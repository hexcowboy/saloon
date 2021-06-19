import re
from collections import deque

from rich import box
from rich.live import Live
from rich.panel import Panel
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.table import Table


class Builder:
    """
    Builds the image from source (requires full source repository)
    You can find the Dockerfile in <project_root>/container/Dockerfile
    """

    def __init__(self, console, docker_client, target_image, context):
        self.console = console
        self.client = docker_client
        self.target_image = target_image
        self.context = context

        self.progress_module = Progress(
            SpinnerColumn(),
            TextColumn("[bright_black]{task.description}"),
            console=self.console,
        )

    def _print_build_banner(self):
        """Tell the console user that the image is being pulled"""
        build_banner = Panel.fit(
            f"This will attempt to build the docker image locally. The output image will be tagged as [blue]{self.target_image}[/blue].",
            title="[bold blue]Building image",
        )
        self.console.print(build_banner)

    def _generate_table(self, header, messages):
        """Generate a table with 5 rows"""
        table = Table(header, box=box.SIMPLE_HEAD, padding=(0, 0))
        table.add_column()

        for message in messages:
            console_width = self.console.width - 4
            shortened_message = message[0:console_width]
            table.add_row(f"{shortened_message}", style="bright_black")

        return table

    def parse_output(self, generator):
        """Iterates over a docker build generator"""
        tasks = list()
        current_step = next(generator).get("stream")
        step_matcher = re.compile("^Step\ \d+\/\d+\ :.*$")

        with Live(transient=True, refresh_per_second=4) as live:
            for message in generator:
                stream = message.get("stream", None)
                error = message.get("error", None)

                if stream:
                    message = " ".join(stream.split())

                    if step_matcher.match(message):
                        # TODO: Sometimes this bit is a bit choppy with the Live view
                        self.console.success(current_step)
                        current_step = message
                        tasks.clear()

                    else:
                        # Get console width and account for padding
                        tasks.append(message)
                        live.update(self._generate_table(current_step, tasks[-5:]))

                elif error:
                    live.stop()
                    self.console.failure(message["error"])
                    for task in tasks:
                        self.console.print(task, style=None)
                    exit(1)

    def build(self):
        """Builds a Docker image provided a context"""
        self._print_build_banner()

        # Sets the target name, also know as the image tag
        target_name = self.target_image.local_name

        # Tell the API to build an image (returns a generator with log output)
        build = self.client.api.build(path=self.context, tag=target_name, decode=True)

        # Let the parser determine what to print
        self.parse_output(build)

        # If the process hasn't exited, it's likely a success
        self.console.print_status(
            "Successfully built the docker image from [blue]./container/Dockerfile[/blue]"
        )
        self.console.print_status(
            f"You can access the image with Docker CLI as [blue]{target_name}[/blue]"
        )

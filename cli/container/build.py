import re

from rich.live import Live
from rich.panel import Panel
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.text import Text


class Builder:
    """
    Builds the image from source (requires full source repository)
    You can find the Dockerfile in <project_root>/container/Dockerfile
    """

    def __init__(self, console, docker_client, image, context):
        self.console = console
        self.client = docker_client
        self.image = image
        self.context = context

        self.progress_module = Progress(
            SpinnerColumn(),
            TextColumn("[bright_black]{task.description}"),
            console=self.console,
        )

    def _print_build_banner(self):
        """Tell the console user that the image is being pulled"""
        build_banner = Panel.fit(
            f"This will attempt to build the docker image locally. The output image will be tagged as [blue]{self.image}[/blue].",
            title="[bold blue]Building image",
        )
        self.console.print(build_banner)

    def _generate_table(self, header, messages):
        """Generate a text table with 5 rows"""
        table = Text("✔ ", style="bright_black").append(header, style="bold white")

        for message in messages:
            shortened_message = message[0:self.console.width]
            table.append(f"\n{shortened_message}", style="bright_black")

        return table

    def _parse_output(self, generator):
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
                        live.console.print(f"[bold green]✔ [default]" + current_step)
                        current_step = message[:self.console.width-2]
                        tasks.clear()

                    else:
                        tasks.append(message)
                        # Generate a table with the last 5 messages
                        live.update(self._generate_table(current_step, tasks[-5:]))

                elif error:
                    live.stop()
                    live.console.print(f"[bold red]✘ [default]" + message["error"])
                    for task in tasks:
                        self.console.print(task, style=None)
                    exit(1)

    def build(self):
        """Builds a Docker image provided a context"""
        self._print_build_banner()

        # Sets the target name, also know as the image tag
        target_name = str(self.image)

        # Tell the API to build an image (returns a generator with log output)
        build = self.client.api.build(path=self.context, tag=target_name, decode=True)

        # Let the parser determine what to print
        self._parse_output(build)

        # If the process hasn't exited, it's likely a success
        self.console.print_status(
            "Successfully built the docker image from [blue]./container/Dockerfile[/blue]"
        )
        self.console.print_status(
            f"You can access the image with Docker CLI as [blue]{target_name}[/blue]"
        )

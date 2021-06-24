from rich.panel import Panel
from rich.progress import BarColumn, Progress, TextColumn


class Puller:
    """Pull classes will output progress and need to share the console as well as the Docker client"""

    def __init__(self, console, docker_client, image):
        self.console = console
        self.client = docker_client
        self.image = image

        self.progress_module = Progress(
            TextColumn("{task.description}"),
            BarColumn(bar_width=999, complete_style="blue", finished_style="blue"),
            refresh_per_second=4,
            console=self.console,
            expand=True,
        )

    def _print_pull_banner(self):
        """Tell the console user that the image is being pulled"""
        pull_banner = Panel.fit(
            f"The image [blue]{self.image}[default] is being downloaded from Docker Hub. This could take between 2 and 15 minutes depending on your internet connection and machine speed.",
            title="[bold blue]Downloading the Base Image",
        )
        self.console.print(pull_banner)

    def parse_output(self, generator):
        """Iterates over a docker pull generator"""
        with self.progress_module as progress:

            tasks = dict()
            completed_task_counter = 0

            # Add the main task as the first status message
            master_task = next(generator)
            tasks[master_task["id"]] = progress.add_task(
                f"[blue]{master_task['status']}"
            )

            for message in generator:
                status = message.get("status", False)
                layer_id = message.get("id", False)
                description = f"{status} {layer_id}"

                # TODO: Python 3.10 is not released yet, but this function should use the match-case syntax instead of if-statements when it is released
                if "Pulling fs layer" in status:
                    tasks[layer_id] = progress.add_task(description)

                elif any(
                    substring in status for substring in ["Downloading", "Extracting"]
                ):
                    current = message["progressDetail"]["current"]
                    total = message["progressDetail"]["total"]
                    progress.update(
                        tasks[layer_id],
                        total=total,
                        completed=current,
                        description=description,
                    )

                elif "Download complete" in status:
                    progress.update(
                        tasks[layer_id], total=1, completed=1, description=description
                    )

                elif "Pull complete" in status:
                    completed_task_counter += 1
                    progress.remove_task(tasks[layer_id])

                elif layer_id in tasks:
                    progress.update(tasks[layer_id], description=description)

                elif "Digest" in status:
                    progress.update(tasks[master_task["id"]], description=status)

                # Run this every iteration regardless of the status
                progress.update(
                    tasks[master_task["id"]],
                    total=len(tasks) - 1,
                    completed=completed_task_counter,
                )

    def pull(self):
        """Pull the specified image from Docker Hub"""
        self._print_pull_banner()

        # Tell the API to pull an image (returns a generator with log output)
        image = self.client.api.pull(repr(self.image), stream=True, decode=True)

        # Let the parser determine what to print
        self.parse_output(image)

        # Tag the image locally
        self.client.api.tag(str(self.image), self.image.local_name)

        # If the process hasn't exited, it's likely a success
        self.console.print_status(
            f"Saloon has been installed and tagged as [blue]{self.image}[/blue]"
        )

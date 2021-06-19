"""DEPRECATED
This file is only here as a reference until the build process is moved into the container module
"""
import docker
from rich.panel import Panel
from rich.progress import BarColumn, Progress, SpinnerColumn


def build(image, image_tag):
    """Builds the image from source (requires full repository)
    You can find the Dockerfile in <project_root>/container/Dockerfile
    """
    dev_mode_banner = Panel.fit(
        "This will attempt to build the docker image locally. If you didn't mean to run saloon in development mode, try installing with [bold]pipx install saloon[/bold] and running it with [bold]saloon[/bold].",
        title="[bold blue]You are running Saloon in development mode",
    )
    console.print(dev_mode_banner)

    # Starts building the image and logging output
    full_image = f"{image}:{image_tag}"
    client = docker.APIClient()
    with console.status(
        "Building the docker image from [blue]./container/Dockerfile[default]"
    ):
        image = client.build(path="container/", tag=full_image, decode=True)
        parse_output(image)

    # If the process hasn't exited, it's a success
    print_status(
        "Successfully built the docker image from [blue]./container/Dockerfile[default]"
    )
    print_status(
        f"You can access the image with Docker CLI as [blue]{full_image}[default]"
    )

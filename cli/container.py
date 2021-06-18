import json
import os
import sys

import docker
import dockerpty
from rich.console import Console
from rich.panel import Panel

# Create a console object
console = Console()

# Create a Docker client
client = docker.from_env()


def print_status(text, color="green"):
    """Prints Saloon docker status in a uniform manner"""
    console.print(f"[bold {color}][+] [default]" + text)


def parse_output(image_generator):
    """Takes a generator and iterates over it to expose plain text on-the-fly"""
    for chunk in image_generator:
        # The generator can be streamed and checked for errors
        if "stream" in chunk:
            for line in chunk["stream"].splitlines():
                print(line)
        elif "error" in chunk:
            print_status("There was an error with Docker", color="red")
            sys.exit(chunk["error"])
        else:
            print(chunk)


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


def pull(image, image_tag):
    """Pull the specified image from Docker Hub"""
    full_image = f"{image}:{image_tag}"
    try:
        client.images.get(full_image)
    except docker.errors.NotFound:
        build_banner = Panel.fit(
            f"The image [blue]{image}:{image_tag}[default] is being downloaded from Docker Hub. This could take between 2 and 15 minutes depending on your internet speed.",
            title="[bold blue]Installing Saloon",
        )
        console.print(build_banner)

        # Pulls the image from Docker Hub
        with console.status(
            f"Pulling the image [blue]{full_image}[default] from Docker Hub (2-10 minutes)"
        ):
            image = client.images.pull(full_image)

        # If there are no errors, it's a success
        print_status(
            f"Saloon has been installed and tagged as [blue]{full_image}[default]"
        )


def run(image, image_tag, *args):
    """Runs the image as a container with specified tag"""

    # Check if the image is already pulled
    pull(image, image_tag)

    # Run the container
    sub_command = " ".join(*args) if args else None

    container = client.containers.create(
        image=f"{image}:{image_tag}",
        command=sub_command,
        stdin_open=True,
        tty=True,
    )

    dockerpty.start(client.api, container.id)

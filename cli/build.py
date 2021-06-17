import json
import os
import sys

import docker
from rich.console import Console
from rich.panel import Panel

# Create rich consoles
console = Console()


def print_status(text, color="green"):
    console.print(f"[bold {color}][+] [default]" + text)


def parse_output(image_generator):
    pass


def build():
    """This will build the image from the Dockerfile
    You can find the Dockerfile in <project_root>/container/Dockerfile
    """
    dev_mode_banner = Panel(
        "This will attempt to build the docker image locally. If you didn't mean to run saloon in development mode, try installing with [bold]pipx install saloon[/bold] and running it with [bold]saloon[/bold].",
        title="[bold blue]You are running Saloon in development mode",
    )
    console.print(dev_mode_banner)

    client = docker.APIClient()
    with console.status("Building the docker image from ./container"):
        # The build() function returns a generator with Docker output
        image = client.build(path="container/", rm=True, nocache=True, decode=True)
        for chunk in image:
            # The generator can be streamed and checked for errors
            if "stream" in chunk:
                for line in chunk["stream"].splitlines():
                    print(line)
            elif "error" in chunk:
                print_status(
                    "Could not build the docker image from ./container/Dockerfile",
                    color="red",
                )
                sys.exit(chunk["error"])
        # If the generator finishes without errors, print a success
        print_status("Successfully built the docker image from ./container")

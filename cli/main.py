import click
import docker
from rich.traceback import install

from cli.container.image import DockerImage
from cli.container.run import Runner
from cli.util.console import Console

# The docker tag used to build/pull from
image = DockerImage("hexcowboy/saloon", "dev", local_name="saloon")

# TODO: Add an argument for opening ports
@click.command(context_settings=dict(help_option_names=["-h", "--help"]))
@click.argument("sub_command", nargs=-1)
def cli(sub_command):
    # Create a Rich console
    install()
    console = Console()

    # Create a Docker client from the environment
    client = docker.from_env()

    # Test that Docker is running
    try:
        client.info()
    except:
        console.print("Docker is not running.")
        console.print(
            "You can download Docker here: https://docs.docker.com/engine/install/"
        )
        exit(1)
        # TODO: prompt to see if user wants to try automatically download Docker

    # TODO: check to see if an xserver is installed

    # Run the container
    runner = Runner(console, client, image)
    runner.run(sub_command)

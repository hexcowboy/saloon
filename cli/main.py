import json
import os
import sys

import click
from rich.traceback import install

# The docker tag used to build/pull from
image = "hexcowboy/saloon"
image_tag = "latest"


@click.command(context_settings=dict(help_option_names=["-h", "--help"]))
@click.argument("sub_command", nargs=-1)
def cli(sub_command):
    from .container import run

    run(image, image_tag, sub_command)


if __name__ == "__main__":
    """Running from command line will enter dev mode"""
    # This makes rich the default error handler
    install()

    # Runs the image builder and tags it
    from container import build, run

    image = "hexcowboy/saloon"
    image_tag = "dev"
    dev_image = build(image, image_tag)
    run(image, image_tag, sys.argv[1:])

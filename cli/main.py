import json
import os
import sys

import click
import docker
from build import build
from rich.traceback import install

# This makes rich the default error handler
install()

# The docker tag used to build/pull from
image_tag = "hexcowboy/saloon:latest"


@click.command(context_settings=dict(help_option_names=["-h", "--help"]))
def cli():
    print("Running")


def run_container(image):
    client = docker.from_env()
    client.containers.run(image)


if __name__ == "__main__":
    """Running from command line will enter dev mode"""
    dev_image = build()
    print(dev_image)
    # run_container(dev_image)

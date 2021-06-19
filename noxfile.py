import docker
import nox

from cli.container.build import Builder
from cli.container.image import DockerImage
from cli.util.console import Console


@nox.session
def format(session):
    session.install("isort", "black")
    session.run("isort", "--profile", "black", ".")
    session.run("black", ".")


@nox.session
def build(session):
    console = Console()
    client = docker.from_env()
    image = DockerImage("hexcowboy/latest", "dev", "cowboy")
    builder = Builder(console, client, image, "./container")
    builder.build()

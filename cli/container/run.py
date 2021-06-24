import docker
import dockerpty
from click import confirm, style
from rich.prompt import Confirm

from .pull import Puller


class Runner:
    """Run functions share console, client, and image"""

    def __init__(self, console, docker_client, image):
        self.console = console
        self.client = docker_client
        self.image = image

    def prompt_for_pull(self):
        """Prompt the user to pull a new image"""
        styled_image_name = style(f"{self.image}", fg="blue")
        wants_to_pull = confirm(
            f"Do you want to pull {styled_image_name} from Docker Hub?", default=True
        )
        if wants_to_pull:
            puller = Puller(self.console, self.client, self.image)
            puller.pull()
        else:
            self.console.print_status(
                f"The image {self.image} is required to proceed.", color="red"
            )
            exit(1)

    def has_local_image(self):
        """Checks to see if the image is already installed locally"""
        try:
            self.client.images.get(str(self.image))
            return True
        except docker.errors.NotFound:
            return False

    def run(self, *args):
        """Runs the image as a container with specified tag"""

        # Check if the image is already pulled, otherwise pull it
        if not self.has_local_image():
            self.prompt_for_pull()

        # Combine all the *args into a single string
        sub_command = " ".join(*args) if args else None

        # Start the container with predefined options
        container = self.client.containers.create(
            image=f"{self.image}",
            command=sub_command,
            stdin_open=True,
            tty=True,
            # TODO: Figure out host network mode
            # network_mode="host", # Works on Linux only
            # publish_all_ports=True,
            # https://blog.oddbit.com/post/2014-08-11-four-ways-to-connect-a-docker/
        )

        # Enter the interactive TTY (this package handles all PTY stuff)
        dockerpty.start(self.client.api, container.id)

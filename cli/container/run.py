import docker
import re
import iso8601
try:
    import dockerpty
except ModuleNotFoundError:
    exit("Your operating system is not supported.")
from datetime import datetime, timedelta, timezone
from click import confirm, style

from .pull import Puller


class Runner:
    """Run functions share console, client, and image"""

    def __init__(self, console, docker_client, image):
        self.console = console
        self.client = docker_client
        self.image = image
        self.local_image = self.image.get_object(docker_client)

    def prompt_for_pull(self, required_to_proceed=False):
        """Prompt the user to pull a new image"""
        styled_image_name = style(f"{self.image}", fg="blue")
        wants_to_pull = confirm(
            f"Do you want to pull {styled_image_name} from Docker Hub?", default=True
        )
        if wants_to_pull:
            puller = Puller(self.console, self.client, self.image)
            puller.pull()
        elif required_to_proceed:
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

    def check_for_updates(self):
        """Checks for updates from the Docker Hub"""
        with self.console.status("Checkng for updates"):
            remote_image = self.client.images.get_registry_data(str(self.image))
            sha256_regex = re.compile('[A-Fa-f0-9]{64}')
            local_digest = sha256_regex.findall(self.local_image.attrs["RepoDigests"][0].split('@')[1])
            remote_digest = sha256_regex.findall(remote_image.attrs["Descriptor"]["digest"])
            if local_digest != remote_digest:
                return True
        return False

    def check_stale_image(self):
        """Checks to see if the image is over 2 weeks old"""
        last_tag_time = iso8601.parse_date(self.local_image.attrs['Metadata']['LastTagTime'])
        days_since_last_tag = datetime.now(timezone.utc) - last_tag_time

        if days_since_last_tag > timedelta(days=14):
            self.console.print(f"Days since last checked for updates: [blue]{days_since_last_tag.days}[/blue]")

            # Reset the last tag time to reset the staleness
            self.local_image.tag(str(self.image))

            return self.check_for_updates()

        return False

    def run(self, force_update=False, *args):
        """Runs the image as a container with specified tag"""

        # Check if the image is already pulled, otherwise pull it
        if not self.has_local_image():
            self.prompt_for_pull(required_to_proceed=True)

        # Check to see if there are any updates
        if self.check_stale_image() or force_update:
            self.prompt_for_pull()

        # Combine all the *args into a single string
        sub_command = " ".join(*args) if args else None

        # Start the container with predefined options
        container = self.client.containers.create(
            image=f"{self.image}",
            command=sub_command,

            auto_remove=True,

            stdin_open=True,
            tty=True,

            # TODO: Figure out host network mode for Docker Desktop
            # https://blog.oddbit.com/post/2014-08-11-four-ways-to-connect-a-docker/
            network_mode="host", # Works on Linux only
            hostname="saloon",
            extra_hosts= {"host.docker.internal": "host-gateway",}
        )

        # Enter the interactive TTY (this package handles all PTY stuff)
        dockerpty.start(self.client.api, container.id)

import docker
import dockerpty

client = docker.APIClient(base_url="unix://var/run/docker.sock")
container = client.create_container(
    image="busybox:latest",
    stdin_open=True,
    tty=True,
    command="/bin/sh",
)

dockerpty.start(client, container)

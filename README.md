# Jackbox
**⚠️ This project is in it's very early stages and shouldn't be used yet**

Fully featured Docker container with hacking tools. Jackbox intends to be a lightweight replacement to pentesting VMs like Parrot and Kali.

## 🚀 Installation

Clone the repository
```bash
git clone https://github.com/hexcowboy/jackbox.git && cd jackbox
```

Build the docker image
```bash
make
```

## 🧨 Running Jackbox

Once the container image is built, you can attach to jackbox with Docker
```bash
# The -it flag is required to have an interactive TTY
docker run -it jackbox
```

By default docker containers are ephemeral. If you wish to has persistent storage and save files between sessions, use a docker volume
```bash
# The path on the left of the : is the docker volume name
# The path on the right is the folder on the docker container
docker run -it -v jackbox:/root jackbox
```

You can see where docker has put this mount by inspecting the
volume
```bash
docker volume inspect jackbox
[
    {
        "CreatedAt": "2021-06-03T19:20:54Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/jackbox/_data",
        "Name": "jackbox",
        "Options": null,
        "Scope": "local"
    }
]
```

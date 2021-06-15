# Saloon

Saloon is a hacking environment that is rapidly available. Compared to the estimated 30+ minute setup with Kali or Parrot, Saloon takes roughly 2-5 minutes to install.

## 🚀 Installation

### Install from Dockerhub (fastest)

```bash
# Pull the image from docker hub
docker pull hexcowboy/saloon
# Tag the image so it can be run as just "saloon"
docker image tag hexcowboy/saloon saloon
```

### Build from source (configurable)

Clone the repository
```bash
# Clone the repository
git clone https://github.com/hexcowboy/saloon.git && cd saloon
# Build the docker container
make
```

## 🧨 Running Saloon

Once the container image is built, you can attach to Saloon with Docker
```bash
# The -it flag is required to have an interactive TTY
docker run -it saloon

# Run a command and then exit
docker run -it saloon smbclient -L 127.0.0.1
```

### Saving files between runs

```bash
# The path on the left of the : is the docker volume name
# The path on the right is the folder on the docker container
docker run -it -v saloon-root:/root saloon

# Mount multiple directories like so
docker run -it \
  -v saloon-root:/root \
  -v saloon-opt:/opt \
  -v saloon-etc:/etc \
  -v saloon-var:/var \
  -v saloon-usr:/usr \
  saloon

# Find the location of your mount like so
docker volume inspect <mount-name>
```

### Running GUI applications

The Docker container is compatible with X11. You just need to set your local XServer to listen on 127.0.0.1.

#### macOS Example

1. Install XQuartz
```bash
brew install --cask xquartz
```
2. Enable `XQuartz` > `Preferences` > `Security` > `Allow connections from network clients`
3. Add your local IP as an xhost
```bash
xhost + 127.0.0.1
```

#### Other Examples

Coming soon. Accepting pull requests for Windows and Linux examples.

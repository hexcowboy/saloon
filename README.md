# Jackbox

Jackbox provides offensive security tools without having to build and configure a virtuaal machine.

## 🚀 Installation

### Install from Dockerhub (fastest)

```bash
# Pull the image from docker hub
docker pull hexcowboy/jackbox
# Tag the image so it can be run as just "jackbox"
docker image tag hexcowboy/jackbox jackbox
```

### Build from source (configurable)

Clone the repository
```bash
# Clone the repository
git clone https://github.com/hexcowboy/jackbox.git && cd jackbox
# Build the docker container
make
```

## 🧨 Running Jackbox

Once the container image is built, you can attach to jackbox with Docker
```bash
# The -it flag is required to have an interactive TTY
docker run -it jackbox

# Run a command and then exit
docker run -it jackbox smbclient -L 127.0.0.1
```

### Saving files between runs

```bash
# The path on the left of the : is the docker volume name
# The path on the right is the folder on the docker container
docker run -it -v jackbox-root:/root jackbox

# Mount multiple directories like so
docker run -it \
  -v jackbox-root:/root \
  -v jackbox-opt:/opt \
  -v jackbox-etc:/etc \
  -v jackbox-var:/var \
  -v jackbox-usr:/usr \
  jackbox

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

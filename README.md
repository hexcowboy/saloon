# Saloon

Saloon is a hacking environment that is rapidly available from Docker Hub. Compared to the estimated 30 minute setup with Kali or Parrot, Saloon takes roughly 5 minutes to install and 1 second to boot.

## 🚀 Installation

### Install from PyPI

```bash
pipx install saloon
```

## 🧨 Running Saloon

Once the container image is built, you can attach to Saloon with Docker
```bash
# Get a shell
saloon

# Run a command and then exit
saloon -- nmap -p80 -sC -sV scanme.nmap.org
```

### Saving files between runs

> *Persistence is not available yet.*

### Networking

> *Networking is not available, but soon you will be able to do things like set up a netcat listener an accept incoming connections or set up a Burp Suite proxy.*

### Running GUI applications

> *Note: Not available on Linux yet*

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

> *Coming soon. Accepting pull requests for Windows and Linux examples.*

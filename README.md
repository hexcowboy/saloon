# Saloon

Saloon is a hacking environment that is rapidly available in the Docker cloud. Compared to the estimated 30 minute setup with Kali or Parrot, Saloon takes roughly 5 minutes to install.

## 🚀 Installation

### Requirements

* Windows (with WSL2), macOS, Linux
* Docker
* Python 3

### Install from PyPI

```bash
pipx install saloon
# or
pip3 install saloon
```

## 🧨 Running Saloon

Once the container image is pulled, you can start running commands
```bash
# Get an interactive shell
saloon

# Run a command and then exit
saloon -- nmap -p80 -sC -sV scanme.nmap.org
```

### Networking

> *Networking is not available\*, but soon you will be able to do things like set up a netcat listener an accept incoming connections or set up a Burp Suite proxy.*

<small>* exception: Linux hosts can interact with saloon from the host interface (127.0.0.1)</small>

### Running GUI applications

The Docker container is compatible with X11. You just need to set your local XServer to listen on 127.0.0.1.

> *⚠️ All of the following setups disable access control on your X Server. Make sure your X Server cannot be accessed by any untrusted networks.*

<details>
  <summary>macOS Setup</summary>

  1. Install XQuartz
  ```bash
  brew install --cask xquartz
  ```
  2. Enable `XQuartz` > `Preferences` > `Security` > `Allow connections from network clients`
  3. Add your local IP as an xhost
  ```bash
  xhost + 127.0.0.1
  ```
  4. Test a GUI application
  ```bash
  saloon -- wireshark
  ```

</details>

<details>
  <summary>Windows Setup</summary>

  1. Install VcSrv
  ```powershell
  choco install -y vcxsrv
  ```
  2. Launch XLaunch from the start menu
  3. Accept all default settings, **checking** "Disable access control"
  4. If prompted, only allow access on Private networks
  5. Test a GUI application
  ```bash
  saloon -- wireshark
  ```

</details>

<details>
  <summary>Linux Setup</summary>

  Linux desktops usually already come with an X Server installed.

  1. Disable access control
  ```bash
  xhost +
  ```
  2. Test a GUI application
  ```bash
  saloon -- wireshark
  ```

</details>

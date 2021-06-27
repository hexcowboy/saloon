# Saloon

Saloon is a hacking environment that is rapidly available in the Docker cloud. Compared to the estimated 30 minute setup with Kali or Parrot, Saloon takes roughly 5 minutes to install.

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

The Docker container is compatible with X11. You just need to set your local XServer to listen on 127.0.0.1.

> *⚠️ All of the following setups disable access control on your X Server. Disabling access control allows outside connections to connect to your X Server. This is insecure if you allow network connections from the internet or from an untrusted network. Make sure your are on a secure network, like your home network, if you decide to use these instructions.*

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

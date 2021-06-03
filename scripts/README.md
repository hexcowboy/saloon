# Build Scripts

This folder contains bash scripts for instructions on building Jackbox.
In theory, it would be much better to have these build steps be
Dockerfiles. However, Docker does not support nesting or importing
external Dockerfiles, so this workaround is needed for now to keep the
project structured and organized.

## Making a custom script

* [Making a binary script](https://github.com/hexcowboy/jackbox/tree/main/scripts#making-a-binary-script)
* [Making a package script](https://github.com/hexcowboy/jackbox/tree/main/scripts#making-a-package-script)
* [Requesting a script](https://github.com/hexcowboy/jackbox/tree/main/scripts#requesting-a-script)
* [Creating a pull request](https://github.com/hexcowboy/jackbox/tree/main/scripts#creating-a-pull-request)

The directory structure is split into different subfolders for different
stages of building. The structure is as follows:

```bash
scripts
├── 00-start.sh          # Entrypoint that recursively calls all other install scripts
├── 10-binaries          # Installs binary tools like programming languages
│   ├── install-rust.sh
│   └── ...
└── 20-packages          # Installs packages like command-line tools and services
    ├── install-ffuf.sh
    └── ...
```

### Making a binary script

Each binary install script should act "dumb" and make sure to install
all dependencies regardless of if they might already be installed. At
the top of each binary script, dependencies can be checked for and
installed with the following snippet:

```bash
#!/bin/bash
DEPS="wget git gcc"

# Install dependencies
for dependency in $DEPS; do
    apt-get update && apt-get install -y $dependency
done
```

The instructions for installing a binary script should be taken from the
binary's official website or documentation. For example, the Go install
script looks like the following:

```bash
# Download the tarball
wget -qL $GO_URL -O /tmp/go.tar.gz

# Unzip the tarball
rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go.tar.gz

# Add Go to the path
echo "export PATH=\$PATH:/usr/local/go/bin" >> $HOME/.bashrc
```

The build steps are taken directly from https://golang.org/doc/install.

### Making a package script

The best way to install a package is through a package manager.
This allows the user to simply upgrade all packages throught a
command like `apt update`. Sometimes package managers don't have
a package in their repository, so it needs to be installed
another way.

The order of preferred installation is as follows:
1. Install from the apt repository with `apt install`
2. Install from a third party package manager like `go get` or `cargo install`
3. Build and installed from source

#### Managing requirements

Unlike binary scripts which install dependencies, packages must
check for requirments *and **exit** if the requirements are not met*.

This snippet can check for requirements and should be placed at
the top of your script:

```bash
#!/bin/bash
REQS="git go curl"

# Check requirements
for requirement in $REQS; do
    if ! [ -x "$(command -v $requirement)" ]; then
        echo "$requirement is required to install <your package name here>"
        exit 1
    fi
done
```

*Requirements are not necessary if using `apt` to install the package*

#### Examples

Example for smbclient which resides in the apt repository:

```bash
#!/bin/bash
apt-get install -y smbclient
```

Example for [ffuf](https://github.com/hexcowboy/jackbox/blob/main/scripts/20-packages/install-ffuf.sh) which is installed from a third party package manager:
```bash
# Install ffuf
go get -u github.com/ffuf/ffuf
```

Example for [starship](https://github.com/hexcowboy/jackbox/blob/main/scripts/20-packages/install-starship.sh) which is built from source:
```bash
# Install from bash script
# https://starship.rs/guide/#%F0%9F%9A%80-installation
curl -fsSL https://starship.rs/install.sh | bash -s -- --yes

# Add starship to bashrc
echo "" >> $HOME/.bashrc
echo "Use starship prompt" >> $HOME/.bashrc
echo 'eval "$(starship init bash)"' >> $HOME/.bashrc
```

### Requesting a script

Not everyone is able to create a script. If you would like
to politely ask for a script to be added, you may 
[open an issue](https://github.com/hexcowboy/jackbox/issues)
explaining what you want added. Your request will be considered
by the maintainers, but not all requests will be granted.
Jackbox aims to only include necessary tools and prevent the
image from becoming too large.

### Creating a pull request

You can create a pull request with a new script, but your
script may or may not be merged for the same reasons
as mentioned above. Please try to be descriptive in your
PR as to why it would be a good feature to add.

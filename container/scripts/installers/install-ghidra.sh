#!/usr/bin/env sh
# https://github.com/NationalSecurityAgency/ghidra#install

DEPS="openjdk-11-jdk jq unzip curl wget"
URL="https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest"
DEST="/opt/ghidra"
BINARY="/usr/local/bin/ghidra"

# Install dependencies
apt-get install -y $DEPS

# Use the GitHub API to find latest release
RELEASE=$(curl $URL | jq -r '.assets[].browser_download_url')

# Download the release
wget $RELEASE -O /tmp/ghidra.zip

# Extract the Zip file
# uses this weird workaround to rename the folder
# https://superuser.com/questions/518347/equivalent-to-tars-strip-components-1-in-unzip
unzip -d "$DEST" "/tmp/ghidra.zip" && f=("$DEST"/*) && mv "$DEST"/*/* "$DEST" && rmdir "${f[@]}"

# Create a binary
cat << EOF > $BINARY
#!/usr/bin/env sh
echo "Starting Ghidra"
/opt/ghidra/support/launch.sh \
  fg \
  Ghidra \
  "" \
  "" \
  ghidra.GhidraRun \
  "\$@" >/dev/null 2>&1 &
EOF

# Make the binary executable
chmod u+x $BINARY

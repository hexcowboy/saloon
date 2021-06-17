#!/usr/bin/env sh
# https://bloodhound.readthedocs.io/en/latest/installation/linux.html

DEPS="wget unzip curl"
DEST="/opt/bloodhound"
BLOODHOUND_RELEASE="3.0.3"
BINARY="/usr/local/bin/bloodhound"

apt-get install -y $DEPS

# Find the latest release of BloodHound
URL="https://api.github.com/repos/BloodHoundAD/BloodHound/releases/latest"

apt-get install -y $DEPS

# Find the latest release from GitHub API
# RELEASE="$(curl $URL | jq -r '.assets[].browser_download_url' | grep linux-x64)"

# Download the release
# wget $RELEASE -O /tmp/bloodhound.zip

# !! Workaround !!
# Latest version is segfaulting, so version 3.0.3 is used for now
# https://github.com/BloodHoundAD/BloodHound/issues/465
wget "https://github.com/BloodHoundAD/BloodHound/releases/download/$BLOODHOUND_RELEASE/BloodHound-linux-x64.zip" -O /tmp/bloodhound.zip

# Unzip the release
unzip -d "$DEST" "/tmp/bloodhound.zip" && f=("$DEST"/*) && mv "$DEST"/*/* "$DEST" && rmdir "${f[@]}"

# Create a binary that runs both neo4j and bloodhound
cat << EOF > $BINARY
#!/usr/bin/env sh
echo "\e[31mThe default credentials on this system are: \e[32mneo4j:saloon\e[0m"

echo ""
echo "Starting neo4j database"
if ! service neo4j status | grep running ; then
  service neo4j start
fi

echo ""
echo "Waiting for neo4j to connect..."
while true; do
  if curl -s -I http://127.0.0.1:7474 | grep -q "200 OK"; then
    break;
  fi
done

echo ""
echo "Starting BloodHound"
/opt/bloodhound/BloodHound \
  --no-sandbox \
  "\$@" \
  >/dev/null 2>&1 &
EOF

# Make the binary executable
chmod u+x $BINARY

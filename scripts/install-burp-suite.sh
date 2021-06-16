#!/usr/bin/env sh
# https://github.com/hexcowboy/docker-burp-suite-community/blob/master/Dockerfile

DEPS="curl default-jre openssl ca-certificates libxext6 libxrender1 libxtst6"
URL="https://portswigger.net/burp/releases/download"
JAR_FILE="/usr/local/BurpSuiteCommunity/burpsuite_community.jar"
BINARY="/usr/local/bin/burpsuite"

apt-get install -y $DEPS

# Download the Burpsuite jar
mkdir -p $(dirname $JAR_FILE)
curl -fsSL $URL -o $JAR_FILE

# Create a binary
cat << EOF > $BINARY
#!/usr/bin/env sh
echo "Starting Burp Suite Community"
PROJECT_CONFIG="/etc/burpsuite/project_options.json"
USER_CONFIG="/etc/burpsuite/user_options.json"
java -jar "$JAR_FILE" \
  --config-file="\$PROJECT_CONFIG" \
  --user-config-file="\$USER_CONFIG" \
  "\$@"
EOF

# Make the binary executable
chmod u+x $BINARY

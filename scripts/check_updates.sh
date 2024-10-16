#!/bin/sh

MODPACK_URL="https://www.curseforge.com/minecraft/modpacks/uvserver/files/latest"
CURRENT_VERSION=$(cat /data/modpack_version.txt)

NEW_VERSION=$(curl -s "$MODPACK_URL" | grep -oP '(?<=version">)[^<]+')

if [ "$CURRENT_VERSION" != "$NEW_VERSION" ]; then
  echo "New version detected: $NEW_VERSION"
  echo "$NEW_VERSION" > /data/modpack_version.txt

  # Broadcast a message to players about downtime
  docker exec -it minecraft rcon-cli "say Server will restart for updates in 1 minute!"
  sleep 60

  # Restart Minecraft server
  docker-compose restart minecraft
fi

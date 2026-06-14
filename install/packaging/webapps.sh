#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing default web apps (Q19 bundle)"

# Per Q19: ship 9 default web-apps with icons bundled from this repo,
# plus 3 more (Google Calendar, Gmail, Claude) added in iter 20b once
# we source their icons. Zoom additionally registers a URL-scheme
# handler so zoommtg:// / zoomus:// invitations open in the web client.
#
# paco-webapp-install overwrites the .desktop file every run (omarchy
# pattern). That's the idempotency story: user-customized webapps
# (created interactively via `paco-webapp-install` with no args) live
# alongside but are never touched here because their names differ.
paco-webapp-install "Google Photos" https://photos.google.com/ "Google Photos.png"
paco-webapp-install "Google Contacts" https://contacts.google.com/ "Google Contacts.png"
paco-webapp-install "Google Messages" https://messages.google.com/web/conversations "Google Messages.png"
paco-webapp-install "Google Maps" https://maps.google.com "Google Maps.png"
paco-webapp-install "ChatGPT" https://chatgpt.com/ ChatGPT.png
paco-webapp-install "YouTube" https://youtube.com/ YouTube.png
paco-webapp-install "GitHub" https://github.com/ GitHub.png
paco-webapp-install "Discord" https://discord.com/channels/@me Discord.png
paco-webapp-install "Zoom" https://app.zoom.us/wc/home Zoom.png \
  "paco-webapp-handler-zoom %u" \
  "x-scheme-handler/zoommtg;x-scheme-handler/zoomus"

echo "Default web apps installed (Super+Space → app name)."

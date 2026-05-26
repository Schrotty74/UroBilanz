#!/bin/zsh
cd "$(dirname "$0")"

echo "UroBilanz startet..."
echo "Adresse: http://localhost:4174"
echo "Zum Beenden dieses Fenster aktivieren und Ctrl+C druecken."

(sleep 1; open "http://localhost:4174/index.html?start=$(date +%s)") &
python3 -m http.server 4174

#!/bin/zsh
cd "$(dirname "$0")"

port=4174
web_channel="${UROBILANZ_WEB_CHANNEL:-final}"

if [ "$web_channel" = "dev" ]; then
  url_path="index.html?channel=dev&start=$(date +%s)"
else
  url_path="index.html?start=$(date +%s)"
fi

port_is_used() {
  /usr/sbin/lsof -iTCP:${1} -sTCP:LISTEN -t >/dev/null 2>&1
}

if port_is_used "${port}"; then
  echo "UroBilanz läuft bereits."
  echo "Adresse: http://localhost:${port}"
  open "http://localhost:${port}/${url_path}"
  exit 0
fi

echo "UroBilanz startet..."
echo "Adresse: http://localhost:${port}"
echo "Zum Beenden dieses Fenster aktivieren und Ctrl+C druecken."

(sleep 0.1; open "http://localhost:${port}/${url_path}") &
python3 -m http.server "${port}" --bind 127.0.0.1

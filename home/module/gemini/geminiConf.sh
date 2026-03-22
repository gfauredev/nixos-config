podman build --tag gemini-sandbox . # TODO Only rebuild if changed
cp --update --verbose ./settings.json ~/.gemini/settings.json &&
  cp --update --verbose ~/.gemini/settings.json ./settings.json
cp --update --verbose ./env.sh ~/.gemini/.env &&
  cp --update --verbose ~/.gemini/.env ./env.sh
cp --update --verbose ./GEMINI.md ~/.gemini/GEMINI.md &&
  cp --update --verbose ~/.gemini/GEMINI.md ./GEMINI.md

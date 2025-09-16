#!/bin/bash

# Function to get Vercel token path based on OS
get_vercel_token_path() {
  case "$(uname -s)" in
  Linux*) echo "$HOME/.local/share/com.vercel.cli/auth.json" ;;
  Darwin*) echo "$HOME/Library/Application Support/com.vercel.cli/auth.json" ;;
  *) echo "" ;;
  esac
}

VERCEL_AUTH_FILE=$(get_vercel_token_path)

if [ -z "$VERCEL_AUTH_FILE" ] || [ ! -f "$VERCEL_AUTH_FILE" ]; then
  echo "Error: Vercel auth file not found."
  echo "Please ensure you are logged in with 'npx vercel login'."
  exit 1
fi

VERCEL_TOKEN="$(jq .token $VERCEL_AUTH_FILE --raw-output)" \
FB_PROJECT_ID="$(jq '.projects.default' .firebaserc --raw-output)" \
  docker compose up

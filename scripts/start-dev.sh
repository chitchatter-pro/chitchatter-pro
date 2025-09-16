#!/bin/bash
VERCEL_TOKEN="$(jq .token ~/.local/share/com.vercel.cli/auth.json --raw-output)" \
FB_PROJECT_ID="$(jq '.projects.default' .firebaserc --raw-output)" \
  docker compose up

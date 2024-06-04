#!/bin/bash
set -e
cd /app

if [ -f .env ]; then
  set -o allexport
  source .env
  set +o allexport
fi

if [ "$RUN_SETUP" = true ]; then
  bash /home/project/setup_deploy.sh
  echo '' > /home/project/setup_deploy.sh
fi

if [ "$RAILS_ENV" = "production" ] || [ "$RAILS_ENV" = "staging" ]; then
  rails assets:precompile
fi

exec $@

#!/bin/bash

export AWS_ACCESS_KEY_ID=DUMMY_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=DUMMY_SECRET_KEY

# NOTE: This is used for local development:
# https://github.com/jagregory/cognito-local

aws cognito-idp create-user-pool \
  --pool-name chitchatter-pro \
  --endpoint-url http://localhost:9229 \
  --region us-east-1

# TODO: The User Pool ID from the output of this script needs to be used to
# configure the application, likely as an environment variable.

# TODO: A JWT validation middleware needs to be implemented in the backend to
# protect API endpoints. See `docs/server-implementation-plan.md` for details.

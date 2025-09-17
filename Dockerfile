# NOTE: To make this production-ready, consider the alternative approach here:
# https://github.com/chitchatter-pro/chitchatter-pro/pull/11#discussion_r2350519256
FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
COPY scripts scripts

RUN npm install

COPY . .

RUN npm run build

CMD ["npm", "run", "db:migrate"]

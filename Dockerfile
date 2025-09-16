FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
COPY scripts scripts

RUN npm install

COPY . .

RUN npm run build

CMD ["npm", "run", "db:migrate"]

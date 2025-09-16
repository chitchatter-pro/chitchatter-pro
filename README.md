# Chitchatter Pro

This repository contains the source code for Chitchatter Pro.

## Development Prerequisites

This project requires a \*NIX-based system for development (e.g., Linux, macOS). Windows users must use [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install).

Clone and install the project:

```bash
git clone git@github.com:chitchatter-pro/chitchatter-pro.git
npm ci
```

Ensure you have the following installed and set up:

- [Docker](https://www.docker.com/get-started/)
- [jq](https://jqlang.org/download/)

Local development requires a [Vercel](https://vercel.com/) account. Create one and run:

```bash
npx vercel login
```

## Running the Application

To run the application in development mode, run the following command at the root of the project:

```bash
npm run start:dev
```

The app will be available at `http://localhost:3000`. To stop the application, run:

```bash
npm run stop:dev
```

## Development Environment

This project uses Docker for development. There are two Docker-based stacks available:

### 1. Development Stack

The development stack is defined in `docker-compose.yml`. It is configured for day-to-day development and includes data persistence for the database.

To start the development environment, run:

```bash
docker compose up
```

This will start all the services defined in `docker-compose.yml`, and the database data will be stored in a Docker volume named `chitchatter-pro-db-data`.

The front-end code is located in the `ui` directory. It is a Vite-based React application.

### 2. Validation Stack

The validation stack is an ephemeral environment used for running tests and validating database migrations. It is defined by a combination of `docker-compose.yml` and `docker-compose.validation.yml`.

The `docker-compose.validation.yml` file overrides the `db` service to disable data persistence, ensuring a clean database for each validation run.

To run the database migration validation, use the following `npm` script:

```bash
npm run validate-migrations
```

This script uses the validation stack to build the services, run the migrations against a temporary database, and then tears down the environment.

## Development URLs

- Admin UI: <http://localhost:3000/>
- API root: <http://localhost:3000/api/>
  - API health check: <http://localhost:3000/api/health>
- Firebase emulator: <http://localhost:4000/database>

## Database Migrations

Database migrations are managed with Prisma. The validation script (`scripts/validate-migrations.sh`) is designed to ensure that migrations are self-consistent and can be run on a clean database.

### Managing Migrations

For day-to-day development, you will need to create and apply database migrations as you make changes to the data model.

#### Creating Migrations

1. Make sure your development environment is running:

   ```bash
   docker compose up
   ```

2. Modify the `server/prisma/schema.prisma` file to reflect your desired schema changes.

3. Run the following command to generate a new migration file:

   ```bash
   npm run db:migrate:create -- --name your-migration-name
   ```

   Replace `your-migration-name` with a descriptive name for your migration. This will create a new migration file in the `server/prisma/migrations` directory.

#### Applying Migrations

When you start the development environment with `docker compose up`, the `server` service runs a command by default that applies any pending migrations.

If you pull down new changes from the repository that include new migrations, you can apply them to your running development database by running:

```bash
npm run db:migrate:apply
```

## Deployment

### Prerequisites

Production deployments require authentication with cloud providers.

#### Firebase

Create an account and project in Firebase and then run:

```bash
npx firebase login
```

Once successfully logged in, create a new Firebase project and run:

```bash
npx firebase init
```

In the interactive setup, select "Realtime Database" and then all of the default options after that.

### Performing Deployments

To deploy the application, run the following command:

```bash
npm run deploy
```

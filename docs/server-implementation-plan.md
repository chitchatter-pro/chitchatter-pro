# Chitchatter Pro: Server Implementation Plan

This document outlines the implementation plan for the server-side components of Chitchatter Pro, based on the system architecture defined in `docs/system-architecture.md`.

> [!NOTE]
> The sections in this document should be broken out into individual GitHub issues.

## Phase 1: Pre-MVP AWS Infrastructure Setup

This phase focuses on establishing the foundational AWS infrastructure required for the MVP and subsequent phases. The goal is to have a secure, scalable, and manageable AWS environment from the start. All infrastructure will be managed as code (IaC) using the **AWS Cloud Development Kit (CDK)**, which aligns with the project's TypeScript ecosystem.

### 1. AWS Account and IAM Strategy

- [ ] Define an account strategy (e.g., using a single account for MVP, with plans for a multi-account setup for production and development environments later).
- [ ] Create specific IAM roles for administrators and for CI/CD pipelines to ensure least-privilege access for both human and automated workflows.
- [ ] Set up billing alerts and budgets in AWS Cost Explorer to monitor costs and prevent surprises.

### 2. AWS CDK Setup

- [ ] Initialize a new CDK app in a dedicated `/infrastructure` directory within the project repository (`cdk init app --language typescript`).
- [ ] Bootstrap the CDK environment in the target AWS account and region (`cdk bootstrap`). This creates the necessary resources for the CDK to manage deployments.
- [ ] Structure the CDK app using reusable Constructs to promote modularity and define the core infrastructure in a dedicated Stack.

### 3. Cognito User Pool Deployment (via CDK)

- [ ] Develop a custom CDK Construct to define the Cognito User Pool and its client.
- [ ] Configure the User Pool with the following settings:
  - [ ] Standard attributes for user profiles (e.g., `email`, `name`).
  - [ ] Enable Multi-Factor Authentication (MFA) using TOTP apps for enhanced security.
  - [ ] Define a strong password policy.
  - [ ] Configure email templates for verification messages and invitations.
- [ ] Configure the User Pool Client for the web application (`pro.chitchatter.im`).
  - [ ] Define allowed OAuth flows (e.g., Authorization Code Grant).
  - [ ] Specify callback URLs for local development (`http://localhost:3000`) and production environments.
- [ ] Define and configure a User Pool Domain (e.g., `auth.chitchatter.im`).
- [ ] Deploy the CDK stack to the AWS account (`cdk deploy`).

### 4. Third-Party Services Setup

This covers the initial setup of essential non-AWS services. The goal is to use CLI commands and configuration files where possible to make the process repeatable.

#### a. Turso Database

- [ ] Create the production database and replica locations via the Turso CLI (`turso db create`).
- [ ] Generate a long-lived authentication token for the Vercel environment (`turso db tokens create`).
- [ ] Store the database URL and auth token securely as environment variables in Vercel.
- [ ] Update the database migration script to be environment-aware, allowing it to run against the production database as part of a CI/CD deployment step.

#### b. Cloudflare

- [ ] **DNS:** Manually configure the necessary DNS records in the Cloudflare dashboard. This is typically a one-time setup for the MVP.
- [ ] **TURN Service:** Provision the managed TURN service via the Cloudflare dashboard and retrieve the API credentials.
- [ ] Store the Cloudflare API credentials securely as environment variables in Vercel. The backend will use these to generate short-lived TURN credentials for clients.

#### c. Firebase

- [ ] Create the project in the Firebase console.
- [ ] Enable the Realtime Database.
- [ ] Store the Firebase project configuration (API key, database URL) securely as environment variables in Vercel.
- [ ] Define database security rules in a dedicated file (e.g., `database.rules.json`).
- [ ] Add a script to the `package.json` to deploy these rules using the Firebase CLI (`firebase deploy --only database`), and integrate this into the CI/CD pipeline.

## Phase 2: Minimum Viable Product (MVP)

### 1. Project Setup

- [ ] Initialize a new Node.js project with TypeScript.
- [ ] Configure ESLint and Prettier for code quality.
- [ ] Set up Vercel for deployment.
- [ ] Create a `src/server` directory for the backend source code.
- [ ] Set up a CI/CD pipeline using GitHub Actions.

### 2. Local Infrastructure (Docker)

- [ ] Create a `docker-compose.yml` file to manage local services.
- [ ] Add a local Turso database service (using `libsql/sqld`) to the Docker Compose setup.
- [ ] Add a local Firebase Realtime Database emulator to the Docker Compose setup.
- [ ] Add a local Cloudflare TURN service (using a Coturn image) to the Docker Compose setup.
- [ ] Add a local AWS Cognito emulator (e.g., `cognito-local`) to the Docker Compose setup.
- [ ] Add a local Stripe (or similar) CLI container to the Docker Compose setup for webhook testing.

### 3. API Implementation (Vercel Edge Functions)

- [ ] Create an `api` directory for Vercel Edge Functions.
- [ ] Implement a health check endpoint (`/api/health`).
- [ ] Implement an endpoint to get TURN server credentials (`/api/turn-credentials`).
- [ ] Implement Stripe webhook endpoint for handling subscriptions (`/api/stripe-webhook` or something similar).

### 4. Database Schema (Turso)

- [ ] Design the initial database schema for users, subscriptions, and usage quotas.
- [ ] Create SQL migration scripts for the initial schema.
- [ ] Implement a script to apply migrations to the local Turso database.

### 5. Authentication and Authorization (AWS Cognito)

- [ ] Set up a User Pool in AWS Cognito.
- [ ] Configure the User Pool with the desired authentication flows.
- [ ] Implement a middleware to validate Cognito JWTs in Vercel Edge Functions.

### 6. Real-time Communication (Firebase Realtime Database)

- [ ] Configure a Firebase Realtime Database for Trystero signaling.
- [ ] Implement security rules to restrict access to the database.

### 7. Usage Tracking and Abuse Prevention

- [ ] Implement a system to track TURN credential allocations.
- [ ] Implement a Lambda function to process usage reports and update user quotas in Turso.

### 8. Testing

- [ ] Set up a testing framework (e.g., Vitest).
- [ ] Write unit tests for all API endpoints.
- [ ] Write integration tests for the authentication flow.
- [ ] Write E2E tests for the core user journeys (sign-up, login, creating a room, etc.).

### 8. Deployment Strategy and CI/CD

This section outlines the strategy for building, testing, and deploying the application and its related cloud configurations.

#### a. Environment Strategy

- [ ] **Environments:** Formalize a two-environment strategy:
  - **`staging`**: A production-like environment for testing. Deployed automatically from the `main` branch. Uses its own set of cloud services (Staging Cognito, Turso, Firebase).
  - **`production`**: The live environment for users. Deployed manually from release tags.
- [ ] **Vercel Setup:** Configure two separate Vercel projects for `staging` and `production` to manage distinct domains, environment variables, and deployment schedules.
- [ ] **Infrastructure:** Deploy a separate `staging` instance of the AWS infrastructure using a CDK parameter (`cdk deploy -c env=staging`). Create corresponding `staging` projects/databases in Turso and Firebase.

#### b. Staging CI/CD Pipeline (GitHub Actions)

- [ ] Configure a GitHub Actions workflow that triggers on every push to the `main` branch.
- [ ] **Automated Checks:** The workflow must pass the following checks before deployment:
  - [ ] Linting and static analysis.
  - [ ] Unit and integration tests.
- [ ] **Automated Deployment:** On successful checks, the workflow will automatically:
  - [ ] Deploy the application to Vercel's `staging` project.
  - [ ] Run database migrations against the `staging` Turso database.
  - [ ] Deploy security rules to the `staging` Firebase project.
- [ ] **Post-Deployment Testing:** After deployment, automatically run the E2E test suite against the `staging` environment to verify the release.

#### c. Production Deployment Process

- [ ] **Manual Trigger:** Production deployments will be triggered manually by creating a Git tag (e.g., `v1.0.0`) from the `main` branch.
- [ ] **Gated Workflow:** The production deployment workflow will:
  - [ ] Run all automated checks (lint, tests).
- [ ] **Production Release:** Upon approval, the workflow will deploy all application and configuration changes to the `production` services (Vercel, Turso, Firebase).
- [ ] **Rollback Plan:** Document a simple rollback procedure, which at a minimum involves re-deploying a previously successful Git tag.

## Phase 3: Post-MVP Enhancements

### 1. Infrastructure for Post-MVP Features (AWS CDK)

- [ ] Create a new CDK Stack to define the resources for post-MVP features.
- [ ] Add a CDK Construct for the AWS Chime SDK resources, including necessary IAM roles for the backend to create meetings and attendees.
- [ ] Add a CDK Construct for the S3 bucket used for managed file sharing.
  - [ ] Configure the bucket with CORS policies.
  - [ ] Implement the 24-hour ephemeral deletion lifecycle policy.
- [ ] Add a CDK Construct for the Lambda function that processes usage reports.
  - [ ] Define the function's IAM role with permissions to read CUR reports from S3.
  - [ ] Configure the S3 trigger for the Lambda function.
- [ ] Deploy the new CDK stack to update the AWS infrastructure.

### 2. Scalable A/V for Larger Groups (AWS Chime)

- [ ] Add a local AWS Chime SDK emulator to the Docker Compose setup.
- [ ] Implement an endpoint to create and join Chime meetings (`/api/video-session`).
- [ ] Implement logic to track Chime usage and enforce quotas.

### 3. Managed File Sharing (AWS S3)

- [ ] Add a local AWS S3 emulator (e.g., MinIO) to the Docker Compose setup.
- [ ] Implement an endpoint to generate pre-signed S3 URLs for uploads (`/api/s3-upload-url`).
- [ ] Implement an endpoint to generate pre-signed S3 URLs for downloads (`/api/s3-download-url`).

### 4. Usage Tracking and Abuse Prevention (enhanced)

- [ ] Implement a system to track Chime usage using cost allocation tagging and AWS Cost and Usage Reports.
- [ ] Implement a system to track S3 usage using cost allocation tagging and AWS Cost and Usage Reports.

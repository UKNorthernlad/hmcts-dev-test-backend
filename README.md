# HMCTS Dev Test Backend
This will be the backend for the brand new HMCTS case management system. As a potential candidate we are leaving
this in your hands. Please refer to the brief for the complete list of tasks! Complete as much as you can and be
as creative as you want.

## Repository Background
This repository contains a SpringBoot application that implements the HMCTS case management backend system. The application provides an API which returns data in JSON format.

The main features of the repo are:

1. The main application SpringBoot application which is built using Gradle.
2. A Dockerfile which can be used to containerize the application.
3. A Docker-compose file used to run the container and a local Postgres instance for development puroses.
4. A GitHub Actions CI/CD pipeline to build the application, container and run serveral static analysis tools
5. Terraform templates used to deploy the application into Azure. Currrently a network, backend Postgress database and a frontend in Azure Container Services. Some supporting services for logging etc. are also created.

### Onboarding for new users
As somebody new to this repository, it's recommended that you follow the guidance below to build and run the application locally. This will allow you to see some of the features included in the supporting build & Dockerfiles. Afterwards you can review the provided CI/CD pipeline and view any previous executions to see understand what is happening.

#### Building and running locally
> This section assumes you already have a local Java Runtime Environment installed & setup and that a Docker Desktop instance is also installed and running.
Follow these steps to build and run the application locally

1. `git clone` the repository to your local machine and `cd` into it.
2. Run `./gradlew build` to start the build of the application.
3. Run `./gradlew bootRun` to start the server running.
4. Open a browser to *http://localhost:4000*. You should see **Welcome to test-backend** as output.
5. Open a browser to *http://localhost:4000/health*. You should see a JSON output that details the health of the connection to the database. As we have not set this up yet nor passed any connection details, you'll see an error but this confirms the health endpoint is working - note the **"status":"DOWN"**:
   ```
   {"components":{"db":{"details":{"error":"java.lang.RuntimeException: Driver org.postgresql.Driver claims to not accept jdbcUrl, jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}"},"status":"DOWN"},"diskSpace":{"details":{"total":494384795648,"free":106673770496,"threshold":10485760,"path":"/Users/fred/Source/hmcts-dev-test-backend/.","exists":true},"status":"UP"},"livenessState":{"status":"UP"},"ping":{"status":"UP"},"readinessState":{"status":"UP"},"ssl":{"details":{"expiringChains":[],"invalidChains":[],"validChains":[]},"status":"UP"}},"groups":["liveness","readiness"],"status":"DOWN"}
   ```
6. Ctrl-C to stop the server.
7. Run the following to define some environment variables which will be read by the application next time it starts.

   > Injecting variables like this prevents the need to hardcode these into the application.

   ```
   export DB_HOST=localhost
   export DB_PORT=5432
   export DB_NAME=devtest
   export DB_OPTIONS=
   export DB_USER_NAME=admin
   export DB_PASSWORD=localdev
   ```
8. To test the connection, use the off-the-shelf Postgres Docker image to host the database:
   ```
   docker run --name pgdb -d -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=localdev -e POSTGRES_DB=devtest -p 5432:5432 postgres:16
   ```
9. Restart the application with `./gradlew bootRun` and check *http://localhost:4000/health*. You should now see the following - note the **"status":"UP"** reference:
   ```
   {"components":{"db":{"details":{"database":"PostgreSQL","validationQuery":"isValid()"},"status":"UP"},"diskSpace":{"details":{"total":494384795648,"free":108727844864,"threshold":10485760,"path":"/Users/fred/Source/hmcts-dev-test-backend/.","exists":true},"status":"UP"},"livenessState":{"status":"UP"},"ping":{"status":"UP"},"readinessState":{"status":"UP"},"ssl":{"details":{"expiringChains":[],"invalidChains":[],"validChains":[]},"status":"UP"}},"groups":["liveness","readiness"],"status":"UP"}
   ```
10. **Ctrl-C** to stop the server and `docker kill pgdb && docker rm pgdb` to remove the Postgres container.

#### Building and running locally - Containerised application
In this next section you will review the supplied Dockerfile which is a set of instructions used to create a container image, then manually build the Docker image from the commmand line.

11. Open the [Dockerfile](Dockerfile) and note the following:
   * This is a multi-stage build file that builds the application (with Gradle) in an image that contains the whole JRE SDK, then copies this to a slimed down JRE image.
   * The application runs as a dedicated user (not root).
   * It listens on port 4000 which will be accessible from your browser when the container is running.
12. Build the image: `docker build -t springboot-app:latest .`, then run it: `docker run -d --name case-app -p 4000:4000 springboot-app:latest`.
`.
  > Note that we are not passing in database connection information as we are just wanting to test the container and application works.
13. Browse to *http://localhost:4000/health* and ensure you see the JSON response (it will say that connections are failing - but this is fine).
14. `docker kill case-app && docker rm case-app` to remove the case-app container.

#### Building and running locally - Docker Compose
Now you will run the application locally using a **docker-compose.yml** file. This will start both a case-app & postgres container image. You will also pass some environment variables to the case-app so that it can connect to the database.

> Previously you passed configuration information via environment variables. You are still going to do this but additionally you'll see how variables can also be passed using "bind-mounts". These make the configuration information appear as files inside the container which can then be referenced directly by applications inside the container. This is a stepping-stone to using *secrets managers* in cloud services such as Azure Key Vault.

15. Review the contents of the `docker-compose.yml` file. See that it contains two services: one for starting the case-app front end and another for the backend database. Notice also that it reads in configuration information via environment variables AND via the file system "bind-mount" volumes.

16. Set/reset the environment variables that will be read by the *docker-compose.yml* file.
   ```
   export DB_HOST=localhost
   export DB_PORT=5432
   export DB_NAME=devtest
   export DB_OPTIONS=
   export DB_USER_NAME=admin
   export DB_PASSWORD=localdev
   ```
17. Run the following to create a "password" file on your local machine. When the container is running, this will be mapped into the container:
   ```
   mkdir /tmp/secrets
   echo localdev >> /tmp/secrets/db_password
   ```
   In the real world, this will be a secrets manager rather than the local filesystem.

18. Now start the containers: `docker compose up`.

19. Review the output of this command. See that 3 things are created: *hmcts-dev-test-backend-postgres-1* which is the database, *hmcts-dev-test-backend-myapp-1* which is the front end and *hmcts-dev-test-backend_appnet* which is a network that both containers are attached to. This allows the front end to connect to the backend database.

20. Browse to *http://localhost:4000/health* and check see the JSON response, should confirm that  **"status":"UP"**. This means the application is now able to connect to the database.


#### Building and running in GitHub - Review the build pipeline & previous workflow runs
A GitHub Action CI/CD workflow has been created to build the application, perform static security analysis then build again into a container image. Further security are then again run.

21. Open [The CI/CD workflow definition](https://github.com/UKNorthernlad/hmcts-dev-test-backend/actions/workflows/BuildCasesApp.yml). Notice there is a single Build job with multiple steps that perform the following:
   * Checkout the repository
   * Install Java
   * Pull the application dependencies via Gradle.
   * Build the application
   * Run unit & static tests such as OWASP etc.
   * Build the container via the multi-stage pipeline
   * Place holders for pushing the new image to an external repository
   * Running of Trivy container security scanner.
   * Installation of Terraform
   * Validation of Terraform templates (more later).

It is a matter of personal taste as to wether all steps exist in a single job or these are split out.

22. If you have permissions, you can run this workflow manually, however [View the "Build Cases app" CI/CD pipeline](https://github.com/UKNorthernlad/hmcts-dev-test-backend/actions/workflows/BuildCasesApp.yml) if you wish to look at previous runs or [Download a log of a previous run for a detailed inspection](https://github.com/UKNorthernlad/hmcts-dev-test-backend/blob/master/samplelogs/logs_84820525985.zip).

      [![Build Cases app](https://github.com/UKNorthernlad/hmcts-dev-test-backend/actions/workflows/BuildCasesApp.yml/badge.svg)](https://github.com/UKNorthernlad/hmcts-dev-test-backend/actions/workflows/BuildCasesApp.yml/badge.svg)

#### Deployment using Terraform from GitHub Actions.
As this application is indended to be deployed into a public cloud service, a Terraform template has been created. This targets Microsoft Azure and has the following key features:

* The main repository contains a folder structure suitable for multiple enviornments, e.g. dev, uat, prod etc. Currently only the *dev* folder is populated.
* The *dev* folder contains a `main.tf`,`main.tfvar` and `variable.tf` files. These define the build of the infrastructure for the environment (resource group, network, backend Postgres database, front end Azure Container App, a key vault and log analytics for logging).
* The main.tf file uses a series of modules in a subfolder which define the individual resources. As the project grows, these could be moved and shared across other environments. This would allow the main.tfvar in each environment to provide environment specific variables and maximise template reuse & standardisation.
* The variable.tf in the *dev* folder contains a number of validation & condition rules for the main variables to help catch bad input.
* There are no hardcoded secrets into any of these files. These are typically created as pipeline/workflow secrets in GitHub and passed-in during the pipeline execution.

## A word on Terraform state management.
Terraform requires the use of a location to store information about the state of the remote cloud environment. Ths is used when performing steps to deploy the template into production.

Typically for a single developer this is just a local folder called `.terraform` in the repository root when does not get pushed when a commit occurs. This is fine for developers working on their own projects or when then have their own cloud environment.

However when a team of developers is sharing a common cloud enviroment and pushing code into a repository, the CI/CD workflow needs it's own copy of this state. This must be held in a central location so that each time the Terraform template are deployed, the cache can be accessed and updated.

To solve this issue, Terraform allows the definition of a *backend*. This is typically a Storage Account on Azure or S3 Bucket on AWS.

Take a look at this section of configuration from the beginning of the `main.tf` file in the `terraform/environments/dev` folder.

Notice the *backend* section: 
```
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.0.1"
    }
  }
  #backend "azurerm" {
  #  resource_group_name   = "rg-tfstate"
  #  storage_account_name  = "sttfstateprod"
  #  container_name        = "tfstate"
  #  key                   = "prod.terraform.tfstate"
  #}
}
```
This is using the Azure Terraform provider to store state in a specific Storage Account using an access key. 

The code sample shows this key being passed in as a variable, however in pratice this is typically created as a *secret* in the GitHub Repo and injected at pipeline runtime.

## Improvements
As there has only been a limiteed time to build this demonstration, there are a number of things would still need to be completed or would be done differently next time.

1. Hooking up more secrets into the GH Repo secrets (currently only the database username & password are located there).

2. Alternatively these could also be stored in KeyVault. There KV deployed as part of this demo includes a sample secret. Ideally the pipeline secrets would be injected into KV at build time so these can be read from the container image.

3. Microsoft has a whole series of standard Azure Terraform templates, these would be used more heavily.

4. Azure Container Apps (ACA) was chosen as the compute service to run the container image, mainly because the application consists of a single docker image with a PaaS Postgres database. The older Azure Container Server only typically allows the running of a single container image as it was originally created for running batch jobs etc. and not to run continuously. ACA is built on top of Kubernetes (Microsoft AKS) and abstracts away many of the AKS management problems but retains much of the benefits.
# Ballerina HubSpot CRM Object Tickets connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/hubspot.crm.object.tickets.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%hubspot.crm.object.tickets)

## Overview

[HubSpot](https://www.hubspot.com) is an AI-powered customer relationship management (CRM) platform. 

The `ballerinax/hubspot.crm.object.tickets` offers APIs to connect and interact with the [HubSpot Tickets API](https://developers.hubspot.com/docs/guides/api/crm/objects/tickets) endpoints, specifically based on the [HubSpot REST API](https://developers.hubspot.com/docs/reference/api).

## Setup guide

To use the `HubSpot CRM Object Tickets` connector, you must have access to the HubSpot API through a HubSpot developer account and an app under it. If you do not have a HubSpot developer account, you can sign up for one [here](https://developers.hubspot.com/get-started).

### Step 1: Create a HubSpot Developer Account

App Developer Accounts, allow you to create developer test accounts to test apps.

> **Note:** These accounts are only for development and testing purposes. Not to be used in production.

1. Go to "Test Account section" from the left sidebar.

    ![Test accounts](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/main/docs/setup/resources/test_acc_img1.png)

2. Click "Create developer test account".

   ![Developer Test Accounts](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/main/docs/setup/resources/test_acc_img2.png)

3. In the next dialogue box, give a name to your test account and click "Create".

   ![Hubspot developer account name](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/main/docs/setup/resources/test_acc_img3.png)

### Step 2: Create a HubSpot App under your account.

1. In your developer account, navigate to the "Apps" section. Click on "Create App".
   ![Hubspot App Creation](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/main/docs/setup/resources/app_img1.png)

2. Provide the necessary details, including the app name and description.

### Step 3: Configure the Authentication Flow.

1. Move to the Auth Tab.

   ![Auth tab](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/main/docs/setup/resources/auth.png)

2. In the "Scopes" section, add the following scopes for your app using the "Add new scope" button.

   * `tickets`
   * `oath`

   ![Scope Selection](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/main/docs/setup/resources/scope_select.png)

3. Add your Redirect URI in the relevant section. You can use `localhost` addresses for local development purposes. Then Click "Create App".

   ![Redirect URI](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/main/docs/setup/resources/redirect_url.png)

### Step 4: Get your Client ID and Client Secret

- Navigate to the "Auth" tab. Make sure to save the provided Client ID and Client Secret.

   ![Credentials](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/main/docs/setup/resources/credentials.png)

### Step 5: Setup Authentication Flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

1. Create an authorization URL using the following format:

   ```
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

   Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>` and `<YOUR_SCOPES>` with the above obtained values.

2. Paste it in the browser and select your developer test account to install the app when prompted.

3. A code will be displayed in the browser. Copy that code.

4. Run the following curl command. Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI`> and `<YOUR_CLIENT_SECRET>` with your specific value. Use the code you received in the above step 3 as the `<CODE>`.

   - Linux/macOS

     ```bash
     curl --request POST \
     --url https://api.hubapi.com/oauth/v1/token \
     --header 'content-type: application/x-www-form-urlencoded' \
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   - Windows

     ```bash
     curl --request POST ^
     --url https://api.hubapi.com/oauth/v1/token ^
     --header 'content-type: application/x-www-form-urlencoded' ^
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   This command will return the access token necessary for API calls.

   ```json
   {
     "token_type": "bearer",
     "refresh_token": "<Refresh Token>",
     "access_token": "<Access Token>",
     "expires_in": 1800
   }
   ```

5. Store the access token and refresh token securely for use in your application.

## Quickstart

To use the `HubSpot CRM Object Tickets` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `hubspot.crm.obj.tickets` module and `oauth2` module.

```ballerina
import ballerinax/hubspot.crm.obj.tickets as hstickets;
import ballerina/oauth2;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file inside the Ballerina package and add the following configurations with the values retrieved in the earlier steps as follows:

   ```toml
    clientId = <Client Id>
    clientSecret = <Client Secret>
    refreshToken = <Refresh Token>
   ```

2. Instantiate a `OAuth2RefreshTokenGrantConfig` with the obtained credentials and initialize the connector with it.

    ```ballerina
   configurable string clientId = ?;
   configurable string clientSecret = ?;
   configurable string refreshToken = ?;

   OAuth2RefreshTokenGrantConfig auth = {
      clientId,
      clientSecret,
      refreshToken,
      credentialBearer: oauth2:POST_BODY_BEARER 
   };

   final Client HubSpotClient = check new ({auth});
   ```

Now, utilize the available connector operations. A sample use case is shown below.

#### Create a New Ticket

```ballerina
public function main() returns error? {
    hstickets:SimplePublicObjectInputForCreate payload = {
        properties: {
            "hs_pipeline": "0",
            "hs_pipeline_stage": "1",
            "hs_ticket_priority": "HIGH",
            "subject": "New troubleshoot report"
        }
    };
    hstickets:SimplePublicObject response = check HubSpotClient->/.post(payload);
    io:println(response);
}
```

## Examples

The `HubSpot CRM Object Tickets` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.obj.tickets/tree/main/examples), covering the following use cases:
   1. [Ticket Management System](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/main/examples/ticket-management-system) - Integrate HubSpot with multiple customer support channels to streamline ticket management.
   2. [Weekly Tickets Report Generation](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/main/examples/weekly-ticket-reports) - Analyze detailed summaries of customer tickets in each week for better support.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`hubspot.crm.object.tickets` package](https://central.ballerina.io/ballerinax/hubspot.crm.object.tickets/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.

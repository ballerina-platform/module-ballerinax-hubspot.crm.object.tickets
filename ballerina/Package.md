## Overview

[//]: # (TODO: Add overview mentioning the purpose of the module, supported REST API versions, and other high-level details.)
[HubSpot](https://www.hubspot.com/our-story?_gl=1*1m7vzmd*_gcl_au*Njg4NDk3MzE4LjE3MzQ2NjYzMTk.*_ga*MTA3NDk2NDE4MC4xNzM0NDk5Njkx*_ga_LXTM6CQ0XK*MTczNDY2NjMxOS41LjEuMTczNDY2NjMyNS41NC4wLjA.*_fplc*cERXeW0zUkg1USUyRjhZTWNpcCUyQno5c3N6dEJmakNLeG5SJTJCUDQlMkZpR0xJbzlSMmlKMWdXMk1QNmd1NDluTzhIUUxVOGpTVFBac0x1OURSRnJuYTJzdnBYTE4wU3FVOHdGa2dUWUJQOVQxVlFKZlVOdVhRdHZYdlMlMkZTWUhhS0duZyUzRCUzRA..&_ga=2.223926171.1279200748.1734499691-1074964180.1734499691) is a customer relationship management (CRM) platform widely used in marketing, sales, customer service, and operations which provides a range of tools and software solutions designed to help businesses attract, engage, and retain customers. 

The `ballerinax/hubspot.crm.object.tickets` package offers APIs to create and manage CRM records that represent customer service requests in a CRM. The tickets endpoints allow you to manage creation and manage ticket records, as well as sync ticket data between HubSpot and other systems, specifically based on HubSpot API v3.

## Setup guide

[//]: # (TODO: Add detailed steps to obtain credentials and configure the module.)
To use the `HubSpot CRM Object Tickets` connector, you must have access to the HubSpot API through a HubSpot developer account and an app under it. If you do not have a HubSpot developer account, you can sign up for one [here](https://developers.hubspot.com/get-started).

### Step 1: Create a HubSpot Developer Account

App Developer Accounts, allow you to create developer test accounts to test apps.

**_These accounts are only for development and testing purposes. Not to be used in production._**

1. Go to **Test Account section** from the left sidebar.

    <img src="../docs/setup/resources/test_acc_img1.png" alt="hubspot developer portal" width="70%"/>

2. Click **Create developer test account**.

   <img src="../docs/setup/resources/test_acc_img2.png" alt="Hubspot developer testacc" style="width: 70%;">

3. In the next dialogue box, give a name to your test account and enter create.

   <img src="../docs/setup/resources/test_acc_img3.png" alt="Hubspot developer testacc name" style="width: 70%;">

### Step 2: Create a HubSpot App under your account.

1. In your developer account, navigate to the **"Apps"** section. Click on **"Create App"**
   <img src="../docs/setup/resources/app_img1.png" alt="Hubspot app creation 1 testacc" style="width: 70%;">

2. Provide the necessary details, including the app name and description.

### Step 3: Configure the Authentication Flow.

1. Move to the Auth Tab.

   <img src="../docs/setup/resources/auth.png" alt="Hubspot app auth tab" style="width: 70%;">

2. In the **Scopes** section, add the following scopes for your app using the **"Add new scope"** button.

   `tickets`
   `oath`

   <img src="../docs/setup/resources/scope_select.png" alt="Scope selection" style="width: 70%;">

3. Add your **Redirect URI** in the relevant section. You can use localhost addresses for local development purposes. Then Click **Create App**.

   <img src="../docs/setup/resources/redirect_url.png" alt="Redirect URI" style="width: 70%;">

### Step 4: Get your Client ID and Client Secret

- Navigate to the **Auth section** of your app. Make sure to save the provided Client ID and Client Secret.

   <img src="../docs/setup/resources/credentials.png" alt="Credentials" style="width: 70%;">

### Step 5: Setup Authentication Flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

1. Create an authorization URL using the following format:

   ```
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

   Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>` and `<YOUR_SCOPES>` with the above obtained values.

2. Paste it in the browser and select your developer test account to intall the app when prompted.

3. A code will be displayed in the browser. Copy that code.

   ```
   Received code: na1-129d-860c-xxxx-xxxx-xxxxxxxxxxxx
   ```

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

[//]: # (TODO: Add a quickstart guide to demonstrate a basic functionality of the module, including sample code snippets.)

To use the `HubSpot CRM Object Tickets` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `hubspot.crm.objects.tickets` module and `oauth2` module.

```ballerina
import ballerinax/hubspot.crm.object.tickets as hstickets;
import ballerina/oauth2;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and, configure the obtained credentials obtained in the above steps as follows:

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

   ConnectionConfig config = {auth};
   final Client HubSpotClient = check new Client(config, "https://api.hubapi.com");
   ```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample usecase is shown below.

#### Create a New Ticket

```ballerina
public function main() returns error? {
    SimplePublicObjectInputForCreate payload = {
        properties: {
            "hs_pipeline": "0",
            "hs_pipeline_stage": "1",
            "hs_ticket_priority": "HIGH",
            "subject": "New troubleshoot report"
        }
    };
    SimplePublicObject response = check HubSpotClient->/crm/v3/objects/tickets.post(payload);
    io:println(response5);
    return;
}
```

## Examples

The `HubSpot CRM Object Tickets` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.crm.object.tickets/tree/main/examples/), covering the following use cases:

[//]: # (TODO: Add examples)

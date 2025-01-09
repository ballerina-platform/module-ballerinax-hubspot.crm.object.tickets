_Author_:  <!-- TODO: Add author name --> \
_Created_: <!-- TODO: Add date --> \
_Updated_: <!-- TODO: Add date --> \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from HubSpot CRM Object Tickets. 
The OpenAPI specification is obtained from [Tickets OpenAPI](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/main/PublicApiSpecs/CRM/Tickets/Rollouts/424/v3/tickets.json).

These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

[//]: # (TODO: Add sanitation details)
1. **Changed the date-time type mentioned in openapi.json to datetime**

2. **Change the url property of the servers object:**

    * Original: https://api.hubapi.com <br>
    * Updated: https://api.hubapi.com/crm/v3/objects/tickets

    * Reason: This change is made to ensure that all API paths are relative to the versioned base URL (crm/v3/objects/taxes), which improves the consistency and usability of the APIs.

3. **Update API Paths:**

    * Original: `/crm/v3/objects/taxes`
    * Updated: `/`
    * Reason: This modification simplifies the API paths, making them shorter and more readable. It also centralizes the versioning to the base URL, which is a common best practice. 

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client -o ballerina
```

# Examples

The `ballerinax/hubspot.crm.object.tickets` connector provides practical examples illustrating usage in various scenarios.

1. [Ticket Management System](./ticket-management-system/) - Integrate HubSpot with multiple customer support channels to streamline ticket management.
2. [Weekly Ticket Reports](./weekly-ticket-reports/) - Analyze detailed summaries of customer tickets in each week for better support.

## Prerequisites

1. Refer the [Setup Guide](../README.md) to create your HubSpot account if you do not have one already.

2. For each example, create a `Config.toml` file in the example root directory. Here's an example of how your Config.toml file should look:
```
clientId = "<clientId>"
clientSecret = "<clientSecret>"
refreshToken = "<refreshToken>"
```
## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```

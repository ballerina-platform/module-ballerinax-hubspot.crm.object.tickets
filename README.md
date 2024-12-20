# Ballerina HubSpot CRM Object Tickets connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.object.tickets/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/hubspot.crm.object.tickets.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%hubspot.crm.object.tickets)

## Overview

[//]: # (TODO: Add overview mentioning the purpose of the module, supported REST API versions, and other high-level details.)

[HubSpot](https://www.hubspot.com/our-story?_gl=1*1m7vzmd*_gcl_au*Njg4NDk3MzE4LjE3MzQ2NjYzMTk.*_ga*MTA3NDk2NDE4MC4xNzM0NDk5Njkx*_ga_LXTM6CQ0XK*MTczNDY2NjMxOS41LjEuMTczNDY2NjMyNS41NC4wLjA.*_fplc*cERXeW0zUkg1USUyRjhZTWNpcCUyQno5c3N6dEJmakNLeG5SJTJCUDQlMkZpR0xJbzlSMmlKMWdXMk1QNmd1NDluTzhIUUxVOGpTVFBac0x1OURSRnJuYTJzdnBYTE4wU3FVOHdGa2dUWUJQOVQxVlFKZlVOdVhRdHZYdlMlMkZTWUhhS0duZyUzRCUzRA..&_ga=2.223926171.1279200748.1734499691-1074964180.1734499691) is a customer relationship management (CRM) platform widely used in marketing, sales, customer service, and operations which provides a range of tools and software solutions designed to help businesses attract, engage, and retain customers. 

The ballerinax/hubspot package offers APIs to connect and interact with HubSpot API endpoints, specifically based on HubSpot API v2.

## Setup guide

[//]: # (TODO: Add detailed steps to obtain credentials and configure the module.)

## Quickstart

[//]: # (TODO: Add a quickstart guide to demonstrate a basic functionality of the module, including sample code snippets.)

## Examples

The `HubSpot CRM Object Tickets` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.crm.object.tickets/tree/main/examples/), covering the following use cases:

[//]: # (TODO: Add examples)

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

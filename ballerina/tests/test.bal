// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/oauth2;
import ballerina/test;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

string ticketId = "";
string batchTicketId1 = "";
string batchTicketId2 = "";

OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

ConnectionConfig config = {auth};
final Client HubSpotClient = check new Client(config, "https://api.hubapi.com/crm/v3/objects/tickets");

// Test to get a list of all tickets
@test:Config {
    groups: ["live_tests"]
}
isolated function getTickets() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check HubSpotClient->/.get();
    if response.results is SimplePublicObject[] {
        test:assertTrue(response.results.length() > 0, "No tickets found");
    }
}

// Test case to create a new ticket
@test:Config {
    groups: ["live_tests"]
}
function createTicket() returns error? {
    SimplePublicObjectInputForCreate payload = {
        properties: {
            "hs_pipeline": "0",
            "hs_pipeline_stage": "1",
            "hs_ticket_priority": "LOW",
            "subject": "Auto generated Issue Report"
        }
    };
    SimplePublicObject response = check HubSpotClient->/.post(payload);
    if response is SimplePublicObject {
        test:assertTrue(response?.properties["hs_object_id"] != null, "Response is not a valid");
        test:assertTrue(response?.properties["subject"] == "Auto generated Issue Report", "Response is not a valid");
        test:assertTrue(response?.properties["hs_ticket_priority"] == "LOW", "Response is not a valid");
        test:assertTrue(response.properties["hs_pipeline"] == "0", "Response is not a valid");
        string? createdTicketId = response.properties["hs_object_id"];
        test:assertTrue(createdTicketId != null, "Response does not contain a valid ticket ID");
        ticketId = createdTicketId ?: "";
    }
}

// Test case to get the ticket by id
@test:Config {
    groups: ["live_tests"],
    dependsOn: [createTicket]
}
function getTicketById() returns error? {
    SimplePublicObjectWithAssociations response = check HubSpotClient->/[ticketId].get();
    test:assertTrue(response?.properties["subject"] == "Auto generated Issue Report", "Incorrect Ticket Subject");
    test:assertTrue(response?.properties["hs_ticket_priority"] == "LOW", "Incorrect Ticket Priority");
    test:assertTrue(response?.properties["hs_pipeline"] == "0", "Incorrect Ticket Pipeline");
}

// Test to check Update the ticket by id
@test:Config {
    groups: ["live_tests"],
    dependsOn: [getTicketById]
}
function updateTicketById() returns error? {
    SimplePublicObjectInput payload = {
        properties: {
            "subject": "Updated Bug Fix",
            "hs_ticket_priority": "HIGH",
            "hs_pipeline": "0"
        }
    };
    SimplePublicObject response = check HubSpotClient->/[ticketId].patch(payload);
    test:assertEquals(response?.properties["subject"], "Updated Bug Fix", "Response is not Updated");
    test:assertEquals(response?.properties["hs_ticket_priority"], "HIGH", "Response is not Updated");
    test:assertEquals(response?.properties["hs_pipeline"], "0", "Response is not Updated");
}

// Test to create a batch of tickets
@test:Config {
    groups: ["live_tests", "batch_tests"]
}
function createBatchTickets() returns error? {
    BatchInputSimplePublicObjectInputForCreate payload = {
        "inputs": [
            {
                "properties": {
                    "hs_pipeline": "0",
                    "hs_pipeline_stage": "1",
                    "hs_ticket_priority": "LOW",
                    "subject": "Issue Report Batch 1"
                }
            },
            {
                "properties": {
                    "hs_pipeline": "0",
                    "hs_pipeline_stage": "1",
                    "hs_ticket_priority": "HIGH",
                    "subject": "Issue Report Batch 2"
                }
            }
        ]
    };
    any response = check HubSpotClient->/batch/create.post(payload);
    if (response is BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors) {
        test:assertTrue(response.status == "COMPLETE", "Response is not a valid");
        string? createdBatchId1 = response?.results[0].id;
        string? createdBatchId2 = response?.results[1].id;
        batchTicketId1 = createdBatchId1 ?: "";
        batchTicketId2 = createdBatchId2 ?: "";
    } else {
        test:assertFail("Response is not valid");
    }
}

// Test case to read a batch of tickets by id
@test:Config {
    groups: ["live_tests", "batch_tests"],
    dependsOn: [createBatchTickets]
}
function readBatchTickets() returns error? {
    BatchReadInputSimplePublicObjectId payload = {
        "propertiesWithHistory": [],
        "ids": [batchTicketId1, batchTicketId2],
        "properties": [],
        "inputs": []
    };
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check HubSpotClient->/batch/read.post(payload);
    test:assertEquals(response.status, "COMPLETE", "Response is not valid");
}

// Test to update a batch of tickets by id
@test:Config {
    groups: ["live_tests", "batch_tests"],
    dependsOn: [createBatchTickets]
}
function updateBatchTickets() returns error? {
    BatchInputSimplePublicObjectBatchInput payload = {
        "inputs": [
            {
                "id": batchTicketId1,
                "properties": {
                    "subject": "Updated Troubleshoot Report 1",
                    "hs_ticket_priority": "MEDIUM",
                    "hs_pipeline": "0"
                }
            },
            {
                "id": batchTicketId2,
                "properties": {
                    "subject": "Updated Troubleshoot Report 2",
                    "hs_ticket_priority": "LOW",
                    "hs_pipeline": "0"
                }
            }
        ]
    };
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check HubSpotClient->/batch/update.post(payload);
    test:assertTrue(response is BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors, "Error in updating the tickets");
}

// Create or update a batch of tickets by unique property values
@test:Config {
    groups: ["live_test1"]
}
isolated function createOrUpdateBatchTicketsByUniquePropertyValues() returns error? {
    BatchInputSimplePublicObjectBatchInputUpsert payload = {
        "inputs": [
            {
                "idProperty": "string",
                "objectWriteTraceId": "string",
                "id": "18189789866",
                "properties": {
                    "additionalprop1": "string",
                    "additionalprop2": "string",
                    "additionalprop3": "string"
                }
            }
        ]
    };
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check HubSpotClient->/batch/upsert.post(payload);
    test:assertTrue(response is BatchResponseSimplePublicObject, "Error in creating or updating the tickets");
}

// Merge two tickets of same type
@test:Config {
    groups: ["live_tests"],
    dependsOn: [createTicket, createBatchTickets]
}
function mergeTickets() returns error? {
    PublicMergeInput payload = {
        "objectIdToMerge": ticketId,
        "primaryObjectId": batchTicketId1
    };
    any response = check HubSpotClient->/merge.post(payload);
    test:assertTrue(response is SimplePublicObject, "Response is not a SimplePublicObject");
}

// Test case to query tickets
@test:Config {
    groups: ["live_tests"]
}
isolated function searchTickets() returns error? {
    PublicObjectSearchRequest payload = {
        "limit": 0,
        "properties": ["subject", "hs_ticket_priority"],
        "associations": [],
        "filterGroups": [
            {
                "filters": [
                    {
                        "propertyName": "hs_ticket_priority",
                        "operator": "EQ",
                        "value": "HIGH"
                    }
                ]
            }
        ]
    };
    CollectionResponseWithTotalSimplePublicObjectForwardPaging|error response = check HubSpotClient->/search.post(payload);
    CollectionResponseWithTotalSimplePublicObjectForwardPaging collectionResponse = check response.ensureType();
    test:assertTrue(collectionResponse.length() >= 0);
}

// Test to archive the ticket by id
@test:Config {
    groups: ["live_tests"],
    dependsOn: [createTicket]
}
function archiveTicketById() returns error? {
    http:Response response = check HubSpotClient->/[ticketId].delete();
    test:assertEquals(response.statusCode, 204, "Unexpected status code: ${response.statusCode}. Expected: 204.");
}

// Test to archive a batch of tickets by id
@test:Config {
    groups: ["live_tests", "batch_tests"],
    dependsOn: [createBatchTickets]
}
function archiveBatchTickets() returns error? {
    BatchInputSimplePublicObjectId payload = {
        "ids": [batchTicketId1, batchTicketId2],
        "inputs": []
    };
    http:Response response = check HubSpotClient->/batch/archive.post(payload);
    test:assertEquals(response.statusCode, 204, "Unexpected status code: ${response.statusCode}. Expected: 204.");
}


import ballerina/io;
import ballerina/test;
import ballerina/oauth2;
import ballerina/os;
import ballerina/http;

configurable string clientId = os:getEnv("clientId");
configurable string clientSecret = os:getEnv("clientSecret");
configurable string refreshToken = os:getEnv("refreshToken");
configurable string hubspotBaseUrl ="https://api.hubapi.com";

OAuth2RefreshTokenGrantConfig auth = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshToken: refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER // this line should be added in to when you are going to create auth object.
};

ConnectionConfig config = {auth};
final Client HubSpotClient = check new Client(config, hubspotBaseUrl);

// Test case to archive the ticket by id
@test:Config{
    groups: ["live_tests"]
}
isolated function archiveTicketById() returns error? {
    http:Response|error response1 = check HubSpotClient->/crm/v3/objects/tickets/["18119697263"].delete();
    io:println(response1);
}


// Test case to get the list of all tickets
@test:Config{
    groups: ["live_tests"]
}

isolated function getTickets() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response2 = check HubSpotClient->/crm/v3/objects/tickets.get();
    io:println(response2);
}

// Test case to get the ticket by id
@test:Config{
    groups: ["live_tests"]
}

isolated function getTicketById() returns error? {
    SimplePublicObjectWithAssociations response3 = check HubSpotClient->/crm/v3/objects/tickets/["18072614505"].get();
    io:println(response3);
}

// Update the ticket by id
@test:Config{
    groups: ["live_tests"]
}

isolated function updateTicketById() returns error? {
    SimplePublicObjectInput payload = {
        properties: {
        "subject": "Bug Fix",
        "hs_ticket_priority": "MEDIUM",
        "hs_pipeline": "0"
        }
    };
    SimplePublicObject response4 = check HubSpotClient->/crm/v3/objects/tickets/["18072614505"].patch(payload);
    io:println(response4);
}

// Test case to create a new ticket
@test:Config{
    groups: ["live_tests"]
}
isolated function createTicket() returns error? {
    SimplePublicObjectInputForCreate payload = {
        properties: {
            "hs_pipeline": "0",
            "hs_pipeline_stage": "1",
            "hs_ticket_priority": "HIGH",
            "subject": "New troubleshoot report"
        }
    };
    SimplePublicObject response5 = check HubSpotClient->/crm/v3/objects/tickets.post(payload);
    io:println(response5);
    return;
}

// Test case to archive a batch of tickets by id
@test:Config{
    groups: ["live_tests"]
}
isolated function archiveBatchTickets() returns error? {
    BatchInputSimplePublicObjectId payload = {
        "ids": ["18081930395", "18090272609"],
        "inputs": []
    };
    http:Response|error response6 = check HubSpotClient->/crm/v3/objects/tickets/batch/archive.post(payload);
    io:println(response6);
    return;
}

// Test case to create a batch of tickets
@test:Config{
    groups: ["live_tests"]
}
isolated function createBatchTickets() returns error? {
    BatchInputSimplePublicObjectInputForCreate payload = {
        "inputs": [
            {
                "properties": {
                    "hs_pipeline": "0",
                    "hs_pipeline_stage": "1",
                    "hs_ticket_priority": "LOW",
                    "subject": "New bug report 1"
                }
            },
            {
                "properties": {
                    "hs_pipeline": "0",
                    "hs_pipeline_stage": "1",
                    "hs_ticket_priority": "HIGH",
                    "subject": "New bug report 2"
                }
            }
        ]
    };
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response7 = check HubSpotClient->/crm/v3/objects/tickets/batch/create.post(payload);
    io:println(response7);
    return;
}

// Test case to read a batch of tickets by id
@test:Config{
    groups: ["live_tests"]
}
isolated function readBatchTickets() returns error? {
    BatchReadInputSimplePublicObjectId payload = {
        "propertiesWithHistory": [],
        "ids": ["18081930395", "18090272609", "18125785934", "18125785935"],
        "properties": ["subject", "hs_ticket_priority"],
        "inputs": []};
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response8 = check HubSpotClient->/crm/v3/objects/tickets/batch/read.post(payload);
    io:println(response8);
    return;
}

// Test case to update a batch of tickets by id
@test:Config{
    groups: ["live_tests"]
}
isolated function updateBatchTickets() returns error? {
    BatchInputSimplePublicObjectBatchInput payload = {
        "inputs": [
            {
                "id": "18090272609",
                "properties": {
                    "subject": "Updated New Troubleshoot Report",
                    "hs_ticket_priority": "MEDIUM",
                    "hs_pipeline": "0"
                }
            },
            {
                "id": "18081930395",
                "properties": {
                    "subject": "Updated Troubleshoot Report",
                    "hs_ticket_priority": "LOW",
                    "hs_pipeline": "0"
                }
            }
        ]
    };
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response9 = check HubSpotClient->/crm/v3/objects/tickets/batch/update.post(payload);
    io:println(response9);
    return;
}

// Create or update a batch of tickets by unique property values
// @test:Config{
//     groups: ["live_tests"]
// }
// isolated function createOrUpdateBatchTicketsByUniquePropertyValues() returns error? {
//     BatchInputSimplePublicObjectBatchInputForCreateOrUpdate payload = {
//         "inputs": [
//             {
//                 "properties": {
//                     "hs_pipeline": "0",
//                     "hs_pipeline_stage": "1",
//                     "hs_ticket_priority": "HIGH",
//                     "subject": "New bug report 1"
//                 }
//             },
//             {
//                 "properties": {
//                     "hs_pipeline": "0",
//                     "hs_pipeline_stage": "1",
//                     "hs_ticket_priority": "HIGH",
//                     "subject": "New bug report 2"
//                 }
//             }
//         ]
//     };
//     BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response10 = check HubSpotClient->/crm/v3/objects/tickets/batch/createOrUpdate.post(payload);
//     io:println(response10);
//     return;
// }

// Merge two tickets of same type
@test:Config{
    groups: ["live_tests"]
}
isolated function mergeTickets() returns error? {
    PublicMergeInput payload = {
        "objectIdToMerge": "18125785935",
        "primaryObjectId": "18125785934"
    };
    SimplePublicObject|error response11 = check HubSpotClient->/crm/v3/objects/tickets/merge.post(payload);
    io:println(response11);
    return;
}

// Test case to query tickets
@test:Config{
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
    CollectionResponseWithTotalSimplePublicObjectForwardPaging|error response12 = check HubSpotClient->/crm/v3/objects/tickets/search.post(payload);
    io:println(response12);
    return;
}


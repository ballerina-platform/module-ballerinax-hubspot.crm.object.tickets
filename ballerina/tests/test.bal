import ballerina/io;
import ballerina/test;
import ballerina/oauth2;
import ballerina/http;

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

// Test to archive the ticket by id
@test:Config{
    groups: ["live_tests"]
}
isolated function archiveTicketById() returns error? {
    http:Response|error response1 = check HubSpotClient->/crm/v3/objects/tickets/["18392088879"].delete();
    // io:println(response1);
    test:assertTrue(response1 is http:Response, "Response is not a http:Response");
}


// Test to get a list of all tickets
@test:Config{
    groups: ["live_tests"]
}

isolated function getTickets() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response2 = check HubSpotClient->/crm/v3/objects/tickets.get();
    // io:println(response2);
    test:assertTrue(response2.length() > 0,"No tickets found");
}

// Test case to get the ticket by id
@test:Config{
    groups: ["live_tests"]
}

isolated function getTicketById() returns error? {
    SimplePublicObjectWithAssociations response3 = check HubSpotClient->/crm/v3/objects/tickets/["18189789866"].get();
    // io:println(response3);
    test:assertTrue(response3 is SimplePublicObjectWithAssociations, "Response is not a SimplePublicObjectWithAssociations");
}

// Test to check Update the ticket by id
@test:Config{
    groups: ["live_tests"]
}

isolated function updateTicketById() returns error? {
    SimplePublicObjectInput payload = {
        properties: {
        "subject": "Updated Bug Fix",
        "hs_ticket_priority": "HIGH",
        "hs_pipeline": "0"
        }
    };
    SimplePublicObject response4 = check HubSpotClient->/crm/v3/objects/tickets/["18072614505"].patch(payload);
    // io:println(response4);
    test:assertTrue(response4.properties.get("subject")=="Updated Bug Fix", "Response is not a Updated");
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
            "hs_ticket_priority": "MEDIUM",
            "subject": "Customer Issue Report New"
        }
    };
    SimplePublicObject|error response5 = check HubSpotClient->/crm/v3/objects/tickets.post(payload);
    // io:println(response5);
    test:assertTrue(response5 is SimplePublicObject, "Response is not a SimplePublicObject");
    return;
}

// Test to archive a batch of tickets by id
@test:Config{
    groups: ["live_tests"]
}
isolated function archiveBatchTickets() returns error? {
    BatchInputSimplePublicObjectId payload = {
        "ids": ["18392088916", "18392088928"],
        "inputs": []
    };
    http:Response|error response6 = check HubSpotClient->/crm/v3/objects/tickets/batch/archive.post(payload);
    // io:println(response6);
    test:assertTrue(response6 is http:Response, "Response is not a http:Response");
    return;
}

// Test to create a batch of tickets
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
                    "subject": "Issue Report New 1"
                }
            },
            {
                "properties": {
                    "hs_pipeline": "0",
                    "hs_pipeline_stage": "1",
                    "hs_ticket_priority": "HIGH",
                    "subject": "Issue Report New 2"
                }
            }
        ]
    };
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response7 = check HubSpotClient->/crm/v3/objects/tickets/batch/create.post(payload);
    // io:println(response7);
    test:assertTrue(response7 is BatchResponseSimplePublicObject, "Response is not a BatchResponseSimplePublicObject");
    return;
}

// Test case to read a batch of tickets by id
@test:Config{
    groups: ["live_tests"]
}
isolated function readBatchTickets() returns error? {
    BatchReadInputSimplePublicObjectId payload = {
        "propertiesWithHistory": [],
        "ids": ["18043215395", "18148225200", "18081930395", "18090272609"],
        "properties": ["subject", "hs_ticket_priority"],
        "inputs": []};
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response8 = check HubSpotClient->/crm/v3/objects/tickets/batch/read.post(payload);
    // io:println(response8);
    if (response8 is BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors) {
        test:assertTrue(response8.length() == 4, "Response is not a valid");
    } else {
        test:assertFail("Response is not valid");
    }
    return;
}

// Test to update a batch of tickets by id
@test:Config{
    groups: ["live_tests"]
}
isolated function updateBatchTickets() returns error? {
    BatchInputSimplePublicObjectBatchInput payload = {
        "inputs": [
            {
                "id": "18090272609",
                "properties": {
                    "subject": "Updated Troubleshoot Report 1",
                    "hs_ticket_priority": "MEDIUM",
                    "hs_pipeline": "0"
                }
            },
            {
                "id": "18081930395",
                "properties": {
                    "subject": "Updated Troubleshoot Report 2",
                    "hs_ticket_priority": "LOW",
                    "hs_pipeline": "0"
                }
            }
        ]
    };
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response9 = check HubSpotClient->/crm/v3/objects/tickets/batch/update.post(payload);
    // io:println(response9);
    test:assertTrue(response9 is BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors, "Error in updating the tickets");
    return;
}

// Create or update a batch of tickets by unique property values
@test:Config{
    groups: ["live_tests"]
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
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response10 = check HubSpotClient->/crm/v3/objects/tickets/batch/upsert.post(payload);
    // test:assertTrue(response10 is BatchResponseSimplePublicObject, "Error in creating or updating the tickets");
    io:println(response10);
    return;
}

// Merge two tickets of same type
@test:Config{
    groups: ["live_tests"]
}
isolated function mergeTickets() returns error? {
    PublicMergeInput payload = {
        "objectIdToMerge": "18088795290",
        "primaryObjectId": "18204824624"
    };
    SimplePublicObject|error response11 = check HubSpotClient->/crm/v3/objects/tickets/merge.post(payload);
    // io:println(response11);
    test:assertTrue(response11 is SimplePublicObject, "Response is not a SimplePublicObject");
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
    if (response12 is CollectionResponseWithTotalSimplePublicObjectForwardPaging) {
        test:assertTrue(response12.length()>=0, "Response is not a CollectionResponseWithTotalSimplePublicObjectForwardPaging");
    } else {
        test:assertFail("Response is not a valid");
    }
    return;
}


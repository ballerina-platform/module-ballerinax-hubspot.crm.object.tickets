import ballerina/test;
import ballerina/oauth2;
import ballerina/http;

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
@test:Config{
    groups: ["live_tests"]
}

isolated function getTickets() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response2 = check HubSpotClient->/.get();
    test:assertTrue(response2.results.length() >= 0,"Response is not valid");
}

// Test case to create a new ticket
@test:Config{
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
    SimplePublicObject|error response5 = check HubSpotClient->/.post(payload);
    if (response5 is SimplePublicObject) {
        test:assertTrue(response5.properties.get("hs_object_id") != null, "Response is not a valid");
        test:assertTrue(response5.properties.get("subject") == "Auto generated Issue Report", "Response is not a valid");
        test:assertTrue(response5.properties.get("hs_ticket_priority") == "LOW", "Response is not a valid");
        test:assertTrue(response5.properties.get("hs_pipeline") == "0", "Response is not a valid");
        string? createdTicketId = response5.properties.get("hs_object_id");
        test:assertTrue(createdTicketId != null, "Response does not contain a valid ticket ID");
        ticketId = createdTicketId ?: "";
    }
    else{
        test:assertFail("Response is not valid");
    }
}

// Test case to get the ticket by id
@test:Config{
    groups: ["live_tests"],
    dependsOn: [createTicket]
}

function getTicketById() returns error? {
    SimplePublicObjectWithAssociations response3 = check HubSpotClient->/[ticketId].get();
    test:assertTrue(response3.properties.get("subject")=="Auto generated Issue Report", "Response is not correct");
    test:assertTrue(response3.properties.get("hs_ticket_priority")=="LOW", "Response is not correct");
    test:assertTrue(response3.properties.get("hs_pipeline")=="0", "Response is not correct");
}

// Test to check Update the ticket by id
@test:Config{
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
    SimplePublicObject response4 = check HubSpotClient->/[ticketId].patch(payload);
    test:assertTrue(response4.properties.get("subject")=="Updated Bug Fix", "Response is not a Updated");
    test:assertTrue(response4.properties.get("hs_ticket_priority")=="HIGH", "Response is not a Updated");
    test:assertTrue(response4.properties.get("hs_pipeline")=="0", "Response is not a Updated");
}

// Test to create a batch of tickets
@test:Config{
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
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response7 = check HubSpotClient->/batch/create.post(payload);
    if (response7 is BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors) {
        test:assertTrue(response7.status == "COMPLETE", "Response is not a valid");
        string? createdBatchId1 = response7.results[0].id;
        string? createdBatchId2 = response7.results[1].id;
        batchTicketId1 = createdBatchId1 ?: "";
        batchTicketId2 = createdBatchId2 ?: "";
    } else {
        test:assertFail("Response is not valid");
    }
}

// Test case to read a batch of tickets by id
@test:Config{
    groups: ["live_tests", "batch_tests"],
    dependsOn: [createBatchTickets]
}
function readBatchTickets() returns error? {
    BatchReadInputSimplePublicObjectId payload = {
        "propertiesWithHistory": [],
        "ids": [batchTicketId1, batchTicketId2],
        "properties": [],
        "inputs": []};
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response8 = check HubSpotClient->/batch/read.post(payload);
    if (response8 is BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors) {
        test:assertTrue(response8.status == "COMPLETE", "Response is not a valid");
    } else {
        test:assertFail("Response is not valid");
    }
}

// Test to update a batch of tickets by id
@test:Config{
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
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response9 = check HubSpotClient->/batch/update.post(payload);
    test:assertTrue(response9 is BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors, "Error in updating the tickets");
}

// Create or update a batch of tickets by unique property values
@test:Config{
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
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response10 = check HubSpotClient->/batch/upsert.post(payload);
    test:assertTrue(response10 is BatchResponseSimplePublicObject, "Error in creating or updating the tickets");
    return;
}

// Merge two tickets of same type
@test:Config{
    groups: ["live_tests"],
    dependsOn: [createTicket, createBatchTickets]
}
function mergeTickets() returns error? {
    PublicMergeInput payload = {
        "objectIdToMerge": ticketId,
        "primaryObjectId": batchTicketId1
    };
    SimplePublicObject|error response11 = check HubSpotClient->/merge.post(payload);
    test:assertTrue(response11 is SimplePublicObject, "Response is not a SimplePublicObject");
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
    CollectionResponseWithTotalSimplePublicObjectForwardPaging|error response12 = check HubSpotClient->/search.post(payload);
    if (response12 is CollectionResponseWithTotalSimplePublicObjectForwardPaging) {
        test:assertTrue(response12.length()>=0, "Invalid response");
    } else {
        test:assertFail("Response is not a valid");
    }
}

// Test to archive the ticket by id
@test:Config{
    groups: ["live_tests"],
    dependsOn: [createTicket]
}
function archiveTicketById() returns error? {
    http:Response|error response1 = check HubSpotClient->/[ticketId].delete();
    test:assertTrue(response1 is http:Response, "Response is not a http:Response");
    if (response1 is http:Response) {
        test:assertTrue(response1.statusCode == 204,  string `Unexpected status code: ${response1.statusCode}. Expected: 204.`);
    }
}

// Test to archive a batch of tickets by id
@test:Config{
    groups: ["live_tests", "batch_tests"],
    dependsOn: [createBatchTickets]
}
function archiveBatchTickets() returns error? {
    BatchInputSimplePublicObjectId payload = {
        "ids": [batchTicketId1, batchTicketId2],
        "inputs": []
    };
    http:Response|error response6 = check HubSpotClient->/batch/archive.post(payload);
    if (response6 is http:Response) {
        test:assertTrue(response6.statusCode == 204, "Unexpected status code: ${response6.statusCode}. Expected: 204.");
    }
    else{
        test:assertFail("Response is not valid");
    }
    return;
}


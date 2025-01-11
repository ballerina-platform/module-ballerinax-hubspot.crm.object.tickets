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
import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.obj.tickets as hstickets;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

string createdTicketId = "";
string batchTicketId1 = "";
string batchTicketId2 = "";
string batchTicketId3 = "";

hstickets:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final hstickets:Client hubspot = check new ({auth});

public function main() returns error? {
    // Ticket creation
    hstickets:SimplePublicObjectInputForCreate payload = {
        properties: {
            "subject": "Sample User Ticket",
            "hs_pipeline": "0",
            "hs_pipeline_stage": "1",
            "hs_ticket_priority": "LOW",
            "content": "This is a sample ticket created using Ballerina"
        }
    };
    hstickets:SimplePublicObject createdTicket = check hubspot->/.post(payload);
    io:println("Created Ticket:", createdTicket);
    io:println();
    createdTicketId = createdTicket.id;

    // Ticket read
    hstickets:SimplePublicObjectWithAssociations readTicket = check hubspot->/[createdTicketId].get();
    io:println("Read Ticket:", readTicket);
    io:println();

    // Ticket update
    hstickets:SimplePublicObjectInput updatePayload = {
        properties: {
            "subject": "Sample User Ticket Updated",
            "hs_pipeline": "0",
            "hs_pipeline_stage": "1",
            "hs_ticket_priority": "HIGH",
            "content": "This is a sample ticket updated using Ballerina"
        }
    };
    hstickets:SimplePublicObject updatedTicket = check hubspot->/[createdTicketId].patch(updatePayload);
    io:println("Updated Ticket:", updatedTicket);
    io:println();

    // Ticket deletion
    http:Response deletedResponse = check hubspot->/[createdTicketId].delete();
    io:println("Deleted Ticket:", deletedResponse);
    io:println();

    // Batch ticket creation
    hstickets:BatchInputSimplePublicObjectInputForCreate batchCreatePayload = {
        "inputs": [
            {
                "properties": {
                    "subject": "Sample User Batch Ticket 1",
                    "hs_pipeline": "0",
                    "hs_pipeline_stage": "1",
                    "hs_ticket_priority": "LOW",
                    "content": "This is a sample ticket 1 created using Ballerina"
                }
            },
            {
                "properties": {
                    "subject": "Sample User Batch Ticket 2",
                    "hs_pipeline": "0",
                    "hs_pipeline_stage": "1",
                    "hs_ticket_priority": "HIGH",
                    "content": "This is a sample ticket 2 created using Ballerina"
                }
            },
            {
                "properties": {
                    "subject": "Sample User Batch Ticket 3",
                    "hs_pipeline": "0",
                    "hs_pipeline_stage": "1",
                    "hs_ticket_priority": "MEDIUM",
                    "content": "This is a sample ticket 3 created using Ballerina"
                }
            }
        ]
    };
    hstickets:BatchResponseSimplePublicObject createdBatchResponse = check hubspot->/batch/create.post(batchCreatePayload);
    io:println("Created Batch Ticket Response:", createdBatchResponse);
    batchTicketId1 = createdBatchResponse.results[0].id;
    batchTicketId2 = createdBatchResponse.results[1].id;
    batchTicketId3 = createdBatchResponse.results[2].id;

    // Batch ticket read
    hstickets:BatchReadInputSimplePublicObjectId batchReadPayload = {
        "propertiesWithHistory": [],
        "ids": [batchTicketId1, batchTicketId2, batchTicketId3],
        "properties": ["subject", "hs_pipeline", "hs_pipeline_stage", "hs_ticket_priority", "content"],
        "inputs": []
    };
    hstickets:BatchResponseSimplePublicObject batchReadResponse = check hubspot->/batch/read.post(batchReadPayload);
    io:println("Batch Read Ticket Response:", batchReadResponse);
    io:println();

    // Batch ticket update
    hstickets:BatchInputSimplePublicObjectBatchInput batchUpdatePayload = {
        "inputs": [
            {
                "id": batchTicketId1,
                "properties": {
                    "subject": "Sample User Batch Ticket 1 Updated",
                    "hs_pipeline": "0",
                    "hs_pipeline_stage": "1",
                    "hs_ticket_priority": "HIGH",
                    "content": "This is a sample ticket 1 updated using Ballerina"
                }
            },
            {
                "id": batchTicketId2,
                "properties": {
                    "subject": "Sample User Batch Ticket 2 Updated",
                    "hs_pipeline": "0",
                    "hs_pipeline_stage": "1",
                    "hs_ticket_priority": "MEDIUM",
                    "content": "This is a sample ticket 2 updated using Ballerina"
                }
            },
            {
                "id": batchTicketId3,
                "properties": {
                    "subject": "Sample User Batch Ticket 3 Updated",
                    "hs_pipeline": "0",
                    "hs_pipeline_stage": "1",
                    "hs_ticket_priority": "LOW",
                    "content": "This is a sample ticket 3 updated using Ballerina"
                }
            }
        ]
    };
    hstickets:BatchResponseSimplePublicObject batchUpdateResponse = check hubspot->/batch/update.post(batchUpdatePayload);
    io:println("Batch Update Ticket Response:", batchUpdateResponse);
}

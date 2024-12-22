import ballerina/io;
import ballerina/test;
import ballerina/oauth2;
import ballerina/os;

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

// @test:Config { 
//     groups: ["live_tests"] 
// }
// isolated function createTicket() returns error? {
//     SimplePublicObject response = check HubSpotClient->/crm/v3/objects/tickets.post(
//         payload = ///Example request body
// {
//   "properties": {
//     "hs_pipeline": "0",
//     "hs_pipeline_stage": "1",
//     "hs_ticket_priority": "HIGH",
//     "subject": "troubleshoot report"
//   },
//   "associations": [
//     {
//       "to": {
//         "id": "18043215395"
//       },
//       "types": [
//         {
//           "associationCategory": "HUBSPOT_DEFINED",
//           "associationTypeId": 16
//         }
//       ]
//     },
//     {
//       "to": {
//         "id": "18043215395"
//       },
//       "types": [
//         {
//           "associationCategory": "HUBSPOT_DEFINED",
//           "associationTypeId": 26
//         }
//       ]
//     }
//   ]
// });

//     io:println(response);
// }
// inputs: [
// { id: "12345" }
// ]
// };
// http:Response response = check HubSpotClient->/crm/v3/objects/tickets/batch/archive.post(payload);
// test:assertTrue(response.statusCode !is 200, "Test failed");
// }


@test:Config{
    groups: ["live_tests"]
}

isolated function getTickets() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check HubSpotClient->/crm/v3/objects/tickets.get();
    io:println(response);
}

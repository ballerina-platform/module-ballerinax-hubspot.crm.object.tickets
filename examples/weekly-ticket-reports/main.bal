import ballerina/io;
import ballerina/oauth2;
// import ballerina/http;
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

hstickets:ConnectionConfig config = {auth};
final hstickets:Client TicketClient = check new hstickets:Client(config);

public function main() returns error? {
    hstickets:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging ticketList = check TicketClient->/.get();
    int totalTickets = ticketList?.results.length();
    int lowPriorityTickets = 0;
    int highPriorityTickets = 0;
    int mediumPriorityTickets = 0;
    foreach var ticket in ticketList.results {
        if (ticket?.properties["hs_ticket_priority"] == "HIGH") {
            highPriorityTickets = highPriorityTickets + 1;
        } else if (ticket?.properties["hs_ticket_priority"] == "MEDIUM") {
            mediumPriorityTickets = mediumPriorityTickets + 1;
        } else {
            lowPriorityTickets = lowPriorityTickets + 1;
        }
    }
    int supportPipelineTickets = 0;
    int technicalPipelineTickets = 0;
    int salesPipelineTickets = 0;
    foreach var ticket in ticketList.results {
        if (ticket?.properties["hs_pipeline"]== "0") {
            supportPipelineTickets = supportPipelineTickets + 1;
        } else if (ticket?.properties["hs_pipeline"]== "676185170") {
            technicalPipelineTickets = technicalPipelineTickets + 1;
        } else if (ticket?.properties["hs_pipeline"]== "675912198") {
            salesPipelineTickets = salesPipelineTickets + 1;
        }
    }
    
    string report = string `
        Weekly Ticket Report:
        - Total Tickets: ${totalTickets}
        - Low Priority: ${lowPriorityTickets}
        - Medium Priority: ${mediumPriorityTickets}
        - High Priority: ${highPriorityTickets}

        - Support Pipeline Tickets: ${supportPipelineTickets}
        - Technical Pipeline Tickets: ${technicalPipelineTickets}
        - Sales Pipeline Tickets: ${salesPipelineTickets}
    `;
    io:println(report);
}

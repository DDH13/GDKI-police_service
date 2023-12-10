import ballerina/http;
import ballerina/log;
import ballerina/persist;
import ballerina/sql;
import ballerina/time;
import ballerina/uuid;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerinax/vonage.sms as vs;

type PoliceRequestWithNIC record {
    readonly string id;
    Citizen citizen;
    string status;
    string? reason;
    string gid;
    time:Utc appliedTime;
    string nic;
};

isolated function getCitizen(string id) returns Citizen|error {
    Citizen|error citizen = dbclient->/citizens/[id];
    if citizen is error {
        return citizen;
    } else {
        return citizen;
    }
}

isolated function addCitizen(Citizen citizen) returns Citizen|error {
    string[]|persist:Error added = dbclient->/citizens.post([citizen]);
    if added is error {
        return added;
    } else {
        return citizen;
    }
}

isolated function getCitizenByNIC(string nic) returns Citizen|error {
    Citizen[]|error citizens = from var citizen in dbclient->/citizens(targetType = Citizen)
        where citizen.nic == nic
        select citizen;
    if (citizens is Citizen[] && citizens.length() > 0) {
        return citizens[0];
    } else {
        return error("Error while retrieving citizen from the database");
    }
}

isolated function getAllCitizens() returns Citizen[]|error {
    Citizen[]|error citizens = from var citizen in dbclient->/citizens(targetType = Citizen)
        select citizen;
    if citizens is error {
        log:printError("Error while retrieving citizens from the database", 'error = citizens);
        return citizens;
    } else {
        return citizens;
    }
}

isolated function getOffensesForCitizen(string id) returns Offense[]|error? {
    Offense[]|error? offenses = from var offense in dbclient->/offenses(targetType = Offense)
        where offense.citizenId == id
        select offense;
    if offenses is error {
        log:printError("Error while retrieving offenses from the database", 'error = offenses);
        return offenses;
    } else {
        return offenses;
    }
}

isolated function checkOffenseExists(string id) returns boolean|error {
    Offense[] offenses = check getOffensesForCitizen(id) ?: [];
    if (offenses.length() > 0) {
        return true;
    } else {
        return false;
    }

}

isolated function addRequest(Citizen citizen, string reason, string gid) returns PoliceRequest|error {

    time:Utc tnow = time:utcNow();
    PoliceRequest request = {id: uuid:createType4AsString(), citizenId: citizen.id, status: "PENDING", appliedTime: tnow, reason: reason, gid: gid};
    string[]|error added = dbclient->/policerequests.post([request]);
    if added is error {
        return added;
    } else {
        return request;
    }
}

isolated function getRequest(string id) returns PoliceRequestWithNIC|error {
    sql:ParameterizedQuery query = `SELECT PoliceRequest.id, citizenId, status, reason, gid, appliedTime, nic FROM PoliceRequest INNER JOIN Citizen On PoliceRequest.citizenId = Citizen.id WHERE PoliceRequest.id = ${id}`;
    stream<PoliceRequestWithNIC, sql:Error?> resultStream = mysqldbClient->query(query);
    PoliceRequestWithNIC[] requests = [];
    check from PoliceRequestWithNIC request in resultStream
        do {
            requests.push(request);
        };
    check resultStream.close();
    if (requests.length() > 0) {
        return requests[0];
    } else {
        return error("Error while retrieving request from the database");
    }   
    
}

isolated function getRequests(int rlimit = 10000, int offset = 0) returns PoliceRequestWithNIC[]|error {
    sql:ParameterizedQuery query = `SELECT PoliceRequest.id, citizenId, status, reason, gid, appliedTime, nic FROM PoliceRequest INNER JOIN Citizen On PoliceRequest.citizenId = Citizen.id ORDER BY appliedTime DESC LIMIT ${rlimit} OFFSET ${offset}`;
    stream<PoliceRequestWithNIC, sql:Error?> resultStream = mysqldbClient->query(query);
    PoliceRequestWithNIC[] requests = [];
    check from PoliceRequestWithNIC request in resultStream
        do {
            requests.push(request);
        };
    check resultStream.close();
    return requests;
}

isolated function getRequestsByStatus(string status, int rlimit = 10000, int offset = 0) returns PoliceRequestWithNIC[]|error {
    sql:ParameterizedQuery query = `SELECT PoliceRequest.id, citizenId, status, reason, gid, appliedTime, nic FROM PoliceRequest INNER JOIN Citizen On PoliceRequest.citizenId = Citizen.id WHERE status = ${status} ORDER BY appliedTime DESC LIMIT ${rlimit} OFFSET ${offset}`;
    stream<PoliceRequestWithNIC, sql:Error?> resultStream = mysqldbClient->query(query);
    PoliceRequestWithNIC[] requests = [];
    check from PoliceRequestWithNIC request in resultStream
        do {
            requests.push(request);
        };
    check resultStream.close();
    return requests;
}

isolated function getRequestsByStatusAndGramaDivision(string status, string grama_division_id, int rlimit = 10000, int offset = 0) returns PoliceRequestWithNIC[]|error {
    sql:ParameterizedQuery query = `SELECT PoliceRequest.id, citizenId, status, reason, gid, appliedTime, nic FROM PoliceRequest INNER JOIN Citizen On PoliceRequest.citizenId = Citizen.id WHERE status = ${status} AND gid = ${grama_division_id} ORDER BY appliedTime DESC LIMIT ${rlimit} OFFSET ${offset}`;
    stream<PoliceRequestWithNIC, sql:Error?> resultStream = mysqldbClient->query(query);
    PoliceRequestWithNIC[] requests = [];
    check from PoliceRequestWithNIC request in resultStream
        do {
            requests.push(request);
        };
    check resultStream.close();
    return requests;
}

isolated function getRequestsByGramaDivision(string grama_division_id, int rlimit = 10000, int offset = 0) returns PoliceRequestWithNIC[]|error {
    sql:ParameterizedQuery query = `SELECT PoliceRequest.id, citizenId, status, reason, gid, appliedTime, nic FROM PoliceRequest INNER JOIN Citizen On PoliceRequest.citizenId = Citizen.id WHERE gid = ${grama_division_id} ORDER BY appliedTime DESC LIMIT ${rlimit} OFFSET ${offset}`;
    stream<PoliceRequestWithNIC, sql:Error?> resultStream = mysqldbClient->query(query);
    PoliceRequestWithNIC[] requests = [];
    check from PoliceRequestWithNIC request in resultStream
        do {
            requests.push(request);
        };
    check resultStream.close();
    return requests;
}

isolated function deleteRequest(string id) returns ()|error {
    PoliceRequest|persist:Error deleted = dbclient->/policerequests/[id].delete();
    if (deleted is error) {
        return deleted;
    }
    return ();
}

isolated function getRequestsForCitizen(string id) returns PoliceRequestWithNIC[]|error? {
    sql:ParameterizedQuery query = `SELECT PoliceRequest.id, citizenId, status, reason, gid, appliedTime, nic FROM PoliceRequest INNER JOIN Citizen On PoliceRequest.citizenId = Citizen.id WHERE citizenId = ${id} ORDER BY appliedTime DESC`;
    stream<PoliceRequestWithNIC, sql:Error?> resultStream = mysqldbClient->query(query);
    PoliceRequestWithNIC[] requests = [];
    check from PoliceRequestWithNIC request in resultStream
        do {
            requests.push(request);
        };
    check resultStream.close();
    return requests;
}

isolated function updateRequestStatus(string id, string status, Citizen citizen) returns string|error {
    PoliceRequest|error updated = dbclient->/policerequests/[id].put({status: status});
    if updated is error {
        return updated;
    } else {
        return id;
    }
}

isolated function checkCitizenHasValidIdentityRequests(string nic) returns boolean|error {
    string url = identity_url + "/identity/requests/validate/" + nic;
    http:Client NewClient = check new (url);
    boolean|error response = check NewClient->/.get();
    if (response is error) {
        return false;
    }
    return response;
}

isolated function getLatestIdentityRequest(string nic) returns json|error {
    string url = identity_url + "/identity/requests/latest/" + nic;
    http:Client NewClient = check new (url);
    json|error response = check NewClient->/.get();
    if (response is error) {
        return response;
    }
    return response;
}

isolated function checkCitizenHasValidAddressRequests(string nic) returns boolean|error {
    string url = address_url + "/address/requests/validate/" + nic;
    http:Client NewClient = check new (url);
    boolean|error response = check NewClient->/.get();
    if (response is error) {
        return false;
    }
    return response;

}

final mysql:Client mysqldbClient = check new (
    host = host, user = user, password = password, port = port, database = database
);
configurable string address_url = ?;
configurable string identity_url = ?;

function initializeDbClient() returns Client|error {
    return new Client();
}

final Client dbclient = check initializeDbClient();

//Vonage SMS provider
configurable string api_key = ?;
configurable string api_secret = ?;
configurable string vonageServiceUrl = "https://rest.nexmo.com/sms";

// // Send SMS
// string _ = check sendSms(vsClient, citizen, updated);
isolated function sendSms(vs:Client vsClient, Citizen citizen, PoliceRequest request) returns string|error {
    //get the contact number
    string url = identity_url + "/identity/requests/latest/" + citizen.nic;
    http:Client NewClient = check new (url);
    json|error identityResponse = check NewClient->/.get();

    if (identityResponse is json) {
        // Extract the contact_num from the JSON object
        string toNumber = check identityResponse.contact_num;
        string sms_message = "Your address request with request ID " + request.id + " has been " + request.status + ".";

        vs:NewMessage message = {
            api_key: api_key,
            'from: "Vonage APIs",
            to: toNumber, //to: user_contactNumber,
            api_secret: api_secret,
            text: sms_message
        };

        vs:InlineResponse200|error response = vsClient->sendAnSms(message);

        if response is error {
            log:printError("Error sending SMS: ", err = response.message());
        }

        return sms_message;
    } else {
        // Handle the case when the response is an error
        return identityResponse.toString();
    }
}

function initializeVsClient() returns vs:Client|error {
    // Initialize Vonage/Nexmo client
    vs:ConnectionConfig smsconfig = {};
    return check new vs:Client(smsconfig, serviceUrl = vonageServiceUrl);
}

vs:Client vsClient = check initializeVsClient();

isolated function getVsClient() returns vs:Client|error {
    // Initialize Vonage/Nexmo client
    vs:ConnectionConfig smsconfig = {};
    return check new vs:Client(smsconfig, serviceUrl = vonageServiceUrl);
}

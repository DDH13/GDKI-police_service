import ballerina/log;
import ballerina/uuid;
import ballerinax/mysql.driver as _;
import ballerina/time;
import ballerina/http;
import ballerinax/vonage.sms as vs;

isolated function getCitizen(string id) returns Citizen|error {
    Citizen|error citizen = dbclient->/citizens/[id];
    if citizen is error {
        return citizen;
    } else {
        return citizen;
    }
}

isolated function getCitizenByNIC(string nic) returns Citizen|error {
    Citizen[]|error citizens = from var citizen in dbclient->/citizens(targetType = Citizen)
        where citizen.nic == nic
        select citizen;
    if citizens is Citizen[] {
        return citizens[0];
    } else {
        return citizens;
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
    Offense[] offenses =  check getOffensesForCitizen(id) ?: [];
    if (offenses.length() > 0) {
        return true;
    } else {
        return false;
    }

}
    

isolated function addRequest(Citizen citizen,string reason, string gid) returns PoliceRequest|error {

    time:Utc tnow = time:utcNow();
    PoliceRequest request = {id: uuid:createType4AsString(), citizenId: citizen.id, status: "PENDING", appliedTime: tnow, reason: reason, gid: gid};
    string[]|error added = dbclient->/policerequests.post([request]);
    if added is error {
        return added;
    } else {
        return request;
    }
}

isolated function getRequest(string id) returns PoliceRequest|error {
    PoliceRequest|error request = dbclient->/policerequests/[id];
    if request is error {
        return request;
    } else {
        return request;
    }
}

isolated function getRequestsForCitizen(string id) returns PoliceRequest[]|error? {
    PoliceRequest[]|error? requests = from var request in dbclient->/policerequests(targetType = PoliceRequest)
        where request.citizenId == id
        select request;
    if requests is error {
        log:printError("Error while retrieving requests from the database", 'error = requests);
        return requests;
    } else {
        return requests;
    }
}

isolated function updateRequestStatus(string id, string status, Citizen citizen, vs:Client vsClient) returns string|error {
    PoliceRequest|error updated = dbclient->/policerequests/[id].put({status: status});
    if updated is error {
        return updated;
    } else {
        // Send SMS
        string _ = check sendSms(vsClient, citizen, updated);
        return id;
    }
}
isolated function checkCitizenHasValidIdentityRequests(string nic) returns boolean|error{
    string url = identity_url + "/identity/requests/validate/" + nic;
    http:Client NewClient = check new(url);
    boolean |error response = check NewClient->/.get();
    if (response is error) {
        return false;
    }
    return response;
}
isolated function checkCitizenHasValidAddressRequests(string nic) returns boolean|error{
    string url = address_url + "/address/requests/validate/" + nic;
    http:Client NewClient = check new(url);
    boolean |error response = check NewClient->/.get();
    if (response is error) {
        return false;
    }
    return response;


}

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

isolated function sendSms(vs:Client vsClient, Citizen citizen, PoliceRequest request) returns string|error {
    //string user_contactNumber = check dbclient->/citizens/[citizen.id].contactNumber;
    string sms_message = "Your police request with ID " + request.id + " has been " + request.status + ".";

    vs:NewMessage message = {
        api_key: api_key,
        'from: "Vonage APIs",
        to:"+94764378939",        //to: user_contactNumber,
        api_secret: api_secret,
        text: sms_message
    };

    vs:InlineResponse200|error response = vsClient->sendAnSms(message);

    if response is error {
        log:printError("Error sending SMS: ", err = response.message());
    }

    return sms_message;
}

function initializeVsClient() returns vs:Client | error {
    // Initialize Vonage/Nexmo client
    vs:ConnectionConfig smsconfig = {};
    return check new vs:Client(smsconfig, serviceUrl = vonageServiceUrl);
}

vs:Client vsClient = check initializeVsClient();

isolated function getVsClient() returns vs:Client | error {
    // Initialize Vonage/Nexmo client
    vs:ConnectionConfig smsconfig = {};
    return check new vs:Client(smsconfig, serviceUrl = vonageServiceUrl);
}

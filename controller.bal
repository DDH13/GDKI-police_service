import ballerina/http;
import ballerinax/vonage.sms as vs;

service /police on new http:Listener(8080) {
    isolated resource function get requests/[string nic]() returns PoliceRequest[]|error? {
        Citizen|error citizen = getCitizenByNIC(nic);
        if (citizen is Citizen) {
            return getRequestsForCitizen(citizen.id);
        } else {
            return citizen;
        }
    }

    isolated resource function post requests/[string nic]() returns PoliceRequest|error? {
        Citizen|error citizen = getCitizenByNIC(nic);
        vs:Client vsClient = check getVsClient();

        if (citizen is Citizen) {
            PoliceRequest addedrequest = check addRequest(citizen);
            boolean|error IdentityIsValid = checkCitizenHasValidIdentityRequests(nic);
            boolean|error AddressIsValid = checkCitizenHasValidAddressRequests(nic);
            boolean|error OffenseExists = checkOffenseExists(citizen.id); 

            if (IdentityIsValid is error || AddressIsValid is error || OffenseExists is error){
                check updateRequestStatus(addedrequest.id, "Rejected",citizen,vsClient);
                addedrequest.status = "Rejected";
            }
            if ( !(check IdentityIsValid) || !(check AddressIsValid) || check OffenseExists ){
                check updateRequestStatus(addedrequest.id, "Rejected",citizen,vsClient);
                addedrequest.status = "Rejected";
            }
             else {
                check updateRequestStatus(addedrequest.id, "Cleared",citizen,vsClient);
                addedrequest.status = "Cleared";
            }
            return addedrequest;
        } else {
            return citizen;
        }
    }

}


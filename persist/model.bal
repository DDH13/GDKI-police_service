import ballerina/persist as _;
import ballerina/time;

public type Citizen record {|
    readonly string id;
    string nic;
    string fullname;
    boolean isCriminal;
    Offense[] offenses;
    PoliceRequest[] requests;
|};

public type Offense record {|
    readonly string id;
    string offense;
    Citizen citizen;
|};

public type PoliceRequest record {|
    readonly string id;
    Citizen citizen;
    string status;
    string? reason;
    string gid;
    time:Utc appliedTime;
|};






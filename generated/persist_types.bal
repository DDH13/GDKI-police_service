// AUTO-GENERATED FILE. DO NOT MODIFY.
// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.
import ballerina/time;

public type Citizen record {|
    readonly string id;
    string nic;
    string fullname;
    boolean isCriminal;
|};

public type CitizenOptionalized record {|
    string id?;
    string nic?;
    string fullname?;
    boolean isCriminal?;
|};

public type CitizenWithRelations record {|
    *CitizenOptionalized;
    OffenseOptionalized[] offenses?;
    PoliceRequestOptionalized[] requests?;
|};

public type CitizenTargetType typedesc<CitizenWithRelations>;

public type CitizenInsert Citizen;

public type CitizenUpdate record {|
    string nic?;
    string fullname?;
    boolean isCriminal?;
|};

public type Offense record {|
    readonly string id;
    string offense;
    string citizenId;
|};

public type OffenseOptionalized record {|
    string id?;
    string offense?;
    string citizenId?;
|};

public type OffenseWithRelations record {|
    *OffenseOptionalized;
    CitizenOptionalized citizen?;
|};

public type OffenseTargetType typedesc<OffenseWithRelations>;

public type OffenseInsert Offense;

public type OffenseUpdate record {|
    string offense?;
    string citizenId?;
|};

public type PoliceRequest record {|
    readonly string id;
    string citizenId;
    string status;
    string? reason;
    string gid;
    time:Utc appliedTime;
|};

public type PoliceRequestOptionalized record {|
    string id?;
    string citizenId?;
    string status?;
    string? reason?;
    string gid?;
    time:Utc appliedTime?;
|};

public type PoliceRequestWithRelations record {|
    *PoliceRequestOptionalized;
    CitizenOptionalized citizen?;
|};

public type PoliceRequestTargetType typedesc<PoliceRequestWithRelations>;

public type PoliceRequestInsert PoliceRequest;

public type PoliceRequestUpdate record {|
    string citizenId?;
    string status?;
    string? reason?;
    string gid?;
    time:Utc appliedTime?;
|};


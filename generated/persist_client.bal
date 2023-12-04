// AUTO-GENERATED FILE. DO NOT MODIFY.
// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.
import ballerina/jballerina.java;
import ballerina/persist;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerinax/persist.sql as psql;

const CITIZEN = "citizens";
const OFFENSE = "offenses";
const POLICE_REQUEST = "policerequests";

public isolated client class Client {
    *persist:AbstractPersistClient;

    private final mysql:Client dbClient;

    private final map<psql:SQLClient> persistClients;

    private final record {|psql:SQLMetadata...;|} & readonly metadata = {
        [CITIZEN] : {
            entityName: "Citizen",
            tableName: "Citizen",
            fieldMetadata: {
                id: {columnName: "id"},
                nic: {columnName: "nic"},
                fullname: {columnName: "fullname"},
                isCriminal: {columnName: "isCriminal"},
                "offenses[].id": {relation: {entityName: "offenses", refField: "id"}},
                "offenses[].offense": {relation: {entityName: "offenses", refField: "offense"}},
                "offenses[].citizenId": {relation: {entityName: "offenses", refField: "citizenId"}},
                "requests[].id": {relation: {entityName: "requests", refField: "id"}},
                "requests[].citizenId": {relation: {entityName: "requests", refField: "citizenId"}},
                "requests[].status": {relation: {entityName: "requests", refField: "status"}},
                "requests[].reason": {relation: {entityName: "requests", refField: "reason"}},
                "requests[].appliedTime": {relation: {entityName: "requests", refField: "appliedTime"}}
            },
            keyFields: ["id"],
            joinMetadata: {
                offenses: {entity: Offense, fieldName: "offenses", refTable: "Offense", refColumns: ["citizenId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE},
                requests: {entity: PoliceRequest, fieldName: "requests", refTable: "PoliceRequest", refColumns: ["citizenId"], joinColumns: ["id"], 'type: psql:MANY_TO_ONE}
            }
        },
        [OFFENSE] : {
            entityName: "Offense",
            tableName: "Offense",
            fieldMetadata: {
                id: {columnName: "id"},
                offense: {columnName: "offense"},
                citizenId: {columnName: "citizenId"},
                "citizen.id": {relation: {entityName: "citizen", refField: "id"}},
                "citizen.nic": {relation: {entityName: "citizen", refField: "nic"}},
                "citizen.fullname": {relation: {entityName: "citizen", refField: "fullname"}},
                "citizen.isCriminal": {relation: {entityName: "citizen", refField: "isCriminal"}}
            },
            keyFields: ["id"],
            joinMetadata: {citizen: {entity: Citizen, fieldName: "citizen", refTable: "Citizen", refColumns: ["id"], joinColumns: ["citizenId"], 'type: psql:ONE_TO_MANY}}
        },
        [POLICE_REQUEST] : {
            entityName: "PoliceRequest",
            tableName: "PoliceRequest",
            fieldMetadata: {
                id: {columnName: "id"},
                citizenId: {columnName: "citizenId"},
                status: {columnName: "status"},
                reason: {columnName: "reason"},
                appliedTime: {columnName: "appliedTime"},
                "citizen.id": {relation: {entityName: "citizen", refField: "id"}},
                "citizen.nic": {relation: {entityName: "citizen", refField: "nic"}},
                "citizen.fullname": {relation: {entityName: "citizen", refField: "fullname"}},
                "citizen.isCriminal": {relation: {entityName: "citizen", refField: "isCriminal"}}
            },
            keyFields: ["id"],
            joinMetadata: {citizen: {entity: Citizen, fieldName: "citizen", refTable: "Citizen", refColumns: ["id"], joinColumns: ["citizenId"], 'type: psql:ONE_TO_MANY}}
        }
    };

    public isolated function init() returns persist:Error? {
        mysql:Client|error dbClient = new (host = host, user = user, password = password, database = database, port = port, options = connectionOptions);
        if dbClient is error {
            return <persist:Error>error(dbClient.message());
        }
        self.dbClient = dbClient;
        self.persistClients = {
            [CITIZEN] : check new (dbClient, self.metadata.get(CITIZEN), psql:MYSQL_SPECIFICS),
            [OFFENSE] : check new (dbClient, self.metadata.get(OFFENSE), psql:MYSQL_SPECIFICS),
            [POLICE_REQUEST] : check new (dbClient, self.metadata.get(POLICE_REQUEST), psql:MYSQL_SPECIFICS)
        };
    }

    isolated resource function get citizens(CitizenTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get citizens/[string id](CitizenTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post citizens(CitizenInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(CITIZEN);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from CitizenInsert inserted in data
            select inserted.id;
    }

    isolated resource function put citizens/[string id](CitizenUpdate value) returns Citizen|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(CITIZEN);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/citizens/[id].get();
    }

    isolated resource function delete citizens/[string id]() returns Citizen|persist:Error {
        Citizen result = check self->/citizens/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(CITIZEN);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get offenses(OffenseTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get offenses/[string id](OffenseTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post offenses(OffenseInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(OFFENSE);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from OffenseInsert inserted in data
            select inserted.id;
    }

    isolated resource function put offenses/[string id](OffenseUpdate value) returns Offense|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(OFFENSE);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/offenses/[id].get();
    }

    isolated resource function delete offenses/[string id]() returns Offense|persist:Error {
        Offense result = check self->/offenses/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(OFFENSE);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    isolated resource function get policerequests(PoliceRequestTargetType targetType = <>, sql:ParameterizedQuery whereClause = ``, sql:ParameterizedQuery orderByClause = ``, sql:ParameterizedQuery limitClause = ``, sql:ParameterizedQuery groupByClause = ``) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "query"
    } external;

    isolated resource function get policerequests/[string id](PoliceRequestTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor",
        name: "queryOne"
    } external;

    isolated resource function post policerequests(PoliceRequestInsert[] data) returns string[]|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(POLICE_REQUEST);
        }
        _ = check sqlClient.runBatchInsertQuery(data);
        return from PoliceRequestInsert inserted in data
            select inserted.id;
    }

    isolated resource function put policerequests/[string id](PoliceRequestUpdate value) returns PoliceRequest|persist:Error {
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(POLICE_REQUEST);
        }
        _ = check sqlClient.runUpdateQuery(id, value);
        return self->/policerequests/[id].get();
    }

    isolated resource function delete policerequests/[string id]() returns PoliceRequest|persist:Error {
        PoliceRequest result = check self->/policerequests/[id].get();
        psql:SQLClient sqlClient;
        lock {
            sqlClient = self.persistClients.get(POLICE_REQUEST);
        }
        _ = check sqlClient.runDeleteQuery(id);
        return result;
    }

    remote isolated function queryNativeSQL(sql:ParameterizedQuery sqlQuery, typedesc<record {}> rowType = <>) returns stream<rowType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor"
    } external;

    remote isolated function executeNativeSQL(sql:ParameterizedQuery sqlQuery) returns psql:ExecutionResult|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.sql.datastore.MySQLProcessor"
    } external;

    public isolated function close() returns persist:Error? {
        error? result = self.dbClient.close();
        if result is error {
            return <persist:Error>error(result.message());
        }
        return result;
    }
}


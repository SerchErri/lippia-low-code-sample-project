Feature: Time entry

  Background:
    Given base url $(env.base_url_clockify)
    And header Content-Type = application/json
    And header x-api-key = $(env.ApiKey)

      #b. Agregar horas a un proyecto
  @AddNewTimeEntry
  Scenario: Add a new time entry
    Given endpoint /v1/workspaces/$(env.workSpaceId)/time-entries
    And body jsons/bodies/AddNewTimeEntry.json
    When execute method POST
    * print response
    Then the status code should be 201
    And validate schema jsons/schemas/responseAddNewTimeEntry.json
    * define timeEntryId = $.customFieldValues.[0].timeEntryId
    * define userId = $.userId

#Preguntar porque no la toma si lo llamamos del lippia config.
#----------------E R R O R -------------------------------------
# Consultar las horas registradas en un WorkSpace
  @GetTimeEntryWorkSpace
  Scenario: Get a specific time entry on workspace
    Given endpoint /v1/workspaces/$(env.workSpaceId)/time-entries/684e06b5d38f97630086ab7f
    When execute method GET
    * print response
    Then the status code should be 200
    And validate schema jsons/schemas/GetTimeEntryWorkSpace.json

     # Consultar las horas registradas en progreso
  @GetProgressTimeEntry
  Scenario: Get all in progress time entries on workspace
    Given endpoint /v1/workspaces/$(env.workSpaceId)/time-entries/status/in-progress
    When execute method GET
    Then the status code should be 200

    #c. Editar un campo de algún registro de hora
  @BulkEditTimeEntries
  Scenario: Bulk edit time entries
    Given endpoint /v1/workspaces/$(env.workSpaceId)/time-entries/684e3c80dec32738ba10ac15
    And set value "Sprint3" of key description in body jsons/bodies/bodyBuelkEditTimeEntries.json
    When execute method PUT
    Then the status code should be 200
    And response should be $.description = "Sprint3"

  #d. Eliminar hora registrada
  @DeleteTimeEntryWorkspace
  Scenario: Delete time entry from workspace
    Given endpoint /v1/workspaces/$(env.workSpaceId)/time-entries/684e3c80dec32738ba10ac15
    When execute method DELETE
    * print response
    Then the status code should be 204



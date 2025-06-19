Feature: Time entry

  Background:
    Given base url $(env.base_url_clockify)
    And header Content-Type = application/json
    And header x-api-key = $(env.ApiKey)
    #* define workSpaceId = $(env.workSpaceId)
    * define workSpaceId = 67ff1553e20b814cf76ed5af

      #b. Agregar horas a un proyecto
  @AddNewTimeEntry
  Scenario: Add a new time entry
    Given endpoint /v1/workspaces/{{workSpaceId}}/time-entries
    And body jsons/bodies/AddNewTimeEntry.json
    When execute method POST
    * print response
    Then the status code should be 201
    And validate schema jsons/schemas/responseAddNewTimeEntry.json
     * define userId = $.userId
    * define timeEntryId = $.id


  # Consultar las horas registradas en progreso
  @GetProgressTimeEntry
  Scenario: Get all in progress time entries on workspace
    Given endpoint /v1/workspaces/{{workSpaceId}}/time-entries/status/in-progress
    When execute method GET
    * print response
    Then the status code should be 200

    #c. Editar un campo de algún registro
  @BulkEditTimeEntries
  Scenario: Bulk edit time entries
    Given endpoint /v1/workspaces/{{workSpaceId}}/time-entries/68538523c718830da9cc0a58
    And set value "Sprint6" of key description in body jsons/bodies/bodyBulkEditTimeEntries.json
    When execute method PUT
    * print response
    Then the status code should be 200
    And response should be $.description = "Sprint6"

  #d. Eliminar hora registrada
  @DeleteTimeEntryWorkspace
  Scenario: Delete time entry from workspace
    Given endpoint /v1/workspaces/{{workSpaceId}}/time-entries/68538523c718830da9cc0a58
    When execute method DELETE
    * print response
    Then the status code should be 204



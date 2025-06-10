Feature: Clockify

  Background:
    Given base url https://api.clockify.me/api


  Scenario: Add a new project
    Given call WorkSpace.feature@CreateWorkspace
    And base url https://api.clockify.me/api
    And endpoint /v1/workspaces/{{workspaceId}}/projects
    And header x-api-key = "NzlhNWNjYmEtZjU2NS00ZmM1LWFlNGYtNjk4MDczMDlmMGRl"
    And header Content-Type = "application/json"
    And set value "Proyecto" of key name in body jsons/bodies/bodyNewProject.json
    When execute method POST
    Then the status code should be 201
    And response should be $.name = "Proyecto"
    And validate schema jsons/schemas/responseNewProject.json
    * define projectId = $.id


  Scenario: Find project by ID
    Given call WorkSpace.feature@AddNewProject
    And endpoint /v1/workspaces/{{workspaceId}}/projects/{{projectId}}
    And header x-api-key = "NzlhNWNjYmEtZjU2NS00ZmM1LWFlNGYtNjk4MDczMDlmMGRl"
    And header Content-Type = "application/json"
    When execute method GET
    Then the status code should be 200
    And response should be $.projectId = $.id




    #----------------------------------- ERRORES REVISAR
  #* definiciones de variables y que las traiga

  # este escenario @UpdateProject
  #  Scenario: Update project on workspace
  #    Given call Projects.feature@FindProjectByID
  #    And endpoint /v1/workspaces/684261e7f6059c750cb5edc9/clients
  #    And header x-api-key = "NzlhNWNjYmEtZjU2NS00ZmM1LWFlNGYtNjk4MDczMDlmMGRl"
  #    And header Content-Type = "application/json"
  #    And set value <name> of key name in body jsons/bodies/addNewClient.json
  #    When execute method POST
  #    Then the status code should be 201
  #    And response should be $.name = <name>
  #    * define idClient = $.id

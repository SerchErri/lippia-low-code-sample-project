Feature: Clockify

  Background:
    Given base url https://api.clockify.me/api


  @AddNewProject #OK
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


  @FindProjectByID #OK
  Scenario: Find project by ID
    Given call WorkSpace.feature@CreateWorkspace
    And call Projects.feature@AddNewProject
    And endpoint /v1/workspaces/{{workspaceId}}/projects/{{projectId}}
    And header x-api-key = "NzlhNWNjYmEtZjU2NS00ZmM1LWFlNGYtNjk4MDczMDlmMGRl"
    And header Content-Type = "application/json"
    When execute method GET
    Then the status code should be 200
    And response should be $.id = "{{projectId}}"

  @AddNewProjectNegative #OK
  Scenario Outline: Validate required fields for Add New Project
    Given call Projects.feature@AddNewProject
    And endpoint /v1/workspaces/{{workspaceId}}/projects
    And header x-api-key = "NzlhNWNjYmEtZjU2NS00ZmM1LWFlNGYtNjk4MDczMDlmMGRl"
    And header Content-Type = "application/json"
    And set value <invalidValue> of key <fieldPath> in body jsons/bodies/bodyNewProject.json
    When execute method POST
    Then the status code should be <expectedStatus>
    And response should be $.message = <expectedErrorMessage>
    And validate schema jsons/schemas/responseAddProjectNegative.json

    Examples: # A veces el caso 2 da error, dice que esperaba una cosa y dio otr y viceversa, se trula a veces!
      | fieldPath | invalidValue | expectedStatus | expectedErrorMessage                 |
      | name      | null         | 400            | "Se requiere el nombre del proyecto" |
      | name      | ""           | 400            | "Se requiere el nombre del proyecto" |


  @UpdateProjectUserRate #OK
  Scenario: Update project user cost rate
    Given call Projects.feature@AddNewProject
    And endpoint /v1/workspaces/{{workspaceId}}/projects/{{projectId}}/memberships
    And header x-api-key = "NzlhNWNjYmEtZjU2NS00ZmM1LWFlNGYtNjk4MDczMDlmMGRl"
    And header Content-Type = "application/json"
    And set value 200 of key amount in body jsons/bodies/bodyUpdateUserRate.json
    When execute method PATCH
    Then the status code should be 200
    And response should be $.id = "{{projectId}}"

  @MessageNegative #OK
  Scenario Outline: Validate error 401 y 404
    Given call Projects.feature@AddNewProject
    And endpoint "<endpoint>"
    And header x-api-key = "<apiKey>"
    And header Content-Type = "application/json"
    When execute method GET
    Then the status code should be <expectedStatus>
    And response should be $.message = <expectedErrorMessage>
    And validate schema jsons/schemas/responseAddProjectNegative.json

    Examples:
      | endpoint                                          | apiKey                                           | expectedStatus | expectedErrorMessage                                                   |
      | /v1/workspaces/684261e7f6059c750cb5edc9/projects  | INVALID_API_KEY                                  | 401            | "Api key does not exist"                                               |
      | /v1/workspaces/684261e7f6059c750cb5edc9/projectsZ | NzlhNWNjYmEtZjU2NS00ZmM1LWFlNGYtNjk4MDczMDlmMGRl | 404            | "No static resource v1/workspaces/684261e7f6059c750cb5edc9/projectsZ." |

  @MessageNegative400 #OK
  Scenario: Validate error 400
    Given call WorkSpace.feature@CreateWorkspace
    And base url https://api.clockify.me/api
    And endpoint /v1/workspaces/{{workspaceId}}/projects
    And header x-api-key = "NzlhNWNjYmEtZjU2NS00ZmM1LWFlNGYtNjk4MDczMDlmMGRl"
    And header Content-Type = "application/json"
    And set value "Debe dar Error" of key id in body jsons/bodies/bodyBadRequest.json
    When execute method POST
    Then the status code should be 400
    And response should be $.code = 501
    And validate schema jsons/schemas/responseNewProject.json

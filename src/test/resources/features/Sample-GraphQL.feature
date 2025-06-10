@graphQl-sample @Sample
Feature: example Stars Wars with Graphql


  @getAllFilms
  Scenario: get all films of saga
    Given base url $(env.base_url_starWars)
    And endpoint /.netlify/functions/index
    And header Content-Type = application/json
    And header Accept = */*
    And body jsons/bodies/getAllFilms.json
    When execute method POST
    Then the status code should be 200
    * define idFilm = $.data.allFilms.films.[0].id

  @execute
  Scenario: get film of saga by id
    Given call Sample-GraphQL.feature@getAllFilms
    And base url https://swapi-graphql.netlify.app
    And endpoint /.netlify/functions/index
    And header Content-Type = application/json
    And header Accept = */*
    And set value "{{idFilm}}" of key variables.filmId in body jsons/bodies/getFilm.json
    When execute method POST
    Then the status code should be 200


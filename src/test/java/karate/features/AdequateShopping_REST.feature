@adequateshop.com
Feature: Test REST api calls on adequateshop.com

  # Get the registration done with unique email id to retrieve auth token
  Background:
    * def generateRand =
    """
      function()
      {
         return java.util.UUID.randomUUID()
      }
    """
    * def registerRequest =
    """
      {
      name: "",
      email: "",
      password : ""
      }
    """
    * set registerRequest.name = generateRand()
    * set registerRequest.email = generateRand() + '@test.com'
    * set registerRequest.password = generateRand()
    Given url adequateShopUrl
    And path 'authaccount','registration'
    And request registerRequest
    When method post
    Then status 200
    And response.message == 'success'
    # store the registration token to use for login call
    * def regToken = response.data.Token
    # Log in
    * header Authorization = 'Bearer ' + regToken
    Given path 'authaccount', 'login'
    * def reqLogin = {   "email": "",  "password": "" }
    And set reqLogin.email = registerRequest.email
    And set reqLogin.password = registerRequest.password
    And request reqLogin
    When method post
    Then status 200
    # Store Log in token from response to be used for all API calls
    * def token = response.data.Token
    # Use the token for authorization
    * def authheader =
    """
      function()
      {
       return {
        Authorization : 'Bearer ' + token
        };
      }
    """
    * configure headers = authheader()

  @getUsers-adequate
  Scenario: GET all Users
    Given path 'users'
    Given param page = '1'
    When method get
    Then status 200
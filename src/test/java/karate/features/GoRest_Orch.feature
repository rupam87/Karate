Feature: Test API Orchestration on GoRest Public API

  Background:
    * url goRestUrl
    * def randString =
      """
      function()
      {
        return java.util.UUID.randomUUID() + ''
       }
      """
    * def bearerToken = '75d58bf991b7ad2730b72881d7de268d410101b9bbab38ee963fe6abd98f6108'
    * def getHeaders =
      """
        function()
        {
          return {
          Authorization: 'Bearer ' + bearerToken
          };
        }
      """
    * configure headers = getHeaders()
   # * header Authorization = 'Bearer ' + bearerToken


  @GetUsers @all
  Scenario: Get Users
    Given path 'v2/users', '13'
    When method get
    Then print response
    * def val = ''
    * if(response.gender=='male') karate.set('val', response.name)
    * print 'Gender is Male :', val

  @PostUser @all
  Scenario Outline: Post a user
    Given path 'v2/users'
    #* def requestJson = {name: '', email:'', gender:'', status:''}
    * def requestJson = read('classpath:Data/GoRest_CreateUserRequest.json')
    * set requestJson.name = "<name>" + randString()
    * set requestJson.email = randString() + "<email>"
    * set requestJson.gender = "<gender>"
    * set requestJson.status = "<status>"
    And print requestJson
    And request requestJson
    When method post
    # Verify POST is successful by matching Response Schema and JSON contents
    Then status 201
    #* def responseJson = {id: '', name: '', email:'', gender:'', status:''}
    * def responseJson = read('classpath:Data/GoRest_CreateUserResponse.json')
    * set responseJson.id = response.id
    * set responseJson.name = response.name
    * set responseJson.email = response.email
    * set responseJson.gender = "<gender>"
    * set responseJson.status = "<status>"
    And match response == responseJson
    And match response == {id: '#number', name:'#string', email:'#string', gender:'#string', status:'#string'}
    * def expResponse = response
    # Store the User Id created to be deleted later
    * def createdUserId = response.id
    And print expResponse
    # Retrieve all users and retry until the newly created user is not reflected in the response
    Given path 'v2/users'
    #* header Authorization = 'Bearer ' + bearerToken
    And retry until karate.match("response contains expResponse").pass
    When method get
    Then match response contains expResponse
    # Delete the newly created user by using the id in the path
    Given path 'v2/users', createdUserId
    #* header Authorization = 'Bearer ' + bearerToken
    When method delete
    Then status 204
    * print 'User Deleted with Id: ' + createdUserId
    # Query the User to verify deletion has happened
    Given path 'v2/users', createdUserId
    #* header Authorization = 'Bearer ' + bearerToken
    When method get
    Then status 404
    And response.message = 'Resource not found'
    * print 'Successfully Verified that User is deleted with Id: ' + createdUserId
    Examples:
      | name          | email           | gender | status |
      | Newman Norman | new.man@nor.man | male   | active |


  @GetTODO @all
  Scenario: Get TODO Api
    Given path 'v2/todos'
    When method get
    Then status 200
    * def pendingStatusList = []
    * def fun =
        """
        function(x)
        {
          if(x.status == 'pending') karate.appendTo(pendingStatusList, x.user_id);
        }
        """
    * karate.forEach(response, fun)
    * print 'User Ids Extracted:', pendingStatusList
    Given path 'v2/users', pendingStatusList[0]
    When method get
    Then print response

  @calculator
  Feature: Test SOAP API on http://www.dneonline.com/calculator.asmx

    Background:
      * url soapCalculatorUrl

    @add1 @add
    Scenario: Calculator Add (Soap 1.1)
      Given request
      """
      <?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <Add xmlns="http://tempuri.org/">
            <intA>2</intA>
            <intB>3</intB>
          </Add>
        </soap:Body>
      </soap:Envelope>
      """
      When soap action 'http://tempuri.org/Add'
      Then status 200
      And match /Envelope/Body/AddResponse/AddResult == '5'
      And print 'response: ', response

    @add2 @add
    Scenario: soap 1.2
      * def req = read('classpath:Data/Calc_AddRequest.xml')
      * set req /Envelope/Body/Add/intA = '12'
      * set req /Envelope/Body/Add/intB = '15'
      Given request req
    # soap is just an HTTP POST, so here we set the required header manually ..
      And header Content-Type = 'application/soap+xml; charset=utf-8'
    # .. and then we use the 'method keyword' instead of 'soap action'
      When method post
      Then status 200
      * def expResp = read('classpath:Data/Calc_AddExpected.xml')
      * set expResp /Envelope/Body/AddResponse/AddResult = '27'
      * print expResp
      * print response
    # note how we focus only on the relevant part of the payload and read expected XML from a file
      And match response == expResp
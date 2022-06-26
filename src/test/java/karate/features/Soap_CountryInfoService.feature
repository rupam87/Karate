Feature: CountryInfo SOAP Service Tests

  Background:
    * url 'http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso'
    * def headerinfo =
    """
      function (){
      return {
        'Content-Type' : 'text/xml; charset=utf-8'
      };
      }
    """
    * configure headers  = headerinfo()

    @FullCountryInfo
    Scenario: Get Full Country Info
      Given request
      """
      <?xml version="1.0" encoding="utf-8"?>
      <soap12:Envelope xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Body>
          <FullCountryInfoAllCountries xmlns="http://www.oorsprong.org/websamples.countryinfo"/>
        </soap12:Body>
      </soap12:Envelope>
      """
      When method post
      Then status 200
      * print response
      * def expXml =
      """
      <?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
              <m:FullCountryInfoAllCountriesResponse xmlns:m="http://www.oorsprong.org/websamples.countryinfo">
                  <m:FullCountryInfoAllCountriesResult>
                      <m:tCountryInfo>
                          <m:sISOCode>AD</m:sISOCode>
                          <m:sName>Andorra</m:sName>
                          <m:sCapitalCity>Andorra La Ville</m:sCapitalCity>
                          <m:sPhoneCode>371</m:sPhoneCode>
                          <m:sContinentCode>EU</m:sContinentCode>
                          <m:sCurrencyISOCode>EUR</m:sCurrencyISOCode>
                          <m:sCountryFlag>http://www.oorsprong.org/WebSamples.CountryInfo/Flags/Andorra.jpg</m:sCountryFlag>
                      </m:tCountryInfo>
                      <m:tCountryInfo>
                          <m:sISOCode>AE</m:sISOCode>
                          <m:sName>United Arab Emirates</m:sName>
                          <m:sCapitalCity>Abu Dhabi</m:sCapitalCity>
                          <m:sPhoneCode>971</m:sPhoneCode>
                          <m:sContinentCode>AS</m:sContinentCode>
                          <m:sCurrencyISOCode>AED</m:sCurrencyISOCode>
                          <m:sCountryFlag>http://www.oorsprong.org/WebSamples.CountryInfo/Flags/United_Arab_Emirates.jpg</m:sCountryFlag>
                          <m:Languages>
                            <m:tLanguage>
                              <m:sISOCode>ara</m:sISOCode>
                              <m:sName>Arabic</m:sName>
                            </m:tLanguage>
                          </m:Languages>
                      </m:tCountryInfo>
                   </m:FullCountryInfoAllCountriesResult>
               </m:FullCountryInfoAllCountriesResponse>
          </soap:Body>
      </soap:Envelope>
      """
      And match response contains deep expXml
      And match response /Envelope/Body/FullCountryInfoAllCountriesResponse/FullCountryInfoAllCountriesResult/tCountryInfo[2]/sISOCode  == 'AE'
      And match response /Envelope/Body/FullCountryInfoAllCountriesResponse/FullCountryInfoAllCountriesResult/tCountryInfo[1] contains deep
      """
      <?xml version="1.0" encoding="utf-8"?>
        <m:tCountryInfo>
          <m:Languages>
            <m:tLanguage>
              <m:sISOCode>#string</m:sISOCode>
              <m:sName>Catalan</m:sName>
            </m:tLanguage>
          </m:Languages>
        </m:tCountryInfo>
      """



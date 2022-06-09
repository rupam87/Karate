function fn() {

    var env = karate.env; // get java system property 'karate.env'
      karate.log('karate.env system property was:', env);
      if (!env) {
        env = 'dev'; // a custom 'intelligent' default
        karate.log('karate.env system property is set to default:', env);
      }

    var config = {
        goRestUrl : 'https://gorest.co.in/public/',
        reqResUrl : 'https://reqres.in/',
        adequateShopUrl : 'http://restapi.adequateshop.com/api/',
        someUrlBase : ''
    }

    if (env == 'stage') {
        // over-ride only those that need to be
        config.someUrlBase = 'https://stage-host/v1/auth';
      } else if (env == 'qa') {
        config.someUrlBase = 'https://e2e-host/v1/auth';
      }

    karate.configure('retry',{ count:5, interval:5000});
    karate.configure('connectTimeout', 5000);
    karate.configure('readTimeout', 5000);

    return config;
 }
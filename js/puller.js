(function() {
  var callRest, counter, cron, fs, j, k, l, logger, m, n, o, p, rest, running, timeoutTime, updateEveryFourHours, updateHourly, writeFile;

  rest = require('unirest');

  fs = require('fs');

  cron = require('node-schedule');

  console.log('initialized');

  running = false;

  timeoutTime = 50 * 1000;

  counter = 0;


  /*
  Make a call to a restfull service
  the answer is stored in a cache folder for debugging
  
  addr {string} address to the service
   */

  callRest = function(addr) {
    running = true;
    console.log('--> Making the question');
    return rest.get(addr).end(function(response) {
      running = false;
      console.log('<-- Response getted' + counter++);
      return writeFile('C:/apps/oee-monitor/cache/response' + ++counter + '.json', JSON.stringify(response));
    });
  };


  /*
  just print in the console information to know the service is alive
   */

  logger = function() {
    return console.log('Still alive --> ' + counter++);
  };


  /*
  Wrapper to native fs.writeFile so i can handle errors in a single place
  
  address {string} Path to file
  content {string} Content of the file
   */

  writeFile = function(address, content) {
    return fs.writeFile(address, content, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return console.log('File saved');
      }
    });
  };


  /*
  Functions to be user by the scheduler
   */

  updateHourly = function() {
    return callRest('http://wmatvmlr401/lr4/oee-monitor/index.php/update/hourly');
  };

  updateEveryFourHours = function() {
    return callRest('http://wmatvmlr401/lr4/oee-monitor/index.php/update/four_ours');
  };


  /*
  Scheduler
   */

  j = cron.scheduleJob('0 30 6  * * *', updateEveryFourHours);

  k = cron.scheduleJob('0 30 10 * * *', updateEveryFourHours);

  l = cron.scheduleJob('0 30 14 * * *', updateEveryFourHours);

  m = cron.scheduleJob('0 30 22 * * *', updateEveryFourHours);

  n = cron.scheduleJob('0 30 2  * * *', updateEveryFourHours);

  o = cron.scheduleJob('0 0 * * * *', updateHourly);

  p = cron.scheduleJob('*/5 * * * * *', logger);

}).call(this);

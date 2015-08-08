(function() {
  var callRest, counter, cron, fs, j, k, l, logger, m, n, o, p, rest, running, timeoutTime, updateHourly, writeFile;

  rest = require('unirest');

  fs = require('fs');

  cron = require('node-schedule');

  console.log('initialized');

  running = false;

  timeoutTime = 50 * 1000;

  counter = 0;

  callRest = function(addr) {
    running = true;
    console.log('--> Making the question');
    return rest.get(addr).end(function(response) {
      running = false;
      console.log('<-- Response getted');
      return writeFile('C:/apps/oee-monitor/cache/response' + ++counter + '.json', JSON.stringify(response));
    });
  };

  logger = function() {
    return console.log('Still alive');
  };

  writeFile = function(address, content) {
    return fs.writeFile(address, content, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return console.log('File saved');
      }
    });
  };

  updateHourly = function() {
    return callRest('http://wmatvmlr401/lr4/oee-monitor/index.php/update/hourly');
  };

  j = cron.scheduleJob('0 30 6  * * *', updateHourly);

  k = cron.scheduleJob('0 30 10 * * *', updateHourly);

  l = cron.scheduleJob('0 30 14 * * *', updateHourly);

  m = cron.scheduleJob('0 30 22 * * *', updateHourly);

  n = cron.scheduleJob('0 30 2  * * *', updateHourly);

  o = cron.scheduleJob('0  */15 *  * * *', updateHourly);

  p = cron.scheduleJob('*/5  * *  * * *', logger);

}).call(this);

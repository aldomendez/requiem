(function() {
  var callRest, counter, cron, fs, j, k, l, logger, m, n, o, p, rest, running, timeoutTime, writeFile;

  rest = require('unirest');

  fs = require('fs');

  cron = require('node-schedule');

  console.log('initialized');

  running = false;

  timeoutTime = 50 * 1000;

  counter = 0;

  callRest = function() {
    running = true;
    console.log('Making the question');
    return rest.get('http://wmatvmlr401/lr4/oee-monitor/index.php/update/target').end(function(response) {
      running = false;
      console.log('Response getted');
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

  j = cron.scheduleJob('0 30 6  * * *', callRest);

  k = cron.scheduleJob('0 30 10 * * *', callRest);

  l = cron.scheduleJob('0 30 14 * * *', callRest);

  m = cron.scheduleJob('0 30 22 * * *', callRest);

  n = cron.scheduleJob('0 30 2  * * *', callRest);

  o = cron.scheduleJob('0  0 */1  * * *', callRest);

  p = cron.scheduleJob('*/5  * *  * * *', logger);

}).call(this);

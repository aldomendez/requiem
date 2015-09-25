(function() {
  var SERVICEPARAMETERS, _, analitics, callRest, checksum, counter, cron, emailjs, fs, j, logger, mailTest, o, p, rest, running, server, timeoutTime, updateEveryFourHours, updateHourly, writeFile;

  rest = require('unirest');

  fs = require('fs');

  cron = require('node-schedule');

  checksum = require('checksum');

  emailjs = require('emailjs');

  analitics = require('./analitics');

  _ = require('underscore');

  SERVICEPARAMETERS = {
    user: process.env['notificationUser'],
    password: process.env['notificationPassword'],
    host: 'smtp.gmail.com',
    tls: true,
    port: 587
  };

  server = emailjs.server.connect(SERVICEPARAMETERS);

  mailTest = function() {
    return server.send({
      from: 'OEE Monitor <cyopticsmexico@gmail.com>',
      to: 'aldo.mendez@avagotech.com',
      subject: 'Mira sin manos',
      text: 'Prueba para el envio de notificaciones por <correo></correo>'
    }, function(error, message) {
      return console.log(error);
    });
  };

  running = false;

  timeoutTime = 50 * 1000;

  counter = 0;


  /*
  Make a call to a restfull service
  the answer is stored in a cache folder for debugging
  
  addr {string} address to the service
   */

  callRest = function(addr, callback) {
    running = true;
    console.log('--> Making the question');
    return rest.get(addr).end(function(response) {
      var cs;
      running = false;
      cs = checksum(JSON.stringify(response.body));
      console.log('<-- Response getted ' + cs);
      return writeFile('C:/apps/oee-monitor/cache/' + cs + '.json', response.body);
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
    console.log('File updated by 1 hour');
    return callRest('http://wmatvmlr401/lr4/oee-monitor/index.php/update/hourly', function(data) {});
  };

  updateHourly();

  updateEveryFourHours = function() {
    console.log('File updated by 4 hour');
    return callRest('http://wmatvmlr401/lr4/oee-monitor/index.php/update/four_ours');
  };


  /*
  Scheduler
   */

  j = cron.scheduleJob('0 30 6,10,14,22,2  * * *', updateEveryFourHours);

  o = cron.scheduleJob('0 0 * * * *', updateHourly);

  p = cron.scheduleJob('*/5 * * * * *', logger);

}).call(this);

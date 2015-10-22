(function() {
  var SERVICEPARAMETERS, _, analitics, callRest, checksum, counter, cron, dateFormat, emailjs, fs, j, logger, mailTest, o, rest, running, server, testService, timeoutTime, updateEveryFourHours, updateHourly, writeFile;

  rest = require('unirest');

  fs = require('fs');

  cron = require('node-schedule');

  checksum = require('checksum');

  emailjs = require('emailjs');

  analitics = require('./analitics');

  dateFormat = require('dateformat');

  _ = require('underscore');

  console.log("Awaken: " + dateFormat(new Date(), "dddd, mmmm dS, yyyy, h:MM:ss TT"));

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
    console.log("Calling home: " + dateFormat(new Date(), "dddd, mmmm dS, yyyy, h:MM:ss TT"));
    console.log('--> Making the question');
    return rest.get(addr).end(function(response) {
      var cs;
      running = false;
      cs = checksum(JSON.stringify(response.body));
      console.log('<-- Response getted ' + cs);
      writeFile('C:/apps/oee-monitor/cache/' + cs + '.json', response.body);
      if (callback != null) {
        return callback(JSON.parse(response.body));
      }
    });
  };


  /*
  just print in the console information to know the service is alive
   */

  logger = function() {
    var dt;
    dt = new Date();
    return console.log("Still alive -->  " + (counter++) + " " + (dt.toString()));
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

  testService = function() {
    console.log('File updated by 1 hour');
    return callRest('http://wmatvmlr401/lr4/oee-monitor/index.php/update/hourly', function(data) {
      return analitics.analize(data);
    });
  };

  updateHourly = function() {
    console.log('File updated by 1 hour');
    return callRest('http://wmatvmlr401/lr4/oee-monitor/index.php/update/hourly');
  };

  updateEveryFourHours = function() {
    console.log('File updated by 4 hour');
    return callRest('http://wmatvmlr401/lr4/oee-monitor/index.php/update/four_ours');
  };


  /*
  Scheduler
   */

  j = cron.scheduleJob('0 30 6  * * *', updateEveryFourHours);

  j = cron.scheduleJob('0 30 10  * * *', updateEveryFourHours);

  j = cron.scheduleJob('0 30 14  * * *', updateEveryFourHours);

  j = cron.scheduleJob('0 30 18  * * *', updateEveryFourHours);

  j = cron.scheduleJob('0 30 22  * * *', updateEveryFourHours);

  j = cron.scheduleJob('0 30 2  * * *', updateEveryFourHours);

  o = cron.scheduleJob('0 0 * * * *', updateHourly);

}).call(this);

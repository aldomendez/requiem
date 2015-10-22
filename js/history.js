(function() {
  var _, addToQueue, async, callRest, checksum, dateFormat, final, fs, interval, options, parser, q, rest, updateDatabase, writeFile;

  rest = require('unirest');

  fs = require('fs');

  checksum = require('checksum');

  dateFormat = require('dateformat');

  _ = require('underscore');

  parser = require('cron-parser');

  async = require('async');

  q = async.queue(function(task, callback) {
    console.log(task.final);
    return updateDatabase(task.inicio, task.final, callback);
  }, 1);

  q.drain = function() {
    return console.log('All items have been processed');
  };

  console.log("Awaken: " + dateFormat(new Date(), "dddd, mmmm dS, yyyy, h:MM:ss TT"));

  callRest = function(addr, callback) {
    var running;
    running = true;
    console.log(addr);
    console.log('--> Making the question');
    return rest.get(addr).end(function(response) {
      var cs;
      running = false;
      cs = checksum(JSON.stringify(response.body));
      console.log('<-- Response getted ' + cs);
      writeFile('C:/apps/oee-monitor/cache/' + cs + '.html', response.body);
      if (callback != null) {
        return callback();
      }
    });
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

  updateDatabase = function(inicio, final, callback) {
    console.log('File updated by 1 hour');
    return callRest("http://wmatvmlr401/lr4/oee-monitor/index.php/update/all/" + inicio + "/" + final, callback);
  };

  options = {
    currentDate: new Date(2015, 0, 1),
    endDate: new Date(),
    iterator: true
  };

  interval = parser.parseExpression('0 30 2,6,10,14,18,22  * * *', options);

  final = interval.next();

  q.drain = function() {
    return addToQueue();
  };

  addToQueue = function() {
    var e, i, inicio, results;
    try {
      i = 20;
      results = [];
      while (i >= 0) {
        try {
          inicio = final;
          final = interval.next();
          console.log("inicio: " + (dateFormat(inicio.value, 'yyyy-mm-dd HH:MM')) + ", final: " + (dateFormat(final.value, 'yyyy-mm-dd HH:MM')));
          q.push({
            'inicio': dateFormat(inicio.value, 'yyyy-mm-dd HH:MM'),
            'final': dateFormat(final.value, 'yyyy-mm-dd HH:MM')
          });
          results.push(i--);
        } catch (_error) {
          e = _error;
          break;
        }
      }
      return results;
    } catch (_error) {
      e = _error;
      return console.log("Error: " + e.message);
    }
  };

  addToQueue();

}).call(this);

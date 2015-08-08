(function() {
  var a, callRest, fs, rest, running, timeoutTime, writeFile;

  rest = require('unirest');

  fs = require('fs');

  running = false;

  timeoutTime = 50 * 1000;

  a = function(timeout) {
    var interval;
    if (!running) {
      return interval = (function(_this) {
        return function() {
          return setTimeout(callRest, timeout);
        };
      })(this)();
    }
  };

  callRest = function() {
    running = true;
    console.log('Running call');
    return rest.get('http://cymautocert/osaapp/semaforo-dev/toolbox.php?action=updateTables').end(function(response) {
      running = false;
      console.log('response geted');
      writeFile('C:\\apps\\node-win\\response.txt', JSON.stringify(response));
      return a(timeoutTime);
    });
  };

  writeFile = function(address, content) {
    return fs.writeFile(address, content, function(err) {
      if (err) {
        console.log(err);
        return console.log('File saved');
      }
    });
  };

  a(timeoutTime);

}).call(this);

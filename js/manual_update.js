(function() {
  var capitalize, date, hhmm, intervalsFactory, month, recordsInDatabase;

  capitalize = function(str) {
    return str.split('').map(function(el, i) {
      if (i === 0) {
        return el.toUpperCase();
      } else {
        return el;
      }
    }).join('');
  };

  month = function(dt) {
    return "ene feb mar abr may jun jul ago sep oct nov dic".split(' ')[dt.getMonth()];
  };

  date = function(dt) {
    return dt.getDate();
  };

  hhmm = function(dt) {
    return (dt.getHours()) + ":" + (dt.getMinutes());
  };

  Vue.filter('to', function(start, finish) {
    if (start.getDate() === finish.getDate()) {
      return (capitalize(month(start))) + " " + (date(start)) + " " + (hhmm(start)) + "-" + (hhmm(finish));
    } else {
      return (capitalize(month(start))) + " " + (date(start)) + " " + (hhmm(start)) + "- " + (capitalize(month(start))) + " " + (date(finish)) + " " + (hhmm(finish));
    }
  });


  /*
  Calculates the intervals we will work at
   */

  intervalsFactory = function() {
    var hours, intervals, now, x;
    now = new Date();
    hours = (function() {
      var j, results;
      results = [];
      for (x = j = 0; j <= 48; x = j += 4) {
        results.push(new Date(now.getFullYear(), now.getMonth(), now.getDate(), x + 2 - 24, 30));
      }
      return results;
    })();
    hours = _.filter(hours, function(el) {
      return el < now;
    });
    hours.splice(0, hours.length - 7);
    return intervals = [0, 1, 2, 3, 4, 5].map(function(el, i, arr) {
      return {
        start: hours[i],
        finish: hours[i + 1]
      };
    });
  };

  recordsInDatabase = Vue.resource('http://wmatvmlr401/lr4/oee-monitor/index.php/manual_input/:machine/:total_qty/:good_qty/:start');

  window.vm = new Vue({
    el: '#template',
    data: {
      machines: [
        {
          name: 'DR1',
          process: 'Deflector - Ensamble'
        }, {
          name: 'DR2',
          process: 'Deflector - Verificacion'
        }, {
          name: 'EN2',
          process: 'Etalon'
        }
      ].map(function(machine) {
        console.log(machine);
        return _.extend(intervalsFactory()).map(function(el) {
          return _.extend(el, {
            buenas: 0,
            total: 0,
            name: machine.name,
            process: machine.process
          });
        });
      })
    },
    methods: {
      returnToReferer: function(a, b) {
        return window.location.href = a;
      },
      saveIntervalContents: function(a) {
        return console.log(a);
      }
    }
  });

}).call(this);

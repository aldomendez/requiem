(function() {
  var capitalize, date, hhmm, intervals, intervalsFactory, month, recordsInDatabase, yyyymmddhh24mm;

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

  yyyymmddhh24mm = function(dt) {
    return (dt.getFullYear()) + "-" + (dt.getMonth() + 1) + "-" + (dt.getDate()) + " " + (dt.getHours()) + ":" + (dt.getMinutes());
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

  intervals = intervalsFactory();

  recordsInDatabase = Vue.resource('http://wmatvmlr401/lr4/oee-monitor/index.php/manual_input/:machine/:start');

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
        var intervalsClone;
        intervalsClone = [];
        _.extend(intervalsClone, intervals).map(function(el) {
          var content;
          content = _.extend(el, {
            good_qty: '',
            build_qty: '',
            name: machine.name,
            process: machine.process,
            editable: true
          });
          recordsInDatabase.get({
            machine: machine.name,
            start: yyyymmddhh24mm(el.start)
          }, (function(_this) {
            return function(item) {
              if (item.error) {
                return false;
              }
              console.log(item);
              content.good_qty = item.good_qty;
              content.build_qty = item.build_qty;
              return content.editable = false;
            };
          })(this)).error(function(data, status) {
            console.log(data);
            return console.log(status);
          });
          return content;
        });
        return intervalsClone;
      })
    },
    methods: {
      returnToReferer: function(a, b) {
        return window.location.href = a;
      },
      saveIntervalContents: function(e, a, machine) {
        e.preventDefault();
        machine.editable = false;
        return recordsInDatabase.save({
          machine: machine.name,
          build_qty: machine.build_qty,
          good_qty: machine.good_qty,
          start: yyyymmddhh24mm(machine.start)
        }, function(data, status) {
          console.log(data);
          return console.log(status);
        });
      }
    }
  });

}).call(this);

(function() {
  var capitalize, date, hhmm, hours, intervals, month, now, util, x;

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
    return "Ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic".split(' ')[dt.getMonth()];
  };

  date = function(dt) {
    return dt.getDate();
  };

  hhmm = function(dt) {
    return (dt.getHours()) + ":" + (dt.getMinutes());
  };

  Vue.filter('range', function(val, start, finish) {
    console.log(start);
    console.log(finish);
    if (start.getDate() === finish.getDate()) {
      return (capitalize(month(start))) + " " + (date(start)) + " " + (hhmm(start)) + "-" + (hhmm(finish));
    } else {
      return (capitalize(month(start))) + " " + (date(start)) + " " + (hhmm(start)) + "- " + (capitalize(month(start))) + " " + (date(finish)) + " " + (hhmm(finish));
    }
  });

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

  intervals = [0, 1, 2, 3, 4, 5].map(function(el, i, arr) {
    return {
      start: hours[i],
      finish: hours[i + 1],
      total: 0,
      buenas: 0
    };
  });

  console.log(intervals);

  util = {
    packId: Vue.resource('http://wmatvmlr401/lr4/oee-monitor/index.php/getIntervalInfo')
  };

  window.vm = new Vue({
    el: '#template',
    data: {
      intervals: intervals
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

(function() {
  var url;

  window.sum = function(arr) {
    return arr.reduce(function(a, b) {
      return +a + +b;
    });
  };

  window.average = function(arr) {
    return sum(arr) / arr.length;
  };

  Vue.filter('perc', function(val) {
    var perc;
    perc = Math.round(val * 100);
    if (perc > 100) {
      return 100;
    } else {
      return perc;
    }
  });

  Vue.filter('color', function(val) {
    if ((0 < val && val < .7)) {
      return 'red';
    }
    if ((.7 <= val && val < .9)) {
      return 'yellow';
    }
    if ((.9 <= val && val <= 1)) {
      return 'green';
    }
  });

  url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_uITLA_PRE-POST-PURGE.json';

  Vue.http.get(url, function(data, status, request) {
    var urldt;
    urldt = data;
    vm.bu['µITLA']['Pre-Post Purge'].raw = data;
    vm.bu['µITLA']['Pre-Post Purge'].avail = average(_.pluck(urldt, 'AVAILABILITY'));
    vm.bu['µITLA']['Pre-Post Purge'].perf = average(_.pluck(urldt, 'PERFORMANCE'));
    vm.bu['µITLA']['Pre-Post Purge'].yiel = average(_.pluck(urldt, 'YIELD'));
    return vm.bu['µITLA']['Pre-Post Purge'].oee = average(_.pluck(urldt, 'OEE'));
  });

  url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_uITLA_ETALON.json';

  Vue.http.get(url, function(data, status, request) {
    var urldt;
    urldt = data;
    vm.bu['µITLA']['Etalon'].raw = data;
    vm.bu['µITLA']['Etalon'].avail = average(_.pluck(urldt, 'AVAILABILITY'));
    vm.bu['µITLA']['Etalon'].perf = average(_.pluck(urldt, 'PERFORMANCE'));
    vm.bu['µITLA']['Etalon'].yiel = average(_.pluck(urldt, 'YIELD'));
    return vm.bu['µITLA']['Etalon'].oee = average(_.pluck(urldt, 'OEE'));
  });

  url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_uITLA_DEFLECTOR.json';

  Vue.http.get(url, function(data, status, request) {
    var urldt;
    urldt = data;
    vm.bu['µITLA']['Deflector'].raw = data;
    vm.bu['µITLA']['Deflector'].avail = average(_.pluck(urldt, 'AVAILABILITY'));
    vm.bu['µITLA']['Deflector'].perf = average(_.pluck(urldt, 'PERFORMANCE'));
    vm.bu['µITLA']['Deflector'].yiel = average(_.pluck(urldt, 'YIELD'));
    return vm.bu['µITLA']['Deflector'].oee = average(_.pluck(urldt, 'OEE'));
  });

  window.vm = new Vue({
    el: '#template',
    data: {
      bu: {
        'µITLA': {
          'Etalon': {
            avail: 0,
            perf: 0,
            yiel: 0,
            oee: 0
          },
          'Deflector': {
            avail: 0,
            perf: 0,
            yiel: 0,
            oee: 0
          },
          'Pre-Post Purge': {
            avail: 0,
            perf: 0,
            yiel: 0,
            oee: 0
          }
        }
      }
    }
  });

}).call(this);

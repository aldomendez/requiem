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
    if ((.7 < val && val < .9)) {
      return 'yellow';
    }
    if ((.9 < val && val <= 2)) {
      return 'green';
    }
  });

  url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_Engines_Functional.json';

  Vue.http.get(url, function(data, status, request) {
    var urldt;
    urldt = data;
    vm.bu['Engines']['Functional 162x'].raw = data;
    vm.bu['Engines']['Functional 162x'].avail = average(_.pluck(urldt, 'AVAILABILITY'));
    vm.bu['Engines']['Functional 162x'].perf = average(_.pluck(urldt, 'PERFORMANCE'));
    vm.bu['Engines']['Functional 162x'].yiel = average(_.pluck(urldt, 'YIELD'));
    return vm.bu['Engines']['Functional 162x'].oee = average(_.pluck(urldt, 'OEE'));
  });

  url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_Engines_Welder.json';

  Vue.http.get(url, function(data, status, request) {
    var urldt;
    urldt = data;
    vm.bu['Engines']['Welder'].raw = data;
    vm.bu['Engines']['Welder'].avail = average(_.pluck(urldt, 'AVAILABILITY'));
    vm.bu['Engines']['Welder'].perf = average(_.pluck(urldt, 'PERFORMANCE'));
    vm.bu['Engines']['Welder'].yiel = average(_.pluck(urldt, 'YIELD'));
    return vm.bu['Engines']['Welder'].oee = average(_.pluck(urldt, 'OEE'));
  });

  url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_insert_Engines_LIV.json';

  Vue.http.get(url, function(data, status, request) {
    var urldt;
    urldt = data;
    vm.bu['Engines']['LIV'].raw = data;
    vm.bu['Engines']['LIV'].avail = average(_.pluck(urldt, 'AVAILABILITY'));
    vm.bu['Engines']['LIV'].perf = average(_.pluck(urldt, 'PERFORMANCE'));
    vm.bu['Engines']['LIV'].yiel = average(_.pluck(urldt, 'YIELD'));
    return vm.bu['Engines']['LIV'].oee = average(_.pluck(urldt, 'OEE'));
  });

  window.vm = new Vue({
    el: '#template',
    data: {
      bu: {
        'Engines': {
          'Welder': {
            avail: 0,
            perf: 0,
            yiel: 0,
            oee: 0
          },
          'LIV': {
            avail: 0,
            perf: 0,
            yiel: 0,
            oee: 0
          },
          'Functional 162x': {
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

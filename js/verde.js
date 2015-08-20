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
    return Math.round(val * 100);
  });

  Vue.filter('color', function(val) {
    if ((0 < val && val < .7)) {
      return 'red';
    }
    if ((.7 < val && val < .9)) {
      return 'yellow';
    }
    if ((.9 < val && val <= 1)) {
      return 'green';
    }
  });

  url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_SiLens_every_x_h.json';

  Vue.http.get(url, function(data, status, request) {
    window.urldt = data;
    vm.bu.Amarillo.SiLens.avail = average(_.pluck(urldt, 'AVAILABILITY'));
    vm.bu.Amarillo.SiLens.perf = average(_.pluck(urldt, 'PERFORMANCE'));
    vm.bu.Amarillo.SiLens.yiel = average(_.pluck(urldt, 'YIELD'));
    return vm.bu.Amarillo.SiLens.oee = average(_.pluck(urldt, 'OEE'));
  });

  window.vm = new Vue({
    el: '#template',
    data: {
      bu: {
        Verde: {
          'Deflector': {
            avail: 0,
            perf: 0,
            yiel: 0,
            oee: 0
          },
          'Pre/Post Bake': {
            avail: 0,
            perf: 0,
            yiel: 0,
            oee: 0
          },
          'OSA Test': {
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

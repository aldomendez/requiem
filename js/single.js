(function() {
  window.vm = new Vue({
    el: '#template',
    data: {
      bu: [
        {
          name: 'Naranja',
          data: [
            {
              name: 'Deflector',
              avail: 40,
              perf: 80,
              yiel: 99
            }, {
              name: 'Pre/Post Bake',
              avail: 40,
              perf: 80,
              yiel: 99
            }, {
              name: 'OSA test',
              avail: 40,
              perf: 80,
              yiel: 99
            }
          ]
        }
      ]
    }
  });

}).call(this);

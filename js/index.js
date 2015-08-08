(function() {
  var Pack;

  Vue.component('main-menu', {});

  Pack = (function() {
    function Pack(carrier1) {
      this.carrier = carrier1;
      this.contents = [];
    }

    return Pack;

  })();

  window.vm = new Vue({
    el: '#template',
    data: {
      carriers: [
        {
          carrier: '156181394',
          contents: [['1', '159866954', 'PASS/POST-PURGE', '159866954', 'MSPP-PIC', '5067-5071', '0'], ['2', '159866954', 'PASS/POST-PURGE', '159866954', 'MSPP-PIC', '5067-5071', '4'], ['3', '159866954', 'PASS/POST-PURGE', '159866954', 'MSPP-PIC', '5067-5071', '3'], ['4', '159866954', 'PASS/POST-PURGE', '159866954', 'MSPP-PIC', '5067-5071', '0']]
        }, {
          carrier: '156181394',
          contents: [['1', '156179044', 'PASS/POST-PURGE', '156179044', 'MSPP-PIC', '5067-5071', '0'], ['2', '156179044', 'PASS/POST-PURGE', '156179044', 'MSPP-PIC', '5067-5071', '4'], ['3', '156179044', 'PASS/POST-PURGE', '156179044', 'MSPP-PIC', '5067-5071', '3'], ['4', '156179044', 'PASS/POST-PURGE', '156179044', 'MSPP-PIC', '5067-5071', '0']]
        }
      ],
      selectedpack: 0,
      newPackCarrier: ''
    },
    methods: {
      selectCarrier: function(pack) {
        console.log(pack);
        return vm.selectedpack = pack;
      },
      isActive: function(selected) {
        var base;
        return typeof (base = vm.selectedpack === selected) === "function" ? base({
          "true": false
        }) : void 0;
      },
      newPack: function(e, carrier) {
        e.preventDefault();
        if (vm.newPackCarrier.length === 9) {
          vm.carriers.unshift(new Pack(vm.newPackCarrier));
          vm.newPackCarrier = '';
          return vm.selectedpack = 0;
        }
      }
    }
  });

}).call(this);

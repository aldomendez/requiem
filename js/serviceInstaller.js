(function() {
  var Service, svc;

  Service = require('node-windows').Service;

  svc = new Service({
    name: 'MonitorPulling',
    description: 'NodeJs Web Pulling to update OEE data',
    script: 'C:\\apps\\oee-monitor\\js\\puller.js'
  });

  svc.on('install', function() {
    return svc.start();
  });

  svc.install();

}).call(this);

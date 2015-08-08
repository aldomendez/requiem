(function() {
  var Service, svc;

  Service = require('node-windows').Service;

  svc = new Service({
    name: 'MonitorPulling',
    description: 'NodeJs Web Pulling to update monitors',
    script: 'C:\\apps\\node-win\\puller.js'
  });

  svc.on('install', function() {
    return svc.start();
  });

  svc.install();

}).call(this);

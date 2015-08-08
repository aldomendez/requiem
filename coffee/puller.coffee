rest = require 'unirest'
fs = require 'fs'

running = false
timeoutTime = 50000
a = (timeout)->
 if not running
  interval = do =>setTimeout(callRest,timeout)
callRest = ->
 running = true
 console.log 'Running call'
 rest.get('http://cymautocert/osaapp/semaforo-dev/toolbox.php?action=updateTables').end (response)->
  running = false
  console.log 'response geted'
  writeFile('C:\\apps\\node-win\\response.txt', JSON.stringify response)
  a timeoutTime
writeFile = (address, content)->
 fs.writeFile address, content, (err)->
  if err
   console.log err
   console.log 'File saved'
a timeoutTime
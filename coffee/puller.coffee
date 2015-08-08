# Dependencias externas
rest = require 'unirest'
fs = require 'fs'

# Inicializacion de variables
running = false
# El valor es en milisegundos
timeoutTime = 50 * 1000

# Inicializacion de funciones
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
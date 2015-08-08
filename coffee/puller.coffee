# Dependencias externas
rest = require 'unirest'
fs = require 'fs'
cron = require 'node-schedule'

console.log 'initialized'
# Inicializacion de variables
running = false
# El valor es en milisegundos
timeoutTime = 50 * 1000
counter = 0
# Inicializacion de funciones
# a = (timeout)->
 # if not running
 	# console.log 'scheduling new timeout'
  # interval = do =>setTimeout(callRest,timeout)

callRest = ->
 running = true
 console.log 'Making the question'
 rest.get('http://wmatvmlr401/lr4/oee-monitor/index.php/update/target').end (response)->
  running = false
  console.log 'Response getted'
  writeFile('C:/apps/oee-monitor/cache/response' + ++counter + '.json', JSON.stringify response)
  # a timeoutTime
logger = ->
 	console.log 'Still alive'

writeFile = (address, content)->
 fs.writeFile address, content, (err)->
  if err
   	console.log err
  else
  	console.log 'File saved'

# a timeoutTime

j = cron.scheduleJob '0 30 6  * * *', callRest
k = cron.scheduleJob '0 30 10 * * *', callRest
l = cron.scheduleJob '0 30 14 * * *', callRest
m = cron.scheduleJob '0 30 22 * * *', callRest
n = cron.scheduleJob '0 30 2  * * *', callRest
o = cron.scheduleJob '0  0 */1  * * *', callRest
p = cron.scheduleJob '*/5  * *  * * *', logger
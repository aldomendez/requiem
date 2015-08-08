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

callRest = (addr)->
 running = true
 console.log '--> Making the question'
 rest.get(addr).end (response)->
  running = false
  console.log '<-- Response getted'
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

updateHourly = ()->
	callRest('http://wmatvmlr401/lr4/oee-monitor/index.php/update/hourly');

# a timeoutTime

j = cron.scheduleJob '0 30 6  * * *', updateHourly
k = cron.scheduleJob '0 30 10 * * *', updateHourly
l = cron.scheduleJob '0 30 14 * * *', updateHourly
m = cron.scheduleJob '0 30 22 * * *', updateHourly
n = cron.scheduleJob '0 30 2  * * *', updateHourly
o = cron.scheduleJob '0  */15 *  * * *', updateHourly
p = cron.scheduleJob '*/5  * *  * * *', logger
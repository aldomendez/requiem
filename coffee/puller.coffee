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

###
Make a call to a restfull service
the answer is stored in a cache folder for debugging

addr {string} address to the service
###

callRest = (addr)->
 running = true
 console.log '--> Making the question'
 rest.get(addr).end (response)->
  running = false
  console.log '<-- Response getted' + counter++
  writeFile('C:/apps/oee-monitor/cache/response' + ++counter + '.json', JSON.stringify response)

###
just print in the console information to know the service is alive
###
logger = ->
 	console.log 'Still alive --> ' + counter++


###
Wrapper to native fs.writeFile so i can handle errors in a single place

address {string} Path to file
content {string} Content of the file
###
writeFile = (address, content)->
 fs.writeFile address, content, (err)->
  if err
   	console.log err
  else
  	console.log 'File saved'

###
Functions to be user by the scheduler
###

updateHourly = ()->
	callRest('http://wmatvmlr401/lr4/oee-monitor/index.php/update/hourly');

updateEveryFourHours = ()->
	callRest('http://wmatvmlr401/lr4/oee-monitor/index.php/update/four_ours');


###
Scheduler
###

j = cron.scheduleJob '0 30 6  * * *', updateEveryFourHours
k = cron.scheduleJob '0 30 10 * * *', updateEveryFourHours
l = cron.scheduleJob '0 30 14 * * *', updateEveryFourHours
m = cron.scheduleJob '0 30 22 * * *', updateEveryFourHours
n = cron.scheduleJob '0 30 2  * * *', updateEveryFourHours
o = cron.scheduleJob '0 0 * * * *', updateHourly
p = cron.scheduleJob '*/5 * * * * *', logger




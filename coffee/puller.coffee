# Dependencias externas
rest = require 'unirest'
fs = require 'fs'
cron = require 'node-schedule'
checksum = require 'checksum'
emailjs = require 'emailjs'
analitics = require './analitics'
_ = require 'underscore'

SERVICEPARAMETERS =  {
	user:process.env['notificationUser']
	password:process.env['notificationPassword']
	host:'smtp.gmail.com'
	tls:true
	port:587
}
server = emailjs.server.connect SERVICEPARAMETERS

mailTest = ()->
	server.send {
		from:'OEE Monitor <cyopticsmexico@gmail.com>'
		to:'aldo.mendez@avagotech.com'
		subject:'Mira sin manos'
		text:'Prueba para el envio de notificaciones por <correo></correo>'
	}, (error, message)->
		console.log error

# Prueba de envio de correos
# mailTest()

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

callRest = (addr,callback)->
 running = true
 console.log '--> Making the question'
 rest.get(addr).end (response)->
  running = false
  cs = checksum JSON.stringify response.body
  console.log '<-- Response getted ' + cs
  writeFile('C:/apps/oee-monitor/cache/' + cs + '.json', response.body)

  # We handle a callback only if this callback is passed
  if callback? then callback JSON.parse response.body

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

testService = ()->
	console.log 'File updated by 1 hour'
	callRest 'http://wmatvmlr401/lr4/oee-monitor/index.php/update/hourly',(data)->
		analitics.analize(data)
		
testService()

updateHourly = ()->
	console.log 'File updated by 1 hour'
	callRest 'http://wmatvmlr401/lr4/oee-monitor/index.php/update/hourly'


updateEveryFourHours = ()->
	console.log 'File updated by 4 hour'
	callRest('http://wmatvmlr401/lr4/oee-monitor/index.php/update/four_ours');


# updateHourly()
###
Scheduler
###

j = cron.scheduleJob '0 30 6,10,14,22,2  * * *', updateEveryFourHours
o = cron.scheduleJob '0 0 * * * *', updateHourly
p = cron.scheduleJob '*/5 * * * * *', logger




# Dependencias externas
rest = require 'unirest'
fs = require 'fs'
checksum = require 'checksum'
dateFormat = require('dateformat');
_ = require 'underscore'
parser = require('cron-parser')
async = require('async')

q = async.queue (task, callback)->
	# setTimeout ()=>
	console.log task.final
	updateDatabase task.inicio, task.final, callback
	# ,1000
,1

q.drain = ()->
	console.log 'All items have been processed'

console.log "Awaken: " + dateFormat(new Date(), "dddd, mmmm dS, yyyy, h:MM:ss TT")


callRest = (addr,callback)->
 running = true
 console.log addr
 # console.log "Calling home: " + dateFormat(new Date(), "dddd, mmmm dS, yyyy, h:MM:ss TT")
 console.log '--> Making the question'
 rest.get(addr).end (response)->
  running = false
  cs = checksum JSON.stringify response.body
  console.log '<-- Response getted ' + cs
  writeFile('C:/apps/oee-monitor/cache/' + cs + '.html', response.body)

  # We handle a callback only if this callback is passed
  if callback? then callback()


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


updateDatabase = (inicio, final, callback)->
	console.log 'File updated by 1 hour'
	callRest "http://wmatvmlr401/lr4/oee-monitor/index.php/update/all/#{inicio}/#{final}", callback

options = {
	currentDate: new Date(2015,9,1)
	endDate: new Date()
	iterator:true
}

interval = parser.parseExpression('0 30 2,6,10,14,18,22  * * *',options);
final = interval.next()

q.drain = ()->
	addToQueue()

addToQueue = ()->
	try
		i = 20
		while i>=0
			try
				inicio = final
				# _.extend inicio, final.value
				final = interval.next()
				console.log "inicio: #{dateFormat inicio.value,'yyyy-mm-dd HH:MM'}, final: #{dateFormat final.value,'yyyy-mm-dd HH:MM'}"
				q.push {
					'inicio':dateFormat inicio.value,'yyyy-mm-dd HH:MM'
					'final': dateFormat final.value,'yyyy-mm-dd HH:MM'
				}
				i--
			catch e
				break
			
	catch e
		console.log "Error: #{e.message}"

addToQueue()
capitalize = (str)->
	return str.split('').map((el,i)-> if i is 0 then el.toUpperCase() else el).join('')
month = (dt)->
	return "ene feb mar abr may jun jul ago sep oct nov dic".split(' ')[dt.getMonth()]
date = (dt)->
	return dt.getDate()
hhmm = (dt)->
	return "#{dt.getHours()}:#{dt.getMinutes()}"
yyyymmddhh24mm = (dt)->
	return "#{dt.getFullYear()}-#{dt.getMonth()+1}-#{dt.getDate()} #{dt.getHours()}:#{dt.getMinutes()}"

Vue.filter 'to',(start, finish)->
	if start.getDate() is finish.getDate()
		"#{capitalize month start} #{date start} #{hhmm start}-#{hhmm finish}"
	else
		"#{capitalize month start} #{date start} #{hhmm start}- #{capitalize month start} #{date finish} #{hhmm finish}"

###
Calculates the intervals we will work at
###
intervalsFactory = ()->
	now = new Date()

	# Fill _hours_ with an array of dates, one each 4 hours starting from yesterday at 2:30am 
	hours = for x in [0..48] by 4
		new Date(now.getFullYear(), now.getMonth(), now.getDate(),x+2-24, 30)

	# Trim hours in the future
	hours = _.filter( hours, (el)-> el < now)

	# Left only 7 dates in the array (the last ones)...
	hours.splice(0, hours.length-7)

	# ...to build 6 intervals
	intervals = [0..5].map (el,i,arr)->
		{start:hours[i],finish:hours[i+1]}

intervals = intervalsFactory() 

# console.log intervals
recordsInDatabase = Vue.resource('http://wmatvmlr401/lr4/oee-monitor/index.php/manual_input/:machine/:start')



window.vm = new Vue {
	el: '#template'
	data: {
		machines:[
			{name:'DR1', process:'Deflector - Ensamble'},
			{name:'DR2', process:'Deflector - Verificacion'},
			{name:'EN2', process:'Etalon'}].map (machine)->
				intervalsClone =[]
				_.extend(intervalsClone, intervals).map (el)->
					content = _.extend el, {
						good_qty:''
						build_qty:''
						name:machine.name
						process:machine.process
						editable : true
					}
					recordsInDatabase.get({machine:machine.name,start:(yyyymmddhh24mm el.start)}, (item)=>
						if item.error then return false
						console.log  item
						content.good_qty = item.good_qty
						content.build_qty = item.build_qty
						content.editable = false
					).error (data,status)->
						console.log data
						console.log status
					return content
				return intervalsClone
	}
	methods:{
		returnToReferer:(a,b)->
			window.location.href = a
		saveIntervalContents:(e, a,machine)->
			e.preventDefault()
			machine.editable = false
			recordsInDatabase.save {
				machine:machine.name
				build_qty:machine.build_qty
				good_qty:machine.good_qty
				start:yyyymmddhh24mm(machine.start)
			},(data, status)->
				console.log data
				console.log status
	}

}

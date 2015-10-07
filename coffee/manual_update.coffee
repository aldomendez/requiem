capitalize = (str)->
	return str.split('').map((el,i)-> if i is 0 then el.toUpperCase() else el).join('')
month = (dt)->
	return "ene feb mar abr may jun jul ago sep oct nov dic".split(' ')[dt.getMonth()]
date = (dt)->
	return dt.getDate()
hhmm = (dt)->
	return "#{dt.getHours()}:#{dt.getMinutes()}"

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


# console.log intervals
recordsInDatabase = Vue.resource('http://wmatvmlr401/lr4/oee-monitor/index.php/manual_input/:machine/:total_qty/:good_qty/:start')



window.vm = new Vue {
	el: '#template'
	data: {
		machines:[
			{name:'DR1', process:'Deflector - Ensamble'},
			{name:'DR2', process:'Deflector - Verificacion'},
			{name:'EN2', process:'Etalon'}].map (machine)->
			console.log machine
			return _.extend(intervalsFactory()).map (el)->
				_.extend el, {
					buenas:0
					total:0
					name:machine.name
					process:machine.process
				}
	}
	methods:{
		returnToReferer:(a,b)->
			window.location.href = a
		saveIntervalContents:(a)->
			console.log a
	}

}

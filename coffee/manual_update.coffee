capitalize = (str)->
	return str.split('').map((el,i)-> if i is 0 then el.toUpperCase() else el).join('')
month = (dt)->
	return "Ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic".split(' ')[dt.getMonth()]
date = (dt)->
	return dt.getDate()
hhmm = (dt)->
	return "#{dt.getHours()}:#{dt.getMinutes()}"

Vue.filter 'range',(val, start, finish)->
	console.log start
	console.log finish
	if start.getDate() is finish.getDate()
		"#{capitalize month start} #{date start} #{hhmm start}-#{hhmm finish}"
	else
		"#{capitalize month start} #{date start} #{hhmm start}- #{capitalize month start} #{date finish} #{hhmm finish}"

now = new Date()
hours = for x in [0..48] by 4
	new Date(now.getFullYear(), now.getMonth(), now.getDate(),x+2-24, 30)
hours = _.filter( hours, (el)-> el < now)
hours.splice(0, hours.length-7)

intervals = [0..5].map (el,i,arr)->
	{start:hours[i],finish:hours[i+1],total:0,buenas:0}



console.log intervals
util = {
	packId: Vue.resource('http://wmatvmlr401/lr4/oee-monitor/index.php/getIntervalInfo')
}

window.vm = new Vue {
	el: '#template'
	data: {
		intervals:intervals
	}
	methods:{
		returnToReferer:(a,b)->
			window.location.href = a
		saveIntervalContents:(a)->
			console.log a
	}

}


window.sum = (arr) -> arr.reduce (a,b)-> +a + +b
window.average = (arr)-> sum(arr)/ (arr.length)
Vue.filter 'perc', (val)->
	perc = Math.round(val*100)
	if perc > 100 then return 100 else return perc
Vue.filter 'color', (val)->
	if 0 < val < .7 then return 'red'
	if .7 < val < .9 then return 'yellow'
	if .9 < val <= 2 then return 'green'



url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_pmqpsk_dctest.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['PMQPSK']['DC Test'].raw = data
	vm.bu['PMQPSK']['DC Test'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['PMQPSK']['DC Test'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['PMQPSK']['DC Test'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['PMQPSK']['DC Test'].oee = average(_.pluck(urldt,'OEE'))

url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_pmqpsk_plctest.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['PMQPSK']['PLC Test'].raw = data
	vm.bu['PMQPSK']['PLC Test'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['PMQPSK']['PLC Test'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['PMQPSK']['PLC Test'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['PMQPSK']['PLC Test'].oee = average(_.pluck(urldt,'OEE'))


window.vm = new Vue {
	el: '#template'
	data: {
		bu:{
			'PMQPSK':{
				'DC Test':{
					avail:0,perf:0,yiel:0,oee:0
				}
				'PLC Test':{
					avail:0,perf:0,yiel:0,oee:0
				}
			}		
		}
	}
}

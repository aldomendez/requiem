
window.sum = (arr) -> arr.reduce (a,b)-> +a + +b
window.average = (arr)-> sum(arr)/ (arr.length)
Vue.filter 'perc', (val)->
	perc = Math.round(val*100)
	if perc > 100 then return 100 else return perc
Vue.filter 'color', (val)->
	if 0 < val < .7 then return 'red'
	if .7 < val < .9 then return 'yellow'
	if .9 < val <= 2 then return 'green'




url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_Engines_Functional.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['Engines']['Functional 162x'].raw = data
	vm.bu['Engines']['Functional 162x'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['Engines']['Functional 162x'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['Engines']['Functional 162x'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['Engines']['Functional 162x'].oee = average(_.pluck(urldt,'OEE'))

url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_Engines_Welder.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['Engines']['Welder'].raw = data
	vm.bu['Engines']['Welder'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['Engines']['Welder'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['Engines']['Welder'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['Engines']['Welder'].oee = average(_.pluck(urldt,'OEE'))


url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_Engines_LIV.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['Engines']['LIV'].raw = data
	vm.bu['Engines']['LIV'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['Engines']['LIV'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['Engines']['LIV'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['Engines']['LIV'].oee = average(_.pluck(urldt,'OEE'))

url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_Engines_10Gb_25Gb.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['Engines']['OSAS'].raw = data
	vm.bu['Engines']['OSAS'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['Engines']['OSAS'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['Engines']['OSAS'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['Engines']['OSAS'].oee = average(_.pluck(urldt,'OEE'))

window.vm = new Vue {
	el: '#template'
	data: {
		bu:{
			'Engines':{
				'OSAS':{
					avail:0,perf:0,yiel:0,oee:0
				}
				'Welder':{
					avail:0,perf:0,yiel:0,oee:0
				}
				'LIV':{
					avail:0,perf:0,yiel:0,oee:0
				}
				'Functional 162x':{
					avail:0,perf:0,yiel:0,oee:0
				}
			}
		}
	}
}

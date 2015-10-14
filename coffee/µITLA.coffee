
window.sum = (arr) -> arr.reduce (a,b)-> +a + +b
window.average = (arr)-> sum(arr)/ (arr.length)
Vue.filter 'perc', (val)->
	perc = Math.round(val*100)
	if perc > 100 then return 100 else return perc
Vue.filter 'color', (val)->
	if 0 < val < .7 then return 'red'
	if .7 <= val < .9 then return 'yellow'
	if .9 <= val <= 1 then return 'green'


url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_uITLA_LENS.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['µITLA']['Lens Assy'].raw = data
	vm.bu['µITLA']['Lens Assy'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['µITLA']['Lens Assy'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['µITLA']['Lens Assy'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['µITLA']['Lens Assy'].oee = average(_.pluck(urldt,'OEE'))

url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_uITLA_ETALON.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['µITLA']['Etalon'].raw = data
	vm.bu['µITLA']['Etalon'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['µITLA']['Etalon'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['µITLA']['Etalon'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['µITLA']['Etalon'].oee = average(_.pluck(urldt,'OEE'))

url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_uITLA_DEFLECTOR.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['µITLA']['Deflector'].raw = data
	vm.bu['µITLA']['Deflector'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['µITLA']['Deflector'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['µITLA']['Deflector'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['µITLA']['Deflector'].oee = average(_.pluck(urldt,'OEE'))


window.vm = new Vue {
	el: '#template'
	data: {
		bu:{
			'µITLA':{
				'Etalon':{
					avail:0,perf:0,yiel:0,oee:0
				}
				'Deflector':{
					avail:0,perf:0,yiel:0,oee:0
				}
				'Lens Assy':{
					avail:0,perf:0,yiel:0,oee:0
				}
			}
		}
	}
}

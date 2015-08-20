sum = (arr) -> arr.reduce (a,b)-> +a + +b
average = (arr)-> sum(arr)/ (arr.length)
Vue.filter 'perc', (val)->
	Math.round(val*100)
Vue.filter 'color', (val)->
	if 0 < val < .7 then return 'red'
	if .7 < val < .9 then return 'yellow'
	if .9 < val <= 1 then return 'green'




url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_SiLens_every_x_h.json'
Vue.http.get url, (data, status, request)->
	window.urldt = data
	vm.bu.Amarillo.SiLens.avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu.Amarillo.SiLens.perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu.Amarillo.SiLens.yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu.Amarillo.SiLens.oee = average(_.pluck(urldt,'OEE'))


window.vm = new Vue {
	el: '#template'
	data: {
		bu:{
			Amarillo:{
				SiLens:{
					avail:0,perf:0,yiel:0,oee:0
				}
				'OSA Test':{
					avail:0,perf:0,yiel:0,oee:0
				}
				'LIV Pack':{
					avail:0,perf:0,yiel:0,oee:0
				}
			}
			Verde:{
				SiLens:{
					avail:0,perf:0,yiel:0,oee:0
				}
				'OSA Test':{
					avail:0,perf:0,yiel:0,oee:0
				}
				'LIV Pack':{
					avail:0,perf:0,yiel:0,oee:0
				}
			}
			Azul:{
				SiLens:{
					avail:0,perf:0,yiel:0,oee:0
				}
				'OSA Test':{
					avail:0,perf:0,yiel:0,oee:0
				}
				'LIV Pack':{
					avail:0,perf:0,yiel:0,oee:0
				}
			}
			Naranja:{
				SiLens:{
					avail:0,perf:0,yiel:0,oee:0
				}
				'OSA Test':{
					avail:0,perf:0,yiel:0,oee:0
				}
				'LIV Pack':{
					avail:0,perf:0,yiel:0,oee:0
				}
			}
		}
	}
	computed:{
		columns:()->
			size = _.size vm.bu
			if size <=1 then return 'one' else 'two'
	}
}

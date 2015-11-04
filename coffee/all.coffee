sum = (arr) -> arr.reduce (a,b)-> +a + +b
average = (arr)-> sum(arr)/ (arr.length)
Vue.filter 'perc', (val)->
	perc = Math.round(val*100)
	if perc > 100 then return 100 else return perc
Vue.filter 'color', (val)->
	if 0 < val < .7 then return 'red'
	if .7 <= val < .9 then return 'yellow'
	if .9 < val <= 10 then return 'green'

Vue.filter 'tableColor', (val)->
	if val is 'red' then return 'negative'
	if val is 'yellow' then return 'warning'
	if val is 'green' then return 'positive'


window.vm = new Vue {
	el: '#template'
	data: {
		show:'all'
		specific:{}
		bu:{
			'LR4-4x25':{
				'SiLens':{
					raw:[],avail:0,perf:0,yiel:0,oee:0
				}
				'OSA Test':{
					raw:[],avail:0,perf:0,yiel:0,oee:0
				}
				'Screening':{
					raw:[],avail:0,perf:0,yiel:0,oee:0
				}
			}
			'µITLA':{
				'Etalon':{
					raw:[],avail:0,perf:0,yiel:0,oee:0
				}
				'Deflector':{
					raw:[],avail:0,perf:0,yiel:0,oee:0
				}
				'Pre-Post Purge':{
					raw:[],avail:0,perf:0,yiel:0,oee:0
				}
			}
			'PMQPSK':{
				'DC Test':{
					raw:[],avail:0,perf:0,yiel:0,oee:0
				}
				'PLC Test':{
					raw:[],avail:0,perf:0,yiel:0,oee:0
				}
				# 'Welder':{
				# 	raw:[],avail:0,perf:0,yiel:0,oee:0
				# }
			}
			'Engines':{
				'OSAS':{
					raw:[],avail:0,perf:0,yiel:0,oee:0
				}
				'Welder':{
					raw:[],avail:0,perf:0,yiel:0,oee:0
				}
				'LIV':{
					raw:[],avail:0,perf:0,yiel:0,oee:0
				}
				'Functional 162x':{
					raw:[],avail:0,perf:0,yiel:0,oee:0
				}
			}
		}
	}
	computed:{
		columns:()->
			size = _.size vm.bu
			if size <=1 then return 'one' else 'two'
	}
	methods:{
		showDetail:(e,data)->
			this.$set 'specific', data.raw
			this.$set 'show','specific'
		returnToMasterTable:()->
			this.$set 'show','all'
	}
}


url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_SiLens_every_x_h.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['LR4-4x25'].SiLens.raw = data
	vm.bu['LR4-4x25'].SiLens.avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['LR4-4x25'].SiLens.perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['LR4-4x25'].SiLens.yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['LR4-4x25'].SiLens.oee = average(_.pluck(urldt,'OEE'))

url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_LR4-OSA_LIV.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['LR4-4x25']['OSA Test'].raw = data
	vm.bu['LR4-4x25']['OSA Test'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['LR4-4x25']['OSA Test'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['LR4-4x25']['OSA Test'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['LR4-4x25']['OSA Test'].oee = average(_.pluck(urldt,'OEE'))

url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_LR4-pack_Screening.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['LR4-4x25']['Screening'].raw = data
	vm.bu['LR4-4x25']['Screening'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['LR4-4x25']['Screening'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['LR4-4x25']['Screening'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['LR4-4x25']['Screening'].oee = average(_.pluck(urldt,'OEE'))

url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_Engines_Functional.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['Engines']['Functional 162x'].raw = data
	vm.bu['Engines']['Functional 162x'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['Engines']['Functional 162x'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['Engines']['Functional 162x'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['Engines']['Functional 162x'].oee = average(_.pluck(urldt,'OEE'))

url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_Engines_10Gb_25Gb.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['Engines']['OSAS'].raw = data
	vm.bu['Engines']['OSAS'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['Engines']['OSAS'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['Engines']['OSAS'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['Engines']['OSAS'].oee = average(_.pluck(urldt,'OEE'))

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

url = 'http://wmatvmlr401/lr4/oee-monitor/cache/oee_query_uITLA_PRE-POST-PURGE.json'
Vue.http.get url, (data, status, request)->
	urldt = data
	vm.bu['µITLA']['Pre-Post Purge'].raw = data
	vm.bu['µITLA']['Pre-Post Purge'].avail = average(_.pluck(urldt,'AVAILABILITY'))
	vm.bu['µITLA']['Pre-Post Purge'].perf = average(_.pluck(urldt,'PERFORMANCE'))
	vm.bu['µITLA']['Pre-Post Purge'].yiel = average(_.pluck(urldt,'YIELD'))
	vm.bu['µITLA']['Pre-Post Purge'].oee = average(_.pluck(urldt,'OEE'))

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

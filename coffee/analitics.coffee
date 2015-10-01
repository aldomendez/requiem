# Este archivo contiene el modulo que sera utilizado para llevar el seguimiento
# de los correo que se an mandado asi como de los cambios que han sucedido en 
# los valores de OEE a lo largo del tiempo para llevar un seguimiento de los
# que se envian y la importancia que toma dependiendo de el impacto que se presenta
# y el tiempo que tiene activa la alarma.

# - Otra cosa que deberia de tener es la razon de cambio, que tantos puntos lleva
#   hacia arriba/abajo

sqlite3 = require 'sqlite3'
databaseName = 'oee.db'
_ = require 'underscore'
db = new sqlite3.Database 'oee.db'

saveLocally = (object)->
	db.serialize ()->
		db.run "create table if not exists oee (
			id text,
			s_start_dt text,
			s_end_dt text,
			bu_id text,
			depto text,
			product text,
			process text,
			system_id text,
			sample_span_time text,
			build_qty text,
			avg_ct text,
			avail text,
			perf text,
			yield text,
			oee
		)"

		stmt = db.prepare "insert into oee (ID,
			S_START_DT,
			S_END_DT,
			BU_ID,
			DEPTO,
			PRODUCT,
			PROCESS,
			SYSTEM_ID,
			SAMPLE_SPAN_TIME,
			BUILD_QTY,
			AVG_CT,
			AVAIL,
			PERF,
			YIELD,
			oee) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

		# stmt.run.apply db,  _.values _.values object
		console.log _.values _.keys object 
		stmt.finalize()

# 	db.each "select rowid id, info from lorem", (err, row)->
# 		console.log "#{row.id} #{row.info}"

analize = (data)->
	console.log data
	for i in data
		for k,v of i
			# console.log v
			for k2,v2 of v
				saveLocally v2
				# console.log v2
				# for k3, v3 of v2
				# 	console.log "key: #{k3}, value: #{v3}"
				

				
	
	

module.exports = {
	analize:analize
}
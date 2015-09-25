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
			id,
			s_start_dt
			s_end_dt,
			bu_id,
			depto,
			product,
			process,
			system_id,
			sample_span_time,
			build_qty,
			avg_ct,
			avail,
			perf,
			yield,
			oee
		)"

		stmt = db.prepare "insert into oee (id,
			s_start_dt
			s_end_dt,
			bu_id,
			depto,
			product,
			process,
			system_id,
			sample_span_time,
			build_qty,
			avg_ct,
			avail,
			perf,
			yield,
			oee) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
		# for i in [0..10] by .1
		stmt.run.apply null, _.values(object) 
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
				# for k3, v3 of v2
				# 	console.log "key: #{k3}, value: #{v3}"
				

				
	
	

module.exports = {
	analize:analize
}
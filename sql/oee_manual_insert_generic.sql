insert into oee_master2 (
	ID, -- se calcula automaticamente
	s_start_dt,
	s_end_dt,
	BU,
	DEPTO,
	PRODUCT,
	PROCESS,
	MACHINE,
	SAMPLE_TIME_SPAN,
	total_production_time,
	build_qty,
	AVG_CT,
	AVAIL,
	PERF,
	YIELD,
	oee
)
select
-- el id se calcula como el consecutivo de el valor mas alto que se tiene en la base de datos
rownum+(select max(id) from oee_master2) id, 
to_date(':inicio','yyyy-mm-dd hh24:mi') s_start_dt, 
to_date(':final','yyyy-mm-dd hh24:mi') s_end_dt,
	':bu_id',
	':depto',
	':product',
	':process',
	':machine',
	':sample_time_span',
	(select ideal_cycle_time from OEE_MACHINE_CATALOG where machine = ':machine' and product = 'all') * :total_qty, -- total production time
	':total_qty',
	(select ideal_cycle_time from OEE_MACHINE_CATALOG where machine = ':machine' and product = 'all'), -- avg_ct
	((select ideal_cycle_time from OEE_MACHINE_CATALOG where machine = ':machine' and product = 'all')*23)/:sample_time_span, -- availability
	case when 23 < 0 then 0 else 1 end, -- performance (always 1 when we have devices, no way to calculate further)
	:yield, -- in php we manage to change this to 0 or the explicit operation $good_qty/$total_qty
	(((select ideal_cycle_time from OEE_MACHINE_CATALOG where machine = ':machine' and product = 'all')*23)/240)*
	(case when 23 < 0 then 0 else 1 end) * :yield
from dual
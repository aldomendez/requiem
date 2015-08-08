select rownum+(select max(id) from oee_master2) id,to_date(':inicio','yyyy-mm-dd hh24:mi') s_start_dt, 
to_date(':final','yyyy-mm-dd hh24:mi') s_end_dt, a.* , (availability * performance * yield) oee from ( 
select bu_id, depto, product, process, machine, round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) 
sample_span_time, round(sum(cycle_time/60),0) total_production_time,
  count(serial_num) build_qty,
  round(sum(cycle_time/60)/count(serial_num),2) avg_ct,
  sum(cycle_time/60)/round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) availability,
  (17.5/(sum(cycle_time/60) /count(serial_num))) Performance,
  sum(case when PASS_FAIL = 'P' then 1 else 0 end)/count(serial_num) Yield
from phase2.lr4_shim_assembly@mxoptix left join apogee.oee_machine_catalog on system_id=machine 
where process_date between to_date(':inicio','yyyy-mm-dd hh24:mi') and to_date(':final','yyyy-mm-dd hh24:mi') and 
  system_id in ('CYBOND38','CYBOND57','CYBOND63','CYBOND60','CYBOND55','CYBOND56','CYBOND14','CYBOND3','CYBOND59','CYBOND58') 
  and step_name = 'TOSA SUBASSEM3 (SUBASSEM2, SI LENS)'
group by bu_id, depto, product, process, machine
)a
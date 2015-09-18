select rownum+(select max(id) from oee_master2) id,':inicio' s_start_dt, ':final' s_end_dt, a.* , (availability * performance * yield) oee from ( 
select bu_id bu,depto, regexp_replace(listagg(product ,',') within group (order by product),'([^,]+)(,\1)+','\1') product
, process,system_id,round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) SAMPLE_TIME_SPAN,
    round(sum(cycle_time),0) total_production_time,
    count(serial_num) build_qty,
    round(sum(cycle_time)/count(serial_num),2) avg_ct,
    sum(cycle_time)/round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) availability,
    min(ideal_cycle_time)/(sum(cycle_time) /count(serial_num)) Performance,
    sum(case when PASS_FAIL = 'PASS' then 1 else 0 end)/count(serial_num) Yield
from (select facility system_id,device serial_num, device_fm PASS_FAIL,end_dt process_date,
operation step_name,test_time/60 cycle_time from 
(pgt.dtl_deflector_assy)a where test_dt between to_date(':inicio','yyyy-mm-dd hh24:mi') 
  and to_date(':final','yyyy-mm-dd hh24:mi')
  and facility in ('DR1','DR2'))a left join apogee.oee_machine_catalog b on system_id=machine 
where process_date between 
  to_date(':inicio','yyyy-mm-dd hh24:mi') and 
  to_date(':final','yyyy-mm-dd hh24:mi')
  and case when a.step_name in (select product from oee_machine_catalog where process = 'LIV' group by product) then a.step_name else 'all' end  = b.product
group by system_id, bu_id, depto, process, machine
)a
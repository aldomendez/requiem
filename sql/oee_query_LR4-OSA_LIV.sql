select rownum+(select max(id) from oee_master2) id,':inicio' s_start_dt, ':final' s_end_dt, a.* , (availability * performance * yield) oee from ( 
select bu_id bu,depto,product,process,system_id,round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) SAMPLE_TIME_SPAN,
    round(sum(cycle_time),0) total_production_time,
    count(serial_num) build_qty,
    round(sum(cycle_time)/count(serial_num),2) avg_ct,
    sum(cycle_time)/round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) availability,
    ideal_cycle_time/(sum(cycle_time) /count(serial_num)) Performance,
    sum(case when PASS_FAIL = 'P' then 1 else 0 end)/count(serial_num) Yield
from (select system_id system_id,serial_num serial_num, pass_fail,completion_date process_date, (completion_date - process_date)*24*60 cycle_time from 
(phase2.PROCESS_EXECUTION@mxoptix)a where process_date between to_date(':inicio','yyyy-mm-dd hh24:mi') 
  and to_date(':final','yyyy-mm-dd hh24:mi')) left join apogee.oee_machine_catalog on system_id=machine 
where process_date between 
  to_date(':inicio','yyyy-mm-dd hh24:mi') and 
  to_date(':final','yyyy-mm-dd hh24:mi')
  and system_id in ('CYTEST701','CYTEST702','CYTEST1201','CYTEST1202')
group by system_id, bu_id, depto, product, process,machine, ideal_cycle_time
)a
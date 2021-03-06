insert into oee_master2 (ID,s_start_dt,s_end_dt,BU,DEPTO,PRODUCT,PROCESS,MACHINE,SAMPLE_TIME_SPAN,total_production_time,build_qty,AVG_CT, AVAIL, PERF, YIELD, oee)
select rownum+(select max(id) from oee_master2) id,to_date(':inicio','yyyy-mm-dd hh24:mi') s_start_dt, to_date(':final','yyyy-mm-dd hh24:mi')
s_end_dt, a.* , (availability * performance * yield) oee from ( 
select bu_id bu,depto,product,process,system_id,round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) SAMPLE_TIME_SPAN,
    round(sum(cycle_time),0) total_production_time,
    count(serial_num) build_qty,
    round(sum(cycle_time)/count(serial_num),2) avg_ct,
    sum(cycle_time)/round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) availability,
    6/(sum(cycle_time) /count(serial_num)) Performance,
    sum(case when PASS_FAIL = 'PASS' then 1 else 0 end)/count(serial_num) Yield
from (select welder_id system_id,device serial_num,device_fm pass_fail,end_dt process_date, (end_dt- test_dt)*24*60 cycle_time,state from 
(dare_pkg.fiber_weld_prod@prodmx)a where test_dt between to_date(':inicio','yyyy-mm-dd hh24:mi') 
  and to_date(':final','yyyy-mm-dd hh24:mi')) left join apogee.oee_machine_catalog on system_id=machine 
where process_date between 
  to_date(':inicio','yyyy-mm-dd hh24:mi') and 
  to_date(':final','yyyy-mm-dd hh24:mi') and
  system_id in ('AOI6','AOI21','AOI5','AOI1','AOI11')
group by system_id, bu_id, depto, product, process,machine 
)a
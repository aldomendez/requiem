select rownum+(select max(id) from oee_master2) id,':inicio' s_start_dt, ':final'
s_end_dt, a.* , (availability * performance * yield) oee from ( 
select bu_id bu,depto,product,process,display_name system_id,round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) SAMPLE_TIME_SPAN,
    round(sum(cycle_time),0) total_production_time,
    count(serial_num) build_qty,
    round(sum(cycle_time)/count(serial_num),2) avg_ct,
    sum(cycle_time)/round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) availability,
    6/(sum(cycle_time) /count(serial_num)) Performance,
    sum(case when PASS_FAIL = 'PASS' then 1 else 0 end)/count(serial_num) Yield
from (
  select facility system_id,device serial_num,device_fm pass_fail,test_dt process_date, (end_dt- test_dt)*24*60 cycle_time,state from 
  dare_pkg.eml10gb_prod@prodmx a where test_dt between to_date(':inicio','yyyy-mm-dd hh24:mi') and to_date(':final','yyyy-mm-dd hh24:mi')
  union all select facility system_id,device serial_num,device_fm pass_fail,test_dt process_date, (end_dt- test_dt)*24*60 cycle_time,state from 
  dare_pkg.eml10gb_stan@prodmx a where test_dt between to_date(':inicio','yyyy-mm-dd hh24:mi') and to_date(':final','yyyy-mm-dd hh24:mi')

) left join apogee.oee_machine_catalog on system_id=machine 
where process_date between 
  to_date(':inicio','yyyy-mm-dd hh24:mi') and 
  to_date(':final','yyyy-mm-dd hh24:mi') and
  state = 'C' and
  system_id in ('PKGF10GB7','PKGF10GB4','PKGF10GB6','PKGF10GB1','PKGF10GB3','PKGF10GB5','PKGF10GB2')
group by display_name, bu_id, depto, product, process,machine 
)a
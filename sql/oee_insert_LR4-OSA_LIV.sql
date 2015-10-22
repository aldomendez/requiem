insert into oee_master2 (ID,s_start_dt,s_end_dt,BU,DEPTO,PRODUCT,PROCESS,MACHINE,SAMPLE_TIME_SPAN,total_production_time,build_qty,AVG_CT, AVAIL, PERF, YIELD, oee)
select rownum+(select max(id) from oee_master2) id,to_date(':inicio','yyyy-mm-dd hh24:mi') s_start_dt, to_date(':final','yyyy-mm-dd hh24:mi')
s_end_dt, a.* , (availability * performance * yield) oee from ( 
    -- Second level, group aggregates per machine
    select  
        bu,depto, regexp_replace(listagg(product ,'.') within group (order by product),'([^.]+)(.\1)+','\1') product, process, system_id,
        round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) SAMPLE_TIME_SPAN,
        round(sum(total_production_time),0) total_production_time, sum(build_qty) build_qty, sum(avg_ct) avg_ct, 
        sum(total_production_time)/round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) availability
        ,sum(perfstp1)/sum(total_production_time)  performance,sum(good_pieces)/sum(build_qty) yield
        from (
        -- First level, calculates values per code
        select bu_id bu,depto, 
              -- Deletes duplicates, only left one of each different
              regexp_replace(listagg(product ,'.') within group (order by product),'([^.]+)(.\1)+','\1') product, 
              process,system_id,
              sum(cycle_time) total_production_time,
              count(serial_num) build_qty,
              round(sum(cycle_time)/count(serial_num),2) avg_ct,
              sum(cycle_time) availability,
              min(ideal_cycle_time)* count(serial_num)perfstp1 ,--min(ideal_cycle_time) idct,
              sum(case when PASS_FAIL = 'P' then 1 else 0 end) good_pieces
        from (select system_id system_id,serial_num serial_num, pass_fail,completion_date process_date,
        step_name,(completion_date - process_date)*24*60 cycle_time from 
        (phase2.PROCESS_EXECUTION@mxoptix)a where process_date between 
          to_date(':inicio','yyyy-mm-dd hh24:mi') 
          and to_date(':final','yyyy-mm-dd hh24:mi')
          and system_id in (
          'CYTEST701','CYTEST702','CYTEST1201','CYTEST1202'
          ))a left join apogee.oee_machine_catalog b on system_id=machine 

        where process_date between 
          to_date(':inicio','yyyy-mm-dd hh24:mi') and 
          to_date(':final','yyyy-mm-dd hh24:mi')
          -- this part split by code and assign its corresponging cycle time given the machine and code
          and case when a.step_name in (select product from oee_machine_catalog where process = 'LIV' group by product) then a.step_name else 'all' end  = b.product
        group by system_id, bu_id, depto, process, machine,ideal_cycle_time

    )b group by process,bu,depto, system_id
)a

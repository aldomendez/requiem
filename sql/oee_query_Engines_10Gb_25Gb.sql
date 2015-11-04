select rownum+(select max(id) from oee_master2) id,':inicio' s_start_dt, ':final' s_end_dt, a.* , (availability * performance * yield) oee from (
    -- Second level, group aggregates per machine
    select  
        bu,depto, regexp_replace(listagg(part_num ,',') within group (order by part_num),'([^,]+)(,\1)+','\1') product,
        regexp_replace(listagg(process ,',') within group (order by process),'([^,]+)(,\1)+','\1') process, system_id,
        round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) SAMPLE_TIME_SPAN,
        round(sum(total_production_time),0) total_production_time, sum(build_qty) build_qty, sum(avg_ct) avg_ct, 
        sum(total_production_time)/round(((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60)*(1-planed_downtime),0) availability
        ,sum(perfstp1)/sum(total_production_time)  performance,sum(good_pieces)/sum(build_qty) yield
        from (
        -- First level, calculates values per code
        select bu_id bu,depto, 
              -- Deletes duplicates in the product list
              regexp_replace(listagg(a.part_num ,',') within group (order by a.part_num),'([^,]+)(,\1)+','\1') part_num, 
              process,display_name system_id,
              sum(cycle_time/60) total_production_time,
              count(serial_num) build_qty,
              round(sum(cycle_time/60)/count(serial_num),2) avg_ct,
              sum(cycle_time) availability,
              min(ideal_cycle_time)* count(serial_num)perfstp1 ,
              sum(case when PASS_FAIL = 'P' then 1 else 0 end) good_pieces,
              planed_downtime
        from (
            select system_id, serial_num, pass_fail, process_date,
            part_num, cycle_time, step_name from phase2.los_assembly@mxoptix edb 
            where process_date between 
              to_date(':inicio','yyyy-mm-dd hh24:mi') and 
              to_date(':final','yyyy-mm-dd hh24:mi') and 
              system_id in ('CYBOND1','CYBOND11','CYBOND15','CYBOND18','CYBOND19','CYBOND20','CYBOND24','CYBOND28','CYBOND29','CYBOND9','CYBOND31','CYBOND32','CYBOND35','CYBOND36','CYBOND37')
          )a left join apogee.oee_machine_catalog b on system_id=machine
          -- this part split by product and assign its corresponging machine specific data
          where case when a.part_num in (select product from oee_machine_catalog where depto = 'OSAS' group by product) then a.part_num else 'all' end  = b.product
        group by system_id, bu_id, depto, process, display_name,ideal_cycle_time, b.planed_downtime

    )b group by bu,depto, system_id, b.planed_downtime
)a
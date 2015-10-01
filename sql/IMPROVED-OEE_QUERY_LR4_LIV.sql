select rownum+(select max(id) from oee_master2) id,'201509241615' s_start_dt, '201509251454' s_end_dt, a.* , (availability * performance * yield) oee from (

    select 
        bu,depto, regexp_replace(listagg(product ,',') within group (order by product),'([^,]+)(,\1)+','\1') product, process, system_id,
        round((to_date('201509251454','yyyymmddhh24mi') - to_date('201509241615','yyyymmddhh24mi'))*24*60,0) SAMPLE_TIME_SPAN,
        round(sum(total_production_time),0) total_production_time, sum(build_qty) build_qty, sum(avg_ct) avg_ct, 
        sum(total_production_time)/round((to_date('201509251454','yyyymmddhh24mi') - to_date('201509241615','yyyymmddhh24mi'))*24*60,0) availability
        ,sum(perfstp1)/sum(total_production_time)  performance,sum(good_pieces)/sum(build_qty) yield
        from (
    
        -- Primer nivel de agregacion Calcula los valores primarios
        select bu_id bu,depto, 
          -- Quita todos los elementos duplicados de la lista
          regexp_replace(listagg(product ,',') within group (order by product),'([^,]+)(,\1)+','\1') product, 
          
          process,system_id,
              
              sum(cycle_time) total_production_time,
              count(serial_num) build_qty,
              round(sum(cycle_time)/count(serial_num),2) avg_ct,
              
              sum(cycle_time) availability,
              
              min(ideal_cycle_time)* count(serial_num)perfstp1 ,--min(ideal_cycle_time) idct,
              
              sum(case when PASS_FAIL = 'P' then 1 else 0 end) good_pieces
              
        from (select system_id system_id,serial_num serial_num, pass_fail,completion_date process_date,
        step_name,(completion_date - process_date)*24*60 cycle_time from 
        (phase2.PROCESS_EXECUTION@mxoptix)a where process_date between to_date('201509241615','yyyymmddhh24mi') 
          and to_date('201509251454','yyyymmddhh24mi')
          and system_id in (
          'CYTEST701','CYTEST702','CYTEST1201','CYTEST1202'
--            'CYTEST1201'
          ))a left join apogee.oee_machine_catalog b on system_id=machine 
        where process_date between 
          to_date('201509241615','yyyymmddhh24mi') and 
          to_date('201509251454','yyyymmddhh24mi')
          -- esta es la parte que hace la separacion por codigos y les asigna su tiempo de ciclo
          and case when a.step_name in (select product from oee_machine_catalog where process = 'LIV' group by product) then a.step_name else 'all' end  = b.product
        group by system_id, bu_id, depto, process, machine,ideal_cycle_time

    )b group by process,bu,depto, system_id
)a
insert into oee_master2 (ID,s_start_dt,s_end_dt,BU,DEPTO,PRODUCT,PROCESS,MACHINE,SAMPLE_TIME_SPAN,total_production_time,build_qty,AVG_CT, AVAIL, PERF, YIELD, oee)
select rownum+(select max(id) from oee_master2) id,to_date('2015-09-07 06:30','yyyy-mm-dd hh24:mi') s_start_dt, to_date('2015-09-07 18:30','yyyy-mm-dd hh24:mi')
s_end_dt, a.* , (availability * performance * yield) oee from ( 
    -- Second level, group aggregates per machine
    select  
        bu,depto, regexp_replace(listagg(product ,',') within group (order by product),'([^,]+)(,\1)+','\1') product,
        regexp_replace(listagg(process ,',') within group (order by process),'([^,]+)(,\1)+','\1') process, system_id,
        round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) SAMPLE_TIME_SPAN,
        round(sum(total_production_time),0) total_production_time, sum(build_qty) build_qty, sum(avg_ct) avg_ct, 
        sum(total_production_time)/round((to_date(':final','yyyy-mm-dd hh24:mi') - to_date(':inicio','yyyy-mm-dd hh24:mi'))*24*60,0) availability
        ,sum(perfstp1)/sum(total_production_time)  performance,sum(good_pieces)/sum(build_qty) yield
        from (
        -- First level, calculates values per code
        select bu_id bu,depto, 
              -- Deletes duplicates in the product list
              regexp_replace(listagg(a.product ,',') within group (order by a.product),'([^,]+)(,\1)+','\1') product, 
              process,display_name system_id,
              sum(cycle_time/60) total_production_time,
              count(serial_num) build_qty,
              round(sum(cycle_time)/count(serial_num),2) avg_ct,
              sum(cycle_time) availability,
              min(ideal_cycle_time)* count(serial_num)perfstp1 ,
              sum(case when PASS_FAIL = 'PASS' then 1 else 0 end) good_pieces
        from (
            select facility system_id, device serial_num, device_fm pass_fail, test_dt process_date,
            case 
              when regexp_like(product, '16(2|5)6') then '80KM'
              when product like 'T162X%' then '80KM'
              when product like '1655%' then '40KM'
              when product like '1625%' then '40KM'
              when product like 'T165X%' then '40KM'
        --      when product like '1626L0%' then '70KM'
        --      when product like 'T165X%' then '70KM'
        --      when product like 'T165X%' then '70KM'
              when product like '1647-%' then '40KM'
              else 'all'
            end
            -- this query is performed over the data for a machine in the [prod]uction and [stan]dars table
            product, test_time cycle_time, temp_cycle step_name from DARE_PKG.MTEMP_QUBE_PROD@prodmx edb where test_dt between 
              to_date(':inicio','yyyy-mm-dd hh24:mi') and to_date(':final','yyyy-mm-dd hh24:mi') and facility in ('0920EN00','1018EN00','1106EN00','LE1-5617','LE1-5027')
            union all select facility system_id, device serial_num, device_fm pass_fail, test_dt process_date, 'standard' step_name, 
            test_time cycle_time, temp_cycle step_name from DARE_PKG.MTEMP_QUBE_STAN@prodmx where test_dt between 
              to_date(':inicio','yyyy-mm-dd hh24:mi') and to_date(':final','yyyy-mm-dd hh24:mi') and facility in ('0920EN00','1018EN00','1106EN00','LE1-5617','LE1-5027')
          )a left join apogee.oee_machine_catalog b on system_id=machine
          -- this part split by product and assign its corresponging machine specific data
          where case when a.product in (select product from oee_machine_catalog where process = 'LIV-'||a.step_name group by product) then a.product else 'all' end  = b.product
          and process = 'LIV-'||a.step_name
        group by system_id, bu_id, depto, process, display_name,ideal_cycle_time

    )b group by bu,depto, system_id
)a
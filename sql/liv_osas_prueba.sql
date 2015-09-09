select serial_num, part_num, state, pass_fail, device_fm, process_type, process_date,system_id, step_name, cycle_time, carrier_serial_num, channel, system_id from phase2.liv_test@mxoptix  
where process_date > sysdate -.2 
and channel = 1 
and system_id = 'CYTEST1202' 
order by process_date 
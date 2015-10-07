<?php 

// phpinfo();

	// echo "product: $machine, $build_qty, $good_qty, $start" ;
	
	/*
	 * All this effort to convert a date to a string
	 */
	// echo $app->request()->getBody();
	$request = json_decode($app->request()->getBody(), true);
	// echo "$request";
	// print_r($request);

	// Convert the taken date to a date object
	$date = DateTime::createFromFormat('Y-n-j H:i',$request['start']);
	// Convert the date to a string
	$inicio = date('Y-m-d H:i',$date->format('U'));
	// echo $inicio;
	// Take a base DATE and ADD 4 hours
	$final = strtotime('+4 hours', $date->format('U'));
	$final = date('Y-m-d H:i', $final);
	$bu_id = '3'; // bu_id [Alfredo-1,Luis-2,Gerardo-3,Tomas-4]
	$depto = 'ITLA';
	$product = 'all';
	$process = 'Deflector';
	$machine = $request['machine'];
	$sample_time_span = '240';
	$total_production_time = '';
	$build_qty = ($request['build_qty'] <= 0)? 0 : $request['build_qty'];
	$good_qty = ($request['good_qty'] <= 0)? 0 : $request['good_qty'];
	$yield = ($build_qty <=0 ) ? 0 : "$good_qty/$build_qty" ;

	
	$query = file_get_contents("./sql/oee_manual_insert_generic.sql");
	
	$DB = new MxApps();
	$DB->setQuery($query);
	$DB->bind_vars(':inicio',$inicio);
	$DB->bind_vars(':final',$final);
	$DB->bind_vars(':bu_id',$bu_id);
	$DB->bind_vars(':depto',$depto);
	$DB->bind_vars(':product',$product);
	$DB->bind_vars(':process',$process);
	$DB->bind_vars(':machine',$machine);
	$DB->bind_vars(':sample_time_span',$sample_time_span);
	$DB->bind_vars(':total_production_time',$total_production_time);
	$DB->bind_vars(':build_qty',$build_qty);
	$DB->bind_vars(':good_qty',$request['good_qty']);
	$DB->bind_vars(':avg_ct',$avg_ct);
	$DB->bind_vars(':yield',$yield);
	$DB->exec();
	// $json = $DB->json();
	echo "$DB->query";

	$DB->setQuery("select ID,CREATION_DT,BU,S_START_DT,S_END_DT,DEPTO,PRODUCT,PROCESS,MACHINE,SAMPLE_TIME_SPAN,
		TOTAL_PRODUCTION_TIME,BUILD_QTY,AVG_CT,AVAIL AVAILABILITY,PERF PERFORMANCE,YIELD,OEE
		from oee_master2 a where machine in ('DR1','DR2') and s_start_dt = (select max(s_start_dt) from oee_master2 b where b.machine = a.machine)");
	$DB->exec();
	file_put_contents('./cache/oee_query_uITLA_DEFLECTOR.json', $DB->json());

	$DB->setQuery("select ID,CREATION_DT,BU,S_START_DT,S_END_DT,DEPTO,PRODUCT,PROCESS,MACHINE,SAMPLE_TIME_SPAN,
		TOTAL_PRODUCTION_TIME,BUILD_QTY,AVG_CT,AVAIL AVAILABILITY,PERF PERFORMANCE,YIELD,OEE
		from oee_master2 a where machine in ('EN2') and s_start_dt = (select max(s_start_dt) from oee_master2 b where b.machine = a.machine)");
	$DB->exec();
	file_put_contents('./cache/oee_query_uITLA_ETALON.json', $DB->json());






	$DB->close();
	
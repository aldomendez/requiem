<?php 

// phpinfo();

	// echo "product: $machine, $total_qty, $good_qty, $start" ;
	
	/*
	 * All this effort to convert a date to a string
	 */

	// Convert the taken date to a date object
	$date = strtotime($start);
	// Convert the date to a string
	$inicio = date('Y-m-d H:i',$date);
	// Take a base DATE and ADD 4 hours
	$final = strtotime('+4 hours', $date);
	$final = date('Y-m-d H:i', $final);

	$bu_id = '3'; // bu_id [Alfredo-1,Luis-2,Gerardo-3,Tomas-4]
	$depto = 'ITLA';
	$product = 'all';
	$process = 'Deflector';
	$machine = $machine;
	$sample_time_span = '240';
	$total_production_time = '';
	$total_qty = ($total_qty <= 0)? 0 : $total_qty;
	$yield = ($total_qty<=0) ? 0 : "$good_qty/$total_qty" ;

	// echo PHP_EOL . "i-> $inicio   f-> $final   -    $total_production_time";	
	
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
	$DB->bind_vars(':total_qty',$total_qty);
	$DB->bind_vars(':good_qty',$good_qty);
	$DB->bind_vars(':avg_ct',$avg_ct);
	$DB->bind_vars(':yield',$yield);
	// $DB->exec();
	// $json = $DB->json();
	echo "$DB->query";
	$DB->close();
	
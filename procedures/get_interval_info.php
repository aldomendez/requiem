<?php 

// phpinfo();

	// echo "product: $machine, $total_qty, $good_qty, $start" ;
	
	/*
	 * All this effort to convert a date to a string
	 */

	// Convert the taken date to a date object
	$date = DateTime::createFromFormat('Y-n-j H:i',$start);
	// Convert the date to a string
	$inicio = date('Y-m-d H:i',$date->format('U'));
	// echo "$inicio";
	$machine = $machine;

	$query = "select * from oee_master2 where s_start_dt = to_date(':s_start_dt','yyyy-mm-dd hh24:mi') and machine = ':machine'";
	
	$DB = new MxApps();
	$DB->setQuery($query);
	$DB->bind_vars(':s_start_dt',$inicio);
	$DB->bind_vars(':machine',$machine);
	$DB->exec();
	$json = $DB->json();
	$ans = $DB->results[0];
	// echo $DB->query;
	if ($json == "[]") {
		echo '{"error":"empty"}';
	} else {
		$build_qty = $ans['BUILD_QTY'];
		$good_qty = round($ans['BUILD_QTY']*$ans['YIELD']);
		$json = '{"build_qty":' . $build_qty . ',"good_qty":' . $good_qty . '}';
		echo "$json";
	}
	
	$DB->close();
	
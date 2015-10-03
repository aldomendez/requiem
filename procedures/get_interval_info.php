<?php 

	echo "product:".$product.", " ;
	$files = array('returnOEEDataFromOurDatabase');
	$inicio = strtotime('-4 hours');
	$final = strtotime('now');
	// echo('Query for dates:' . date('Y-m-d H:i', $inicio) . "  >".  date('Y-m-d H:i', $final));

	$DB = new MxApps();
	foreach ($files as $index => $value) {
		$query = "select to_char(sysdate,'yyyymmddhh24miss') from dual";
		$DB->setQuery($query);
		// $DB->bind_vars(':inicio',date('Y-m-d H:i', $inicio));
		// $DB->bind_vars(':final',date('Y-m-d H:i', $final));
		$DB->exec();
		$json = $DB->json();

		if ($json == '[]') {
			throw new Exception("No arrojo datos la base de datos", 1);
		} else {
			// file_put_contents('cache/' . $value . '.json', $json);
			echo $json;
		}
	}
	$DB->close();

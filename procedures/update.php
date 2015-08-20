<?php 
	if ($target == 'hourly') {
		// every our we create a cache
		$files = array('oee_query_SiLens_every_x_h');
		$inicio = strtotime('-4 hours');
		$final = strtotime('now');
		echo('Query for dates:' . date('Y-m-d H:i', $inicio) . "  >".  date('Y-m-d H:i', $final));
		$DB = new MxApps();

		foreach ($files as $index => $value) {
			$query = file_get_contents("sql/" . $value . '.sql');
			$DB->setQuery($query);
			$DB->bind_vars(':inicio',date('Y-m-d H:i', $inicio));
			$DB->bind_vars(':final',date('Y-m-d H:i', $final));
			$DB->exec();
			$json = $DB->json();

			if ($json == '[]') {
				throw new Exception("No arrojo datos la base de datos", 1);
			} else {
				file_put_contents('cache/' . $value . '.json', $json);
				echo $json;
			}
		}
		$DB->close();
	} elseif ($target == 'four_ours') {
		// Only insert data every four hours
		$files = array('oe_insert_SiLens_every_x_h');
		$inicio = strtotime('-4 hours');
		$final = strtotime('now');
		echo('Query for dates:' . date('Y-m-d H:i', $inicio) . "  >".  date('Y-m-d H:i', $final));
		$DB = new MxApps();

		foreach ($files as $index => $value) {
			$query = file_get_contents("sql/" . $value . '.sql');
			$DB->setQuery($query);
			$DB->bind_vars(':inicio',date('Y-m-d H:i', $inicio));
			$DB->bind_vars(':final',date('Y-m-d H:i', $final));
			if (oci_execute($DB->statement)){
				echo "Success";
			} else {
				echo "Fail";
			}

			
		}
		$DB->close();
	}



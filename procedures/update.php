<?php 
	if ($target == 'hourly') {

		// every our we create a cache

		// los valores corresponden a:
		//  - el nombre del archivo que contiene el query
		//  - el tiempo en horas que se toman para la muestra
		$files = array(
			array('oee_query_SiLens_every_x_h',4)
			,array('oee_query_LR4-OSA_LIV',4)
			,array('oee_query_Engines_Functional',4)
			,array('oee_query_Engines_Welder',4)
			,array('oee_query_pmqpsk_dctest',8)
			,array('oee_query_pmqpsk_plctest',4)
			,array('oee_query_uITLA_LENS',4)
			// ,array('oee_query_uITLA_ETALON',4)
			// ,array('oee_query_uITLA_DEFLECTOR',4)
			,array('oee_query_LR4-pack_Screening',4)
			,array('oee_insert_Engines_LIV',4)
		);
		$ans = array();
		$final = strtotime('now');
		// echo('Query for dates:' . date('Y-m-d H:i', $inicio) . "  >".  date('Y-m-d H:i', $final));
		$DB = new MxApps();

		foreach ($files as $index => $info) {
			$queryName = $info[0];
			$queryTimeSpan = $info[1];
			// Se crea la fecha de inicio para cada query por que puede ser diferente para cada uno
			$inicio = strtotime('-' . $queryTimeSpan . ' hours');

			$query = file_get_contents("sql/" . $queryName . '.sql');
			$DB->setQuery($query);
			$DB->bind_vars(':inicio',date('Y-m-d H:i', $inicio));
			$DB->bind_vars(':final',date('Y-m-d H:i', $final));
			$DB->exec();
			// I save the copy of the query
			// Later I want to have a copy of what it is doing 
			file_put_contents("sql/preCompiled/".$queryName.".sql", $DB->query);
			$json = $DB->json();

			if ($json == '[]') {
				// throw new Exception("No arrojo datos la base de datos [".$queryName. "]", 1);
			} else {
				file_put_contents('cache/' . $queryName . '.json', $json);
				array_push($ans, array($queryName => json_decode($json)));
			}
		}
		$DB->close();
		echo json_encode($ans);
	} elseif ($target == 'four_ours') {
		// Only insert data every four hours
		$files = array('oee_insert_SiLens_every_x_h');
		$inicio = strtotime('-4 hours');
		$final = strtotime('now');
		// echo('Query for dates:' . date('Y-m-d H:i', $inicio) . "  >".  date('Y-m-d H:i', $final));
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



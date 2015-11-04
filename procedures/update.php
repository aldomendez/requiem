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
			// ,array('oee_query_uITLA_LENS',4)
			// ,array('oee_query_uITLA_ETALON',4) // Retired because are not reliable given
			// ,array('oee_query_uITLA_DEFLECTOR',4) // the nature of the process
			,array('oee_query_LR4-pack_Screening',4)
			,array('oee_query_Engines_LIV',4)
			,array('oee_query_uITLA_PRE-POST-PURGE',4)
			,array('oee_query_Engines_10Gb_25Gb',4)
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
		$files = array(
			'oee_insert_SiLens_every_x_h'
			,'oee_insert_LR4-OSA_LIV'
			,'oee_insert_Engines_Functional'
			,'oee_insert_Engines_Welder'
			,'oee_insert_pmqpsk_dctest'
			,'oee_insert_pmqpsk_plctest'
			,'oee_insert_uITLA_LENS'
			// ,'oee_insert_uITLA_ETALON' // Retired because are not reliable given
			// ,'oee_insert_uITLA_DEFLECTOR' // the nature of the process
			,'oee_insert_LR4-pack_Screening'
			,'oee_insert_Engines_LIV'
			,'oee_query_uITLA_PRE-POST-PURGE'
			,'oee_insert_Engines_10Gb_25Gb'
		);
		$inicio = strtotime('-4 hours');
		$final = strtotime('now');
		// echo('Query for dates:' . date('Y-m-d H:i', $inicio) . "  >".  date('Y-m-d H:i', $final));
		$DB = new MxApps();

		foreach ($files as $index => $value) {
			$query = file_get_contents("sql/" . $value . '.sql');
			$DB->setQuery($query);
			$DB->bind_vars(':inicio',date('Y-m-d H:i', $inicio));
			$DB->bind_vars(':final',date('Y-m-d H:i', $final));
			file_put_contents("sql/preCompiled/".$value.".sql", $DB->query);
			echo "Active : " . $value . PHP_EOL;
			if (oci_execute($DB->statement)){
				echo "Success : " . $value . PHP_EOL;
			} else {
				echo "Fail" . PHP_EOL;
			}

			
		}
		$DB->close();
	}



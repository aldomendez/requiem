<?php 

// /update/:query/:inicio/:final

// $date = DateTime::createFromFormat('Y-n-j H:i',$inicio);
// $inicio = date('Y-m-d H:i',$date->format('U'));

// $date = DateTime::createFromFormat('Y-n-j H:i',$final);
// $final = date('Y-m-d H:i',$date->format('U'));

echo $inicio,PHP_EOL, $final, PHP_EOL ;


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
	,'oee_insert_Engines_10Gb_25Gb'
);
// $inicio = strtotime('-4 hours');
// $final = strtotime('now');
// echo('Query for dates:' . date('Y-m-d H:i', $inicio) . "  >".  date('Y-m-d H:i', $final));
$DB = new MxApps();

foreach ($files as $index => $value) {
	$query = file_get_contents("sql/" . $value . '.sql');
	$DB->setQuery($query);
	$DB->bind_vars(':inicio',$inicio);
	$DB->bind_vars(':final' ,$final);
	file_put_contents("sql/preCompiled/".$value.".sql", $DB->query);
	echo "Active : " . $value . PHP_EOL;
	if (oci_execute($DB->statement)){
		echo "Success : " . $value . PHP_EOL;
	} else {
		echo "Fail" . PHP_EOL;
	}

	
}
$DB->close();



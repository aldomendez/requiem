<?php
require '../Slim/Slim.php';
include "../inc/database.php";

$app = new Slim();

$app->get('/', 'index' );
$app->get('/carrier/:carrier', 'get_carrier_content' );
$app->post('/carrier/dispose', 'dispose' );
$app->post('/saveFailData', 'saveFailData');
$app->get('/insp/:carrier/:tech', 'get_4x25CarrierContents');


function get_carrier_content($carrier='')
{
    if ($carrier == '') {
        throw new Exception("No se paso un numero de carrier", 1);
    }
    // echo $carrier;
    $DB = new MxOptix();
    $query = <<<QUERY1
SELECT DISTINCT 
a.CARRIER_SERIAL_NUM,
a.CARRIER_SITE,
a.SERIAL_NUM,
a.STATUS,
b.STATUS savedStatus,
b.COMMENTS,
b.component,
b.failmode
           
FROM phase2.carrier_site@mxoptix a 
,apogee.fallas_lr4@mxapps b
WHERE a.serial_num = b.serial_num (+)
AND a.carrier_serial_num = ':carrier'       
ORDER BY a.carrier_site
QUERY1;
    $DB->setQuery($query);
    $DB->bind_vars(':carrier', $carrier);
    $DB->exec();
    $json = $DB->json();
    
    // Regresa los datos al navegador
    echo "$json";
    
    $DB->close();
}
function saveFailData()
{
    global $app;
    // Primero a declarar todas la variables que necesito
    $post = $app->request()->post();
    $components = $post['components'];
    $user = $post['user'];

    print_r($components);
    // Query que inserta en los componentes


$insert_fail_mode = <<<QUERY1
INSERT INTO fallas_lr4 (
  serial_num,status,carrier_serial_num,carrier_site,user_id,comments,component,failmode
) select ':serial_num',':status',':carrier_serial_num',':carrier_site',':user_id',':comments',':component',':failmode' 
FROM dual
WHERE NOT EXISTS (SELECT 1 FROM fallas_lr4 WHERE serial_num = ':serial_num')
QUERY1;

$update_fail_mode = <<<QUERY1
UPDATE fallas_lr4 
SET
    user_id = ':user_id',
    status = ':status',
    component = ':component',
    failmode = ':failmode',
    comments = ':comments'
Where serial_num = ':serial_num'
QUERY1;

$update_part_info = <<<Query2
UPDATE part_info
SET part_status = ':status',
pass_fail = ':pass_fail'
WHERE serial_num = ':serial_num'
Query2;

    $DB = new MxApps();
    $P2 = new MxOptix();

    foreach ($components as $key => $value) {
        if ($value['exists'] == 'false') {
            $DB->setQuery($insert_fail_mode);
            $DB->bind_vars(':serial_num',$value['SERIAL_NUM']);
            $DB->bind_vars(':status',$value['STATUS']=='true'?'P':'F');
            $DB->bind_vars(':carrier_serial_num',$value['CARRIER_SERIAL_NUM']);
            $DB->bind_vars(':carrier_site',$value['CARRIER_SITE']);
            $DB->bind_vars(':user_id',$user);
            $DB->bind_vars(':comments',$value['COMMENTS']);
            $DB->bind_vars(':component',$value['COMPONENT']);
            $DB->bind_vars(':failmode',$value['FAILMODE']);
            
            echo $DB->query . PHP_EOL;
            $DB->insert();
            oci_free_statement($DB->statement);

            $P2->setQuery($update_part_info);
            $P2->bind_vars(':serial_num',$value['SERIAL_NUM']);
            $P2->bind_vars(':status',$value['STATUS']=='true'?'PASS/POST-PURGE':'FAIL/VISUAL_INSPECTION');
            $P2->bind_vars(':pass_fail',$value['STATUS']=='true'?'P':'F');
            
            echo $P2->query . PHP_EOL;
            $P2->insert();
            oci_free_statement($P2->statement);
        } else {
            $DB->setQuery($update_fail_mode);
            $DB->bind_vars(':serial_num',$value['SERIAL_NUM']);
            $DB->bind_vars(':status',$value['STATUS']=='true'?'P':'F');
            $DB->bind_vars(':user_id',$user);
            $DB->bind_vars(':comments',$value['COMMENTS']);
            $DB->bind_vars(':component',$value['COMPONENT']);
            $DB->bind_vars(':failmode',$value['FAILMODE']);
            
            echo $DB->query . PHP_EOL;
            $DB->insert();
            oci_free_statement($DB->statement);

            
            $P2->setQuery($update_part_info);
            $P2->bind_vars(':serial_num',$value['SERIAL_NUM']);
            $P2->bind_vars(':status',$value['STATUS']=='true'?'PASS/POST-PURGE':'FAIL/VISUAL_INSPECTION');
            $P2->bind_vars(':pass_fail',$value['STATUS']=='true'?'P':'F');
            
            echo $P2->query . PHP_EOL;
            $P2->insert();
            oci_free_statement($P2->statement);
        }
    }
    oci_close($DB->conn);
    oci_close($P2->conn);
}

function index()
{
    include "start.php";
}

function all_epoxys(){
    
    $query = "SELECT lot_number, comments, to_char(expire_date,'yyyymmddhh24mi') expire_date FROM epoxy WHERE expire_date > SYSDATE";
    $DB = new MxOptix();
    $DB->setQuery($query);
    $DB->exec();
    $json = $DB->json();
    
    echo "$json";
    
    $DB->close();
}


function get_4x25CarrierContents($carrier, $tech){

    $query = <<<QUERY1
SELECT CARRIER_SERIAL_NUM, CARRIER_SITE, SERIAL_NUM, 'P' AS Fail_Pass
, ':tech' Technician
, To_Char(sysdate,'yyyy-mm-dd hh24:mi') upd_date
FROM carrier_site
WHERE carrier_serial_num = ':carrier' ORDER BY Carrier_site
QUERY1;

    $DB = new MxOptix();
    $DB->setQuery($query);
    $DB->bind_vars(':carrier', $carrier);
    $DB->bind_vars(':tech', $tech);
    oci_execute($DB->statement);
    $results = null;
    oci_fetch_all($DB->statement, $results,0,-1,OCI_FETCHSTATEMENT_BY_ROW);

    // print_r($results);

    $ans = array();

    foreach ($results as $key => $value) {
            array_push($ans, implode(',', $value));
    }
    // // Regresa los datos al navegador
    echo(implode('|', $ans));

    $DB->close();
 
 } 


$app->run();
<?php
require '../Slim/Slim.php';
include "../inc/database.php";

$app = new Slim();

$app->get('/', 'index' );
$app->get('/new', 'new_index' );
$app->get('/getIntervalInfo', 'get_interval_info' );
$app->get('/manualUpdate', 'manual_update' );
$app->get('/bu/:bu', 'single_bu_score' );
$app->get('/update/:target', 'updateTarget');
$app->get('/get/:depto/:product/:process', 'returnOEEDataByProcess');



function index()
{
    include "all.php";
}

function get_interval_info()
{
	include './procedures/get_interval_info.php';
}

function new_index()
{
	/*
	 * las mejoras que quiero para esta versiones tener la flexibilidad de cambiar las cosas desde
	 * la base de datos, ya no quiero tener las cosas hardcoded en el script que lo carga
	 */
    include "new_all.php";
}

function manual_update()
{
	include "manual_update.php";
}

function single_bu_score($bu)
{
    include "single_bu_score.php";
}

function updateTarget($target='')
{
    require './procedures/update.php';
}

function returnOEEDataByProcess($depto, $product, $process)
{
	require './procedures/returnOEEDataByProcess.php';
}

$app->run();
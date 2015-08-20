<?php
require '../Slim/Slim.php';
include "../inc/database.php";

$app = new Slim();

$app->get('/', 'index' );
$app->get('/bu/:bu', 'single_bu_score' );
$app->get('/update/:target', 'updateTarget');
$app->get('/get/:depto/:product/:process', 'returnOEEDataByProcess');



function index()
{
    include "all.php";
}

function single_bu_score()
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
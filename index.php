<?php
require '../Slim/Slim.php';
include "../inc/database.php";

$app = new Slim();

$app->get('/', 'index' );
$app->get('/update/:target', 'updateTarget');
function index()
{
    include "start.php";
}

function updateTarget($target='')
{
    echo $target;
}



$app->run();
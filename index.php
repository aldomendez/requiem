<?php
require '../Slim/Slim.php';
include "../inc/database.php";

$app = new Slim();

$app->get('/', 'index' );
$app->get('/bu/:bu', 'single_bu_score' );
$app->get('/update/:target', 'updateTarget');


function index()
{
    include "start.php";
}

function single_bu_score()
{
    include "single_bu_score.php";
}

function updateTarget($target='')
{
    require './procedures/update.php';
}


$app->run();
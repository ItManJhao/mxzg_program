<?php
header("Content-type: text/html; charset=utf-8");

date_default_timezone_set('PRC');

include '../../application/config/config.php';

$_GET['action'] = 'pay.callback';
$_GET['platform'] = 'yaowan';

include '../../../ecphp/EcPhp.php';
?>
<?php
header("Content-type: text/html; charset=utf-8");

date_default_timezone_set('PRC');

include '../../application/config/config.php';

function getPostGetX($pat = "Submit", $is_in = false) {
	$querystring = "";
	$pat = '\b' . str_replace('|', '\b|\b', $pat) . '\b';
	$GET_POST = array_merge($_GET, $_POST);
	foreach($GET_POST as $key=>$value) {
		if ($is_in) {
			if (preg_match("/$pat/i", $key))
				$querystring .= "&$key=$value";
		}
		else {
			if (!preg_match("/$pat/i", $key))
				$querystring .= "&$key=$value";
		}
	}
	if ($querystring)
		return substr($querystring, 1);
		return "";
}


$tmp = explode('-', $_GET['custom']);
if ($tmp[0] == 'YiBao') {
	echo file_get_contents("http://203.195.152.226:92/?action=cps.callback&" . getPostGetX());
	exit();
}


$_GET['action'] = 'pay.callback';
$_GET['platform'] = 'youku';

include '../../../ecphp/EcPhp.php';
?>
<?php
//配置文件

//出错时是否报错
define('DEBUG', true);

define('SITE_NAME', 'DFH3-Game'); //网站名

define('KEY', '^_^dfh-24!'); //密钥

$arr_tmp =  explode('.', $_SERVER['HTTP_HOST']);
$len = count($arr_tmp);
//echo $arr_tmp[$len - 2] . '.' . $arr_tmp[$len - 1];
define('DOMAIN', $arr_tmp[$len - 2] . '.' . $arr_tmp[$len - 1]); //主域

//项目（应用程序）所在目录
define('DIR_APPLICATION', realpath(__DIR__ . '/../'));	//realpath返回绝对路径

//默认控制器类
define('DEFAULT_CLASS', 'home');
//默认方法
define('DEFAULT_METHOD', 'index');

//网站根网址
$http = $_SERVER['REQUEST_SCHEME'];
if (!$http) {
	$http = strtolower($_SERVER['HTTPS']) == 'on' ? 'https' : 'http';
}
define('SITE_ROOT', $http . '://' . $_SERVER['HTTP_HOST'] . '/');

//数据库配置 BEGIN #########################
$CFG_DB['DEFAULT']['HOST'] = '121.10.139.62:3306';
$CFG_DB['DEFAULT']['USER'] = 'root';
$CFG_DB['DEFAULT']['PWD'] = 'mnd';
$CFG_DB['DEFAULT']['DATABASE'] = 'dfh5_center_data';


define('DEFAULT_CFG_DB', 'DEFAULT'); //默认使用的数据库配置

//关于SET NAMES
define('AUTO_SET_NAMES', true); //当连接数据库，自动使用SET NAMES
define('DB_CHARSET', 'UTF8'); //默认使用的数据库编码
define('AUTO_CHANGE_SQL_MODE', true);

//数据库配置 END #########################

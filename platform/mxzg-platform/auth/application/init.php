<?php

/**
 * 入口文件
 * 1.定义全局常量（define）
 * 2.加载函数库
 * 3.启动框架
 */
define('LSS', __DIR__);#当前框架所在的根目录
define('CORE', LSS.'/core');#框架核心文件所在目录
define('APP', LSS.'/app');#项目文件所处目录
define('DIR_SDK', LSS.'/app/sdk');#sdk处理类所在目录
define('DIR_LIBS', LSS.'/libraries');#项目文件所处目录
// define('MODULE', 'app');#项目文件所处目录

define('DEBUG', false);#是否开始调试模式
if (DEBUG){
    ini_set('display_errors','On');#为一个配置选项设置值
}else{
    ini_set('display_errors','Off');
}
// ini_set('log_errors', 1);
// error_reporting(-1);
// ini_set('display_errors', 'Off');

include CORE.'/common/function.php';#加载自定义函数库

include CORE.'/lss.php';#核心文件
include CORE . '/config/database.php';
include CORE . '/config/config.php';

//时区设置
if(isset($DEFAULT_TIMEZONE) && !empty($DEFAULT_TIMEZONE)){
	date_default_timezone_set($DEFAULT_TIMEZONE);
}

//加载数据库类
// include_once LSS . '/libraries/Mysql.php';
// $db = new Mysql();

spl_autoload_register('\core\lss::load');#类不存在的时候将会触发该方法，即类的自动加载
\core\lss::run();

// // 加载版本配置
// include LSS . '/config/version.php';




// //初始化时执行的代码
// // import('Class.Mysql');
// include_once __DIR__ . '/libraries/Mysql.php';
// // 20171009 平台没有使用到session，将其注释 by旭光
// // session_start();

// /**
//  * @var Mysql $db
//  */
// $db = new Mysql();

// include_once __DIR__ . '/libraries/Cors.php';
// $cors = new Cors();
// $cors->handle();

<?php

//数据库配置 BEGIN #########################
// $CFG_DB['DEFAULT']['HOST'] = '121.10.139.62:3306';
// $CFG_DB['DEFAULT']['USER'] = 'root';
// $CFG_DB['DEFAULT']['PWD'] = 'mnd';
// $CFG_DB['DEFAULT']['DATABASE'] = 'dfh5_center_data';

// $CFG_DB['DEFAULT']['HOST'] = '127.0.0.1';
// $CFG_DB['DEFAULT']['USER'] = 'root';
// $CFG_DB['DEFAULT']['PWD'] = 'root';
// $CFG_DB['DEFAULT']['DATABASE'] = 'zqyx_platform';
// $CFG_DB['DEFAULT']['PORT'] = '3306';

//测试
$CFG_DB['DEFAULT']['HOST'] = '182.254.197.214';
$CFG_DB['DEFAULT']['USER'] = 'root';
$CFG_DB['DEFAULT']['PWD'] = '@@@iknow08a5AMB';
$CFG_DB['DEFAULT']['DATABASE'] = 'mxzg_platform';
$CFG_DB['DEFAULT']['PORT'] = '3306';

//正式线上
// $CFG_DB['DEFAULT']['HOST'] = '172.16.0.6';
// $CFG_DB['DEFAULT']['USER'] = 'mxzg_game';
// $CFG_DB['DEFAULT']['PWD'] = '^-^ayjsgame!@#db&201912';
// $CFG_DB['DEFAULT']['DATABASE'] = 'mxzg_platform';
// $CFG_DB['DEFAULT']['PORT'] = '30001';

define('DEFAULT_CFG_DB', 'DEFAULT'); //默认使用的数据库配置

//关于SET NAMES
define('AUTO_SET_NAMES', true); //当连接数据库，自动使用SET NAMES
define('DB_CHARSET', 'UTF8'); //默认使用的数据库编码
define('AUTO_CHANGE_SQL_MODE', true);


// return array(
//     'DSN'       => 'mysql:host=121.10.139.62:3306;dbname=zqyx_platform',
//     'USERNAME'  => 'root',
//     'PASSWD'    => 'mnd',
// );
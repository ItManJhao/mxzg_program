<?php
// +----------------------------------------------------------------------
// | OneThink [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2013 http://www.onethink.cn All rights reserved.
// +----------------------------------------------------------------------
// | Author: 麦当苗儿 <zuojiazi@vip.qq.com> <http://www.zjzit.cn>
// +----------------------------------------------------------------------

/**
 * 系统配文件
 * 所有系统级别的配置
 */
return array(
 
    /* 系统数据加密设置 */
    'DATA_AUTH_KEY' => '|xeS)><AN9BoGlu2C4P.{Y_tEf]q/b@51Q!Tyz#R', //默认数据加密KEY
    /* 调试配置 */
    'SHOW_PAGE_TRACE' => false, //false,
    /* 用户相关设置 */
    'USER_MAX_CACHE'     => 1000, //最大缓存用户数
    /* URL配置 */
    'URL_CASE_INSENSITIVE' => true, //默认false 表示URL区分大小写 true则表示不区分大小写
    'URL_MODEL'            => 1, //URL模式
    'VAR_URL_PARAMS'       => '', // PATHINFO URL参数变量
    'URL_PATHINFO_DEPR'    => '/', //PATHINFO URL分割符
    /* 全局过滤配置 */
    'DEFAULT_FILTER' => '', //全局过滤函数

    'LOGIN_CENTER_URL' => 'http://134.175.85.111:2001/admin.php/login/index', //总登录页面地址
    'CENTER_HOST' => 'http://134.175.85.111:2001/', //总后台域名
    'PLATFROM_ID' => '1', //本平台代号
    'LOGIN_TOKEN_KEY' => '~!@ayjsgame@login@!~', //登陆校验token的key
    'LOGIN_TOKEN_EXPIRE' => '7200', //登陆校验token的过期时间

    'DEFAULT_TIMEZONE'=>'PRC',   //默认时区

    'EXPORT_LIMIT_NUM' => '3000', //限制导出数量条数

    // 'TAGLIB_BUILD_IN' => 'Cx,Common\Tag\Myhtml',

    'TITLE_NAME_AN_TEST' => '安卓-内网后台',   //浏览器表头
    'TITLE_NAME_AN_TRUE' => '安卓-正式服后台',   //浏览器表头
    'TITLE_NAME_IOS' => 'IOS-后台',   //浏览器表头
    'TITLE_NAME_DEFAULT' => '契约召唤管理后台',   //浏览器表头
    
    /* 数据库配置 */
//    //正式线上平台库
//    'DB_DEPLOY_TYPE' => 1, //开打支持多服务器        
//    'DB_RW_SEPARATE'=> true,//数据库读写否分离
//    'DB_TYPE'   => 'mysql', // 数据库类型
//    'DB_HOST'   => '172.16.0.6,172.16.0.24', // 服务器地址
//    'DB_NAME'   => 'mxzg_platform', // 数据库名
//    'DB_USER'   => 'mxzg_game', // 用户名
//    'DB_PWD'    => '^-^ayjsgame!@#db&201912',  // 密码
//    'DB_PORT'   => '30001,3306', // 端口
//    //正式数据分析库
//    'DB_DATA_ANALYSIS' => array(
//        'DB_DEPLOY_TYPE' => 1, //开打支持多服务器        
//        'DB_RW_SEPARATE' => true,//数据库读写否分离
//        'DB_TYPE'   => 'mysqli', // 数据库类型
//        'DB_HOST'   => '172.16.0.6,172.16.0.24', // 服务器地址
//        'DB_NAME'   => 'mxzg_data_analysis', // 数据库名
//        'DB_USER'   => 'mxzg_game', // 用户名
//        'DB_PWD'    => '^-^ayjsgame!@#db&201912',  // 密码
//        'DB_PORT'   => '30001,3306', // 端口
//    ),

    //测试平台库
    'DB_DEPLOY_TYPE' => 1, //开打支持多服务器        
    'DB_RW_SEPARATE'=> true,//数据库读写否分离
    'DB_TYPE'   => 'mysqli', // 数据库类型
    'DB_HOST'   => '182.254.197.214,182.254.197.214', // 服务器地址
    'DB_NAME'   => 'mxzg_platform', // 数据库名
    'DB_USER'   => 'root', // 用户名
    'DB_PWD'    => '@@@iknow08a5AMB',  // 密码
    'DB_PORT'   => '3306', // 端口
    //测试数据分析库
    'DB_DATA_ANALYSIS' => array(
        'DB_DEPLOY_TYPE' => 1, //开打支持多服务器        
        'DB_RW_SEPARATE' => true,//数据库读写否分离
        'DB_TYPE'   => 'mysqli', // 数据库类型
        'DB_HOST'   => '182.254.197.214,182.254.197.214', // 服务器地址
        'DB_NAME'   => 'mxzg_data_analysis', // 数据库名
        'DB_USER'   => 'root', // 用户名
        'DB_PWD'    => '@@@iknow08a5AMB',  // 密码
        'DB_PORT'   => '3306', // 端口
    ),
    //测试游戏中心库
    'DB_DATA_CENTER' => array(
        'DB_DEPLOY_TYPE' => 1, //开打支持多服务器        
        'DB_RW_SEPARATE' => true,//数据库读写否分离
        'DB_TYPE'   => 'mysqli', // 数据库类型
        'DB_HOST'   => '182.254.197.214,182.254.197.214', // 服务器地址
        'DB_NAME'   => 'mxzg_center_data', // 数据库名
        'DB_USER'   => 'root', // 用户名
        'DB_PWD'    => '@@@iknow08a5AMB',  // 密码
        'DB_PORT'   => '3306', // 端口
    ),

//    //本地
//    'DB_TYPE'   => 'mysql', // 数据库类型
//    'DB_HOST'   => '127.0.0.1', // 服务器地址
//    'DB_NAME'   => 'mxzg_platform', // 数据库名
//    'DB_USER'   => 'root', // 用户名
//    'DB_PWD'    => 'root',  // 密码
//    'DB_PORT'   => '3306', // 端口


    //游戏数据库
    'DB_GAME_DATA' => array(
    ),
    //游戏日志库
    'DB_GAME_LOG' => array(
    ),

    //中心服ip和port
    'CENTER_SERVER_INFO' => array(
        'HOST' => '192.168.0.206',
        'PORT' => '20002'
    ),

    //redis缓存配置
    'DATA_CACHE_TYPE' => 'Redis',
    'REDIS_HOST' => '192.168.1.131',
    'REDIS_PORT' => 11001,
    'DATA_CACHE_TIMEOUT' => false,
    'REDIS_PASSWORD' => '^-^ayjsgame!@#redis&201912',

    //邮件配置
    'MAIL_CONFIG' => array(
        'MAIL_SMTP' => TRUE,
        'MAIL_HOST' => 'smtphz.qiye.163.com',
        'MAIL_PORT' => '994',
        'MAIL_SMTPAUTH' => TRUE,
        'MAIL_USERNAME' => 'qyzh_server@anyaojs.com',
        'MAIL_PASSWORD' => '~83~7YYK6LVey6ht',
        'MAIL_SECURE' => 'ssl',
        'MAIL_CHARSET' => 'utf-8',
        'MAIL_ISHTML' => TRUE,
        'MAIL_FROMNAME' => '暗耀晶石指挥部',
    ),
    // 'MAIL_CONFIG' => array(
    //     'MAIL_SMTP' => TRUE,
    //     'MAIL_HOST' => 'ssl://smtp.qq.com',
    //     'MAIL_PORT' => '465',
    //     'MAIL_SMTPAUTH' => TRUE,
    //     'MAIL_USERNAME' => '360015056@qq.com',
    //     'MAIL_PASSWORD' => 'ywnecysajjvzbhjh',
    //     'MAIL_SECURE' => 'ssl',
    //     'MAIL_CHARSET' => 'utf-8',
    //     'MAIL_ISHTML' => TRUE,
    //     'MAIL_FROMNAME' => '暗耀晶石指挥部(港澳台)',
    // ),
    //服务器创角警告邮件
    'MAIL_SERVER_WARNING' => array(
        '360015056@qq.com','396734413@qq.com','duziqi@hnguangyi.cn'
    ),
    //服务器心跳停止警告邮件
    'MAIL_SERVER_HEART_BEAT' => array(
        '360015056@qq.com','396734413@qq.com','tangyangbo@qq.com'
    ),

    'DB_PREFIX' => '', // 数据库表前缀
    'DB_CHARSET'=> 'utf8', // 字符集
    'DB_DEBUG'  =>  TRUE, // 数据库调试模式 开启后可以记录SQL日志 3.2.3新增
    'ACTIVE_SEND_SERVER_URL' => '/activity/addOrUpdateActivity/',   //发送服务器
    'ROLE_OFFLINEALL_URL' => '/role/offlineAll/',   //提全服人下线
    'ROLE_LOGIN_CHAT_FORBID' => '/role/loginChatForbid/',   //封号禁言与解除
    'MAIL_SEND' => '/mail/sendSysMail/',   //发送邮件
    'MARQUEE_SEND' => '/marquee/sendMarquee/',   //开启跑马灯
    'MARQUEE_CANCEL' => '/marquee/cancelMarquee/',   //关闭跑马灯
    'SEND_OPTIME' => '/server/setOpenTime/',   //发送开服时间
    'RELOAD_CONFIG' => '/server/reloadConfig/',   //刷新游戏配置
    'VIRTUAL_RECHARGE' => '/recharge/virtualRecharge/',   //模拟充值
    'SEND_SENSITIVE_WORD' => '/server/sensitiveWord/',   //发送敏感词
    'HOT_UPDATE' => '/patch/loadpatch/',   //热更后端代码
    'GET_CHAT_LOG' => '/chat/getChatLog/',   //获取实时聊天日志
    'COST_RECHARGE' => '/cost/recharge/',   //扣除充值
    'COST_ITEM' => '/cost/item/',   //扣除道具
    'DELETE_SYSMAIL' => '/mail/deleteSysMail/',   //删除玩家系统邮件
    'DELETE_PERSONALMAIL' => '/mail/deletePersonalMail/',   //删除玩家个人邮件
    'UPDATE_CLAN_DESC' => '/clan/resetDesc/',   //更新公会公告
    'DELETE_CHAT_LOG' => '/chat/deleteChatLog/',   //删除聊天记录
    'CHAMPION_CLEAN_BIU' => '/champion/cleanBiu/',   //冠军赛和周冠军赛清除弹幕
    'HERO_COMMENT_DELETE' => '/heroComment/delete/',   //删除英雄评论

    //总后台操作
    'CENTER_REGISTER_RECHARGE' => '/cli/DoPlatfromData/RegisterRecharge/',   //发送注册数和总充值


    //补单发货配置
    'ORDER_SEND_KEY' => '^-^ayjsgame!@#api&201912',
    'ORDER_SEND_URL' => '/recharge/chargeCallback',
    'ORDER_SEND_ACTION' => 'recharge.chargeCallback',


    //平台sdk对接相关配置
    'PLATFORM_CONFIG' => array(
        'FIREBASE_PUSH_URL' => 'https://www.feifansite.com/sdk/firebase_push.php',
        'LOGIN_KEY_AND' => '25589fd1dbbbd50ce9acb654aa5cdf04',
        'GAME_ID_AND' => '0',
        'LOGIN_KEY_IOS' => '25589fd1dbbbd50ce9acb654aa5cdf04',
        'GAME_ID_IOS' => '0',
    ),

);

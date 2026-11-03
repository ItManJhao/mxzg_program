<?PHP

/**
 * 成功
 */
define(SUCCESS, 0);

/**
 * SDK登录验证出错
 */
define(SDK_LOGIN_ERROR, 1);

/**
 * 参数错误
 */
define(PARAMS_ERROR, 10001);

/**
 * 没有可用服务器
 */
define(NOT_SERVER, 10002);

/**
 * 玩家不存在
 */
define(USER_NOT_EXISTS, 10003);
/**
 * 玩家账号被锁定
 */
define(USER_LOCKED, 10004);

/**
 * 限制注册
 */
define(CHANNEL_LIMITED,10005);

/**
 * 充值回调有误
 */
define(PAY_CALLBACK_ERROR, 10006);

/**
 * 充值回调通知发货有误
 */
define(PAY_CALLBACK_SERVER_ERROR, 10007);

/**
 * 服务器有误
 */
define(SERVER_ERROR, 10008);

/**
 * 订单不存在
 */
define(CHARGE_ERROR, 10009);

/**
 * 金额校验错误
 */
define(MONEY_CHECK_ERROR, 10010);

/**
 * 用户校验错误
 */
define(USER_CHECK_ERROR, 10011);


/**
 * 商品校验错误
 */
define(GOODS_CHECK_ERROR, 10012);

//--------------兑换相关错误
define(CDKEY_IS_NOT_EXISTS, 11028);//兑换码不存在
define(CDKEY_IS_USERd, 11029);//兑换码已使用
define(CDKEY_IS_NOT_ALLOW_USE, 11030);//还没到开始时间
define(CDKEY_IS_EXPIRE, 11031);//兑换码已过期
define(CDKEY_IS_LIMITED, 11032);//兑换码使用次数受限
define(CDKEY_INVALID, 11034);//渠道受到限制时，提示兑换码无效

?>

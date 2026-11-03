<?php
include_once __DIR__ . '/DataSDK.php';
include_once __DIR__ . '/PayConfig.php';

abstract class AbstractSDK {
	/**
	 * SDK验证成功后，返回UserSDK，否则返回null
	 * @param string $error_msg
	 * @return UserSDK
	 */
	abstract public function checkLogin(&$error_msg);
	
	/**
	 * 支付回调验证处理方法
	 * @param string $error_msg
	 * @return PaySDK
	 */
	abstract public function payCallback(&$error_msg);
	
	/**
	 * 返回SDK的前缀
	 * @return string
	 */
	public function prefix() {
		$class_name = get_class($this);
		return substr($class_name, 3) . '.';
	}
	
	public function paySuccess() {
		echo '1';
	}
	
	/**
	 * 返回各个SDK下订单需要的数据
	 * @param string $order_id
	 * @param long $rid
	 * @param string $open_id
	 * @param int $server_id
	 * @param string $nick
	 * @param int $goods_id
	 * @param string $goods_name
	 * @param float $money
	 */
	public function order($order_id, $open_id, $rid, $server_id, $nick, $goods_id, $goods_name, $money) {
		$ret['order_id'] = $order_id;
		$ret['open_id'] = $open_id;
		$ret['rid'] = $rid;
		$ret['server_id'] = $server_id;
		$ret['nick'] = $nick;
		$ret['goods_id'] = $goods_id;
		$ret['goods_name'] = $goods_name;
		$ret['money'] = $money;
		return $ret;
	}
	
	/**
	 * 获取SDK的特殊数据
	 * @return NULL
	 */
	public function getSDKData() {
		return null;
	}
	
	/**
	 * 公众号推送
	 * @param string $open_id
	 * @param string $msg
	 * @param int $msg_id
	 * @return array array('SUCCESS'=>'...', 'REJECTED'=>'...', 'FAILED'=>'...')
	 */
	public function pushPublic($open_id, $msg, $msg_id) {
		return null;
	}
	
	/**
	 * 公众号推送开关
	 * @param string $open_id
	 * @param int $status 1开 0关
	 * @param string $on_off 返回ON/OFF
	 * @return bool
	 */
	public function pushPublicOnOff($open_id, $status, &$on_off) {
		return false;
	}
	
	/**
	 * 
	 * @param User $user_controller
	 */
	public function getLoginUrl($user_controller) {
		
	}
	
	/**
	 * 用户首次打开应用
	 */
	public function dataReportInstall($open_id, $channel) {
		
	}
	
	/**
	 * 用户每次打开应用
	 */
	public function dataReportStartup($open_id, $channel) {
	
	}
	
	/**
	 * 用户创建游戏角色
	 */
	public function dataReportRegister($open_id, $rid, $server_id, $register_time) {
	
	}
	
	/**
	 * 用户登录进入游戏
	 */
	public function dataReportLogin($open_id, $rid, $server_id, $login_time) {
		
	}
	
	/**
	 * 用户充值完成
	 */
	public function dataReportPay($order_id, $money, $open_id, $rid, $server_id, $platform) {
	
	}
	
	/**
	 * 用户升级
	 */
	public function dataReportLevelUp($open_id, $rid, $server_id, $level, $upgrade_time) {
		
	}
}
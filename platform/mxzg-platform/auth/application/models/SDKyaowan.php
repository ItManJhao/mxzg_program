<?php
include __DIR__ . '/AbstractSDK.php';

import('Function.Http');
import('Function.Url');
import('Function.Client');

class SDKyaowan extends AbstractSDK {

	private $paykey = "bd512ec0c32f3ddddc03945e2cb";
	private $gameid = 1;
	private $appkey = '^_^dfh3:stddd-09-24!';

	private $goods_id_table = array();

	private $yaowan_datareport_gameid = 1;
	private $yaowan_datareport_key = '12345ddddyiTY';

	// 返回使用商品标识
    public function getPayFlag() {
        return 'h5';
    }

	function SDKyaowan() {
		$this->goods_id_table[101] = 8320;
		$this->goods_id_table[102] = 8321;
		$this->goods_id_table[103] = 8322;
		$this->goods_id_table[104] = 8323;
		$this->goods_id_table[105] = 8324;
		$this->goods_id_table[106] = 8325;
		$this->goods_id_table[107] = 8326;

		$this->goods_id_table[144] = 8923;
		$this->goods_id_table[145] = 8924;
		$this->goods_id_table[146] = 8925;
		$this->goods_id_table[147] = 8926;
		$this->goods_id_table[148] = 8927;
		$this->goods_id_table[149] = 8928;
		$this->goods_id_table[150] = 8929;

		$this->goods_id_table[151] = 8327;
		$this->goods_id_table[152] = 8328;
		$this->goods_id_table[154] = 8354;

		$this->goods_id_table[160] = 8738;
		$this->goods_id_table[161] = 8564;
		$this->goods_id_table[162] = 8565;
		$this->goods_id_table[163] = 8566;
		$this->goods_id_table[164] = 8567;

		$this->goods_id_table[171] = 8652;
		$this->goods_id_table[172] = 8653;
		$this->goods_id_table[173] = 8654;
		$this->goods_id_table[174] = 8655;
		$this->goods_id_table[175] = 8656;

		$this->goods_id_table[181] = 8872;
		$this->goods_id_table[182] = 8873;
		$this->goods_id_table[183] = 8874;
		$this->goods_id_table[184] = 8875;
		$this->goods_id_table[185] = 8876;
		$this->goods_id_table[186] = 8877;
	}

	private function genSign($arr) {
		ksort($arr, SORT_STRING);
		$str = '';
		foreach ($arr as $k => $v) {
			if ($sign_name == 'sign') {
				continue;
			}
			//echo "$k => $v\n";
			$str .= $v;
		}
		return md5($str . $this->appkey);
	}

	public function checkLogin(&$error_msg) {

		$arr['token'] = GET::STR('token');
		$arr['time'] = time();
		$arr['sign'] = $this->genSign($arr);

		$url = "http://h5-payment.aloco.com/api/api/login_check?" . http_build_query($arr);
		$json = sendGet($url);
		$ret = json_decode($json, true);
		//printTest($ret);
		if ($ret['code'] != 0) {
			$error_msg = $ret['code'] . ', ' . $ret['msg'];
			return false;
		}

		if (!$ret['uid']) {
			$error_msg = 'uid is empty';
			return false;
		}

		$user = new UserSDK();
		$user->open_id = $this->prefix() . $ret['uid'];
		$user->focus = $ret['is_focus'] ? 1 : 0;
		$user->head_img = $ret['headimgurl'];

		switch ($ret['user_type']) {
			case 'wx':
				$user->account_type = 1; // 微信
				break;
			case 'qq':
				$user->account_type = 2; // QQ
				break;
			case 'wb':
				$user->account_type = 3; // 微博
				break;
			default:
				$user->account_type = 0;
				break;
		}

		return $user;
	}

	public function payCallback(&$error_msg) {

		$trans_id = GET::STR('trans_id');
		$product_id = GET::INT('product_id');
		$txid = GET::STR('txid');
		$rmb = GET::STR('rmb');
		$sign = GET::STR('sign');

		if (!$txid) {
			$error_msg = 'txid(order id) is empty';
			return null;
		}

		$new_goods_id = 0;
		if ($product_id) {
			foreach ($this->goods_id_table as $k => $v) {
				if ($v == $product_id) {
					$new_goods_id = $k;
					break;
				}
			}
		}

		// 校验签名 begin {
		$arr_get = $_GET;
		unset($arr_get['sign']);
		unset($arr_get['action']);
		unset($arr_get['platform']);

		ksort($arr_get);

		$str = http_build_query($arr_get);
		$str .= '&key=' . $this->paykey;
		$md5 = strtoupper(md5($str));

		if ($sign != $md5) {
			$error_msg = "Sign Err, recv = '$sign', my = '$md5'";
			return null;
		}
		// end }

		// 金额小于1元的直接抛弃掉
		if ($rmb < 1) {
			$error_msg = 'amount < 1';
			return null;
		}

		// 校验金额
		global $db;
		$sql = "select * from charge where order_id = '" . $txid . "'";
		$charge = $db->getFirstRow($sql);
		if (!$charge) {
			$error_msg = 'charge not found';
			return null;
		}
		if (abs($charge['money'] - $rmb)>1) {
			$error_msg = 'sdk amount != charge money';
			return null;
		}

		$pay_sdk = new PaySDK();
		$pay_sdk->order_id = $txid;
		$pay_sdk->ext_data = $trans_id;
		$pay_sdk->new_goods_id = $new_goods_id;
		return $pay_sdk;
	}

	public function paySuccess() {
		echo 'SUCCESS';
	}

	public function order($order_id, $open_id, $rid, $server_id, $nick, $goods_id, $goods_name, $money) {
		/*
		 * uid:openId,
				gameid:AppConfig['gameid'] || 0,
				txid:object['order_id'],
				good_id:goodCfg[this.getGoodsId()],
				good_type:goodCfg['RechargeType'] > 0 ? 3 : 1
		 */

		$p_goods_id = $this->goods_id_table[$goods_id];


		$tmp = explode('.', $open_id);
		$user_id = $tmp[1] ? $tmp[1] : $open_id;

		$ret['uid'] = $user_id;
		$ret['gameid'] = $this->gameid;
		$ret['txid'] = $order_id;
		$ret['good_id'] = $p_goods_id;

		return $ret;
	}

	public function pushPublic($arr_open_ids, $msg, $msg_id) {

		$str_user_ids = '';

		foreach ($arr_open_ids as $open_id) {

			$tmp = explode('.', $open_id);
			$user_id = $tmp[1] ? $tmp[1] : $open_id;

			if ($str_user_ids) {
				$str_user_ids .= "," . $user_id;
			} else {
				$str_user_ids = $user_id;
			}
		}

		$params['uid'] = $str_user_ids;
		$params['msg'] = $msg;
		$params['gameid'] = $this->gameid;
		$params['type'] = 1;
		$params['msg_type'] = $msg_id;
		$params['sign'] = $this->genSign($params);

		$url = 'http://h5-payment.aloco.com/api/wxpush/push';
		// die($url);
		$json = sendPost($url, http_build_query($params));
		$ret = json_decode($json, true);

		$result = array(
				'SUCCESS'=>array(),
				'REJECTED'=>array(),
				'FAILED'=>array(),
		);

		if ($ret['success']) {
			foreach ($ret['success'] as $tmp) {
				$result['SUCCESS'][] = $this->prefix() . $tmp;
			}
		}
		if ($ret['rejected']) {
			foreach ($ret['rejected'] as $tmp) {
				$result['REJECTED'][] = $this->prefix() . $tmp;
			}
		}
		if ($ret['failed']) {
			foreach ($ret['failed'] as $tmp) {
				$result['FAILED'][] = $this->prefix() . $tmp;
			}
		}
		return $result;
	}

	public function pushPublicOnOff($open_id, $status, &$on_off) {
		$tmp = explode('.', $open_id);
		$user_id = $tmp[1] ? $tmp[1] : $open_id;

		$params['uid'] = $user_id;
		$params['gameid'] = $this->gameid;
		$params['type'] = $status ? 0 : 1;
		$params['sign'] = $this->genSign($params);

		$url = 'http://h5-payment.aloco.com/api/wxpush/is_remind_yx?' . http_build_query($params);
		//die($url);
		$json = sendGet($url);
		$ret = json_decode($json, true);
		//printTest($ret);
		if ($ret['code'] == 0) {
			if ($ret['msg'] == 'on') {
				$on_off = 'ON';
			} else {
				$on_off = 'OFF';
			}
			return true;
		} else {
			return false;
		}
	}

	public function dataReportRegister($open_id, $rid, $server_id, $register_time) {
		global $db;
		$user = $db->getFirstRow("select open_id, platform, channel, os, browser, imei, idfa, idfv from `user` where open_id = '" . $db->escape($open_id) . "'");
		if (!$user) {
			return;
		}

		// 要玩的数据上报
		$tmp = explode('.', $user['channel']);
		if ($tmp[1]) {
			list($campagin_name, $source_name) = explode('|', $tmp[1]);
		}

		$params['m'] = 'Dfh3';
		$params['action'] = 'user';
		$params['game_id'] = $this->yaowan_datareport_gameid;
		$params['uid'] = $rid;
		$params['page_open_time'] = time();
		$params['reg_time'] = time();
		$params['create_time'] = time();
		$params['ip'] = getIP();
		$params['system'] = $user['os'];
		$params['browser'] = $user['browser'];
		$params['campagin_name'] = $campagin_name ? $campagin_name : 'unknown';
		$params['source_name'] = $source_name ? $source_name : 'unknown';
		$params['sign'] = md5($params['game_id'] . $params['create_time'] . $params['uid'] . $this->yaowan_datareport_key);

		$url = 'http://mob-adm.yaowan.com/cron.php?' . http_build_query($params);
		$html = sendGet($url);
		addLog('yaowanRegister', $url . "\n" . $html);
	}

	/**
	 * 用户登录进入游戏
	 */
	public function dataReportLogin($open_id, $rid, $server_id, $login_time) {
		global $db;
		$user = $db->getFirstRow("select open_id, platform, channel, os, browser, imei, idfa, idfv from `user` where open_id = '" . $db->escape($open_id) . "'");
		if (!$user) {
			return;
		}

		// 要玩的数据上报

		$params['m'] = 'Dfh3';
		$params['action'] = 'login';
		$params['game_id'] = $this->yaowan_datareport_gameid;
		$params['uid'] = $rid;
		$params['login_time'] = time();
		$params['ip'] = getIP();
		$params['system'] = $user['os'];
		$params['browser'] = $user['browser'];
		$params['district_id'] = $server_id;
		$params['role'] = $rid;
		$params['sign'] = md5($params['game_id'] . $params['uid'] . $params['login_time'] . $this->yaowan_datareport_key);

		$url = 'http://mob-adm.yaowan.com/cron.php?' . http_build_query($params);
		$html = sendGet($url);
		addLog('yaowanLogin', $url . "\n" . $html);
	}

	/**
	 * 用户充值完成
	 */
	public function dataReportPay($order_id, $money, $open_id, $rid, $server_id, $platform) {
		return;
		global $db;
		$user = $db->getFirstRow("select open_id, os, imei, idfa, idfv from `user` where open_id = '" . $db->escape($open_id) . "'");
		if (!$user) {
			return;
		}

		// 要玩的数据上报

		$params['m'] = 'Dfh3';
		$params['action'] = 'pay';
		$params['game_id'] = $this->yaowan_datareport_gameid;
		$params['order_id'] = $order_id;
		$params['uid'] = $rid;
		$params['system'] = $user['os'];
		$params['district_id'] = $server_id;
		$params['role_name'] = $rid;
		$params['create_time'] = time();
		$params['price'] = $money;
		$params['sign'] = md5($params['game_id'] . $params['create_time'] . $params['uid'] . $this->yaowan_datareport_key);

		$url = 'http://mob-adm.yaowan.com/cron.php?' . http_build_query($params);
		$html = sendGet($url);
		addLog('yaowanPay', $url . "\n" . $html);
	}
}
?>

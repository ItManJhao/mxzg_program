<?php
include __DIR__ . '/AbstractSDK.php';

import('Function.Http');
import('Function.Url');
import('Function.Client');

class SDKtemp extends AbstractSDK {

	private $ry_android_key = '660dfc4ecbe6dddd61228f97e';
	private $ry_ios_key = '3c321e18709dddd973fe7472a';
	private $ry_url = 'http://log.reyun.com/';

	private $yaowan_datareport_gameid = 1;
	private $yaowan_datareport_key = '123456KMjxuyiTY';

	// 返回使用商品标识
    public function getPayFlag() {
        return 'all';
    }

	public function checkLogin(&$error_msg) {
		$open_id = trim(GET::STR('open_id'));
		$f_openid = REQUEST::STR('f_openid'); // 邀请者
		$f_serverid = REQUEST::STR('f_serverid'); // 邀请者登录服务器
		if (!$open_id) {
			$error_msg = 'open_id is empty.';
			return null;
		}

		$sdkhttpdat = REQUEST::STR('sdkhttpdat');
		if ($sdkhttpdat) {
			addLog('temp.test', $sdkhttpdat);
			addLog('temp.test2', json_decode($sdkhttpdat, true));
		}

		$u = new UserSDK();
		$u->open_id = $this->prefix() . $open_id;
		$u->head_img = 'http://wx.qlogo.cn/mmopen/F9JreP39IIrxMG7CD6iaibjjOnFgPloS6qJs7N6ibWbaY8vCLTWDpTicrEjc2gS3yY4mLZU6yC4kbdwCgfVnYkRDCQ/0'; // 测试用
		if ($f_openid AND $f_serverid) {
			$u->f_openid = $this->prefix() . $f_openid;
			$u->f_serverid = $f_serverid;
		}
		$u->sdkhttpdat = json_encode(array('test','test2'));
		return $u;
	}

	public function payCallback(&$error_msg) {
		$pay_sdk = new PaySDK();
		$pay_sdk->order_id = GET::STR('order_id');
		if (!$pay_sdk->order_id ) {
			$error_msg="order_id is null";
			return;			
		}
		$pay_sdk->money = GET::STR('money');
		$pay_sdk->open_id = GET::STR('open_id');
		$pay_sdk->goods_id = GET::STR('goods_id');
		return $pay_sdk;
	}


	public function payRes($code,$msg='') {
		if ($code == 0) {
			exit('SUCCESS');
		} else {
			exit(json_encode(array('code'=>$code,'msg'=>$msg)));
		}
	}

	public function order($charge) {

		$tmp = explode('.', $charge['user_id']);

		if ($tmp[0] . '.' != $this->prefix()) {
			// 必须是temp.账号才能通过
			return null;
		}

		$url = SITE_ROOT . "?action=pay.callback&platform=temp&order_id={$charge['order_id']}&goods_id={$charge['goods_id']}&money={$charge['money']}&open_id={$charge['user_id']}";
		$ret = sendGet($url);

		return "payCallback: $ret";
	}


}
?>

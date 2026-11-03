<?php
class UserSDK {
	/**
	 * SDK用户唯一ID
	 * @var string
	 */
	public $open_id;
	
	/**
	 * 是否关注公众号
	 * @var int
	 */
	public $focus;
	
	/**
	 * 推荐人的open_id
	 * @var string
	 */
	public $f_openid;
	
	/**
	 * 头像
	 * @var string
	 */
	public $head_img;
	
	/**
	 * 账号类型 0自有账号 1微信 2QQ 3微博 4游客
	 * @var int
	 */
	public $account_type;
	
	/**
	 * sdk数据
	 * @var mixed
	 */
	public $sdk_data;
	
	public function UserSDK() {
		$this->open_id = '';
		$this->focus = 1;
		$this->f_openid = '';
		$this->head_img = '';
		$this->account_type = 0;
	}
}

class PaySDK {
	/**
	 * 我们的充值订单ID
	 * @var string
	 */
	public $order_id;
	
	/**
	 *  对方返回的支付数据，一般存对方的订单号
	 * @var string
	 */
	public $ext_data;
	
	/**
	 * SDK回调返回的充值金额
	 * @var float
	 */
	public $real_money;
	
	/**
	 * 充值过程中，用户选择了新的商品
	 * @var int
	 */
	public $new_goods_id;

	/**
	 * 商品ID
	 * @var int
	 */
	public $goods_id;

	/**
	 * SDK 用户id
	 * @var int
	 */
	public $user_id;
	
	public function PaySDK() {
		$this->user_id = '';
		$this->goods_id = 0;
		$this->order_id = '';
		$this->ext_data = '';
		$this->real_money = 0;
		$this->new_goods_id = 0;
	}
}
<?php
class PayConfig {
	/**
	 * 商品ID
	 * @var string
	 */
	public $idx;
	/**
	 * 对应金币
	 * @var int
	 */
	public $gold;
	/**
	 * 价格
	 * @var double
	 */
	public $money;
	/**
	 * 商品名
	 * @var string
	 */
	public $name;

	public function PayConfig($idx, $gold, $money, $name) {
		$this->idx = $idx;
		$this->gold = $gold;
		$this->money = $money;
		$this->name = $name;
	}
}

$CHARGE_CFG = array();
// H5
//								商品ID	灵玉		RMB		商品名
$charge_cfg_h5 = array();
$charge_cfg_h5[1] = new PayConfig(1, 		0, 		25,		'月卡');
$charge_cfg_h5[2] = new PayConfig(2, 		0, 		18, 	'周卡');
$charge_cfg_h5[3] = new PayConfig(3, 		600, 	6,		'600灵玉');
$charge_cfg_h5[4] = new PayConfig(4,		3000,	30,		'3000灵玉');
$charge_cfg_h5[5] = new PayConfig(5, 		6800, 	68, 	'6800灵玉');
$charge_cfg_h5[6] = new PayConfig(6, 		9800, 	98, 	'9800灵玉');
$charge_cfg_h5[7] = new PayConfig(7, 		12800, 	128, 	'12800灵玉');
$charge_cfg_h5[8] = new PayConfig(8, 		19800, 	198, 	'19800灵玉');
$charge_cfg_h5[9] = new PayConfig(9, 		32800, 	328, 	'32800灵玉');
$charge_cfg_h5[10] = new PayConfig(10, 		64800, 	648, 	'64800灵玉');


// IOS
//								商品ID	灵玉		RMB		商品名\
$charge_cfg_ios = array();
$charge_cfg_ios[1] = new PayConfig(1, 		0, 		25,		'月卡');
$charge_cfg_ios[2] = new PayConfig(2, 		0, 		18, 	'周卡');
$charge_cfg_ios[3] = new PayConfig(3, 		600, 	6,		'600灵玉');
$charge_cfg_ios[4] = new PayConfig(4,		3000,	30,		'3000灵玉');
$charge_cfg_ios[5] = new PayConfig(5, 		6800, 	68, 	'6800灵玉');
$charge_cfg_ios[6] = new PayConfig(6, 		9800, 	98, 	'9800灵玉');
$charge_cfg_ios[7] = new PayConfig(7, 		12800, 	128, 	'12800灵玉');
$charge_cfg_ios[8] = new PayConfig(8, 		19800, 	198, 	'19800灵玉');
$charge_cfg_ios[9] = new PayConfig(9, 		32800, 	328, 	'32800灵玉');
$charge_cfg_ios[10] = new PayConfig(10, 	64800, 	648, 	'64800灵玉');






// ANDROID
//								        商品ID	灵玉		RMB		商品名
$charge_cfg_android = array();
$charge_cfg_android[1] = new PayConfig(1, 		0, 		25,		'月卡');
$charge_cfg_android[2] = new PayConfig(2, 		0, 		18, 	'周卡');
$charge_cfg_android[3] = new PayConfig(3, 		600, 	6,		'600灵玉');
$charge_cfg_android[4] = new PayConfig(4,		3000,	30,		'3000灵玉');
$charge_cfg_android[5] = new PayConfig(5, 		6800, 	68, 	'6800灵玉');
$charge_cfg_android[6] = new PayConfig(6, 		9800, 	98, 	'9800灵玉');
$charge_cfg_android[7] = new PayConfig(7, 		12800, 	128, 	'12800灵玉');
$charge_cfg_android[8] = new PayConfig(8, 		19800, 	198, 	'19800灵玉');
$charge_cfg_android[9] = new PayConfig(9, 		32800, 	328, 	'32800灵玉');
$charge_cfg_android[10] = new PayConfig(10, 	64800, 	648, 	'64800灵玉');


$CHARGE_CFG['h5'] = $charge_cfg_h5;
$CHARGE_CFG['ios'] = $charge_cfg_ios;
$CHARGE_CFG['android'] = $charge_cfg_android;

/**
 * 获取充值配置
 * @param int $goods_id
 * @return PayConfig
 */
function getPayConfig($platform, $goods_id) {
	global $CHARGE_CFG;
	if ($platform=='all') {
		foreach ($CHARGE_CFG as $pf => $val) {
			if (isset($val[$goods_id])) {
				return $val[$goods_id];
			}
		}
	} else {
		return $CHARGE_CFG[$platform][$goods_id];
	}
}

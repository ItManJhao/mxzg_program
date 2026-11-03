<?php

class SDKtanwan extends \core\lss {

	// private $paykey = "99a5d8fd6fa358e6fed8a8f5b3bbf5e1";
	// private $gameid = 1;
	// private $loginkey = '1a38cf0f0c10abc9fed882618d94fafb';
	// private $loginurl = 'https://www.feifansite.com/ios/oauth.php';
	// private $send_key = '^-^ayjsgame!@#api&201912';
 //    private $send_url = '/recharge/chargeCallback';
 //    private $send_cation = 'recharge.chargeCallback';
 //    private $get_role_url = '/role/roleInfo';
 //    private $check_ip = [
 //                '47.244.241.221','47.75.90.160'
 //            ];
 //    private $gift_key = 'cd8cf80cfc434b029275d5d6a2e647f3';
 //    private $gift_list_url = '/recharge/tanwanDirectBuyGemList';
 //    private $gift_can_url = '/recharge/tanwanCanDirectBuyGem';

    private $paykey;
    private $gameid;
    private $loginkey;
    private $loginurl;
    private $send_key;
    private $send_url;
    private $send_cation;
    private $get_role_url;
    private $check_ip;
    private $gift_key;
    private $gift_list_url;
    private $gift_can_url;
    private $firebase_push_url;
    function  __construct() {
        parent::__construct();
        $this->paykey = $this->platform_data['paykey'];
        $this->gameid = $this->platform_data['gameid'];
        $this->loginkey = $this->platform_data['loginkey'];
        $this->loginurl = $this->platform_data['loginurl'];
        $this->send_key = $this->platform_data['send_key'];
        $this->send_url = $this->platform_data['send_url'];
        $this->send_cation = $this->platform_data['send_cation'];
        $this->get_role_url = $this->platform_data['get_role_url'];
        $this->check_ip = $this->platform_data['check_ip'];
        $this->gift_key = $this->platform_data['gift_key'];
        $this->gift_list_url = $this->platform_data['gift_list_url'];
        $this->gift_can_url = $this->platform_data['gift_can_url'];
        $this->firebase_push_url = $this->platform_data['firebase_push_url'];
    }

	private function getLoginSign($str) {
		return md5($str . $this->loginkey);
	}
	private function getParamSign($data, $sign_key) {
		ksort($data);
        $sign_str ='';
        foreach($data as $key=>$val){
        	if(!empty($val) && $key != 'sign' && $key != 's'){
				$sign_str .= $key . '=' . urlencode($val) . '&';
        	}
        }
        $sign_str = substr($sign_str,0,-1);
        $sign_str .= $sign_key;

        return [
            'sign_str' => $sign_str,
            'sign' => md5($sign_str)
        ];
	}
    private function getParamValueSign($data, $sign_key) {
        ksort($data);
        $sign_str ='';
        foreach($data as $key=>$val){
            if(!empty($val) && $key != 'sign' && $key != 's'){
                $sign_str .= urlencode($val);
            }
        }
        $sign_str .= $sign_key;

        return [
            'sign_str' => $sign_str,
            'sign' => md5($sign_str)
        ];
    }

	public function checkLogin() {
        $data = [];
		$data['appid'] = $this->getParam('game_id', 0);
		$data['uid'] = $this->getParam('open_id', 0);
		$data['sessionid'] = $this->getParam('access_token', 0);
		$data['token'] = $this->getLoginSign($data['appid'].$data['uid'].$data['sessionid']);

        $return_data = [
            'code' => 1,
            'msg' => '验证成功！'
        ];

        //特殊处理：access_token为空则不验证
        if(empty($data['sessionid'])){
            return $return_data;
        }
        
		$json = curlRequest($this->loginurl, 'post', $data);
		$ret = json_decode($json, true);
		if($ret ){
			if($ret['code'] == 1){
				return $return_data;
			}else{
                $return_data['code'] = 0;
                $return_data['msg'] = $ret['msg'];
			}
		}
		return $return_data;
	}

	public function payCallback($recharge_callback_id) {

        $ip = get_ip();
        $now_time = time();
        $xOrderSandbox = 0; //沙箱状态的订单会有该参数且值为1，正式订单无该参数
        $BillNo = $this->getParam('cp_orderid');        //游戏订单号
        $pay_type = $this->getParam('pay_type');      //支付方式：1-游戏内购 2-第三方支付
        $orderId = $this->getParam('orderid');      //sdk订单号
        $open_id = $this->getParam('uid');          //open_id
        $amount = $this->getParam('pay_usd');        //金额
        $goods_id_check = $goods_id = $this->getParam('product_id');   //商品id
        $role_id = $this->getParam('role_id');       //角色id
        $sid = $this->getParam('server_id');         //区服id
        $pay_time = $this->getParam('pay_date');         //支付时间
        $device_type = $this->getParam('os');         //设备类型1-pc、2-ios、3-android
        $extraInfo = $this->getParam('ext1', '');  //透传的额外参数
        $sign = $this->getParam('sign');            //签名

        if(empty($BillNo)){
            $BillNo = 0;    
        }
        
        $where_str = 'where 1 ';
        
        try {
            $this->db->begin();     //开始mysqli事务

            //处理透传参数
            //获取商品id（2020-3-18-lby）
            $level = 0;
            $vip = 0;
            if(!empty($extraInfo)){
                $extraInfo_arr = decryptParam(11, $extraInfo);
                $extraInfo = json_encode($extraInfo_arr);
                $goods_id = isset($extraInfo_arr['goods_id']) ? $extraInfo_arr['goods_id'] : 0;
                $level = isset($extraInfo_arr['level']) ? $extraInfo_arr['level'] : 0;
                $vip = isset($extraInfo_arr['vip']) ? $extraInfo_arr['vip'] : 0;

                //校验商品id是否合法
                if($pay_type != 2 && !empty($goods_id)){     //不是第三方
                    $this->db->db_tabel('product');
                    $goods_id_str = "where id='$goods_id' ";
                    $product_info_r = $this->db->db_find("*", $goods_id_str);
                    if($product_info_r){
                        if($goods_id_check != $product_info_r['goods_id']){
                            throw new \Exception("商品id验证失败", 10002);
                        }
                    }
                }
            }

            //验证ip是否符合
            if(!in_array($ip, $this->check_ip)){
                throw new \Exception("ip验证失败", 10002);
            }
            //进行数据验签
            $sign_data = $this->getParamSign($_REQUEST, $this->paykey);
            $sign_new = $sign_data['sign'];
            if($sign_new != $sign){     //验签失败
                throw new \Exception("验签失败--" . $sign_data['sign_str'], 10002);
            }

            // if(!empty($BillNo)){
      //           $where_str .= "and game_order_id='$BillNo' ";
      //       }else{
      //        throw new \Exception("参数错误--BillNo", 10002);
      //       }

            if(!empty($orderId)){
                $where_str .= "and sdk_order_id='$orderId' ";
            }else{
                throw new \Exception("参数错误--orderId", 10002);
            }
            if(!empty($role_id)){
                $where_str .= "and role_id='$role_id' ";
            }else{
                throw new \Exception("参数错误--roleId", 10002);
            }

            //处理第三方商品id
            if($pay_type == 2 && !empty($goods_id)){
                //转换第三方商品id为商品id
                $this->db->db_tabel('product');
                $where_product_str = "where three_product_id='$goods_id' ";
                $product_info = $this->db->db_find("*", $where_product_str);
                if($product_info){
                    $_REQUEST['product_id'] = $product_info['id'];
                    $goods_id = $product_info['id'];
                }
            }
            //获取订单数据信息
            $sql = "
                select recharge.*,server.extranet_host,server.intranet_host,server.http_port
                from recharge 
                left join server on server.id=recharge.sid 
                $where_str
            ";
            $order_info = $this->db->db_sql($sql);

            $status = 1;
            if(!$order_info){   //订单不存在，创建订单
                $keyarr = [
                    'game_order_id','sdk_order_id','open_id','role_id','sid','pay_type','goods_id','ip','level','vip','money','record_money','status','is_test','extraInfo','device_type','pay_time','updated_at','created_at'
                ];
                $valuearr = [
                    "'$BillNo'","'$orderId'","'$open_id'",$role_id,$sid,"'$pay_type'","'$goods_id'","'$ip'","'$level'","'$vip'","'$amount'","'$amount'",$status,$xOrderSandbox,"'$extraInfo'","'$device_type'","'$pay_time'",$now_time,$now_time
                ];
                $this->db->db_tabel('recharge');
                $id = $this->db->db_insert($keyarr, $valuearr);    //插入数据，获取主键id
                if(!$id){
                    throw new \Exception("创建订单失败", 10002);
                }

                //获取服务器信息
                $sql = "
                    select * 
                    from server 
                    where id='$sid'
                ";
                $server_info = $this->db->db_sql($sql);
                if(!$server_info){
                    throw new \Exception("参数出错--serverid", 10001);
                }
                $server_info = $server_info[0];
            }elseif(in_array($order_info[0]['status'], array(-11,3)) ){    //订单已经完成或者是重复订单
                return 'SUCCESS';
            }elseif(!in_array($order_info[0]['status'], array(0,1,2,4)) ){     //订单未发货或者发货失败重新发货
                throw new \Exception("未知订单状态", 10002);
            }else{
                $id = $order_info[0]['id'];
                $server_info = [
                    'intranet_host' => $order_info[0]['intranet_host'],
                    'http_port' => $order_info[0]['http_port']
                ];
            }

            //处理发货
            $send_data = [
                'action' => $this->send_cation,
                'orderId' => $BillNo,
                'money' => $amount * 100,
                'payTime' => $now_time,
                'status' => 1,
                'isTest' => $xOrderSandbox,
                'platformOrderId' =>$orderId,
            ];
            //生成发货的签名
            $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . $this->send_url;

            //用curl请求发货
            $send_result = pay_to_game($send_url,$send_data,$this->send_key);
            //修改订单信息    
            if($send_result['repeat'] == 'yes'){    //重复订单
                $status = -11;
            }else{
                $status = $send_result['result'] == 'success' ? 3 : 4;
            }
            $debug = json_encode($send_result['debug']);
            $request_url = $send_result['request_url'];

            $update_data = [
                'status' => $status,
                'server_status' => 1,
                'debug' => $debug,
                'request_url' => $request_url,
                'updated_at' => $now_time
            ];

            //获取cp研发订单号(2020-04-17-lby)
            if(isset($send_result['debug']['data'])){
                $cp_data = $send_result['debug']['data'];
                if(isset($cp_data['cp_order_id'])){
                    $BillNo = $cp_data['cp_order_id'];
                    $update_data['game_order_id'] = $cp_data['cp_order_id'];
                }
                if(isset($cp_data['level'])){
                    $update_data['level'] = $cp_data['level'];
                }
                if(isset($cp_data['vip'])){
                    $update_data['vip'] = $cp_data['vip'];
                }

                //2020-07-16-lby-韩版平台和游戏的金额对不上，使用游戏方返回的金额
                if(isset($cp_data['money'])){
                    $update_data['money'] = $cp_data['money'];
                }
            }
            
            $this->db->db_tabel('recharge');
            $res = $this->db->db_update($update_data, "where id=$id ");    //更新数据

            //生成日志数据
            $keyarr_log = [
                'recharge_id', 'game_order_id','sdk_order_id','open_id','role_id','sid','goods_id','ip','money','status','is_test','extraInfo','server_status','debug','request_url','device_type','pay_time','created_at'
            ];
            $valuearr_log = [
                $id,"'$BillNo'","'$orderId'","'$open_id'",$role_id,$sid,"'$goods_id'","'$ip'","'$amount'",$status,$xOrderSandbox,"'$extraInfo'",1,"'".$debug."'","'".$request_url."'","'$device_type'","'$pay_time'",$now_time
            ];
            $this->db->db_tabel('recharge_log');
            $this->db->db_insert($keyarr_log, $valuearr_log);    //插入数据，获取主键id
            
            $this->db->commit();         //提交mysqli事务
            if($status == 3){
                return 'SUCCESS';
            }else{
                return 'fail';
            }
        } catch (\Exception $e) {
            $this->db->rollBack();         //回滚mysqli事务

            $msg = $e->getMessage();
            $update_data = [
                'game_order_id' => $BillNo,
                'sdk_order_id' => $orderid,
                'status' => 1,
                'debug' => $msg
            ];
            $this->db->db_tabel('recharge_callback');
            $res = $this->db->db_update($update_data, "where id=" . $recharge_callback_id);    //更新数据
            $this->db->commit();         //提交mysqli事务

            return 'fail';
        }

	}

    // 获取角色列表
    public function getRoles() {
        $open_id = $this->getParam('uid', 0);
        $server_id = $this->getParam('server_id', 0);

        $result = [
            'code' => 0,
            'message' => '',
            'data' => []
        ];
        if(empty($open_id)){
            $result['message'] = 'uid不能为空';
            echo json_encode($result);
            exit;
        }
        if(empty($server_id)){
            $result['message'] = 'server_id不能为空';
            echo json_encode($result);
            exit;
        }

        $this->db->db_tabel('user');
        $where_str = "where open_id='$open_id' ";
        $user_info = $this->db->db_find("*", $where_str);
        
        if(!$user_info){
            $result['message'] = 'uid出错';
            echo json_encode($result);
            exit;
        }

        //查询服务器信息
        $this->db->db_tabel('server');
        $where_str = "where id=$server_id ";
        $server_info = $this->db->db_find("*", $where_str);
        if(!$server_info){
            $result['message'] = 'server_id出错';
            echo json_encode($result);
            exit;
        }
        //获取游戏端角色信息
        $send_data = [
            'user_id' => $user_info['id'],
            'server_id' => $server_id,
        ];
        $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . $this->get_role_url;
        $ret_json = curlRequest($send_url . '?' . http_build_query($send_data),'get');
        $ret_data = json_decode($ret_json, true);
        if(!isset($ret_data['code']) || $ret_data['code'] != 200){
            $result['message'] = '响应出错';
            echo json_encode($result);
            exit;
        }
        $result = [
            'code' => 1,
            'message' => '请求成功',
            'data' => []
        ];
        $role_info = json_decode($ret_data['desc'], true);
        $result['data'][] = [
            'role_id' => $role_info['role_id'],
            'role_name' => $role_info['role_name'],
        ];
        echo json_encode($result);
        exit;
    }

    // 获取服务器列表
    public function getServers() {
        $now_time = time();
        $sql = "
            select *
            from server
            where type=0
        ";
        $server_data = $this->db->db_sql($sql);

        $result = [
            'code' => 1,
            'message' => '请求成功',
            'data' => []
        ];
        foreach($server_data as $server_val){
            if($server_val['status'] == 0){
                $type = 0;
            }elseif(in_array($server_val['status'],[1,2])){
                $type = 1;
            }
            if($server_val['defend_end_time'] >= $now_time){
                $type = 2;
            }

            //判断服务器类型，不是正式服，全部返回未开放
            if($server_val['type'] != 0){
                $type = 0;
            }
            $result['data'][] = [
                'server_id' => $server_val['id'],
                'server_name' => $server_val['server_name'],
                'open_time' => $server_val['open_time'],
                'type' => $type
            ];
        }
        echo json_encode($result);
        exit;
    }

    // 玩家可以购买礼包列表（礼包有限购）
    public function getDirectBuyGemList() {
        $open_id = $this->getParam('uid', '');
        $roleid = $this->getParam('roleid', '');
        $serverid = $this->getParam('serverid', '');
        $sign = $this->getParam('sign', '');

        $result = [
            'code' => 0,
            'message' => '',
            'data' => '{}'
        ];
        //验证签名
        $sign_data = $this->getParamValueSign($_REQUEST, $this->gift_key);
        $sign_new = $sign_data['sign'];
        if($sign_new != $sign){     //验签失败
            $result['message'] = '验签失败';
            echo json_encode($result);
            exit;
        }

        if(empty($roleid)){
            $result['message'] = '角色id不能为空';
            echo json_encode($result);
            exit;
        }
        if(empty($serverid)){
            $result['message'] = '服务器id不能为空';
            echo json_encode($result);
            exit;
        }
        //获取服务器信息
        $sql = "
            select * 
            from server
            where id='" . $serverid . "'
        ";
        $server_info = $this->db->db_sql($sql);
        if(!$server_info){
            $result['message'] = '服务器id参数出错';
            echo json_encode($result);
            exit;
        }
        $server_info = $server_info[0];
        $send_data = [
            'roleid' => $roleid
        ];
        $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . $this->gift_list_url;
        $send_url .= '?' . http_build_query($send_data);
        $result = curlRequest($send_url, $request_type = 'get');
        $result_arr = json_decode($result, true);
        $three_product_ids = [];
        if($result_arr['code'] == 1){   //返回成功
            $product_arr = $result_arr['data']['canbuy_product_id'];
            if(!empty($product_arr)){
                $product_str = implode(',', $product_arr);
                $sql = "
                    select * 
                    from product
                    where id in($product_str) and three_product_id != ''
                ";
                $product_data = $this->db->db_sql($sql);
                foreach($product_data as $product_val){
                    $three_product_ids[] = $product_val['three_product_id'];
                }
                $result_arr['data']['canbuy_product_id'] = $three_product_ids;
                $result = json_encode($result_arr);
            }
        }
        echo $result;
        exit;

    }

    // 玩家是否能购买礼包（礼包有限购）
    public function canDirectBuyGem() {
        $open_id = $this->getParam('uid', '');
        $roleid = $this->getParam('roleid', '');
        $serverid = $this->getParam('serverid', '');
        $product_id = $this->getParam('product_id', '');
        $sign = $this->getParam('sign', '');

        $result = [
            'code' => 0,
            'message' => '',
            'data' => '{}'
        ];
        //验证签名
        $sign_data = $this->getParamValueSign($_REQUEST, $this->gift_key);
        $sign_new = $sign_data['sign'];
        if($sign_new != $sign){     //验签失败
            $result['message'] = '验签失败';
            echo json_encode($result);
            exit;
        }

        if(empty($roleid)){
            $result['message'] = '角色id不能为空';
            echo json_encode($result);
            exit;
        }
        if(empty($serverid)){
            $result['message'] = '服务器id不能为空';
            echo json_encode($result);
            exit;
        }
        //获取服务器信息
        $sql = "
            select * 
            from server
            where id='" . $serverid . "'
        ";
        $server_info = $this->db->db_sql($sql);
        if(!$server_info){
            $result['message'] = '服务器id参数出错';
            echo json_encode($result);
            exit;
        }
        $server_info = $server_info[0];
        //转换第三方商品id为商品id
        $this->db->db_tabel('product');
        $where_str = "where three_product_id='$product_id' ";
        $product_info = $this->db->db_find("*", $where_str);
        $send_data = [
            'roleid' => $roleid,
            'product_id' => isset($product_info['id']) ? $product_info['id'] : '0'
        ];
        $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . $this->gift_can_url;
        $send_url .= '?' . http_build_query($send_data);
        $result = curlRequest($send_url, $request_type = 'get');
        echo $result;
        exit;

    }

    // 给玩家消息推送
    public function firebasePush() {
        $now_time = time();
        $appid = $this->gameid;
        $user_id = $this->getParam('user_id');
        $is_broadcast = $this->getParam('is_broadcast', 0);
        $title = $this->getParam('title');
        $content = $this->getParam('content');
        $time = $this->getParam('time');
        $sign = $this->getLoginSign($appid.$time);

        $params = [
            'title' => $title,
            'content' => $content,
            'appid' => $appid,
            'time' => $time,
            'sign' => $sign,
            'is_broadcast' => $is_broadcast,
        ];

        $open_id_arr = [];
        $user_id_str = '';
        if($is_broadcast == 0){     //1为广播，即针对全服玩家推送  0为不广播，针对单用户推送
            //获取渠道uid（open_id）
            $user_ids = json_decode($user_id, true);
            $user_id_str = implode(',', $user_ids);
            $sql = "
                select open_id 
                from user
                where id in($user_id_str)
            ";
            $user_data = $this->db->db_sql($sql);
            if(!empty($user_data)){
                $open_id_arr = array_column($user_data, 'open_id');
            }
        }
        $params['uid'] = json_encode($open_id_arr);
        $json = curlRequest($this->firebase_push_url, 'post', $params);
        $ret = json_decode($json, true);
        $status = 0;
        if($ret ){
            if($ret['code'] == 1){
                $status = 1;
            }
        }
        //记录发送的消息
        $keyarr = [
            'appid','title','content','is_broadcast','user_ids','status','debug','time','created_at'
        ];
        $valuearr = [
            $appid,"'$title'","'$content'",$is_broadcast,"'$user_id_str'",$status,"'$json'",$time,$now_time
        ];
        $this->db->db_tabel('firebase_push_log');
        $id = $this->db->db_insert($keyarr, $valuearr);    //插入数据，获取主键id
        if(!$id){
            throw new \Exception("创建订单失败", 10002);
        }


        return $status;
    }

}

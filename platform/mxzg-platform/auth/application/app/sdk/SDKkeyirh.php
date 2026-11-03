<?php

class SDKkeyirh extends \core\lss {

	private $paykey = "250110158623e07bfb422653704db6bc";
	private $gameid = 1;
	private $loginkey = '7c9a1c54bb3583bb7af9054efbd9ba3c';
	private $loginurl = 'https://apioverseas.hnguangyi.cn/Api/Login/CheckLogin';
    private $send_key = '^-^ayjsgame!@#api&201912';
    private $send_url = '/recharge/chargeCallback';
    private $send_cation = 'recharge.chargeCallback';
    private $gift_key = 'bd512ec0c32f3ddddc03945e2cb';
    private $gift_list_url = '/recharge/tanwanDirectBuyGemList';
    private $gift_can_url = '/recharge/tanwanCanDirectBuyGem';

    function  __construct() {
        parent::__construct();
    }
    
    private function getLoginSign($str) {
        return md5($str . $this->loginkey);
    }

	private function getParamSign($data, $sign_key) {
		ksort($data);
        $sign_str ='';
        foreach($data as $key=>$val){
            $sign_str .= $key . '=' . $val . '&';
        }
        $sign_str .= 'PayKey=' . $sign_key;
        return [
            'sign_str' => $sign_str,
            'sign' => strtolower(md5($sign_str))
        ];
	}

    public function checkLogin() {
        $data = [];
        $data['GameId'] = $this->getParam('game_id', 0);
        $data['UserCode'] = $this->getParam('open_id', 0);
        $data['LoginToken'] = $this->getParam('access_token', 0);
        $data['Sign'] = $this->getLoginSign($data['GameId'].$data['UserCode'].$data['LoginToken']);

        $return_data = [
            'code' => 1,
            'msg' => '验证成功！'
        ];

        //特殊处理：access_token为空则不验证
        if(empty($data['LoginToken'])){
            return $return_data;
        }

        $json = curlRequest($this->loginurl, 'post', $data);
        $ret = json_decode($json, true);

        if($ret ){
            if($ret['Status'] == 0){
                return $return_data;
            }else{
                $return_data['code'] = 0;
                $return_data['msg'] = $ret['Msg'];
            }
        }
        return $return_data;
    }

	public function payCallback($recharge_callback_id) {
        $ip = get_ip();
        $now_time = time();
        $xOrderSandbox = $this->getParam('X-Order-Sandbox', 0); //沙箱状态的订单会有该参数且值为1，正式订单无该参数
        $BillNo = $this->getParam('BillNo');        //游戏订单号
        $orderId = $this->getParam('OrderId');      //sdk订单号
        $open_id = $this->getParam('UserCode');     //open_id
        $gameId = $this->getParam('GameId');        //游戏id
        $amount = $this->getParam('Amount');        //金额
        $goods_id = $this->getParam('ProductId');   //商品id
        $role_id = $this->getParam('RoleId');       //角色id
        $sid = $this->getParam('ServerId');         //区服id
        $order_status = $this->getParam('Status');        //充值状态：0.充值成功，1.充值失败
        $extraInfo = $this->getParam('ExtraInfo', '');  //透传的额外参数
        $UrlInfo = $this->getParam('UrlInfo', '');      //url拼接的平台的参数（贪玩的回调参数）
        $sign = $this->getParam('Sign');            //签名

        //获取商品id（2020-3-18-lby）
        $level = 0;
        $vip = 0;
        if(!empty($extraInfo)){
            $extraInfo_arr = decryptParam(11, $extraInfo);
            $extraInfo = json_encode($extraInfo_arr);
            $goods_id = isset($extraInfo_arr['goods_id']) ? $extraInfo_arr['goods_id'] : 0;
            $level = isset($extraInfo_arr['level']) ? $extraInfo_arr['level'] : 0;
            $vip = isset($extraInfo_arr['vip']) ? $extraInfo_arr['vip'] : 0;
        }
        
        $where_str = 'where 1 ';
        
        try {
            $this->db->begin();     //开始mysqli事务

            //进行数据验签
            $params = [
                'BillNo' => $_REQUEST['BillNo'],
                'OrderId' => $_REQUEST['OrderId'],
                'UserCode' => $_REQUEST['UserCode'],
                'GameId' => $_REQUEST['GameId'],
                'Amount' => $_REQUEST['Amount'],
                'ProductId' => $_REQUEST['ProductId'],
                'RoleId' => $_REQUEST['RoleId'],
                'ServerId' => $_REQUEST['ServerId'],
                'Status' => $_REQUEST['Status'],
                'ExtraInfo' => $_REQUEST['ExtraInfo'],
                'UrlInfo' => $UrlInfo,
            ];
            if(isset($_REQUEST['X-Order-Sandbox'])){
                $params['X-Order-Sandbox'] = $_REQUEST['X-Order-Sandbox'];
            }
            $sign_data = $this->getParamSign($params, $this->paykey);
            $sign_new = $sign_data['sign'];
            if($sign_new != $sign){     //验签失败
                throw new \Exception("验签失败--" . $sign_data['sign_str'], 10002);
            }

			// if(!empty($BillNo)){
	  //           $where_str .= "and game_order_id='$BillNo' ";
	  //       }else{
	  //       	throw new \Exception("参数错误", 10002);
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
            //获取订单数据信息
            $sql = "
                select recharge.*,server.extranet_host,server.intranet_host,server.http_port
                from recharge 
                left join server on server.id=recharge.sid 
                $where_str
            ";
            $order_info = $this->db->db_sql($sql);

            $status = 0;
            if($order_status == 1){
                $status = 2;
            }
            if(!$order_info){   //订单不存在，创建订单
                $keyarr = [
                    'game_order_id','sdk_order_id','open_id','role_id','sid','goods_id','ip','level','vip','money','status','is_test','extraInfo','updated_at','pay_time','created_at'
                ];
                $valuearr = [
                    "'$BillNo'","'$orderId'","'$open_id'",$role_id,$sid,"'$goods_id'","'$ip'","'$level'","'$vip'","'$amount'",$status,$xOrderSandbox,"'$extraInfo'",$now_time,$now_time,$now_time
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
                return 'success';
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
                'status' => $order_status == 0 ? 1 : 2,
                'isTest' => $xOrderSandbox,
                'platformOrderId' =>$orderId,
            ];
            //生成发货的签名
            // $send_data['sign'] = getSign($send_data, $this->send_key);
            $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . $this->send_url;

            //用curl请求发货
            $send_result = pay_to_game($send_url, $send_data, $this->send_key, $UrlInfo);

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
            $this->db->db_tabel('recharge');
            $res = $this->db->db_update($update_data, "where id=$id ");    //更新数据

            //生成日志数据
            $keyarr_log = [
                'recharge_id', 'game_order_id','sdk_order_id','open_id','role_id','sid','goods_id','ip','money','status','is_test','extraInfo','server_status','debug','request_url','pay_time','created_at'
            ];
            $valuearr_log = [
                $id,"'$BillNo'","'$orderId'","'$open_id'",$role_id,$sid,"'$goods_id'","'$ip'","'$amount'",$status,$xOrderSandbox,"'$extraInfo'",1,"'".$debug."'","'".$request_url."'",$now_time,$now_time
            ];
            $this->db->db_tabel('recharge_log');
            $this->db->db_insert($keyarr_log, $valuearr_log);    //插入数据，获取主键id
            
            $this->db->commit();         //提交mysqli事务
            return 'success';
        } catch (\Exception $e) {
            $this->db->rollBack();         //回滚mysqli事务

            $msg = $e->getMessage();
            $update_data = [
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
        $open_id = $this->getParam('userCode', 0);
        $server_id = $this->getParam('serverId', 0);

        $result = [
            'code' => 0,
            'message' => '',
            'data' => []
        ];
        if(empty($open_id)){
            $result['message'] = 'userCode不能为空';
            echo json_encode($result);
            exit;
        }
        if(empty($server_id)){
            $result['message'] = 'serverId不能为空';
            echo json_encode($result);
            exit;
        }

        $where_str = "where user.open_id='$open_id' and us.sid=$server_id ";
        $sql = "
            select *
            from user_server as us 
            left join user on user.id=us.user_id
            $where_str
        ";
        $role_data = $this->db->db_sql($sql);

        $result = [
            'code' => 1,
            'message' => '请求成功',
            'data' => []
        ];
        foreach($role_data as $role_val){
            $result['data'][] = [
                'role_id' => $role_val['role_id'],
                'role_name' => $role_val['role_name'],
            ];
        }
        echo json_encode($result);
        exit;
    }

    // 获取服务器列表
    public function getServers() {
        $now_time = time();
        $sql = "
            select *
            from server
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

            //如果是测试服则，返回未开放
            if($server_val['is_test'] == 1){
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
        $sign_data = $this->getParamSign($_REQUEST, $this->gift_key);
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
        $sign_data = $this->getParamSign($_REQUEST, $this->gift_key);
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
            'roleid' => $roleid,
            'product_id' => $product_id
        ];
        $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . $this->gift_can_url;
        $send_url .= '?' . http_build_query($send_data);
        $result = curlRequest($send_url, $request_type = 'get');
        echo $result;
        exit;

    }
}
?>

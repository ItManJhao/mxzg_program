<?php

class SDK43wan extends \core\lss {

    private $paykey;
    private $game_pay_key;
    private $gameid;
    private $loginkey;
    private $logintype = 2;     //1.h5验证，2.apk验证
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
        global $DATA_43WAN;
        $this->paykey = $DATA_43WAN['paykey'];               //验证充值回调签名的key
        $this->gameid = $DATA_43WAN['gameid'];
        $this->loginkey = $DATA_43WAN['loginkey'];
        $this->logintype = $DATA_43WAN['logintype'];
        $this->loginurl = $DATA_43WAN['loginurl'];
        $this->send_key = $DATA_43WAN['send_key'];
        $this->send_url = $DATA_43WAN['send_url'];
        $this->send_cation = $DATA_43WAN['send_cation'];
        $this->get_role_url = $DATA_43WAN['get_role_url'];
        $this->check_ip = $DATA_43WAN['check_ip'];
        $this->gift_key = $DATA_43WAN['gift_key'];
        $this->gift_list_url = $DATA_43WAN['gift_list_url'];
        $this->gift_can_url = $DATA_43WAN['gift_can_url'];
        $this->firebase_push_url = $DATA_43WAN['firebase_push_url'];
        parent::__construct();
    }

	private function getLoginSign($str) {
		return md5($str . $this->loginkey);
	}

	public function checkLogin() {
        $return_data = [
            'code' => 1,
            'msg' => '验证成功！'
        ];

        $sign = $this->getParam('sign', 0);
        $data['uid'] = $this->getParam('open_id', 0);
        $data['timestamp'] = $this->getParam('sdk_time', 0);
        $new_sign = $this->getLoginSign($data['uid'].$data['timestamp']);
        
        if($new_sign != $sign){
            $return_data['code'] = 0;
            $return_data['msg'] = '验证失败';
        }

		return $return_data;
	}

	public function payCallback($recharge_callback_id) {
        $ip = get_ip();
        $now_time = time();
        $sid = (int)$this->getParam('server', 0);              //服务器id
        $orderId = $this->getParam('order_id', 0);      //渠道订单号，唯一
        $open_id = $this->getParam('uid', 0);              //用户id
        $amount = $this->getParam('amount', 0.00);            //实际充值金额：人民币（元）
        $pay_time = $this->getParam('timestamp', 0);             //发送请求的时间，UNIX时间戳
        $isTest = $this->getParam('sandbox', '');            //0/1, 是否为沙盒测试充值 ，0 是非沙箱环境 ，1 是沙箱
        $extraInfo = $this->getParam('extra', '');            //扩展参数，游戏方自定义，原样返回。
        $sign = $this->getParam('sign', '');                //加密签名，注：.是连接符，不参与加密，md5("$uid.$amount.$time.$sid.$orderid.$ext.$pay_key")
        $xOrderSandbox = 0;     
        $device_type = 3;

        $where_str = 'where 1 ';
        $game_order_id = 0;    //游戏订单号
        // $isTest = 0;    //是否测试
        try {
            $this->db->begin();     //开始mysqli事务

            //进行数据验签
            $sign_str = $open_id.$orderId.$sid.$amount.$extraInfo.$isTest.$pay_time.$this->paykey;
            $sign_new = md5($sign_str);
            if($sign_new != $sign){     //验签失败
                throw new \Exception("验签失败--" . $sign_str, 3);
            }

            if(!empty($orderId)){
                $where_str .= "and sdk_order_id='$orderId' ";
            }else{
                throw new \Exception("参数错误--orderId", 2);
            }

            //处理透传参数
            if(!empty($extraInfo)){
                $extraInfo_arr = decryptParam(11, $extraInfo);
                $goods_id = isset($extraInfo_arr['goods_id']) ? $extraInfo_arr['goods_id'] : 0;
                $level = isset($extraInfo_arr['level']) ? $extraInfo_arr['level'] : 0;
                $vip = isset($extraInfo_arr['vip']) ? $extraInfo_arr['vip'] : 0;
                $role_id = isset($extraInfo_arr['role_id']) ? $extraInfo_arr['role_id'] : 0;
                $game_order_id = isset($extraInfo_arr['game_order_id']) ? $extraInfo_arr['game_order_id'] : 0;
            }else{
                throw new \Exception("透传参数错误--extraInfo", 2);
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
                    'game_order_id','sdk_order_id','open_id','role_id','sid','goods_id','ip','level','vip','money','record_money','status','is_test','extraInfo','pay_time','updated_at','created_at'
                ];
                $valuearr = [
                    "'$game_order_id'","'$orderId'","'$open_id'",$role_id,$sid,"'$goods_id'","'$ip'","'$level'","'$vip'","'$amount'","'$amount'",$status,$isTest,"'$extraInfo'","'$pay_time'",$now_time,$now_time
                ];
                $this->db->db_tabel('recharge');
                $id = $this->db->db_insert($keyarr, $valuearr);    //插入数据，获取主键id
                if(!$id){
                    throw new \Exception("创建订单失败", 2);
                }

                //获取服务器信息
                $sql = "
                    select * 
                    from server 
                    where id='$sid'
                ";
                $server_info = $this->db->db_sql($sql);
                if(!$server_info){
                    throw new \Exception("参数出错--serverid", 2);
                }
                $server_info = $server_info[0];
            }elseif(in_array($order_info[0]['status'], array(-11,3)) ){    //订单已经完成或者是重复订单
                $return_data = [
                    'status' => 0,
                    'msg' => '成功'
                ];
                return json_encode($return_data);
            }elseif(!in_array($order_info[0]['status'], array(0,1,2,4)) ){     //订单未发货或者发货失败重新发货
                throw new \Exception("未知订单状态", 2);
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
                'orderId' => $game_order_id,
                'money' => $amount * 100,
                'payTime' => $pay_time,
                'status' => 1,
                'isTest' => $isTest,
                'platformOrderId' =>$orderId,
            ];

            //生成发货的签名
            $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . $this->send_url;
            // $send_url = "http://182.254.197.214:20101/recharge/chargeCallback";

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
                    $game_order_id = $cp_data['cp_order_id'];
                    $update_data['game_order_id'] = $cp_data['cp_order_id'];
                }
                if(isset($cp_data['level'])){
                    $update_data['level'] = $cp_data['level'];
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
                $id,"'$game_order_id'","'$orderId'","'$open_id'",$role_id,$sid,"'$goods_id'","'$ip'","'$amount'",$status,$xOrderSandbox,"'$extraInfo'",1,"'".$debug."'","'".$request_url."'","'$device_type'","'$pay_time'",$now_time
            ];
            $this->db->db_tabel('recharge_log');
            $this->db->db_insert($keyarr_log, $valuearr_log);    //插入数据，获取主键id
            
            $this->db->commit();         //提交mysqli事务
            if(in_array($status, [3,-11])){
                $return_data = [
                    'status' => 0,
                    'msg' => '成功'
                ];
                return json_encode($return_data);
            }else{
                $return_data = [
                    'status' => 1,
                    'msg' => '失败'
                ];
                return json_encode($return_data);
            }
        } catch (\Exception $e) {
            $this->db->rollBack();         //回滚mysqli事务

            $msg = $e->getMessage();
            $code = $e->getCode();
            $update_data = [
                'game_order_id' => $game_order_id,
                'sdk_order_id' => $orderId,
                'status' => 1,
                'debug' => $msg
            ];
            $this->db->db_tabel('recharge_callback');
            $res = $this->db->db_update($update_data, "where id=" . $recharge_callback_id);    //更新数据
            $this->db->commit();         //提交mysqli事务

            $return_data = [
                'status' => 1,
                'msg' => $msg
            ];
            return json_encode($return_data);
        }

	}


}

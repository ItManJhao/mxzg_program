<?php
namespace app\controller;

//充值相关
class Recharge43wan extends \core\lss {

    private $channel_sdk = '43wan';
    function  __construct() {
        parent::__construct();
    }

    // 回调接口，接受支付完成的订单信息，并且通知服务器发货
    public function serverRecharge() {
        $ip = get_ip();
        $now_time = time();

        //回调参数入库
        $keyarr_call = [
            'route','ip','debug','callback_str','created_at'
        ];
        $request_str = json_encode($_REQUEST, JSON_UNESCAPED_UNICODE);
        $host_http = $_SERVER['HTTP_HOST'];
        $valuearr_call = [
            "'Recharge.serverRecharge'","'$ip'","'$host_http'","'$request_str'",$now_time
        ];
        $this->db->db_tabel('recharge_callback');
        $recharge_callback_id = $this->db->db_insert($keyarr_call, $valuearr_call);

        //(2020-04-07-lby：新加的逻辑，应对港台东南亚韩国等sdk做的)
        // $platform = $this->getPlatform();  //获取平台英文小写
        $platform = $this->channel_sdk;  //获取平台英文小写
        if(!empty($platform)){
            $sdk_class = "SDK{$platform}";
            $sdk_obj = $this->loadSDK($sdk_class);
            if($sdk_obj){
                $ret = $sdk_obj->payCallback($recharge_callback_id);
                echo $ret;exit;
            }
        }
        $return_data = [
            'status' => 1,
            'msg' => '失败'
        ];
        echo json_encode($return_data);exit;
    }

}


<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 发送平台数据给总后台
 */
class SendPlatfromDataController extends PublicController{

    /**
     * 发送注册数和总充值
     */
    public function RegisterRecharge(){
        //查询注册数和总充值
        $platfrom = C("PLATFROM_ID");
        $user_count = $this->platform_db->table('user')->count('id');
        if(in_array($platfrom, [1,8])){     //国内平台查询money字段
            $money_sum = $this->platform_db->table('recharge')->where("status=3")->sum('money');
        }else{
            $money_sum = $this->platform_db->table('recharge')->where("status=3")->sum('record_money');
        }
        $send_data = [
            'platfrom' => C("PLATFROM_ID"),
            'user_count' => $user_count,
            'money_sum' => $money_sum,
        ];
        $send_url = C("CENTER_HOST") . C("CENTER_REGISTER_RECHARGE");
        $send_url .= '?' . http_build_query($send_data);
        $result = curlRequest($send_url, $request_type = 'get');
        var_dump($result);exit;
    }


}
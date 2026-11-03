<?php

namespace app\controller;

class User extends \core\lss {
    private $gameid;
    private $loginkey;
    private $firebase_push_url;
    private $reporting_level_batch_url;
    // private $platform_data = [];

    function  __construct() {
        parent::__construct();

        // global $KEYI_DATA;
        // global $TANWAN_DATA;
        // global $PLATFORM_STR;
        
        // if($PLATFORM_STR == 'keyi'){
        //     $this->platform_data = $KEYI_DATA;
        // }else{
        //     $this->platform_data = $TANWAN_DATA;
        // }

        $this->gameid = isset($this->platform_data['gameid']) ? $this->platform_data['gameid'] : 0;
        $this->loginkey = isset($this->platform_data['loginkey']) ? $this->platform_data['loginkey'] : '';
        $this->firebase_push_url = isset($this->platform_data['firebase_push_url']) ? $this->platform_data['firebase_push_url'] : '';
        $this->reporting_level_batch_url = isset($this->platform_data['reporting_level_batch_url']) ? $this->platform_data['reporting_level_batch_url'] : '';

        
    }

    //后端获取是否能登陆
    public function canLogin() {
        $sid = $this->getParam('sid');
        $uid = $this->getParam('uid');
        $ip = $this->getParam('ip');

        //判断是否在白名单
        $sql = "
            select * 
            from white_list
            where uid='" . $uid . "' or ip='$ip' and status=1
        ";
        $white_data = $this->db->db_sql($sql);

        //是否能登陆
        $res = [
            'is_login' => 1
        ];

        if($white_data){    //在白名单
            out($res);
        }

        //获取服务器信息
        $this->db->db_tabel('server');
        $server_info = $this->db->db_find('*', "where id='$sid'");
        if(!$server_info){
            out([], '区服参数错误，请稍后再试', 10001);
        }
        if($server_info['status'] == 0){    //0未开放，1爆满，2流畅，3维护，未开放和维护不让登陆
            $res['is_login'] = 0;
        }
        if($server_info['defend_end_time'] > time()){    //0未开放，1爆满，2流畅，3维护，未开放和维护不让登陆
            $res['is_login'] = 0;
        }
        out($res);
    }


    // //给玩家消息推送
    // public function firebasePush() {
    //     $platform = $this->getPlatform();  //获取平台英文小写
    //     if(!empty($platform)){
    //         $sdk_class = "SDK{$platform}";
    //         $sdk_obj = $this->loadSDK($sdk_class);
    //         if($sdk_obj){
    //             $res = $sdk_obj->firebasePush();
    //             if($res == 1){
    //                 success();
    //             }else{
    //                 error();
    //             }
    //         }
            
    //     }
    // }

    // 给玩家消息推送
    public function firebasePush() {
        $now_time = time();
        $appid = $this->gameid;
        $user_id = $this->getParam('user_id');
        $is_broadcast = $this->getParam('is_broadcast', 0);
        $title = $this->getParam('title');
        $content = $this->getParam('content');
        $time = $this->getParam('time');
        $sign = md5($appid.$time . $this->loginkey);

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
        
        return $status;
    }


    // 研发批量上报等级
    public function reportingLevelBatch() {
        $now_time = time();
        $data = $this->getParam('data', '');
        if(!empty($data)){
            $data_arr = json_decode($data, true);
        }else{
            echo '参数不能为空';
            exit;
        }
        //提取平台uid
        $uid_arr = array_column($data_arr, 'userCode');
        $user_id_str = implode(',', $uid_arr);
        $sql = "
            select id,open_id 
            from user
            where id in($user_id_str)
        ";
        $user_data = $this->db->db_sql($sql);
        $user_data_r = [];
        foreach($user_data as $user_val){
            $user_data_r[$user_val['id']] = $user_val['open_id'];
        }
        //替换原数组的平台id为open_id
        foreach($data_arr as &$data_val){
            if(isset($user_data_r[$data_val['userCode']])){
                $data_val['userCode'] = $user_data_r[$data_val['userCode']];
            }
        }
        // $data_arr = [
        //     [
        //         'userCode' => 'Ky511599880395ca9b531cd2',
        //         'game_id' => '177',
        //         'roleId' => '10000001',
        //         'serverId' => '1',
        //         'roleName' => 'aa',
        //         'level' => '12',
        //         'add_time' => '1599893301',
        //         'create_time' => '1599893301',
        //     ],
        //     [
        //         'userCode' => 'Ky511599815030b9e04b4d82',
        //         'game_id' => '177',
        //         'roleId' => '10000002',
        //         'serverId' => '1',
        //         'roleName' => 'bb',
        //         'level' => '13',
        //         'add_time' => '1599893301',
        //         'create_time' => '1599893301',
        //     ],
        // ];
        // var_dump(json_encode($data_arr));exit;
        $data_str = base64_encode(json_encode($data_arr));

        //生成签名
        $sign = md5(json_encode($data_arr, JSON_UNESCAPED_UNICODE). $this->loginkey);
        $send_data = [
            'Gid' => $this->gameid,
            'Version' => 'v1',
            'Data' => $data_str,
            'Sign' => $sign,
        ];
        $send_url = $this->reporting_level_batch_url;
        $json = curlRequest($send_url, 'post', $send_data);
        $ret = json_decode($json, true);

        $status = 0;
        if($ret ){
            if($ret['code'] == 0){
                $status = 1;
            }
        }
        //记录发送的消息
        $keyarr = [
            'send_data','status','debug','created_at'
        ];
        $send_data_str = json_encode($send_data);
        $valuearr = [
            "'$send_data_str'",$status,"'$json'",$now_time
        ];
        $this->db->db_tabel('reporting_level_log');
        $id = $this->db->db_insert($keyarr, $valuearr);    //插入数据，获取主键id

        echo $id;
        exit;

    }

}

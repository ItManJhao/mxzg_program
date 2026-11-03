<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 玩家聊天滚动详情
 */
class ChatController extends PublicController{
    /*搜索*/
    public function ChatLog(){
        $chat_types = [
            [
                'id' => 0,
                'name' => '所有频道'
            ],
            [
                'id' => 2,
                'name' => '世界'
            ],
            [
                'id' => 6,
                'name' => '跨服'
            ],
            [
                'id' => 3,
                'name' => '公会'
            ],
            [
                'id' => 7,
                'name' => '全服'
            ],
        ];

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->select();
        $this->assign(['servers' => $servers, 'chat_types' => $chat_types]);
        $this->display();
    }

    /*实时滚动聊天内容*/
    public function ajax_ChatLog(){
        //记录搜索条件
        $sid = I('sid', '0');
        $chat_type = I('chat_type', '0');
        $time = I('time', '0');

        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . C("GET_CHAT_LOG");
        $send_data = [
            'chatType' => $chat_type,
            'lastTime' => $time,
        ];
        $send_url .= '?' . http_build_query($send_data);
        $result = curlRequest($send_url, $request_type = 'get');
        $result_arr = json_decode($result, true);
        $now_time = time();
        $lasttime = $now_time;
        if($result_arr['code'] == 200){
            // $result_arr['desc'] = '[{"serverId":1001,"rid":1005000018,"name":"梦的巴萨","context":"7586","time":1582788575,"chatType":0},{"serverId":1001,"rid":1005000018,"name":"梦的巴萨","context":"457","time":1582788581,"chatType":0}]';
            $chat_data = json_decode($result_arr['desc'], true);
            $chat_data = arraySort($chat_data, 'time', SORT_ASC);
            foreach($chat_data as &$chat_val){
                $chat_val['date'] = date('Y-m-d H:i:s', $chat_val['time']);
                //判断玩家是否被封号和禁言
                $chat_val['is_forbid'] = 0;
                $chat_val['is_shutup'] = 0;
                $role_info = $this->platform_db->table('user_server')->where("role_id=" . $chat_val['rid'])->find();
                if($role_info){
                    //查询是否已经被封号
                    if($role_info['forbid_end_time'] > $now_time){
                        $chat_val['is_forbid'] = 1;
                    }
                    //查询是否已经被禁言
                    if($role_info['shutup_end_time'] > $now_time){
                        $chat_val['is_shutup'] = 1;
                    }
                }
                $lasttime = $chat_val['time'];
            }
            $data = ['status'=>1, 'lasttime'=> $lasttime, 'data' => $chat_data];
        }else{
            $data = ['status'=>0, 'lasttime'=> $lasttime, 'data' => []];
        }
        $this->ajaxReturn($data);
    }

    /*删除聊天内容*/
    public function ajax_DelChatLog(){
        //记录搜索条件
        $sid = I('sid', '0');
        $chat_type = I('chat_type', '0');
        $clan_id = I('clan_id', '0');

        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . C("DELETE_CHAT_LOG");
        $send_data = [
            'chatType' => $chat_type,
            'clanId' => !empty($clan_id) ? $clan_id : 0
        ];
        $send_url .= '?' . http_build_query($send_data);
        $result = curlRequest($send_url, $request_type = 'get');
        $result_arr = json_decode($result, true);

        if(!$result_arr){
            $error_msg .= '删除聊天记录失败，原因：连接失败；';
        }else{
            $status = $result_arr['code'];
            if($status != 200){
                $error_msg .= '删除聊天记录失败，原因：' . $result_arr['msg'] . '；';
            }
        }

        if(!empty($error_msg)){
            $status = ['status'=>0,'message'=>$error_msg];
        }else{
            $status = ['status'=>1,'message'=>'删除聊天记录成功~'];
        }
        $this->ajaxReturn($status);
    }

    /*获取当前服务器的公会*/
    // public function getClanData(){
    //     $sid = I('sid', '0');
    //     //获取当前服务器的公会
    //     $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
    //     $this->data_db = connectionDb($server_info, 'data');     //连接游戏数据库
    //     $clan_data = $this->data_db->table('clan')
    //         ->select();
    //     $this->ajaxReturn($clan_data);
    // }
//
//    /*搜索*/
//    public function index(){
//        $redis = connectRedis();
//        $redis->set('test','hello redis');
//        echo $redis->get('test');
//        exit;
//
//        //记录搜索条件
//        $sensitive_word = I('sensitive_word', '');
//
//        $where = "1 ";
//        if(!empty($sensitive_word)){
//            $where .= "and sensitive_word like '%{$sensitive_word}%' ";
//        }
//        $where .="and status=1 ";
//
//        $count = M('sensitive_word')
//            ->where($where)
//            ->count();
//        $Page  = new \Think\Page($count,20);
//        $list = M('sensitive_word')
//            ->where($where)
//            ->limit($Page->firstRow.','.$Page->listRows)
//            ->select();
//
//        $search_params = [
//            'sensitive_word' => $sensitive_word,
//        ];
//        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'search_params' => $search_params]);
//        $this->display();
//    }
//
//    public function add(){
//        $this->display();
//    }
//
//    /*添加*/
//    public function ajax_add(){
//        $sensitive_word = I('post.sensitive_word', '');
//        if(empty($sensitive_word)){
//            $status = ['status'=>0,'message'=>'请填写敏感词'];
//            $this->ajaxReturn($status);
//        }
//        $now_time = time();
//        $sensitive_word_info = M('sensitive_word')->where("sensitive_word='".$sensitive_word."' and status=1")->find();
//        if($sensitive_word_info){
//            $status = ['status'=>1,'message'=>'敏感词已经存在，请勿重复添加'];
//            $this->ajaxReturn($status);
//        }
//
//        $data = [
//            'sensitive_word' => $sensitive_word,
//            'status' => 1,
//            'admin_id' => session('admin_user_id'),
//            'admin_name' => session('belongs_to'),
//            'created_at' => $now_time,
//        ];
//        $save = M('sensitive_word')->add($data);
//
//        if ($save) {
//            $status = ['status'=>1,'message'=>'添加成功~'];
//        }else{
//            $status = ['status'=>0,'message'=>'添加失败'];
//        }
//
//        $this->ajaxReturn($status);
//    }
//
//    /*删除敏感词*/
//    public function ajax_delete(){
//        $id = I('post.id', 0);
//        if(empty($id)){
//            $status = ['status'=>0,'message'=>'参数出错，请返回重试'];
//            $this->ajaxReturn($status);
//        }
//        $data_update = [
//            'status' => 0,
//            'admin_id' => session('admin_user_id'),
//            'admin_name' => session('belongs_to'),
//        ];
//        $save = M('sensitive_word')->where("id=" . $id)->save($data_update);
//        if ($save) {
//            $status = ['status'=>1,'message'=>'删除成功~'];
//        }else{
//            $status = ['status'=>0,'message'=>'删除失败'];
//        }
//        $this->ajaxReturn($status);
//    }
//
//    /**
//     * 发送敏感词
//     */
//    public function send(){
//        //获取要发送的敏感词
//        $sensitive_word_list = M('sensitive_word')->where('status=1')->select();
//        $sensitive_word_str = '';
//        foreach($sensitive_word_list as $sensitive_word_val){
//            $sensitive_word_str .= $sensitive_word_val['sensitive_word'] . ',';
//        }
//        if(!empty($sensitive_word_str)){
//            $sensitive_word_str = substr($sensitive_word_str,0,-1);
//        }
//
//        //获取所有的服务器
//        $server_list = M('server')->select();
//        $this->assign(['channels' => $channels, 'server_list' => $server_list, 'sensitive_word_str'=>$sensitive_word_str]);
//        $this->display();
//    }
//
//    /**
//     * 发送敏感词ajax
//     */
//    public function ajax_send(){
//        $params = I('post.');
//        if($params['server_ids']){
//            $sid = implode(',', $params['server_ids']);
//        }else{
//            $sid = '';
//        }
//        //获取要发送的敏感词
//        $sensitive_word_list = M('sensitive_word')->where('status=1')->select();
//        $sensitive_word_str = '';
//        foreach($sensitive_word_list as $sensitive_word_val){
//            $sensitive_word_str .= $sensitive_word_val['sensitive_word'] . ',';
//        }
//        if(!empty($sensitive_word_str)){
//            $sensitive_word_str = substr($sensitive_word_str,0,-1);
//        }
//
//        //获取要发送的服务器信息
//        $server_list = M('server')
//            ->field('*')
//            ->where("id in (" . $sid . ")")
//            ->select();
//        //记录发送失败的服务器
//        $error_msg = '';
//        foreach($server_list as $server_val) {
//            $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'] . C("SEND_SENSITIVE_WORD");
//            $send_data = [
//                'words' => $sensitive_word_str,
//            ];
//            $send_url .= '?' . http_build_query($send_data);
//            $result = curlRequest($send_url, $request_type = 'get');
//            $result_arr = json_decode($result, true);
//            $status = $result_arr['code'];
//            if($status != 200){
//                $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '发送失败，原因：' . $result_arr['msg'] . '；';
//            }
//        }
//
//        $data = [
//            'sensitive_words' => $sensitive_word_str,
//            'sid' => $sid,
//            'debug' => $error_msg,
//            'admin_id' => session('admin_user_id'),
//            'admin_name' => session('belongs_to'),
//            'created_at' => time(),
//        ];
//        M('send_sensitive_word')->add($data);
//
//        if(!empty($error_msg)){
//            $status = ['status'=>0,'message'=>$error_msg];
//        }else{
//            $status = ['status'=>1,'message'=>'发送成功~'];
//        }
//
//        $this->ajaxReturn($status);
//    }
//
//    /**
//     * 发送敏感词记录
//     */
//    public function send_log(){
//        $list = M('send_sensitive_word')->select();
//        $this->assign(['list'=>$list]);
//        $this->display();
//    }
}
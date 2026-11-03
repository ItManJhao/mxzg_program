<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 角色管理
 */
class UserServerController extends PublicController{

    /*搜索*/
    public function index(){
        $now_time = time();
        //记录搜索条件
        $role_id = I('role_id', '');
        $role_name = I('role_name', '');
        $sid = I('sid', '');
        $c_son_id = I('c_son_id', '');
        $oprate_type = I('oprate_type', '');

        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        $channelss = M('channel')->select();
        $channels_re = [];
        foreach($channelss as $channels_val){
            $channels_re[$channels_val['id']] = $channels_val;
        }

        //获取所有的服务器
        $servers = M('server')->select();

        //组建搜索条件的值
        $search_params = [
            'role_id' => $role_id,
            'role_name' => $role_name,
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'oprate_type' => $oprate_type,
        ];

        //判断时间是否都选择
        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $this->game_data_db = connectionDb($server_info, 'data');     //连接游戏数据库

        $where = "1 ";
        if(!empty($role_id)){
            $where .= "and role.id='$role_id' ";
        }
        if(!empty($role_name)){
            $where .= "and role.nick like '%{$role_name}%' ";
        }
        if(!empty($c_son_id)){
            $where .= "and role.place=$c_son_id ";
        }
        if($oprate_type == 1){      //封号进行时
            $where .= "and role.forbid_end_time>=$now_time ";
        }elseif($oprate_type == 2){ //禁言进行时
            $where .= "and role.forbid_words_end_time>=$now_time ";
        }

        $count = $this->game_data_db->table('role')
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,20);
        $list = $this->game_data_db->table('role')
            ->field('
                role.id as role_id,
                role.nick as role_name,
                role.user_id,
                role.place,
                role.forbid_end_time,
                role.forbid_words_end_time as shutup_end_time
            ')
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        foreach($list as &$val){
            //获取渠道名称
            if(isset($channels_re[$val['place']])){
                $val['channel_name'] = $channels_re[$val['place']]['name'];
                $val['parent_name'] = $channels_re[$channels_re[$val['place']]['parent_id']]['name'];
            }else{
                $val['channel_name'] = '';
                $val['parent_name'] = '';
            }
            //获取服务器名称
            $val['server_name'] = $server_info['server_name'];
            $val['sid'] = $sid;
        }
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*
     * 角色操作页面，包括禁言和封号
     */
    public function oprate(){
        $rid = I('rid', '');
        $this->assign(['rid'=>$rid]);
        $this->display();
    }

    /*
     * 角色操作，包括禁言和封号
     */
    public function ajax_oprate(){
        $params = I('post.');
        $role_id_str = $params['role_id'];
        $end_time = strtotime($params['end_time']);
        //判断时间是否超过int类型最大值
        if($end_time > 2147483647){
            $end_time = 2147483647;
        }
        if(empty($role_id_str)){
            $status = ['status'=>0,'message'=>'请输入角色id，多个用英文逗号隔开'];
            $this->ajaxReturn($status);
        }else{
            $rolde_ids = explode(',', $role_id_str);
            $user_server_data = M('user_server')
                ->alias('us')
                ->field('us.*,server.intranet_host,server.http_port')
                ->join("left join server on server.id=us.sid")
                ->where("role_id in($role_id_str)")
                ->select();
            $send_arr = [];
            foreach($user_server_data as $role_info){
                $send_arr[$role_info['intranet_host'] . '-' . $role_info['http_port']][] = $role_info['role_id'];
            }
        }
        $log_data = [
            'rids' => "$role_id_str",
        ];
        if($params['type'] == 1){   //封号操作
            $log_data['forbid_end_time'] = $end_time;
            $send_data = [
                'type' => 1,
                'forbidEndTime' => $end_time,
            ];
            foreach($send_arr as $send_key=>$send_val){
                $server_info = explode('-',$send_key);
                $send_url = "http://" . $server_info[0] . ':' . $server_info[1] . C("ROLE_LOGIN_CHAT_FORBID");
                $send_data['rids'] = implode(',', $send_val);
                $send_url .= '?' . http_build_query($send_data);
                $result = curlRequest($send_url, $request_type = 'get');
                $result_arr = json_decode($result, true);
                $status = $result_arr['code'];
            }

            //修改角色表封禁时间
            foreach($rolde_ids as $role_id){
                M('user_server')->where("role_id=$role_id")->save(['forbid_end_time' => $end_time]);
            }
        }elseif($params['type'] == 2){   //禁言操作
            $log_data['shutup_end_time'] = $end_time;
            $send_data = [
                'type' => 2,
                'forbidEndTime' => $end_time,
            ];
            foreach($send_arr as $send_key=>$send_val){
                $server_info = explode('-',$send_key);
                $send_url = "http://" . $server_info[0] . ':' . $server_info[1] . C("ROLE_LOGIN_CHAT_FORBID");
                $send_data['rids'] = implode(',', $send_val);
                $send_url .= '?' . http_build_query($send_data);
                $result = curlRequest($send_url, $request_type = 'get');
                $result_arr = json_decode($result, true);
                $status = $result_arr['code'];
            }

            //修改角色表封禁时间
            foreach($rolde_ids as $role_id){
                M('user_server')->where("role_id=$role_id")->save(['shutup_end_time' => $end_time]);
            }
        }else{
            $status = ['status'=>0,'message'=>'请选择封号或禁言时间'];
            $this->ajaxReturn($status);
        }
        //添加日志
        $this->addTableLog('chat_forbid_log', $log_data);
        $status = ['status'=>1,'message'=>'操作成功~'];
        $this->ajaxReturn($status);
    }

    /*
     * 角色替换
     */
    public function replace(){
        $this->display();
    }

    /*
     * 角色替换
     */
    public function ajax_replace(){
        $role_id_one = I('post.role_id_one', 0);
        $role_id_two = I('post.role_id_two', 0);
        if( empty($role_id_one) || empty($role_id_two)) {
            $status = ['status'=>0,'message'=>'请输入角色id'];
            $this->ajaxReturn($status);
        }
        if( !intval($role_id_one) || !intval($role_id_two)) {
            $status = ['status'=>0,'message'=>'角色id只能是数字'];
            $this->ajaxReturn($status);
        }
        //判断角色id是否存在
        $user_server_one = M('user_server')
            ->alias('us')
            ->field('us.*,user.open_id')
            ->join("left join user on user.id=us.user_id")
            ->where('role_id = '.$role_id_one)
            ->find();
        if(!$user_server_one){
            $status = ['status'=>0,'message'=>'A角色id不存在，请重新输入'];
            $this->ajaxReturn($status);
        }
        $user_server_two = M('user_server')
            ->alias('us')
            ->field('us.*,user.open_id')
            ->join("left join user on user.id=us.user_id")
            ->where('role_id = '.$role_id_two)
            ->find();
        if(!$user_server_two){
            $status = ['status'=>0,'message'=>'B角色id不存在，请重新输入'];
            $this->ajaxReturn($status);
        }
        //判断两个角色id是否是同一个服
        if($user_server_one['sid'] != $user_server_two['sid']){
            $status = ['status'=>0,'message'=>'两个角色id不在同一个服，请认真检查'];
            $this->ajaxReturn($status);
        }
        //更换角色id
        M('user')->where('id = '.$user_server_one['user_id'])->save(['open_id' => $user_server_two['open_id']]);
        M('user')->where('id = '.$user_server_two['user_id'])->save(['open_id' => $user_server_one['open_id']]);
        //添加日志
        $log_data = [
            'one_role_id' => $role_id_one,
            'two_role_id' => $role_id_two,
        ];
        $this->addTableLog('role_replace_log', $log_data);
        $status = ['status'=>1,'message'=>'替换成功~'];
        $this->ajaxReturn($status);
    }

    /*
     * 踢人下线
     */
    public function ajax_offline(){
        $role_id = I('post.role_id', 0);
        var_dump($role_id);
    }
    /*
     * 解除封号
     */
    public function ajax_yes_play(){
        $role_id = I('post.role_id', 0);
        //判断角色id是否存在
        $user_server = M('user_server')
            ->alias('us')
            ->field('us.*,server.intranet_host,server.http_port')
            ->join("left join server on server.id=us.sid")
            ->where('us.role_id = '.$role_id)
            ->find();
        if(!$user_server){
            $status = ['status'=>0,'message'=>'角色id不存在，请返回重试'];
            $this->ajaxReturn($status);
        }

        //解除封号
        $send_url = "http://" . $user_server['intranet_host'] . ':' . $user_server['http_port'] . C("ROLE_LOGIN_CHAT_FORBID");
        $send_data = [
            'rids' => "$role_id",
            'type' => 1,
            'forbidEndTime' => strtotime("-1 day"),
        ];
        $send_url .= '?' . http_build_query($send_data);
        $result = curlRequest($send_url, $request_type = 'get');
        $result_arr = json_decode($result, true);
        $status = $result_arr['code'];
        //修改数据
        M('user_server')->where('role_id = '.$role_id)->save(['forbid_end_time' => strtotime("-1 day")]);
        //添加日志
        $this->addTableLog('chat_forbid_log', $send_data);
        $status = ['status'=>1,'message'=>'解除封号成功~'];

        $this->ajaxReturn($status);
    }
    /*
     * 解除禁言
     */
    public function ajax_yes_chat(){
        $role_id = I('post.role_id', 0);
        //判断角色id是否存在
        $user_server = M('user_server')
            ->alias('us')
            ->field('us.*,server.intranet_host,server.http_port')
            ->join("left join server on server.id=us.sid")
            ->where('us.role_id = '.$role_id)
            ->find();
        if(!$user_server){
            $status = ['status'=>0,'message'=>'角色id不存在，请返回重试'];
            $this->ajaxReturn($status);
        }

        //解除封号
        $send_url = "http://" . $user_server['intranet_host'] . ':' . $user_server['http_port'] . C("ROLE_LOGIN_CHAT_FORBID");
        $send_data = [
            'rids' => "$role_id",
            'type' => 2,
            'forbidEndTime' => strtotime("-1 day"),
        ];
        $send_url .= '?' . http_build_query($send_data);
        $result = curlRequest($send_url, $request_type = 'get');
        $result_arr = json_decode($result, true);
        $status = $result_arr['code'];
        //修改数据
        M('user_server')->where('role_id = '.$role_id)->save(['shutup_end_time' => strtotime("-1 day")]);
        //添加日志
        $this->addTableLog('chat_forbid_log', $send_data);
        $status = ['status'=>1,'message'=>'解除禁言成功~'];

        $this->ajaxReturn($status);
    }

    //封禁日志
    public function opratelog()
    {
        $role_id = I('role_id', 0);
        $count = M('chat_forbid_log')
            ->alias('cfl')
            ->field('cfl.*,bms_users.name as admin_name')
            ->join("left join bms_users on bms_users.id=cfl.admin_id")
            ->where("CONCAT(',',cfl.rids,',') LIKE '%,$role_id,%'")
            ->count();
        $Page  = new \Think\Page($count,20);
        $chat_forbid_log = M('chat_forbid_log')
            ->alias('cfl')
            ->field('cfl.*,bms_users.name as admin_name')
            ->join("left join bms_users on bms_users.id=cfl.admin_id")
            ->where("CONCAT(',',cfl.rids,',') LIKE '%,$role_id,%'")
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        $this->assign(['chat_forbid' => $chat_forbid_log, 'page'=>$Page->show(),'count'=>$count]);
        $this->display();
    }

    //角色替换日志
    public function replacelog()
    {
        $role_id = I('role_id', 0);
        $count = M('role_replace_log')
            ->alias('crl')
            ->join("left join user_server as us1 on us1.role_id=crl.one_role_id")
            ->join("left join user_server as us2 on us2.role_id=crl.two_role_id")
            ->join("left join bms_users on bms_users.id=crl.admin_id")
            ->where("one_role_id=$role_id or two_role_id=$role_id")
            ->count();
        $Page  = new \Think\Page($count,20);
        $role_replace_log = M('role_replace_log')
            ->alias('crl')
            ->field('crl.*,bms_users.name as admin_name,us1.role_name as one_role_name,us2.role_name as two_role_name')
            ->join("left join user_server as us1 on us1.role_id=crl.one_role_id")
            ->join("left join user_server as us2 on us2.role_id=crl.two_role_id")
            ->join("left join bms_users on bms_users.id=crl.admin_id")
            ->where("one_role_id=$role_id or two_role_id=$role_id")
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        $this->assign(['role_replace_log' => $role_replace_log, 'page'=>$Page->show(),'count'=>$count]);
        $this->display();
    }

    private function addTableLog($table, $data){
        $data['admin_id'] = session('admin_user_id');
        $data['created_at'] = time();
        $id = M($table)->add($data);
        if($id){
            return 1;
        }else{
            return 0;
        }
    }



}
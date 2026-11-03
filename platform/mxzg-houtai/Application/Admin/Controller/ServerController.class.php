<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 服务器的配置管理
 */
class ServerController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $id = I('id', '');
        $server_name = I('server_name', '');
        $status = I('status', '-1');

        $where = "1 ";
        if(!empty($id)){
            $where .= "and id=$id ";
        }
        if(!empty($server_name)){
            $where .= "and server_name like '%{$server_name}%' ";
        }
        $now_time = time();
        //维护状态根据维护时间来判断，权重第一
        if($status == 3){
            $where .= "and defend_end_time>$now_time ";
        }

        if(in_array($status, [0,1,2])){
            $where .= "and status=$status ";
        }

        $count = M('server')->where($where)->count();
        $Page  = new \Think\Page($count, 40);
        $server_list = M('server')->where($where)->order('id desc')->limit($Page->firstRow.','.$Page->listRows)->select();
        foreach($server_list as &$server_val){
            if($server_val['defend_end_time'] > time()){
                $server_val['status_name'] = '维护';
            }elseif($server_val['status'] == 0){
                $server_val['status_name'] = '未开放';
            }elseif($server_val['status'] == 1){
                $server_val['status_name'] = '爆满';
            }elseif($server_val['status'] == 2){
                $server_val['status_name'] = '流畅';
            }else{
                $server_val['status_name'] = '';
            }
        }
        $search_params = [
            'id' => $id,
            'server_name' => $server_name,
            'status' => $status,
        ];
        $this->assign(['server_list'=>$server_list,'page'=>$Page->show(),'count'=>$count,'data'=>$data, 'search_params' => $search_params]);
        $this->display();
    }

    public function add(){
        $this->display();
    }

    public function edit(){
        $id = I('id', 0);
        $server_info = M('server')->where('id = '.$id.'')->find();
        $this->assign(['server_info'=>$server_info]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $params = I('post.');

//        if (!$params['ids']) {
//            $status = ['status'=>0,'message'=>'请填写区服ID'];
//        }
        if (!$params['server_name']) {
            $status = ['status'=>0,'message'=>'请填写服务器名称'];
        }
        else if (!$params['extranet_host']) {
            $status = ['status'=>0,'message'=>'请填写服务器外网地址'];
        }
        else if (!$params['intranet_host']) {
            $status = ['status'=>0,'message'=>'请填写内网地址'];
        }
        else if (!$params['game_port']) {
            $status = ['status'=>0,'message'=>'请填写游戏端口'];
        }
        else if (!$params['http_port']) {
            $status = ['status'=>0,'message'=>'请填写HTTP端口'];
        }
        else if (!$params['open_time']) {
            $status = ['status'=>0,'message'=>'请填写开服时间'];
        }
        else if (!$params['db_host']) {
            $status = ['status'=>0,'message'=>'请填写数据库地址'];
        }
        else if (!$params['db_port']) {
            $status = ['status'=>0,'message'=>'请填写数据库端口'];
        }
        else if (!$params['db_user']) {
            $status = ['status'=>0,'message'=>'请填写数据库用户名'];
        }
        else if (!$params['db_password']) {
            $status = ['status'=>0,'message'=>'请填写数据库密码'];
        }
        else if (!$params['db_game_database']) {
            $status = ['status'=>0,'message'=>'请填写游戏数据库名'];
        }
        else if (!$params['db_log_database']) {
            $status = ['status'=>0,'message'=>'请填写游戏日志数据库名'];
        }
        else{
            $is_server_name = M('server')->where('server_name = "'.$params['server_name'].'"')->getField('id');
            if ($is_server_name) {
                $status = ['status'=>0,'message'=>'该服务器名称已存在'];
            }else{
                $now_time = time();
                $data = [
                    'server_name' => $params['server_name'],
                    'extranet_host' => $params['extranet_host'],
                    'intranet_host' => $params['intranet_host'],
                    'game_port' => $params['game_port'],
                    'http_port' => $params['http_port'],
                    'db_host' => $params['db_host'],
                    'db_port' => $params['db_port'],
                    'db_user' => $params['db_user'],
                    'db_password' => $params['db_password'],
                    'db_game_database' => $params['db_game_database'],
                    'db_log_database' => $params['db_log_database'],
                    'note' => $params['note'],
                    'is_new' => $params['is_new'],
                    'type' => $params['type'],
                    'role_nums_limit' => !empty($params['role_nums_limit']) ? $params['role_nums_limit'] : 0,
                    'status' => $params['status'],
                    'open_time' => strtotime($params['open_time']),
                    'defend_end_time' => strtotime($params['defend_end_time']),
                    'msg' => $params['msg'],
                    'group_id' => $params['group_id'],
                    'updated_at' => $now_time,
                    'created_at' => $now_time,
                ];
                $add = M('server')->add($data);
                if ($add) {
                    $status = ['status'=>1,'message'=>'添加成功~'];
                }else{
                    $status = ['status'=>0,'message'=>'添加失败'];
                }
            }
        }
 
        $this->ajaxReturn($status);
    }

    /*更新*/
    public function ajax_updata(){
        $params = I('post.');

        if (!$params['id']) {
            $status = ['status'=>0,'message'=>'参数出错，请返回重试'];
        }
        else if (!$params['server_name']) {
            $status = ['status'=>0,'message'=>'请填写服务器名称'];
        }
        else if (!$params['extranet_host']) {
            $status = ['status'=>0,'message'=>'请填写服务器外网地址'];
        }
        else if (!$params['intranet_host']) {
            $status = ['status'=>0,'message'=>'请填写内网地址'];
        }
        else if (!$params['game_port']) {
            $status = ['status'=>0,'message'=>'请填写游戏端口'];
        }
        else if (!$params['http_port']) {
            $status = ['status'=>0,'message'=>'请填写HTTP端口'];
        }
        else if (!$params['open_time']) {
            $status = ['status'=>0,'message'=>'请填写开服时间'];
        }
        else if (!$params['db_host']) {
            $status = ['status'=>0,'message'=>'请填写数据库地址'];
        }
        else if (!$params['db_port']) {
            $status = ['status'=>0,'message'=>'请填写数据库端口'];
        }
        else if (!$params['db_user']) {
            $status = ['status'=>0,'message'=>'请填写数据库用户名'];
        }
        else if (!$params['db_password']) {
            $status = ['status'=>0,'message'=>'请填写数据库密码'];
        }
        else if (!$params['db_game_database']) {
            $status = ['status'=>0,'message'=>'请填写游戏数据库名'];
        }
        else if (!$params['db_log_database']) {
            $status = ['status'=>0,'message'=>'请填写游戏日志数据库名'];
        }
        else{
            //判断服务器id是否正确
            $is_id = M('server')->where('id='.$params['id'])->getField('id');
            if(!$is_id){
                $status = ['status'=>0,'message'=>'数据不对，请返回重试'];
                $this->ajaxReturn($status);
            }

            //判断是否修改服务器名字是否重复
            $is_server_name = M('server')->where('id != '.$params['id'].' and server_name = "'.$params['server_name'].'"')->getField('id');
            if ($is_server_name) {
                $status = ['status'=>0,'message'=>'该服务器名称已存在'];
            }else{
                $now_time = time();
                $data = [
                    'server_name' => $params['server_name'],
                    'extranet_host' => $params['extranet_host'],
                    'intranet_host' => $params['intranet_host'],
                    'game_port' => $params['game_port'],
                    'http_port' => $params['http_port'],
                    'db_host' => $params['db_host'],
                    'db_port' => $params['db_port'],
                    'db_user' => $params['db_user'],
                    'db_password' => $params['db_password'],
                    'db_game_database' => $params['db_game_database'],
                    'db_log_database' => $params['db_log_database'],
                    'note' => $params['note'],
                    'is_new' => $params['is_new'],
                    'type' => $params['type'],
                    'role_nums_limit' => !empty($params['role_nums_limit']) ? $params['role_nums_limit'] : 0,
                    'status' => $params['status'],
                    'open_time' => strtotime($params['open_time']),
                    'defend_end_time' => strtotime($params['defend_end_time']),
                    'msg' => $params['msg'],
                    'group_id' => $params['group_id'],
                    'updated_at' => $now_time,
                ];
                $db = M('server');
                $save = $db->where('id = '.$params['id'])->save($data);
//                echo $db->getLastSql();exit;
                if ($save) {
                    $status = ['status'=>1,'message'=>'编辑成功~'];
                }else{
                    $status = ['status'=>0,'message'=>'编辑失败'];
                }
 
            }

        }
        $this->ajaxReturn($status);
    }

    /*维护（踢全服下线）*/
    public function defend(){
        //获取所有的服务器
        $server_list = M('server')->select();
        $server_list = array_chunk($server_list, 50);
        $this->assign(['server_list' => $server_list]);
        $this->display();
    }

    /*维护（踢全服下线）*/
    public function ajax_defend(){
        $params = I('post.');
        if(empty($params['server_ids'])){
            $status = ['status'=>0,'message'=>'请选择服务器'];
            $this->ajaxReturn($status);
        }

        $server_ids_str = implode(',', $params['server_ids']);
        $server_list = M('server')->field('id,status,server_name,intranet_host,http_port')->where("id in($server_ids_str)")->select();
        $defend_end_time = strtotime($params['defend_end_time']);
        $data_update = [
            'defend_end_time' => $defend_end_time,
            'msg' => $params['msg'],
        ];
        $error_msg = '';
        foreach($server_list as $server_val){
            if($server_val['status'] == 0){
                $error_msg .= '服务器【' . $server_val['id'] . '：' . $server_val['server_name'] . '】踢全服下线失败，原因：服务器未开放不能维护；';
            }else{
                $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'] . C("ROLE_OFFLINEALL_URL");
                $result = curlRequest($send_url, $request_type = 'post', ['defend_end_time' => $defend_end_time]);
                $result_arr = json_decode($result, true);
                $status = $result_arr['code'];
                if($status != 200){
                    $error_msg .= '服务器【' . $server_val['id'] . '：' . $server_val['server_name'] . '】踢全服下线失败，原因：' . $result_arr['msg'] . '；';
                }
                //修改数据
                $data_update['id'] = $server_val['id'];
                $res = M('server')->save($data_update);
            }
            
        }
        if (empty($error_msg)) {
            $status = ['status'=>1,'message'=>'踢全服下线成功~'];
        }else{
            $status = ['status'=>0,'message'=>$error_msg];
        }
        $this->ajaxReturn($status);
    }

    /*发送开服时间*/
    public function ajax_send_optime(){
        $id = I('id', 0);
        $server_info = M('server')->where('id = '.$id)->find();
        if(!$server_info){
            $status = ['status'=>0,'message'=>'参数错误，请稍后再试'];
            $this->ajaxReturn($status);
        }

        $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . C("SEND_OPTIME");
        $send_url .= '?time=' . $server_info['open_time'];
        $result = curlRequest($send_url, $request_type = 'get');
        $result_arr = json_decode($result, true);
        $status = $result_arr['code'];

        if ($status == 200) {
            $status = ['status'=>1,'message'=>'发送成功~'];
        }else{
            $status = ['status'=>0,'message'=>'发送失败'];
        }
        $this->ajaxReturn($status);
    }


}
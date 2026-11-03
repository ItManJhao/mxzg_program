<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 消息推送管理
 */
class FirebasePushController extends PublicController{

    //消息推送列表
    public function index(){
        //记录搜索条件
        $is_broadcast = I('is_broadcast', 'all');
        $status = I('status', 'all');
        $type = I('type', 'all');
        $title = I('title', '');
        $user_ids = I('user_ids', '');

        $where = "1 ";
        if($is_broadcast != 'all'){
            $where .= "and fpl.is_broadcast='$is_broadcast' ";
        }
        if($status != 'all'){
            $where .= "and fpl.status='$status' ";
        }
        if($type != 'all'){
            $where .= "and fpl.type='$type' ";
        }
        if(!empty($title)){
            $where .= "and fpl.title like '%{$title}%' ";
        }
        if(!empty($user_ids)){
            $where .= "and fpl.user_ids like '%{$user_ids}%' ";
        }

        $count = $this->platform_db->table('firebase_push_log')
            ->alias('fpl')
            ->join("left join bms_users on bms_users.id=fpl.admin_id")
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,50);
        $list = $this->platform_db->table('firebase_push_log')
            ->alias('fpl')
            ->field('fpl.*,bms_users.name as admin_name')
            ->join("left join bms_users on bms_users.id=fpl.admin_id")
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->order('fpl.id desc')
            ->select();

        $show = $Page->show();
        $search_params = [
            'is_broadcast' => $is_broadcast,
            'status' => $status,
            'type' => $type,
            'title' => $title,
            'user_ids' => $user_ids,
        ];
        $this->assign(['list'=>$list,'count'=>$count,'page'=>$show,'search_params' => $search_params]);
        $this->display();
    }

    //添加消息推送
    public function add(){
        $this->display();
    }

    /*添加消息推送ajax*/
    public function ajax_add(){
        $platform_config = C("PLATFORM_CONFIG");    //平台配置
        

        $title = I('title', '');
        $content = I('content', '');
        $system = I('system', '0');
        $is_broadcast = I('is_broadcast', '');
        $user_ids = I('user_ids', '');
        $now_time = time();
        
        if($is_broadcast == 0 && empty($user_ids)){
            $status = ['status'=>0,'message'=>'用户消息要填写平台uid~'];
            $this->ajaxReturn($status);
        }
        if($system == 0){   //安卓
            $appid = $platform_config['GAME_ID_AND'];
            $login_key = $platform_config['LOGIN_KEY_AND'];
        }else{              //iod
            $appid = $platform_config['GAME_ID_IOS'];
            $login_key = $platform_config['LOGIN_KEY_IOS'];
        }
        $firebase_push_url = $platform_config['FIREBASE_PUSH_URL'];
        $sign = md5($appid.$now_time.$login_key);

        $params = [
            'title' => $title,
            'content' => $content,
            'appid' => $appid,
            'time' => $now_time,
            'sign' => $sign,
            'is_broadcast' => $is_broadcast,
        ];

        $open_id_arr = [];
        $user_id_str = '';
        if($is_broadcast == 0){     //1为广播，即针对全服玩家推送  0为不广播，针对单用户推送
            //获取渠道uid（open_id）
            $user_id_str = $user_ids;
            $user_data = $this->platform_db->table('user')
                ->field('open_id')
                ->where("id in($user_id_str)")
                ->select();
            
            if(!empty($user_data)){
                $open_id_arr = array_column($user_data, 'open_id');
            }
        }
        $params['uid'] = json_encode($open_id_arr);
        $json = curlRequest($firebase_push_url, 'post', $params);
        $ret = json_decode($json, true);
        $status = 0;
        if($ret ){
            if($ret['code'] == 1){
                $status = 1;
            }
        }

        $data = [
            'appid' => $appid,
            'title' => $title,
            'content' => $content,
            'is_broadcast' => $is_broadcast,
            'user_ids' => $user_id_str,
            'type' => 2,
            'status' => $status,
            'debug' => $json,
            'admin_id' => session('admin_user_id'),
            'time' => $now_time,
            'created_at' => $now_time,
        ];
        $res = $this->platform_db->table('firebase_push_log')->add($data);

        if ($status == 1) {
            $status = ['status'=>1,'message'=>'消息推送成功~'];
        }else{
            $status = ['status'=>0,'message'=>'消息推送失败~'];
        }
        $this->ajaxReturn($status);
    }


}
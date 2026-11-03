<?php
namespace Admin\Controller;

use Think\Controller;

/**
 *  公会数据管理
 */
class ClanController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $clan_head_rid = I('clan_head_rid', '');
        $clan_id = I('clan_id', '');
        $clan_name = I('clan_name', '');
        $sid = I('sid', '0');

        //获取所有的服务器
        $servers = M('server')->where($this->server_where)->select();
        
        //组建搜索条件的值
        $search_params = [
            'clan_head_rid' => $clan_head_rid,
            'clan_id' => $clan_id,
            'clan_name' => $clan_name,
            'sid' => $sid,
        ];

        //判断时间是否都选择
        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'count'=>0, 'page'=>'', 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $game_data_db = connectionDb($server_info, 'data');     //连接游戏数据库

        $where = "1 ";
        if(!empty($uid)){
            $where .= "and clan.clan_head_rid='$clan_head_rid' ";
        }
        if(!empty($role_id)){
            $where .= "and clan.id='$clan_id' ";
        }
        if(!empty($role_name)){
            $where .= "and clan.clan_name like '%{$clan_name}%' ";
        }

        $count = $game_data_db->table('clan')
            ->join("left JOIN clan_member as cm on cm.clan_id=clan.id")
            ->join("left JOIN clan_boss as cb on cb.clan_id=clan.id")
            ->where($where)
            ->count("distinct clan.id");
        $Page  = new \Think\Page($count, 30);
        $list = $game_data_db->table('clan')
            ->field("
                clan.*,
                cb.boss_idx,
                count(cm.clan_id) as counts,
                group_concat(cm.rid) as rids
            ")
            ->join("left JOIN clan_member as cm on cm.clan_id=clan.id")
            ->join("left JOIN clan_boss as cb on cb.clan_id=clan.id")
            ->where($where)
            ->group("clan.id")
            ->order("clan_fighting desc")
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
            
        foreach($list as &$val){
            //获取公会总充值金额
            $val['money'] = $game_data_db->table('recharge')
                ->where("give_state=1 and rid in(" . $val['rids'] . ") ")
                ->sum('pay_money*0.01');
            $val['sid'] = $sid;  
        }
        $this->assign(['list'=>$list,'page'=>$Page->show(),'firstRow'=>$Page->firstRow,'count'=>$count, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    //公会成员
    public function ClanMember(){

        $clan_id = I('clan_id', '');
        $sid = I('sid', '0');
        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();

        if(empty($clan_id) || empty($server_info)){
            $this->display();
            exit;
        }
        //查询角色信息，需要连接游戏数据库
        $game_data_db = connectionDb($server_info);
        $clan_members = $game_data_db->table('clan_member')
            ->field("clan_member.*,role.user_id,role.nick as role_name,role.level,role.fighting,role.last_login_time,role_charge.total_recharge*0.01 as total_recharge")
            ->join("left JOIN role on role.id=clan_member.rid")
            ->join("left JOIN role_charge on role_charge.rid=clan_member.rid")
            ->where("clan_member.clan_id = $clan_id")
            ->select();

        $this->assign(['clan_members'=>$clan_members]);
        $this->display();
    }

    //修改公告
    public function UpdateClanDesc(){
        $clan_id = I('clan_id', '');
        $sid = I('sid', '0');
        $clan_desc = I('clan_desc', '');
        $clan_info = [
            'clan_id' => $clan_id,
            'sid' => $sid,
            'clan_desc' => $clan_desc,
        ];
        $this->assign(['clan_info'=>$clan_info]);
        $this->display();
    }
    //修改公告ajax
    public function ajax_UpdateClanDesc(){
        $clan_id = I('clan_id', '');
        $sid = I('sid', '0');
        $clan_desc = I('clan_desc', '');
        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();

        if(empty($clan_id) || empty($server_info)){
            $status = ['status'=>0,'message'=>'请选择服务器'];
            $this->ajaxReturn($status);
        }

        $send_data = [
            'clanId' => $clan_id,
            'desc' => $clan_desc,
        ];
        $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . C("UPDATE_CLAN_DESC");
        $send_url .= '?' . http_build_query($send_data);
        // var_dump($send_url);exit;
        $result = curlRequest($send_url, $request_type = 'get');
        $result_arr = json_decode($result, true);

        if(!$result_arr){
            $error_msg .= '更新公告失败，原因：连接失败；';
        }else{
            $status = $result_arr['code'];
            if($status != 200){
                $error_msg .= '更新公告失败，原因：' . $result_arr['msg'] . '；';
            }
        }

        if(!empty($error_msg)){
            $status = ['status'=>0,'message'=>$error_msg];
        }else{
            $status = ['status'=>1,'message'=>'更新公告成功~'];
        }
        $this->ajaxReturn($status);
    }

}
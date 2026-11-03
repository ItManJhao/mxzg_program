<?php
namespace Admin\Controller;

use Think\Controller;

/*
 * 游戏数据日志
 */
class GameErrorLogController extends PublicController{

    /*玩家报错日志*/
    public function RoleErrorLog(){
        //记录搜索条件
        $now_date = date('Y-m-d H:i:s');
        $sid = I('sid', '');
        $rid = I('rid', '');
        $className = I('className', '');
        $start_time = I('start_time', date('Y-m-d H:i:s', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);

        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        //获取所有的服务器
        $servers = M('server')->field("id,server_name")->select();
        $servers_re = [];
        foreach($servers as $servers_val){
            $servers_re[$servers_val['id']] = $servers_val;
        }
        
        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'rid' => $rid,
            'className' => $className,
            'start_time' => $start_time,
            'end_time' => $end_time,
        ];

        $where = "1 ";
        if(!empty($sid)){
            $where .= "and sid in($sid) ";
        }
        if(!empty($role_id)){
            $where .= "and rid='$rid' ";
        }
        if(!empty($className)){
            $where .= "and className like '%{$className}%' ";
        }
        if(!empty($start_time)){
            $where .= "and time>=" . strtotime($start_time) . " ";
        }
        if(!empty($end_time)){
            $where .= "and time<=" . strtotime($end_time) . " ";
        }

        $count = $this->data_analysis_db->table('role_error_log')
            ->where($where)
            ->count("id");
        $Page  = new \Think\Page($count, 50);
        $list = $this->data_analysis_db->table('role_error_log')
            ->where($where)
            ->order("id desc")
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        foreach($list as &$val){
            //获取渠道名称
            if(isset($servers_re[$val['sid']])){
                $val['server_name'] = $servers_re[$val['sid']]['server_name'];
            }else{
                $val['server_name'] = '';
            }
        }

        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*玩家报错日志统计*/
    public function RoleErrorLogStat(){
        //记录搜索条件
        $now_date = date('Y-m-d H:i:s');
        $sid = I('sid', '');
        $rid = I('rid', '');
        $className = I('className', '');
        $start_time = I('start_time', date('Y-m-d H:i:s', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);

        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        //获取所有的服务器
        $servers = M('server')->field("id,server_name")->select();
        
        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'rid' => $rid,
            'className' => $className,
            'start_time' => $start_time,
            'end_time' => $end_time,
        ];

        $where = "1 ";
        if(!empty($sid)){
            $where .= "and sid in($sid) ";
        }
        if(!empty($role_id)){
            $where .= "and rid='$rid' ";
        }
        if(!empty($className)){
            $where .= "and className like '%{$className}%' ";
        }
        if(!empty($start_time)){
            $where .= "and time>=" . strtotime($start_time) . " ";
        }
        if(!empty($end_time)){
            $where .= "and time<=" . strtotime($end_time) . " ";
        }

        $count_data = $this->data_analysis_db->table('role_error_log')
            ->where($where)
            ->limit(1)
            ->count("DISTINCT className,lineNumber");
        $count = 0;
        foreach($count_data as $count_key=>$count_val){
            $count = $count_key;
        }
        $Page  = new \Think\Page($count, 50);
        $list = $this->data_analysis_db->table('role_error_log')
            ->field("className,lineNumber,count(id) num,stackTrace")
            ->where($where)
            ->group("className,lineNumber")
            ->order("num desc")
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*后台发送邮件记录*/
    public function MailboxLog(){
        //记录搜索条件
        $now_date = date('Y-m-d');
        $to_mail = I('to_mail', '');
        $status = I('status', '-1');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        
        //组建搜索条件的值
        $search_params = [
            'to_mail' => $to_mail,
            'status' => $status,
            'start_time' => $start_time,
            'end_time' => $end_time,
        ];

        $where = "1 ";
        if(!empty($to_mail)){
            $where .= "and to_mail like '%{$to_mail}%' ";
        }
        if($status != -1){
            $where .= "and status=$status ";
        }
        if(!empty($start_time)){
            $where .= "and created_at>=" . strtotime($start_time) . " ";
        }
        if(!empty($end_time)){
            $where .= "and created_at<=" . strtotime($end_time . ' 23:59:59') . " ";
        }

        $count = $this->platform_db->table('mailbox_log')
            ->where($where)
            ->count("id");
        $Page  = new \Think\Page($count, 50);
        $list = $this->platform_db->table('mailbox_log')
            ->where($where)
            ->order("id desc")
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'search_params' => $search_params]);
        $this->display();
    }

}
<?php
namespace Admin\Controller;
use Think\Controller;
use Think\Db;

/**
 * 数据总览--新服开服数据
 */
class OverviewOpenController extends PublicController{

    /*搜索*/
    public function index(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();
        //获取所有的服务器
        $servers = $this->platform_db->table('server')->select();
        $servers_re = [];
        foreach($servers as $servers_val){
            $servers_re[$servers_val['id']] = $servers_val;
        }

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '100001');
        $open_date = I('open_date', date('Y-m-d'));    //开服时间

        //组装搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'open_date' => $open_date,
        ];
        //判断时间是否都选择
        if(empty($open_date) || empty($sid) || empty($c_son_id)){
            $this->assign(['list'=>[], 'error_msg'=> '渠道、服务器、开服时间都必须选择！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $where = "1 ";
        $where_login_all = "1 ";
        $where .= "and sid=$sid ";
        if(!empty($c_son_id)){
            $where .= "and c_son_id=$c_son_id ";
            $where_login_all .= "and c_son_id=$c_son_id ";
        }

        $where .= "and date ='" . $open_date . "' ";

        $count = $this->data_analysis_db->table('overview_open')
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,50);
        $list = $this->data_analysis_db->table('overview_open')
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        foreach($list as &$list_val){
            $list_val['open_time_show'] = $list_val['date'] . ' ' . ($list_val['time']-1) . ':00~' . $list_val['time'] . ':00';
        }
        //计算汇总总登录数
        $start_time = $this->data_analysis_db->table('overview_open')
            ->where($where)
            ->min('time');
        $end_time = $this->data_analysis_db->table('overview_open')
            ->where($where)
            ->max('time');
        if(!empty($start_time) && !empty($end_time)){
            $where_login_all .= "and created_at >=" . strtotime($open_date . ' ' . ($start_time-1) . ':00:00') . ' ';
            $where_login_all .= "and created_at <" . strtotime($open_date . ' ' . $end_time . ':00:00') . ' ';
            $login_num_total = $this->data_analysis_db->table('overview_open')
                ->where($where_login_all)
                ->sum('login_num');
        }else{
            $login_num_total = 0;
        }

        //计算汇总数据
        $data_total = $this->data_analysis_db->table('overview_open')
            ->field('
                sum(register_num) as register_num_total,
                sum(role_num) as role_num_total,
                sum(pay_num) as pay_num_total,
                sum(pay_money) as pay_money_total,
                max(highest_online_num) as highest_online_num_max
            ')
            ->where($where)
            ->find();

        $list[] = [
            'open_time_show' => '汇总',
            'register_num' => $data_total['register_num_total'],
            'role_num' => $data_total['role_num_total'],
            'add_role_rate' => getDivision($data_total['role_num_total'], $data_total['register_num_total']),
            'login_num' => $login_num_total,
            'pay_num' => $data_total['pay_num_total'],
            'pay_money' => $data_total['pay_money_total'],
            'arppu' => getDivisionSpecial($data_total['pay_money_total'], $data_total['pay_num_total']),
            'arpu' => getDivisionSpecial($data_total['pay_money_total'], $login_num_total),
            'rate' => getDivision($data_total['pay_num_total'], $login_num_total),
            'highest_online_num' => $data_total['highest_online_num_max'],
        ];
        $show = $Page->show();
        
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }


}
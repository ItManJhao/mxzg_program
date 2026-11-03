<?php
namespace Admin\Controller;
use Think\Controller;
use Think\Db;

/**
 * 数据总览--每日总览
 */
class OverviewDayController extends PublicController{

    /*搜索*/
    public function index(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();
//        $channels_re = [];
//        foreach($channels as $channels_val){
//            $channels_re[$channels_val['id']] = $channels_val;
//        }

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();
//        $servers_re = [];
//        foreach($servers as $servers_val){
//            $servers_re[$servers_val['id']] = $servers_val;
//        }

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $now_date = date('Y-m-d');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        $where = "1 ";
        $where_regtal = $where_regxu = "1 ";
        if(!empty($sid)){
            $where .= "and sid in($sid) ";
        }
        if(!empty($c_son_id)){
            $where .= "and c_son_id in($c_son_id) ";
            $where_regxu .= "and c_son_id in($c_son_id) ";
            $where_regtal .= "and c_son_id in($c_son_id) ";
        }
        if(!empty($start_time)){
            $where .= "and unix_timestamp(date) >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
            $where_regtal .= "and created_at >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
        }
        if(!empty($end_time)){
            $where .= "and unix_timestamp(date)<=" . strtotime(date('Y-m-d', strtotime($end_time)) . ' 23:59:59') . ' ';
            $where_regtal .= "and created_at <=" . strtotime(date('Y-m-d', strtotime($end_time)) . ' 23:59:59') . ' ';
        }

        $counts = $this->data_analysis_db->table('overview_day')
            ->where($where)
            ->group('date')
            ->select();
        $count = count($counts);
        $Page  = new \Think\Page($count,50);
        $list = $this->data_analysis_db->table('overview_day')
            ->field('
                date,
                sum(role_num) as role_num_total,
                sum(device_num) as device_num_total,
                sum(login_num) as login_num_total,
                sum(pay_num) as pay_num_total,
                sum(pay_money) as pay_money_total,
                sum(add_pay_num) as add_pay_num_total,
                sum(add_pay_money) as add_pay_money_total,
                sum(old_pay_money) as old_pay_money_total,
                sum(one_day_num) as one_day_num_total,
                sum(three_day_num) as three_day_num_total,
                sum(four_day_num) as four_day_num_total,
                sum(five_day_num) as five_day_num_total,
                sum(six_day_num) as six_day_num_total,
                sum(seven_day_num) as seven_day_num_total,
                sum(fourteen_day_num) as fourteen_day_num_total,
                sum(thirty_day_num) as thirty_day_num_total
            ')
            ->where($where)
            ->group('date')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        foreach($list as &$list_val){
            //获取注册数
            $where_reg = $where_regxu;
            $where_reg .= "and created_at >=" . strtotime($list_val['date'] . ' 00:00:00') . ' ';
            $where_reg .= "and created_at <=" . strtotime($list_val['date'] . ' 23:59:59') . ' ';
            $register_num = $this->platform_db->table('user')
                ->where($where_reg)
                ->count();
            $list_val = [
                'date' => $list_val['date'],
                'register_num' => $register_num,
                'role_num' => $list_val['role_num_total'],
                'device_num' => $list_val['device_num_total'],
                'add_role_rate' => getDivision($list_val['role_num_total'], $register_num),
                'login_num' => $list_val['login_num_total'],
                'pay_num' => $list_val['pay_num_total'],
                'pay_money' => $list_val['pay_money_total'],
                'arppu' => getDivisionSpecial($list_val['pay_money_total'], $list_val['pay_num_total']),
                'arpu' => getDivisionSpecial($list_val['pay_money_total'], $list_val['login_num_total']),
                'rate' => getDivision($list_val['pay_num_total'], $list_val['login_num_total']),
                'add_pay_num' => $list_val['add_pay_num_total'],
                'add_pay_money' => $list_val['add_pay_money_total'],
                'add_arppu' => getDivisionSpecial($list_val['add_pay_money_total'], $list_val['add_pay_num_total']),
                'add_arpu' => getDivisionSpecial($list_val['add_pay_money_total'], $list_val['role_num_total']),
                'add_rate' => getDivision($list_val['add_pay_num_total'], $list_val['role_num_total']),
                'old_pay_money' => $list_val['old_pay_money_total'],
                'one_day_retain' => getDivision($list_val['one_day_num_total'], $list_val['role_num_total']),
                'three_day_retain' => getDivision($list_val['three_day_num_total'], $list_val['role_num_total']),
                'four_day_retain' => getDivision($list_val['four_day_num_total'], $list_val['role_num_total']),
                'five_day_retain' => getDivision($list_val['five_day_num_total'], $list_val['role_num_total']),
                'six_day_retain' => getDivision($list_val['six_day_num_total'], $list_val['role_num_total']),
                'seven_day_retain' => getDivision($list_val['seven_day_num_total'], $list_val['role_num_total']),
                'fourteen_day_retain' => getDivision($list_val['fourteen_day_num_total'], $list_val['role_num_total']),
                'thirty_day_retain' => getDivision($list_val['thirty_day_num_total'], $list_val['role_num_total']),
            ];
        }

        //计算汇总数据
        $data_total = $this->data_analysis_db->table('overview_day')
            ->field('
                sum(role_num) as role_num_total,
                sum(device_num) as device_num_total,
                sum(login_num) as login_num_total,
                sum(pay_num) as pay_num_total,
                sum(pay_money) as pay_money_total,
                sum(add_pay_num) as add_pay_num_total,
                sum(add_pay_money) as add_pay_money_total,
                sum(old_pay_money) as old_pay_money_total,
                sum(one_day_num) as one_day_num_total,
                sum(three_day_num) as three_day_num_total,
                sum(four_day_num) as four_day_num_total,
                sum(five_day_num) as five_day_num_total,
                sum(six_day_num) as six_day_num_total,
                sum(seven_day_num) as seven_day_num_total,
                sum(fourteen_day_num) as fourteen_day_num_total,
                sum(thirty_day_num) as thirty_day_num_total
            ')
            ->where($where)
            ->find();
        //获取注册数
        $register_num = $this->platform_db->table('user')
            ->where($where_regtal)
            ->count();
        $list[] = [
            'date' => '汇总',
            'register_num' => $register_num,
            'role_num' => $data_total['role_num_total'],
            'device_num' => $data_total['device_num_total'],
            'add_role_rate' => getDivision($data_total['role_num_total'], $register_num),
            'login_num' => $data_total['login_num_total'],
            'pay_num' => $data_total['pay_num_total'],
            'pay_money' => $data_total['pay_money_total'],
            'arppu' => getDivisionSpecial($data_total['pay_money_total'], $data_total['pay_num_total']),
            'arpu' => getDivisionSpecial($data_total['pay_money_total'], $data_total['login_num_total']),
            'rate' => getDivision($data_total['pay_num_total'], $data_total['login_num_total']),
            'add_pay_num' => $data_total['add_pay_num_total'],
            'add_pay_money' => $data_total['add_pay_money_total'],
            'add_arppu' => getDivisionSpecial($data_total['add_pay_money_total'], $data_total['add_pay_num_total']),
            'add_arpu' => getDivisionSpecial($data_total['add_pay_money_total'], $data_total['role_num_total']),
            'add_rate' => getDivision($data_total['add_pay_num_total'], $data_total['role_num_total']),
            'old_pay_money' => $data_total['old_pay_money_total'],
            'one_day_retain' => getDivision($data_total['one_day_num_total'], $data_total['role_num_total']),
            'three_day_retain' => getDivision($data_total['three_day_num_total'], $data_total['role_num_total']),
            'four_day_retain' => getDivision($data_total['four_day_num_total'], $data_total['role_num_total']),
            'five_day_retain' => getDivision($data_total['five_day_num_total'], $data_total['role_num_total']),
            'six_day_retain' => getDivision($data_total['six_day_num_total'], $data_total['role_num_total']),
            'seven_day_retain' => getDivision($data_total['seven_day_num_total'], $data_total['role_num_total']),
            'fourteen_day_retain' => getDivision($data_total['fourteen_day_num_total'], $data_total['role_num_total']),
            'thirty_day_retain' => getDivision($data_total['thirty_day_num_total'], $data_total['role_num_total']),
        ];

        $show = $Page->show();

        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'start_time' => $start_time,
            'end_time' => $end_time,
        ];
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*每日总览假数据页面*/
    public function index_copy(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();
//        $channels_re = [];
//        foreach($channels as $channels_val){
//            $channels_re[$channels_val['id']] = $channels_val;
//        }

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();
//        $servers_re = [];
//        foreach($servers as $servers_val){
//            $servers_re[$servers_val['id']] = $servers_val;
//        }

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $now_date = date('Y-m-d');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        $where = "1 ";
        $where_regtal = $where_regxu = "1 ";
        if(!empty($sid)){
            $where .= "and sid=$sid ";
        }
        if(!empty($c_son_id)){
            $where .= "and c_son_id=$c_son_id ";
            $where_regxu .= "and c_son_id=$c_son_id ";
            $where_regtal .= "and c_son_id=$c_son_id ";
        }
        if(!empty($start_time)){
            $where .= "and unix_timestamp(date) >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
            $where_regtal .= "and created_at >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
        }
        if(!empty($end_time)){
            $where .= "and unix_timestamp(date)<=" . strtotime(date('Y-m-d', strtotime($end_time)) . ' 23:59:59') . ' ';
            $where_regtal .= "and created_at <=" . strtotime(date('Y-m-d', strtotime($end_time)) . ' 23:59:59') . ' ';
        }

        $counts = $this->data_analysis_db->table('overview_day_copy')
            ->where($where)
            ->group('date')
            ->select();
        $count = count($counts);
        $Page  = new \Think\Page($count,50);
        $list = $this->data_analysis_db->table('overview_day_copy')
            ->field('
                date,
                sum(role_num) as role_num_total,
                sum(device_num) as device_num_total,
                sum(login_num) as login_num_total,
                sum(pay_num) as pay_num_total,
                sum(pay_money) as pay_money_total,
                sum(add_pay_num) as add_pay_num_total,
                sum(add_pay_money) as add_pay_money_total,
                sum(old_pay_money) as old_pay_money_total,
                sum(one_day_num) as one_day_num_total,
                sum(three_day_num) as three_day_num_total,
                sum(seven_day_num) as seven_day_num_total,
                sum(fourteen_day_num) as fourteen_day_num_total,
                sum(thirty_day_num) as thirty_day_num_total
            ')
            ->where($where)
            ->group('date')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        foreach($list as &$list_val){
            //获取注册数
            $where_reg = $where_regxu;
            $where_reg .= "and created_at >=" . strtotime($list_val['date'] . ' 00:00:00') . ' ';
            $where_reg .= "and created_at <=" . strtotime($list_val['date'] . ' 23:59:59') . ' ';
            $register_num = $this->platform_db->table('user')
                ->where($where_reg)
                ->count();
            $list_val = [
                'date' => $list_val['date'],
                'register_num' => $register_num,
                'role_num' => $list_val['role_num_total'],
                'device_num' => $list_val['device_num_total'],
                'add_role_rate' => getDivision($list_val['role_num_total'], $register_num),
                'login_num' => $list_val['login_num_total'],
                'pay_num' => $list_val['pay_num_total'],
                'pay_money' => $list_val['pay_money_total'],
                'arppu' => getDivisionSpecial($list_val['pay_money_total'], $list_val['pay_num_total']),
                'arpu' => getDivisionSpecial($list_val['pay_money_total'], $list_val['login_num_total']),
                'rate' => getDivision($list_val['pay_num_total'], $list_val['login_num_total']),
                'add_pay_num' => $list_val['add_pay_num_total'],
                'add_pay_money' => $list_val['add_pay_money_total'],
                'add_arppu' => getDivisionSpecial($list_val['add_pay_money_total'], $list_val['add_pay_num_total']),
                'add_arpu' => getDivisionSpecial($list_val['add_pay_money_total'], $list_val['role_num_total']),
                'add_rate' => getDivision($list_val['add_pay_num_total'], $list_val['role_num_total']),
                'old_pay_money' => $list_val['old_pay_money_total'],
                'one_day_retain' => getDivision($list_val['one_day_num_total'], $list_val['role_num_total']) . '%',
                'three_day_retain' => getDivision($list_val['three_day_num_total'], $list_val['role_num_total']) . '%',
                'seven_day_retain' => getDivision($list_val['seven_day_num_total'], $list_val['role_num_total']) . '%',
                'fourteen_day_retain' => getDivision($list_val['fourteen_day_num_total'], $list_val['role_num_total']) . '%',
                'thirty_day_retain' => getDivision($list_val['thirty_day_num_total'], $list_val['role_num_total']) . '%',
            ];
        }

        //计算汇总数据
        $data_total = $this->data_analysis_db->table('overview_day_copy')
            ->field('
                sum(role_num) as role_num_total,
                sum(device_num) as device_num_total,
                sum(login_num) as login_num_total,
                sum(pay_num) as pay_num_total,
                sum(pay_money) as pay_money_total,
                sum(add_pay_num) as add_pay_num_total,
                sum(add_pay_money) as add_pay_money_total,
                sum(old_pay_money) as old_pay_money_total
            ')
            ->where($where)
            ->find();
        //获取注册数
        $register_num = $this->platform_db->table('user')
            ->where($where_regtal)
            ->count();
        $list[] = [
            'date' => '汇总',
            'register_num' => $register_num,
            'role_num' => $data_total['role_num_total'],
            'device_num' => $data_total['device_num_total'],
            'add_role_rate' => getDivision($data_total['role_num_total'], $register_num),
            'login_num' => $data_total['login_num_total'],
            'pay_num' => $data_total['pay_num_total'],
            'pay_money' => $data_total['pay_money_total'],
            'arppu' => getDivisionSpecial($data_total['pay_money_total'], $data_total['pay_num_total']),
            'arpu' => getDivisionSpecial($data_total['pay_money_total'], $data_total['login_num_total']),
            'rate' => getDivision($data_total['pay_num_total'], $data_total['login_num_total']),
            'add_pay_num' => $data_total['add_pay_num_total'],
            'add_pay_money' => $data_total['add_pay_money_total'],
            'add_arppu' => getDivisionSpecial($data_total['add_pay_money_total'], $data_total['add_pay_num_total']),
            'add_arpu' => getDivisionSpecial($data_total['add_pay_money_total'], $data_total['role_num_total']),
            'add_rate' => getDivision($data_total['add_pay_num_total'], $data_total['role_num_total']),
            'old_pay_money' => $data_total['old_pay_money_total'],
            'one_day_retain' => '',
            'three_day_retain' => '',
            'seven_day_retain' => '',
            'fourteen_day_retain' => '',
            'thirty_day_retain' => '',
        ];

        $show = $Page->show();
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'start_time' => $start_time,
            'end_time' => $end_time,
        ];
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

}
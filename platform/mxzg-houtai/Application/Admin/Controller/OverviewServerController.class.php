<?php
namespace Admin\Controller;
use Think\Controller;
use Think\Db;

/**
 * 数据总览--分区总览
 */
class OverviewServerController extends PublicController{

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
        $c_son_id = I('c_son_id', '0');
        $now_date = date('Y-m-d');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);
        $open_date = I('open_date', '');    //开服时间
        $open_days_start = I('open_days_start', '');    //开服天数
        $open_days_end = I('open_days_end', '');    //开服天数

        //组装搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'start_time' => $start_time,
            'end_time' => $end_time,
            'open_date' => $open_date,
            'open_days_start' => $open_days_start,
            'open_days_end' => $open_days_end,
        ];

        //判断时间是否都选择
        if(empty($start_time) || empty($end_time)){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间都必须选择！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        if(date('Y-m', strtotime($start_time)) != date('Y-m', strtotime($end_time)) &&
            date("Y-m", strtotime("+1 months", strtotime($start_time))) != date('Y-m', strtotime($end_time))){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间最多是连续两个月！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

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

        $where .= "and unix_timestamp(date) >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
        $start_time_str = strtotime(date('Y-m-d', strtotime($start_time)) . ' 00:00:00');
        $where_regtal .= "and created_at >=" . $start_time_str . ' ';
        $where .= "and unix_timestamp(date)<=" . strtotime(date('Y-m-d', strtotime($end_time))) . ' ';
        $end_time_str = strtotime(date('Y-m-d', strtotime($end_time)) . ' 23:59:59');
        $where_regtal .= "and created_at <=" . $end_time_str . ' ';

        //根据开服时间和开服天数查询服务器id
        $where_open = "1 ";
        if(!empty($open_date)){
            $where_open .= "and open_time>=" . strtotime(date('Y-m-d', strtotime($open_date)) . ' 00:00:00') . ' ';
            $where_open .= "and open_time<=" . strtotime(date('Y-m-d', strtotime($open_date)) . ' 23:59:59') . ' ';
        }
        if(!empty($open_days_start) && !empty($open_days_end)){
            $where_open .= "and open_time>=" . strtotime(date('Y-m-d', strtotime("-" . ($open_days_end-1) . " day")) . ' 00:00:00') . ' ';
            $where_open .= "and open_time<=" . strtotime(date('Y-m-d', strtotime("-" . ($open_days_start-1) . " day")) . ' 23:59:59') . ' ';
        }elseif(!empty($open_days_start) && empty($open_days_end)){
            $where_open .= "and open_time>=" . strtotime(date('Y-m-d', strtotime("-" . ($open_days_start-1) . " day")) . ' 00:00:00') . ' ';
            $where_open .= "and open_time<=" . strtotime(date('Y-m-d', strtotime("-" . ($open_days_start-1) . " day")) . ' 23:59:59') . ' ';
        }elseif(!empty($open_days_end) && empty($open_days_start)){
            $where_open .= "and open_time>=" . strtotime(date('Y-m-d', strtotime("-" . ($open_days_end-1) . " day")) . ' 00:00:00') . ' ';
            $where_open .= "and open_time<=" . strtotime(date('Y-m-d', strtotime("-" . ($open_days_end-1) . " day")) . ' 23:59:59') . ' ';
        }
        if($where_open != '1 '){
            $sids = $this->platform_db->table('server')
                ->where($where_open)
                ->getField('id',true);
            if($sids){
                $sid_str = implode(',', $sids);
                $where .= "and sid in ($sid_str) ";
            }
        }

        $counts = $this->data_analysis_db->table('overview_day')
            ->field('sid')
            ->where($where)
            ->group('sid')
            ->select();
        $count = count($counts);
        $Page  = new \Think\Page($count, 20);
        $list = $this->data_analysis_db->table('overview_day')
            ->field('
                date,
                sid,
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
                sum(thirty_day_num) as thirty_day_num_total,
                max(highest_online_num) as highest_online_num_max,
                AVG(average_online_num) as average_online_num_avg
            ')
            ->where($where)
            ->group('sid')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        foreach($list as &$list_val){

            if(isset($servers_re[$list_val['sid']])){
                $this->game_log_db = connectionDb($servers_re[$list_val['sid']], 'log');     //连接游戏日志库
                //查询登录数
                $table_start = 'role_login_log' . getLogTable('month', $start_time);
                $table_end = 'role_login_log' . getLogTable('month', $end_time);
                //判断表是否存在
                $is_find = 1;
                $is_table_start = checkTable($this->game_log_db, $table_start);
                $is_table_end = checkTable($this->game_log_db, $table_end);
                if( $is_table_start && $is_table_end){
                    $table_sql = "(select * from $table_start where login_time>=$start_time_str and login_time<=$end_time_str  UNION ALL select * from $table_end where login_time>=$start_time_str and login_time<=$end_time_str )";
                }elseif($is_table_start){
                    $table_sql = "(select * from $table_start where login_time>=$start_time_str and login_time<=$end_time_str)";
                }elseif($is_table_end){
                    $table_sql = "(select * from $table_end where login_time>=$start_time_str and login_time<=$end_time_str)";
                }else{
                    $is_find = 0;
                }
                if($is_find == 1){
                    $login_num_total = $this->game_log_db->table($table_sql.' tmp')
                        ->count("distinct rid");
                }else{
                    $login_num_total = 0;
                }
            }
            $list_val = [
                'server' => '',
                'sid' => $list_val['sid'],
//                    'register_num' => $register_num,
                'role_num' => $list_val['role_num_total'],
                'device_num' => $list_val['device_num_total'],
//                    'add_role_rate' => getDivision($list_val['role_num_total'], $register_num),
                'login_num' => $login_num_total,
                'pay_num' => $list_val['pay_num_total'],
                'pay_money' => $list_val['pay_money_total'],
                'arppu' => getDivisionSpecial($list_val['pay_money_total'], $list_val['pay_num_total']),
                'arpu' => getDivisionSpecial($list_val['pay_money_total'], $login_num_total),
                'rate' => getDivision($list_val['pay_num_total'], $login_num_total),
                'add_pay_num' => $list_val['add_pay_num_total'],
                'add_pay_money' => $list_val['add_pay_money_total'],
                'add_arppu' => getDivisionSpecial($list_val['add_pay_money_total'], $list_val['add_pay_num_total']),
                'add_arpu' => getDivisionSpecial($list_val['add_pay_money_total'], $list_val['role_num_total']),
                'add_rate' => getDivision($list_val['add_pay_num_total'], $list_val['role_num_total']),
                'old_pay_money' => $list_val['old_pay_money_total'],
                'one_day_retain' => getDivision($list_val['one_day_num_total'], $list_val['role_num_total']),
                'three_day_retain' => getDivision($list_val['three_day_num_total'], $list_val['role_num_total']),
                'seven_day_retain' => getDivision($list_val['seven_day_num_total'], $list_val['role_num_total']),
                'fourteen_day_retain' => getDivision($list_val['fourteen_day_num_total'], $list_val['role_num_total']),
                'thirty_day_retain' => getDivision($list_val['thirty_day_num_total'], $list_val['role_num_total']),
                'highest_online_num' => $list_val['highest_online_num_max'],
                'average_online_num' => round($list_val['average_online_num_avg']),
            ];

            //获取区服信息
            if(isset($servers_re[$list_val['sid']])){
                $list_val['open_date'] = date('Y-m-d H:i:s', $servers_re[$list_val['sid']]['open_time']);   //开服日期
                $list_val['open_days'] = (strtotime(date('Y-m-d')) - strtotime(date('Y-m-d', $servers_re[$list_val['sid']]['open_time'])))/86400 + 1;   //开服天数
                $list_val['server'] = $servers_re[$list_val['sid']]['id'] . '-' . $servers_re[$list_val['sid']]['server_name'];
            }

        }

        //计算汇总数据
        $data_total = $this->data_analysis_db->table('overview_day')
            ->field("
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
                sum(thirty_day_num) as thirty_day_num_total,
                max(highest_online_num) as highest_online_num_max,
                AVG(average_online_num) as average_online_num_avg
            ")
            ->where($where)
            ->find();
        $list[] = [
            'server' => '汇总',
            'open_date' => '',
            'open_days' => '',
//            'register_num' => $register_num,
            'role_num' => $data_total['role_num_total'],
            'device_num' => $data_total['device_num_total'],
//            'add_role_rate' => getDivision($data_total['role_num_total'], $register_num),
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
            'seven_day_retain' => getDivision($data_total['seven_day_num_total'], $data_total['role_num_total']),
            'fourteen_day_retain' => getDivision($data_total['fourteen_day_num_total'], $data_total['role_num_total']),
            'thirty_day_retain' => getDivision($data_total['thirty_day_num_total'], $data_total['role_num_total']),
            'highest_online_num' => $data_total['highest_online_num_max'],
            'average_online_num' => round($data_total['average_online_num_avg']),
        ];
        $show = $Page->show();

        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }


}
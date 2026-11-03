<?php
namespace Admin\Controller;
use Think\Controller;
use Think\Db;

/**
 * 数据总览--渠道占比
 */
class OverviewChannelController extends PublicController{

    /*搜索*/
    public function index(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where('parent_id>0')->select();
        $channelss = $this->platform_db->table('channel')->select();
        $channels_re = [];
        foreach($channelss as $channels_val){
            $channels_re[$channels_val['id']] = $channels_val;
        }
        unset($channelss);

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $now_date = date('Y-m-d');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        //组件搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'start_time' => $start_time,
            'end_time' => $end_time,
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
        if(!empty($sid)){
            $where .= "and sid in($sid) ";
        }
        if(!empty($c_son_id)){
            $where .= "and c_son_id in($c_son_id) ";
        }
        $where .= "and unix_timestamp(date) >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
        $start_time_str = strtotime(date('Y-m-d', strtotime($start_time)) . ' 00:00:00');
        $where .= "and unix_timestamp(date)<=" . strtotime(date('Y-m-d', strtotime($end_time))) . ' ';
        $end_time_str = strtotime(date('Y-m-d', strtotime($end_time)) . ' 23:59:59');

        $counts = $this->data_analysis_db->table('overview_day')
            ->group('c_son_id')
            ->where($where)
            ->select();
        $count = count($counts);
        $Page  = new \Think\Page($count,50);
        $subQuery = $this->data_analysis_db->table('overview_day')->field('
                date,
                c_id,
                c_son_id,
                register_num,
                sum(role_num) as role_num_t,
                sum(login_num) as login_num_t,
                sum(pay_num) as pay_num_t,
                sum(pay_money) as pay_money_t
            ')
            ->where($where)
            ->group('c_son_id,date')
            ->buildSql();
        $list = $this->data_analysis_db->table($subQuery.' a')
            ->field('
                c_id,
                c_son_id,
                sum(register_num) as register_num_total,
                sum(role_num_t) as role_num_total,
                sum(login_num_t) as login_num_total,
                sum(pay_num_t) as pay_num_total,
                sum(pay_money_t) as pay_money_total
            ')
            ->group('c_son_id')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        //计算汇总数据
        $data_total = $this->data_analysis_db->table($subQuery.' b')
            ->field('
                sum(register_num) as register_num_total,
                sum(role_num_t) as role_num_total,
                sum(login_num_t) as login_num_total,
                sum(pay_num_t) as pay_num_total,
                sum(pay_money_t) as pay_money_total
            ')
            ->find();
        $login_num_total_all = 0;
        foreach($list as &$list_val){
            //查询登录数
            $login_num_total = 0;
            foreach($servers as $server_val){
                if($server_val['status'] > 0 && $server_val['id'] > 1000){
                    $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库
                    //查询登录数
                    $table_start = 'role_login_log' . getLogTable('month', $start_time);
                    $table_end = 'role_login_log' . getLogTable('month', $end_time);
                    $table_sql = "(select * from $table_start UNION ALL select * from $table_end)";
                    $subQuery = $this->game_log_db->table($table_sql . ' tmp')
                        ->field('rid')
                        ->where("login_time>=$start_time_str and login_time<=$end_time_str ")
                        ->group('rid')
                        ->buildSql();
                    $login_num = $this->game_log_db->table($subQuery.' a')
                        ->count();
                    $login_num_total_all += $login_num;
                    $login_num_total += $login_num;
                }
            }

            $list_val = [
                'c_id' => $list_val['c_id'],
                'c_name' => '',
                'c_son_id' => $list_val['c_son_id'],
                'c_son_name' => '',
                'register_num' => $list_val['register_num_total'],
                'register_num_rate' => getDivision($list_val['register_num_total'], $data_total['register_num_total']),
                'role_num' => $list_val['role_num_total'],
                'role_num_rate' => getDivision($list_val['role_num_total'], $data_total['role_num_total']),
                'login_num' => $login_num_total,
                'login_num_rate' => 0,
                'pay_num' => $list_val['pay_num_total'],
                'pay_num_rate' => getDivision($list_val['pay_num_total'], $data_total['pay_num_total']),
                'pay_money' => $list_val['pay_money_total'],
                'pay_money_rate' => getDivision($list_val['pay_money_total'], $data_total['pay_money_total']),
            ];

            //获取渠道信息
            if(isset($channels_re[$list_val['c_id']])){
                $list_val['c_name'] = $channels_re[$list_val['c_id']]['name'];
            }
            if(isset($channels_re[$list_val['c_son_id']])){
                $list_val['c_son_name'] = $channels_re[$list_val['c_son_id']]['name'];
            }
        }
        foreach($list as &$list_val){
            $list_val['login_num_rate'] = getDivision($list_val['login_num'], $login_num_total_all);
        }

        $list[] = [
            'c_name' => '汇总',
            'c_son_name' => '汇总',
            'register_num' => $data_total['register_num_total'],
            'register_num_rate' => '100',
            'role_num' => $data_total['role_num_total'],
            'role_num_rate' => '100',
            'login_num' => $login_num_total_all,
            'login_num_rate' => '100',
            'pay_num' => $data_total['pay_num_total'],
            'pay_num_rate' => '100',
            'pay_money' => $data_total['pay_money_total'],
            'pay_money_rate' => '100',
        ];
        $show = $Page->show();

        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }


}
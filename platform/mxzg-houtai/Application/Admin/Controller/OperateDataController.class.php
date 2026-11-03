<?php
namespace Admin\Controller;

use Think\Controller;

/*
 * 运营数据 
 */
class OperateDataController extends PublicController{

    protected $minute_num;
    protected $minute_str;
    protected $hour_num;
    protected $hour_str;
    protected $day_str;

    public function __construct() {
        parent::__construct();
        $this->minute_num = 12;         //按分钟统计，一个小时统计的次数
        $this->minute_str = 5*60;       //按分钟统计，每次间隔的时间
        $this->hour_num = 24;           //按小时统计，一天统计的次数
        $this->hour_str = 60*60;        //按小时统计，每次间隔的时间
        $this->day_str = 86400;         //按天统计，每次间隔的时间
    }

    /*实时新增*/
    public function RealAdd(){
        
        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $type = I('type', '1');
        $minute_time = I('minute_time', date('Y-m-d H'));
        $hour_time = I('hour_time', date('Y-m-d'));
        $minute_time = str_replace("+"," ", $minute_time);
        $hour_time = str_replace("+"," ", $hour_time);

        //组件搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'type' => $type,
            'minute_time' => $minute_time,
            'hour_time' => $hour_time,
        ];
        $data_x = [];
        $data_series = [];

        //判断时间是否都选择
        if(empty($minute_time) && empty($hour_time)){
            $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $where = "1 ";
        if(!empty($c_son_id)){
            $where .= "and c_son_id in($c_son_id) ";
        }
        
        //处理不同统计类型的开始时间和结束时间以及数据外壳
        if($type == 1){     //按分钟统计，每$this->minute_str秒一次
            $interval_time = $this->minute_str;
            $start_time = strtotime($minute_time . ':00:00');
            $end_time = $start_time + $interval_time;
            $for_num = $this->minute_num;
        }else{              //按小时统计
            $interval_time = $this->hour_str;
            $start_time = strtotime($hour_time . '00:00:00');
            $end_time = $start_time + $interval_time;
            $for_num = $this->hour_num;
        }

        $data_series_role_create = [];
        $data_series_user = [];
        for($x=0; $x<$for_num; $x++){
            $data_x[] = date('Y-m-d H:i', $start_time + $x * $interval_time);     //x坐标

            //y坐标创角数查询
            $role_create_num_all = 0;
            foreach($servers as $server_val){
                if((empty($sid)) || (!empty($sid) && in_array($server_val['id'], explode(',', $sid)))){
                    $where_r = '1 ';
                    $where_r .= "and create_time>=" . ($start_time + $x * $interval_time) . ' ';
                    $where_r .= "and create_time<" . ($end_time + $x * $interval_time) . ' ';

                    $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库
                    $table = 'role_create_log';
                    $role_create_num = $this->game_log_db->table($table)
                        ->where($where_r)
                        ->count();
                    $role_create_num_all += $role_create_num;
                }
            }
            $data_series_role_create[] = $role_create_num_all;     //y坐标创角数

            //y坐标注册数查询
            $where_register = $where;
            $where_register .= "and created_at >=" . ($start_time + $x * $interval_time) . ' ';
            $where_register .= "and created_at <" . ($end_time + $x * $interval_time) . ' ';
            $register_num = $this->platform_db->table('user')
                ->where($where_register)
                ->count();
            $data_series_user[] = $register_num;     //y坐标注册数
        }
        $data_series = [
            [
                'name' => '实时创角',
                'type' => 'line',
                'data' => $data_series_role_create
            ],
            [
                'name' => '实时注册',
                'type' => 'line',
                'data' => $data_series_user
            ]
        ];

        $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*实时在线*/
    public function RealOnline(){
        
        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $type = I('type', '1');
        $minute_time = I('minute_time', date('Y-m-d H'));
        $hour_time = I('hour_time', date('Y-m-d'));
        $minute_time = str_replace("+"," ", $minute_time);
        $hour_time = str_replace("+"," ", $hour_time);

        //组件搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'type' => $type,
            'minute_time' => $minute_time,
            'hour_time' => $hour_time,
        ];
        $data_x = [];
        $data_series = [];

        //判断时间是否都选择
        if(empty($minute_time) && empty($hour_time)){
            $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $where = "1 ";
        if(!empty($c_son_id)){
            $where .= "and place in($c_son_id) ";
        }
        
        //处理不同统计类型的开始时间和结束时间以及数据外壳
        if($type == 1){     //按分钟统计，每$this->minute_str秒一次
            $interval_time = $this->minute_str;
            $start_time = strtotime($minute_time . ':00:00');
            $end_time = $start_time + $interval_time;
            $for_num = $this->minute_num;
            
        }else{              //按小时统计
            $interval_time = $this->hour_str;
            $start_time = strtotime($hour_time . '00:00:00');
            $end_time = $start_time + $interval_time;
            $for_num = $this->hour_num;
        }
        $current_date = date('Y-m-d', $start_time);

        $data_series_online = [];
        for($x=0; $x<$for_num; $x++){
            $data_x[] = date('Y-m-d H:i', $start_time + $x * $interval_time);     //x坐标

            //y坐标创角数查询
            $online_num_all = 0;
            foreach($servers as $server_val){
                if((empty($sid)) || (!empty($sid) && in_array($server_val['id'], explode(',', $sid)))){
                    $where_r = $where;
                    $where_r .= "and record_time>=" . ($start_time + $x * $interval_time) . ' ';
                    $where_r .= "and record_time<" . ($end_time + $x * $interval_time) . ' ';

                    $this->game_log_db = connectionDb($server_val, 'log');          //连接游戏日志库
                    // $table = 'role_create_log';
                    $table = 'online_num_log' . getLogTable('month', $current_date);
                    $is_exist = checkTable($this->game_log_db, $table);
                    if($is_exist){
                        $online_num = $this->game_log_db->table($table)
                            ->where($where_r)
                            ->max('online_num');
                        $online_num_all += $online_num;
                    }
                    
                }
            }
            $data_series_online[] = $online_num_all;     //y坐标在线数

        }
        $data_series = [
            [
                'name' => '实时在线',
                'type' => 'line',
                'data' => $data_series_online
            ]
        ];

        $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }
    /*单服实时在线*/
    public function OnlyRealOnline(){
        
        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $today_date = I('today_date', date('Y-m-d'));

        //组件搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'today_date' => $today_date,
        ];
        $data_x = [];
        $data_series = [];
        $data_legend = [];

        //判断
        if(empty($sid) || empty($today_date)){
            $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'data_legend'=> json_encode($data_legend), 'error_msg'=> '请选择服务器和日期！！！', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        $sid_arr = explode(',', $sid);
        if(count($sid_arr) > 10){
            $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'data_legend'=> json_encode($data_legend), 'error_msg'=> '服务器不能超过10个！！！', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $where = "1 ";
        if(!empty($c_son_id)){
            $where .= "and place in($c_son_id) ";
        }
        
        $where .= "and record_time>=" . strtotime($today_date) . ' ';
        $where .= "and record_time<=" . strtotime($today_date . ' 23:59:59') . ' ';

        $server_data = $this->platform_db->table('server')->where("id in($sid)")->select();
        foreach($server_data as &$server_val){
            $data_x = [];
            $data_series_online = [];
            // $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
            $game_log_db = connectionDb($server_val, 'log');         //连接游戏日志库
            
    
            $table = 'online_num_log' . getLogTable('month', $today_date);
            $online_num_data = $game_log_db->table($table)
                ->field("online_num,record_time")
                ->where($where)
                ->select();
            foreach($online_num_data as $online_num_val){
                $data_x[] = date('H:i:s', $online_num_val['record_time']);
                $data_series_online[] = $online_num_val['online_num'];
            }
            $data_series[] = [
                'name' => $server_val['id'] . '-' . $server_val['server_name'],
                'type' => 'line',
                'data' => $data_series_online
            ];
            $data_legend[] = $server_val['id'] . '-' . $server_val['server_name'];
        }

        $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'data_legend'=> json_encode($data_legend), 'error_msg' => '', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*每日在线峰值*/
    public function OnlineApex(){
        
        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();

        //记录搜索条件
        $now_date = date("Y-m-d");
        $sid = I('sid', '0');
        $type = I('type', '1');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);
        $hour_time = I('hour_time', date('Y-m-d'));
        $hour_time = str_replace("+"," ", $hour_time);

        //组件搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'type' => $type,
            'start_time' => $start_time,
            'end_time' => $end_time,
            'hour_time' => $hour_time,
        ];
        $data_x = [];
        $data_series = [];

        //判断时间是否都选择
        if(
            ($type == 1 && empty($hour_time)) 
            || ($type == 2 && empty($start_time) && empty($end_time))  
            || ($type == 2 && date('Y-m', strtotime($start_time)) != date('Y-m', strtotime($end_time)))
        ){
            $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $where = "1 ";
        if(!empty($c_son_id)){
            $where .= "and place in($c_son_id) ";
        }
        
        //处理不同统计类型的开始时间和结束时间以及数据外壳
        if($type == 1){     //按小时统计
            $interval_time = $this->hour_str;
            $start_time = strtotime($hour_time . '00:00:00');
            $end_time = $start_time + $interval_time;
            $for_num = $this->hour_num;
        }else{              //按日期统计
            $interval_time = $this->day_str;
            $for_num = (strtotime($end_time)-strtotime($start_time))/86400;
            $start_time = strtotime($start_time);
            $end_time = $start_time + $interval_time;
        }

        $current_date = date('Y-m-d', $start_time);

        $data_series_online = [];
        $list = []; //表格数据
        for($x=0; $x<$for_num; $x++){
            if($type == 1){
                $data_x[] = date('Y-m-d H:i', $start_time + $x * $interval_time);     //x坐标
                $list[$x]['date'] = date('Y-m-d H:i', $start_time + $x * $interval_time);
            }else{
                $data_x[] = date('Y-m-d', $start_time + $x * $interval_time);     //x坐标
                $list[$x]['date'] = date('Y-m-d', $start_time + $x * $interval_time);
            }
            
            //y坐标创角数查询
            $online_num_max = 0;
            $online_num_total = 0;
            $online_num_avg_count = 0;

            //表格在线时长
            $online_time_max = 0;
            $online_time_total = 0;
            $online_time_avg_count = 0;
            foreach($servers as $server_val){
                if((empty($sid)) || (!empty($sid) && in_array($server_val['id'], explode(',', $sid)))){
                    $where_r = "1 ";
                    $where_r .= "and record_time>=" . ($start_time + $x * $interval_time) . ' ';
                    $where_r .= "and record_time<" . ($end_time + $x * $interval_time) . ' ';

                    $this->game_log_db = connectionDb($server_val, 'log');          //连接游戏日志库
                    $table = 'online_num_log' . getLogTable('month', $current_date);
                    $online_info = $this->game_log_db->table($table)
                        ->field("max(online_num) as online_num_max,avg(online_num) as online_num_avg")
                        ->where($where_r)
                        ->find();
                    //峰值
                    if($online_info['online_num_max'] > $online_num_max){
                        $online_num_max = $online_info['online_num_max'];
                    }
                    //平均值
                    $online_num_total += $online_info['online_num_avg'];
                    $online_num_avg_count += 1;

                    //表格在线时长
                    $where_r = $where;
                    $where_r .= "and (logout_time-online_time)>=" . ($start_time + $x * $interval_time) . ' ';
                    $where_r .= "and (logout_time-online_time)<" . ($end_time + $x * $interval_time) . ' ';

                    $table = 'role_logout_log' . getLogTable('month', $current_date);
                    $online_time_info = $this->game_log_db->table($table)
                        ->field("max(online_time) as online_time_max,avg(online_time) as online_time_avg")
                        ->where($where_r)
                        ->find();

                    //最高在线时长
                    if($online_time_info['online_time_max'] > $online_time_max){
                        $online_time_max = $online_time_info['online_time_max'];
                    }
                    //平均在线时长
                    $online_time_total += $online_time_info['online_time_avg'];
                    $online_time_avg_count += 1;
                }
            }
            $data_series_online_max[] = $online_num_max;     //y坐标在线峰值
            $data_series_online_vag[] = round($online_num_total/$online_num_avg_count, 0);     //y坐标在线平均
            $list[$x]['max_num'] = $online_num_max;
            $list[$x]['vag_num'] = round($online_num_total/$online_num_avg_count, 0);
            $list[$x]['max_time'] = $online_time_max;
            $list[$x]['vag_time'] = round($online_time_total/$online_time_avg_count, 0);

        }

        $data_series = [
            [
                'name' => '在线峰值',
                'type' => 'line',
                'data' => $data_series_online_max
            ],
            [
                'name' => '平均在线',
                'type' => 'line',
                'data' => $data_series_online_vag
            ]
        ];

        $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'list' => $list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*每日留存*/
    public function RetainDay(){
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
        $retain_type = I('retain_type', '1');   //留存类型，默认注册类型

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
        if(!empty($retain_type)){
            $where .= "and retain_type=$retain_type ";
        }
        if(!empty($start_time)){
            $where .= "and unix_timestamp(date) >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
            $where_regtal .= "and created_at >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
        }
        if(!empty($end_time)){
            $where .= "and unix_timestamp(date)<=" . strtotime(date('Y-m-d', strtotime($end_time))) . ' ';
            $where_regtal .= "and created_at <=" . strtotime(date('Y-m-d', strtotime($end_time))) . ' ';
        }

        $counts = $this->data_analysis_db->table('retain_day')
            ->group('date')
            ->where($where)
            ->select();
        $count = count($counts);
        $Page  = new \Think\Page($count,50);
        $list = $this->data_analysis_db->table('retain_day')
            ->field('
                date,
                sum(num) as num_total,
                sum(one_day_num) as one_day_num_total,
                sum(three_day_num) as three_day_num_total,
                sum(four_day_num) as four_day_num_total,
                sum(five_day_num) as five_day_num_total,
                sum(six_day_num) as six_day_num_total,
                sum(seven_day_num) as seven_day_num_total,
                sum(eight_day_num) as eight_day_num_total,
                sum(nine_day_num) as nine_day_num_total,
                sum(ten_day_num) as ten_day_num_total,
                sum(eleven_day_num) as eleven_day_num_total,
                sum(twelve_day_num) as twelve_day_num_total,
                sum(thirteen_day_num) as thirteen_day_num_total,
                sum(fourteen_day_num) as fourteen_day_num_total,
                sum(fifteen_day_num) as fifteen_day_num_total,
                sum(sixteen_day_num) as sixteen_day_num_total,
                sum(seventeen_day_num) as seventeen_day_num_total,
                sum(eighteen_day_num) as eighteen_day_num_total,
                sum(nineteen_day_num) as nineteen_day_num_total,
                sum(twenty_day_num) as twenty_day_num_total,
                sum(twenty_one_day_num) as twenty_one_day_num_total,
                sum(twenty_two_day_num) as twenty_two_day_num_total,
                sum(twenty_three_day_num) as twenty_three_day_num_total,
                sum(twenty_four_day_num) as twenty_four_day_num_total,
                sum(twenty_five_day_num) as twenty_five_day_num_total,
                sum(twenty_six_day_num) as twenty_six_day_num_total,
                sum(twenty_seven_day_num) as twenty_seven_day_num_total,
                sum(twenty_eight_day_num) as twenty_eight_day_num_total,
                sum(twenty_nine_day_num) as twenty_nine_day_num_total,
                sum(thirty_day_num) as thirty_day_num_total,
                sum(thirty_one_day_num) as thirty_one_day_num_total,
                sum(thirty_two_day_num) as thirty_two_day_num_total,
                sum(thirty_three_day_num) as thirty_three_day_num_total,
                sum(thirty_four_day_num) as thirty_four_day_num_total,
                sum(thirty_five_day_num) as thirty_five_day_num_total,
                sum(thirty_six_day_num) as thirty_six_day_num_total,
                sum(thirty_seven_day_num) as thirty_seven_day_num_total,
                sum(thirty_eight_day_num) as thirty_eight_day_num_total,
                sum(thirty_nine_day_num) as thirty_nine_day_num_total,
                sum(forty_day_num) as forty_day_num_total,
                sum(forty_one_day_num) as forty_one_day_num_total,
                sum(forty_two_day_num) as forty_two_day_num_total,
                sum(forty_three_day_num) as forty_three_day_num_total,
                sum(forty_four_day_num) as forty_four_day_num_total,
                sum(forty_five_day_num) as forty_five_day_num_total,
                sum(forty_six_day_num) as forty_six_day_num_total,
                sum(forty_seven_day_num) as forty_seven_day_num_total,
                sum(forty_eight_day_num) as forty_eight_day_num_total,
                sum(forty_nine_day_num) as forty_nine_day_num_total,
                sum(fifty_day_num) as fifty_day_num_total,
                sum(fifty_one_day_num) as fifty_one_day_num_total,
                sum(fifty_two_day_num) as fifty_two_day_num_total,
                sum(fifty_three_day_num) as fifty_three_day_num_total,
                sum(fifty_four_day_num) as fifty_four_day_num_total,
                sum(fifty_five_day_num) as fifty_five_day_num_total,
                sum(fifty_six_day_num) as fifty_six_day_num_total,
                sum(fifty_seven_day_num) as fifty_seven_day_num_total,
                sum(fifty_eight_day_num) as fifty_eight_day_num_total,
                sum(fifty_nine_day_num) as fifty_nine_day_num_total,
                sum(sixty_day_num) as sixty_day_num_total,
                sum(sixty_one_day_num) as sixty_one_day_num_total,
                sum(sixty_two_day_num) as sixty_two_day_num_total,
                sum(sixty_three_day_num) as sixty_three_day_num_total,
                sum(sixty_four_day_num) as sixty_four_day_num_total,
                sum(sixty_five_day_num) as sixty_five_day_num_total,
                sum(sixty_six_day_num) as sixty_six_day_num_total,
                sum(sixty_seven_day_num) as sixty_seven_day_num_total,
                sum(sixty_eight_day_num) as sixty_eight_day_num_total,
                sum(sixty_nine_day_num) as sixty_nine_day_num_total,
                sum(seventy_day_num) as seventy_day_num_total,
                sum(seventy_one_day_num) as seventy_one_day_num_total,
                sum(seventy_two_day_num) as seventy_two_day_num_total,
                sum(seventy_three_day_num) as seventy_three_day_num_total,
                sum(seventy_four_day_num) as seventy_four_day_num_total,
                sum(seventy_five_day_num) as seventy_five_day_num_total,
                sum(seventy_six_day_num) as seventy_six_day_num_total,
                sum(seventy_seven_day_num) as seventy_seven_day_num_total,
                sum(seventy_eight_day_num) as seventy_eight_day_num_total,
                sum(seventy_nine_day_num) as seventy_nine_day_num_total,
                sum(eighty_day_num) as eighty_day_num_total,
                sum(eighty_one_day_num) as eighty_one_day_num_total,
                sum(eighty_two_day_num) as eighty_two_day_num_total,
                sum(eighty_three_day_num) as eighty_three_day_num_total,
                sum(eighty_four_day_num) as eighty_four_day_num_total,
                sum(eighty_five_day_num) as eighty_five_day_num_total,
                sum(eighty_six_day_num) as eighty_six_day_num_total,
                sum(eighty_seven_day_num) as eighty_seven_day_num_total,
                sum(eighty_eight_day_num) as eighty_eight_day_num_total,
                sum(eighty_nine_day_num) as eighty_nine_day_num_total,
                sum(ninety_day_num) as ninety_day_num_total,
                sum(ninety_seven_day_num) as ninety_seven_day_num_total,
                sum(hundred_four_day_num) as hundred_four_day_num_total,
                sum(hundred_eleven_day_num) as hundred_eleven_day_num_total,
                sum(hundred_eighteen_day_num) as hundred_eighteen_day_num_total,
                sum(hundred_twenty_five_day_num) as hundred_twenty_five_day_num_total,
                sum(hundred_thirty_two_day_num) as hundred_thirty_two_day_num_total,
                sum(hundred_thirty_nine_day_num) as hundred_thirty_nine_day_num_total,
                sum(hundred_forty_six_day_num) as hundred_forty_six_day_num_total,
                sum(hundred_fifty_three_day_num) as hundred_fifty_three_day_num_total
            ')
            ->where($where)
            ->group('date')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        foreach($list as &$list_val){
            //处理显示为空
            $days = getTimeslotDays(strtotime($list_val['date']), time());

            if($retain_type == 1){  //注册类型特殊处理
                //获取注册数
                $where_reg = $where_regxu;
                $where_reg .= "and created_at >=" . strtotime($list_val['date'] . ' 00:00:00') . ' ';
                $where_reg .= "and created_at <=" . strtotime($list_val['date'] . ' 23:59:59') . ' ';
                $list_val['num_total'] = $this->platform_db->table('user')
                    ->where($where_reg)
                    ->count();
            }
            $list_val = [
                'date' => $list_val['date'],
                'num' => $list_val['num_total'],
                'one_day_retain' => ($days >= 2) ? getDivision($list_val['one_day_num_total'], $list_val['num_total']) . '%' : '',
                'three_day_retain' => ($days >= 3) ? getDivision($list_val['three_day_num_total'], $list_val['num_total']) . '%' : '',
                'four_day_retain' => ($days >= 4) ? getDivision($list_val['four_day_num_total'], $list_val['num_total']) . '%' : '',
                'five_day_retain' => ($days >= 5) ? getDivision($list_val['five_day_num_total'], $list_val['num_total']) . '%' : '',
                'six_day_retain' => ($days >= 6) ? getDivision($list_val['six_day_num_total'], $list_val['num_total']) . '%' : '',
                'seven_day_retain' => ($days >= 7) ? getDivision($list_val['seven_day_num_total'], $list_val['num_total']) . '%' : '',
                'eight_day_retain' => ($days >= 8) ? getDivision($list_val['eight_day_num_total'], $list_val['num_total']) . '%' : '',
                'nine_day_retain' => ($days >= 9) ? getDivision($list_val['nine_day_num_total'], $list_val['num_total']) . '%' : '',
                'ten_day_retain' => ($days >= 10) ? getDivision($list_val['ten_day_num_total'], $list_val['num_total']) . '%' : '',
                'eleven_day_retain' => ($days >= 11) ? getDivision($list_val['eleven_day_num_total'], $list_val['num_total']) . '%' : '',
                'twelve_day_retain' => ($days >= 12) ? getDivision($list_val['twelve_day_num_total'], $list_val['num_total']) . '%' : '',
                'thirteen_day_retain' => ($days >= 13) ? getDivision($list_val['thirteen_day_num_total'], $list_val['num_total']) . '%' : '',
                'fourteen_day_retain' => ($days >= 14) ? getDivision($list_val['fourteen_day_num_total'], $list_val['num_total']) . '%' : '',
                'fifteen_day_retain' => ($days >= 15) ? getDivision($list_val['fifteen_day_num_total'], $list_val['num_total']) . '%' : '',
                'sixteen_day_retain' => ($days >= 16) ? getDivision($list_val['sixteen_day_num_total'], $list_val['num_total']) . '%' : '',
                'seventeen_day_retain' => ($days >= 17) ? getDivision($list_val['seventeen_day_num_total'], $list_val['num_total']) . '%' : '',
                'eighteen_day_retain' => ($days >= 18) ? getDivision($list_val['eighteen_day_num_total'], $list_val['num_total']) . '%' : '',
                'nineteen_day_retain' => ($days >= 19) ? getDivision($list_val['nineteen_day_num_total'], $list_val['num_total']) . '%' : '',
                'twenty_day_retain' => ($days >= 20) ? getDivision($list_val['twenty_day_num_total'], $list_val['num_total']) . '%' : '',
                'twenty_one_day_retain' => ($days >= 21) ? getDivision($list_val['twenty_one_day_num_total'], $list_val['num_total']) . '%' : '',
                'twenty_two_day_retain' => ($days >= 22) ? getDivision($list_val['twenty_two_day_num_total'], $list_val['num_total']) . '%' : '',
                'twenty_three_day_retain' => ($days >= 23) ? getDivision($list_val['twenty_three_day_num_total'], $list_val['num_total']) . '%' : '',
                'twenty_four_day_retain' => ($days >= 24) ? getDivision($list_val['twenty_four_day_num_total'], $list_val['num_total']) . '%' : '',
                'twenty_five_day_retain' => ($days >= 25) ? getDivision($list_val['twenty_five_day_num_total'], $list_val['num_total']) . '%' : '',
                'twenty_six_day_retain' => ($days >= 26) ? getDivision($list_val['twenty_six_day_num_total'], $list_val['num_total']) . '%' : '',
                'twenty_seven_day_retain' => ($days >= 27) ? getDivision($list_val['twenty_seven_day_num_total'], $list_val['num_total']) . '%' : '',
                'twenty_eight_day_retain' => ($days >= 28) ? getDivision($list_val['twenty_eight_day_num_total'], $list_val['num_total']) . '%' : '',
                'twenty_nine_day_retain' => ($days >= 29) ? getDivision($list_val['twenty_nine_day_num_total'], $list_val['num_total']) . '%' : '',
                'thirty_day_retain' => ($days >= 30) ? getDivision($list_val['thirty_day_num_total'], $list_val['num_total']) . '%' : '',
                'thirty_one_day_retain' => ($days >= 31) ? getDivision($list_val['thirty_one_day_num_total'], $list_val['num_total']) . '%' : '',
                'thirty_two_day_retain' => ($days >= 32) ? getDivision($list_val['thirty_two_day_num_total'], $list_val['num_total']) . '%' : '',
                'thirty_three_day_retain' => ($days >= 33) ? getDivision($list_val['thirty_three_day_num_total'], $list_val['num_total']) . '%' : '',
                'thirty_four_day_retain' => ($days >= 34) ? getDivision($list_val['thirty_four_day_num_total'], $list_val['num_total']) . '%' : '',
                'thirty_five_day_retain' => ($days >= 35) ? getDivision($list_val['thirty_five_day_num_total'], $list_val['num_total']) . '%' : '',
                'thirty_six_day_retain' => ($days >= 36) ? getDivision($list_val['thirty_six_day_num_total'], $list_val['num_total']) . '%' : '',
                'thirty_seven_day_retain' => ($days >= 37) ? getDivision($list_val['thirty_seven_day_num_total'], $list_val['num_total']) . '%' : '',
                'thirty_eight_day_retain' => ($days >= 38) ? getDivision($list_val['thirty_eight_day_num_total'], $list_val['num_total']) . '%' : '',
                'thirty_nine_day_retain' => ($days >= 39) ? getDivision($list_val['thirty_nine_day_num_total'], $list_val['num_total']) . '%' : '',
                'forty_day_retain' => ($days >= 40) ? getDivision($list_val['forty_day_num_total'], $list_val['num_total']) . '%' : '',
                'forty_one_day_retain' => ($days >= 41) ? getDivision($list_val['forty_one_day_num_total'], $list_val['num_total']) . '%' : '',
                'forty_two_day_retain' => ($days >= 42) ? getDivision($list_val['forty_two_day_num_total'], $list_val['num_total']) . '%' : '',
                'forty_three_day_retain' => ($days >= 43) ? getDivision($list_val['forty_three_day_num_total'], $list_val['num_total']) . '%' : '',
                'forty_four_day_retain' => ($days >= 44) ? getDivision($list_val['forty_four_day_num_total'], $list_val['num_total']) . '%' : '',
                'forty_five_day_retain' => ($days >= 45) ? getDivision($list_val['forty_five_day_num_total'], $list_val['num_total']) . '%' : '',
                'forty_six_day_retain' => ($days >= 46) ? getDivision($list_val['forty_six_day_num_total'], $list_val['num_total']) . '%' : '',
                'forty_seven_day_retain' => ($days >= 47) ? getDivision($list_val['forty_seven_day_num_total'], $list_val['num_total']) . '%' : '',
                'forty_eight_day_retain' => ($days >= 48) ? getDivision($list_val['forty_eight_day_num_total'], $list_val['num_total']) . '%' : '',
                'forty_nine_day_retain' => ($days >= 49) ? getDivision($list_val['forty_nine_day_num_total'], $list_val['num_total']) . '%' : '',
                'fifty_day_retain' => ($days >= 50) ? getDivision($list_val['fifty_day_num_total'], $list_val['num_total']) . '%' : '',
                'fifty_one_day_retain' => ($days >= 51) ? getDivision($list_val['fifty_one_day_num_total'], $list_val['num_total']) . '%' : '',
                'fifty_two_day_retain' => ($days >= 52) ? getDivision($list_val['fifty_two_day_num_total'], $list_val['num_total']) . '%' : '',
                'fifty_three_day_retain' => ($days >= 53) ? getDivision($list_val['fifty_three_day_num_total'], $list_val['num_total']) . '%' : '',
                'fifty_four_day_retain' => ($days >= 54) ? getDivision($list_val['fifty_four_day_num_total'], $list_val['num_total']) . '%' : '',
                'fifty_five_day_retain' => ($days >= 55) ? getDivision($list_val['fifty_five_day_num_total'], $list_val['num_total']) . '%' : '',
                'fifty_six_day_retain' => ($days >= 56) ? getDivision($list_val['fifty_six_day_num_total'], $list_val['num_total']) . '%' : '',
                'fifty_seven_day_retain' => ($days >= 57) ? getDivision($list_val['fifty_seven_day_num_total'], $list_val['num_total']) . '%' : '',
                'fifty_eight_day_retain' => ($days >= 58) ? getDivision($list_val['fifty_eight_day_num_total'], $list_val['num_total']) . '%' : '',
                'fifty_nine_day_retain' => ($days >= 59) ? getDivision($list_val['fifty_nine_day_num_total'], $list_val['num_total']) . '%' : '',
                'sixty_day_retain' => ($days >= 60) ? getDivision($list_val['sixty_day_num_total'], $list_val['num_total']) . '%' : '',
                'sixty_one_day_retain' => ($days >= 61) ? getDivision($list_val['sixty_one_day_num_total'], $list_val['num_total']) . '%' : '',
                'sixty_two_day_retain' => ($days >= 62) ? getDivision($list_val['sixty_two_day_num_total'], $list_val['num_total']) . '%' : '',
                'sixty_three_day_retain' => ($days >= 63) ? getDivision($list_val['sixty_three_day_num_total'], $list_val['num_total']) . '%' : '',
                'sixty_four_day_retain' => ($days >= 64) ? getDivision($list_val['sixty_four_day_num_total'], $list_val['num_total']) . '%' : '',
                'sixty_five_day_retain' => ($days >= 65) ? getDivision($list_val['sixty_five_day_num_total'], $list_val['num_total']) . '%' : '',
                'sixty_six_day_retain' => ($days >= 66) ? getDivision($list_val['sixty_six_day_num_total'], $list_val['num_total']) . '%' : '',
                'sixty_seven_day_retain' => ($days >= 67) ? getDivision($list_val['sixty_seven_day_num_total'], $list_val['num_total']) . '%' : '',
                'sixty_eight_day_retain' => ($days >= 68) ? getDivision($list_val['sixty_eight_day_num_total'], $list_val['num_total']) . '%' : '',
                'sixty_nine_day_retain' => ($days >= 69) ? getDivision($list_val['sixty_nine_day_num_total'], $list_val['num_total']) . '%' : '',
                'seventy_day_retain' => ($days >= 70) ? getDivision($list_val['seventy_day_num_total'], $list_val['num_total']) . '%' : '',
                'seventy_one_day_retain' => ($days >= 71) ? getDivision($list_val['seventy_one_day_num_total'], $list_val['num_total']) . '%' : '',
                'seventy_two_day_retain' => ($days >= 72) ? getDivision($list_val['seventy_two_day_num_total'], $list_val['num_total']) . '%' : '',
                'seventy_three_day_retain' => ($days >= 73) ? getDivision($list_val['seventy_three_day_num_total'], $list_val['num_total']) . '%' : '',
                'seventy_four_day_retain' => ($days >= 74) ? getDivision($list_val['seventy_four_day_num_total'], $list_val['num_total']) . '%' : '',
                'seventy_five_day_retain' => ($days >= 75) ? getDivision($list_val['seventy_five_day_num_total'], $list_val['num_total']) . '%' : '',
                'seventy_six_day_retain' => ($days >= 76) ? getDivision($list_val['seventy_six_day_num_total'], $list_val['num_total']) . '%' : '',
                'seventy_seven_day_retain' => ($days >= 77) ? getDivision($list_val['seventy_seven_day_num_total'], $list_val['num_total']) . '%' : '',
                'seventy_eight_day_retain' => ($days >= 78) ? getDivision($list_val['seventy_eight_day_num_total'], $list_val['num_total']) . '%' : '',
                'seventy_nine_day_retain' => ($days >= 79) ? getDivision($list_val['seventy_nine_day_num_total'], $list_val['num_total']) . '%' : '',
                'eighty_day_retain' => ($days >= 80) ? getDivision($list_val['eighty_day_num_total'], $list_val['num_total']) . '%' : '',
                'eighty_one_day_retain' => ($days >= 81) ? getDivision($list_val['eighty_one_day_num_total'], $list_val['num_total']) . '%' : '',
                'eighty_two_day_retain' => ($days >= 82) ? getDivision($list_val['eighty_two_day_num_total'], $list_val['num_total']) . '%' : '',
                'eighty_three_day_retain' => ($days >= 83) ? getDivision($list_val['eighty_three_day_num_total'], $list_val['num_total']) . '%' : '',
                'eighty_four_day_retain' => ($days >= 84) ? getDivision($list_val['eighty_four_day_num_total'], $list_val['num_total']) . '%' : '',
                'eighty_five_day_retain' => ($days >= 85) ? getDivision($list_val['eighty_five_day_num_total'], $list_val['num_total']) . '%' : '',
                'eighty_six_day_retain' => ($days >= 86) ? getDivision($list_val['eighty_six_day_num_total'], $list_val['num_total']) . '%' : '',
                'eighty_seven_day_retain' => ($days >= 87) ? getDivision($list_val['eighty_seven_day_num_total'], $list_val['num_total']) . '%' : '',
                'eighty_eight_day_retain' => ($days >= 88) ? getDivision($list_val['eighty_eight_day_num_total'], $list_val['num_total']) . '%' : '',
                'eighty_nine_day_retain' => ($days >= 89) ? getDivision($list_val['eighty_nine_day_num_total'], $list_val['num_total']) . '%' : '',
                'ninety_day_retain' => ($days >= 90) ? getDivision($list_val['ninety_day_num_total'], $list_val['num_total']) . '%' : '',
                'ninety_seven_day_retain' => ($days >= 97) ? getDivision($list_val['ninety_seven_day_num_total'], $list_val['num_total']) . '%' : '',
                'hundred_four_day_retain' => ($days >= 104) ? getDivision($list_val['hundred_four_day_num_total'], $list_val['num_total']) . '%' : '',
                'hundred_eleven_day_retain' => ($days >= 111) ? getDivision($list_val['hundred_eleven_day_num_total'], $list_val['num_total']) . '%' : '',
                'hundred_eighteen_day_retain' => ($days >= 118) ? getDivision($list_val['hundred_eighteen_day_num_total'], $list_val['num_total']) . '%' : '',
                'hundred_twenty_five_day_retain' => ($days >= 125) ? getDivision($list_val['hundred_twenty_five_day_num_total'], $list_val['num_total']) . '%' : '',
                'hundred_thirty_two_day_retain' => ($days >= 132) ? getDivision($list_val['hundred_thirty_two_day_num_total'], $list_val['num_total']) . '%' : '',
                'hundred_thirty_nine_day_retain' => ($days >= 139) ? getDivision($list_val['hundred_thirty_nine_day_num_total'], $list_val['num_total']) . '%' : '',
                'hundred_forty_six_day_retain' => ($days >= 146) ? getDivision($list_val['hundred_forty_six_day_num_total'], $list_val['num_total']) . '%' : '',
                'hundred_fifty_three_day_retain' => ($days >= 153) ? getDivision($list_val['hundred_fifty_three_day_num_total'], $list_val['num_total']) . '%' : '',
            ];
        }

        //计算汇总数据
        $data_total = $this->data_analysis_db->table('retain_day')
            ->field('
                sum(num) as num_total,
                sum(one_day_num) as one_day_num_total,
                sum(three_day_num) as three_day_num_total,
                sum(four_day_num) as four_day_num_total,
                sum(five_day_num) as five_day_num_total,
                sum(six_day_num) as six_day_num_total,
                sum(seven_day_num) as seven_day_num_total,
                sum(eight_day_num) as eight_day_num_total,
                sum(nine_day_num) as nine_day_num_total,
                sum(ten_day_num) as ten_day_num_total,
                sum(eleven_day_num) as eleven_day_num_total,
                sum(twelve_day_num) as twelve_day_num_total,
                sum(thirteen_day_num) as thirteen_day_num_total,
                sum(fourteen_day_num) as fourteen_day_num_total,
                sum(fifteen_day_num) as fifteen_day_num_total,
                sum(sixteen_day_num) as sixteen_day_num_total,
                sum(seventeen_day_num) as seventeen_day_num_total,
                sum(eighteen_day_num) as eighteen_day_num_total,
                sum(nineteen_day_num) as nineteen_day_num_total,
                sum(twenty_day_num) as twenty_day_num_total,
                sum(twenty_one_day_num) as twenty_one_day_num_total,
                sum(twenty_two_day_num) as twenty_two_day_num_total,
                sum(twenty_three_day_num) as twenty_three_day_num_total,
                sum(twenty_four_day_num) as twenty_four_day_num_total,
                sum(twenty_five_day_num) as twenty_five_day_num_total,
                sum(twenty_six_day_num) as twenty_six_day_num_total,
                sum(twenty_seven_day_num) as twenty_seven_day_num_total,
                sum(twenty_eight_day_num) as twenty_eight_day_num_total,
                sum(twenty_nine_day_num) as twenty_nine_day_num_total,
                sum(thirty_day_num) as thirty_day_num_total,
                sum(thirty_one_day_num) as thirty_one_day_num_total,
                sum(thirty_two_day_num) as thirty_two_day_num_total,
                sum(thirty_three_day_num) as thirty_three_day_num_total,
                sum(thirty_four_day_num) as thirty_four_day_num_total,
                sum(thirty_five_day_num) as thirty_five_day_num_total,
                sum(thirty_six_day_num) as thirty_six_day_num_total,
                sum(thirty_seven_day_num) as thirty_seven_day_num_total,
                sum(thirty_eight_day_num) as thirty_eight_day_num_total,
                sum(thirty_nine_day_num) as thirty_nine_day_num_total,
                sum(forty_day_num) as forty_day_num_total,
                sum(forty_one_day_num) as forty_one_day_num_total,
                sum(forty_two_day_num) as forty_two_day_num_total,
                sum(forty_three_day_num) as forty_three_day_num_total,
                sum(forty_four_day_num) as forty_four_day_num_total,
                sum(forty_five_day_num) as forty_five_day_num_total,
                sum(forty_six_day_num) as forty_six_day_num_total,
                sum(forty_seven_day_num) as forty_seven_day_num_total,
                sum(forty_eight_day_num) as forty_eight_day_num_total,
                sum(forty_nine_day_num) as forty_nine_day_num_total,
                sum(fifty_day_num) as fifty_day_num_total,
                sum(fifty_one_day_num) as fifty_one_day_num_total,
                sum(fifty_two_day_num) as fifty_two_day_num_total,
                sum(fifty_three_day_num) as fifty_three_day_num_total,
                sum(fifty_four_day_num) as fifty_four_day_num_total,
                sum(fifty_five_day_num) as fifty_five_day_num_total,
                sum(fifty_six_day_num) as fifty_six_day_num_total,
                sum(fifty_seven_day_num) as fifty_seven_day_num_total,
                sum(fifty_eight_day_num) as fifty_eight_day_num_total,
                sum(fifty_nine_day_num) as fifty_nine_day_num_total,
                sum(sixty_day_num) as sixty_day_num_total,
                sum(sixty_one_day_num) as sixty_one_day_num_total,
                sum(sixty_two_day_num) as sixty_two_day_num_total,
                sum(sixty_three_day_num) as sixty_three_day_num_total,
                sum(sixty_four_day_num) as sixty_four_day_num_total,
                sum(sixty_five_day_num) as sixty_five_day_num_total,
                sum(sixty_six_day_num) as sixty_six_day_num_total,
                sum(sixty_seven_day_num) as sixty_seven_day_num_total,
                sum(sixty_eight_day_num) as sixty_eight_day_num_total,
                sum(sixty_nine_day_num) as sixty_nine_day_num_total,
                sum(seventy_day_num) as seventy_day_num_total,
                sum(seventy_one_day_num) as seventy_one_day_num_total,
                sum(seventy_two_day_num) as seventy_two_day_num_total,
                sum(seventy_three_day_num) as seventy_three_day_num_total,
                sum(seventy_four_day_num) as seventy_four_day_num_total,
                sum(seventy_five_day_num) as seventy_five_day_num_total,
                sum(seventy_six_day_num) as seventy_six_day_num_total,
                sum(seventy_seven_day_num) as seventy_seven_day_num_total,
                sum(seventy_eight_day_num) as seventy_eight_day_num_total,
                sum(seventy_nine_day_num) as seventy_nine_day_num_total,
                sum(eighty_day_num) as eighty_day_num_total,
                sum(eighty_one_day_num) as eighty_one_day_num_total,
                sum(eighty_two_day_num) as eighty_two_day_num_total,
                sum(eighty_three_day_num) as eighty_three_day_num_total,
                sum(eighty_four_day_num) as eighty_four_day_num_total,
                sum(eighty_five_day_num) as eighty_five_day_num_total,
                sum(eighty_six_day_num) as eighty_six_day_num_total,
                sum(eighty_seven_day_num) as eighty_seven_day_num_total,
                sum(eighty_eight_day_num) as eighty_eight_day_num_total,
                sum(eighty_nine_day_num) as eighty_nine_day_num_total,
                sum(ninety_day_num) as ninety_day_num_total,
                sum(ninety_seven_day_num) as ninety_seven_day_num_total,
                sum(hundred_four_day_num) as hundred_four_day_num_total,
                sum(hundred_eleven_day_num) as hundred_eleven_day_num_total,
                sum(hundred_eighteen_day_num) as hundred_eighteen_day_num_total,
                sum(hundred_twenty_five_day_num) as hundred_twenty_five_day_num_total,
                sum(hundred_thirty_two_day_num) as hundred_thirty_two_day_num_total,
                sum(hundred_thirty_nine_day_num) as hundred_thirty_nine_day_num_total,
                sum(hundred_forty_six_day_num) as hundred_forty_six_day_num_total,
                sum(hundred_fifty_three_day_num) as hundred_fifty_three_day_num_total
            ')
            ->where($where)
            ->find();
        if($retain_type == 1){
            //获取注册数
            $data_total['num_total'] = $this->platform_db->table('user')
                ->where($where_regtal)
                ->count();
        }
        
        $list[] = [
            'date' => '汇总',
            'num' => $data_total['num_total'],
            'one_day_retain' => getDivision($data_total['one_day_num_total'], $data_total['num_total']) . '%',
            'three_day_retain' => getDivision($data_total['three_day_num_total'], $data_total['num_total']) . '%',
            'four_day_retain' => getDivision($data_total['four_day_num_total'], $data_total['num_total']) . '%',
            'five_day_retain' => getDivision($data_total['five_day_num_total'], $data_total['num_total']) . '%',
            'six_day_retain' => getDivision($data_total['six_day_num_total'], $data_total['num_total']) . '%',
            'seven_day_retain' => getDivision($data_total['seven_day_num_total'], $data_total['num_total']) . '%',
            'eight_day_retain' => getDivision($data_total['eight_day_num_total'], $data_total['num_total']) . '%',
            'nine_day_retain' => getDivision($data_total['nine_day_num_total'], $data_total['num_total']) . '%',
            'ten_day_retain' => getDivision($data_total['ten_day_num_total'], $data_total['num_total']) . '%',
            'eleven_day_retain' => getDivision($data_total['eleven_day_num_total'], $data_total['num_total']) . '%',
            'twelve_day_retain' => getDivision($data_total['twelve_day_num_total'], $data_total['num_total']) . '%',
            'thirteen_day_retain' => getDivision($data_total['thirteen_day_num_total'], $data_total['num_total']) . '%',
            'fourteen_day_retain' => getDivision($data_total['fourteen_day_num_total'], $data_total['num_total']) . '%',
            'fifteen_day_retain' => getDivision($data_total['fifteen_day_num_total'], $data_total['num_total']) . '%',
            'sixteen_day_retain' => getDivision($data_total['sixteen_day_num_total'], $data_total['num_total']) . '%',
            'seventeen_day_retain' => getDivision($data_total['seventeen_day_num_total'], $data_total['num_total']) . '%',
            'eighteen_day_retain' => getDivision($data_total['eighteen_day_num_total'], $data_total['num_total']) . '%',
            'nineteen_day_retain' => getDivision($data_total['nineteen_day_num_total'], $data_total['num_total']) . '%',
            'twenty_day_retain' => getDivision($data_total['twenty_day_num_total'], $data_total['num_total']) . '%',
            'twenty_one_day_retain' => getDivision($data_total['twenty_one_day_num_total'], $data_total['num_total']) . '%',
            'twenty_two_day_retain' => getDivision($data_total['twenty_two_day_num_total'], $data_total['num_total']) . '%',
            'twenty_three_day_retain' => getDivision($data_total['twenty_three_day_num_total'], $data_total['num_total']) . '%',
            'twenty_four_day_retain' => getDivision($data_total['twenty_four_day_num_total'], $data_total['num_total']) . '%',
            'twenty_five_day_retain' => getDivision($data_total['twenty_five_day_num_total'], $data_total['num_total']) . '%',
            'twenty_six_day_retain' => getDivision($data_total['twenty_six_day_num_total'], $data_total['num_total']) . '%',
            'twenty_seven_day_retain' => getDivision($data_total['twenty_seven_day_num_total'], $data_total['num_total']) . '%',
            'twenty_eight_day_retain' => getDivision($data_total['twenty_eight_day_num_total'], $data_total['num_total']) . '%',
            'twenty_nine_day_retain' => getDivision($data_total['twenty_nine_day_num_total'], $data_total['num_total']) . '%',
            'thirty_day_retain' => getDivision($data_total['thirty_day_num_total'], $data_total['num_total']) . '%',
            'thirty_one_day_retain' => getDivision($data_total['thirty_one_day_num_total'], $data_total['num_total']) . '%',
            'thirty_two_day_retain' => getDivision($data_total['thirty_two_day_num_total'], $data_total['num_total']) . '%',
            'thirty_three_day_retain' => getDivision($data_total['thirty_three_day_num_total'], $data_total['num_total']) . '%',
            'thirty_four_day_retain' => getDivision($data_total['thirty_four_day_num_total'], $data_total['num_total']) . '%',
            'thirty_five_day_retain' => getDivision($data_total['thirty_five_day_num_total'], $data_total['num_total']) . '%',
            'thirty_six_day_retain' => getDivision($data_total['thirty_six_day_num_total'], $data_total['num_total']) . '%',
            'thirty_seven_day_retain' => getDivision($data_total['thirty_seven_day_num_total'], $data_total['num_total']) . '%',
            'thirty_eight_day_retain' => getDivision($data_total['thirty_eight_day_num_total'], $data_total['num_total']) . '%',
            'thirty_nine_day_retain' => getDivision($data_total['thirty_nine_day_num_total'], $data_total['num_total']) . '%',
            'forty_day_retain' => getDivision($data_total['forty_day_num_total'], $data_total['num_total']) . '%',
            'forty_one_day_retain' => getDivision($data_total['forty_one_day_num_total'], $data_total['num_total']) . '%',
            'forty_two_day_retain' => getDivision($data_total['forty_two_day_num_total'], $data_total['num_total']) . '%',
            'forty_three_day_retain' => getDivision($data_total['forty_three_day_num_total'], $data_total['num_total']) . '%',
            'forty_four_day_retain' => getDivision($data_total['forty_four_day_num_total'], $data_total['num_total']) . '%',
            'forty_five_day_retain' => getDivision($data_total['forty_five_day_num_total'], $data_total['num_total']) . '%',
            'forty_six_day_retain' => getDivision($data_total['forty_six_day_num_total'], $data_total['num_total']) . '%',
            'forty_seven_day_retain' => getDivision($data_total['forty_seven_day_num_total'], $data_total['num_total']) . '%',
            'forty_eight_day_retain' => getDivision($data_total['forty_eight_day_num_total'], $data_total['num_total']) . '%',
            'forty_nine_day_retain' => getDivision($data_total['forty_nine_day_num_total'], $data_total['num_total']) . '%',
            'fifty_day_retain' => getDivision($data_total['fifty_day_num_total'], $data_total['num_total']) . '%',
            'fifty_one_day_retain' => getDivision($data_total['fifty_one_day_num_total'], $data_total['num_total']) . '%',
            'fifty_two_day_retain' => getDivision($data_total['fifty_two_day_num_total'], $data_total['num_total']) . '%',
            'fifty_three_day_retain' => getDivision($data_total['fifty_three_day_num_total'], $data_total['num_total']) . '%',
            'fifty_four_day_retain' => getDivision($data_total['fifty_four_day_num_total'], $data_total['num_total']) . '%',
            'fifty_five_day_retain' => getDivision($data_total['fifty_five_day_num_total'], $data_total['num_total']) . '%',
            'fifty_six_day_retain' => getDivision($data_total['fifty_six_day_num_total'], $data_total['num_total']) . '%',
            'fifty_seven_day_retain' => getDivision($data_total['fifty_seven_day_num_total'], $data_total['num_total']) . '%',
            'fifty_eight_day_retain' => getDivision($data_total['fifty_eight_day_num_total'], $data_total['num_total']) . '%',
            'fifty_nine_day_retain' => getDivision($data_total['fifty_nine_day_num_total'], $data_total['num_total']) . '%',
            'sixty_day_retain' => getDivision($data_total['sixty_day_num_total'], $data_total['num_total']) . '%',
            'sixty_one_day_retain' => getDivision($data_total['sixty_one_day_num_total'], $data_total['num_total']) . '%',
            'sixty_two_day_retain' => getDivision($data_total['sixty_two_day_num_total'], $data_total['num_total']) . '%',
            'sixty_three_day_retain' => getDivision($data_total['sixty_three_day_num_total'], $data_total['num_total']) . '%',
            'sixty_four_day_retain' => getDivision($data_total['sixty_four_day_num_total'], $data_total['num_total']) . '%',
            'sixty_five_day_retain' => getDivision($data_total['sixty_five_day_num_total'], $data_total['num_total']) . '%',
            'sixty_six_day_retain' => getDivision($data_total['sixty_six_day_num_total'], $data_total['num_total']) . '%',
            'sixty_seven_day_retain' => getDivision($data_total['sixty_seven_day_num_total'], $data_total['num_total']) . '%',
            'sixty_eight_day_retain' => getDivision($data_total['sixty_eight_day_num_total'], $data_total['num_total']) . '%',
            'sixty_nine_day_retain' => getDivision($data_total['sixty_nine_day_num_total'], $data_total['num_total']) . '%',
            'seventy_day_retain' => getDivision($data_total['seventy_day_num_total'], $data_total['num_total']) . '%',
            'seventy_one_day_retain' => getDivision($data_total['seventy_one_day_num_total'], $data_total['num_total']) . '%',
            'seventy_two_day_retain' => getDivision($data_total['seventy_two_day_num_total'], $data_total['num_total']) . '%',
            'seventy_three_day_retain' => getDivision($data_total['seventy_three_day_num_total'], $data_total['num_total']) . '%',
            'seventy_four_day_retain' => getDivision($data_total['seventy_four_day_num_total'], $data_total['num_total']) . '%',
            'seventy_five_day_retain' => getDivision($data_total['seventy_five_day_num_total'], $data_total['num_total']) . '%',
            'seventy_six_day_retain' => getDivision($data_total['seventy_six_day_num_total'], $data_total['num_total']) . '%',
            'seventy_seven_day_retain' => getDivision($data_total['seventy_seven_day_num_total'], $data_total['num_total']) . '%',
            'seventy_eight_day_retain' => getDivision($data_total['seventy_eight_day_num_total'], $data_total['num_total']) . '%',
            'seventy_nine_day_retain' => getDivision($data_total['seventy_nine_day_num_total'], $data_total['num_total']) . '%',
            'eighty_day_retain' => getDivision($data_total['eighty_day_num_total'], $data_total['num_total']) . '%',
            'eighty_one_day_retain' => getDivision($data_total['eighty_one_day_num_total'], $data_total['num_total']) . '%',
            'eighty_two_day_retain' => getDivision($data_total['eighty_two_day_num_total'], $data_total['num_total']) . '%',
            'eighty_three_day_retain' => getDivision($data_total['eighty_three_day_num_total'], $data_total['num_total']) . '%',
            'eighty_four_day_retain' => getDivision($data_total['eighty_four_day_num_total'], $data_total['num_total']) . '%',
            'eighty_five_day_retain' => getDivision($data_total['eighty_five_day_num_total'], $data_total['num_total']) . '%',
            'eighty_six_day_retain' => getDivision($data_total['eighty_six_day_num_total'], $data_total['num_total']) . '%',
            'eighty_seven_day_retain' => getDivision($data_total['eighty_seven_day_num_total'], $data_total['num_total']) . '%',
            'eighty_eight_day_retain' => getDivision($data_total['eighty_eight_day_num_total'], $data_total['num_total']) . '%',
            'eighty_nine_day_retain' => getDivision($data_total['eighty_nine_day_num_total'], $data_total['num_total']) . '%',
            'ninety_day_retain' => getDivision($data_total['ninety_day_num_total'], $data_total['num_total']) . '%',
            'ninety_seven_day_retain' => getDivision($data_total['ninety_seven_day_num_total'], $data_total['num_total']) . '%',
            'hundred_four_day_retain' => getDivision($data_total['hundred_four_day_num_total'], $data_total['num_total']) . '%',
            'hundred_eleven_day_retain' => getDivision($data_total['hundred_eleven_day_num_total'], $data_total['num_total']) . '%',
            'hundred_eighteen_day_retain' => getDivision($data_total['hundred_eighteen_day_num_total'], $data_total['num_total']) . '%',
            'hundred_twenty_five_day_retain' => getDivision($data_total['hundred_twenty_five_day_num_total'], $data_total['num_total']) . '%',
            'hundred_thirty_two_day_retain' => getDivision($data_total['hundred_thirty_two_day_num_total'], $data_total['num_total']) . '%',
            'hundred_thirty_nine_day_retain' => getDivision($data_total['hundred_thirty_nine_day_num_total'], $data_total['num_total']) . '%',
            'hundred_forty_six_day_retain' => getDivision($data_total['hundred_forty_six_day_num_total'], $data_total['num_total']) . '%',
            'hundred_fifty_three_day_retain' => getDivision($data_total['hundred_fifty_three_day_num_total'], $data_total['num_total']) . '%',
        ];

        $show = $Page->show();
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'start_time' => $start_time,
            'end_time' => $end_time,
            'retain_type' => $retain_type
        ];
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*每日留存假数据*/
    public function RetainDayCopy(){
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
        $now_date = date('Y-m-d H:i:s');
        $start_time = I('start_time', date('Y-m-d H:i:s', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);
        $retain_type = I('retain_type', '1');   //留存类型，默认注册类型

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
        if(!empty($retain_type)){
            $where .= "and retain_type=$retain_type ";
        }
        if(!empty($start_time)){
            $where .= "and unix_timestamp(date) >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
            $where_regtal .= "and created_at >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
        }
        if(!empty($end_time)){
            $where .= "and unix_timestamp(date)<=" . strtotime(date('Y-m-d', strtotime($end_time))) . ' ';
            $where_regtal .= "and created_at <=" . strtotime(date('Y-m-d', strtotime($end_time))) . ' ';
        }

        $counts = $this->data_analysis_db->table('retain_day_copy')
            ->group('date')
            ->where($where)
            ->select();
        $count = count($counts);
        $Page  = new \Think\Page($count,50);
        $list = $this->data_analysis_db->table('retain_day_copy')
            ->field('
                date,
                sum(num) as num_total,
                sum(one_day_num) as one_day_num_total,
                sum(three_day_num) as three_day_num_total,
                sum(four_day_num) as four_day_num_total,
                sum(five_day_num) as five_day_num_total,
                sum(six_day_num) as six_day_num_total,
                sum(seven_day_num) as seven_day_num_total,
                sum(ten_day_num) as ten_day_num_total,
                sum(fourteen_day_num) as fourteen_day_num_total,
                sum(twenty_day_num) as twenty_day_num_total,
                sum(thirty_day_num) as thirty_day_num_total,
                sum(sixty_day_num) as sixty_day_num_total,
                sum(ninety_day_num) as ninety_day_num_total
            ')
            ->where($where)
            ->group('date')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        foreach($list as &$list_val){
            if($retain_type == 1){  //注册类型特殊处理
                //获取注册数
                $where_reg = $where_regxu;
                $where_reg .= "and created_at >=" . strtotime($list_val['date'] . ' 00:00:00') . ' ';
                $where_reg .= "and created_at <=" . strtotime($list_val['date'] . ' 23:59:59') . ' ';
                $list_val['num_total'] = $this->platform_db->table('user')
                    ->where($where_reg)
                    ->count();
            }
            $list_val = [
                'date' => $list_val['date'],
                'num' => $list_val['num_total'],
                'one_day_retain' => getDivision($list_val['one_day_num_total'], $list_val['num_total']) . '%',
                'three_day_retain' => getDivision($list_val['three_day_num_total'], $list_val['num_total']) . '%',
                'four_day_retain' => getDivision($list_val['four_day_num_total'], $list_val['num_total']) . '%',
                'five_day_retain' => getDivision($list_val['five_day_num_total'], $list_val['num_total']) . '%',
                'six_day_retain' => getDivision($list_val['six_day_num_total'], $list_val['num_total']) . '%',
                'seven_day_retain' => getDivision($list_val['seven_day_num_total'], $list_val['num_total']) . '%',
                'ten_day_retain' => getDivision($list_val['ten_day_num_total'], $list_val['num_total']) . '%',
                'fourteen_day_retain' => getDivision($list_val['fourteen_day_num_total'], $list_val['num_total']) . '%',
                'twenty_day_retain' => getDivision($list_val['twenty_day_num_total'], $list_val['num_total']) . '%',
                'thirty_day_retain' => getDivision($list_val['thirty_day_num_total'], $list_val['num_total']) . '%',
                'sixty_day_retain' => getDivision($list_val['sixty_day_num_total'], $list_val['num_total']) . '%',
                'ninety_day_retain' => getDivision($list_val['ninety_day_num_total'], $list_val['num_total']) . '%',
            ];
        }

        //计算汇总数据
        $data_total = $this->data_analysis_db->table('retain_day_copy')
            ->field('
                sum(num) as num_total
            ')
            ->where($where)
            ->find();
        if($retain_type == 1){
            //获取注册数
            $data_total['num_total'] = $this->platform_db->table('user')
                ->where($where_regtal)
                ->count();
        }
        
        $list[] = [
            'date' => '汇总',
            'num' => $data_total['num_total'],
            'one_day_retain' => '',
            'three_day_retain' => '',
            'four_day_retain' => '',
            'five_day_retain' => '',
            'six_day_retain' => '',
            'seven_day_retain' => '',
            'ten_day_retain' => '',
            'fourteen_day_retain' => '',
            'twenty_day_retain' => '',
            'thirty_day_retain' => '',
            'sixty_day_retain' => '',
            'ninety_day_retain' => '',
        ];

        $show = $Page->show();
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'start_time' => $start_time,
            'end_time' => $end_time,
            'retain_type' => $retain_type
        ];
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*等级关卡流失*/
    public function CheckpointLoss(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();
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
        $checkpoint_type = I('checkpoint_type', '1');

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'start_time' => $start_time,
            'end_time' => $end_time,
            'checkpoint_type' => $checkpoint_type
        ];
        //判断必要筛选条件是否选择了
        if(empty($start_time) || empty($end_time) || empty($checkpoint_type)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择关卡类型和日期！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $where = '1 ';
        if(!empty($sid)){
            $where .= "and sid in($sid) ";
        }
        $where .= "and checkpoint_type=$checkpoint_type ";
        if(!empty($c_son_id)){
            $where .= "and c_son_id in($c_son_id) ";
        }
        $where .= "and unix_timestamp(date) >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
        $where .= "and unix_timestamp(date)<=" . strtotime(date('Y-m-d', strtotime($end_time))) . ' ';

        $count = $this->data_analysis_db->table('checkpoint_loss')
            ->where($where)
            ->count("distinct checkpoint_num");
        $Page  = new \Think\Page($count,50);
        $list = $this->data_analysis_db->table('checkpoint_loss')
            ->field('
                checkpoint_num,
                sum(one_day_stop_num) as one_day_stop_num_total,
                sum(three_day_stop_num) as three_day_stop_num_total,
                sum(five_day_stop_num) as five_day_stop_num_total,
                sum(seven_day_stop_num) as seven_day_stop_num_total,
                sum(fourteen_day_stop_num) as fourteen_day_stop_num_total
            ')
            ->where($where)
            ->group('checkpoint_num')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        //获取创角数（以第一层的创角数为准）
        $create_role_num_totals = $this->data_analysis_db->table('checkpoint_loss')
            ->where($where . "and checkpoint_num=1")
            ->sum("create_role_num");
        if(empty($create_role_num_totals)){
            $create_role_num_totals = 0;
        }
        foreach($list as &$list_val){
            $list_val = [
                'checkpoint_num' => $list_val['checkpoint_num'],
                'create_role_num' => $create_role_num_totals,
                'one_day_stop_num' => $list_val['one_day_stop_num_total'],
                'one_day_retain' => getDivision($list_val['one_day_stop_num_total'], $create_role_num_totals),
                'three_day_stop_num' => $list_val['three_day_stop_num_total'],
                'three_day_retain' => getDivision($list_val['three_day_stop_num_total'], $create_role_num_totals),
                'five_day_stop_num' => $list_val['five_day_stop_num_total'],
                'five_day_retain' => getDivision($list_val['five_day_stop_num_total'], $create_role_num_totals),
                'seven_day_stop_num' => $list_val['seven_day_stop_num_total'],
                'seven_day_retain' => getDivision($list_val['seven_day_stop_num_total'], $create_role_num_totals),
                'fourteen_day_stop_num' => $list_val['fourteen_day_stop_num_total'],
                'fourteen_day_retain' => getDivision($list_val['fourteen_day_stop_num_total'], $create_role_num_totals),
            ];
        }

        //计算汇总数据
        $data_total = $this->data_analysis_db->table('checkpoint_loss')
            ->field('
                sum(one_day_stop_num) as one_day_stop_num_total,
                sum(three_day_stop_num) as three_day_stop_num_total,
                sum(five_day_stop_num) as five_day_stop_num_total,
                sum(seven_day_stop_num) as seven_day_stop_num_total,
                sum(fourteen_day_stop_num) as fourteen_day_stop_num_total
            ')
            ->where($where)
            ->find();

        $list[] = [
            'checkpoint_num' => '汇总',
            'create_role_num' => $create_role_num_totals,
            'one_day_stop_num' => $data_total['one_day_stop_num_total'],
            'one_day_retain' => '100',
            'three_day_stop_num' => $data_total['three_day_stop_num_total'],
            'three_day_retain' => '100',
            'five_day_stop_num' => $data_total['five_day_stop_num_total'],
            'five_day_retain' => '100',
            'seven_day_stop_num' => $data_total['seven_day_stop_num_total'],
            'seven_day_retain' => '100',
            'fourteen_day_stop_num' => $data_total['fourteen_day_stop_num_total'],
            'fourteen_day_retain' => '100'
        ];

        $show = $Page->show();
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();

    }

    //等级关卡流失导出
    public function CheckpointLossExport(){
        ini_set('memory_limit','256M'); //临时提高内存
        
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $now_date = date('Y-m-d');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);
        $checkpoint_type = I('checkpoint_type', '1');

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'start_time' => $start_time,
            'end_time' => $end_time,
            'checkpoint_type' => $checkpoint_type
        ];
        //判断必要筛选条件是否选择了
        if(empty($start_time) || empty($end_time) || empty($checkpoint_type)){
            $list = [];
        }else{
            $where = '1 ';
            if(!empty($sid)){
                $where .= "and sid in($sid) ";
            }
            $where .= "and checkpoint_type=$checkpoint_type ";
            if(!empty($c_son_id)){
                $where .= "and c_son_id in($c_son_id) ";
            }
            $where .= "and unix_timestamp(date) >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
            $where .= "and unix_timestamp(date)<=" . strtotime(date('Y-m-d', strtotime($end_time))) . ' ';

            $list = $this->data_analysis_db->table('checkpoint_loss')
                ->field('
                    checkpoint_num,
                    sum(one_day_stop_num) as one_day_stop_num_total,
                    sum(three_day_stop_num) as three_day_stop_num_total,
                    sum(five_day_stop_num) as five_day_stop_num_total,
                    sum(seven_day_stop_num) as seven_day_stop_num_total,
                    sum(fourteen_day_stop_num) as fourteen_day_stop_num_total
                ')
                ->where($where)
                ->group('checkpoint_num')
                ->select();
            //获取创角数（以第一层的创角数为准）
            $create_role_num_totals = $this->data_analysis_db->table('checkpoint_loss')
                ->where($where . "and checkpoint_num=1")
                ->sum("create_role_num");
            if(empty($create_role_num_totals)){
                $create_role_num_totals = 0;
            }
            foreach($list as &$list_val){
                $list_val = [
                    'checkpoint_num' => $list_val['checkpoint_num'],
                    'create_role_num' => $create_role_num_totals,
                    'one_day_stop_num' => $list_val['one_day_stop_num_total'],
                    'one_day_retain' => getDivision($list_val['one_day_stop_num_total'], $create_role_num_totals),
                    'three_day_stop_num' => $list_val['three_day_stop_num_total'],
                    'three_day_retain' => getDivision($list_val['three_day_stop_num_total'], $create_role_num_totals),
                    'five_day_stop_num' => $list_val['five_day_stop_num_total'],
                    'five_day_retain' => getDivision($list_val['five_day_stop_num_total'], $create_role_num_totals),
                    'seven_day_stop_num' => $list_val['seven_day_stop_num_total'],
                    'seven_day_retain' => getDivision($list_val['seven_day_stop_num_total'], $create_role_num_totals),
                    'fourteen_day_stop_num' => $list_val['fourteen_day_stop_num_total'],
                    'fourteen_day_retain' => getDivision($list_val['fourteen_day_stop_num_total'], $create_role_num_totals),
                ];
            }

            //计算汇总数据
            $data_total = $this->data_analysis_db->table('checkpoint_loss')
                ->field('
                    sum(one_day_stop_num) as one_day_stop_num_total,
                    sum(three_day_stop_num) as three_day_stop_num_total,
                    sum(five_day_stop_num) as five_day_stop_num_total,
                    sum(seven_day_stop_num) as seven_day_stop_num_total,
                    sum(fourteen_day_stop_num) as fourteen_day_stop_num_total
                ')
                ->where($where)
                ->find();

            $list[] = [
                'checkpoint_num' => '汇总',
                'create_role_num' => $create_role_num_totals,
                'one_day_stop_num' => $data_total['one_day_stop_num_total'],
                'one_day_retain' => '100',
                'three_day_stop_num' => $data_total['three_day_stop_num_total'],
                'three_day_retain' => '100',
                'five_day_stop_num' => $data_total['five_day_stop_num_total'],
                'five_day_retain' => '100',
                'seven_day_stop_num' => $data_total['seven_day_stop_num_total'],
                'seven_day_retain' => '100',
                'fourteen_day_stop_num' => $data_total['fourteen_day_stop_num_total'],
                'fourteen_day_retain' => '100'
            ];
        }

        vendor('PHPExcel.PHPExcel');
        vendor('PHPExcel.PHPExcel.Writer.Excel5');
        Vendor("PHPExcel.PHPExcel.IOFactory");
        $excel = new \PHPExcel();
        //Excel表格式,这里简略写了8列
        $letter = array('A','B','C','D','E','F','G','H','I','J','K','L');
        //表头数组
        $tableheader = array('等级','创角数','次日停留人数','次日停留占比','3日停留人数','3日停留占比','5日停留人数','5日停留占比','7日停留人数','7日停留占比','14日停留人数','14日停留占比');
        //填充表头信息
        for($i = 0;$i < count($tableheader);$i++) {
            $excel->getActiveSheet()->setCellValue("$letter[$i]1","$tableheader[$i]");
        }
        $excel->getActiveSheet()->getDefaultColumnDimension()->setWidth(20);//所有单元格（列）默认宽度
        //填充表格信息
        for ($i = 2;$i <= count($list) + 1;$i++) {
            $excel->getActiveSheet()->setCellValue("A$i", $list[$i - 2]['checkpoint_num']);
            $excel->getActiveSheet()->setCellValue("B$i", $list[$i - 2]['create_role_num']);
            $excel->getActiveSheet()->setCellValue("C$i", $list[$i - 2]['one_day_stop_num']);
            $excel->getActiveSheet()->setCellValue("D$i", $list[$i - 2]['one_day_retain']);
            $excel->getActiveSheet()->setCellValue("E$i", $list[$i - 2]['three_day_stop_num']);
            $excel->getActiveSheet()->setCellValue("F$i", $list[$i - 2]['three_day_retain']);
            $excel->getActiveSheet()->setCellValue("G$i", $list[$i - 2]['five_day_stop_num']);
            $excel->getActiveSheet()->setCellValue("H$i", $list[$i - 2]['five_day_retain']);
            $excel->getActiveSheet()->setCellValue("I$i", $list[$i - 2]['seven_day_stop_num']);
            $excel->getActiveSheet()->setCellValue("J$i", $list[$i - 2]['seven_day_retain']);
            $excel->getActiveSheet()->setCellValue("K$i", $list[$i - 2]['fourteen_day_stop_num']);
            $excel->getActiveSheet()->setCellValue("L$i", $list[$i - 2]['fourteen_day_retain']);
        }

        //创建Excel输入对象
        ob_clean();
        $write = new \PHPExcel_Writer_Excel5($excel);
        header("Pragma: public");
        header("Expires: 0");
        $filename="checkpoint_loss.xls";
        header("Content-Disposition: attachment;filename=$filename");
        header("Cache-Control:must-revalidate, post-check=0, pre-check=0");
        header("Content-Type:application/force-download");
        header("Content-Type:application/vnd.ms-execl");
        header("Content-Type:application/octet-stream");
        header("Content-Type:application/download");
        header("Content-Transfer-Encoding:binary");
        $write->save('php://output');
    }

    /*充值区间留存*/
    public function RetainRechargeInterval(){
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
        $today_date = I('today_date', date('Y-m-d'));    //日期

        $where = "1 ";
        if(!empty($sid)){
            $where .= "and sid in($sid) ";
        }
        if(!empty($c_son_id)){
            $where .= "and c_son_id in($c_son_id) ";
        }
        if(!empty($today_date)){
            $where .= "and unix_timestamp(date) =" . strtotime(date('Y-m-d', strtotime($today_date))) . ' ';
        }

        $counts = $this->data_analysis_db->table('retain_recharge_interval')
            ->field('id')
            ->group('retain_type')
            ->where($where)
            ->select();
        $count = count($counts);
        $Page  = new \Think\Page($count,50);
        $list = $this->data_analysis_db->table('retain_recharge_interval')
            ->field('
                retain_type,
                sum(num) as num_total,
                sum(one_day_num) as one_day_num_total,
                sum(three_day_num) as three_day_num_total,
                sum(four_day_num) as four_day_num_total,
                sum(five_day_num) as five_day_num_total,
                sum(six_day_num) as six_day_num_total,
                sum(seven_day_num) as seven_day_num_total,
                sum(ten_day_num) as ten_day_num_total,
                sum(fourteen_day_num) as fourteen_day_num_total,
                sum(twenty_one_day_num) as twenty_one_day_num_total,
                sum(thirty_day_num) as thirty_day_num_total,
                sum(sixty_day_num) as sixty_day_num_total,
                sum(ninety_day_num) as ninety_day_num_total
            ')
            ->where($where)
            ->group('retain_type')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        foreach($list as &$list_val){
            
            $list_val = [
                'retain_type' => $list_val['retain_type'],
                'num' => $list_val['num_total'],
                'one_day_retain' => getDivision($list_val['one_day_num_total'], $list_val['num_total']),
                'three_day_retain' => getDivision($list_val['three_day_num_total'], $list_val['num_total']),
                'four_day_retain' => getDivision($list_val['four_day_num_total'], $list_val['num_total']),
                'five_day_retain' => getDivision($list_val['five_day_num_total'], $list_val['num_total']),
                'six_day_retain' => getDivision($list_val['six_day_num_total'], $list_val['num_total']),
                'seven_day_retain' => getDivision($list_val['seven_day_num_total'], $list_val['num_total']),
                'ten_day_retain' => getDivision($list_val['ten_day_num_total'], $list_val['num_total']),
                'fourteen_day_retain' => getDivision($list_val['fourteen_day_num_total'], $list_val['num_total']),
                'twenty_one_day_retain' => getDivision($list_val['twenty_one_day_num_total'], $list_val['num_total']),
                'thirty_day_retain' => getDivision($list_val['thirty_day_num_total'], $list_val['num_total']),
                'sixty_day_retain' => getDivision($list_val['sixty_day_num_total'], $list_val['num_total']),
                'ninety_day_retain' => getDivision($list_val['ninety_day_num_total'], $list_val['num_total']),
            ];
        }

        //计算汇总数据
        $data_total = $this->data_analysis_db->table('retain_recharge_interval')
            ->field('
                sum(num) as num_total,
                sum(one_day_num) as one_day_num_total,
                sum(three_day_num) as three_day_num_total,
                sum(four_day_num) as four_day_num_total,
                sum(five_day_num) as five_day_num_total,
                sum(six_day_num) as six_day_num_total,
                sum(seven_day_num) as seven_day_num_total,
                sum(ten_day_num) as ten_day_num_total,
                sum(fourteen_day_num) as fourteen_day_num_total,
                sum(twenty_one_day_num) as twenty_one_day_num_total,
                sum(thirty_day_num) as thirty_day_num_total,
                sum(sixty_day_num) as sixty_day_num_total,
                sum(ninety_day_num) as ninety_day_num_total
            ')
            ->where($where)
            ->find();
        
        $list[] = [
            'retain_type' => '0',
            'num' => $data_total['num_total'],
            'one_day_retain' => getDivision($data_total['one_day_num_total'], $data_total['num_total']),
            'three_day_retain' => getDivision($data_total['three_day_num_total'], $data_total['num_total']),
            'four_day_retain' => getDivision($data_total['four_day_num_total'], $data_total['num_total']),
            'five_day_retain' => getDivision($data_total['five_day_num_total'], $data_total['num_total']),
            'six_day_retain' => getDivision($data_total['six_day_num_total'], $data_total['num_total']),
            'seven_day_retain' => getDivision($data_total['seven_day_num_total'], $data_total['num_total']),
            'ten_day_retain' => getDivision($data_total['ten_day_num_total'], $data_total['num_total']),
            'fourteen_day_retain' => getDivision($data_total['fourteen_day_num_total'], $data_total['num_total']),
            'twenty_one_day_retain' => getDivision($data_total['twenty_one_day_num_total'], $data_total['num_total']),
            'thirty_day_retain' => getDivision($data_total['thirty_day_num_total'], $data_total['num_total']),
            'sixty_day_retain' => getDivision($data_total['sixty_day_num_total'], $data_total['num_total']),
            'ninety_day_retain' => getDivision($data_total['ninety_day_num_total'], $data_total['num_total']),
        ];

        $show = $Page->show();
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'today_date' => $today_date,
        ];
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }
    /*充值区间继续充值*/
    public function RechargeIntervalAgain(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();
        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $today_date = I('today_date', date('Y-m-d'));    //日期

        $where = "1 ";
        if(!empty($sid)){
            $where .= "and sid in($sid) ";
        }
        if(!empty($c_son_id)){
            $where .= "and c_son_id in($c_son_id) ";
        }
        if(!empty($today_date)){
            $where .= "and unix_timestamp(date) =" . strtotime(date('Y-m-d', strtotime($today_date))) . ' ';
        }

        $counts = $this->data_analysis_db->table('retain_recharge_interval')
            ->field('id')
            ->group('retain_type')
            ->where($where)
            ->select();
        $count = count($counts);
        $Page  = new \Think\Page($count,50);
        $list = $this->data_analysis_db->table('retain_recharge_interval')
            ->field('
                retain_type,
                sum(num) as num_total,
                sum(one_day_money) as one_day_money_total,
                sum(three_day_money) as three_day_money_total,
                sum(four_day_money) as four_day_money_total,
                sum(five_day_money) as five_day_money_total,
                sum(six_day_money) as six_day_money_total,
                sum(seven_day_money) as seven_day_money_total,
                sum(ten_day_money) as ten_day_money_total,
                sum(fourteen_day_money) as fourteen_day_money_total,
                sum(twenty_one_day_money) as twenty_one_day_money_total,
                sum(thirty_day_money) as thirty_day_money_total,
                sum(sixty_day_money) as sixty_day_money_total,
                sum(ninety_day_money) as ninety_day_money_total
            ')
            ->where($where)
            ->group('retain_type')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        foreach($list as &$list_val){
            $list_val = [
                'retain_type' => $list_val['retain_type'],
                'num' => $list_val['num_total'],
                'one_day_money' => $list_val['one_day_money_total'],
                'three_day_money' => $list_val['three_day_money_total'],
                'four_day_money' => $list_val['four_day_money_total'],
                'five_day_money' => $list_val['five_day_money_total'],
                'six_day_money' => $list_val['six_day_money_total'],
                'seven_day_money' => $list_val['seven_day_money_total'],
                'ten_day_money' => $list_val['ten_day_money_total'],
                'fourteen_day_money' => $list_val['fourteen_day_money_total'],
                'twenty_one_day_money' => $list_val['twenty_one_day_money_total'],
                'thirty_day_money' => $list_val['thirty_day_money_total'],
                'sixty_day_money' => $list_val['sixty_day_money_total'],
                'ninety_day_money' => $list_val['ninety_day_money_total'],
            ];
        }

        //计算汇总数据
        $data_total = $this->data_analysis_db->table('retain_recharge_interval')
            ->field('
                sum(num) as num_total,
                sum(one_day_money) as one_day_money_total,
                sum(three_day_money) as three_day_money_total,
                sum(four_day_money) as four_day_money_total,
                sum(five_day_money) as five_day_money_total,
                sum(six_day_money) as six_day_money_total,
                sum(seven_day_money) as seven_day_money_total,
                sum(ten_day_money) as ten_day_money_total,
                sum(fourteen_day_money) as fourteen_day_money_total,
                sum(twenty_one_day_money) as twenty_one_day_money_total,
                sum(thirty_day_money) as thirty_day_money_total,
                sum(sixty_day_money) as sixty_day_money_total,
                sum(ninety_day_money) as ninety_day_money_total
            ')
            ->where($where)
            ->find();
        
        $list[] = [
            'retain_type' => '0',
            'num' => $data_total['num_total'],
            'one_day_money' => $data_total['one_day_money_total'],
            'three_day_money' => $data_total['three_day_money_total'],
            'four_day_money' => $data_total['four_day_money_total'],
            'five_day_money' => $data_total['five_day_money_total'],
            'six_day_money' => $data_total['six_day_money_total'],
            'seven_day_money' => $data_total['seven_day_money_total'],
            'ten_day_money' => $data_total['ten_day_money_total'],
            'fourteen_day_money' => $data_total['fourteen_day_money_total'],
            'twenty_one_day_money' => $data_total['twenty_one_day_money_total'],
            'thirty_day_money' => $data_total['thirty_day_money_total'],
            'sixty_day_money' => $data_total['sixty_day_money_total'],
            'ninety_day_money' => $data_total['ninety_day_money_total'],
        ];

        $show = $Page->show();
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'today_date' => $today_date,
        ];
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*在线时长统计*/
    public function OnlineLength(){
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
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', date('Y-m-d'));
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'start_time' => $start_time,
            'end_time' => $end_time
        ];

        $data_x = [];
        $data_series = [];
        $data_legend = [];
        
        $where = '1 ';
        if(!empty($sid)){
            $where .= "and sid in($sid) ";
        }
        if(!empty($c_son_id)){
            $where .= "and c_son_id in($c_son_id) ";
        }

        $where .= "and unix_timestamp(date) >=" . strtotime($start_time) . ' ';
        $where .= "and unix_timestamp(date) <=" . strtotime($end_time) . ' ';

        $count = $this->data_analysis_db->table('online_length_day')
            ->where($where)
            ->count("distinct date");
        $Page  = new \Think\Page($count,50);
        $list = $this->data_analysis_db->table('online_length_day')
            ->field("
                date,
                sum(login_role) as login_role_total,
                sum(login_num) as login_num_total,
                sum(one_num) as one_num_total,
                sum(two_num) as two_num_total,
                sum(three_num) as three_num_total,
                sum(four_num) as four_num_total,
                sum(five_num) as five_num_total,
                sum(six_num) as six_num_total,
                sum(seven_num) as seven_num_total,
                sum(eight_num) as eight_num_total,
                sum(nine_num) as nine_num_total,
                sum(ten_num) as ten_num_total,
                sum(eleven_num) as eleven_num_total,
                sum(twelve_num) as twelve_num_total,
                sum(thirteen_num) as thirteen_num_total,
                sum(fourteen_num) as fourteen_num_total,
                sum(fifteen_num) as fifteen_num_total
            ")
            ->where($where)
            ->group('date')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        $data_x = [
            '0~10s','10~30s','30~60s','1~3m','3~5m','5~10m','10~20m','20~30m','30~60m','60~90m','90~120m','120~180m','180~240m','240~300m','300+m'
        ];
        foreach($list as $list_val){
            $data_legend[] = $list_val['date'];
            $data_series[] = [
                'name' => $list_val['date'],
                'type' => 'line',
                'data' => [
                    $list_val['one_num_total'],$list_val['two_num_total'],$list_val['three_num_total'],$list_val['four_num_total'],$list_val['five_num_total'],
                    $list_val['six_num_total'],$list_val['seven_num_total'],$list_val['eight_num_total'],$list_val['nine_num_total'],$list_val['ten_num_total'],
                    $list_val['eleven_num_total'],$list_val['twelve_num_total'],$list_val['thirteen_num_total'],$list_val['fourteen_num_total'],$list_val['fifteen_num_total'],
                ]
            ];
        }
        
        $show = $Page->show();
        $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'data_legend'=> json_encode($data_legend), 'list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /**
     * 实时等级/VIP分布
     */
    public function RealLevelVip(){

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();
        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $type = I('type', '1'); //统计内容：1.角色等级，2.VIP等级

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'type' => $type,
        ];
        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $game_data_db = connectionDb($server_info, 'data');     //连接游戏数据库

        $where = '1 ';
        if(!empty($c_son_id)){
            $where .= "and role.place in($c_son_id) ";
        }
        if($type == 1){
            $field = 'level';
        }else{
            $field = 'goddess_vip';
        }
        $list = $game_data_db->table('role')
            ->field("
                sum(rc.total_recharge) as total_money,count(role.id) as total_role_num,role." . $field . " as role_level
            ")
            ->join("LEFT JOIN role_charge as rc on rc.rid=role.id")
            ->where($where)
            ->group("role." . $field)
            ->select();
        
        //查询总数
        $total_data = $game_data_db->table('role')
            ->field("
                sum(rc.total_recharge) as total_money,count(role.id) as total_role_num
            ")
            ->join("LEFT JOIN role_charge as rc on rc.rid=role.id")
            ->where($where)
            ->find();
        $total_data['total_money'] = !empty($total_data['total_money']) ? $total_data['total_money']/100 : '0.00';
        
        foreach($list as &$list_val){
            $list_val['total_role_num_retain'] = getDivision($list_val['total_role_num'], $total_data['total_role_num']);
            $list_val['total_money'] = !empty($list_val['total_money']) ? $list_val['total_money']/100 : '0.00';
            $list_val['total_money_retain'] = getDivision($list_val['total_money'], $total_data['total_money']);
        }
        $list[] = [
            'role_level' => '汇总',
            'total_role_num' => $total_data['total_role_num'],
            'total_role_num_retain' => 100,
            'total_money' => $total_data['total_money'],
            'total_money_retain' => 100,

        ];

        $this->assign(['list'=>$list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    
    }

    /*每日活跃*/
    public function DauDay(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

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
                sum(login_num) as login_num_total,
                sum(month_login_num) as month_login_num_total,
                sum(login_times) as login_times_total
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
                'role_num' => $list_val['role_num_total'],      //新增活跃
                'login_num' => $list_val['login_num_total'],    //总活跃（DAU）
                'old_login_num' => $list_val['login_num_total'] - $list_val['role_num_total'],  //老活跃
                'month_login_num' => $list_val['month_login_num_total'],    //月活跃
                'dau_mau' => getDivisionSpecial($list_val['login_num_total'], $list_val['month_login_num']),   //dau/mau
                'add_dau_rate' => getDivision($list_val['role_num_total'], $list_val['login_num_total']) . '%',        //新增活跃比（新增活跃/dau）
                'login_times' => $list_val['login_times_total'],    //登陆次数
                'login_times_avg' => getDivisionSpecial($list_val['login_times_total'], $list_val['login_num_total']),    //人均登陆次数
            ];
        }

        //计算汇总数据
        $data_total = $this->data_analysis_db->table('overview_day')
            ->field('
                sum(role_num) as role_num_total,
                sum(login_num) as login_num_total,
                sum(month_login_num) as month_login_num_total,
                sum(login_times) as login_times_total
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
            'role_num' => $data_total['role_num_total'],      //新增活跃
            'login_num' => $data_total['login_num_total'],    //总活跃（DAU）
            'old_login_num' => $data_total['login_num_total'] - $data_total['role_num_total'],  //老活跃
            'month_login_num' => $data_total['month_login_num_total'],    //月活跃
            'dau_mau' => getDivisionSpecial($data_total['login_num_total'], $data_total['month_login_num']),   //dau/mau
            'add_dau_rate' => getDivision($data_total['role_num_total'], $data_total['login_num_total']) . '%',        //新增活跃比（新增活跃/dau）
            'login_times' => $data_total['login_times_total'],    //登陆次数
            'login_times_avg' => getDivisionSpecial($data_total['login_times_total'], $data_total['login_num_total']),    //人均登陆次数
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
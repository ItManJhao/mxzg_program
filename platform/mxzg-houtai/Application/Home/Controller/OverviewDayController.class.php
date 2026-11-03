<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 每日总览
 */
class OverviewDayController extends PublicController{
    protected $game_log_db;

    /**
     * 查询要处理的数据入口
     */
    public function entry(){
        $this->date = $this->ovday_date;
        $this->start_time = strtotime($this->date);  //开始时间戳
        $this->end_time = $this->start_time + 86399;    //结束时间戳

        //查询所有渠道
        $channels = $this->platform_db->table('channel')
            ->where($this->channel_where)
            ->select();
        //查询所有服务器
        $servers = $this->platform_db->table('server')
            ->where($this->server_where)
            ->order('id desc')
            ->select();

        //处理日常数据
        foreach($channels as $channel_val){
            //获取注册数
            $register_num = $this->platform_db->table('user')
            ->where("c_son_id=" . $channel_val['id'] . " and created_at>=$this->start_time and created_at<=$this->end_time ")
            ->count();
            foreach($servers as $server_val){
                if($this->start_time >= strtotime(date('Y-m-d', $server_val['open_time']))){
                    //获取每日基本数据，并保存数据
                    $day_data_res =  $this->day_data($server_val, $channel_val['id'], $channel_val['parent_id'], $register_num);
                    var_dump($day_data_res);
                    echo PHP_EOL;
                    //处理留存
                    $retain_data = $this->doRetain($server_val, $channel_val['id']);
                    var_dump($retain_data);
                    echo PHP_EOL;
                }

            }
        }

    }

    /**
     * @desc 查询当天的日常数据
     * @param $server_val array 服务器详情
     * @param $register_num string 注册数
     * @param $start_time int 开始时间戳
     * @param  $end_time int 结束时间戳
     */
    public function day_data($server_val, $channel_id, $parent_channel_id, $register_num){
        $sid = $server_val['id'];
        $start_time = $this->start_time;
        $end_time = $this->end_time;
        $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库

        //获取创角数
        $role_ids = $this->game_log_db->table('role_create_log')
            ->where("place=$channel_id and create_time>=$start_time and create_time<=$end_time ")
            ->getField('rid',true);
        $role_num = count($role_ids);
        // if(!empty($role_ids)){
        //     $role_ids = implode(',', $role_ids);
        // }else{
        //     $role_ids = '';
        // }

        //获取创角设备数
        $device_num = $this->game_log_db->table('role_create_log')
            ->where("place=$channel_id and create_time>=$start_time and create_time<=$end_time ")
            ->count('distinct device_id');

        //创角转化率，创角数/注册数
        $add_role_rate = getDivision($role_num, $register_num);

        //获取总登陆人次
        $table = 'role_login_log' . getLogTable('month', $this->date);
        $login_num = $this->game_log_db->table($table)
            ->field('id')
            ->where("place=$channel_id and login_time>=$start_time and login_time<=$end_time ")
            ->count("distinct rid");

        //当月总登陆人次（月活跃人数）
        $table = 'role_login_log' . getLogTable('month', $this->date);
        $month_start_time = mktime(0,0,0,date('m', $start_time),1,date('Y', $start_time));
        $month_end_time = mktime(23,59,59,date('m', $start_time),date('t', $start_time),date('Y', $start_time));
        $month_login_num = $this->game_log_db->table($table)
            ->field('id')
            ->where("place=$channel_id and login_time>=$month_start_time and login_time<=$month_end_time ")
            ->count("distinct rid");

        //获取总登陆次数
        $table = 'role_login_log' . getLogTable('month', $this->date);
        $login_times = $this->game_log_db->table($table)
            ->field('id')
            ->where("place=$channel_id and login_time>=$start_time and login_time<=$end_time ")
            ->count();

        //查询总付费人次
        $pay_num_data = $this->platform_db->table('recharge')
            ->field('recharge.id')
            ->join("left join user_server as us on us.role_id=recharge.role_id")
            ->where("us.c_son_id=$channel_id and recharge.sid=" . $sid . " and recharge.status=3 and recharge.updated_at>=$start_time and recharge.updated_at<=$end_time ")
            ->group('recharge.role_id')
            ->select();
        $pay_num = count($pay_num_data);

        //查询总付费
        $pay_money = $this->platform_db->table('recharge')
            ->join("left join user_server as us on us.role_id=recharge.role_id")
            ->where("us.c_son_id=$channel_id and recharge.sid=" . $sid . " and recharge.status=3 and recharge.updated_at>=$start_time and recharge.updated_at<=$end_time ")
            ->sum('recharge.money');
        if(empty($pay_money)){
            $pay_money = 0.00;
        }
        //计算arppu--总付费/总付费人数
        $arppu = getDivisionSpecial($pay_money, $pay_num);

        //计算活跃arpu--总付费/总登陆人数
        $arpu = getDivisionSpecial($pay_money, $login_num);

        //计算总付费率--总付费人数/总登陆人数
        $rate = getDivision($pay_num, $login_num);

        //新增付费人次
        $add_pay_num_data = $this->platform_db->table('recharge')
            ->field('id')
            ->where("sid=" . $sid . " and status=3 and updated_at>=$start_time and updated_at<=$end_time 
                    and role_id in (
                    select role_id from user_server as us
                    where us.c_son_id=$channel_id and us.sid=" . $sid . " and us.created_at>=$start_time and us.created_at<=$end_time 
                    )
                    ")
            ->group('role_id')
            ->select();

        $add_pay_num = count($add_pay_num_data);

        //新增付费
        $add_pay_money = $this->platform_db->table('recharge')
            ->where("sid=" . $sid . " and status=3 and updated_at>=$start_time and updated_at<=$end_time 
                    and role_id in (
                    select role_id from user_server as us
                    where us.c_son_id=$channel_id and us.sid=" . $sid . " and us.created_at>=$start_time and us.created_at<=$end_time 
                    )
                    ")
            ->sum('money');
        if(empty($add_pay_money)){
            $add_pay_money = 0.00;
        }
        //计算新增arppu--新增付费/新增付费人数
        $add_arppu = getDivisionSpecial($add_pay_money, $add_pay_num);

        //计算新增活跃arpu--新增付费/新增登陆人数（创角数）
        $add_arpu = getDivisionSpecial($add_pay_money, $role_num);

        //计算总付费率--新增付费人数/新增登陆人数（创角数）
        $add_rate = getDivision($add_pay_num, $role_num);

        //计算老用户充值
        $old_pay_money = $pay_money - $add_pay_money;

        $data_analysis_info = $this->data_analysis_db->table('overview_day')
            ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}'")
            ->find();

        //计算最高在线数
        $table = 'online_num_log' . getLogTable('month', $this->date);
        $highest_online_num = $this->game_log_db->table($table)
            ->where("place=$channel_id and record_time>=$start_time and record_time<=$end_time ")
            ->max('online_num');
        if(empty($highest_online_num)){
            $highest_online_num = 0;
        }

        //计算平均在线数
        $table = 'online_num_log' . getLogTable('month', $this->date);
        $average_online_num = $this->game_log_db->table($table)
            ->where("place=$channel_id and record_time>=$start_time and record_time<=$end_time ")
            ->avg('online_num');
        if(empty($average_online_num)){
            $average_online_num = 0;
        }else{
            $average_online_num = round($average_online_num);
        }
        
        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'register_num' => $register_num,
            'role_num' => $role_num,
            'month_login_num' => $month_login_num,
            'login_times' => $login_times,
            'device_num' => $device_num,
            'role_ids' => '',
            'add_role_rate' => $add_role_rate,
            'login_num' => $login_num,
            'pay_num' => $pay_num,
            'pay_money' => $pay_money,
            'arppu' => $arppu,
            'arpu' => $arpu,
            'rate' => $rate,
            'add_pay_num' => $add_pay_num,
            'add_pay_money' => $add_pay_money,
            'add_arppu' => $add_arppu,
            'add_arpu' => $add_arpu,
            'add_rate' => $add_rate,
            'old_pay_money' => $old_pay_money,
            'highest_online_num' => $highest_online_num,
            'average_online_num' => $average_online_num,
            'date' => $this->date,
            'updated_at' => time()
        ];
        if($data_analysis_info){    //修改
            $res = $this->data_analysis_db->table('overview_day')->where("id=" . $data_analysis_info['id'])->save($day_data);
        }else{                      //添加
            $day_data['created_at'] = time();
            $res = $this->data_analysis_db->table('overview_day')->add($day_data);
        }

        return $res;
    }

    /**
     * @desc 查询当日对应的留存
     * @param $server_val
     */
    protected function doRetain($server_val, $channel_id){
        $sid = $server_val['id'];
        $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库

        //处理当天的昨日的次日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 1, 'one_day_num');
        echo $sid . '次日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第三天的3日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 2, 'three_day_num');
        echo $sid . '3日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第4天的4日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 3, 'four_day_num');
        echo $sid . '4日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第5天的5日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 4, 'five_day_num');
        echo $sid . '5日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第6天的6日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 5, 'six_day_num');
        echo $sid . '6日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第7天的7日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 6, 'seven_day_num');
        echo $sid . '7日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第14天的14日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 13, 'fourteen_day_num');
        echo $sid . '14日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第30天的30日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 29, 'thirty_day_num');
        echo $sid . '30日留存---' . $channel_id . $retain_res . PHP_EOL;

        return 'Retain--ok';
    }

    protected function getRetain($sid, $channel_id, $game_log_db, $days, $update_field){
        //查询当天的昨日的数据
        $one_day_date = date('Y-m-d', strtotime($this->date) - $days * 86400);   //
        $start_time = strtotime($one_day_date);  //开始时间戳
        $end_time = $start_time + 86399;    //结束时间戳
        $one_day_data_analysis = $this->data_analysis_db->table('overview_day')
            ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}'")
            ->find();
        $up_res = -1;
        if($one_day_data_analysis){     //数据存在，计算次日留存

            if(!empty($one_day_data_analysis['device_num'])){

                $table = 'role_login_log' . getLogTable('month', $this->date);
                //获取创角的登录数
                $one_day_num = $this->game_log_db->table('role_create_log')
                    ->alias('rcl')
                    ->join("left join $table as aa on aa.rid=rcl.rid")
                    ->where("rcl.place=$channel_id and rcl.create_time>=$start_time and rcl.create_time<=$end_time
                        and aa.place=$channel_id and aa.login_time>=$this->start_time and aa.login_time<=$this->end_time ")
                    ->count('distinct rcl.rid');
                    
            }else{
                $one_day_num = '0';   //当天的昨天的次日留存
            }

            //修改数据
            $data_update = [
                $update_field => $one_day_num,
                'updated_at' => time()
            ];
            $up_res = $this->data_analysis_db->table('overview_day')
                ->where("id=" . $one_day_data_analysis['id'])
                ->save($data_update);
        }
        return $up_res;
    }

}
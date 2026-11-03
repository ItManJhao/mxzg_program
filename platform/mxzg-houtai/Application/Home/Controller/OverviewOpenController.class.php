<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 开服当天数据
 */
class OverviewOpenController extends PublicController{
    protected $game_log_db;

    /**
     * 查询要处理的数据入口
     */
    public function entry(){

        //查询所有渠道
        $channels = $this->platform_db->table('channel')
            ->where($this->channel_where)
            ->select();
        //查询当天开服的服务器
        $today_start = strtotime($this->today_date);  //开始时间戳
        $end_time = $today_start + 86399;    //结束时间戳
        $servers = $this->platform_db->table('server')
            ->where("open_time>=$today_start and open_time<=$end_time")
            ->select();

        if(!$servers){
            echo 'no data ~~~';
            exit;
        }

        //处理日常数据
        $hour_start = strtotime($this->today_date) + ($this->today_hour-1) * 3600;
        $hour_end = $hour_start + 3599;
        foreach($channels as $channel_val){
            //获取注册数
            $register_num = $this->platform_db->table('user')
            ->where("c_son_id=" . $channel_val['id'] . " and created_at>=$hour_start and created_at<=$hour_end ")
            ->count();
            foreach($servers as $server_val){
                //判断时间是否在开服时间之后
                if($hour_end>$server_val['open_time']){
                    //获取基本数据，并保存数据
                    $day_data_res =  $this->day_data($server_val, $channel_val['id'], $channel_val['parent_id'], $register_num, $hour_start, $hour_end);
                    var_dump($day_data_res);
                    echo PHP_EOL;
                }else{
                    echo 'no time ~~~';
                }
            }
        }

    }

    /**
     * @desc 查询一个小时的基础数据并入库
     * @param $server_val array 服务器详情
     * @param $register_num string 注册数
     * @param $start_time int 开始时间戳
     * @param  $end_time int 结束时间戳
     */
    public function day_data($server_val, $channel_id, $parent_channel_id, $register_num, $start_time, $end_time){
        $sid = $server_val['id'];
        $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库

        //获取创角数
//        $role_num = $this->platform_db->table('user_server')
//            ->alias('us')
//            ->join("left join user on user.id=us.user_id")
//            ->where("user.c_son_id=$channel_id and us.sid=" . $sid . " and us.created_at>=$start_time and us.created_at<=$end_time ")
//            ->count();
        $role_num = $this->game_log_db->table('role_create_log')
            ->where("place=$channel_id and create_time>=$start_time and create_time<=$end_time")
            ->count();

        //创角转化率，创角数/注册数
        $add_role_rate = getDivision($role_num, $register_num);

        //获取登陆人次
        $table = 'role_login_log' . getLogTable('month', $this->today_date);
        $login_data = $this->game_log_db->table($table)
            ->field('id')
            ->where("place=$channel_id and login_time>=$start_time and login_time<=$end_time ")
            ->group('rid')
            ->select();
//        var_dump($this->game_log_db->getLastSql());exit;
        $login_num = count($login_data);

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

        $overview_open_info = $this->data_analysis_db->table('overview_open')
            ->where("c_son_id=$channel_id and sid=$sid and date='{$this->today_date}' and time='{$this->today_hour}'")
            ->find();

        //计算最高在线数
        $table = 'online_num_log' . getLogTable('month', $this->today_date);
        $highest_online_num = $this->game_log_db->table($table)
            ->where("place=$channel_id and record_time>=$start_time and record_time<=$end_time ")
            ->max('online_num');
        if(empty($highest_online_num)){
            $highest_online_num = 0;
        }

        $open_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'register_num' => $register_num,
            'role_num' => $role_num,
            'add_role_rate' => $add_role_rate,
            'login_num' => $login_num,
            'pay_num' => $pay_num,
            'pay_money' => $pay_money,
            'arppu' => $arppu,
            'arpu' => $arpu,
            'rate' => $rate,
            'highest_online_num' => $highest_online_num,
            'date' => $this->today_date,
            'time' => $this->today_hour,
            'updated_at' => time()
        ];
        if($overview_open_info){    //修改
            $res = $this->data_analysis_db->table('overview_open')->where("id=" . $overview_open_info['id'])->save($open_data);
        }else{                      //添加
            $open_data['created_at'] = time();
            $res = $this->data_analysis_db->table('overview_open')->add($open_data);
        }

        return $res;
    }


}
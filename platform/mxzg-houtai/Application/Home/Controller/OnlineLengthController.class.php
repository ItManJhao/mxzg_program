<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 在线时长
 */
class OnlineLengthController extends PublicController{
    protected $game_data_db;

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
            
            foreach($servers as $server_val){
                if($this->start_time >= strtotime(date('Y-m-d', $server_val['open_time']))){
                    echo '渠道--' . $channel_val['name'] . '，区服--' . $server_val['server_name'] . '，在线时长开始处理';
                    echo PHP_EOL;
                    //获取每日基本数据，并保存数据
                    $day_data_res =  $this->day_data($server_val, $channel_val['id'], $channel_val['parent_id']);
                    var_dump($day_data_res);
                    echo PHP_EOL;
                }
            }
        }

    }

    /**
     * @desc 查询当天的日常数据
     * @param $server_val array 服务器详情
     * @param $channel_id array 子渠道id
     * @param $parent_channel_id array 父渠道id
     */
    public function day_data($server_val, $channel_id, $parent_channel_id){
        $sid = $server_val['id'];
        $start_time = $this->start_time;
        $end_time = $this->end_time;
        $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏数据库

        //1.查询登陆人数和登陆次数

        $table = 'role_login_log' . getLogTable('month', $this->date);
        $login_data = $this->game_log_db->table($table)
            ->field('count(distinct rid) as login_role,count(id) as login_num')
            ->where("place=$channel_id and login_time>=$start_time and login_time<=$end_time ")
            ->find();
        $login_role = $login_data['login_role'];    //登录人数
        $login_num = $login_data['login_num'];      //登录次数

        //2.查询每个段的在线人数

        $where = '1 ';
        $where .= "and place=$channel_id ";
        $where .= "and (logout_time-online_time)>=$start_time and (logout_time-online_time)<=$end_time ";
        $table = 'role_logout_log' . getLogTable('month', $this->date);
        $subQuery = $this->game_log_db->table($table)
            ->field('
                rid,sum(online_time) as online_times
            ')
            ->where($where)
            ->group('rid')
            ->buildSql();
        $online_length_data = $this->game_log_db->table($subQuery . ' tmp')
            ->field('
                sum(if(online_times<10,1,0)) as one_num,
                sum(if(online_times BETWEEN 11 and 30,1,0)) as two_num,
                sum(if(online_times BETWEEN 31 and 60,1,0)) as three_num,
                sum(if(online_times BETWEEN 61 and 180,1,0)) as four_num,
                sum(if(online_times BETWEEN 181 and 300,1,0)) as five_num,
                sum(if(online_times BETWEEN 301 and 600,1,0)) as six_num,
                sum(if(online_times BETWEEN 601 and 1200,1,0)) as seven_num,
                sum(if(online_times BETWEEN 1201 and 1800,1,0)) as eight_num,
                sum(if(online_times BETWEEN 1801 and 3600,1,0)) as nine_num,
                sum(if(online_times BETWEEN 3601 and 5400,1,0)) as ten_num,
                sum(if(online_times BETWEEN 5401 and 7200,1,0)) as eleven_num,
                sum(if(online_times BETWEEN 7201 and 10800,1,0)) as twelve_num,
                sum(if(online_times BETWEEN 10801 and 14400,1,0)) as thirteen_num,
                sum(if(online_times BETWEEN 14401 and 18000,1,0)) as fourteen_num,
                sum(if(online_times>=18001,1,0)) as fifteen_num
            ')
            ->find();
        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'date' => $this->date,
            'login_role' => $login_role,
            'login_num' => $login_num,
            'one_num' => !empty($online_length_data['one_num']) ? $online_length_data['one_num'] : 0,
            'two_num' => !empty($online_length_data['two_num']) ? $online_length_data['two_num'] : 0,
            'three_num' => !empty($online_length_data['three_num']) ? $online_length_data['three_num'] : 0,
            'four_num' => !empty($online_length_data['four_num']) ? $online_length_data['four_num'] : 0,
            'five_num' => !empty($online_length_data['five_num']) ? $online_length_data['five_num'] : 0,
            'six_num' => !empty($online_length_data['six_num']) ? $online_length_data['six_num'] : 0,
            'seven_num' => !empty($online_length_data['seven_num']) ? $online_length_data['seven_num'] : 0,
            'eight_num' => !empty($online_length_data['eight_num']) ? $online_length_data['eight_num'] : 0,
            'nine_num' => !empty($online_length_data['nine_num']) ? $online_length_data['nine_num'] : 0,
            'ten_num' => !empty($online_length_data['ten_num']) ? $online_length_data['ten_num'] : 0,
            'eleven_num' => !empty($online_length_data['eleven_num']) ? $online_length_data['eleven_num'] : 0,
            'twelve_num' => !empty($online_length_data['twelve_num']) ? $online_length_data['twelve_num'] : 0,
            'thirteen_num' => !empty($online_length_data['thirteen_num']) ? $online_length_data['thirteen_num'] : 0,
            'fourteen_num' => !empty($online_length_data['fourteen_num']) ? $online_length_data['fourteen_num'] : 0,
            'fifteen_num' => !empty($online_length_data['fifteen_num']) ? $online_length_data['fifteen_num'] : 0,
            'updated_at' => time()
        ];

        $day_info = $this->data_analysis_db->table('online_length_day')
            ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}'")
            ->find();
        if($day_info){    //修改
            $res = $this->data_analysis_db->table('online_length_day')->where("id=" . $day_info['id'])->save($day_data);
        }else{                      //添加
            $day_data['created_at'] = time();
            $res = $this->data_analysis_db->table('online_length_day')->add($day_data);
        }

        return 1;
    }


}
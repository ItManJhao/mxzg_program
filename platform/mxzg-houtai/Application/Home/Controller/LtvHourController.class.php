<?php
namespace Home\Controller;

use Think\Controller;

/*
 * Ltv小时统计
 */
class LtvHourController extends PublicController{
    protected $game_data_db;
    protected $field_arr = [
        '1' => 'one',
        '2' => 'two',
        '3' => 'three',
        '4' => 'four',
        '5' => 'five',
        '6' => 'six',
        '7' => 'seven',
        '8' => 'eight',
        '9' => 'nine',
        '10' => 'ten',
        '11' => 'eleven',
        '12' => 'twelve',
        '13' => 'thirteen',
        '14' => 'fourteen',
        '15' => 'fifteen',
        '16' => 'sixteen',
        '17' => 'seventeen',
        '18' => 'eighteen',
        '19' => 'nineteen',
        '20' => 'twenty',
        '21' => 'twenty_one',
        '22' => 'twenty_two',
        '23' => 'twenty_three',
        '24' => 'twenty_four',
    ];

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
                    echo '渠道--' . $channel_val['name'] . '，区服--' . $server_val['server_name'] . '，ltv小时统计开始处理';
                    echo PHP_EOL;
                    //获取每日基本数据，并保存数据
                    $day_data_res =  $this->day_data($server_val, $channel_val['id'], $channel_val['parent_id']);
                    var_dump($day_data_res);
                    echo PHP_EOL;
                    //处理充值留存
                    // $retain_data = $this->doRetain($server_val, $channel_val['id']);
                    // var_dump($retain_data);
                    // echo PHP_EOL;
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
        // $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库
        $this->game_data_db = connectionDb($server_val, 'data');     //连接游戏数据库

        //获取开服当天的创角
        $open_date = date('Y-m-d', $server_val['open_time']);
        $open_start_time_micro = strtotime($open_date) * 1000;
        $open_end_time_micro = $open_start_time_micro + 86399999;
        $role_ids = $this->game_data_db->table('role')
            ->where("place=$channel_id and create_time>=$open_start_time_micro and create_time<=$open_end_time_micro")
            ->getField('id',true);
        $create_role = count($role_ids);   //创角数
        if(!empty($role_ids)){
            $role_ids = implode(',', $role_ids);
        }else{
            $role_ids = '1';
        }
        
        //获取要查询的订单的时间范围
        $hour_start = strtotime($this->date) + ($this->ovday_hour-1) * 3600;
        $hour_end = $hour_start + 3599;
        // $role_ids = $this->game_data_db->table('recharge')
        //获取创角的登录数
        $money = $this->game_data_db->table('recharge')
            ->where("give_state=1 and time>=$this->start_time and time<=$hour_end and rid in($role_ids)")
            ->sum('pay_money');
        if(empty($money)){
            $money = '0.00';
        }
        $ltv_hour_info = $this->data_analysis_db->table('ltv_hour')
            ->where("c_son_id=$channel_id and sid=$sid and open_date='{$open_date}' and date='{$this->date}'")
            ->find();

        $day_after = (strtotime($this->date) - strtotime($open_date))/86400 + 1;
        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'open_date' => $open_date,
            'date' => $this->date,
            'day_after' => $day_after,
            'open_create_role' => $create_role,
            $this->field_arr[$this->ovday_hour] . '_day_money' => $money,
            'updated_at' => time()
        ];
        if($ltv_hour_info){    //修改
            $res = $this->data_analysis_db->table('ltv_hour')->where("id=" . $ltv_hour_info['id'])->save($day_data);
        }else{                      //添加
            $day_data['created_at'] = time();
            $res = $this->data_analysis_db->table('ltv_hour')->add($day_data);
        }

        return 1;
    }

}
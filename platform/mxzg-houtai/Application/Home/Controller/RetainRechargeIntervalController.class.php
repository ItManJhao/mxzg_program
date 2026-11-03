<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 充值区间留存
 */
class RetainRechargeIntervalController extends PublicController{
    protected $game_log_db;

    protected $retain_type_count = [
        '1' => [1,10],
        '2' => [11,30],
        '3' => [31,50],
        '4' => [51,100],
        '5' => [101,200],
        '6' => [201,500],
        '7' => [501,1000],
        '8' => [1001,2000],
        '9' => [2001,3000],
        '10' => [3001,5000],
        '11' => [5001,8000],
        '12' => [8001,10000],
        '13' => [10001,0],
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
                    echo '渠道--' . $channel_val['name'] . '，区服--' . $server_val['server_name'] . '，留存开始处理';
                    echo PHP_EOL;
                    //获取每日基本数据，并保存数据
                    $day_data_res =  $this->day_data($server_val, $channel_val['id'], $channel_val['parent_id']);
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
     * @param $channel_id array 子渠道id
     * @param $parent_channel_id array 父渠道id
     * @param $start_time int 开始时间戳
     * @param $end_time int 结束时间戳
     */
    public function day_data($server_val, $channel_id, $parent_channel_id){
        $sid = $server_val['id'];
        $start_time = $this->start_time;
        $end_time = $this->end_time;
        $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库

        //处理充值区间内的基本数据
        foreach($this->retain_type_count as $retain_type_key=>$retain_type_val){
            if($retain_type_val[1] == 0){
                $having = "sum(recharge.money)>=" . $retain_type_val[0];
            }else{
                $having = "sum(recharge.money)>=" . $retain_type_val[0] . " and sum(recharge.money)<=" . $retain_type_val[1];
            }
            //查询在充值区间内的角色集合
            $role_ids = $this->platform_db->table('recharge')
                ->field('recharge.role_id')
                ->join("LEFT JOIN user_server as us on us.role_id=recharge.role_id")
                ->where("us.c_son_id=$channel_id and us.sid=$sid and recharge.status=3 and recharge.created_at>=$start_time and recharge.created_at<=$end_time")
                ->group('recharge.role_id')
                ->having($having)
                ->select();
                
            $num = count($role_ids);   //角色数
            if(!empty($role_ids)){
                $role_ids = array_column($role_ids, 'role_id');
                $role_ids = implode(',', $role_ids);
            }else{
                $role_ids = '';
            }

            $retain_info = $this->data_analysis_db->table('retain_recharge_interval')
                ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}' and retain_type=$retain_type_key")
                ->find();

            $day_data = [
                'c_id' => $parent_channel_id,
                'c_son_id' => $channel_id,
                'sid' => $sid,
                'date' => $this->date,
                'retain_type' => $retain_type_key,
                'num' => $num,
                'role_ids' => $role_ids,
            ];
            if($retain_info){    //修改
                $res = $this->data_analysis_db->table('retain_recharge_interval')->where("id=" . $retain_info['id'])->save($day_data);
            }else{                      //添加
                $day_data['created_at'] = time();
                $res = $this->data_analysis_db->table('retain_recharge_interval')->add($day_data);
            }
        }
        
        return 1;
    }

    /**
     * @desc 查询当日对应的留存
     * @param $server_val
     */
    protected function doRetain($server_val, $channel_id){
        $sid = $server_val['id'];
        $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库

        //处理当天的昨日的次日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 1, 'one_day_');
        echo $sid . '--次日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第三天的3日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 2, 'three_day_');
        echo $sid . '--3日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第四天的4日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 3, 'four_day_');
        echo $sid . '--4日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第五天的5日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 4, 'five_day_');
        echo $sid . '--5日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第六天的6日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 5, 'six_day_');
        echo $sid . '--6日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第7天的7日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 6, 'seven_day_');
        echo $sid . '--7日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第14天的14日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 14, 'fourteen_day_');
        echo $sid . '--14日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第21天的21日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 20, 'twenty_one_day_');
        echo $sid . '--21日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第30天的30日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 29, 'thirty_day_');
        echo $sid . '--30日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第60天的60日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 59, 'sixty_day_');
        echo $sid . '--60日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第90天的90日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 89, 'ninety_day_');
        echo $sid . '--90日留存---' . $channel_id . $retain_res . PHP_EOL;

        return 'Retain--ok';
    }

    protected function getRetain($sid, $channel_id, $game_log_db, $days, $update_field){
        //查询当天的昨日的数据
        $one_day_date = date('Y-m-d', strtotime($this->date) - $days * 86400);   //
        $start_time = strtotime($one_day_date);  //开始时间戳
        $end_time = $start_time + 86399;    //结束时间戳


        //处理留存
        foreach($this->retain_type_count as $retain_type_key=>$retain_type_val){
            $retain_info = $this->data_analysis_db->table('retain_recharge_interval')
                ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and retain_type=$retain_type_key")
                ->find();
            if($retain_info){     //数据存在，计算留存
                if($retain_info['role_ids']){
                    //获取要处理的角色集在当日登录的用户数
                    $table = 'role_login_log' . getLogTable('month', $this->date);
                    $login_count = $game_log_db->table($table)
                        ->field('id,rid')
                        ->where("place=$channel_id and login_time>=$this->start_time and login_time<=$this->end_time and rid in (" . $retain_info['role_ids'] . ")")
                        ->count('distinct rid');
                    // $one_day_retain = getDivision($login_count, $retain_info['num']);
                    //获取要处理的角色集在当日的充值总数
                    $moneys = $this->platform_db->table('recharge')
                        ->field('id,rid')
                        ->join("LEFT JOIN user_server as us on us.role_id=recharge.role_id")
                        ->where("us.c_son_id=$channel_id and us.sid=$sid and recharge.status=3 and recharge.created_at>=$this->start_time and recharge.created_at<=$this->end_time and recharge.role_id in (" . $retain_info['role_ids'] . ")")
                        ->sum('money');
                    if(!$moneys){
                        $moneys = '0.00';
                    }
                }else{
                    $login_count = 0;
                    $moneys = '0.00';
                    // $one_day_retain = '0.00';   
                }

                //修改数据
                $data_update = [
                    $update_field . 'num' => $login_count,
                    $update_field . 'money' => $moneys,
                ];
                $up_res = $this->data_analysis_db->table('retain_recharge_interval')
                    ->where("id=" . $retain_info['id'])
                    ->save($data_update);
            }
        }


        return '处理留存完成';
    }

}
<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 每日首充统计
 */
class FirstRechargeDayController extends PublicController{
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
                    echo '渠道--' . $channel_val['name'] . '，区服--' . $server_val['server_name'] . '，每日首充开始处理';
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
        $this->game_data_db = connectionDb($server_val, 'data');     //连接游戏数据库

        //1.获取当日首充人数和金额
        $where = '1 ';
        $where .= "and role.place=$channel_id ";
        $where .= "and recharge.time >=" . $start_time . ' ';
        $where .= "and recharge.time <=" . $end_time . ' ';
        $where .= "and recharge.give_state=1 ";
        $subQuery = $this->game_data_db->table("recharge")
            ->field('
                rid,pay_money
            ')
            ->join("LEFT JOIN role on role.id=recharge.rid")
            ->where($where)
            ->group('recharge.rid')
            ->order('recharge.id ASC')
            ->buildSql();
        $first_data = $this->game_data_db->table($subQuery . ' tmp')
            ->field('
                count(rid) as num,
                sum(pay_money/100) as money
            ')
            ->find();

        //2.首日充值金额和次数
        $start_time_micro = $start_time*1000;
        $end_time_micro = $end_time*1000 + 999;
        $where = '1 ';
        $where .= "and role.place=$channel_id ";
        $where .= "and role.create_time>=$start_time_micro and role.create_time<=$end_time_micro ";
        $where .= "and recharge.time >=" . $start_time . ' ';
        $where .= "and recharge.time <=" . $end_time . ' ';
        $where .= "and recharge.give_state=1 ";
        $create_role_data = $this->game_data_db->table("recharge")
            ->field('
                count(distinct rid) create_role,
                count(rid) create_num,
                sum(pay_money/100) create_money
            ')
            ->join("LEFT JOIN role on role.id=recharge.rid")
            ->where($where)
            ->find();

        $day_info = $this->data_analysis_db->table('first_recharge_day')
            ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}'")
            ->find();

        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'date' => $this->date,
            'first_num' => !empty($first_data['num']) ? $first_data['num'] : 0,
            'first_money' => !empty($first_data['money']) ? $first_data['money'] : 0,
            'create_num' => !empty($create_role_data['create_num']) ? $create_role_data['create_num'] : 0,
            'create_money' => !empty($create_role_data['create_money']) ? $create_role_data['create_money'] : 0,
            'create_role' => !empty($create_role_data['create_role']) ? $create_role_data['create_role'] : 0,
            'updated_at' => time()
        ];
        if($day_info){    //修改
            $res = $this->data_analysis_db->table('first_recharge_day')->where("id=" . $day_info['id'])->save($day_data);
        }else{                      //添加
            $day_data['created_at'] = time();
            $res = $this->data_analysis_db->table('first_recharge_day')->add($day_data);
        }

        return 1;
    }


}
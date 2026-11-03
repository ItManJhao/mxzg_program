<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 充值区间统计
 */
class RechargeIntervalController extends PublicController{
    protected $game_log_db;

    protected $type_count = [
        '1' => 'one',
        '2' => 'tow',
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
    ];

    /**
     * 查询要处理的数据入口
     */
    public function entry(){
        echo 'game over';exit;
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

        $where = '1 ';
        $where .= "and recharge.sid=$sid ";
        $where .= "and us.c_son_id=$channel_id ";
        $where .= "and recharge.status=3 ";
        $where .= "and recharge.created_at>=$start_time and recharge.created_at<=$end_time ";
        $subQuery = $this->platform_db->table('recharge')
            ->field('
                recharge.role_id,count(recharge.role_id) as count,sum(recharge.money) as money
            ')
            ->join("LEFT JOIN user_server as us on us.role_id=recharge.role_id")
            ->where($where)
            ->group('recharge.role_id')
            ->buildSql();
        $recharge_interval_data = $this->platform_db->table($subQuery . ' tmp')
            ->field('
                sum(if(money>=1 and money<=10,1,0)) as one_roles,sum(if(money>=1 and money<=10,count,0)) as one_nums,sum(if(money>=1 and money<=10,money,0)) as one_moneys,
                sum(if(money>=11 and money<=30,1,0)) as two_roles,sum(if(money>=11 and money<=30,count,0)) as two_nums,sum(if(money>=11 and money<=30,money,0)) as two_moneys,
                sum(if(money>=31 and money<=50,1,0)) as three_roles,sum(if(money>=31 and money<=50,count,0)) as three_nums,sum(if(money>=31 and money<=50,money,0)) as three_moneys,
                sum(if(money>=51 and money<=100,1,0)) as four_roles,sum(if(money>=51 and money<=100,count,0)) as four_nums,sum(if(money>=51 and money<=100,money,0)) as four_moneys,
                sum(if(money>=101 and money<=200,1,0)) as five_roles,sum(if(money>=101 and money<=200,count,0)) as five_nums,sum(if(money>=101 and money<=200,money,0)) as five_moneys,
                sum(if(money>=201 and money<=500,1,0)) as six_roles,sum(if(money>=201 and money<=500,count,0)) as six_nums,sum(if(money>=201 and money<=500,money,0)) as six_moneys,
                sum(if(money>=501 and money<=1000,1,0)) as seven_roles,sum(if(money>=501 and money<=1000,count,0)) as seven_nums,sum(if(money>=501 and money<=1000,money,0)) as seven_moneys,
                sum(if(money>=1001 and money<=2000,1,0)) as eight_roles,sum(if(money>=1001 and money<=2000,count,0)) as eight_nums,sum(if(money>=1001 and money<=2000,money,0)) as eight_moneys,
                sum(if(money>=2001 and money<=3000,1,0)) as nine_roles,sum(if(money>=2001 and money<=3000,count,0)) as nine_nums,sum(if(money>=2001 and money<=3000,money,0)) as nine_moneys,
                sum(if(money>=3001 and money<=5000,1,0)) as ten_roles,sum(if(money>=3001 and money<=5000,count,0)) as ten_nums,sum(if(money>=3001 and money<=5000,money,0)) as ten_moneys,
                sum(if(money>=5001 and money<=8000,1,0)) as eleven_roles,sum(if(money>=5001 and money<=8000,count,0)) as eleven_nums,sum(if(money>=5001 and money<=8000,money,0)) as eleven_moneys,
                sum(if(money>=8001 and money<=10000,1,0)) as twelve_roles,sum(if(money>=8001 and money<=10000,count,0)) as twelve_nums,sum(if(money>=8001 and money<=10000,money,0)) as twelve_moneys,
                sum(if(money>=10001,1,0)) as thirteen_roles,sum(if(money>=10001,count,0)) as thirteen_nums,sum(if(money>=10001,money,0)) as thirteen_moneys
            ')
            ->find();

        foreach($this->type_count as $type_count_key=>$type_count_val){
            $day_data[] = [
                'c_id' => $parent_channel_id,
                'c_son_id' => $channel_id,
                'sid' => $sid,
                'date' => $this->date,
                'type' => $type_count_key,
                'role' => $recharge_interval_data[$type_count_val . '_roles'],
                'num' => $recharge_interval_data[$type_count_val . '_nums'],
                'money' => $recharge_interval_data[$type_count_val . '_moneys'],
                'created_at' => time()
            ];
        }
        
        $res = $this->data_analysis_db->table('recharge_interval')->addAll($day_data,[],true);
        
        return 1;
    }


}
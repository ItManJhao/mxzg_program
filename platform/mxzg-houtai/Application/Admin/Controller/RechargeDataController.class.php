<?php
namespace Admin\Controller;

use Think\Controller;

/*
 * 充值数据 
 */
class RechargeDataController extends PublicController{

    protected $product_types = [
        '0' => [
            'id' => '0', 
            'name' => '未知'
        ],
        '1' => [
            'id' => '1', 
            'name' => '钻石充值'
        ],
        '2' => [
            'id' => '2', 
            'name' => '成长基金'
        ],
        '3' => [
            'id' => '3', 
            'name' => '月度投资'
        ],
        '4' => [
            'id' => '4', 
            'name' => '星级养成礼'
        ],
        '5' => [
            'id' => '5', 
            'name' => '每周福利'
        ],
        '6' => [
            'id' => '6', 
            'name' => '每日限购（vip）'
        ],
        '7' => [
            'id' => '7', 
            'name' => '超值礼包'
        ],
        '8' => [
            'id' => '8', 
            'name' => '特权礼包'
        ],
        '9' => [
            'id' => '9', 
            'name' => '每月福利'
        ],
        '10' => [
            'id' => '10', 
            'name' => '每日礼包（全民）'
        ],
        '11' => [
            'id' => '11', 
            'name' => '新服限购'
        ],
        '12' => [
            'id' => '12', 
            'name' => '等级养成礼'
        ],
        '13' => [
            'id' => '13', 
            'name' => '关卡养成礼'
        ],
        '14' => [
            'id' => '14', 
            'name' => '中秋礼包'
        ],
        '15' => [
            'id' => '15', 
            'name' => '狂欢时刻'
        ],
        '16' => [
            'id' => '16', 
            'name' => '节日礼包'
        ],
        '17' => [
            'id' => '17', 
            'name' => '通行证活动'
        ],
        '18' => [
            'id' => '18', 
            'name' => '限时抢购'
        ],
        '19' => [
            'id' => '19', 
            'name' => '首充'
        ],
        '20' => [
            'id' => '20', 
            'name' => '召唤祈愿特权'
        ],
    ];

    protected $recharge_type = [
        '1' => ['id' => 1,'name' => '1~10','field' => 'one'],
        '2' => ['id' => 2,'name' => '11~30','field' => 'two'],
        '3' => ['id' => 3,'name' => '31~50','field' => 'three'],
        '4' => ['id' => 4,'name' => '51~100','field' => 'four'],
        '5' => ['id' => 5,'name' => '101~200','field' => 'five'],
        '6' => ['id' => 6,'name' => '201~500','field' => 'six'],
        '7' => ['id' => 7,'name' => '501~1000','field' => 'seven'],
        '8' => ['id' => 8,'name' => '1001~2000','field' => 'eight'],
        '9' => ['id' => 9,'name' => '2001~3000','field' => 'nine'],
        '10' => ['id' => 10,'name' => '3001~5000','field' => 'ten'],
        '11' => ['id' => 11,'name' => '5001~8000','field' => 'eleven'],
        '12' => ['id' => 12,'name' => '8001~10000','field' => 'twelve'],
        '13' => ['id' => 13,'name' => '10001+','field' => 'thirteen'],
    ];
    
    protected $hour_field_arr = [
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

    /*Ltv统计*/
    public function LtvDay(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();

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

        $where = '1 ';
        if(!empty($sid)){
            $where .= "and sid in($sid) ";
        }
        if(!empty($c_son_id)){
            $where .= "and c_son_id in($c_son_id) ";
        }

        $where .= "and unix_timestamp(date) >=" . strtotime($start_time) . ' ';
        $where .= "and unix_timestamp(date) <=" . strtotime($end_time) . ' ';

        $count = $this->data_analysis_db->table('ltv_day')
            ->where($where)
            ->count("distinct date");
        $Page  = new \Think\Page($count, 30);
        $list = $this->data_analysis_db->table('ltv_day')
            ->field("
                date,
                sum(create_role) as create_role_total,
                sum(add_money) as add_money_total,
                sum(one_day_money) as one_day_money_total,
                sum(two_day_money) as two_day_money_total,
                sum(three_day_money) as three_day_money_total,
                sum(four_day_money) as four_day_money_total,
                sum(five_day_money) as five_day_money_total,
                sum(six_day_money) as six_day_money_total,
                sum(seven_day_money) as seven_day_money_total,
                sum(eight_day_money) as eight_day_money_total,
                sum(nine_day_money) as nine_day_money_total,
                sum(ten_day_money) as ten_day_money_total,
                sum(eleven_day_money) as eleven_day_money_total,
                sum(twelve_day_money) as twelve_day_money_total,
                sum(thirteen_day_money) as thirteen_day_money_total,
                sum(fourteen_day_money) as fourteen_day_money_total,
                sum(fifteen_day_money) as fifteen_day_money_total,
                sum(sixteen_day_money) as sixteen_day_money_total,
                sum(seventeen_day_money) as seventeen_day_money_total,
                sum(eighteen_day_money) as eighteen_day_money_total,
                sum(nineteen_day_money) as nineteen_day_money_total,
                sum(twenty_day_money) as twenty_day_money_total,
                sum(twenty_one_day_money) as twenty_one_day_money_total,
                sum(twenty_two_day_money) as twenty_two_day_money_total,
                sum(twenty_three_day_money) as twenty_three_day_money_total,
                sum(twenty_four_day_money) as twenty_four_day_money_total,
                sum(twenty_five_day_money) as twenty_five_day_money_total,
                sum(twenty_six_day_money) as twenty_six_day_money_total,
                sum(twenty_seven_day_money) as twenty_seven_day_money_total,
                sum(twenty_eight_day_money) as twenty_eight_day_money_total,
                sum(twenty_nine_day_money) as twenty_nine_day_money_total,
                sum(thirty_day_money) as thirty_day_money_total,
                sum(thirty_one_day_money) as thirty_one_day_money_total,
                sum(thirty_two_day_money) as thirty_two_day_money_total,
                sum(thirty_three_day_money) as thirty_three_day_money_total,
                sum(thirty_four_day_money) as thirty_four_day_money_total,
                sum(thirty_five_day_money) as thirty_five_day_money_total,
                sum(thirty_six_day_money) as thirty_six_day_money_total,
                sum(thirty_seven_day_money) as thirty_seven_day_money_total,
                sum(thirty_eight_day_money) as thirty_eight_day_money_total,
                sum(thirty_nine_day_money) as thirty_nine_day_money_total,
                sum(forty_day_money) as forty_day_money_total,
                sum(forty_one_day_money) as forty_one_day_money_total,
                sum(forty_two_day_money) as forty_two_day_money_total,
                sum(forty_three_day_money) as forty_three_day_money_total,
                sum(forty_four_day_money) as forty_four_day_money_total,
                sum(forty_five_day_money) as forty_five_day_money_total,
                sum(forty_six_day_money) as forty_six_day_money_total,
                sum(forty_seven_day_money) as forty_seven_day_money_total,
                sum(forty_eight_day_money) as forty_eight_day_money_total,
                sum(forty_nine_day_money) as forty_nine_day_money_total,
                sum(fifty_day_money) as fifty_day_money_total,
                sum(fifty_one_day_money) as fifty_one_day_money_total,
                sum(fifty_two_day_money) as fifty_two_day_money_total,
                sum(fifty_three_day_money) as fifty_three_day_money_total,
                sum(fifty_four_day_money) as fifty_four_day_money_total,
                sum(fifty_five_day_money) as fifty_five_day_money_total,
                sum(fifty_six_day_money) as fifty_six_day_money_total,
                sum(fifty_seven_day_money) as fifty_seven_day_money_total,
                sum(fifty_eight_day_money) as fifty_eight_day_money_total,
                sum(fifty_nine_day_money) as fifty_nine_day_money_total,
                sum(sixty_day_money) as sixty_day_money_total,
                sum(sixty_one_day_money) as sixty_one_day_money_total,
                sum(sixty_two_day_money) as sixty_two_day_money_total,
                sum(sixty_three_day_money) as sixty_three_day_money_total,
                sum(sixty_four_day_money) as sixty_four_day_money_total,
                sum(sixty_five_day_money) as sixty_five_day_money_total,
                sum(sixty_six_day_money) as sixty_six_day_money_total,
                sum(sixty_seven_day_money) as sixty_seven_day_money_total,
                sum(sixty_eight_day_money) as sixty_eight_day_money_total,
                sum(sixty_nine_day_money) as sixty_nine_day_money_total,
                sum(seventy_day_money) as seventy_day_money_total,
                sum(seventy_one_day_money) as seventy_one_day_money_total,
                sum(seventy_two_day_money) as seventy_two_day_money_total,
                sum(seventy_three_day_money) as seventy_three_day_money_total,
                sum(seventy_four_day_money) as seventy_four_day_money_total,
                sum(seventy_five_day_money) as seventy_five_day_money_total,
                sum(seventy_six_day_money) as seventy_six_day_money_total,
                sum(seventy_seven_day_money) as seventy_seven_day_money_total,
                sum(seventy_eight_day_money) as seventy_eight_day_money_total,
                sum(seventy_nine_day_money) as seventy_nine_day_money_total,
                sum(eighty_day_money) as eighty_day_money_total,
                sum(eighty_one_day_money) as eighty_one_day_money_total,
                sum(eighty_two_day_money) as eighty_two_day_money_total,
                sum(eighty_three_day_money) as eighty_three_day_money_total,
                sum(eighty_four_day_money) as eighty_four_day_money_total,
                sum(eighty_five_day_money) as eighty_five_day_money_total,
                sum(eighty_six_day_money) as eighty_six_day_money_total,
                sum(eighty_seven_day_money) as eighty_seven_day_money_total,
                sum(eighty_eight_day_money) as eighty_eight_day_money_total,
                sum(eighty_nine_day_money) as eighty_nine_day_money_total,
                sum(ninety_day_money) as ninety_day_money_total,
                sum(ninety_one_day_money) as ninety_one_day_money_total,
                sum(ninety_two_day_money) as ninety_two_day_money_total,
                sum(ninety_three_day_money) as ninety_three_day_money_total,
                sum(ninety_four_day_money) as ninety_four_day_money_total,
                sum(ninety_five_day_money) as ninety_five_day_money_total,
                sum(ninety_six_day_money) as ninety_six_day_money_total,
                sum(ninety_seven_day_money) as ninety_seven_day_money_total,
                sum(ninety_eight_day_money) as ninety_eight_day_money_total,
                sum(ninety_nine_day_money) as ninety_nine_day_money_total,
                sum(hundred_day_money) as hundred_day_money_total,
                sum(hundred_one_day_money) as hundred_one_day_money_total,
                sum(hundred_two_day_money) as hundred_two_day_money_total,
                sum(hundred_three_day_money) as hundred_three_day_money_total,
                sum(hundred_four_day_money) as hundred_four_day_money_total,
                sum(hundred_five_day_money) as hundred_five_day_money_total,
                sum(hundred_six_day_money) as hundred_six_day_money_total,
                sum(hundred_seven_day_money) as hundred_seven_day_money_total,
                sum(hundred_eight_day_money) as hundred_eight_day_money_total,
                sum(hundred_nine_day_money) as hundred_nine_day_money_total,
                sum(hundred_ten_day_money) as hundred_ten_day_money_total,
                sum(hundred_eleven_day_money) as hundred_eleven_day_money_total,
                sum(hundred_twelve_day_money) as hundred_twelve_day_money_total,
                sum(hundred_thirteen_day_money) as hundred_thirteen_day_money_total,
                sum(hundred_fourteen_day_money) as hundred_fourteen_day_money_total,
                sum(hundred_fifteen_day_money) as hundred_fifteen_day_money_total,
                sum(hundred_sixteen_day_money) as hundred_sixteen_day_money_total,
                sum(hundred_seventeen_day_money) as hundred_seventeen_day_money_total,
                sum(hundred_eighteen_day_money) as hundred_eighteen_day_money_total,
                sum(hundred_nineteen_day_money) as hundred_nineteen_day_money_total,
                sum(hundred_twenty_day_money) as hundred_twenty_day_money_total,
                sum(hundred_twenty_one_day_money) as hundred_twenty_one_day_money_total,
                sum(hundred_twenty_two_day_money) as hundred_twenty_two_day_money_total,
                sum(hundred_twenty_three_day_money) as hundred_twenty_three_day_money_total,
                sum(hundred_twenty_four_day_money) as hundred_twenty_four_day_money_total,
                sum(hundred_twenty_five_day_money) as hundred_twenty_five_day_money_total,
                sum(hundred_twenty_six_day_money) as hundred_twenty_six_day_money_total,
                sum(hundred_twenty_seven_day_money) as hundred_twenty_seven_day_money_total,
                sum(hundred_twenty_eight_day_money) as hundred_twenty_eight_day_money_total,
                sum(hundred_twenty_nine_day_money) as hundred_twenty_nine_day_money_total,
                sum(hundred_thirty_day_money) as hundred_thirty_day_money_total,
                sum(hundred_thirty_one_day_money) as hundred_thirty_one_day_money_total,
                sum(hundred_thirty_two_day_money) as hundred_thirty_two_day_money_total,
                sum(hundred_thirty_three_day_money) as hundred_thirty_three_day_money_total,
                sum(hundred_thirty_four_day_money) as hundred_thirty_four_day_money_total,
                sum(hundred_thirty_five_day_money) as hundred_thirty_five_day_money_total,
                sum(hundred_thirty_six_day_money) as hundred_thirty_six_day_money_total,
                sum(hundred_thirty_seven_day_money) as hundred_thirty_seven_day_money_total,
                sum(hundred_thirty_eight_day_money) as hundred_thirty_eight_day_money_total,
                sum(hundred_thirty_nine_day_money) as hundred_thirty_nine_day_money_total,
                sum(hundred_forty_day_money) as hundred_forty_day_money_total,
                sum(hundred_forty_one_day_money) as hundred_forty_one_day_money_total,
                sum(hundred_forty_two_day_money) as hundred_forty_two_day_money_total,
                sum(hundred_forty_three_day_money) as hundred_forty_three_day_money_total,
                sum(hundred_forty_four_day_money) as hundred_forty_four_day_money_total,
                sum(hundred_forty_five_day_money) as hundred_forty_five_day_money_total,
                sum(hundred_forty_six_day_money) as hundred_forty_six_day_money_total,
                sum(hundred_forty_seven_day_money) as hundred_forty_seven_day_money_total,
                sum(hundred_forty_eight_day_money) as hundred_forty_eight_day_money_total,
                sum(hundred_forty_nine_day_money) as hundred_forty_nine_day_money_total,
                sum(hundred_fifty_day_money) as hundred_fifty_day_money_total
            ")
            ->where($where)
            ->group('date')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        
        foreach($list as &$list_val){

            //处理显示为空
            $days = getTimeslotDays(strtotime($list_val['date']), time());
            $list_val = [
                'date' => $list_val['date'],
                'create_role_total' => $list_val['create_role_total'],
                'add_money_total' => $list_val['add_money_total'],
                'one_ltv' => ($days >= 1) ? getDivisionSpecial($list_val['one_day_money_total'],$list_val['create_role_total'],2) : '',
                'two_ltv' => ($days >= 2) ? getDivisionSpecial($list_val['two_day_money_total'],$list_val['create_role_total'],2) : '',
                'three_ltv' => ($days >= 3) ? getDivisionSpecial($list_val['three_day_money_total'],$list_val['create_role_total'],2) : '',
                'four_ltv' => ($days >= 4) ? getDivisionSpecial($list_val['four_day_money_total'],$list_val['create_role_total'],2) : '',
                'five_ltv' => ($days >= 5) ? getDivisionSpecial($list_val['five_day_money_total'],$list_val['create_role_total'],2) : '',
                'six_ltv' => ($days >= 6) ? getDivisionSpecial($list_val['six_day_money_total'],$list_val['create_role_total'],2) : '',
                'seven_ltv' => ($days >= 7) ? getDivisionSpecial($list_val['seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'eight_ltv' => ($days >= 8) ? getDivisionSpecial($list_val['eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'nine_ltv' => ($days >= 9) ? getDivisionSpecial($list_val['nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'ten_ltv' => ($days >= 10) ? getDivisionSpecial($list_val['ten_day_money_total'],$list_val['create_role_total'],2) : '',
                'eleven_ltv' => ($days >= 11) ? getDivisionSpecial($list_val['eleven_day_money_total'],$list_val['create_role_total'],2) : '',
                'twelve_ltv' => ($days >= 12) ? getDivisionSpecial($list_val['twelve_day_money_total'],$list_val['create_role_total'],2) : '',
                'thirteen_ltv' => ($days >= 13) ? getDivisionSpecial($list_val['thirteen_day_money_total'],$list_val['create_role_total'],2) : '',
                'fourteen_ltv' => ($days >= 14) ? getDivisionSpecial($list_val['fourteen_day_money_total'],$list_val['create_role_total'],2) : '',
                'fifteen_ltv' => ($days >= 15) ? getDivisionSpecial($list_val['fifteen_day_money_total'],$list_val['create_role_total'],2) : '',
                'sixteen_ltv' => ($days >= 16) ? getDivisionSpecial($list_val['sixteen_day_money_total'],$list_val['create_role_total'],2) : '',
                'seventeen_ltv' => ($days >= 17) ? getDivisionSpecial($list_val['seventeen_day_money_total'],$list_val['create_role_total'],2) : '',
                'eighteen_ltv' => ($days >= 18) ? getDivisionSpecial($list_val['eighteen_day_money_total'],$list_val['create_role_total'],2) : '',
                'nineteen_ltv' => ($days >= 19) ? getDivisionSpecial($list_val['nineteen_day_money_total'],$list_val['create_role_total'],2) : '',
                'twenty_ltv' => ($days >= 20) ? getDivisionSpecial($list_val['twenty_day_money_total'],$list_val['create_role_total'],2) : '',
                'twenty_one_ltv' => ($days >= 21) ? getDivisionSpecial($list_val['twenty_one_day_money_total'],$list_val['create_role_total'],2) : '',
                'twenty_two_ltv' => ($days >= 22) ? getDivisionSpecial($list_val['twenty_two_day_money_total'],$list_val['create_role_total'],2) : '',
                'twenty_three_ltv' => ($days >= 23) ? getDivisionSpecial($list_val['twenty_three_day_money_total'],$list_val['create_role_total'],2) : '',
                'twenty_four_ltv' => ($days >= 24) ? getDivisionSpecial($list_val['twenty_four_day_money_total'],$list_val['create_role_total'],2) : '',
                'twenty_five_ltv' => ($days >= 25) ? getDivisionSpecial($list_val['twenty_five_day_money_total'],$list_val['create_role_total'],2) : '',
                'twenty_six_ltv' => ($days >= 26) ? getDivisionSpecial($list_val['twenty_six_day_money_total'],$list_val['create_role_total'],2) : '',
                'twenty_seven_ltv' => ($days >= 27) ? getDivisionSpecial($list_val['twenty_seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'twenty_eight_ltv' => ($days >= 28) ? getDivisionSpecial($list_val['twenty_eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'twenty_nine_ltv' => ($days >= 29) ? getDivisionSpecial($list_val['twenty_nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'thirty_ltv' => ($days >= 30) ? getDivisionSpecial($list_val['thirty_day_money_total'],$list_val['create_role_total'],2) : '',
                'thirty_one_ltv' => ($days >= 31) ? getDivisionSpecial($list_val['thirty_one_day_money_total'],$list_val['create_role_total'],2) : '',
                'thirty_two_ltv' => ($days >= 32) ? getDivisionSpecial($list_val['thirty_two_day_money_total'],$list_val['create_role_total'],2) : '',
                'thirty_three_ltv' => ($days >= 33) ? getDivisionSpecial($list_val['thirty_three_day_money_total'],$list_val['create_role_total'],2) : '',
                'thirty_four_ltv' => ($days >= 34) ? getDivisionSpecial($list_val['thirty_four_day_money_total'],$list_val['create_role_total'],2) : '',
                'thirty_five_ltv' => ($days >= 35) ? getDivisionSpecial($list_val['thirty_five_day_money_total'],$list_val['create_role_total'],2) : '',
                'thirty_six_ltv' => ($days >= 36) ? getDivisionSpecial($list_val['thirty_six_day_money_total'],$list_val['create_role_total'],2) : '',
                'thirty_seven_ltv' => ($days >= 37) ? getDivisionSpecial($list_val['thirty_seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'thirty_eight_ltv' => ($days >= 38) ? getDivisionSpecial($list_val['thirty_eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'thirty_nine_ltv' => ($days >= 39) ? getDivisionSpecial($list_val['thirty_nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'forty_ltv' => ($days >= 40) ? getDivisionSpecial($list_val['forty_day_money_total'],$list_val['create_role_total'],2) : '',
                'forty_one_ltv' => ($days >= 41) ? getDivisionSpecial($list_val['forty_one_day_money_total'],$list_val['create_role_total'],2) : '',
                'forty_two_ltv' => ($days >= 42) ? getDivisionSpecial($list_val['forty_two_day_money_total'],$list_val['create_role_total'],2) : '',
                'forty_three_ltv' => ($days >= 43) ? getDivisionSpecial($list_val['forty_three_day_money_total'],$list_val['create_role_total'],2) : '',
                'forty_four_ltv' => ($days >= 44) ? getDivisionSpecial($list_val['forty_four_day_money_total'],$list_val['create_role_total'],2) : '',
                'forty_five_ltv' => ($days >= 45) ? getDivisionSpecial($list_val['forty_five_day_money_total'],$list_val['create_role_total'],2) : '',
                'forty_six_ltv' => ($days >= 46) ? getDivisionSpecial($list_val['forty_six_day_money_total'],$list_val['create_role_total'],2) : '',
                'forty_seven_ltv' => ($days >= 47) ? getDivisionSpecial($list_val['forty_seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'forty_eight_ltv' => ($days >= 48) ? getDivisionSpecial($list_val['forty_eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'forty_nine_ltv' => ($days >= 49) ? getDivisionSpecial($list_val['forty_nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'fifty_ltv' => ($days >= 50) ? getDivisionSpecial($list_val['fifty_day_money_total'],$list_val['create_role_total'],2) : '',
                'fifty_one_ltv' => ($days >= 51) ? getDivisionSpecial($list_val['fifty_one_day_money_total'],$list_val['create_role_total'],2) : '',
                'fifty_two_ltv' => ($days >= 52) ? getDivisionSpecial($list_val['fifty_two_day_money_total'],$list_val['create_role_total'],2) : '',
                'fifty_three_ltv' => ($days >= 53) ? getDivisionSpecial($list_val['fifty_three_day_money_total'],$list_val['create_role_total'],2) : '',
                'fifty_four_ltv' => ($days >= 54) ? getDivisionSpecial($list_val['fifty_four_day_money_total'],$list_val['create_role_total'],2) : '',
                'fifty_five_ltv' => ($days >= 55) ? getDivisionSpecial($list_val['fifty_five_day_money_total'],$list_val['create_role_total'],2) : '',
                'fifty_six_ltv' => ($days >= 56) ? getDivisionSpecial($list_val['fifty_six_day_money_total'],$list_val['create_role_total'],2) : '',
                'fifty_seven_ltv' => ($days >= 57) ? getDivisionSpecial($list_val['fifty_seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'fifty_eight_ltv' => ($days >= 58) ? getDivisionSpecial($list_val['fifty_eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'fifty_nine_ltv' => ($days >= 59) ? getDivisionSpecial($list_val['fifty_nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'sixty_ltv' => ($days >= 60) ? getDivisionSpecial($list_val['sixty_day_money_total'],$list_val['create_role_total'],2) : '',
                'sixty_one_ltv' => ($days >= 61) ? getDivisionSpecial($list_val['sixty_one_day_money_total'],$list_val['create_role_total'],2) : '',
                'sixty_two_ltv' => ($days >= 62) ? getDivisionSpecial($list_val['sixty_two_day_money_total'],$list_val['create_role_total'],2) : '',
                'sixty_three_ltv' => ($days >= 63) ? getDivisionSpecial($list_val['sixty_three_day_money_total'],$list_val['create_role_total'],2) : '',
                'sixty_four_ltv' => ($days >= 64) ? getDivisionSpecial($list_val['sixty_four_day_money_total'],$list_val['create_role_total'],2) : '',
                'sixty_five_ltv' => ($days >= 65) ? getDivisionSpecial($list_val['sixty_five_day_money_total'],$list_val['create_role_total'],2) : '',
                'sixty_six_ltv' => ($days >= 66) ? getDivisionSpecial($list_val['sixty_six_day_money_total'],$list_val['create_role_total'],2) : '',
                'sixty_seven_ltv' => ($days >= 67) ? getDivisionSpecial($list_val['sixty_seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'sixty_eight_ltv' => ($days >= 68) ? getDivisionSpecial($list_val['sixty_eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'sixty_nine_ltv' => ($days >= 69) ? getDivisionSpecial($list_val['sixty_nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'seventy_ltv' => ($days >= 70) ? getDivisionSpecial($list_val['seventy_day_money_total'],$list_val['create_role_total'],2) : '',
                'seventy_one_ltv' => ($days >= 71) ? getDivisionSpecial($list_val['seventy_one_day_money_total'],$list_val['create_role_total'],2) : '',
                'seventy_two_ltv' => ($days >= 72) ? getDivisionSpecial($list_val['seventy_two_day_money_total'],$list_val['create_role_total'],2) : '',
                'seventy_three_ltv' => ($days >= 73) ? getDivisionSpecial($list_val['seventy_three_day_money_total'],$list_val['create_role_total'],2) : '',
                'seventy_four_ltv' => ($days >= 74) ? getDivisionSpecial($list_val['seventy_four_day_money_total'],$list_val['create_role_total'],2) : '',
                'seventy_five_ltv' => ($days >= 75) ? getDivisionSpecial($list_val['seventy_five_day_money_total'],$list_val['create_role_total'],2) : '',
                'seventy_six_ltv' => ($days >= 76) ? getDivisionSpecial($list_val['seventy_six_day_money_total'],$list_val['create_role_total'],2) : '',
                'seventy_seven_ltv' => ($days >= 77) ? getDivisionSpecial($list_val['seventy_seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'seventy_eight_ltv' => ($days >= 78) ? getDivisionSpecial($list_val['seventy_eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'seventy_nine_ltv' => ($days >= 79) ? getDivisionSpecial($list_val['seventy_nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'eighty_ltv' => ($days >= 80) ? getDivisionSpecial($list_val['eighty_day_money_total'],$list_val['create_role_total'],2) : '',
                'eighty_one_ltv' => ($days >= 81) ? getDivisionSpecial($list_val['eighty_one_day_money_total'],$list_val['create_role_total'],2) : '',
                'eighty_two_ltv' => ($days >= 82) ? getDivisionSpecial($list_val['eighty_two_day_money_total'],$list_val['create_role_total'],2) : '',
                'eighty_three_ltv' => ($days >= 83) ? getDivisionSpecial($list_val['eighty_three_day_money_total'],$list_val['create_role_total'],2) : '',
                'eighty_four_ltv' => ($days >= 84) ? getDivisionSpecial($list_val['eighty_four_day_money_total'],$list_val['create_role_total'],2) : '',
                'eighty_five_ltv' => ($days >= 85) ? getDivisionSpecial($list_val['eighty_five_day_money_total'],$list_val['create_role_total'],2) : '',
                'eighty_six_ltv' => ($days >= 86) ? getDivisionSpecial($list_val['eighty_six_day_money_total'],$list_val['create_role_total'],2) : '',
                'eighty_seven_ltv' => ($days >= 87) ? getDivisionSpecial($list_val['eighty_seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'eighty_eight_ltv' => ($days >= 88) ? getDivisionSpecial($list_val['eighty_eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'eighty_nine_ltv' => ($days >= 89) ? getDivisionSpecial($list_val['eighty_nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'ninety_ltv' => ($days >= 90) ? getDivisionSpecial($list_val['ninety_day_money_total'],$list_val['create_role_total'],2) : '',


                'ninety_one_ltv' => ($days >= 91) ? getDivisionSpecial($list_val['ninety_one_day_money_total'],$list_val['create_role_total'],2) : '',
                'ninety_two_ltv' => ($days >= 92) ? getDivisionSpecial($list_val['ninety_two_day_money_total'],$list_val['create_role_total'],2) : '',
                'ninety_three_ltv' => ($days >= 93) ? getDivisionSpecial($list_val['ninety_three_day_money_total'],$list_val['create_role_total'],2) : '',
                'ninety_four_ltv' => ($days >= 94) ? getDivisionSpecial($list_val['ninety_four_day_money_total'],$list_val['create_role_total'],2) : '',
                'ninety_five_ltv' => ($days >= 95) ? getDivisionSpecial($list_val['ninety_five_day_money_total'],$list_val['create_role_total'],2) : '',
                'ninety_six_ltv' => ($days >= 96) ? getDivisionSpecial($list_val['ninety_six_day_money_total'],$list_val['create_role_total'],2) : '',
                'ninety_seven_ltv' => ($days >= 97) ? getDivisionSpecial($list_val['ninety_seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'ninety_eight_ltv' => ($days >= 98) ? getDivisionSpecial($list_val['ninety_eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'ninety_nine_ltv' => ($days >= 99) ? getDivisionSpecial($list_val['ninety_nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_ltv' => ($days >= 100) ? getDivisionSpecial($list_val['hundred_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_one_ltv' => ($days >= 101) ? getDivisionSpecial($list_val['hundred_one_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_two_ltv' => ($days >= 102) ? getDivisionSpecial($list_val['hundred_two_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_three_ltv' => ($days >= 103) ? getDivisionSpecial($list_val['hundred_three_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_four_ltv' => ($days >= 104) ? getDivisionSpecial($list_val['hundred_four_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_five_ltv' => ($days >= 105) ? getDivisionSpecial($list_val['hundred_five_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_six_ltv' => ($days >= 106) ? getDivisionSpecial($list_val['hundred_six_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_seven_ltv' => ($days >= 107) ? getDivisionSpecial($list_val['hundred_seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_eight_ltv' => ($days >= 108) ? getDivisionSpecial($list_val['hundred_eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_nine_ltv' => ($days >= 109) ? getDivisionSpecial($list_val['hundred_nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_ten_ltv' => ($days >= 110) ? getDivisionSpecial($list_val['hundred_ten_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_eleven_ltv' => ($days >= 111) ? getDivisionSpecial($list_val['hundred_eleven_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_twelve_ltv' => ($days >= 112) ? getDivisionSpecial($list_val['hundred_twelve_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_thirteen_ltv' => ($days >= 113) ? getDivisionSpecial($list_val['hundred_thirteen_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_fourteen_ltv' => ($days >= 114) ? getDivisionSpecial($list_val['hundred_fourteen_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_fifteen_ltv' => ($days >= 115) ? getDivisionSpecial($list_val['hundred_fifteen_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_sixteen_ltv' => ($days >= 116) ? getDivisionSpecial($list_val['hundred_sixteen_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_seventeen_ltv' => ($days >= 117) ? getDivisionSpecial($list_val['hundred_seventeen_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_eighteen_ltv' => ($days >= 118) ? getDivisionSpecial($list_val['hundred_eighteen_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_nineteen_ltv' => ($days >= 119) ? getDivisionSpecial($list_val['hundred_nineteen_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_twenty_ltv' => ($days >= 120) ? getDivisionSpecial($list_val['hundred_twenty_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_twenty_one_ltv' => ($days >= 121) ? getDivisionSpecial($list_val['hundred_twenty_one_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_twenty_two_ltv' => ($days >= 122) ? getDivisionSpecial($list_val['hundred_twenty_two_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_twenty_three_ltv' => ($days >= 123) ? getDivisionSpecial($list_val['hundred_twenty_three_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_twenty_four_ltv' => ($days >= 124) ? getDivisionSpecial($list_val['hundred_twenty_four_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_twenty_five_ltv' => ($days >= 125) ? getDivisionSpecial($list_val['hundred_twenty_five_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_twenty_six_ltv' => ($days >= 126) ? getDivisionSpecial($list_val['hundred_twenty_six_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_twenty_seven_ltv' => ($days >= 127) ? getDivisionSpecial($list_val['hundred_twenty_seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_twenty_eight_ltv' => ($days >= 128) ? getDivisionSpecial($list_val['hundred_twenty_eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_twenty_nine_ltv' => ($days >= 129) ? getDivisionSpecial($list_val['hundred_twenty_nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_thirty_ltv' => ($days >= 130) ? getDivisionSpecial($list_val['hundred_thirty_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_thirty_one_ltv' => ($days >=131) ? getDivisionSpecial($list_val['hundred_thirty_one_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_thirty_two_ltv' => ($days >= 132) ? getDivisionSpecial($list_val['hundred_thirty_two_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_thirty_three_ltv' => ($days >= 133) ? getDivisionSpecial($list_val['hundred_thirty_three_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_thirty_four_ltv' => ($days >= 134) ? getDivisionSpecial($list_val['hundred_thirty_four_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_thirty_five_ltv' => ($days >= 135) ? getDivisionSpecial($list_val['hundred_thirty_five_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_thirty_six_ltv' => ($days >= 136) ? getDivisionSpecial($list_val['hundred_thirty_six_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_thirty_seven_ltv' => ($days >= 137) ? getDivisionSpecial($list_val['hundred_thirty_seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_thirty_eight_ltv' => ($days >= 138) ? getDivisionSpecial($list_val['hundred_thirty_eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_thirty_nine_ltv' => ($days >= 139) ? getDivisionSpecial($list_val['hundred_thirty_nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_forty_ltv' => ($days >= 140) ? getDivisionSpecial($list_val['hundred_forty_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_forty_one_ltv' => ($days >= 141) ? getDivisionSpecial($list_val['hundred_forty_one_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_forty_two_ltv' => ($days >= 142) ? getDivisionSpecial($list_val['hundred_forty_two_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_forty_three_ltv' => ($days >= 143) ? getDivisionSpecial($list_val['hundred_forty_three_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_forty_four_ltv' => ($days >= 144) ? getDivisionSpecial($list_val['hundred_forty_four_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_forty_five_ltv' => ($days >= 145) ? getDivisionSpecial($list_val['hundred_forty_five_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_forty_six_ltv' => ($days >= 146) ? getDivisionSpecial($list_val['hundred_forty_six_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_forty_seven_ltv' => ($days >= 147) ? getDivisionSpecial($list_val['hundred_forty_seven_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_forty_eight_ltv' => ($days >= 148) ? getDivisionSpecial($list_val['hundred_forty_eight_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_forty_nine_ltv' => ($days >= 149) ? getDivisionSpecial($list_val['hundred_forty_nine_day_money_total'],$list_val['create_role_total'],2) : '',
                'hundred_fifty_ltv' => ($days >= 150) ? getDivisionSpecial($list_val['hundred_fifty_day_money_total'],$list_val['create_role_total'],2) : '',

            ];

        }

        $show = $Page->show();
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*Ltv小时统计*/
    public function LtvHour(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();
        
        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $day_after = I('day_after', '1');

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'day_after' => $day_after
        ];
        $data_x = [];
        $data_series = [];  //折线图数据
        if(empty($sid)){
            $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'error_msg'=> '请选择服务器！！！', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        $sid_arr = explode(',', $sid);
        if(count($sid_arr) > 4){
            $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'error_msg'=> '服务器不能超过4个！！！', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $where = '1 ';
        if(!empty($c_son_id)){
            $where .= "and c_son_id in($c_son_id) ";
        }
        if(!empty($day_after)){
            $where .= "and day_after=$day_after ";
        }

        $server_data = $this->platform_db->table('server')->where("id in($sid)")->select();
        
        foreach($server_data as &$server_val){
            $sid_where = $where;
            $sid_where .= "and sid=" . $server_val['id'];
            $ltv_hour_data = $this->data_analysis_db->table('ltv_hour')
                ->field("
                    sum(open_create_role) as create_role_total,
                    sum(one_day_money) as one_day_money_total,
                    sum(two_day_money) as two_day_money_total,
                    sum(three_day_money) as three_day_money_total,
                    sum(four_day_money) as four_day_money_total,
                    sum(five_day_money) as five_day_money_total,
                    sum(six_day_money) as six_day_money_total,
                    sum(seven_day_money) as seven_day_money_total,
                    sum(eight_day_money) as eight_day_money_total,
                    sum(nine_day_money) as nine_day_money_total,
                    sum(ten_day_money) as ten_day_money_total,
                    sum(eleven_day_money) as eleven_day_money_total,
                    sum(twelve_day_money) as twelve_day_money_total,
                    sum(thirteen_day_money) as thirteen_day_money_total,
                    sum(fourteen_day_money) as fourteen_day_money_total,
                    sum(fifteen_day_money) as fifteen_day_money_total,
                    sum(sixteen_day_money) as sixteen_day_money_total,
                    sum(seventeen_day_money) as seventeen_day_money_total,
                    sum(eighteen_day_money) as eighteen_day_money_total,
                    sum(nineteen_day_money) as nineteen_day_money_total,
                    sum(twenty_day_money) as twenty_day_money_total,
                    sum(twenty_one_day_money) as twenty_one_day_money_total,
                    sum(twenty_two_day_money) as twenty_two_day_money_total,
                    sum(twenty_three_day_money) as twenty_three_day_money_total,
                    sum(twenty_four_day_money) as twenty_four_day_money_total
                ")
                ->where($sid_where)
                ->find();

            $line_data = [];
            for($i=1; $i<=24; $i++){
                $field = $this->hour_field_arr[$i] . '_day_money_total';
                $line_data[] = getDivisionSpecial($ltv_hour_data[$field]/100, $ltv_hour_data['create_role_total'],2);
            }
            $data_series[] = [
                'name' => $server_val['id'] . '--' . $server_val['server_name'],
                'type' => 'line',
                'data' => $line_data
            ];
        }

        for($j=1; $j<=24; $j++){
            $data_x[] = $j;
        }
        $this->assign(['data_x'=> json_encode($data_x), 'data_series'=> json_encode($data_series), 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*充值商品统计*/
    public function ProductStatis(){

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();
        
        //获取所有的商品
        $product_list = $this->platform_db->table('product')->select();
        $product_list_re = [];
        foreach($product_list as $product_list_val){
            $product_list_re[$product_list_val['id']] = $product_list_val;
        }
        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $product_id = I('product_id', '0');
        $type = I('type', '1');
        $start_time = I('start_time', date('Y-m-d H:i:s', strtotime("-7 day")));
        $end_time = I('end_time', date('Y-m-d H:i:s'));
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'product_id' => $product_id,
            'type' => $type,
            'start_time' => $start_time,
            'end_time' => $end_time
        ];

        $where = '1 ';
        $where .= "and recharge.status=3 ";
        
        if(!empty($c_son_id)){
            $where .= "and us.c_son_id in($c_son_id) ";
        }
        if(!empty($sid)){
            $where .= "and recharge.sid in($sid) ";
        }
        if(!empty($product_id)){
            $where .= "and recharge.goods_id in($product_id) ";
        }

        $where .= "and recharge.created_at >=" . strtotime($start_time) . ' ';
        $where .= "and recharge.created_at <=" . strtotime($end_time) . ' ';

        if($type == 1){     //汇总，以商品为主来统计
            $list = $this->platform_db->table('recharge')
                ->field("*,count(distinct recharge.role_id) as role_num,count(recharge.id) as num")
                ->join("LEFT JOIN user_server as us on us.role_id=recharge.role_id")
                ->where($where)
                ->group("goods_id")
                ->select();

            $count = count($list);
            $Page  = new \Think\Page($count,200);

            //计算总充值和总人数
            $total_data = $this->platform_db->table('recharge')
                ->field("count(recharge.role_id) as role_num_total,sum(recharge.money) as money_total")
                ->join("LEFT JOIN user_server as us on us.role_id=recharge.role_id")
                ->where($where)
                ->find();

            foreach($list as &$list_val){
                if(isset($product_list_re[$list_val['goods_id']])){
                    $product_info = $product_list_re[$list_val['goods_id']];
                    //转换商品名字
                    $list_val['product_name'] = $product_info['product_name'];
                    //转换商品类型名字
                    $list_val['product_type_name'] = isset($this->product_types[$product_info['product_type']]) ? $this->product_types[$product_info['product_type']]['name'] : '';
                }
                //单日单商品的总充值金额
                $list_val['money_total'] = round($list_val['money'] * $list_val['num'], 2);
                $list_val['pay_money'] = round($list_val['money'], 2);
                //人数占比（单日单商品的充值人数除以总充值人数）
                $list_val['role_ratio'] = getDivision($list_val['role_num'],$total_data['role_num_total']);
                //金额占比（单日单商品的充值金额除以总充值金额）
                $list_val['money_ratio'] = getDivision($list_val['money_total'],$total_data['money_total']);
            }
        }else{              //日期，以日期和商品为主来统计
            $subQuery = $this->platform_db->table('recharge')
                ->field("recharge.*,from_unixtime(recharge.created_at,'%Y-%m-%d') as date")
                ->join("LEFT JOIN user_server as us on us.role_id=recharge.role_id")
                ->where($where)
                ->buildSql();

            $count = $this->platform_db->table($subQuery . ' aa')
                ->field("*")
                ->group("date,goods_id")
                ->select();

            $count = count($count);
            $Page  = new \Think\Page($count,30);
            $list = $this->platform_db->table($subQuery . ' aa')
                ->field("*,count(distinct aa.role_id) as role_num,count(aa.id) as num")
                ->group("date,goods_id")
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();

            //计算总充值和总人数
            $total_data = $this->platform_db->table($subQuery . ' aa')
                ->field("count(aa.role_id) as role_num_total,sum(aa.money) as money_total")
                ->find();

            foreach($list as &$list_val){
                if(isset($product_list_re[$list_val['goods_id']])){
                    $product_info = $product_list_re[$list_val['goods_id']];
                    //转换商品名字
                    $list_val['product_name'] = $product_info['product_name'];
                    //转换商品类型名字
                    $list_val['product_type_name'] = isset($this->product_types[$product_info['product_type']]) ? $this->product_types[$product_info['product_type']]['name'] : '';
                }
                //单日单商品的总充值金额
                $list_val['money_total'] = round($list_val['money'] * $list_val['num'], 2);
                $list_val['pay_money'] = round($list_val['money'], 2);
                //人数占比（单日单商品的充值人数除以总充值人数）
                $list_val['role_ratio'] = getDivision($list_val['role_num'],$total_data['role_num_total']);
                //金额占比（单日单商品的充值金额除以总充值金额）
                $list_val['money_ratio'] = getDivision($list_val['money_total'],$total_data['money_total']);
            }
        }
        

        $show = $Page->show();
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'product_list'=> $product_list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*玩家充值排行*/
    public function RechargeRanking(){

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $start_time = I('start_time', date('Y-m-d H:i:s', strtotime("-7 day")));
        $end_time = I('end_time', date('Y-m-d H:i:s'));
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        $money_start = I('money_start', '');
        $money_end = I('money_end', '');

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'money_start' => $money_start,
            'money_end' => $money_end,
            'start_time' => $start_time,
            'end_time' => $end_time
        ];

        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        if(empty($start_time) || empty($end_time)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择时间！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $game_data_db = connectionDb($server_info, 'data');         //连接游戏日志库

        $where = $where_having = '1 ';
        $where .= "and recharge.give_state=1 ";
        
        if(!empty($c_son_id)){
            $where .= "and role.place in($c_son_id) ";
        }
        if(!empty($money_start)){
            $where_having .= "and total_money>=" . $money_start * 100 . ' ';
        }
        if(!empty($money_end)){
            $where_having .= "and total_money<=" . $money_end * 100 . ' ';
        }

        $where .= "and recharge.time >=" . strtotime($start_time) . ' ';
        $where .= "and recharge.time <=" . strtotime($end_time) . ' ';

        $count = $game_data_db->table('recharge')
            ->join("LEFT JOIN role on role.id=recharge.rid")
            ->where($where)
            ->group("rid")
            ->having($where_having)
            ->select();
        $count = count($count);
        $Page  = new \Think\Page($count, 50);
        $list = $game_data_db->table('recharge')
            ->field("
                rid,
                role.nick,
                role.user_id,
                role.`level`,
                role.`fighting`,
                role.goddess_vip,
                role.gem,
                from_unixtime(role.create_time/1000,'%Y-%m-%d %H:%i:%s') as create_date,
                from_unixtime(role.last_login_time/1000,'%Y-%m-%d %H:%i:%s') as last_login_date,
                sum(pay_money) as total_money,
                count(distinct from_unixtime(recharge.time,'%Y-%m-%d')) as date_count,
                count(from_unixtime(recharge.time,'%Y-%m-%d')) as total_count")
            ->join("LEFT JOIN role on role.id=recharge.rid")
            ->where($where)
            ->group("rid")
            ->having($where_having)
            ->order("total_money desc")
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        $today_time = strtotime(date("Y-m-d") . "00:00:00");
        $today_end = strtotime(date("Y-m-d") . "23:59:59");
        foreach($list as &$list_val){
            $list_val['total_money'] = sprintf("%.2f", $list_val['total_money']/100);
            //查询角色首充信息
            $role_recharge_first = $game_data_db->table('recharge')
                                ->field("from_unixtime(time,'%Y-%m-%d') as date,pay_money")
                                ->where("give_state=1 and rid=" . $list_val['rid'])
                                ->order("time asc")
                                ->find();
            if($role_recharge_first){
                $list_val['money_first'] = sprintf("%.2f", $role_recharge_first['pay_money']/100);
                $list_val['date_first'] = $role_recharge_first['date'];
            }else{
                $list_val['money_first'] = 0.00;
                $list_val['date_first'] = '';
            }
            //查询角色最后充值信息
            $role_recharge_end = $game_data_db->table('recharge')
                                ->field("from_unixtime(time,'%Y-%m-%d') as date")
                                ->where("give_state=1 and rid=" . $list_val['rid'])
                                ->order("time desc")
                                ->find();
            if($role_recharge_end){
                $list_val['date_end'] = $role_recharge_end['date'];
            }else{
                $list_val['date_end'] = '';
            }

            //查询角色今日充值信息
            $pay_money_today = $game_data_db->table('recharge')
                                ->where("time >=$today_time and time<=$today_end and give_state=1 and rid=" . $list_val['rid'])
                                ->sum('pay_money');
            if($pay_money_today){
                $list_val['pay_money_today'] = sprintf("%.2f", $pay_money_today/100);
            }else{
                $list_val['pay_money_today'] = 0.00;
            }
        }

        $show = $Page->show();
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*首充数据*/
    public function FirstRecharge(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();

        //获取所有的商品
        $product_list = $this->platform_db->table('product')->select();
        $product_list_re = [];
        foreach($product_list as $product_list_val){
            $product_list_re[$product_list_val['id']] = $product_list_val;
        }
        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', date('Y-m-d'));
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);
        $type = I('type', '1');     //1.等级，2.商品

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'type' => $type,
            'start_time' => $start_time,
            'end_time' => $end_time
        ];

        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        //判断时间是否都选择
        if(empty($start_time) || empty($end_time)){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间都必须选择！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        if(date('Y-m', strtotime($start_time)) != date('Y-m', strtotime($end_time))){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间必须是同月！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $this->game_data_db = connectionDb($server_info, 'data');     //连接游戏数据库

        $where = '1 ';
        if(!empty($c_son_id)){
            $where .= "and role.place in($c_son_id) ";
        }
        $where .= "and recharge.give_state=1 ";

        $where_template = "time >=" . strtotime($start_time . ' 00:00:00') . ' ';
        $where_template .= "and time <=" . strtotime($end_time . ' 23:59:59') . ' ';
        $where_template .= "and give_state=1 ";

        if($type == 1){     //1.等级
            $where .= "and recharge.role_lv>1 ";
            $subQuery = $this->game_data_db->table("recharge")
                ->field('
                    rid,role_lv,pay_money
                ')
                ->join("LEFT JOIN role on role.id=recharge.rid")
                ->where($where)
                ->group('recharge.rid')
                ->order('recharge.id ASC')
                ->buildSql();
            $count = $this->game_data_db->table($subQuery . ' tmp')
                ->count("distinct role_lv");
            $Page  = new \Think\Page($count, 20);
            $list = $this->game_data_db->table($subQuery . ' tmp')
                ->field('
                    role_lv,
                    GROUP_CONCAT(rid) as rid_str,
                    count(rid) as num,
                    sum(pay_money) as money
                ')
                ->group('role_lv')
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();
            //计算首充的总人数和总金额
            $total_data = $this->game_data_db->table($subQuery . ' tmp')
                ->field("count(rid) as num_total,sum(pay_money) as money_total")
                ->find();
            foreach($list as &$list_val){
                //首充人数占比（商品的充值人数除以总充值人数）
                $list_val['first_role_ratio'] = getDivision($list_val['num'],$total_data['num_total']);
                //首充金额占比（商品的充值金额除以总充值金额）
                $list_val['first_money_ratio'] = getDivision($list_val['money'],$total_data['money_total']);
            }
            $list[] = [
                'role_lv' => "汇总",
                'num' => $total_data['num_total'],
                'first_role_ratio' => 100,
                'money' => $total_data['money_total'],
                'first_money_ratio' => 100,
            ];
        }else{              //2.商品
            $subQuery = $this->game_data_db->table("recharge")
                ->field('
                    rid,product_id,pay_money
                ')
                ->join("LEFT JOIN role on role.id=recharge.rid")
                ->where($where)
                ->group('recharge.rid')
                ->order('recharge.id ASC')
                ->buildSql();
            $count = $this->game_data_db->table($subQuery . ' tmp')
                ->count("distinct product_id");
            $Page  = new \Think\Page($count, 20);
            $list = $this->game_data_db->table($subQuery . ' tmp')
                ->field('
                    product_id,
                    count(rid) as num,
                    sum(pay_money) as money
                ')
                ->group('product_id')
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();

            //处理每个商品对应的角色id集合
            $list_tmp = $this->game_data_db->table($subQuery . ' tmp')
                ->select();
            $product_rid = [];
            $rid_strs = '';
            foreach($list_tmp as $list_tmp_val){
                $product_rid[$list_tmp_val['product_id']] .= $list_tmp_val['rid'] . ',';
                $rid_strs .= $list_tmp_val['rid'] . ',';
            }
            foreach($product_rid as &$product_rid_val){
                if(!empty($product_rid_val)){
                    $product_rid_val = substr($product_rid_val, 0, -1);
                }
            }
            if(!empty($rid_strs)){
                $rid_strs = substr($rid_strs, 0, -1);
            }

            //计算首充的总人数和总金额
            $total_data = $this->game_data_db->table($subQuery . ' tmp')
                ->field("count(rid) as num_total,sum(pay_money) as money_total")
                ->find();
            if(!empty($rid_strs)){
                $where_aa = $where_template;
                $where_aa .= "and rid in(" . $rid_strs . ") ";
                $again_total = $this->game_data_db->table("recharge")
                    ->field('
                        count(distinct rid) as again_num_total,
                        sum(pay_money) as again_money_total
                    ')
                    ->where($where_aa)
                    ->find();
            }else{
                $again_total = [
                    'again_num_total' => 0,
                    'again_money_total' => 0.00
                ];
            }
            foreach($list as &$list_val){
                if(isset($product_list_re[$list_val['product_id']])){
                    $product_info = $product_list_re[$list_val['product_id']];
                    //转换商品名字
                    $list_val['product_name'] = $product_info['product_name'];
                }else{
                    $list_val['product_name'] = '';
                }
                //首充人数占比（商品的充值人数除以总充值人数）
                $list_val['first_role_ratio'] = getDivision($list_val['num'],$total_data['num_total']);
                //首充金额占比（商品的充值金额除以总充值金额）
                $list_val['first_money_ratio'] = getDivision($list_val['money'],$total_data['money_total']);

                //查询时间范围内再充人数和再充金额
                
                if(isset($product_rid[$list_val['product_id']]) && !empty($product_rid[$list_val['product_id']])){
                    $where_aa = $where_template;
                    $where_aa .= "and rid in(" . $product_rid[$list_val['product_id']] . ") ";
                    $again_info = $this->game_data_db->table("recharge")
                        ->field('
                            count(distinct rid) as again_num,
                            sum(pay_money) as again_money
                        ')
                        ->where($where_aa)
                        ->find();
                    $list_val['again_num'] = $again_info['again_num'];
                    $list_val['again_money'] = $again_info['again_money'];
                }else{
                    $list_val['again_num'] = 0;
                    $list_val['again_money'] = 0.00;
                }
                
                //再充人数占比（商品的充值人数除以总充值人数）
                $list_val['again_role_ratio'] = getDivision($list_val['again_num'], $again_total['again_num_total']);
                //再充金额占比（商品的充值金额除以总充值金额）
                $list_val['again_money_ratio'] = getDivision($list_val['again_money'], $again_total['again_money_total']);
            }
            // exit;
            $list[] = [
                'product_name' => "汇总",
                'num' => $total_data['num_total'],
                'first_role_ratio' => 100,
                'money' => $total_data['money_total'],
                'first_money_ratio' => 100,
                'again_num' => $again_total['again_num_total'],
                'again_role_ratio' => 100,
                'again_money' => $again_total['again_money_total'],
                'again_money_ratio' => 100,
            ];
        }
        

        $show = $Page->show();
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*每日首充统计*/
    public function FirstRechargeDay(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();

        //记录搜索条件
        $now_date = date('Y-m-d');
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        $where = "1 ";
        if(!empty($sid)){
            $where .= "and sid in($sid) ";
        }
        if(!empty($c_son_id)){
            $where .= "and c_son_id in($c_son_id) ";
        }
        if(!empty($start_time)){
            $where .= "and unix_timestamp(date) >=" . strtotime(date('Y-m-d', strtotime($start_time))) . ' ';
        }
        if(!empty($end_time)){
            $where .= "and unix_timestamp(date)<=" . strtotime(date('Y-m-d', strtotime($end_time)) . ' 23:59:59') . ' ';
        }

        $counts = $this->data_analysis_db->table('first_recharge_day')
            ->where($where)
            ->group('date')
            ->select();
        $count = count($counts);
        $Page  = new \Think\Page($count,50);
        $list = $this->data_analysis_db->table('first_recharge_day')
            ->field('
                date,
                sum(first_num) as first_num_total,
                sum(first_money) as first_money_total,
                sum(create_num) as create_num_total,
                sum(create_money) as create_money_total,
                sum(create_role) as create_role_total
            ')
            ->where($where)
            ->group('date')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        //计算汇总数据
        $data_total = $this->data_analysis_db->table('first_recharge_day')
            ->field('
                sum(first_num) as first_num_total,
                sum(first_money) as first_money_total,
                sum(create_num) as create_num_total,
                sum(create_money) as create_money_total,
                sum(create_role) as create_role_total
            ')
            ->where($where)
            ->find();
        $list[] = [
            'date' => '汇总',
            'first_num_total' => $data_total['first_num_total'],
            'first_money_total' => $data_total['first_money_total'],
            'create_num_total' => $data_total['create_num_total'],
            'create_money_total' => $data_total['create_money_total'],
            'create_role_total' => $data_total['create_role_total'],
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

    /**
     * 充值区间统计
     */
    public function RechargeInterval(){
        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();
        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $operate_type = I('operate_type', '1');
        $type = I('type', '0');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', date('Y-m-d'));
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'operate_type' => $operate_type,
            'type' => $type,
            'start_time' => $start_time,
            'end_time' => $end_time
        ];

        $where = '1 ';
        $where .= "and recharge.status=3 ";
        
        if(!empty($c_son_id)){
            $where .= "and us.c_son_id in($c_son_id) ";
        }
        if(!empty($sid)){
            $where .= "and recharge.sid in($sid) ";
        }

        $where .= "and recharge.created_at >=" . strtotime($start_time) . ' ';
        $where .= "and recharge.created_at <=" . strtotime($end_time . ' 23:59:59') . ' ';

        if($operate_type == 1){     //汇总，以充值区间为主来统计
            $subQuery = $this->platform_db->table('recharge')
                ->field('
                    recharge.role_id,count(recharge.role_id) as count,sum(recharge.money) as money
                ')
                ->join("LEFT JOIN user_server as us on us.role_id=recharge.role_id")
                ->where($where)
                ->group('recharge.role_id')
                ->buildSql();

            $datas = $this->platform_db->table($subQuery . ' tmp')
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
            
            $total_data = $this->platform_db->table($subQuery . ' tmp')
                ->field('
                    count(role_id) as roles,sum(count) as nums,sum(money) as moneys
                ')
                ->find();
            $list = [];
            foreach($this->recharge_type as $recharge_type_key=>$recharge_type_val){
                if(!empty($type)){
                    if($recharge_type_key == $type){
                        $list[] = [
                            'name' => $recharge_type_val['name'],
                            'roles' => $datas[$recharge_type_val['field'] . '_roles'],
                            'roles_ratio' => 100,
                            'nums' => $datas[$recharge_type_val['field'] . '_nums'],
                            'moneys' => $datas[$recharge_type_val['field'] . '_moneys'],
                            'moneys_ratio' => 100,
                            'moneys_avg' => getDivisionSpecial($datas[$recharge_type_val['field'] . '_moneys'],$datas[$recharge_type_val['field'] . '_roles']),
                        ];
                    }
                }else{
                    $list[] = [
                        'name' => $recharge_type_val['name'],
                        'roles' => $datas[$recharge_type_val['field'] . '_roles'],
                        'roles_ratio' => getDivision($datas[$recharge_type_val['field'] . '_roles'],$total_data['roles']),
                        'nums' => $datas[$recharge_type_val['field'] . '_nums'],
                        'moneys' => $datas[$recharge_type_val['field'] . '_moneys'],
                        'moneys_ratio' => getDivision($datas[$recharge_type_val['field'] . '_moneys'],$total_data['moneys']),
                        'moneys_avg' => getDivisionSpecial($datas[$recharge_type_val['field'] . '_moneys'],$datas[$recharge_type_val['field'] . '_roles']),
                    ];
                }
                
            }
            $count = count($list);
            $Page  = new \Think\Page($count, 50);
            if(!empty($type)){
                $list[] = [
                    'name' =>'汇总',
                    'roles' => $list[0]['roles'],
                    'roles_ratio' => 100,
                    'nums' => $list[0]['nums'],
                    'moneys' => $list[0]['moneys'],
                    'moneys_ratio' => 100,
                    'moneys_avg' => getDivisionSpecial($list[0]['moneys'],$list[0]['roles']),
                ];
            }else{
                $list[] = [
                    'name' =>'汇总',
                    'roles' => $total_data['roles'],
                    'roles_ratio' => 100,
                    'nums' => $total_data['nums'],
                    'moneys' => $total_data['moneys'],
                    'moneys_ratio' => 100,
                    'moneys_avg' => getDivisionSpecial($total_data['moneys'],$total_data['roles']),
                ];
            }
            
            
        }else{              //日期，以日期和充值区间为主来统计
            $subQuery = $this->platform_db->table('recharge')
                ->field("
                    from_unixtime(recharge.created_at,'%Y-%m-%d') as date,recharge.role_id,count(recharge.role_id) as count,sum(recharge.money) as money
                ")
                ->join("LEFT JOIN user_server as us on us.role_id=recharge.role_id")
                ->where($where)
                ->group('recharge.role_id')
                ->buildSql();
            $subQuerys = $this->platform_db->table($subQuery . ' aa')
                ->field('
                    CASE 
                    WHEN money>=1 and money<=10 THEN 1
                    WHEN money>=11 and money<=30 THEN 2
                    WHEN money>=31 and money<=50 THEN 3
                    WHEN money>=51 and money<=100 THEN 4
                    WHEN money>=101 and money<=200 THEN 5
                    WHEN money>=201 and money<=500 THEN 6
                    WHEN money>=501 and money<=1000 THEN 7
                    WHEN money>=1001 and money<=2000 THEN 8
                    WHEN money>=2001 and money<=3000 THEN 9
                    WHEN money>=3001 and money<=5000 THEN 10
                    WHEN money>=5001 and money<=8000 THEN 11
                    WHEN money>=8001 and money<=10000 THEN 12
                    WHEN money>=10001 THEN 13
                    else 0
                    END as type,date,role_id,count,money
                ')
                ->buildSql();
            $where_list = "1 ";
            if(!empty($type)){
                $where_list .= "and tmp.type=$type";
            }
            $count = $this->platform_db->table($subQuerys . ' tmp')
                ->field("*")
                ->where($where_list)
                ->group("date,type")
                ->select();

            $count = count($count);
            $Page  = new \Think\Page($count, 50);
            $list = $this->platform_db->table($subQuerys . ' tmp')
                ->field("*,count(tmp.role_id) as roles,sum(tmp.count) as nums,sum(tmp.money) as moneys")
                ->where($where_list)
                ->group("date,type")
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();

            //计算总充值和总人数
            $total_data = $this->platform_db->table($subQuerys . ' tmp')
                ->field("count(tmp.role_id) as roles,sum(tmp.count) as nums,sum(tmp.money) as moneys")
                ->where($where_list)
                ->find();

            foreach($list as &$list_val){
                $list_val = [
                    'date' => $list_val['date'],
                    'name' => isset($this->recharge_type[$list_val['type']]) ? $this->recharge_type[$list_val['type']]['name'] : '',
                    'roles' => $list_val['roles'],
                    'roles_ratio' => getDivision($list_val['roles'],$total_data['roles']),
                    'nums' => $list_val['nums'],
                    'moneys' => $list_val['moneys'],
                    'moneys_ratio' => getDivision($list_val['moneys'],$total_data['moneys']),
                    'moneys_avg' => getDivisionSpecial($list_val['moneys'],$list_val['roles']),
                ];
            }
            $list[] = [
                'date' =>'汇总',
                'name' =>'',
                'roles' => $total_data['roles'],
                'roles_ratio' => 100,
                'nums' => $total_data['nums'],
                'moneys' => $total_data['moneys'],
                'moneys_ratio' => 100,
                'moneys_avg' => getDivisionSpecial($total_data['moneys'],$total_data['roles']),
            ];
        }

        $show = $Page->show();
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'recharge_type' => $this->recharge_type, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /**
     * 分区开服天数充值
     */
    public function ServerRechargeDay(){

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();
        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $type = I('type', '1'); //统计内容：1.累积充值，2.充值人数，3.付费率，4.arppu，5.arpu

        // echo 11;exit;
        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'type' => $type,
        ];
        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        $sid_arr = explode(',', $sid);
        if(count($sid_arr) > 10){
            $this->assign(['list'=>[], 'error_msg'=> '服务器选择在10个以内！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        $where = '1 ';
        // $where .= "and recharge.status=3 ";
        
        if(!empty($c_son_id)){
            $where .= "and place in($c_son_id) ";
        }
        // if(!empty($sid)){
        //     $where .= "and recharge.sid=$sid ";
        // }

        // $where .= "and recharge.created_at >=" . strtotime($start_time) . ' ';
        // $where .= "and recharge.created_at <=" . strtotime($end_time . ' 23:59:59') . ' ';
        $server_data = $this->platform_db->table('server')->where("id in($sid)")->select();

        $list = [];
        $list_tilte = ['开服天数'];
        foreach($server_data as $server_val){
            for($i=1; $i<=60; $i++){
                $list[$i][$server_val['id']] = '';
            }
            //数据的title
            $list_tilte[] = $server_val['server_name'];
            $game_data_db = connectionDb($server_val, 'data');     //连接游戏数据库
            $game_log_db = connectionDb($server_val, 'log');        //连接游戏日志库
            $start_time = strtotime(date('y-m-d', $server_val['open_time']));
            $end_time = $start_time + (60 * 86400);
            $where_recharge = $where;
            $where_recharge .= "and give_state=1 and time>=$start_time and time<$end_time";
            $recharge_data = $game_data_db->table('recharge')
                ->field("
                    from_unixtime(recharge.time,'%Y-%m-%d') as date,sum(recharge.pay_money) as money,count(distinct recharge.rid) as role_num
                ")
                ->join("LEFT JOIN role on role.id=recharge.rid")
                ->where($where_recharge)
                ->group('date')
                ->select();

            foreach($recharge_data as $recharge_val){
                $total_money = !empty($recharge_val['money']) ? $recharge_val['money']/100 : '0.00';
                $total_money = sprintf("%.2f", $total_money);
                $total_role_num = !empty($recharge_val['role_num']) ? $recharge_val['role_num'] : '0';
                if($type == 1){     //累积充值
                    $day_after = (strtotime($recharge_val['date']) - strtotime(date('y-m-d', $server_val['open_time'])))/86400 + 1;
                    $list[$day_after][$server_val['id']] = $total_money;
                }elseif($type == 2){    //充值人数
                    $day_after = (strtotime($recharge_val['date']) - strtotime(date('Y-m-d', $server_val['open_time'])))/86400 + 1;
                    $list[$day_after][$server_val['id']] = $total_role_num;
                }elseif($type == 3){    //付费率--总付费人数/总登陆人数
                    //查询登陆人数
                    $where_login = $where;
                    $where_login .= "and login_time>=$start_time and login_time<$end_time";
                    $table = 'role_login_log' . getLogTable('month', $recharge_val['date']);
                    $login_num = $game_log_db->table($table)
                        ->field('id')
                        ->where($where_login)
                        ->count("distinct rid");

                    $day_after = (strtotime($recharge_val['date']) - strtotime(date('Y-m-d', $server_val['open_time'])))/86400 + 1;
                    $list[$day_after][$server_val['id']] = getDivision($total_role_num, $login_num) . '%';
                }elseif($type == 4){    //arppu--总付费/总付费人数
                    $day_after = (strtotime($recharge_val['date']) - strtotime(date('Y-m-d', $server_val['open_time'])))/86400 + 1;
                    $list[$day_after][$server_val['id']] = getDivisionSpecial($total_money, $total_role_num);
                }elseif($type == 5){    //arpu--总付费/总登陆人数
                    //查询登陆人数
                    $where_login = $where;
                    $where_login .= "and login_time>=$start_time and login_time<$end_time";
                    $table = 'role_login_log' . getLogTable('month', $recharge_val['date']);
                    $login_num = $game_log_db->table($table)
                        ->field('id')
                        ->where($where_login)
                        ->count("distinct rid");

                    $day_after = (strtotime($recharge_val['date']) - strtotime(date('Y-m-d', $server_val['open_time'])))/86400 + 1;
                    $list[$day_after][$server_val['id']] = getDivisionSpecial($total_money, $login_num);
                }
            }
        }
        $this->assign(['list'=>$list, 'list_tilte'=>$list_tilte, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }


}
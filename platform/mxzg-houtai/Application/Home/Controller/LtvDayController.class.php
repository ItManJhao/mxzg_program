<?php
namespace Home\Controller;

use Think\Controller;

/*
 * Ltv统计
 */
class LtvDayController extends PublicController{
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
                    echo '渠道--' . $channel_val['name'] . '，区服--' . $server_val['server_name'] . '，留存开始处理';
                    echo PHP_EOL;
                    //获取每日基本数据，并保存数据
                    $day_data_res =  $this->day_data($server_val, $channel_val['id'], $channel_val['parent_id']);
                    var_dump($day_data_res);
                    echo PHP_EOL;
                    //处理充值留存
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
     */
    public function day_data($server_val, $channel_id, $parent_channel_id){
        $sid = $server_val['id'];
        $start_time = $this->start_time;
        $end_time = $this->end_time;
        // $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库
        $this->game_data_db = connectionDb($server_val, 'data');     //连接游戏数据库

        //2.处理创角数据
        //获取创角数
//        $role_num = $this->platform_db->table('user_server')
//            ->alias('us')
//            ->join("left join user on user.id=us.user_id")
//            ->where("user.c_son_id=$channel_id and us.sid=" . $sid . " and us.created_at>=$start_time and us.created_at<=$end_time ")
//            ->count();
        $start_time_micro = $start_time*1000;
        $end_time_micro = $end_time*1000 + 999;
        $create_role = $this->game_data_db->table('role')
            ->where("place=$channel_id and create_time>=$start_time_micro and create_time<=$end_time_micro")
            ->count();
        // $create_role = count($role_ids);   //创角数
        // if(!empty($role_ids)){
        //     $role_ids = implode(',', $role_ids);
        // }else{
        //     $role_ids = '';
        // }

        // $create_role_ids = $role_ids;
        $ltv_day_info = $this->data_analysis_db->table('ltv_day')
            ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}'")
            ->find();
        
        $table = 'recharge';
        //获取当天创角的充值金额
        $add_money = $this->game_data_db->table('role')
            ->join("left join $table as aa on aa.rid=role.id")
            ->where("role.place=$channel_id and role.create_time>=$start_time_micro and role.create_time<=$end_time_micro
                and aa.give_state=1 and aa.time>=$start_time and aa.time<=$end_time ")
            ->sum('aa.pay_money');
        if(!empty($add_money)){
            $add_money = sprintf("%.2f", $add_money/100);
        }else{
            $add_money = 0.00;
        }
        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'date' => $this->date,
            'create_role' => $create_role,
            'add_money' => $add_money,
            // 'role_ids' => $role_ids,
            'updated_at' => time()
        ];
        if($ltv_day_info){    //修改
            $res = $this->data_analysis_db->table('ltv_day')->where("id=" . $ltv_day_info['id'])->save($day_data);
        }else{                      //添加
            $day_data['created_at'] = time();
            $res = $this->data_analysis_db->table('ltv_day')->add($day_data);
        }

        return 1;
    }

    /**
     * @desc 查询当日对应的留存
     * @param $server_val
     */
    protected function doRetain($server_val, $channel_id){
        $sid = $server_val['id'];
        // $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库

        //处理当天的充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 0, 'one_day_money');
        echo $sid . '--1日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天的昨日的2日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 1, 'two_day_money');
        echo $sid . '--2日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第三天的3日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 2, 'three_day_money');
        echo $sid . '--3日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第四天的4日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 3, 'four_day_money');
        echo $sid . '--4日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第5天的5日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 4, 'five_day_money');
        echo $sid . '--5日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第6天的6日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 5, 'six_day_money');
        echo $sid . '--6日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第7天的7日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 6, 'seven_day_money');
        echo $sid . '--7日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第8天的8日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 7, 'eight_day_money');
        echo $sid . '--8日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第9天的9日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 8, 'nine_day_money');
        echo $sid . '--9日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第10天的10日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 9, 'ten_day_money');
        echo $sid . '--10日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第11天的11日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 10, 'eleven_day_money');
        echo $sid . '--11日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第12天的12日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 11, 'twelve_day_money');
        echo $sid . '--12日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第13天的13日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 12, 'thirteen_day_money');
        echo $sid . '--13日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第14天的14日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 13, 'fourteen_day_money');
        echo $sid . '--14日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第15天的15日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 14, 'fifteen_day_money');
        echo $sid . '--15日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第16天的16日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 15, 'sixteen_day_money');
        echo $sid . '--16日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第17天的17日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 16, 'seventeen_day_money');
        echo $sid . '--17日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第18天的18日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 17, 'eighteen_day_money');
        echo $sid . '--18日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第19天的19日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 18, 'nineteen_day_money');
        echo $sid . '--19日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第20天的20日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 19, 'twenty_day_money');
        echo $sid . '--20日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第21天的21日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 20, 'twenty_one_day_money');
        echo $sid . '--21日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第22天的22日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 21, 'twenty_two_day_money');
        echo $sid . '--22日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第23天的23日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 22, 'twenty_three_day_money');
        echo $sid . '--23日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第24天的24日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 23, 'twenty_four_day_money');
        echo $sid . '--24日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第25天的25日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 24, 'twenty_five_day_money');
        echo $sid . '--25日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第26天的26日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 25, 'twenty_six_day_money');
        echo $sid . '--26日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第27天的27日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 26, 'twenty_seven_day_money');
        echo $sid . '--27日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第28天的28日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 27, 'twenty_eight_day_money');
        echo $sid . '--28日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第29天的29日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 28, 'twenty_nine_day_money');
        echo $sid . '--29日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第30天的30日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 29, 'thirty_day_money');
        echo $sid . '--30日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第31天的31日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 30, 'thirty_one_day_money');
        echo $sid . '--31日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第32天的32日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 31, 'thirty_two_day_money');
        echo $sid . '--32日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第33天的33日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 32, 'thirty_three_day_money');
        echo $sid . '--33日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第34天的34日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 33, 'thirty_four_day_money');
        echo $sid . '--34日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第35天的35日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 34, 'thirty_five_day_money');
        echo $sid . '--35日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第36天的36日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 35, 'thirty_six_day_money');
        echo $sid . '--36日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第37天的37日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 36, 'thirty_seven_day_money');
        echo $sid . '--37日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第38天的38日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 37, 'thirty_eight_day_money');
        echo $sid . '--38日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第39天的39日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 38, 'thirty_nine_day_money');
        echo $sid . '--39日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第40天的40日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 39, 'forty_day_money');
        echo $sid . '--40日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第41天的41日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 40, 'forty_one_day_money');
        echo $sid . '--41日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第42天的42日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 41, 'forty_two_day_money');
        echo $sid . '--42日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第43天的43日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 42, 'forty_three_day_money');
        echo $sid . '--43日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第44天的44日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 43, 'forty_four_day_money');
        echo $sid . '--44日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第45天的45日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 44, 'forty_five_day_money');
        echo $sid . '--45日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第46天的46日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 45, 'forty_six_day_money');
        echo $sid . '--46日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第47天的47日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 46, 'forty_seven_day_money');
        echo $sid . '--47日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第48天的48日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 47, 'forty_eight_day_money');
        echo $sid . '--48日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第49天的49日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 48, 'forty_nine_day_money');
        echo $sid . '--49日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第50天的50日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 49, 'fifty_day_money');
        echo $sid . '--50日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第51天的51日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 50, 'fifty_one_day_money');
        echo $sid . '--51日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第52天的52日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 51, 'fifty_two_day_money');
        echo $sid . '--52日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第53天的53日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 52, 'fifty_three_day_money');
        echo $sid . '--53日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第54天的54日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 53, 'fifty_four_day_money');
        echo $sid . '--54日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第55天的55日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 54, 'fifty_five_day_money');
        echo $sid . '--55日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第56天的56日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 55, 'fifty_six_day_money');
        echo $sid . '--56日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第57天的57日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 56, 'fifty_seven_day_money');
        echo $sid . '--57日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第58天的58日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 57, 'fifty_eight_day_money');
        echo $sid . '--58日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第59天的59日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 58, 'fifty_nine_day_money');
        echo $sid . '--59日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第60天的60日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 59, 'sixty_day_money');
        echo $sid . '--60日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第61天的61日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 60, 'sixty_one_day_money');
        echo $sid . '--61日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第62天的62日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 61, 'sixty_two_day_money');
        echo $sid . '--62日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第63天的63日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 62, 'sixty_three_day_money');
        echo $sid . '--63日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第64天的64日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 63, 'sixty_four_day_money');
        echo $sid . '--64日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第65天的65日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 64, 'sixty_five_day_money');
        echo $sid . '--65日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第66天的66日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 65, 'sixty_six_day_money');
        echo $sid . '--66日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第67天的67日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 66, 'sixty_seven_day_money');
        echo $sid . '--67日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第68天的68日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 67, 'sixty_eight_day_money');
        echo $sid . '--68日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第69天的69日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 68, 'sixty_nine_day_money');
        echo $sid . '--69日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第70天的70日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 69, 'seventy_day_money');
        echo $sid . '--70日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第71天的71日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 70, 'seventy_one_day_money');
        echo $sid . '--71日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第72天的72日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 71, 'seventy_two_day_money');
        echo $sid . '--72日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第73天的73日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 72, 'seventy_three_day_money');
        echo $sid . '--73日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第74天的74日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 73, 'seventy_four_day_money');
        echo $sid . '--74日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第75天的75日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 74, 'seventy_five_day_money');
        echo $sid . '--75日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第76天的76日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 75, 'seventy_six_day_money');
        echo $sid . '--76日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第77天的77日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 76, 'seventy_seven_day_money');
        echo $sid . '--77日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第78天的78日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 77, 'seventy_eight_day_money');
        echo $sid . '--78日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第79天的79日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 78, 'seventy_nine_day_money');
        echo $sid . '--79日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第80天的80日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 79, 'eighty_day_money');
        echo $sid . '--80日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第81天的81日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 80, 'eighty_one_day_money');
        echo $sid . '--81日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第82天的82日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 81, 'eighty_two_day_money');
        echo $sid . '--82日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第83天的83日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 82, 'eighty_three_day_money');
        echo $sid . '--83日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第84天的84日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 83, 'eighty_four_day_money');
        echo $sid . '--84日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第85天的85日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 84, 'eighty_five_day_money');
        echo $sid . '--85日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第86天的86日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 85, 'eighty_six_day_money');
        echo $sid . '--86日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第87天的87日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 86, 'eighty_seven_day_money');
        echo $sid . '--87日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第88天的88日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 87, 'eighty_eight_day_money');
        echo $sid . '--88日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第89天的89日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 88, 'eighty_nine_day_money');
        echo $sid . '--89日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第90天的90日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 89, 'ninety_day_money');
        echo $sid . '--90日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第91天的91日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 90, 'ninety_one_day_money');
        echo $sid . '--91日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第92天的92日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 91, 'ninety_two_day_money');
        echo $sid . '--92日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第93天的93日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 92, 'ninety_three_day_money');
        echo $sid . '--93日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第94天的94日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 93, 'ninety_four_day_money');
        echo $sid . '--94日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第95天的95日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 94, 'ninety_five_day_money');
        echo $sid . '--95日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第96天的96日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 95, 'ninety_six_day_money');
        echo $sid . '--96日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第97天的97日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 96, 'ninety_seven_day_money');
        echo $sid . '--97日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第98天的98日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 97, 'ninety_eight_day_money');
        echo $sid . '--98日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第99天的99日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 98, 'ninety_nine_day_money');
        echo $sid . '--99日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第100天的100日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 99, 'hundred_day_money');
        echo $sid . '--100日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第101天的101日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 100, 'hundred_one_day_money');
        echo $sid . '--101日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第102天的102日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 101, 'hundred_two_day_money');
        echo $sid . '--102日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第103天的103日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 102, 'hundred_three_day_money');
        echo $sid . '--103日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第104天的104日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 103, 'hundred_four_day_money');
        echo $sid . '--104日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第105天的105日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 104, 'hundred_five_day_money');
        echo $sid . '--105日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第106天的106日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 105, 'hundred_six_day_money');
        echo $sid . '--106日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第107天的107日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 106, 'hundred_seven_day_money');
        echo $sid . '--107日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第108天的108日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 107, 'hundred_eight_day_money');
        echo $sid . '--108日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面109天的109日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 108, 'hundred_nine_day_money');
        echo $sid . '-109日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第110天的110日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 109, 'hundred_ten_day_money');
        echo $sid . '--110日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第111天的111日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 110, 'hundred_eleven_day_money');
        echo $sid . '--111日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第112天的112日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 111, 'hundred_twelve_day_money');
        echo $sid . '-112日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第113天的113日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 112, 'hundred_thirteen_day_money');
        echo $sid . '--113日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第114天的114日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 113, 'hundred_fourteen_day_money');
        echo $sid . '--114日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第115天的115日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 114, 'hundred_fifteen_day_money');
        echo $sid . '--115日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第116天的116日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 115, 'hundred_sixteen_day_money');
        echo $sid . '--116日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第117天的117日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 116, 'hundred_seventeen_day_money');
        echo $sid . '--117日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第118天的118日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 117, 'hundred_eighteen_day_money');
        echo $sid . '--118日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第119天的119日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 118, 'hundred_nineteen_day_money');
        echo $sid . '--119日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第120天的120日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 119, 'hundred_twenty_day_money');
        echo $sid . '-120日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第121天的121日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 120, 'hundred_twenty_one_day_money');
        echo $sid . '--121日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第122天的122日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 121, 'hundred_twenty_two_day_money');
        echo $sid . '--122日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第123天的123日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 122, 'hundred_twenty_three_day_money');
        echo $sid . '--123日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第124天的124日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 123, 'hundred_twenty_four_day_money');
        echo $sid . '-124日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第125天的125日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 124, 'hundred_twenty_five_day_money');
        echo $sid . '--125日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第126天的126日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 125, 'hundred_twenty_six_day_money');
        echo $sid . '--126日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第127天的127日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 126, 'hundred_twenty_seven_day_money');
        echo $sid . '--127日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面128天的128日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 127, 'hundred_twenty_eight_day_money');
        echo $sid . '--128日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第129天的129日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 128, 'hundred_twenty_nine_day_money');
        echo $sid . '--129日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第130天的130日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 129, 'hundred_thirty_day_money');
        echo $sid . '--130日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第131天的131日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 130, 'hundred_thirty_one_day_money');
        echo $sid . '--131日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第132天的132日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 131, 'hundred_thirty_two_day_money');
        echo $sid . '--132日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第133天133日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 132, 'hundred_thirty_three_day_money');
        echo $sid . '--133日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第134天的134日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 133, 'hundred_thirty_four_day_money');
        echo $sid . '--134日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第135天的135日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 134, 'hundred_thirty_five_day_money');
        echo $sid . '--135日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第136天的136日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 135, 'hundred_thirty_six_day_money');
        echo $sid . '--136日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第137天的137日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 136, 'hundred_thirty_seven_day_money');
        echo $sid . '--137日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第138天的138日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 137, 'hundred_thirty_eight_day_money');
        echo $sid . '--138日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第139天的139日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 138, 'hundred_thirty_nine_day_money');
        echo $sid . '-139日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第140天的140日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 139, 'hundred_forty_day_money');
        echo $sid . '--140日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第141天的141日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 140, 'hundred_forty_one_day_money');
        echo $sid . '--141日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第142天的142日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 141, 'hundred_forty_two_day_money');
        echo $sid . '--142日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第143天的143日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 142, 'hundred_forty_three_day_money');
        echo $sid . '--143日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第144天的144日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 143, 'hundred_forty_four_day_money');
        echo $sid . '--144日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第145天的145日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 144, 'hundred_forty_five_day_money');
        echo $sid . '--145日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第146天的146日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 145, 'hundred_forty_six_day_money');
        echo $sid . '--146日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第147天的147日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 146, 'hundred_forty_seven_day_money');
        echo $sid . '--147日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第148天的148日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 147, 'hundred_forty_eight_day_money');
        echo $sid . '--148日充值金额---' . $channel_id . $retain_res . PHP_EOL;
        
        //处理当天前面第149天的149日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 148, 'hundred_forty_nine_day_money');
        echo $sid . '--149日充值金额---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第150天150日充值金额
        $retain_res = $this->getRetain($sid, $channel_id, 149, 'hundred_fifty_day_money');
        echo $sid . '--150日充值金额---' . $channel_id . $retain_res . PHP_EOL;


        return 'money--ok';
    }

    protected function getRetain($sid, $channel_id, $days, $update_field){
        $one_day_date = date('Y-m-d', strtotime($this->date) - $days * 86400);  //需要处理数据的日期
        $start_time = strtotime($one_day_date);     //需要处理日期的凌晨0：00的时间戳
        $end_time = $start_time + 86399;    //结束时间戳
        $start_time_micro = $start_time*1000;
        $end_time_micro = $end_time*1000 + 999;

        $ltv_day_info = $this->data_analysis_db->table('ltv_day')
            ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}'")
            ->find();
        if($ltv_day_info){     //数据存在，计算留存
            if(!empty($ltv_day_info['create_role'])){

                $table = 'recharge';
                //获取创角的登录数
                $money = $this->game_data_db->table('role')
                    ->join("left join $table as aa on aa.rid=role.id")
                    ->where("role.place=$channel_id and role.create_time>=$start_time_micro and role.create_time<=$end_time_micro
                        and aa.give_state=1 and aa.time>=$start_time and aa.time<=$this->end_time ")
                    ->sum('aa.pay_money');
                if(empty($money)){
                    $money = "0.00";
                }else{
                    $money = sprintf("%.2f", $money/100);
                }
            }else{
                $money = '0.00';   //当天的昨天的次日留存
            }

            //修改数据
            $data_update = [
                $update_field => $money,
                'updated_at' => time()
            ];
            $up_res = $this->data_analysis_db->table('ltv_day')
                ->where("id=" . $ltv_day_info['id'])
                ->save($data_update);
        }

        return '处理留存完成';
    }

}
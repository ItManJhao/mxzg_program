<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 每日留存
 */
class RetainDayController extends PublicController{
    protected $game_log_db;

    /**
     * 查询要处理的数据入口
     */
    public function entry(){
        ini_set('memory_limit','512M'); //临时提高内存
        
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
            $register_user_ids = $this->platform_db->table('user')
            ->where("c_son_id=" . $channel_val['id'] . " and created_at>=$this->start_time and created_at<=$this->end_time ")
            ->getField('id',true);
            
            foreach($servers as $server_val){
                if($this->start_time >= strtotime(date('Y-m-d', $server_val['open_time']))){
                    echo '渠道--' . $channel_val['name'] . '，区服--' . $server_val['server_name'] . '，留存开始处理';
                    echo PHP_EOL;
                    //获取每日基本数据，并保存数据
                    $day_data_res =  $this->day_data($server_val, $channel_val['id'], $channel_val['parent_id'], $register_user_ids, $this->start_time, $this->end_time);
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
     * @param $register_user_ids string 注册用户id集
     * @param $start_time int 开始时间戳
     * @param $end_time int 结束时间戳
     */
    public function day_data($server_val, $channel_id, $parent_channel_id, $register_user_ids, $start_time, $end_time){
        $sid = $server_val['id'];
        $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库

        //1.处理注册数据
        $register_num = count($register_user_ids);   //注册数
        if(!empty($register_user_ids)){
            $role_ids = implode(',', $register_user_ids);
        }else{
            $role_ids = '';
        }

        $retain_day_info = $this->data_analysis_db->table('retain_day')
            ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}' and retain_type=1")
            ->find();

        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'date' => $this->date,
            'retain_type' => 1,
            'num' => $register_num,
            'role_ids' => $role_ids,
            'updated_at' => time()
        ];
        if($retain_day_info){    //修改
            $res = $this->data_analysis_db->table('retain_day')->where("id=" . $retain_day_info['id'])->save($day_data);
        }else{                      //添加
            $day_data['created_at'] = time();
            $res = $this->data_analysis_db->table('retain_day')->add($day_data);
        }

        //2.处理创角数据
        //获取创角数
//        $role_num = $this->platform_db->table('user_server')
//            ->alias('us')
//            ->join("left join user on user.id=us.user_id")
//            ->where("user.c_son_id=$channel_id and us.sid=" . $sid . " and us.created_at>=$start_time and us.created_at<=$end_time ")
//            ->count();
        $role_ids = $this->game_log_db->table('role_create_log')
            ->where("place=$channel_id and create_time>=$start_time and create_time<=$end_time")
            ->getField('rid',true);
        $num = count($role_ids);   //创角数
        if(!empty($role_ids)){
            $role_ids = implode(',', $role_ids);
        }else{
            $role_ids = '';
        }
        $create_role_ids = $role_ids;
        $retain_day_info = $this->data_analysis_db->table('retain_day')
            ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}' and retain_type=2")
            ->find();

        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'date' => $this->date,
            'retain_type' => 2,
            'num' => $num,
            'role_ids' => $role_ids,
            'updated_at' => time()
        ];
        if($retain_day_info){    //修改
            $res = $this->data_analysis_db->table('retain_day')->where("id=" . $retain_day_info['id'])->save($day_data);
        }else{                      //添加
            $day_data['created_at'] = time();
            $res = $this->data_analysis_db->table('retain_day')->add($day_data);
        }

        //3.处理付费数据
        $role_ids = $this->platform_db->table('recharge')
            ->field('recharge.role_id')
            ->join("left join user_server as us on us.role_id=recharge.role_id")
            ->where("us.c_son_id=$channel_id and recharge.sid=" . $sid . " and recharge.status=3 and recharge.updated_at>=$start_time and recharge.updated_at<=$end_time ")
            ->group('recharge.role_id')
            ->select();
        $num = count($role_ids);   //付费数
        if(!empty($role_ids)){
            $role_ids = implode(',', array_column($role_ids, 'role_id'));
        }else{
            $role_ids = '';
        }
        $retain_day_info = $this->data_analysis_db->table('retain_day')
            ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}' and retain_type=3")
            ->find();

        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'date' => $this->date,
            'retain_type' => 3,
            'num' => $num,
            'role_ids' => $role_ids,
            'updated_at' => time()
        ];
        if($retain_day_info){    //修改
            $res = $this->data_analysis_db->table('retain_day')->where("id=" . $retain_day_info['id'])->save($day_data);
        }else{                      //添加
            $day_data['created_at'] = time();
            $res = $this->data_analysis_db->table('retain_day')->add($day_data);
        }

        //4.处理新增付费数据
        $role_ids = $this->platform_db->table('recharge')
            ->field('recharge.role_id')
            ->where("sid=" . $sid . " and status=3 and updated_at>=$start_time and updated_at<=$end_time 
                    and role_id in (
                    select role_id from user_server as us 
                    where us.c_son_id=$channel_id and us.sid=" . $sid . " and us.created_at>=$start_time and us.created_at<=$end_time 
                    )
                    ")
            ->group('role_id')
            ->select();
        $num = count($role_ids);   //新增付费数
        if(!empty($role_ids)){
            $role_ids = implode(',', array_column($role_ids, 'role_id'));
        }else{
            $role_ids = '';
        }
        $retain_day_info = $this->data_analysis_db->table('retain_day')
            ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}' and retain_type=4")
            ->find();

        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'date' => $this->date,
            'retain_type' => 4,
            'num' => $num,
            'role_ids' => $role_ids,
            'updated_at' => time()
        ];
        if($retain_day_info){    //修改
            $res = $this->data_analysis_db->table('retain_day')->where("id=" . $retain_day_info['id'])->save($day_data);
        }else{                      //添加
            $day_data['created_at'] = time();
            $res = $this->data_analysis_db->table('retain_day')->add($day_data);
        }

        //5.处理老用户数据
        $table = 'role_login_log' . getLogTable('month', $this->date);
        if(!empty($create_role_ids)){
            $role_ids = $this->game_log_db->table($table)
                ->where("place=$channel_id and login_time>=$start_time and login_time<=$end_time 
                    and rid not in ($create_role_ids)
                    ")
                ->group('rid')
                ->getField('rid',true);
        }else{
            $role_ids = $this->game_log_db->table($table)
                ->where("place=$channel_id and login_time>=$start_time and login_time<=$end_time ")
                ->group('rid')
                ->getField('rid',true);
        }
        $num = count($role_ids);   //老用户数
        if(!empty($role_ids)){
            $role_ids = implode(',', $role_ids);
        }else{
            $role_ids = '';
        }
        $retain_day_info = $this->data_analysis_db->table('retain_day')
            ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}' and retain_type=5")
            ->find();

        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'date' => $this->date,
            'retain_type' => 5,
            'num' => $num,
            'role_ids' => $role_ids,
            'updated_at' => time()
        ];
        if($retain_day_info){    //修改
            $res = $this->data_analysis_db->table('retain_day')->where("id=" . $retain_day_info['id'])->save($day_data);
        }else{                      //添加
            $day_data['created_at'] = time();
            $res = $this->data_analysis_db->table('retain_day')->add($day_data);
        }

        //6.设备数
        $num = $this->game_log_db->table('role_create_log')
            ->where("place=$channel_id and create_time>=$start_time and create_time<=$end_time ")
            ->count('distinct device_id');

        $retain_day_info = $this->data_analysis_db->table('retain_day')
            ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}' and retain_type=6")
            ->find();

        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'date' => $this->date,
            'retain_type' => 6,
            'num' => $num,
            'role_ids' => '',
            'updated_at' => time()
        ];
        if($retain_day_info){    //修改
            $res = $this->data_analysis_db->table('retain_day')->where("id=" . $retain_day_info['id'])->save($day_data);
        }else{                      //添加
            $day_data['created_at'] = time();
            $res = $this->data_analysis_db->table('retain_day')->add($day_data);
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
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 1, 'one_day_num');
        echo $sid . '--次日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第三天的3日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 2, 'three_day_num');
        echo $sid . '--3日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第四天的4日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 3, 'four_day_num');
        echo $sid . '--4日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第五天的5日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 4, 'five_day_num');
        echo $sid . '--5日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第六天的6日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 5, 'six_day_num');
        echo $sid . '--6日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第7天的7日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 6, 'seven_day_num');
        echo $sid . '--7日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第8天的8日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 7, 'eight_day_num');
        echo $sid . '--8日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第9天的9日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 8, 'nine_day_num');
        echo $sid . '--9日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第10天的10日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 9, 'ten_day_num');
        echo $sid . '--10日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第11天的11日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 10, 'eleven_day_num');
        echo $sid . '--11日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第12天的12日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 11, 'twelve_day_num');
        echo $sid . '--12日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第13天的13日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 12, 'thirteen_day_num');
        echo $sid . '--13日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第14天的14日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 13, 'fourteen_day_num');
        echo $sid . '--14日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第15天的15日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 14, 'fifteen_day_num');
        echo $sid . '--15日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第16天的16日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 15, 'sixteen_day_num');
        echo $sid . '--16日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第17天的17日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 16, 'seventeen_day_num');
        echo $sid . '--17日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第18天的18日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 17, 'eighteen_day_num');
        echo $sid . '--18日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第19天的19日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 18, 'nineteen_day_num');
        echo $sid . '--19日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第20天的20日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 19, 'twenty_day_num');
        echo $sid . '--20日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第21天的21日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 20, 'twenty_one_day_num');
        echo $sid . '--21日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第22天的22日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 21, 'twenty_two_day_num');
        echo $sid . '--22日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第23天的23日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 22, 'twenty_three_day_num');
        echo $sid . '--23日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第24天的24日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 23, 'twenty_four_day_num');
        echo $sid . '--24日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第25天的25日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 24, 'twenty_five_day_num');
        echo $sid . '--25日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第26天的26日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 25, 'twenty_six_day_num');
        echo $sid . '--26日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第27天的27日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 26, 'twenty_seven_day_num');
        echo $sid . '--27日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第28天的28日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 27, 'twenty_eight_day_num');
        echo $sid . '--28日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第29天的29日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 28, 'twenty_nine_day_num');
        echo $sid . '--29日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第30天的30日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 29, 'thirty_day_num');
        echo $sid . '--30日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第31天的31日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 30, 'thirty_one_day_num');
        echo $sid . '--31日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第32天的32日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 31, 'thirty_two_day_num');
        echo $sid . '--32日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第33天的33日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 32, 'thirty_three_day_num');
        echo $sid . '--33日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面34天的34日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 33, 'thirty_four_day_num');
        echo $sid . '--34日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第35天的35日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 34, 'thirty_five_day_num');
        echo $sid . '--35日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第36天的36日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 35, 'thirty_six_day_num');
        echo $sid . '--36日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第37天的37日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 36, 'thirty_seven_day_num');
        echo $sid . '--37日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第38天的38日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 37, 'thirty_eight_day_num');
        echo $sid . '--38日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第39天的39日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 38, 'thirty_nine_day_num');
        echo $sid . '--39日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第40天的40日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 39, 'forty_day_num');
        echo $sid . '--40日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第41天的41日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 40, 'forty_one_day_num');
        echo $sid . '--41日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第42天的42日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 41, 'forty_two_day_num');
        echo $sid . '--42日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第43天的43日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 42, 'forty_three_day_num');
        echo $sid . '--43日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第44天的44日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 43, 'forty_four_day_num');
        echo $sid . '--44日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第45天的45日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 44, 'forty_five_day_num');
        echo $sid . '--45日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第46天的46日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 45, 'forty_six_day_num');
        echo $sid . '--46日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第47天的47日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 46, 'forty_seven_day_num');
        echo $sid . '--47日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第48天的48日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 47, 'forty_eight_day_num');
        echo $sid . '--48日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第49天的49日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 48, 'forty_nine_day_num');
        echo $sid . '--49日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第50天的50日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 49, 'fifty_day_num');
        echo $sid . '--50日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第51天的51日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 50, 'fifty_one_day_num');
        echo $sid . '--51日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第52天的52日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 51, 'fifty_two_day_num');
        echo $sid . '--52日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第53天的53日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 52, 'fifty_three_day_num');
        echo $sid . '--53日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第54天的54日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 53, 'fifty_four_day_num');
        echo $sid . '--54日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第55天的55日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 54, 'fifty_five_day_num');
        echo $sid . '--55日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第56天的56日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 55, 'fifty_six_day_num');
        echo $sid . '--56日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第57天的57日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 56, 'fifty_seven_day_num');
        echo $sid . '--57日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第58天的58日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 57, 'fifty_eight_day_num');
        echo $sid . '--58日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第59天的59日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 58, 'fifty_nine_day_num');
        echo $sid . '--59日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第60天的60日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 59, 'sixty_day_num');
        echo $sid . '--60日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第61天的61日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 60, 'sixty_one_day_num');
        echo $sid . '--61日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第62天的62日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 61, 'sixty_two_day_num');
        echo $sid . '--62日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第63天的63日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 62, 'sixty_three_day_num');
        echo $sid . '--63日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第64天的64日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 63, 'sixty_four_day_num');
        echo $sid . '--64日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第65天的65日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 64, 'sixty_five_day_num');
        echo $sid . '--65日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第66天的66日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 65, 'sixty_six_day_num');
        echo $sid . '--66日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第67天的67日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 66, 'sixty_seven_day_num');
        echo $sid . '--67日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第68天的68日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 67, 'sixty_eight_day_num');
        echo $sid . '--68日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第69天的69日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 68, 'sixty_nine_day_num');
        echo $sid . '--69日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第70天的70日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 69, 'seventy_day_num');
        echo $sid . '--70日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第71天的71日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 70, 'seventy_one_day_num');
        echo $sid . '--71日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第72天的72日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 71, 'seventy_two_day_num');
        echo $sid . '--72日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第73天的73日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 72, 'seventy_three_day_num');
        echo $sid . '--73日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第74天的74日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 73, 'seventy_four_day_num');
        echo $sid . '--74日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第75天的75日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 74, 'seventy_five_day_num');
        echo $sid . '--75日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第76天的76日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 75, 'seventy_six_day_num');
        echo $sid . '--76日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第77天的77日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 76, 'seventy_seven_day_num');
        echo $sid . '--77日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第78天的78日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 77, 'seventy_eight_day_num');
        echo $sid . '--78日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第79天的79日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 78, 'seventy_nine_day_num');
        echo $sid . '--79日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第80天的80日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 79, 'eighty_day_num');
        echo $sid . '--80日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第81天的81日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 80, 'eighty_one_day_num');
        echo $sid . '--81日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第82天的82日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 81, 'eighty_two_day_num');
        echo $sid . '--82日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第83天的83日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 82, 'eighty_three_day_num');
        echo $sid . '--83日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面84天的84日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 83, 'eighty_four_day_num');
        echo $sid . '--84日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第85天的85日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 84, 'eighty_five_day_num');
        echo $sid . '--85日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第86天的86日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 85, 'eighty_six_day_num');
        echo $sid . '--86日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第87天的87日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 86, 'eighty_seven_day_num');
        echo $sid . '--87日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第88天的88日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 87, 'eighty_eight_day_num');
        echo $sid . '--88日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第89天的89日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 88, 'eighty_nine_day_num');
        echo $sid . '--89日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第90天的90日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 89, 'ninety_day_num');
        echo $sid . '--90日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第97天的97日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 96, 'ninety_seven_day_num');
        echo $sid . '--97日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第104天104日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 103, 'hundred_four_day_num');
        echo $sid . '--104日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第111天的111日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 110, 'hundred_eleven_day_num');
        echo $sid . '--111日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第118天的118日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 117, 'hundred_eighteen_day_num');
        echo $sid . '--118日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第125天的125日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 124, 'hundred_twenty_five_day_num');
        echo $sid . '--125日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第132天的132日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 131, 'hundred_thirty_two_day_num');
        echo $sid . '--132日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第139天的139日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 138, 'hundred_thirty_nine_day_num');
        echo $sid . '--139日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第146天的146日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 145, 'hundred_forty_six_day_num');
        echo $sid . '--146日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第153天的153日留存
        $retain_res = $this->getRetain($sid, $channel_id, $this->game_log_db, 152, 'hundred_fifty_three_day_num');
        echo $sid . '--153日留存---' . $channel_id . $retain_res . PHP_EOL;


        return 'Retain--ok';
    }

    protected function getRetain($sid, $channel_id, $game_log_db, $days, $update_field){
        //查询当天的昨日的数据
        $one_day_date = date('Y-m-d', strtotime($this->date) - $days * 86400);   //
        $start_time = strtotime($one_day_date);  //开始时间戳
        $end_time = $start_time + 86399;    //结束时间戳

        //1.处理注册留存
        $retain_day_info = $this->data_analysis_db->table('retain_day')
            ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and retain_type=1")
            ->find();
        if($retain_day_info){     //数据存在，计算留存
            if($retain_day_info['role_ids']){
                //获取昨日新增的用户在当日登录的用户数
                $table = 'role_login_log' . getLogTable('month', $this->date);
                $login_data = $game_log_db->table($table)
                    ->field('id,rid')
                    ->where("place=$channel_id and login_time>=$this->start_time and login_time<=$this->end_time and open_id in (" . $retain_day_info['role_ids'] . ")")
                    ->group('rid')
                    ->select();
                $login_count = count($login_data);
            }else{
                $login_count = '0';   
            }

            //修改数据
            $data_update = [
                $update_field => $login_count,
                'updated_at' => time()
            ];
            $up_res = $this->data_analysis_db->table('retain_day')
                ->where("id=" . $retain_day_info['id'])
                ->save($data_update);
        }

        //2.处理创角留存
        $retain_day_info = $this->data_analysis_db->table('retain_day')
            ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and retain_type=2")
            ->find();
        if($retain_day_info){     //数据存在，计算留存
            if($retain_day_info['role_ids']){
                //获取昨日新增的用户在当日登录的用户数
                $table = 'role_login_log' . getLogTable('month', $this->date);
                $login_data = $game_log_db->table($table)
                    ->field('id,rid')
                    ->where("place=$channel_id and login_time>=$this->start_time and login_time<=$this->end_time and rid in (" . $retain_day_info['role_ids'] . ")")
                    ->group('rid')
                    ->select();
                $login_count = count($login_data);
            }else{
                $login_count = '0';   
            }

            //修改数据
            $data_update = [
                $update_field => $login_count,
                'updated_at' => time()
            ];
            $up_res = $this->data_analysis_db->table('retain_day')
                ->where("id=" . $retain_day_info['id'])
                ->save($data_update);
        }

        //3.处理付费留存
        $retain_day_info = $this->data_analysis_db->table('retain_day')
            ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and retain_type=3")
            ->find();
        if($retain_day_info){     //数据存在，计算留存
            if($retain_day_info['role_ids']){
                //获取昨日新增的用户在当日登录的用户数
                $table = 'role_login_log' . getLogTable('month', $this->date);
                $login_data = $game_log_db->table($table)
                    ->field('id,rid')
                    ->where("place=$channel_id and login_time>=$this->start_time and login_time<=$this->end_time and rid in (" . $retain_day_info['role_ids'] . ")")
                    ->group('rid')
                    ->select();
                $login_count = count($login_data);
            }else{
                $login_count = '0';   
            }

            //修改数据
            $data_update = [
                $update_field => $login_count,
                'updated_at' => time()
            ];
            $up_res = $this->data_analysis_db->table('retain_day')
                ->where("id=" . $retain_day_info['id'])
                ->save($data_update);
        }

        //4.处理新增付费留存
        $retain_day_info = $this->data_analysis_db->table('retain_day')
            ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and retain_type=4")
            ->find();
        if($retain_day_info){     //数据存在，计算留存
            if($retain_day_info['role_ids']){
                //获取昨日新增的用户在当日登录的用户数
                $table = 'role_login_log' . getLogTable('month', $this->date);
                $login_data = $game_log_db->table($table)
                    ->field('id,rid')
                    ->where("place=$channel_id and login_time>=$this->start_time and login_time<=$this->end_time and rid in (" . $retain_day_info['role_ids'] . ")")
                    ->group('rid')
                    ->select();
                $login_count = count($login_data);
            }else{
                $login_count = '0';   
            }

            //修改数据
            $data_update = [
                $update_field => $login_count,
                'updated_at' => time()
            ];
            $up_res = $this->data_analysis_db->table('retain_day')
                ->where("id=" . $retain_day_info['id'])
                ->save($data_update);
        }

        //5.处理老用户留存
        $retain_day_info = $this->data_analysis_db->table('retain_day')
            ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and retain_type=5")
            ->find();
        if($retain_day_info){     //数据存在，计算留存
            if($retain_day_info['role_ids']){
                //获取昨日新增的用户在当日登录的用户数
                $table = 'role_login_log' . getLogTable('month', $this->date);
                $login_data = $game_log_db->table($table)
                    ->field('id,rid')
                    ->where("place=$channel_id and login_time>=$this->start_time and login_time<=$this->end_time and rid in (" . $retain_day_info['role_ids'] . ")")
                    ->group('rid')
                    ->select();
                $login_count = count($login_data);
            }else{
                $login_count = '0';   
            }

            //修改数据
            $data_update = [
                $update_field => $login_count,
                'updated_at' => time()
            ];
            $up_res = $this->data_analysis_db->table('retain_day')
                ->where("id=" . $retain_day_info['id'])
                ->save($data_update);
        }

        //6.处理设备留存
        $retain_day_info = $this->data_analysis_db->table('retain_day')
            ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and retain_type=6")
            ->find();
        if($retain_day_info){     //数据存在，计算留存
            if(!empty($retain_day_info['num'])){

                $table = 'role_login_log' . getLogTable('month', $this->date);
                //获取创角设备的登录数
                $login_count = $this->game_log_db->table('role_create_log')
                    ->alias('rcl')
                    ->join("left join $table as aa on aa.device_id=rcl.device_id")
                    ->where("rcl.place=$channel_id and rcl.create_time>=$start_time and rcl.create_time<=$end_time
                        and aa.place=$channel_id and aa.login_time>=$this->start_time and aa.login_time<=$this->end_time ")
                    ->count('distinct rcl.device_id');
                    
            }else{
                $login_count = '0';   //当天的昨天的次日留存
            }

            //修改数据
            $data_update = [
                $update_field => $login_count,
                'updated_at' => time()
            ];
            $up_res = $this->data_analysis_db->table('retain_day')
                ->where("id=" . $retain_day_info['id'])
                ->save($data_update);
        }

        return '处理留存完成';
    }

}
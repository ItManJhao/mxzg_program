<?php
namespace Admin\Controller;

use Think\Controller;

/*
 * 游戏数据 
 */
class GameDataController extends PublicController{

    protected $shop_types;

    public function __construct() {
        parent::__construct();
        $this->shop_types = [
            '100100' => [
                'id' => '100100', 
                'name' => '市场'
            ],
            '100200' => [
                'id' => '100200', 
                'name' => '许愿池'
            ],
            '100300' => [
                'id' => '100300', 
                'name' => '黑市-先知'
            ],
            '100400' => [
                'id' => '100400', 
                'name' => '祭坛'
            ],
            '100500' => [
                'id' => '100500', 
                'name' => '黑市-竞技场'
            ],
            '100600' => [
                'id' => '100600', 
                'name' => '黑市-公会'
            ],
            '100700' => [
                'id' => '100700', 
                'name' => '试炼'
            ],
            '100800' => [
                'id' => '100800', 
                'name' => '黑市-道具'
            ],
            '100900' => [
                'id' => '100900', 
                'name' => '狂欢时刻'
            ],
            '101000' => [
                'id' => '101000', 
                'name' => '黑市-英雄'
            ],
            '101200' => [
                'id' => '101200', 
                'name' => '跨服天梯'
            ],
            '101300' => [
                'id' => '101300', 
                'name' => '先知-碎片商城'
            ],
        ];
        $this->equip_not_event = '4004,4005,4006,4007,4008';   //装备日志不做处理的事件类型id
    }

    /*消费类型统计*/
    public function EventStatis(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();
//        $channels_re = [];
//        foreach($channels as $channels_val){
//            $channels_re[$channels_val['id']] = $channels_val;
//        }

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();
//        $servers_re = [];
//        foreach($servers as $servers_val){
//            $servers_re[$servers_val['id']] = $servers_val;
//        }
        //获取所有的事件
        $event_list = $this->platform_db->table('game_event')->select();
        //获取所有的道具
        $item_list = $this->platform_db->table('gift_item')->select();

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $today_date = I('today_date', date('Y-m-d'));    //日期
        $item_type = I('item_type', '0');
        $event_type = I('event_type', '0');

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'today_date' => $today_date,
            'item_type' => $item_type,
            'event_type' => $event_type
        ];
        //判断必要筛选条件是否选择了
        if(empty($sid) || empty($today_date)){
            $this->assign(['list'=>[], 'error_msg'=> '服务器和时间都必须选择！！！', 'count'=>0, 'page'=>'', 'event_list' => $event_list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $game_log_db = connectionDb($server_info, 'log');         //连接游戏日志库
        
        $where = '1 ';
        if(!empty($c_son_id)){
            $where .= "and place in($c_son_id) ";
        }

        $where_item = $where;
        if(!empty($event_type)){
            $where_item .= "and event in($event_type) ";
        }
        $where_item .= "and delta<0 ";
        $start_time_str = strtotime(date('Y-m-d', strtotime($today_date)) . ' 00:00:00');
        $end_time_str = strtotime(date('Y-m-d', strtotime($today_date)) . ' 23:59:59');
        $where_item .= "and time>=$start_time_str and time<=$end_time_str ";

        if($item_type == 900001){       //金币
            $table = 'gold_log' . getLogTable('month', $today_date);
        }elseif($item_type == 900002){  //钻石
            $table = 'gem_log' . getLogTable('month', $today_date);
        }

        $count = $game_log_db->table($table)
            ->where($where_item)
            ->count();
        $Page  = new \Think\Page($count, $count);
        $list = $game_log_db->table($table)
            ->field("
                event,
                event_desc,
                count(distinct rid) as cost_roles,
                count(id) as cost_count,
                sum(-delta) as cost_total
            ")
            ->where($where_item)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->group('event')
            ->select();

        //获取活跃人数
        $where_login = $where;
        $where_login .= "and login_time>=$start_time_str and login_time<=$end_time_str ";
        $table = 'role_login_log' . getLogTable('month', $today_date);
        $count = $game_log_db->table($table)
            ->where($where_login)
            ->count("distinct rid");

        //总消费
        $cost_totals = 0;
        //总消费人数
        $cost_roles_totals = 0;
        foreach($list as &$list_val){
            $list_val['active_roles'] = $count;
            $cost_totals += $list_val['cost_total'];
            $cost_roles_totals += $list_val['cost_roles'];
        }

        foreach($list as &$list_val){
            //计算总消费占比（单数据的消费/所有数据的总消费）
            $list_val['cost_radio'] = getDivision($list_val['cost_total'], $cost_totals) . '%';
            //计算总消费人数占比（单数据的消费人数/所有数据的总消费人数，不去重）
            $list_val['cost_roles_radio'] = getDivision($list_val['cost_roles'], $cost_roles_totals) . '%';
        }
        

        $show = $Page->show();
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'event_list' => $event_list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*道具每日库存统计*/
    public function ItemDay(){
        //实例化mxag_data_analysis数据库
        $this->data_analysis_db = M('',null,'DB_DATA_ANALYSIS');

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();
//        $channels_re = [];
//        foreach($channels as $channels_val){
//            $channels_re[$channels_val['id']] = $channels_val;
//        }

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();
//        $servers_re = [];
//        foreach($servers as $servers_val){
//            $servers_re[$servers_val['id']] = $servers_val;
//        }
        //获取所有的礼包道具
        $item_list = M('gift_item')->select();

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $today_date = I('today_date', date('Y-m-d', strtotime("-1 day")));    //日期
        $item_type = I('item_type', '0');

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'today_date' => $today_date,
            'item_type' => $item_type
        ];
        //判断必要筛选条件是否选择了
        if(empty($today_date)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择日期！！！', 'count'=>0, 'page'=>'', 'item_list' => $item_list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $where = '1 ';
        if(!empty($sid)){
            $where .= "and sid in($sid) ";
        }
        if(!empty($c_son_id)){
            $where .= "and c_son_id in($c_son_id) ";
        }
        if(!empty($item_type)){
            $where .= "and item_type in($item_type) ";
        }

        $where .= "and unix_timestamp(date) =" . strtotime(date('Y-m-d', strtotime($today_date))) . ' ';

        $count = $this->data_analysis_db->table('item_day')
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,50);
        $list = $this->data_analysis_db->table('item_day')
            ->field("
                item_type,
                item_name,
                item_quality,
                sum(get_num) as get_num_total,
                sum(out_num) as out_num_total,
                sum(surplus_num) as surplus_num_total,
                sum(surplus_role) as surplus_role_total,
                sum(active_role) as active_role_total,
                sum(active_num) as active_num_total,
                sum(old_active_role) as old_active_role_total,
                sum(old_active_num) as old_active_num_total
            ")
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->group('item_type')
            ->select();
        foreach($list as &$list_val){
            $list_val['surplus_num_avg'] = getDivisionSpecial($list_val['surplus_num_total'],$list_val['surplus_role_total'],0);    //人均拥有数
            $list_val['old_active_num_avg'] = getDivisionSpecial($list_val['old_active_num_total'],$list_val['old_active_role_total'],0);    //去新人均拥有数
        }
        $show = $Page->show();
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'item_list' => $item_list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }


    /*道具获得/消耗详情统计（道具来源统计）*/
    public function ItemStatisDetails(){
        $now_date = date('Y-m-d H:i:s');
        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();
        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();
        //获取所有的游戏事件
        $event_list = $this->platform_db->table('game_event')->select();
        //获取所有的礼包道具
        $item_list = $this->platform_db->table('gift_item')->select();
        $item_datas = getItemTypeData($item_list);
        $item_data = $item_datas['item_data'];              //用于处理数据的显示
        $item_class_arr = $item_datas['item_class_arr'];    //用于页面二级下拉框筛选

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        // $show_type = I('show_type', '0');               //显示类型，0.汇总，1.详细
        $game_event = I('game_event', '0');             //来源
        $oprate_type = I('oprate_type', '1');           //统计类型，1.获得，2.消费
        $item_type = I('item_type', '0');                //道具id
        $item_class = I('item_class', '0');               //道具分类

        $start_time = I('start_time', date('Y-m-d H:i:s', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'start_time' => $start_time,
            'end_time' => $end_time,
            'game_event' => $game_event,
            'oprate_type' => $oprate_type,
            'item_type' => $item_type,
            'item_class' => $item_class,
        ];

        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'count'=>0, 'page'=>'', 'event_list'=> $event_list, 'item_classs'=> $this->item_class, 'item_class_arr'=>$item_class_arr, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        if(date('Y-m', strtotime($start_time)) != date('Y-m', strtotime($end_time))){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间必须是同月！！！', 'count'=>0, 'page'=>'', 'event_list'=> $event_list, 'item_classs'=> $this->item_class, 'item_class_arr'=>$item_class_arr, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $game_log_db = connectionDb($server_info, 'log');         //连接游戏日志库

        $where = 'time>=' . strtotime($start_time) . ' and time<=' . strtotime($end_time) . ' ';

        if($oprate_type == 1){
            $where .= "and delta>0 ";
            $order_where = "sum desc";
        }elseif($oprate_type == 2){
            $where .= "and delta<0 ";
            $order_where = "sum asc";
        }
        if(!empty($game_event)){
            $where .= "and event in($game_event) ";
        }
        if(!empty($c_son_id)){
            $where .= "and place in($c_son_id) ";
        }

        if($item_class == 1){           //金币
            $table = 'gold_log' . getLogTable('month', $start_time);
        }elseif($item_class == 2){      //钻石
            $table = 'gem_log' . getLogTable('month', $start_time);
        }elseif($item_class == 3){      //角色经验
            $table = 'role_exp_log' . getLogTable('month', $start_time);
        }elseif($item_class == 5){      //英雄经验
            $table = 'hero_exp_log' . getLogTable('month', $start_time);
        }elseif($item_class == 8){      //精灵（符文）
            $table = 'rune_log' . getLogTable('month', $start_time);
            if(!empty($item_type)){
                $where .= "and type in($item_type) ";
            }
            $count = $game_log_db->table($table)
                ->where($where)
                ->group("type,event")
                ->select();
            $count = count($count);
            $Page  = new \Think\Page($count,30);
            
            $list = $game_log_db->table($table)
                ->field('
                    type,
                    event,
                    event_desc,
                    sum(delta) as sum,
                    count(distinct rid) as rid_count,
                    count(id) count
                ')
                ->where($where)
                ->group("type,event")
                ->order($order_where)
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();
            foreach($list as &$list_val){
                $list_val['item_type'] = $list_val['type'];
                $list_val['item_name'] = $item_data[$list_val['type']]['name'];
                $list_val['quality'] = $item_data[$list_val['type']]['quality'];
            }
        }elseif($item_class == 61){  //装备
            if(!empty($item_type)){
                $where .= "and type in($item_type) ";
            }else{
                $item_types = $this->platform_db->table('gift_item')
                    ->field('id')
                    ->where("type=6 and type_label=1 ")
                    ->select();
                $item_types = array_column($item_types, 'id');
                $item_type_str = implode(',', $item_types);
                $where .= "and type in($item_type_str) ";
            }
        }elseif($item_class == 65){  //宝石
            if(!empty($item_type)){
                $where .= "and type in($item_type) ";
            }else{
                $item_types = $this->platform_db->table('gift_item')
                    ->field('id')
                    ->where("type=6 and type_label=5 ")
                    ->select();
                $item_types = array_column($item_types, 'id');
                $item_type_str = implode(',', $item_types);
                $where .= "and type in($item_type_str) ";
            }
        }elseif($item_class == 12){      //神装
            $table = 'god_equip_log' . getLogTable('month', $start_time);
            if(!empty($item_type)){
                $where .= "and sys_id in($item_type) ";
            }
            $count = $game_log_db->table($table)
                ->where($where)
                ->group("sys_id,event")
                ->select();
            $count = count($count);
            $Page  = new \Think\Page($count,30);
            
            $list = $game_log_db->table($table)
                ->field('
                    sys_id as type,
                    event,
                    event_desc,
                    sum(delta) as sum,
                    count(distinct rid) as rid_count,
                    count(id) count
                ')
                ->where($where)
                ->group("sys_id,event")
                ->order($order_where)
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();
            foreach($list as &$list_val){
                $list_val['item_type'] = $list_val['type'];
                $list_val['item_name'] = $item_data[$list_val['type']]['name'];
                $list_val['quality'] = $item_data[$list_val['type']]['quality'];
            }
        }elseif($item_class == 17){      //灵器
            $table = 'reiki_equip_log' . getLogTable('month', $start_time);
            if(!empty($item_type)){
                $where .= "and sys_id in($item_type) ";
            }
            $count = $game_log_db->table($table)
                ->where($where)
                ->group("sys_id,event")
                ->select();
            $count = count($count);
            $Page  = new \Think\Page($count,30);
            
            $list = $game_log_db->table($table)
                ->field('
                    sys_id as type,
                    event,
                    event_desc,
                    sum(delta) as sum,
                    count(distinct rid) as rid_count,
                    count(id) count
                ')
                ->where($where)
                ->group("sys_id,event")
                ->order($order_where)
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();
            foreach($list as &$list_val){
                $list_val['item_type'] = $list_val['type'];
                $list_val['item_name'] = $item_data[$list_val['type']]['name'];
                $list_val['quality'] = $item_data[$list_val['type']]['quality'];
            }
        }else{  //道具
            if(!empty($item_type)){
                $where .= "and type in($item_type) ";
            }else{
                $item_types = $this->platform_db->table('gift_item')
                    ->field('id')
                    ->where("type=6 and type_label not in(1,5) ")
                    ->select();
                $item_types = array_column($item_types, 'id');
                $where .= "and type in($item_types) ";
            }
        }
        if(in_array($item_class, [1,2,3,5])){
            $count = $game_log_db->table($table)
                ->where($where)
                ->group("event")
                ->select();
            $count = count($count);
            $Page  = new \Think\Page($count,30);
            $list = $game_log_db->table($table)
                ->field('
                    event,
                    event_desc,
                    sum(delta) as sum,
                    count(distinct rid) as rid_count,
                    count(id) count
                ')
                ->where($where)
                ->group("event")
                ->order($order_where)
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();
            foreach($list as &$list_val){
                $list_val['item_type'] = $item_type;
                $list_val['item_name'] = $item_data[$item_type]['name'];
                $list_val['quality'] = $item_data[$item_type]['quality'];
            }
        }elseif(in_array($item_class, [61,65,6])){
            $table = 'item_log' . getLogTable('month', $start_time);
            $count = $game_log_db->table($table)
                ->where($where)
                ->group("type,event")
                ->select();
            $count = count($count);
            $Page  = new \Think\Page($count,30);
            
            $list = $game_log_db->table($table)
                ->field('
                    type,
                    event,
                    event_desc,
                    sum(delta) as sum,
                    count(distinct rid) as rid_count,
                    count(id) count
                ')
                ->where($where)
                ->group("type,event")
                ->order($order_where)
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();
            foreach($list as &$list_val){
                $list_val['item_type'] = $list_val['type'];
                $list_val['item_name'] = $item_data[$list_val['type']]['name'];
                $list_val['quality'] = $item_data[$list_val['type']]['quality'];
            }
        }

        $show = $Page->show();
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'event_list'=> $event_list, 'item_classs'=> $this->item_class, 'item_class_arr'=>$item_class_arr, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }
    //道具获得/消耗详情统计（道具来源统计）导出
    public function ItemStatisDetailsExport(){
        ini_set('memory_limit','256M'); //临时提高内存
        $now_date = date('Y-m-d H:i:s');
        //获取所有的礼包道具
        $item_list = $this->platform_db->table('gift_item')->select();
        $item_datas = getItemTypeData($item_list, 0);
        $item_data = $item_datas['item_data'];              //用于处理数据的显示
        // $item_class_arr = $item_datas['item_class_arr'];    //用于页面二级下拉框筛选

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $game_event = I('game_event', '0');             //来源
        $oprate_type = I('oprate_type', '1');           //统计类型，1.获得，2.消费
        $item_type = I('item_type', '0');                //道具id
        $item_class = I('item_class', '0');               //道具分类

        $start_time = I('start_time', date('Y-m-d H:i:s', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);


        //判断时间是否都选择
        $is_error = 0;
        if(empty($sid) || empty($start_time) || empty($end_time)){
            $is_error = 1;
        }
        if(date('Y-m', strtotime($start_time)) != date('Y-m', strtotime($end_time))){
            $is_error = 1;
        }

        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if($is_error == 0 && $server_info){
            $game_log_db = connectionDb($server_info, 'log');         //连接游戏日志库

            $where = 'time>=' . strtotime($start_time) . ' and time<=' . strtotime($end_time) . ' ';

            if($oprate_type == 1){
                $where .= "and delta>0 ";
                $order_where = "sum desc";
            }elseif($oprate_type == 2){
                $where .= "and delta<0 ";
                $order_where = "sum asc";
            }
            if(!empty($game_event)){
                $where .= "and event in($game_event) ";
            }
            if(!empty($c_son_id)){
                $where .= "and place in($c_son_id) ";
            }

            if($item_class == 1){           //金币
                $table = 'gold_log' . getLogTable('month', $start_time);
            }elseif($item_class == 2){      //钻石
                $table = 'gem_log' . getLogTable('month', $start_time);
            }elseif($item_class == 3){      //角色经验
                $table = 'role_exp_log' . getLogTable('month', $start_time);
            }elseif($item_class == 5){      //英雄经验
                $table = 'hero_exp_log' . getLogTable('month', $start_time);
            }elseif($item_class == 8){      //精灵（符文）
                $table = 'rune_log' . getLogTable('month', $start_time);
                if(!empty($item_type)){
                    $where .= "and type in($item_type)";
                }
                
                $list = $game_log_db->table($table)
                    ->field('
                        type,
                        event,
                        event_desc,
                        sum(delta) as sum,
                        count(distinct rid) as rid_count,
                        count(id) count
                    ')
                    ->where($where)
                    ->group("type,event")
                    ->order($order_where)
                    ->limit(C('EXPORT_LIMIT_NUM'))       //限制导出数量
                    ->select();
                foreach($list as &$list_val){
                    $list_val['item_type'] = $list_val['type'];
                    $list_val['item_name'] = $item_data[$list_val['type']]['name'];
                    $list_val['quality'] = $item_data[$list_val['type']]['quality'];
                }
            }elseif($item_class == 61){  //装备
                if(!empty($item_type)){
                    $where .= "and type in($item_type) ";
                }else{
                    $item_types = $this->platform_db->table('gift_item')
                        ->field('id')
                        ->where("type=6 and type_label=1 ")
                        ->select();
                    $item_types = array_column($item_types, 'id');
                    $item_type_str = implode(',', $item_types);
                    $where .= "and type in($item_type_str) ";
                }
            }elseif($item_class == 65){  //宝石
                if(!empty($item_type)){
                    $where .= "and type in($item_type) ";
                }else{
                    $item_types = $this->platform_db->table('gift_item')
                        ->field('id')
                        ->where("type=6 and type_label=5 ")
                        ->select();
                    $item_types = array_column($item_types, 'id');
                    $item_type_str = implode(',', $item_types);
                    $where .= "and type in($item_type_str) ";
                }
            }elseif($item_class == 12){      //神装
                $table = 'god_equip_log' . getLogTable('month', $start_time);
                if(!empty($item_type)){
                    $where .= "and sys_id in($item_type) ";
                }
                
                $list = $game_log_db->table($table)
                    ->field('
                        sys_id as type,
                        event,
                        event_desc,
                        sum(delta) as sum,
                        count(distinct rid) as rid_count,
                        count(id) count
                    ')
                    ->where($where)
                    ->group("sys_id,event")
                    ->order($order_where)
                    ->limit($Page->firstRow.','.$Page->listRows)
                    ->select();
                foreach($list as &$list_val){
                    $list_val['item_type'] = $list_val['type'];
                    $list_val['item_name'] = $item_data[$list_val['type']]['name'];
                    $list_val['quality'] = $item_data[$list_val['type']]['quality'];
                }
            }elseif($item_class == 17){      //灵器
                $table = 'reiki_equip_log' . getLogTable('month', $start_time);
                if(!empty($item_type)){
                    $where .= "and sys_id in($item_type) ";
                }
                
                $list = $game_log_db->table($table)
                    ->field('
                        sys_id as type,
                        event,
                        event_desc,
                        sum(delta) as sum,
                        count(distinct rid) as rid_count,
                        count(id) count
                    ')
                    ->where($where)
                    ->group("sys_id,event")
                    ->order($order_where)
                    ->limit($Page->firstRow.','.$Page->listRows)
                    ->select();
                foreach($list as &$list_val){
                    $list_val['item_type'] = $list_val['type'];
                    $list_val['item_name'] = $item_data[$list_val['type']]['name'];
                    $list_val['quality'] = $item_data[$list_val['type']]['quality'];
                }
            }else{  //道具
                if(!empty($item_type)){
                    $where .= "and type in($item_type) ";
                }else{
                    $item_types = $this->platform_db->table('gift_item')
                        ->field('id')
                        ->where("type=6 and type_label not in(1,5) ")
                        ->select();
                    $item_types = array_column($item_types, 'id');
                    $where .= "and type in($item_types) ";
                }
            }
            if(in_array($item_class, [1,2,3,5])){
                $list = $game_log_db->table($table)
                    ->field('
                        event,
                        event_desc,
                        sum(delta) as sum,
                        count(distinct rid) as rid_count,
                        count(id) count
                    ')
                    ->where($where)
                    ->group("event")
                    ->order($order_where)
                    ->limit(C('EXPORT_LIMIT_NUM'))       //限制导出数量
                    ->select();
                foreach($list as &$list_val){
                    $list_val['item_type'] = $item_type;
                    $list_val['item_name'] = $item_data[$item_type]['name'];
                    $list_val['quality'] = $item_data[$item_type]['quality'];
                }
            }elseif(in_array($item_class, [61,65,6])){
                $table = 'item_log' . getLogTable('month', $start_time);
                $count = $game_log_db->table($table)
                    ->where($where)
                    ->group("type,event")
                    ->select();
                $count = count($count);
                $Page  = new \Think\Page($count,20);
                
                $list = $game_log_db->table($table)
                    ->field('
                        type,
                        event,
                        event_desc,
                        sum(delta) as sum,
                        count(distinct rid) as rid_count,
                        count(id) count
                    ')
                    ->where($where)
                    ->group("type,event")
                    ->order($order_where)
                    ->limit($Page->firstRow.','.$Page->listRows)
                    ->select();
                foreach($list as &$list_val){
                    $list_val['item_type'] = $list_val['type'];
                    $list_val['item_name'] = $item_data[$list_val['type']]['name'];
                    $list_val['quality'] = $item_data[$list_val['type']]['quality'];
                }
            }
        }else{
            $list = [];
        }
        unset($item_datas);
        unset($item_data);

        vendor('PHPExcel.PHPExcel');
        vendor('PHPExcel.PHPExcel.Writer.Excel5');
        Vendor("PHPExcel.PHPExcel.IOFactory");
        $excel = new \PHPExcel();
        //Excel表格式,这里简略写了8列
        $letter = array('A','B','C','D','E','F','G');
        //表头数组
        $tableheader = array('道具ID','道具名称','品质','来源','获得/消耗量','获得/消耗人数','获得/消耗次数');
        //填充表头信息
        for($i = 0;$i < count($tableheader);$i++) {
            $excel->getActiveSheet()->setCellValue("$letter[$i]1","$tableheader[$i]");
        }
        $excel->getActiveSheet()->getDefaultColumnDimension()->setWidth(20);//所有单元格（列）默认宽度
        //填充表格信息
        for ($i = 2;$i <= count($list) + 1;$i++) {
            $excel->getActiveSheet()->setCellValue("A$i", $list[$i - 2]['item_type']);
            $excel->getActiveSheet()->setCellValue("B$i", $list[$i - 2]['item_name']);
            $excel->getActiveSheet()->setCellValue("C$i", $list[$i - 2]['quality']);
            $excel->getActiveSheet()->setCellValue("D$i", $list[$i - 2]['event'] . '--' . $list[$i - 2]['event_desc']);
            $excel->getActiveSheet()->setCellValue("E$i", $list[$i - 2]['sum']);
            $excel->getActiveSheet()->setCellValue("F$i", $list[$i - 2]['rid_count']);
            $excel->getActiveSheet()->setCellValue("G$i", $list[$i - 2]['count']);
        }

        //创建Excel输入对象
        ob_clean();
        $write = new \PHPExcel_Writer_Excel5($excel);
        header("Pragma: public");
        header("Expires: 0");
        $filename="item_statis_details.xls";
        header("Content-Disposition: attachment;filename=$filename");
        header("Cache-Control:must-revalidate, post-check=0, pre-check=0");
        header("Content-Type:application/force-download");
        header("Content-Type:application/vnd.ms-execl");
        header("Content-Type:application/octet-stream");
        header("Content-Type:application/download");
        header("Content-Transfer-Encoding:binary");
        $write->save('php://output');
    }


    /*道具获得/消耗统计*/
    public function ItemStatis(){
        $now_date = date('Y-m-d H:i:s');
        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();
        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();
        // //获取所有的游戏事件
        // $event_list = M('game_event')->select();
        //获取所有的礼包道具
        $item_list = M('gift_item')->select();
        $item_datas = getItemTypeData($item_list);
        $item_data = $item_datas['item_data'];              //用于处理数据的显示
        $item_class_arr = $item_datas['item_class_arr'];    //用于页面二级下拉框筛选

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        // $show_type = I('show_type', '0');               //显示类型，0.汇总，1.详细
        $oprate_type = I('oprate_type', '1');           //统计类型，1.获得，2.消费
        $item_type = I('item_type', '0');                //道具id
        $item_class = I('item_class', '0');               //道具分类

        $start_time = I('start_time', date('Y-m-d H:i:s', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            // 'show_type' => $show_type,
            'start_time' => $start_time,
            'end_time' => $end_time,
            'oprate_type' => $oprate_type,
            'item_type' => $item_type,
            'item_class' => $item_class,
        ];

        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'count'=>0, 'page'=>'', 'item_classs'=> $this->item_class, 'item_class_arr'=>$item_class_arr, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        if(date('Y-m', strtotime($start_time)) != date('Y-m', strtotime($end_time))
            ){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间必须是同月！！！', 'count'=>0, 'page'=>'', 'item_class'=> $this->item_class, 'item_class_arr'=>$item_class_arr, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $this->game_data_db = connectionDb($server_info, 'data');       //连接游戏数据库
        $this->game_log_db = connectionDb($server_info, 'log');         //连接游戏日志库

        $where = 'time>=' . strtotime($start_time) . ' and time<=' . strtotime($end_time) . ' ';
        if(!empty($c_son_id)){
            $where_c_son_id = " and place in($c_son_id) ";
            $where_c_son_id_role = " and role.place in($c_son_id) ";
        }else{
            $where_c_son_id = "";
            $where_c_son_id_role = '';
        }
        $where .= $where_c_son_id;

        if($oprate_type == 1){
            $where .= "and delta>0 ";
        }elseif($oprate_type == 2){
            $where .= "and delta<0 ";
        }

        $where_god_type = $where_type = '1 '; //用到道具id的搜索条件
        if(!empty($item_type)){
            $where_type .= "and type_id=$item_type";
            $where_god_type .= "and sys_id=$item_type";
        }
        $where_type .= $where_c_son_id_role;
        $where_god_type .= $where_c_son_id_role;

        if($item_class == 1){           //金币
            $count = 1;
            $Page  = new \Think\Page($count,10);
            $list_info = $this->game_data_db->table('role')
                ->field('
                    sum(gold) as sum,
                    count(id) as num
                ')
                ->where('gold>0 ' . $where_c_son_id)
                ->find();
            //获取时间段内的获得消耗情况（查询金币流水日志）
            $table = 'gold_log' . getLogTable('month', $start_time);
            $log_data = $this->getLogData($this->game_log_db, $table, $where, $oprate_type);
        }elseif($item_class == 2){      //钻石
            $count = 1;
            $Page  = new \Think\Page($count,10);
            $list_info = $this->game_data_db->table('role')
                ->field('
                    sum(gem) as sum,
                    count(id) as num
                ')
                ->where('gem>0 ' . $where_c_son_id)
                ->find();
            //获取时间段内的获得消耗情况（查询钻石流水日志）
            $table = 'gem_log' . getLogTable('month', $start_time);
            $log_data = $this->getLogData($this->game_log_db, $table, $where, $oprate_type);
        }elseif($item_class == 3){      //角色经验
            $count = 1;
            $Page  = new \Think\Page($count,10);
            $list_info = $this->game_data_db->table('role')
                ->field('
                    sum(exp) as sum,
                    count(id) as num
                ')
                ->where('exp>0 ' . $where_c_son_id)
                ->find();
            //获取时间段内的获得消耗情况（查询钻石流水日志）
            $table = 'role_exp_log' . getLogTable('month', $start_time);
            $log_data = $this->getLogData($this->game_log_db, $table, $where, $oprate_type);
        }elseif($item_class == 5){      //英雄经验
            $count = 1;
            $Page  = new \Think\Page($count,10);
            $list_info = $this->game_data_db->table('role')
                ->field('
                    sum(hero_exp) as sum,
                    count(id) as num
                ')
                ->where('hero_exp>0 ' . $where_c_son_id)
                ->find();
            //获取时间段内的获得消耗情况（查询钻石流水日志）
            $table = 'hero_exp_log' . getLogTable('month', $start_time);
            $log_data = $this->getLogData($this->game_log_db, $table, $where, $oprate_type);
        }elseif($item_class == 8){      //精灵（符文）
            $count = $this->game_data_db->table('rune_info')
                ->join("
                    LEFT JOIN role on role.id=rune_info.rid
                ")
                ->where($where_type)
                ->group('type_id')
                ->count();
            $count = count($count);
            $Page  = new \Think\Page($count,10);
            $list = $this->game_data_db->table('rune_info')
                ->field('
                    type_id,
                    count(id) as sum,
                    count(distinct rid) as num
                ')
                ->where($where_type)
                ->group('type_id')
                ->select();
            foreach($list as &$rune_val){
                $rune_val['sum_avg'] = getDivisionSpecial($rune_val['sum'],$rune_val['num'],0);  //平均每人多少
                $rune_val['item_type'] = $rune_val['type_id'];
                $rune_val['item_name'] = $item_data[$rune_val['type_id']]['name'];
                $rune_val['quality'] = $item_data[$rune_val['type_id']]['quality'];

                $where_log = $where;
                $where_log .= "and type=" . $rune_val['type_id'] . " ";
                //获取时间段内的获得消耗情况（查询钻石流水日志）
                $table = 'rune_log' . getLogTable('month', $start_time);
                $log_data = $this->getLogData($this->game_log_db, $table, $where_log, $oprate_type);
                $rune_val['delta_sum'] = $log_data['sum'];
                $rune_val['delta_rid_count'] = $log_data['rid_count'];
                $rune_val['delta_count'] = $log_data['count'];
                $rune_val['delta_ratio'] = getDivision($rune_val['delta_sum'],$rune_val['sum']);    //总量占比
                $rune_val['delta_rid_ratio'] = getDivision($rune_val['delta_rid_count'],$rune_val['num']);      //人数占比
            }
            
        }elseif($item_class == 61){  //装备
            if(!empty($item_type)){     //查询多个
                $count = 1;
                $where_equip = "id in($item_type) ";
            }else{      //查询全部
                $where_equip = "type=6 and type_label=1 ";
                $count = $this->platform_db->table('gift_item')
                    ->where($where_equip)
                    ->count();
            }
            $Page  = new \Think\Page($count,10);
            $list = $this->platform_db->table('gift_item')
                    ->field('id as item_type,name as item_name,quality')
                    ->where($where_equip)
                    ->select();
            foreach($list as &$equip_val){
                //获取装备在背包中有多少
                $back_pack_data = $this->game_data_db->table('back_pack')
                    ->alias('bp')
                    ->field('
                        count(DISTINCT bp.rid) as rid_count,
                        sum(bp.num) as bp_sum,
                        sum(tmp.he_count) as he_sum
                    ')
                    ->join("
                        LEFT JOIN (SELECT count(sys_id) as he_count,rid
                        FROM hero_equip as he
                        left join role on role.id=he.rid
                        where sys_id=" . $equip_val['item_type'] . $where_c_son_id_role . "
                        GROUP BY rid) as tmp on tmp.rid=bp.rid
                    ")
                    ->where("item_id=" . $equip_val['item_type'] . " and (bp.num>0 or tmp.he_count>0) ")
                    ->find();
                //遍历背包的数据，拿到角色id集（用来去重计算有多少）
                $equip_val['sum'] = $back_pack_data['bp_sum'] + $back_pack_data['he_sum'];
                $equip_val['num'] = $back_pack_data['rid_count'];
                $equip_val['sum_avg'] = getDivisionSpecial($equip_val['sum'],$equip_val['num'],0);  //平均每人多少
                // $equip_val['item_type'] = $item_type;
                // $equip_val['item_name'] = $item_data[$item_type]['name'];
                // $equip_val['quality'] = $item_data[$item_type]['quality'];
                //获取装备的日志数据
                $table = 'item_log' . getLogTable('month', $start_time);

                $where_log = $where;
                $where_log .= "and type=" . $equip_val['item_type'] . " and event not in($this->equip_not_event) ";
                $log_data = $this->getLogData($this->game_log_db, $table, $where_log, $oprate_type);
                $equip_val['delta_sum'] = $log_data['sum'];
                $equip_val['delta_rid_count'] = $log_data['rid_count'];
                $equip_val['delta_count'] = $log_data['count'];
                $equip_val['delta_ratio'] = getDivision($equip_val['delta_sum'],$equip_val['sum']);    //总量占比
                $equip_val['delta_rid_ratio'] = getDivision($equip_val['delta_rid_count'],$equip_val['num']);      //人数占比
            }
        }elseif($item_class == 65){     //宝石
            if(!empty($item_type)){     //查询多个
                $count = 1;
                $where_equip = "id in($item_type) ";
            }else{      //查询全部
                $where_equip = "type=6 and type_label=5 ";
                $count = $this->platform_db->table('gift_item')
                    ->where($where_equip)
                    ->count();
            }
            $Page  = new \Think\Page($count,10);
            $list = $this->platform_db->table('gift_item')
                    ->field('id as item_type,name as item_name,quality')
                    ->where($where_equip)
                    ->select();
            foreach($list as &$equip_val){
                //获取装备在背包中有多少
                $back_pack_data = $this->game_data_db->table('back_pack')
                    ->alias('bp')
                    ->field('
                        count(DISTINCT bp.rid) as rid_count,
                        sum(bp.num) as bp_sum,
                        sum(tmp.he_count) as he_sum
                    ')
                    ->join("
                        LEFT JOIN (SELECT count(sys_id) as he_count,rid
                        FROM hero_equip as he
                        left join role on role.id=he.rid
                        where sys_id=" . $equip_val['item_type'] . $where_c_son_id_role . "
                        GROUP BY rid) as tmp on tmp.rid=bp.rid
                    ")
                    ->where("item_id=" . $equip_val['item_type'] . " and (bp.num>0 or tmp.he_count>0) ")
                    ->find();
                //遍历背包的数据，拿到角色id集（用来去重计算有多少）
                $equip_val['sum'] = $back_pack_data['bp_sum'] + $back_pack_data['he_sum'];
                $equip_val['num'] = $back_pack_data['rid_count'];
                $equip_val['sum_avg'] = getDivisionSpecial($equip_val['sum'],$equip_val['num'],0);  //平均每人多少
                // $equip_val['item_type'] = $item_type;
                // $equip_val['item_name'] = $item_data[$item_type]['name'];
                // $equip_val['quality'] = $item_data[$item_type]['quality'];
                //获取装备的日志数据
                $table = 'item_log' . getLogTable('month', $start_time);

                $where_log = $where;
                $where_log .= "and type=" . $equip_val['item_type'] . " ";
                $log_data = $this->getLogData($this->game_log_db, $table, $where_log, $oprate_type);
                $equip_val['delta_sum'] = $log_data['sum'];
                $equip_val['delta_rid_count'] = $log_data['rid_count'];
                $equip_val['delta_count'] = $log_data['count'];
                $equip_val['delta_ratio'] = getDivision($equip_val['delta_sum'],$equip_val['sum']);    //总量占比
                $equip_val['delta_rid_ratio'] = getDivision($equip_val['delta_rid_count'],$equip_val['num']);      //人数占比
            }
        }elseif($item_class == 12){      //神装
            $count = $this->game_data_db->table('god_equip')
                ->join("
                    LEFT JOIN role on role.id=god_equip.rid
                ")
                ->where($where_god_type)
                ->group('sys_id')
                ->count();
            $count = count($count);
            $Page  = new \Think\Page($count,10);
            $list = $this->game_data_db->table('god_equip')
                ->field('
                    sys_id as type_id,
                    count(id) as sum,
                    count(distinct rid) as num
                ')
                ->where($where_god_type)
                ->group('sys_id')
                ->select();
            foreach($list as &$god_equip_val){
                $god_equip_val['sum_avg'] = getDivisionSpecial($god_equip_val['sum'],$god_equip_val['num'],0);  //平均每人多少
                $god_equip_val['item_type'] = $god_equip_val['type_id'];
                $god_equip_val['item_name'] = $item_data[$god_equip_val['type_id']]['name'];
                $god_equip_val['quality'] = $item_data[$god_equip_val['type_id']]['quality'];

                $where_log = $where;
                $where_log .= "and sys_id=" . $god_equip_val['type_id'] . " ";
                //获取时间段内的获得消耗情况（查询钻石流水日志）
                $table = 'god_equip_log' . getLogTable('month', $start_time);
                $log_data = $this->getLogData($this->game_log_db, $table, $where_log, $oprate_type);
                $god_equip_val['delta_sum'] = $log_data['sum'];
                $god_equip_val['delta_rid_count'] = $log_data['rid_count'];
                $god_equip_val['delta_count'] = $log_data['count'];
                $god_equip_val['delta_ratio'] = getDivision($god_equip_val['delta_sum'],$god_equip_val['sum']);    //总量占比
                $god_equip_val['delta_rid_ratio'] = getDivision($god_equip_val['delta_rid_count'],$god_equip_val['num']);      //人数占比
            }
            
        }elseif($item_class == 17){      //灵器
            $count = $this->game_data_db->table('reiki_equip')
                ->join("
                    LEFT JOIN role on role.id=reiki_equip.rid
                ")
                ->where($where_god_type)
                ->group('sys_id')
                ->count();
            $count = count($count);
            $Page  = new \Think\Page($count,10);
            $list = $this->game_data_db->table('reiki_equip')
                ->field('
                    sys_id as type_id,
                    count(id) as sum,
                    count(distinct rid) as num
                ')
                ->where($where_god_type)
                ->group('sys_id')
                ->select();
            foreach($list as &$reiki_equip_val){
                $reiki_equip_val['sum_avg'] = getDivisionSpecial($reiki_equip_val['sum'],$reiki_equip_val['num'],0);  //平均每人多少
                $reiki_equip_val['item_type'] = $reiki_equip_val['type_id'];
                $reiki_equip_val['item_name'] = $item_data[$reiki_equip_val['type_id']]['name'];
                $reiki_equip_val['quality'] = $item_data[$reiki_equip_val['type_id']]['quality'];

                $where_log = $where;
                $where_log .= "and sys_id=" . $reiki_equip_val['type_id'] . " ";
                //获取时间段内的获得消耗情况（查询钻石流水日志）
                $table = 'reiki_equip_log' . getLogTable('month', $start_time);
                $log_data = $this->getLogData($this->game_log_db, $table, $where_log, $oprate_type);
                $reiki_equip_val['delta_sum'] = $log_data['sum'];
                $reiki_equip_val['delta_rid_count'] = $log_data['rid_count'];
                $reiki_equip_val['delta_count'] = $log_data['count'];
                $reiki_equip_val['delta_ratio'] = getDivision($reiki_equip_val['delta_sum'],$reiki_equip_val['sum']);    //总量占比
                $reiki_equip_val['delta_rid_ratio'] = getDivision($reiki_equip_val['delta_rid_count'],$reiki_equip_val['num']);      //人数占比
            }
            
        }elseif($item_class == 6){  //道具
            if(!empty($item_type)){     //查询单个
                $count = 1;
                $where_equip = "id=$item_type";
            }else{      //查询全部装备
                $count = $this->platform_db->table('gift_item')
                    ->where('type=6 and type_label not in(1,5) ')
                    ->count();
                $where_equip = "type=6 and type_label not in(1,5) ";
            }
            $Page  = new \Think\Page($count,10);
            $item_type_arr = $this->platform_db->table('gift_item')
                ->where($where_equip)
                ->getField('id',true);
            $item_types = implode(',', $item_type_arr);
            $list = $this->game_data_db->table('back_pack')
                ->field("item_id,sum(num) as sum,count(item_id) as num")
                ->join("left join role on role.id=back_pack.rid")
                ->where("item_id in($item_types)" . $where_c_son_id_role)
                ->group('item_id')
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();
            foreach($list as &$item_val){
                $item_val['sum_avg'] = getDivisionSpecial($item_val['sum'],$item_val['num'],0);  //平均每人多少
                $item_val['item_type'] = $item_val['item_id'];
                $item_val['item_name'] = $item_data[$item_val['item_id']]['name'];
                $item_val['quality'] = $item_data[$item_val['item_id']]['quality'];

                $where_log = $where;
                $where_log .= "and type=" . $item_val['item_id'] . " ";
                //获取时间段内的获得消耗情况（查询钻石流水日志）
                $table = 'item_log' . getLogTable('month', $start_time);
                $log_data = $this->getLogData($this->game_log_db, $table, $where_log, $oprate_type);
                $item_val['delta_sum'] = $log_data['sum'];
                $item_val['delta_rid_count'] = $log_data['rid_count'];
                $item_val['delta_count'] = $log_data['count'];
                $item_val['delta_ratio'] = getDivision($item_val['delta_sum'],$item_val['sum']);    //总量占比
                $item_val['delta_rid_ratio'] = getDivision($item_val['delta_rid_count'],$item_val['num']);      //人数占比
            }
        }
        if(in_array($item_class, [1,2,3,5])){
            $list_info['sum_avg'] = getDivisionSpecial($list_info['sum'],$list_info['num'],0);  //平均每人多少
            $list_info['item_type'] = $item_type;
            $list_info['item_name'] = $item_data[$item_type]['name'];
            $list_info['quality'] = $item_data[$item_type]['quality'];
            $list_info['delta_sum'] = $log_data['sum'];
            $list_info['delta_rid_count'] = $log_data['rid_count'];
            $list_info['delta_count'] = $log_data['count'];
            $list_info['delta_ratio'] = getDivision($list_info['delta_sum'],$list_info['sum']);    //总量占比
            $list_info['delta_rid_ratio'] = getDivision($list_info['delta_rid_count'],$list_info['num']);      //人数占比
            $list[] = $list_info;
        }

        $show = $Page->show();
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'item_classs'=> $this->item_class, 'item_class_arr'=>$item_class_arr, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    private function getLogData($game_log_db, $table, $where, $oprate_type){
        if($oprate_type ==1){
            $log_data = $game_log_db->table($table)
                ->field('
                    sum(delta) as sum,
                    count(distinct rid) as rid_count,
                    count(id) count
                ')
                ->where($where)
                ->find();
        }else{
            $log_data = $game_log_db->table($table)
                ->field('
                    sum(-delta) as sum,
                    count(distinct rid) as rid_count,
                    count(id) count
                ')
                ->where($where)
                ->find();
        }
        return $log_data;
    }

    /*商城消费道具统计*/
    public function ShopLog(){

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();

        //获取所有的礼包道具
        $item_list = M('gift_item')->select();
        $item_data = [];
        foreach($item_list as $item_val){
            $item_data[$item_val['id']] = $item_val;
        }

        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $today_date = I('today_date', date('Y-m-d'));    //日期
        $shop_type = I('shop_type', '0');
        $item_type = I('item_type', '0');         //商品类型（获得道具）
        $currency_type = I('currency_type', '0');       //货币类型（消耗道具）

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'today_date' => $today_date,
            'shop_type' => $shop_type,
            'item_type' => $item_type,
            'currency_type' => $currency_type,
        ];

        //判断时间是否都选择
        if(empty($sid) || empty($today_date)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器和日期！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'shop_types'=> $this->shop_types, 'item_list'=>$item_list, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $where = "1 ";
        if(!empty($c_son_id)){
            $where .= "and place in($c_son_id) ";
        }
        if(!empty($today_date)){
            $where .= "and dateTime >=" . strtotime(date('Y-m-d', strtotime($today_date)) . ' 00:00:00') . ' ';
            $where .= "and dateTime <=" . strtotime(date('Y-m-d', strtotime($today_date)) . ' 23:59:59') . ' ';
        }
        if(!empty($shop_type)){
            $where .= "and shop_type=$shop_type ";
        }
        if(!empty($item_type)){
            $where .= "and reward_item_type in($item_type) ";
        }
        if(!empty($currency_type)){
            $where .= "and cost_item_type=$currency_type ";
        }

        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $this->game_log_db = connectionDb($server_info, 'log');     //连接游戏日志库
        $table = 'shop_log' . getLogTable('month', $today_date);

        $subQuery = $this->game_log_db->table($table)
            ->field('
                shop_type,
                reward_item_type,
                buy_times,
                reward_item_num,
                cost_item_type,
                sum(cost_item_num) as cost_item_nums,
                cost_item_num,
                rid,
                count(rid) as buy_count
            ')
            ->where($where)
            ->group('shop_type,reward_item_type,cost_item_type,cost_item_num,rid')
            ->buildSql();
        $count = $this->game_log_db->table($subQuery.' a')
            ->group('shop_type,reward_item_type')
            ->count();
        $Page  = new \Think\Page($count, 30);
        $list = $this->game_log_db->table($subQuery.' aa')
            ->field('
                shop_type,
                reward_item_type,
                buy_times,
                reward_item_num,
                cost_item_type,
                sum(cost_item_nums) as cost_item_total,
                cost_item_num,
                count(rid) as num,
                sum(buy_count) as buy_counts
            ')
            ->group('shop_type,reward_item_type,cost_item_type,cost_item_num')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        foreach($list as &$val){
            $val['date'] = $today_date;
            //获取消耗和获得道具的名称
            $val['reward_item_name'] = isset($item_data[$val['reward_item_type']]) ? $item_data[$val['reward_item_type']]['name'] : '';
            $val['cost_item_name'] = isset($item_data[$val['cost_item_type']]) ? $item_data[$val['cost_item_type']]['name'] : '';
            $val['price'] = $val['cost_item_num'];         //商品的价格
            $val['per_capita_num'] = getDivisionSpecial($val['buy_counts'], $val['num']);                   //人均购买次数
            $val['shop_name'] = isset($this->shop_types[$val['shop_type']]) ? $this->shop_types[$val['shop_type']]['name'] : '';    //商城名城
        }
        
        //计算汇总数据
        $data_total = $this->game_log_db->table($subQuery.' aa')
            ->field('
                reward_item_num,
                sum(cost_item_nums) as cost_item_total,
                count(rid) as num,
                sum(buy_count) as buy_counts
            ')
            ->find();
        
        $list[] = [
            'date' => '汇总',
            'shop_type' => '',
            'reward_item_type' => '',
            'buy_times' => '',
            'reward_item_name' => '',
            'cost_item_type' => '',
            'cost_item_name' => '',
            'shop_name' => '',
            'reward_item_num' => '',
            'cost_item_total' => $data_total['cost_item_total'],
            'num' => $data_total['num'],
            'buy_counts' => $data_total['buy_counts'],
            'price' => '',
            'per_capita_num' => getDivisionSpecial($data_total['buy_counts'], $data_total['num']),
        ];

        $show = $Page->show();
        $this->assign(['list'=>$list, 'count'=>$count, 'page'=>$show, 'channels' => $channels, 'shop_types'=> $this->shop_types, 'item_list'=>$item_list, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*英雄星级统计*/
    public function HeroStar(){

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where($this->channel_where)->select();

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->where($this->server_where)->select();

        //获取所有的礼包道具
        $item_list = M('gift_item')->select();
        $item_data = [];
        foreach($item_list as $item_val){
            $item_data[$item_val['id']] = $item_val;
        }

        //记录搜索条件
        $now_date = date('Y-m-d');
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);
        $type = I('type', '1');

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'start_time' => $start_time,
            'end_time' => $end_time,
            'type' => $type,
        ];

        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        if( date('Y-m', strtotime($start_time)) != date('Y-m', strtotime($end_time)) ){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间必须是同月！！！', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $where = "1 ";
        if(!empty($c_son_id)){
            $where .= "and place in($c_son_id) ";
        }

        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $game_log_db = connectionDb($server_info, 'log');     //连接游戏日志库
        $game_data_db = connectionDb($server_info, 'data');     //连接游戏日志库

        $days = getTimeslotDays(strtotime($start_time), strtotime($end_time));
        //遍历日期范围处理数据
        $list = [];
        for($i=0; $i<$days; $i++){
            $start_time_son = strtotime($start_time) + 86400 * $i;
            $end_time_son = $start_time_son + 86400;
            $today_date = date('Y-m-d', $start_time_son);
            //获取活跃人
            $table = 'role_login_log' . getLogTable('month', $today_date);
            $login_where = $where;
            $login_where .= " and login_time>=$start_time_son and login_time<$end_time_son";
            $role_ids = $game_log_db->table($table)
                ->field('rid')
                ->where($login_where)
                ->group('rid')
                ->getField('rid',true);
            $role_num = count($role_ids);
            if(!empty($role_ids)){
                $role_ids = implode(',', $role_ids);
            }else{
                $role_ids = '1';
            }

            if($type == 1){     //统计类型：1.拥有人数，2.英雄数
                $hero_where = '1 ';
                $hero_where .= " and rid in($role_ids) and star>4";
                $hero_data = $game_data_db->table("hero")
                    ->field("star,count(distinct rid) as role_num")
                    ->where($hero_where)
                    ->group('star')
                    ->select();
                $hero_data_re = [];   
                foreach($hero_data as $hero_val){
                    $hero_data_re[$hero_val['star']] = $hero_val;
                }
                $list_val = [
                    'date' => $today_date,
                    'role_num' => $role_num,
                ];
                for($j=5; $j<=12; $j++){
                    if(isset($hero_data_re[$j])){
                        $list_val['star_' . $j] = $hero_data_re[$j]['role_num'] . '|' . getDivision($hero_data_re[$j]['role_num'],$role_num) . '%';
                    }else{
                        $list_val['star_' . $j] = '';
                    }
                }
            }else{
                $hero_where = $where;
                $hero_where .= " and rid in($role_ids) and star>4";
                $hero_data = $game_data_db->table("hero")
                    ->field("star,count(rid) as role_num")
                    ->where($hero_where)
                    ->group('star')
                    ->select();
                $hero_data_re = [];   
                foreach($hero_data as $hero_val){
                    $hero_data_re[$hero_val['star']] = $hero_val;
                }
                $list_val = [
                    'date' => $today_date,
                    'role_num' => $role_num,
                ];
                for($j=5; $j<=12; $j++){
                    if(isset($hero_data_re[$j])){
                        $list_val['star_' . $j] = $hero_data_re[$j]['role_num'];
                    }else{
                        $list_val['star_' . $j] = '';
                    }
                }
            }
            $list[] = $list_val;
        }
        
        $this->assign(['list'=>$list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }


}
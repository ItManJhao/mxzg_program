<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 道具每日库存统计
 */
class ItemDayController extends PublicController{
    protected $game_log_db;

    /**
     * 查询要处理的数据入口
     */
    public function entry(){
        ini_set('memory_limit','512M'); //临时提高内存

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
                    echo '渠道--' . $channel_val['name'] . '，区服--' . $server_val['server_name'] . '，道具每日统计处理';
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
        $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库

        //获取所有的道具数据
        //获取所有的礼包道具
        $item_list = M('gift_item')->select();
        $item_datas = getItemTypeData($item_list, 0);
        $item_data = $item_datas['item_data'];              //用于处理数据的显示
        $item_class_arr = $item_datas['item_class_arr'];    //用于页面二级下拉框筛选

        //当日活跃用户
        $table = 'role_login_log' . getLogTable('month', $this->date);
        $active_role_ids = $this->game_log_db->table($table)    //活跃用户
            ->where("place=$channel_id and login_time>=$start_time and login_time<=$end_time ")
            ->group('rid')
            ->getField('rid',true);
        $active_role = count($active_role_ids);   //活跃用户人数

        //去新（老）活跃用户
        $create_role_ids = $this->game_log_db->table('role_create_log')
            ->where("place=$channel_id and create_time>=$start_time and create_time<=$end_time")
            ->getField('rid',true);
        if(!empty($create_role_ids)){
            $create_role_str = implode(',', $create_role_ids);  //新用户
            $where = "place=$channel_id and login_time>=$start_time and login_time<=$end_time and rid not in ($create_role_str)";
        }else{
            $where = "place=$channel_id and login_time>=$start_time and login_time<=$end_time";
        }
        $table = 'role_login_log' . getLogTable('month', $this->date);
        $old_active_role_ids = $this->game_log_db->table($table)    //去新活跃用户
            ->where($where)
            ->group('rid')
            ->getField('rid',true);
        $old_active_role = count($old_active_role_ids);   //去新活跃用户人数


        //1.处理金币数据
        foreach($item_class_arr[1] as $gold_val){
            $item_day_info = $this->data_analysis_db->table('item_day')
                ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}' and item_type={$gold_val['id']}")
                ->find();
            //计算当日累计获得
            $table = 'gold_log' . getLogTable('month', $this->date);
            $get_num = $this->game_log_db->table($table)    //累计获得
                ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta>0")
                ->sum('delta');
            $get_num = !empty($get_num) ? $get_num : 0;
            $out_num = $this->game_log_db->table($table)    //累计消耗
                ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta<0")
                ->sum('delta');
            $out_num = !empty($out_num) ? $out_num : 0;
            $out_num = abs($out_num);
            $role_data = $this->game_data_db->table('role')    //剩余库存以及拥有人数
                ->field('sum(gold) as surplus_num,count(id) as surplus_role')
                ->where("place=$channel_id and gold>0")
                ->find();

            if($active_role > 0){
                $active_role_id_str = implode(',', $active_role_ids);
                $active_num = $this->game_data_db->table('role')    //活跃用户库存
                    ->where("place=$channel_id and id in ($active_role_id_str)")
                    ->sum('gold');
                $active_num = !empty($active_num) ? $active_num : 0;
            }else{
                $active_num = 0;
            }
            
            if($old_active_role > 0){
                $old_active_role_id_str = implode(',', $old_active_role_ids);
                $old_active_num = $this->game_data_db->table('role')    //去新活跃用户库存
                    ->where("place=$channel_id and id in ($old_active_role_id_str)")
                    ->sum('gold');
                $old_active_num = !empty($old_active_num) ? $old_active_num : 0;
            }else{
                $old_active_num = 0;
            }
            $day_data = [
                'c_id' => $parent_channel_id,
                'c_son_id' => $channel_id,
                'sid' => $sid,
                'date' => $this->date,
                'item_type' => $gold_val['id'],
                'item_name' => $gold_val['name'],
                'item_quality' => $gold_val['quality'],
                'get_num' => $get_num,
                'out_num' => $out_num,
                'surplus_num' => !empty($role_data['surplus_num']) ? $role_data['surplus_num'] : 0,
                'surplus_role' => $role_data['surplus_role'],
                'active_role' => $active_role,
                'active_num' => $active_num,
                'old_active_role' => $old_active_role,
                'old_active_num' => $old_active_num,
            ];
            if($item_day_info){    //修改
                $res = $this->data_analysis_db->table('item_day')->where("id=" . $item_day_info['id'])->save($day_data);
            }else{                      //添加
                $day_data['created_at'] = time();
                $res = $this->data_analysis_db->table('item_day')->add($day_data);
            }
        }

        //2.处理钻石数据
        foreach($item_class_arr[2] as $gem_val){
            $item_day_info = $this->data_analysis_db->table('item_day')
                ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}' and item_type={$gem_val['id']}")
                ->find();
            //计算当日累计获得
            $table = 'gem_log' . getLogTable('month', $this->date);
            $get_num = $this->game_log_db->table($table)    //累计获得
                ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta>0")
                ->sum('delta');
            $get_num = !empty($get_num) ? $get_num : 0;
            $out_num = $this->game_log_db->table($table)    //累计消耗
                ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta<0")
                ->sum('delta');
            $out_num = !empty($out_num) ? $out_num : 0;
            $out_num = abs($out_num);
            $role_data = $this->game_data_db->table('role')    //剩余库存以及拥有人数
                ->field('sum(gem) as surplus_num,count(id) as surplus_role')
                ->where("place=$channel_id and gem>0")
                ->find();

            if($active_role > 0){
                $active_role_id_str = implode(',', $active_role_ids);
                $active_num = $this->game_data_db->table('role')    //活跃用户库存
                    ->where("place=$channel_id and id in ($active_role_id_str)")
                    ->sum('gem');
                $active_num = !empty($active_num) ? $active_num : 0;
            }else{
                $active_num = 0;
            }
            
            if($old_active_role > 0){
                $old_active_role_id_str = implode(',', $old_active_role_ids);
                $old_active_num = $this->game_data_db->table('role')    //去新活跃用户库存
                    ->where("place=$channel_id and id in ($old_active_role_id_str)")
                    ->sum('gem');
                $old_active_num = !empty($old_active_num) ? $old_active_num : 0;
            }else{
                $old_active_num = 0;
            }
            $day_data = [
                'c_id' => $parent_channel_id,
                'c_son_id' => $channel_id,
                'sid' => $sid,
                'date' => $this->date,
                'item_type' => $gem_val['id'],
                'item_name' => $gem_val['name'],
                'item_quality' => $gem_val['quality'],
                'get_num' => $get_num,
                'out_num' => $out_num,
                'surplus_num' => !empty($role_data['surplus_num']) ? $role_data['surplus_num'] : 0,
                'surplus_role' => $role_data['surplus_role'],
                'active_role' => $active_role,
                'active_num' => $active_num,
                'old_active_role' => $old_active_role,
                'old_active_num' => $old_active_num,
            ];
            if($item_day_info){    //修改
                $res = $this->data_analysis_db->table('item_day')->where("id=" . $item_day_info['id'])->save($day_data);
            }else{                      //添加
                $day_data['created_at'] = time();
                $res = $this->data_analysis_db->table('item_day')->add($day_data);
            }
        }
        
        //3.处理角色经验数据
        foreach($item_class_arr[3] as $exp_val){
            $item_day_info = $this->data_analysis_db->table('item_day')
                ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}' and item_type={$exp_val['id']}")
                ->find();
            //计算当日累计获得
            $table = 'role_exp_log' . getLogTable('month', $this->date);
            $get_num = $this->game_log_db->table($table)    //累计获得
                ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta>0")
                ->sum('delta');
            $get_num = !empty($get_num) ? $get_num : 0;
            $out_num = $this->game_log_db->table($table)    //累计消耗
                ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta<0")
                ->sum('delta');
            $out_num = !empty($out_num) ? $out_num : 0;
            $out_num = abs($out_num);
            $role_data = $this->game_data_db->table('role')    //剩余库存以及拥有人数
                ->field('sum(exp) as surplus_num,count(id) as surplus_role')
                ->where("place=$channel_id and exp>0")
                ->find();

            if($active_role > 0){
                $active_role_id_str = implode(',', $active_role_ids);
                $active_num = $this->game_data_db->table('role')    //活跃用户库存
                    ->where("place=$channel_id and id in ($active_role_id_str)")
                    ->sum('exp');
                $active_num = !empty($active_num) ? $active_num : 0;
            }else{
                $active_num = 0;
            }
            
            if($old_active_role > 0){
                $old_active_role_id_str = implode(',', $old_active_role_ids);
                $old_active_num = $this->game_data_db->table('role')    //去新活跃用户库存
                    ->where("place=$channel_id and id in ($old_active_role_id_str)")
                    ->sum('exp');
                $old_active_num = !empty($old_active_num) ? $old_active_num : 0;
            }else{
                $old_active_num = 0;
            }
            $day_data = [
                'c_id' => $parent_channel_id,
                'c_son_id' => $channel_id,
                'sid' => $sid,
                'date' => $this->date,
                'item_type' => $exp_val['id'],
                'item_name' => $exp_val['name'],
                'item_quality' => $exp_val['quality'],
                'get_num' => $get_num,
                'out_num' => $out_num,
                'surplus_num' => !empty($role_data['surplus_num']) ? $role_data['surplus_num'] : 0,
                'surplus_role' => $role_data['surplus_role'],
                'active_role' => $active_role,
                'active_num' => $active_num,
                'old_active_role' => $old_active_role,
                'old_active_num' => $old_active_num,
            ];
            if($item_day_info){    //修改
                $res = $this->data_analysis_db->table('item_day')->where("id=" . $item_day_info['id'])->save($day_data);
            }else{                      //添加
                $day_data['created_at'] = time();
                $res = $this->data_analysis_db->table('item_day')->add($day_data);
            }
        }

        //4.处理英雄经验数据
        foreach($item_class_arr[5] as $hero_exp_val){
            $item_day_info = $this->data_analysis_db->table('item_day')
                ->where("c_son_id=$channel_id and sid=$sid and date='{$this->date}' and item_type={$hero_exp_val['id']}")
                ->find();
            //计算当日累计获得
            $table = 'hero_exp_log' . getLogTable('month', $this->date);
            $get_num = $this->game_log_db->table($table)    //累计获得
                ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta>0")
                ->sum('delta');
            $get_num = !empty($get_num) ? $get_num : 0;
            $out_num = $this->game_log_db->table($table)    //累计消耗
                ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta<0")
                ->sum('delta');
            $out_num = !empty($out_num) ? $out_num : 0;
            $out_num = abs($out_num);
            $role_data = $this->game_data_db->table('role')    //剩余库存以及拥有人数
                ->field('sum(hero_exp) as surplus_num,count(id) as surplus_role')
                ->where("place=$channel_id and hero_exp>0")
                ->find();

            if($active_role > 0){
                $active_role_id_str = implode(',', $active_role_ids);
                $active_num = $this->game_data_db->table('role')    //活跃用户库存
                    ->where("place=$channel_id and id in ($active_role_id_str)")
                    ->sum('hero_exp');
                $active_num = !empty($active_num) ? $active_num : 0;
            }else{
                $active_num = 0;
            }
            
            if($old_active_role > 0){
                $old_active_role_id_str = implode(',', $old_active_role_ids);
                $old_active_num = $this->game_data_db->table('role')    //去新活跃用户库存
                    ->where("place=$channel_id and id in ($old_active_role_id_str)")
                    ->sum('hero_exp');
                $old_active_num = !empty($old_active_num) ? $old_active_num : 0;
            }else{
                $old_active_num = 0;
            }
            $day_data = [
                'c_id' => $parent_channel_id,
                'c_son_id' => $channel_id,
                'sid' => $sid,
                'date' => $this->date,
                'item_type' => $hero_exp_val['id'],
                'item_name' => $hero_exp_val['name'],
                'item_quality' => $hero_exp_val['quality'],
                'get_num' => $get_num,
                'out_num' => $out_num,
                'surplus_num' => !empty($role_data['surplus_num']) ? $role_data['surplus_num'] : 0,
                'surplus_role' => $role_data['surplus_role'],
                'active_role' => $active_role,
                'active_num' => $active_num,
                'old_active_role' => $old_active_role,
                'old_active_num' => $old_active_num,
            ];
            if($item_day_info){    //修改
                $res = $this->data_analysis_db->table('item_day')->where("id=" . $item_day_info['id'])->save($day_data);
            }else{                      //添加
                $day_data['created_at'] = time();
                $res = $this->data_analysis_db->table('item_day')->add($day_data);
            }
        }

        //5.处理精灵数据
        $day_data = [];
        $item_id_arr = array_column($item_class_arr[8], 'id');
        $item_id_str = implode(',', $item_id_arr);
        $item_arr_re = [];
        foreach($item_class_arr[8] as $item_val){
            $item_arr_re[$item_val['id']] = $item_val;
            $day_data[$item_val['id']] = [
                'c_id' => $parent_channel_id,
                'c_son_id' => $channel_id,
                'sid' => $sid,
                'date' => $this->date,
                'item_type' => $item_val['id'],
                'item_name' => $item_val['name'],
                'item_quality' => $item_val['quality'],
                'get_num' => 0,
                'out_num' => 0,
                'surplus_num' => 0,
                'surplus_role' => 0,
                'active_role' => $active_role,
                'active_num' => 0,
                'old_active_role' => $old_active_role,
                'old_active_num' => 0,
                'created_at' => time()
            ];
        }
        //计算当日累计获得
        $table = 'rune_log' . getLogTable('month', $this->date);
        $get_num_data = $this->game_log_db->table($table)    //累计获得
            ->field("sum(delta) as get_num,type")
            ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta>0 and type in($item_id_str)")
            ->group("type")
            ->select();
        foreach($get_num_data as $get_num_data_val){
            if(!empty($get_num_data_val['get_num'])){
                if(isset($day_data[$get_num_data_val['type']])){
                    $day_data[$get_num_data_val['type']]['get_num'] = $get_num_data_val['get_num'];
                }
            }
        }
        $out_num_data = $this->game_log_db->table($table)    //累计消耗
            ->field("sum(delta) as get_num,type")
            ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta<0 and type in($item_id_str)")
            ->group("type")
            ->select();
        foreach($out_num_data as $out_num_data_val){
            if(!empty($out_num_data_val['out_num'])){
                if(isset($day_data[$out_num_data_val['type']])){
                    $day_data[$out_num_data_val['type']]['out_num'] = $out_num_data_val['out_num'];
                }
            }
        }
        $role_data = $this->game_data_db->table('rune_info')    //剩余库存以及拥有人数
            ->field('count(rune_info.id) as surplus_num,count(distinct rune_info.rid) as surplus_role,type_id as type')
            ->join("left join role on role.id=rune_info.rid")
            ->where("role.place=$channel_id and rune_info.type_id in($item_id_str)")
            ->group("type_id")
            ->select();
        foreach($role_data as $role_data_val){
            if(!empty($role_data_val['surplus_num'])){
                if(isset($day_data[$role_data_val['type']])){
                    $day_data[$role_data_val['type']]['surplus_num'] = $role_data_val['surplus_num'];
                    $day_data[$role_data_val['type']]['surplus_role'] = $role_data_val['surplus_role'];
                }
            }
        }

        if($active_role > 0){
            $active_role_id_str = implode(',', $active_role_ids);
            $active_num_data = $this->game_data_db->table('rune_info')    //活跃用户库存
                ->field('count(rune_info.id) as old_active_num,type_id as type')
                ->join("left join role on role.id=rune_info.rid")
                ->where("role.place=$channel_id and rune_info.type_id in($item_id_str) and rune_info.rid in ($active_role_id_str)")
                ->group("type_id")
                ->select();
            foreach($active_num_data as $active_num_data_val){
                if(!empty($active_num_data_val['active_num'])){
                    if(isset($day_data[$active_num_data_val['type']])){
                        $day_data[$active_num_data_val['type']]['active_num'] = $active_num_data_val['active_num'];
                    }
                }
            }
        }
        
        if($old_active_role > 0){
            $old_active_role_id_str = implode(',', $old_active_role_ids);
            $old_active_num_data = $this->game_data_db->table('rune_info')    //去新活跃用户库存
                ->field('count(rune_info.id) as old_active_num,type_id as type')
                ->join("left join role on role.id=rune_info.rid")
                ->where("role.place=$channel_id and rune_info.type_id in($item_id_str) and rune_info.rid in ($old_active_role_id_str)")
                ->group("type_id")
                ->select();
            foreach($old_active_num_data as $old_active_num_data_val){
                if(isset($day_data[$old_active_num_data_val['type']])){
                    if(!empty($old_active_num_data_val['old_active_num'])){
                        $day_data[$old_active_num_data_val['type']]['old_active_num'] = $old_active_num_data_val['old_active_num'];
                    }
                }
            }
        }
        foreach($day_data as &$day_data_val){
            if( empty($day_data_val['get_num']) && empty($day_data_val['out_num']) && empty($day_data_val['surplus_num']) 
            && empty($day_data_val['surplus_role']) && empty($day_data_val['active_num'])  && empty($day_data_val['old_active_num']) ){   //数据都是0，不做插入操作
                unset($day_data[$day_data_val['item_type']]);
            }
        }
        $day_data = array_values($day_data);
        $res = $this->data_analysis_db->table('item_day')->addAll($day_data,[],true);

        //6.处理装备数据
        $day_data = [];
        foreach($item_class_arr[61] as $item_val){
            //计算当日累计获得
            $table = 'item_log' . getLogTable('month', $this->date);
            $get_num = $this->game_log_db->table($table)    //累计获得
                ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta>0 and type={$item_val['id']}")
                ->sum('delta');
            $get_num = !empty($get_num) ? $get_num : 0;
            $out_num = $this->game_log_db->table($table)    //累计消耗
                ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta<0 and type={$item_val['id']}")
                ->sum('delta');
            $out_num = !empty($out_num) ? $out_num : 0;
            $out_num = abs($out_num);
            //获取装备在背包表和英雄装备表中有多少
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
                    where role.place=$channel_id and sys_id=" . $equip_val['item_type'] . "
                    GROUP BY rid) as tmp on tmp.rid=bp.rid
                ")
                ->join("left join role on role.id=bp.rid")
                ->where("role.place=$channel_id and item_id=" . $equip_val['item_type'] . " and (bp.num>0 or tmp.he_count>0) ")
                ->find();
            $surplus_num = $back_pack_data['bp_sum'] + $back_pack_data['he_sum'];
            $surplus_role = $back_pack_data['rid_count'];

            if($active_role > 0){
                $active_role_id_str = implode(',', $active_role_ids);
                //获取装备在背包表和英雄装备表中有多少
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
                        where role.place=$channel_id and sys_id=" . $equip_val['item_type'] . " and he.rid in ($active_role_id_str) 
                        GROUP BY rid) as tmp on tmp.rid=bp.rid
                    ")
                    ->join("left join role on role.id=bp.rid")
                    ->where("role.place=$channel_id and item_id=" . $equip_val['item_type'] . " and bp.rid in ($active_role_id_str) and (bp.num>0 or tmp.he_count>0) ")
                    ->find();
                $active_num = $back_pack_data['bp_sum'] + $back_pack_data['he_sum'];
            }else{
                $active_num = 0;
            }
            
            if($old_active_role > 0){
                $old_active_role_id_str = implode(',', $old_active_role_ids);
                //获取装备在背包表和英雄装备表中有多少
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
                        where sys_id=" . $equip_val['item_type'] . " and he.rid in ($old_active_role_id_str) 
                        GROUP BY rid) as tmp on tmp.rid=bp.rid
                    ")
                    ->join("left join role on role.id=bp.rid")
                    ->where("role.place=$channel_id and item_id=" . $equip_val['item_type'] . " and bp.rid in ($old_active_role_id_str) and (bp.num>0 or tmp.he_count>0) ")
                    ->find();
                $old_active_num = $back_pack_data['bp_sum'] + $back_pack_data['he_sum'];
            }else{
                $old_active_num = 0;
            }
            if(!empty($get_num) || !empty($out_num) || !empty($surplus_num) || !empty($surplus_role) || !empty($active_num) || !empty($old_active_num)){
                $day_data[] = [
                    'c_id' => $parent_channel_id,
                    'c_son_id' => $channel_id,
                    'sid' => $sid,
                    'date' => $this->date,
                    'item_type' => $item_val['id'],
                    'item_name' => $item_val['name'],
                    'item_quality' => $item_val['quality'],
                    'get_num' => $get_num,
                    'out_num' => $out_num,
                    'surplus_num' => $surplus_num,
                    'surplus_role' => $surplus_role,
                    'active_role' => $active_role,
                    'active_num' => $active_num,
                    'old_active_role' => $old_active_role,
                    'old_active_num' => $old_active_num,
                    'created_at' => time()
                ];
            }
            
        }
        $this->data_analysis_db->table('item_day')->addAll($day_data,[],true);
        
        //7.处理宝石数据
        $day_data = [];
        foreach($item_class_arr[65] as $item_val){
            //计算当日累计获得
            $table = 'item_log' . getLogTable('month', $this->date);
            $get_num = $this->game_log_db->table($table)    //累计获得
                ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta>0 and type={$item_val['id']}")
                ->sum('delta');
            $get_num = !empty($get_num) ? $get_num : 0;
            $out_num = $this->game_log_db->table($table)    //累计消耗
                ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta<0 and type={$item_val['id']}")
                ->sum('delta');
            $out_num = !empty($out_num) ? $out_num : 0;
            $out_num = abs($out_num);
            //获取装备在背包表和英雄装备表中有多少
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
                    where role.place=$channel_id and sys_id=" . $equip_val['item_type'] . "
                    GROUP BY rid) as tmp on tmp.rid=bp.rid
                ")
                ->join("left join role on role.id=bp.rid")
                ->where("role.place=$channel_id and item_id=" . $equip_val['item_type'] . " and (bp.num>0 or tmp.he_count>0) ")
                ->find();
            $surplus_num = $back_pack_data['bp_sum'] + $back_pack_data['he_sum'];
            $surplus_role = $back_pack_data['rid_count'];

            if($active_role > 0){
                $active_role_id_str = implode(',', $active_role_ids);
                //获取装备在背包表和英雄装备表中有多少
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
                        where role.place=$channel_id and sys_id=" . $equip_val['item_type'] . " and he.rid in ($active_role_id_str) 
                        GROUP BY rid) as tmp on tmp.rid=bp.rid
                    ")
                    ->join("left join role on role.id=bp.rid")
                    ->where("role.place=$channel_id and item_id=" . $equip_val['item_type'] . " and bp.rid in ($active_role_id_str) and (bp.num>0 or tmp.he_count>0) ")
                    ->find();
                $active_num = $back_pack_data['bp_sum'] + $back_pack_data['he_sum'];
            }else{
                $active_num = 0;
            }
            
            if($old_active_role > 0){
                $old_active_role_id_str = implode(',', $old_active_role_ids);
                //获取装备在背包表和英雄装备表中有多少
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
                        where sys_id=" . $equip_val['item_type'] . " and he.rid in ($old_active_role_id_str) 
                        GROUP BY rid) as tmp on tmp.rid=bp.rid
                    ")
                    ->join("left join role on role.id=bp.rid")
                    ->where("role.place=$channel_id and item_id=" . $equip_val['item_type'] . " and bp.rid in ($old_active_role_id_str) and (bp.num>0 or tmp.he_count>0) ")
                    ->find();
                $old_active_num = $back_pack_data['bp_sum'] + $back_pack_data['he_sum'];
            }else{
                $old_active_num = 0;
            }
            if(!empty($get_num) || !empty($out_num) || !empty($surplus_num) || !empty($surplus_role) || !empty($active_num) || !empty($old_active_num)){
                $day_data[] = [
                    'c_id' => $parent_channel_id,
                    'c_son_id' => $channel_id,
                    'sid' => $sid,
                    'date' => $this->date,
                    'item_type' => $item_val['id'],
                    'item_name' => $item_val['name'],
                    'item_quality' => $item_val['quality'],
                    'get_num' => $get_num,
                    'out_num' => $out_num,
                    'surplus_num' => $surplus_num,
                    'surplus_role' => $surplus_role,
                    'active_role' => $active_role,
                    'active_num' => $active_num,
                    'old_active_role' => $old_active_role,
                    'old_active_num' => $old_active_num,
                    'created_at' => time()
                ];
            }
        }
        $this->data_analysis_db->table('item_day')->addAll($day_data,[],true);

        //8.处理神装数据
        $day_data = [];
        $item_id_arr = array_column($item_class_arr[12], 'id');
        $item_id_str = implode(',', $item_id_arr);
        $item_arr_re = [];
        foreach($item_class_arr[12] as $item_val){
            $item_arr_re[$item_val['id']] = $item_val;
            $day_data[$item_val['id']] = [
                'c_id' => $parent_channel_id,
                'c_son_id' => $channel_id,
                'sid' => $sid,
                'date' => $this->date,
                'item_type' => $item_val['id'],
                'item_name' => $item_val['name'],
                'item_quality' => $item_val['quality'],
                'get_num' => 0,
                'out_num' => 0,
                'surplus_num' => 0,
                'surplus_role' => 0,
                'active_role' => $active_role,
                'active_num' => 0,
                'old_active_role' => $old_active_role,
                'old_active_num' => 0,
                'created_at' => time()
            ];
        }
        //计算当日累计获得
        $table = 'god_equip_log' . getLogTable('month', $this->date);
        $get_num_data = $this->game_log_db->table($table)    //累计获得
            ->field("sum(delta) as get_num,sys_id as type")
            ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta>0 and sys_id in($item_id_str)")
            ->group("sys_id")
            ->select();
        foreach($get_num_data as $get_num_data_val){
            if(!empty($get_num_data_val['get_num'])){
                if(isset($day_data[$get_num_data_val['type']])){
                    $day_data[$get_num_data_val['type']]['get_num'] = $get_num_data_val['get_num'];
                }
            }
        }
        $out_num_data = $this->game_log_db->table($table)    //累计消耗
            ->field("sum(delta) as out_num,sys_id as type")
            ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta<0 and sys_id in($item_id_str)")
            ->group("sys_id")
            ->select();
        foreach($out_num_data as $out_num_data_val){
            if(!empty($out_num_data_val['out_num'])){
                if(isset($day_data[$out_num_data_val['type']])){
                    $day_data[$out_num_data_val['type']]['out_num'] = $out_num_data_val['out_num'];
                }
            }
        }
        $out_num = !empty($out_num) ? $out_num : 0;
        $out_num = abs($out_num);
        $role_data = $this->game_data_db->table('god_equip')    //剩余库存以及拥有人数
            ->field('count(god_equip.id) as surplus_num,count(distinct god_equip.rid) as surplus_role,sys_id as type')
            ->join("left join role on role.id=god_equip.rid")
            ->where("role.place=$channel_id and god_equip.sys_id in($item_id_str)")
            ->group("sys_id")
            ->select();
        foreach($role_data as $role_data_val){
            if(!empty($role_data_val['surplus_num'])){
                if(isset($day_data[$role_data_val['type']])){
                    $day_data[$role_data_val['type']]['surplus_num'] = $role_data_val['surplus_num'];
                    $day_data[$role_data_val['type']]['surplus_role'] = $role_data_val['surplus_role'];
                }
            }
        }
        if($active_role > 0){
            $active_role_id_str = implode(',', $active_role_ids);
            $active_num_data = $this->game_data_db->table('god_equip')    //活跃用户库存
                ->field('count(god_equip.id) as active_num,sys_id as type')
                ->join("left join role on role.id=god_equip.rid")
                ->where("role.place=$channel_id and god_equip.sys_id in($item_id_str) and god_equip.rid in ($active_role_id_str)")
                ->group("sys_id")
                ->select();
            foreach($active_num_data as $active_num_data_val){
                if(!empty($active_num_data_val['active_num'])){
                    if(isset($day_data[$active_num_data_val['type']])){
                        $day_data[$active_num_data_val['type']]['active_num'] = $active_num_data_val['active_num'];
                    }
                }
            }
        }
        
        if($old_active_role > 0){
            $old_active_role_id_str = implode(',', $old_active_role_ids);
            $old_active_num_data = $this->game_data_db->table('god_equip')    //去新活跃用户库存
                ->field('count(god_equip.id) as old_active_num,sys_id as type')
                ->join("left join role on role.id=god_equip.rid")
                ->where("role.place=$channel_id and god_equip.sys_id in($item_id_str) and god_equip.rid in ($old_active_role_id_str)")
                ->group("sys_id")
                ->select();
            foreach($old_active_num_data as $old_active_num_data_val){
                if(isset($day_data[$old_active_num_data_val['type']])){
                    if(!empty($old_active_num_data_val['old_active_num'])){
                        $day_data[$old_active_num_data_val['type']]['old_active_num'] = $old_active_num_data_val['old_active_num'];
                    }
                }
            }
        }
        foreach($day_data as &$day_data_val){
            if( empty($day_data_val['get_num']) && empty($day_data_val['out_num']) && empty($day_data_val['surplus_num']) 
            && empty($day_data_val['surplus_role']) && empty($day_data_val['active_num'])  && empty($day_data_val['old_active_num']) ){   //数据都是0，不做插入操作
                unset($day_data[$day_data_val['item_type']]);
            }
        }
        
        $day_data = array_values($day_data);
        $this->data_analysis_db->table('item_day')->addAll($day_data,[],true);


        //9.处理灵器数据
        $day_data = [];
        $item_id_arr = array_column($item_class_arr[17], 'id');
        $item_id_str = implode(',', $item_id_arr);
        $item_arr_re = [];
        foreach($item_class_arr[17] as $item_val){
            $item_arr_re[$item_val['id']] = $item_val;
            $day_data[$item_val['id']] = [
                'c_id' => $parent_channel_id,
                'c_son_id' => $channel_id,
                'sid' => $sid,
                'date' => $this->date,
                'item_type' => $item_val['id'],
                'item_name' => $item_val['name'],
                'item_quality' => $item_val['quality'],
                'get_num' => 0,
                'out_num' => 0,
                'surplus_num' => 0,
                'surplus_role' => 0,
                'active_role' => $active_role,
                'active_num' => 0,
                'old_active_role' => $old_active_role,
                'old_active_num' => 0,
                'created_at' => time()
            ];
        }
        //计算当日累计获得
        $table = 'reiki_equip_log' . getLogTable('month', $this->date);
        $get_num_data = $this->game_log_db->table($table)    //累计获得
            ->field("sum(delta) as get_num,sys_id as type")
            ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta>0 and sys_id in($item_id_str)")
            ->group("sys_id")
            ->select();
        foreach($get_num_data as $get_num_data_val){
            if(!empty($get_num_data_val['get_num'])){
                if(isset($day_data[$get_num_data_val['type']])){
                    $day_data[$get_num_data_val['type']]['get_num'] = $get_num_data_val['get_num'];
                }
            }
        }
        $out_num_data = $this->game_log_db->table($table)    //累计消耗
            ->field("sum(delta) as out_num,sys_id as type")
            ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta<0 and sys_id in($item_id_str)")
            ->group("sys_id")
            ->select();
        foreach($out_num_data as $out_num_data_val){
            if(!empty($out_num_data_val['out_num'])){
                if(isset($day_data[$out_num_data_val['type']])){
                    $day_data[$out_num_data_val['type']]['out_num'] = $out_num_data_val['out_num'];
                }
            }
        }
        $out_num = !empty($out_num) ? $out_num : 0;
        $out_num = abs($out_num);
        $role_data = $this->game_data_db->table('reiki_equip')    //剩余库存以及拥有人数
            ->field('count(reiki_equip.id) as surplus_num,count(distinct reiki_equip.rid) as surplus_role,sys_id as type')
            ->join("left join role on role.id=reiki_equip.rid")
            ->where("role.place=$channel_id and reiki_equip.sys_id in($item_id_str)")
            ->group("sys_id")
            ->select();
        foreach($role_data as $role_data_val){
            if(!empty($role_data_val['surplus_num'])){
                if(isset($day_data[$role_data_val['type']])){
                    $day_data[$role_data_val['type']]['surplus_num'] = $role_data_val['surplus_num'];
                    $day_data[$role_data_val['type']]['surplus_role'] = $role_data_val['surplus_role'];
                }
            }
        }
        if($active_role > 0){
            $active_role_id_str = implode(',', $active_role_ids);
            $active_num_data = $this->game_data_db->table('reiki_equip')    //活跃用户库存
                ->field('count(reiki_equip.id) as active_num,sys_id as type')
                ->join("left join role on role.id=reiki_equip.rid")
                ->where("role.place=$channel_id and reiki_equip.sys_id in($item_id_str) and reiki_equip.rid in ($active_role_id_str)")
                ->group("sys_id")
                ->select();
            foreach($active_num_data as $active_num_data_val){
                if(!empty($active_num_data_val['active_num'])){
                    if(isset($day_data[$active_num_data_val['type']])){
                        $day_data[$active_num_data_val['type']]['active_num'] = $active_num_data_val['active_num'];
                    }
                }
            }
        }
        
        if($old_active_role > 0){
            $old_active_role_id_str = implode(',', $old_active_role_ids);
            $old_active_num_data = $this->game_data_db->table('reiki_equip')    //去新活跃用户库存
                ->field('count(reiki_equip.id) as old_active_num,sys_id as type')
                ->join("left join role on role.id=reiki_equip.rid")
                ->where("role.place=$channel_id and reiki_equip.sys_id in($item_id_str) and reiki_equip.rid in ($old_active_role_id_str)")
                ->group("sys_id")
                ->select();
            foreach($old_active_num_data as $old_active_num_data_val){
                if(isset($day_data[$old_active_num_data_val['type']])){
                    if(!empty($old_active_num_data_val['old_active_num'])){
                        $day_data[$old_active_num_data_val['type']]['old_active_num'] = $old_active_num_data_val['old_active_num'];
                    }
                }
            }
        }
        foreach($day_data as &$day_data_val){
            if( empty($day_data_val['get_num']) && empty($day_data_val['out_num']) && empty($day_data_val['surplus_num']) 
            && empty($day_data_val['surplus_role']) && empty($day_data_val['active_num'])  && empty($day_data_val['old_active_num']) ){   //数据都是0，不做插入操作
                unset($day_data[$day_data_val['item_type']]);
            }
        }
        
        $day_data = array_values($day_data);
        $this->data_analysis_db->table('item_day')->addAll($day_data,[],true);


        // //10.处理宠物数据
        // $day_data = [];
        // $item_id_arr = array_column($item_class_arr[18], 'id');
        // $item_id_str = implode(',', $item_id_arr);
        // $item_arr_re = [];
        // foreach($item_class_arr[18] as $item_val){
        //     $item_arr_re[$item_val['id']] = $item_val;
        //     $day_data[$item_val['id']] = [
        //         'c_id' => $parent_channel_id,
        //         'c_son_id' => $channel_id,
        //         'sid' => $sid,
        //         'date' => $this->date,
        //         'item_type' => $item_val['id'],
        //         'item_name' => $item_val['name'],
        //         'item_quality' => $item_val['quality'],
        //         'get_num' => 0,
        //         'out_num' => 0,
        //         'surplus_num' => 0,
        //         'surplus_role' => 0,
        //         'active_role' => $active_role,
        //         'active_num' => 0,
        //         'old_active_role' => $old_active_role,
        //         'old_active_num' => 0,
        //         'created_at' => time()
        //     ];
        // }
        // //计算当日累计获得
        // $table = 'reiki_equip_log' . getLogTable('month', $this->date);
        // $get_num_data = $this->game_log_db->table($table)    //累计获得
        //     ->field("sum(delta) as get_num,sys_id as type")
        //     ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta>0 and sys_id in($item_id_str)")
        //     ->group("sys_id")
        //     ->select();
        // foreach($get_num_data as $get_num_data_val){
        //     if(!empty($get_num_data_val['get_num'])){
        //         if(isset($day_data[$get_num_data_val['type']])){
        //             $day_data[$get_num_data_val['type']]['get_num'] = $get_num_data_val['get_num'];
        //         }
        //     }
        // }
        // $out_num_data = $this->game_log_db->table($table)    //累计消耗
        //     ->field("sum(delta) as out_num,sys_id as type")
        //     ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta<0 and sys_id in($item_id_str)")
        //     ->group("sys_id")
        //     ->select();
        // foreach($out_num_data as $out_num_data_val){
        //     if(!empty($out_num_data_val['out_num'])){
        //         if(isset($day_data[$out_num_data_val['type']])){
        //             $day_data[$out_num_data_val['type']]['out_num'] = $out_num_data_val['out_num'];
        //         }
        //     }
        // }
        // $out_num = !empty($out_num) ? $out_num : 0;
        // $out_num = abs($out_num);
        // $role_data = $this->game_data_db->table('reiki_equip')    //剩余库存以及拥有人数
        //     ->field('count(reiki_equip.id) as surplus_num,count(distinct reiki_equip.rid) as surplus_role,sys_id as type')
        //     ->join("left join role on role.id=reiki_equip.rid")
        //     ->where("role.place=$channel_id and reiki_equip.sys_id in($item_id_str)")
        //     ->group("sys_id")
        //     ->select();
        // foreach($role_data as $role_data_val){
        //     if(!empty($role_data_val['surplus_num'])){
        //         if(isset($day_data[$role_data_val['type']])){
        //             $day_data[$role_data_val['type']]['surplus_num'] = $role_data_val['surplus_num'];
        //             $day_data[$role_data_val['type']]['surplus_role'] = $role_data_val['surplus_role'];
        //         }
        //     }
        // }
        // if($active_role > 0){
        //     $active_role_id_str = implode(',', $active_role_ids);
        //     $active_num_data = $this->game_data_db->table('reiki_equip')    //活跃用户库存
        //         ->field('count(reiki_equip.id) as active_num,sys_id as type')
        //         ->join("left join role on role.id=reiki_equip.rid")
        //         ->where("role.place=$channel_id and reiki_equip.sys_id in($item_id_str) and reiki_equip.rid in ($active_role_id_str)")
        //         ->group("sys_id")
        //         ->select();
        //     foreach($active_num_data as $active_num_data_val){
        //         if(!empty($active_num_data_val['active_num'])){
        //             if(isset($day_data[$active_num_data_val['type']])){
        //                 $day_data[$active_num_data_val['type']]['active_num'] = $active_num_data_val['active_num'];
        //             }
        //         }
        //     }
        // }
        
        // if($old_active_role > 0){
        //     $old_active_role_id_str = implode(',', $old_active_role_ids);
        //     $old_active_num_data = $this->game_data_db->table('reiki_equip')    //去新活跃用户库存
        //         ->field('count(reiki_equip.id) as old_active_num,sys_id as type')
        //         ->join("left join role on role.id=reiki_equip.rid")
        //         ->where("role.place=$channel_id and reiki_equip.sys_id in($item_id_str) and reiki_equip.rid in ($old_active_role_id_str)")
        //         ->group("sys_id")
        //         ->select();
        //     foreach($old_active_num_data as $old_active_num_data_val){
        //         if(isset($day_data[$old_active_num_data_val['type']])){
        //             if(!empty($old_active_num_data_val['old_active_num'])){
        //                 $day_data[$old_active_num_data_val['type']]['old_active_num'] = $old_active_num_data_val['old_active_num'];
        //             }
        //         }
        //     }
        // }
        // foreach($day_data as &$day_data_val){
        //     if( empty($day_data_val['get_num']) && empty($day_data_val['out_num']) && empty($day_data_val['surplus_num']) 
        //     && empty($day_data_val['surplus_role']) && empty($day_data_val['active_num'])  && empty($day_data_val['old_active_num']) ){   //数据都是0，不做插入操作
        //         unset($day_data[$day_data_val['item_type']]);
        //     }
        // }
        
        // $day_data = array_values($day_data);
        // $this->data_analysis_db->table('item_day')->addAll($day_data,[],true);


        //11.处理正常道具（除了装备和宝石）数据
        $day_data = [];
        $item_id_arr = array_column($item_class_arr[6], 'id');
        $item_id_str = implode(',', $item_id_arr);
        $item_arr_re = [];
        foreach($item_class_arr[6] as $item_val){
            $item_arr_re[$item_val['id']] = $item_val;
            $day_data[$item_val['id']] = [
                'c_id' => $parent_channel_id,
                'c_son_id' => $channel_id,
                'sid' => $sid,
                'date' => $this->date,
                'item_type' => $item_val['id'],
                'item_name' => $item_val['name'],
                'item_quality' => $item_val['quality'],
                'get_num' => 0,
                'out_num' => 0,
                'surplus_num' => 0,
                'surplus_role' => 0,
                'active_role' => $active_role,
                'active_num' => 0,
                'old_active_role' => $old_active_role,
                'old_active_num' => 0,
                'created_at' => time()
            ];
        }
        //计算当日累计获得
        $table = 'item_log' . getLogTable('month', $this->date);
        $get_num_data = $this->game_log_db->table($table)    //累计获得
            ->field("sum(delta) as get_num,type")
            ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta>0 and type in($item_id_str)")
            ->group("type")
            ->select();
        foreach($get_num_data as $get_num_data_val){
            if(!empty($get_num_data_val['get_num'])){
                if(isset($day_data[$get_num_data_val['type']])){
                    $day_data[$get_num_data_val['type']]['get_num'] = $get_num_data_val['get_num'];
                }
            }
        }
        $out_num_data = $this->game_log_db->table($table)    //累计消耗
            ->field("sum(delta) as out_num,type")
            ->where("place=$channel_id and time>=$start_time and time<=$end_time and delta<0 and type in($item_id_str)")
            ->group("type")
            ->select();
        foreach($out_num_data as $out_num_data_val){
            if(!empty($out_num_data_val['out_num'])){
                if(isset($day_data[$out_num_data_val['type']])){
                    $day_data[$out_num_data_val['type']]['out_num'] = $out_num_data_val['out_num'];
                }
            }
        }
        $role_data = $this->game_data_db->table('back_pack')    //剩余库存以及拥有人数
            ->field('count(back_pack.id) as surplus_num,count(distinct rid) as surplus_role,item_id as type')
            ->join("left join role on role.id=back_pack.rid")
            ->where("role.place=$channel_id and item_id in($item_id_str)")
            ->group("item_id")
            ->select();
        foreach($role_data as $role_data_val){
            if(!empty($role_data_val['surplus_num'])){
                if(isset($day_data[$role_data_val['type']])){
                    $day_data[$role_data_val['type']]['surplus_num'] = $role_data_val['surplus_num'];
                    $day_data[$role_data_val['type']]['surplus_role'] = $role_data_val['surplus_role'];
                }
            }
        }
        if($active_role > 0){
            $active_role_id_str = implode(',', $active_role_ids);
            $active_num_data = $this->game_data_db->table('back_pack')    //活跃用户库存
                ->field('count(back_pack.id) as active_num,item_id as type')
                ->join("left join role on role.id=back_pack.rid")
                ->where("role.place=$channel_id and item_id in($item_id_str) and rid in ($active_role_id_str)")
                ->group("item_id")
                ->select();
            foreach($active_num_data as $active_num_data_val){
                if(!empty($active_num_data_val['active_num'])){
                    if(isset($day_data[$active_num_data_val['type']])){
                        $day_data[$active_num_data_val['type']]['active_num'] = $active_num_data_val['active_num'];
                    }
                }
            }
        }
        
        if($old_active_role > 0){
            $old_active_role_id_str = implode(',', $old_active_role_ids);
            $old_active_num_data = $this->game_data_db->table('back_pack')    //去新活跃用户库存
                ->field('count(back_pack.id) as old_active_num,item_id as type')
                ->join("left join role on role.id=back_pack.rid")
                ->where("role.place=$channel_id and item_id in($item_id_str) and rid in ($old_active_role_id_str)")
                ->group("item_id")
                ->select();
            foreach($old_active_num_data as $old_active_num_data_val){
                if(isset($day_data[$old_active_num_data_val['type']])){
                    if(!empty($old_active_num_data_val['old_active_num'])){
                        $day_data[$old_active_num_data_val['type']]['old_active_num'] = $old_active_num_data_val['old_active_num'];
                    }
                }
            }
        }
        foreach($day_data as &$day_data_val){
            if( empty($day_data_val['get_num']) && empty($day_data_val['out_num']) && empty($day_data_val['surplus_num']) 
            && empty($day_data_val['surplus_role']) && empty($day_data_val['active_num'])  && empty($day_data_val['old_active_num']) ){   //数据都是0，不做插入操作
                unset($day_data[$day_data_val['item_type']]);
            }
        }
        $day_data = array_values($day_data);
        $this->data_analysis_db->table('item_day')->addAll($day_data,[],true);
        return 1;
    }

}
<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 关卡流水（等级，主线关卡，爬塔层数）
 */
class CheckpointLossController extends PublicController{
    protected $game_log_db;

    /**
     * 查询要处理的数据入口
     */
    public function entry(){

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
            // $register_user_ids = $this->platform_db->table('user')
            // ->where("c_son_id=" . $channel_val['id'] . " and created_at>=$this->start_time and created_at<=$this->end_time ")
            // ->getField('id',true);
            
            foreach($servers as $server_val){
                if($this->start_time >= strtotime(date('Y-m-d', $server_val['open_time']))){
                    echo '渠道--' . $channel_val['name'] . '，区服--' . $server_val['server_name'] . '，关卡流失开始处理';
                    echo PHP_EOL;
                    //获取每日基本数据，并保存数据
                    $day_data_res =  $this->day_data($server_val, $channel_val['id'], $channel_val['parent_id'], $this->start_time, $this->end_time);
                    var_dump($day_data_res);
                    echo PHP_EOL;
                    //处理留存比例
                    $retain_data = $this->doRetain($server_val, $channel_val['id'], $channel_val['parent_id']);
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
    public function day_data($server_val, $channel_id, $parent_channel_id, $start_time, $end_time){
        $sid = $server_val['id'];
        $this->game_log_db = connectionDb($server_val, 'log');     //连接游戏日志库

        //获取创角数
        // $role_num = $this->platform_db->table('user_server')
        //     ->alias('us')
        //     ->join("left join user on user.id=us.user_id")
        //     ->where("user.c_son_id=$channel_id and us.sid=" . $sid . " and us.created_at>=$start_time and us.created_at<=$end_time ")
        //     ->count();
        $role_ids = $this->game_log_db->table('role_create_log')
            ->where("place=$channel_id and create_time>=$start_time and create_time<=$end_time")
            ->getField('rid',true);
        $num = count($role_ids);   //创角数
        if(!empty($role_ids)){
            $role_ids = implode(',', $role_ids);
        }else{
            $role_ids = '';
        }

        //1.等级关卡
        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'date' => $this->date,
            'checkpoint_type' => 1,
            'create_role_num' => $num,
            'role_ids' => $role_ids,
            'created_at' => time()
        ];
        //获取总等级数
        $this->data_db = connectionDb($server_val, 'data');     //连接游戏数据库
        $max = $this->data_db->table('role')->max('level');     
        $day_datas =[];
        for($e=1; $e<=$max; $e++){
            if($e>100 && is_int($e/5)){     //等级大于100按照5级一条数据处理
                $day_data['checkpoint_num'] = $e;
                $day_datas[] = $day_data;
            }elseif($e<=100){
                $day_data['checkpoint_num'] = $e;
                $day_datas[] = $day_data;
            }
        }
        $this->data_analysis_db->table('checkpoint_loss')->addAll($day_datas,[],true);    //批量插入，存在则修改

        // //2.主线关卡
        // $day_data = [
        //     'c_id' => $parent_channel_id,
        //     'c_son_id' => $channel_id,
        //     'sid' => $sid,
        //     'date' => $this->date,
        //     'checkpoint_type' => 2,
        //     'create_role_num' => $num,
        //     'role_ids' => $role_ids,
        //     'created_at' => time()
        // ];
        // //获取总等级数
        // $this->data_db = connectionDb($server_val, 'data');     //连接游戏数据库
        // $max = $this->data_db->table('role_mission')->max('chapter_id');     
        // $day_datas =[];
        // for($f=0; $f<=$max; $f++){
        //     $day_data['checkpoint_num'] = $f;
        //     $day_datas[] = $day_data;
        // }
        // $this->data_analysis_db->table('checkpoint_loss')->addAll($day_datas,[],true);    //批量插入，存在则修改

        //3.爬塔层数
        $day_data = [
            'c_id' => $parent_channel_id,
            'c_son_id' => $channel_id,
            'sid' => $sid,
            'date' => $this->date,
            'checkpoint_type' => 3,
            'create_role_num' => $num,
            'role_ids' => $role_ids,
            'created_at' => time()
        ];
        //获取总等级数
        $this->data_db = connectionDb($server_val, 'data');     //连接游戏数据库
        $max = $this->data_db->table('tower')->max('stage');     
        $day_datas =[];
        for($g=1; $g<=$max; $g++){
            if($g>100 && is_int($g/5)){     //等级大于100按照5级一条数据处理
                $day_data['checkpoint_num'] = $g;
                $day_datas[] = $day_data;
            }elseif($g<=100){
                $day_data['checkpoint_num'] = $g;
                $day_datas[] = $day_data;
            }
        }
        $this->data_analysis_db->table('checkpoint_loss')->addAll($day_datas,[],true);    //批量插入，存在则修改

        return 1;
    }

    /**
     * @desc 查询当日对应的留存
     * @param $server_val
     */
    protected function doRetain($server_val, $channel_id, $parent_channel_id){
        $sid = $server_val['id'];
        $this->game_log_db = connectionDb($server_val, 'data');     //连接游戏日志库

        //处理当天的昨日的次日留存
        $retain_res = $this->getRetain($sid, $channel_id, $parent_channel_id, $this->game_log_db, 1, 'one_day');
        echo $sid . '--次日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第三天的3日留存
        $retain_res = $this->getRetain($sid, $channel_id, $parent_channel_id, $this->game_log_db, 2, 'three_day');
        echo $sid . '--3日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第五天的5日留存
        $retain_res = $this->getRetain($sid, $channel_id, $parent_channel_id, $this->game_log_db, 4, 'five_day');
        echo $sid . '--5日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第7天的7日留存
        $retain_res = $this->getRetain($sid, $channel_id, $parent_channel_id, $this->game_log_db, 6, 'seven_day');
        echo $sid . '--7日留存---' . $channel_id . $retain_res . PHP_EOL;

        //处理当天前面第14天的14日留存
        $retain_res = $this->getRetain($sid, $channel_id, $parent_channel_id, $this->game_log_db, 14, 'fourteen_day');
        echo $sid . '--14日留存---' . $channel_id . $retain_res . PHP_EOL;

        return 'checkpoint_loss--ok';
    }

    protected function getRetain($sid, $channel_id, $parent_channel_id, $game_log_db, $days, $update_field){
        //查询当天的昨日的数据
        $one_day_date = date('Y-m-d', strtotime($this->date) - $days * 86400);   //
        $start_time = strtotime($one_day_date);  //开始时间戳
        $end_time = $start_time + 86399;    //结束时间戳

        //1.处理等级停留占比
        $checkpoint_loss_first = $this->data_analysis_db->table('checkpoint_loss')
            ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and checkpoint_type=1 and checkpoint_num=1")
            ->find();
        if($checkpoint_loss_first && !empty($checkpoint_loss_first['role_ids'])){
            //获取当天的等级数据
            $level_data = $game_log_db->table('role')
                ->field('level,count(id) as stop_num')
                ->where("place=$channel_id and id in (" . $checkpoint_loss_first['role_ids'] . ")")
                ->group('level')
                ->order('level desc')
                ->select();
            if($level_data){
                $max_level = $level_data[0]['level'];
                $level_data_re = [];
                foreach($level_data as $level_data_val){
                    //2020-5-27-lby：超过100级，每5级统计一条数据
                    $level = $level_data_val['level'];
                    if($level > 100){
                        $level = ceil($level/5) * 5;
                    }
                    if(isset($level_data_re[$level])){
                        $level_data_re[$level] = [
                            'level' => $level,
                            'stop_num' => $level_data_re[$level]['stop_num'] + $level_data_val['stop_num']
                        ];
                    }else{
                        $level_data_re[$level] = [
                            'level' => $level,
                            'stop_num' =>  $level_data_val['stop_num']
                        ];
                    }
                    // $level_data_re[$level_data_val['level']] = $level_data_val;
                }

                for($i=1; $i<=$max_level; $i++){
                    if($i<=100 || ($i>100 && is_int($i/5))){     //等级大于100按照5级一条数据处理
                        $checkpoint_loss_info = $this->data_analysis_db->table('checkpoint_loss')
                            ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and checkpoint_type=1 and checkpoint_num=$i")
                            ->find();
                        if(isset($level_data_re[$i]) && $level_data_re[$i]['stop_num']>0){
                            $stop_num = $level_data_re[$i]['stop_num'];
                            if($checkpoint_loss_info){    //修改
                                $day_data = [
                                    $update_field . '_stop_num' => $stop_num,
                                ];
                                $res = $this->data_analysis_db->table('checkpoint_loss')->where("id=" . $checkpoint_loss_info['id'])->save($day_data);
                            }else{                      //添加
                                $add_data = [
                                    'c_id' => $checkpoint_loss_first['c_id'],
                                    'c_son_id' => $checkpoint_loss_first['c_son_id'],
                                    'sid' => $checkpoint_loss_first['sid'],
                                    'date' => $checkpoint_loss_first['date'],
                                    'checkpoint_type' => $checkpoint_loss_first['checkpoint_type'],
                                    'create_role_num' => $checkpoint_loss_first['create_role_num'],
                                    'role_ids' => $checkpoint_loss_first['role_ids'],
                                    'checkpoint_num' => $i,
                                    $update_field . '_stop_num' => $stop_num,
                                    'created_at' => time()
                                ];
                                $res = $this->data_analysis_db->table('checkpoint_loss')->add($add_data);
                            }
                        }
                    }
                }
            }
        }

        // //2.处理主线关卡停留占比
        // $checkpoint_loss_first = $this->data_analysis_db->table('checkpoint_loss')
        //     ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and checkpoint_type=2 and checkpoint_num=1")
        //     ->find();
        // if($checkpoint_loss_first && !empty($checkpoint_loss_first['role_ids'])){
        //     //获取当天的等级数据
        //     $level_data = $game_log_db->table('role_mission')
        //         ->field('chapter_id as level,count(rid) as stop_num')
        //         ->join("left join role on role.id=role_mission.rid")
        //         ->where("role.place=$channel_id and rid in (" . $checkpoint_loss_first['role_ids'] . ")")
        //         ->group('chapter_id')
        //         ->order('chapter_id desc')
        //         ->select();
        //     if($level_data){
        //         $max_level = $level_data[0]['level'];
        //         $level_data_re = [];
        //         foreach($level_data as $level_data_val){
        //             $level_data_re[$level_data_val['level']] = $level_data_val;
        //         }

                
        //         for($j=0; $j<=$max_level; $j++){
        //             $checkpoint_loss_info = $this->data_analysis_db->table('checkpoint_loss')
        //                 ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and checkpoint_type=2 and checkpoint_num=$j")
        //                 ->find();
        //             if(isset($level_data_re[$j])){
        //                 $stop_num = $level_data_re[$j]['stop_num'];
        //                 $retain = getDivision($stop_num, $checkpoint_loss_info['create_role_num']);
                        
        //                 if($checkpoint_loss_info){    //修改
        //                     $day_data = [
        //                         $update_field . '_retain' => $retain,
        //                         $update_field . '_stop_num' => $stop_num,
        //                     ];
        //                     $res = $this->data_analysis_db->table('checkpoint_loss')->where("id=" . $checkpoint_loss_info['id'])->save($day_data);
        //                 }else{                      //添加
        //                     $add_data = [
        //                         'c_id' => $checkpoint_loss_first['c_id'],
        //                         'c_son_id' => $checkpoint_loss_first['c_son_id'],
        //                         'sid' => $checkpoint_loss_first['sid'],
        //                         'date' => $checkpoint_loss_first['date'],
        //                         'checkpoint_type' => $checkpoint_loss_first['checkpoint_type'],
        //                         'create_role_num' => $checkpoint_loss_first['create_role_num'],
        //                         'role_ids' => $checkpoint_loss_first['role_ids'],
        //                         'checkpoint_num' => $j,
        //                         $update_field . '_retain' => $retain,
        //                         $update_field . '_stop_num' => $stop_num,
        //                         'created_at' => time()
        //                     ];
        //                     $res = $this->data_analysis_db->table('checkpoint_loss')->add($add_data);
        //                 }
        //             }
        //         }
        //     }
        // }

        //3.处理爬塔层数停留占比
        $checkpoint_loss_first = $this->data_analysis_db->table('checkpoint_loss')
            ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and checkpoint_type=3 and checkpoint_num=1")
            ->find();
        if($checkpoint_loss_first && !empty($checkpoint_loss_first['role_ids'])){
            //获取当天的等级数据
            $level_data = $game_log_db->table('tower')
                ->field('stage as level,count(rid) as stop_num')
                ->join("left join role on role.id=tower.rid")
                ->where("role.place=$channel_id and rid in (" . $checkpoint_loss_first['role_ids'] . ")")
                ->group('stage')
                ->order('stage desc')
                ->select();
            if($level_data){
                $max_level = $level_data[0]['level'];
                $level_data_re = [];
                foreach($level_data as $level_data_val){
                    //2020-5-27-lby：超过100级，每5级统计一条数据
                    $level = $level_data_val['level'];
                    if($level > 100){
                        $level = ceil($level/5) * 5;
                    }
                    if(isset($level_data_re[$level])){
                        $level_data_re[$level] = [
                            'level' => $level,
                            'stop_num' => $level_data_re[$level]['stop_num'] + $level_data_val['stop_num']
                        ];
                    }else{
                        $level_data_re[$level] = [
                            'level' => $level,
                            'stop_num' =>  $level_data_val['stop_num']
                        ];
                    }
                    // $level_data_re[$level_data_val['level']] = $level_data_val;
                }

                for($k=1; $k<=$max_level; $k++){
                    if($k<=100 || ($k>100 && is_int($k/5))){     //等级大于100按照5级一条数据处理
                        $checkpoint_loss_info = $this->data_analysis_db->table('checkpoint_loss')
                            ->where("sid=" . $sid . " and c_son_id=$channel_id and date='{$one_day_date}' and checkpoint_type=3 and checkpoint_num=$k")
                            ->find();
                        if(isset($level_data_re[$k]) && $level_data_re[$i]['stop_num']>0){
                            $stop_num = $level_data_re[$k]['stop_num'];
                            
                            if($checkpoint_loss_info){    //修改
                                $day_data = [
                                    $update_field . '_stop_num' => $stop_num,
                                ];
                                $res = $this->data_analysis_db->table('checkpoint_loss')->where("id=" . $checkpoint_loss_info['id'])->save($day_data);
                            }else{                      //添加
                                $add_data = [
                                    'c_id' => $checkpoint_loss_first['c_id'],
                                    'c_son_id' => $checkpoint_loss_first['c_son_id'],
                                    'sid' => $checkpoint_loss_first['sid'],
                                    'date' => $checkpoint_loss_first['date'],
                                    'checkpoint_type' => $checkpoint_loss_first['checkpoint_type'],
                                    'create_role_num' => $checkpoint_loss_first['create_role_num'],
                                    'role_ids' => $checkpoint_loss_first['role_ids'],
                                    'checkpoint_num' => $k,
                                    $update_field . '_stop_num' => $stop_num,
                                    'created_at' => time()
                                ];
                                $res = $this->data_analysis_db->table('checkpoint_loss')->add($add_data);
                            }
                        }
                    }
                }
            }
        }

        return '处理留存完成';
    }

}
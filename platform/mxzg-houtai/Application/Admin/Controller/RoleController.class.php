<?php
namespace Admin\Controller;

use Think\Controller;

/*
 * 角色数据管理
 */
class RoleController extends PublicController{

    protected $data_db;
    /*搜索*/
    public function index(){
        //记录搜索条件
        $uid = I('uid', '');
        $role_id = I('role_id', '');
        $role_name = I('role_name', '');
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '');
        $sort_field = I('sort_field', '');

        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        $channelss = M('channel')->select();
        $channels_re = [];
        foreach($channelss as $channels_val){
            $channels_re[$channels_val['id']] = $channels_val;
        }
        //获取所有的服务器
        $servers = M('server')->select();
        
        //组建搜索条件的值
        $search_params = [
            'uid' => $uid,
            'role_id' => $role_id,
            'role_name' => $role_name,
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'sort_field' => $sort_field,
        ];

        //判断时间是否都选择
        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'count'=>0, 'page'=>'', 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $this->game_data_db = connectionDb($server_info, 'data');     //连接游戏数据库

        $where = "1 ";
        if(!empty($uid)){
            $where .= "and role.user_id='$uid' ";
        }
        if(!empty($role_id)){
            $where .= "and role.id='$role_id' ";
        }
        if(!empty($role_name)){
            $where .= "and role.nick like '%{$role_name}%' ";
        }
        if(!empty($c_son_id)){
            $where .= "and role.place=$c_son_id ";
        }

        //处理排序字段
        if(empty($sort_field)){
            $order_str = "role.id desc";
        }else{
            $order_str = str_replace(",", " ", $sort_field);
        }
        $count = $this->game_data_db->table('role')
            ->join("left join recharge as rc on rc.rid=role.id and rc.give_state=1")
            ->where($where)
            ->count("distinct role.id");
        $Page  = new \Think\Page($count, 40);
        $list = $this->game_data_db->table('role')
            ->field("
                role.id as role_id,
                role.nick as role_name,
                role.user_id,
                role.place,
                role.level,
                role.gem,
                role.fighting,
                from_unixtime(role.last_login_time/1000,'%Y-%m-%d %H:%i:%s') as last_login_date,
                from_unixtime(role.last_offline_time/1000,'%Y-%m-%d %H:%i:%s') as last_offline_date,
                from_unixtime(role.create_time/1000,'%Y-%m-%d %H:%i:%s') as create_date,
                sum(rc.pay_money) as total_recharge
            ")
            ->join("left join recharge as rc on rc.rid=role.id and rc.give_state=1")
            ->where($where)
            ->group("role.id")
            ->order($order_str)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        foreach($list as &$val){
            //获取渠道名称
            if(isset($channels_re[$val['place']])){
                $val['channel_name'] = $channels_re[$val['place']]['name'];
                $val['parent_name'] = $channels_re[$channels_re[$val['place']]['parent_id']]['name'];
            }else{
                $val['channel_name'] = '';
                $val['parent_name'] = '';
            }
            //获取服务器名称
            $val['server_name'] = $server_info['server_name'];
            $val['sid'] = $server_info['id'];
            $val['total_recharge'] = round($val['total_recharge']/100,2);

            //查询渠道的uid（open_id）
            $user_info = $this->platform_db->table('user')->where("id=" . $val['user_id'])->find();
            if($user_info){
                $val['open_id'] = $user_info['open_id'];
            }else{
                $val['open_id'] = '';
            }
        }
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*搜索*/
    public function export(){
        ini_set('memory_limit','256M'); //临时提高内存

        //记录搜索条件
        $uid = I('uid', '');
        $role_id = I('role_id', '');
        $role_name = I('role_name', '');
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '');
        $sort_field = I('sort_field', '');

        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        $channelss = M('channel')->select();
        $channels_re = [];
        foreach($channelss as $channels_val){
            $channels_re[$channels_val['id']] = $channels_val;
        }

        //判断时间是否都选择
        $is_error = 0;
        if(empty($sid)){
            $is_error = 1;
        }

        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if($is_error == 0 && $server_info){
            $this->game_data_db = connectionDb($server_info, 'data');     //连接游戏数据库

            $where = "1 ";
            if(!empty($uid)){
                $where .= "and role.user_id='$uid' ";
            }
            if(!empty($role_id)){
                $where .= "and role.id='$role_id' ";
            }
            if(!empty($role_name)){
                $where .= "and role.nick like '%{$role_name}%' ";
            }
            if(!empty($c_son_id)){
                $where .= "and role.place=$c_son_id ";
            }

            //处理排序字段
            if(empty($sort_field)){
                $order_str = "role.id desc";
            }else{
                $order_str = str_replace(",", " ", $sort_field);
            }
            $list = $this->game_data_db->table('role')
                ->field("
                    role.id as role_id,
                    role.nick as role_name,
                    role.user_id,
                    role.place,
                    role.level,
                    role.gem,
                    role.fighting,
                    from_unixtime(role.last_login_time/1000,'%Y-%m-%d %H:%i:%s') as last_login_date,
                    from_unixtime(role.last_offline_time/1000,'%Y-%m-%d %H:%i:%s') as last_offline_date,
                    from_unixtime(role.create_time/1000,'%Y-%m-%d %H:%i:%s') as create_date,
                    sum(rc.pay_money) as total_recharge
                ")
                ->join("left join recharge as rc on rc.rid=role.id and rc.give_state=1")
                ->where($where)
                ->group("role.id")
                ->order($order_str)
                ->limit(30000)       //限制导出数量
                ->select();

            foreach($list as &$val){
                //获取渠道名称
                if(isset($channels_re[$val['place']])){
                    $val['channel_name'] = $channels_re[$val['place']]['name'];
                    $val['parent_name'] = $channels_re[$channels_re[$val['place']]['parent_id']]['name'];
                }else{
                    $val['channel_name'] = '';
                    $val['parent_name'] = '';
                }
                //获取服务器名称
                $val['server_name'] = $server_info['server_name'];
                $val['sid'] = $server_info['id'];
                $val['total_recharge'] = round($val['total_recharge']/100,2);

                //查询渠道的uid（open_id）
                $user_info = $this->platform_db->table('user')->where("id=" . $val['user_id'])->find();
                if($user_info){
                    $val['open_id'] = $user_info['open_id'];
                }else{
                    $val['open_id'] = '';
                }
            }
        }else{
            $list = [];
        }

        vendor('PHPExcel.PHPExcel');
        vendor('PHPExcel.PHPExcel.Writer.Excel5');
        Vendor("PHPExcel.PHPExcel.IOFactory");
        $excel = new \PHPExcel();
        //Excel表格式,这里简略写了8列
        $letter = array('A','B','C','D','E','F','G','H','I','J','K','L','M');
        //表头数组
        $tableheader = array('角色id','角色名称','渠道','账号id','渠道uid','区服','等级','总充值','持有钻石','战斗力','最后登陆时间','最后离线时间','创号时间');
        //填充表头信息
        for($i = 0;$i < count($tableheader);$i++) {
            $excel->getActiveSheet()->setCellValue("$letter[$i]1","$tableheader[$i]");
        }
        $excel->getActiveSheet()->getDefaultColumnDimension()->setWidth(20);//所有单元格（列）默认宽度
        //填充表格信息
        for ($i = 2;$i <= count($list) + 1;$i++) {
            $excel->getActiveSheet()->setCellValue("A$i", $list[$i - 2]['role_id']);
            $excel->getActiveSheet()->setCellValue("B$i", $list[$i - 2]['role_name']);
            $excel->getActiveSheet()->setCellValue("C$i", $list[$i - 2]['channel_name'] . '（' . $list[$i - 2]['parent_name'] . "）");
            $excel->getActiveSheet()->setCellValue("D$i", $list[$i - 2]['user_id']);
            $excel->getActiveSheet()->setCellValue("E$i", $list[$i - 2]['open_id']);
            $excel->getActiveSheet()->setCellValue("F$i", $sid . '--' . $list[$i - 2]['server_name']);
            $excel->getActiveSheet()->setCellValue("G$i", $list[$i - 2]['level']);
            $excel->getActiveSheet()->setCellValue("H$i", $list[$i - 2]['total_recharge']);
            $excel->getActiveSheet()->setCellValue("I$i", $list[$i - 2]['gem']);
            $excel->getActiveSheet()->setCellValue("J$i", $list[$i - 2]['fighting']);
            $excel->getActiveSheet()->setCellValue("K$i", $list[$i - 2]['last_login_date']);
            $excel->getActiveSheet()->setCellValue("L$i", $list[$i - 2]['last_offline_date']);
            $excel->getActiveSheet()->setCellValue("M$i", $list[$i - 2]['create_date']);
        }

        //创建Excel输入对象
        ob_clean();
        $write = new \PHPExcel_Writer_Excel5($excel);
        header("Pragma: public");
        header("Expires: 0");
        $filename="role_list.xls";
        header("Content-Disposition: attachment;filename=$filename");
        header("Cache-Control:must-revalidate, post-check=0, pre-check=0");
        header("Content-Type:application/force-download");
        header("Content-Type:application/vnd.ms-execl");
        header("Content-Type:application/octet-stream");
        header("Content-Type:application/download");
        header("Content-Transfer-Encoding:binary");
        $write->save('php://output');
    }

    public function info(){

        $role_id = I('id', '');
        $sid = I('sid', '0');
        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();

        if(empty($role_id) || empty($server_info)){
            $this->display();
            exit;
        }
        //查询角色信息，需要连接游戏数据库
        $this->data_db = connectionDb($server_info);
        $role_info = $this->data_db->table('role')->where("id = $role_id")->find();
        $role_info['offline_time'] = calculateTime($role_info['last_offline_time']);
        //查询玩家最后登录的ip
        $game_log_db = connectionDb($server_info, 'log');
        $table = 'role_login_log' . getLogTable('month', date('Y-m-d', $role_info['last_login_time'] * 0.001));
        $login_info = $game_log_db->table($table)
            ->field('ip')
            ->where("rid=$role_id ")
            ->order('id desc')
            ->find();
        if($login_info){
            $role_info['ip'] = $login_info['ip'];
        }else{
            $role_info['ip'] = '';
        }

        //查询账号信息
        $user_info = $this->platform_db->table('user')
            ->field('user.*,ch1.name as channel_name,ch2.name as channel_name_son')
            ->join("left join channel as ch1 on ch1.id=user.c_id")
            ->join("left join channel as ch2 on ch2.id=user.c_son_id")
            ->where("user.id=" . $role_info['user_id'])->find();
        $user_info['created_time'] = calculateTime($user_info['created_at']);
        //查询账号是否是白名单
        $user_info['is_white'] = 0;
        $white_info = $this->platform_db->table('white_list')->where("uid=" . $role_info['user_id'])->find();
        if($white_info){
            $user_info['is_white'] = 1;
        }

        //获取充值信息
        $role_charge_data = $this->data_db->table('role_charge')->where("rid = $role_id")->find();
        //查询羁绊
        // $fetter_goddess_data = $this->data_db->table('fetter_goddess')->where("rid = $role_id")->select();
        // $fetter_goddess_data_rel = [];
        // foreach($fetter_goddess_data as $fetter_goddess_val){
        //     $fetter_goddess_data_rel[$fetter_goddess_val['goddess_type']] = $fetter_goddess_val;
        // }
        // unset($fetter_goddess_data);    //释放内存
        // $fetter_goddess = [];
        // foreach($this->fetter_goddess as $fetter_goddess_key=>$fetter_goddess_val){
        //     if(isset($fetter_goddess_data_rel[$fetter_goddess_key])){
        //         $fetter_goddess_data_rel[$fetter_goddess_key]['goddess_type_name'] = $fetter_goddess_val;
        //         $fetter_goddess[] = $fetter_goddess_data_rel[$fetter_goddess_key];
        //     }else{
        //         $fetter_goddess[] = [
        //             'goddess_type' => $fetter_goddess_key,
        //             'goddess_type_name' => $fetter_goddess_val,
        //             'level' => 0,
        //             'skill_level' => 0,
        //             'refine_level' => 0,
        //             'uplimit_level' => 0
        //         ];
        //     }
        // }
        //查询羁绊
        $fetter_goddess_info = $this->data_db->table('fetter_goddess2')->where("rid = $role_id")->find();
        //查询幻化
        $goddess_fashion_info = $this->data_db->table('goddess_fashion')->where("rid = $role_id")->find();

        //查询公会信息
        $clan_id = $role_info['clan_id'];
        $clan_info = $this->data_db->table('clan')->where("id = $clan_id")->find();
        //查询玩家公会信息
        $role_clan_info = $this->data_db->table('clan_member')->where("rid=$role_id and clan_id=$clan_id")->find();

        //查询每日副本
        $daily_dungeon = $this->data_db->table('daily_dungeon')->where("rid=$role_id")->find();
        $daily_dungeon_arr = json_decode($daily_dungeon['dungeon_type'], true);
        $daily_dungeon_info = [
            '1' => 0,
            '2' => 0,
            '3' => 0,
            '4' => 0,
            '5' => 0,
        ];
        foreach($daily_dungeon_arr as $daily_dungeon_key=>$daily_dungeon_val){
            $daily_dungeon_info[$daily_dungeon_key] = $daily_dungeon_val['passMaxMission'];
        }

        //幻境之塔
        $tower_info = $this->data_db->table('tower')->where("rid=$role_id")->find();
        //关卡
        $role_mission_info = $this->data_db->table('role_mission')->where("rid=$role_id")->find();
        //勇者试炼
        $adven_mission_info = $this->data_db->table('adven_mission')->where("rid=$role_id")->find();
        //月神庇护所
        $dungeon_info = $this->data_db->table('dungeon_info')->where("rid=$role_id")->find();
        //诸神遗迹
        $god_relic_info = $this->data_db->table('god_relic')->where("rid=$role_id")->find();

        //获取英雄信息
        $hero_data = $this->data_db->table('hero')->where("rid=$role_id and star>3")->order("fighting desc")->select();
        //获取英雄的布阵数据
        $hero_line_up_data = $this->data_db->table('hero_line_up')->where("rid=$role_id")->select();
        $hero_line_up_re = [];  //英雄的布阵信息，字符串拼接
        foreach($hero_line_up_data as $hero_line_up_val){
            $formation_arr = json_decode($hero_line_up_val['formation'], true);
            if(!empty($formation_arr)){
                foreach($formation_arr as $formation_val){
                    $hero_line_up_re[(string)$formation_val['heroId']] .= $hero_line_up_val['type'] . '--' . $formation_val['pos'] . '；';
                }
            }
        }

        //获取道具数据（只获取英雄）
        $item_info = $this->platform_db->table('gift_item')->where("type=7")->select();
        $item_info_re = [];
        foreach($item_info as $item_val){
            $item_info_re[$item_val['id']] = $item_val;
        }
        unset($item_info);

        //获取英雄属性
        $hero_attributes = $this->platform_db->table('hero')->select();
        $hero_attributes_re = [];
        foreach($hero_attributes as $hero_attribute){
            $hero_attributes_re[$hero_attribute['id']] = $hero_attribute;
        }
        unset($hero_attributes);

        foreach($hero_data as &$hero_val){
            $hero_val['type_name'] = isset($item_info_re[$hero_val['type']]) ? $item_info_re[$hero_val['type']]['name'] : '';
            $hero_val['line_up'] = isset($hero_line_up_re[$hero_val['id']]) ? $hero_line_up_re[$hero_val['id']] : '';
            //英雄属性
            $hero_val['elem'] = isset($hero_attributes_re[$hero_val['type']]) ? $hero_attributes_re[$hero_val['type']]['elem'] : '';
            $hero_val['occupation'] = isset($hero_attributes_re[$hero_val['type']]) ? $hero_attributes_re[$hero_val['type']]['occupation'] : '';
        }

        //获取星盘数据
        $astrolabe_info = $this->data_db->table('astrolabe')->where("rid=$role_id")->find();
        
        $astrolabe_title = [];
        $astrolabe_data = [];
        if($astrolabe_info){
            $five_elements = '';
            //处理星盘激活的五行
            $active_elem = json_decode($astrolabe_info['active_elem'], true);
            foreach($active_elem as $active_elem_val){
                $five_elements .= isset($this->five_elements[$active_elem_val]) ? $this->five_elements[$active_elem_val]['name'] . ';' : '';
            }
            $astrolabe_data['five_elements'] = $five_elements;
            $astrolabe_title['name'] = '星盘激活的属性';
            //处理星盘点亮的星级和技能
            $light_star = json_decode($astrolabe_info['light_star'], true);

            //获取星盘对应的星级和对应的技能
            $astrolabe_star_data = $this->platform_db->table('astrolabe_star')->select();
            $astrolabe_star_data_re = [];
            foreach($astrolabe_star_data as $astrolabe_star_data_val){
                $astrolabe_star_data_re[$astrolabe_star_data_val['id']] = $astrolabe_star_data_val;
            }
            unset($astrolabe_star_data);
            $astrolabe_skill_data = $this->platform_db->table('astrolabe_skill')->select();
            $astrolabe_skill_data_re = [];
            foreach($astrolabe_skill_data as $astrolabe_skill_data_val){
                $astrolabe_skill_data_re[$astrolabe_skill_data_val['id']] = $astrolabe_skill_data_val;
            }
            unset($astrolabe_skill_data);

            foreach($light_star as $light_star_key=>$light_star_val){
                if(isset($astrolabe_star_data_re[$light_star_key])){
                    $star_skill = '';
                    $star_skill .= $astrolabe_star_data_re[$light_star_key]['star'] . '--';
                    if(isset($astrolabe_skill_data_re[$light_star_val])){
                        $star_skill .= $astrolabe_skill_data_re[$light_star_key]['name'];
                    }
                    $astrolabe_data['star_skill_' . $light_star_key] = $star_skill;
                    $astrolabe_title['star_skill_' . $light_star_key] = '星级和技能';
                }
            }
            unset($astrolabe_star_data_re);
            unset($astrolabe_skill_data_re);
        }

        //获取圣物数据
        $dragon_data = [];
        $holy_things_data = [];
        $dragon_info = $this->data_db->table('dragon')->where("rid=$role_id")->find();
        if($dragon_info){
            //获取属性表数据
            $attribute_data = $this->platform_db->table('attribute')->select();
            $attribute_data_re = [];
            foreach($attribute_data as $attribute_data_val){
                $attribute_data_re[$attribute_data_val['id']] = $attribute_data_val;
            }
            
            //处理圣物等级阶级属性
            $dragon_level_info = $this->platform_db->table('dragon_level')->where("id=" . $dragon_info['attr_level'])->find();
            if($dragon_level_info){
                $dragon_data['level'] = $dragon_level_info['level'];
                $dragon_data['grade'] = $dragon_level_info['grade'];
                $attribute = json_decode($dragon_level_info['attribute'], true);
                foreach($attribute as $attribute_val){
                    foreach($attribute_val as $attribute_val_key=>$attribute_val_val){
                        if(isset($attribute_data_re[$attribute_val_key])){
                            $dragon_data['attribute_key'][] = $attribute_data_re[$attribute_val_key]['name'];
                        }else{
                            $dragon_data['attribute_key'][] = '';
                        }
                        $dragon_data['attribute_val'][] = $attribute_val_val;
                    }
                }
            }

            //处理圣物等级品质属性
            $slots = json_decode($dragon_info['slots'], true);
            $holy_things_ids = [];
            foreach($slots as $slots_val){
                $holy_things_ids[] = $slots_val['sysId'];
            }
            $holy_things_ids = implode(',', $holy_things_ids);

            $holy_things_data = [];
            $holy_things_key = [];
            $holy_things_data = $this->platform_db->table('holy_things')->where("id in($holy_things_ids)")->select();
            foreach($holy_things_data as $holy_things_kel=>&$holy_things_val){
                $holy_things_key = [
                    '圣物id', '星级', '品质', '技能'
                ];
                $attribute = json_decode($holy_things_val['attribute'], true);
                if($holy_things_val['quality'] == 1){
                    $quality_name = '1|稀有';
                }elseif($holy_things_val['quality'] == 2){
                    $quality_name = '2|极品';
                }elseif($holy_things_val['quality'] == 3){
                    $quality_name = '3|普通';
                }else{
                    $quality_name = '无';
                }
                $holy_things_val = [
                    $holy_things_val['id'], $holy_things_val['star'], $quality_name, $holy_things_val['skill'],
                ];
                foreach($attribute as $attribute_val){
                    foreach($attribute_val as $attribute_val_key=>$attribute_val_val){
                        if(isset($attribute_data_re[$attribute_val_key])){
                            $holy_things_key[] = $attribute_data_re[$attribute_val_key]['name'];
                        }else{
                            $holy_things_key[] = '';
                        }
                        $holy_things_val[] = $attribute_val_val;
                    }
                }
            }
        }
        


        $this->assign([
            'role_info'=>$role_info,
            'user_info'=>$user_info,
            // 'fetter_goddess' => $fetter_goddess,
            'fetter_goddess_info' => $fetter_goddess_info,
            'goddess_fashion_info' => $goddess_fashion_info,
            'role_charge_data' => $role_charge_data,
            'clan_info' => $clan_info,
            'role_clan_info' => $role_clan_info,
            'daily_dungeon_info' => $daily_dungeon_info,
            'tower_info' => $tower_info,
            'role_mission_info' => $role_mission_info,
            'adven_mission_info' => $adven_mission_info,
            'dungeon_info' => $dungeon_info,
            'god_relic_info' => $god_relic_info,
            'hero_data' => $hero_data,
            'astrolabe_title' => $astrolabe_title,
            'astrolabe_data' => $astrolabe_data,
            'dragon_data' => $dragon_data,
            'holy_things_key' => $holy_things_key,
            'holy_things_data' => $holy_things_data,
        ]);
        $this->display();
    }

    /**
     * 公会科技
     */
    public function clan_skill(){
        $role_id = I('id', '');
        $sid = I('sid', '0');
        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if(empty($role_id) || empty($server_info)){
            $this->display();
            exit;
        }
        $this->data_db = connectionDb($server_info);    //连接游戏data库
        //查询公会科技表
        $clan_skill_info = $this->data_db->table('clan_skill')->where("rid=$role_id")->find();
        $skill = $clan_skill_info['skill'];
//        $skill = '{"1":{"skillType":2,"level":1,"profession":1}}';
        $skill_arr = json_decode($skill, true);
        $clan_skill_data = getClanSkillData($this->profession, $skill_arr);
        $clan_skill_config = $this->platform_db->table('clan_skill_config')->group("ability")->order("ability asc")->select();
        $clan_skill_title = [
            '职业ID','职业','科技等级'
        ];
        foreach($clan_skill_config as $clan_skill_val){
            $clan_skill_title[] = $clan_skill_val['name'];
        }
        $this->assign([
            'clan_skill_title' => $clan_skill_title,
            'clan_skill_data' => $clan_skill_data,
        ]);
        $this->display();
    }

    /**
     * 背包信息
     */
    public function back_pack(){
        $role_id = I('id', '');
        $sid = I('sid', '0');
        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if(empty($role_id) || empty($server_info)){
            $this->display();
            exit;
        }
        $this->data_db = connectionDb($server_info);    //连接游戏data库
        //获取玩家的道具背包
        $back_pack_info = $this->data_db->table('back_pack')->where("rid=$role_id")->select();

        //获取道具基本数据
        $item_info = $this->platform_db->table('gift_item')->where("type_label in (1,2,3,4,5,6,7,8)")->select();
        $item_info_re = [];
        foreach($item_info as $item_val){
            $item_info_re[$item_val['id']] = $item_val;
        }
        unset($item_info);
        $back_pack_data = [];
        foreach($back_pack_info as $back_pack_val){
            if(isset($item_info_re[$back_pack_val['item_id']])){
                $item_info = $item_info_re[$back_pack_val['item_id']];
                if($item_info['type_label'] == 7){
                    $type_label = 2;
                }else{
                    $type_label = $item_info['type_label'];
                }
                $back_pack_data['type_label_' . $type_label][] = [
                    'id' => $item_info['id'],
                    'name' => $item_info['name'],
                    'quality' => $item_info['quality'],
                    'num' => $back_pack_val['num'],
                ];
            }
        }
        unset($back_pack_info);
        //获取背包精灵符文信息
        $rune_info_data = [];
        $rune_info = $this->data_db->table('rune_info')->field('type_id,count(id) as num')->where("rid=$role_id and hero_id=0")->group('type_id')->select();
        foreach($rune_info as $rune_info_val){
            if(isset($item_info_re[$rune_info_val['type_id']])){
                $item_info = $item_info_re[$rune_info_val['type_id']];
                $rune_info_data[] = [
                    'id' => $item_info['id'],
                    'name' => $item_info['name'],
                    'quality' => $item_info['quality'],
                    'num' => $rune_info_val['num'],
                ];
            }
        }

        //获取背包神装信息
        $god_equip_data = [];
        $god_equip = $this->data_db->table('god_equip')->field('sys_id,count(id) as num')->where("rid=$role_id and hero_id=0")->group('sys_id')->select();
        foreach($god_equip as $god_equip_val){
            if(isset($item_info_re[$god_equip_val['sys_id']])){
                $item_info = $item_info_re[$god_equip_val['sys_id']];
                $god_equip_data[] = [
                    'id' => $item_info['id'],
                    'name' => $item_info['name'],
                    'quality' => $item_info['quality'],
                    'num' => $god_equip_val['num'],
                ];
            }
        }

        //获取未使用的宠物
        $hero_pet_data = [];
        $hero_pet = $this->data_db->table('pet')->field('sys_id,count(id) as num')->where("rid=$role_id and hero_id=0")->group('sys_id')->select();
        foreach($hero_pet as $hero_pet_val){
            if(isset($item_info_re[$hero_pet_val['sys_id']])){
                $item_info = $item_info_re[$hero_pet_val['sys_id']];
                $hero_pet_data[] = [
                    'id' => $item_info['id'],
                    'name' => $item_info['name'],
                    'quality' => $item_info['quality'],
                    'num' => $hero_pet_val['num'],
                ];
            }
        }

        unset($item_info_re);

        $this->assign([
            'type_label_1' => isset($back_pack_data['type_label_1']) ? $back_pack_data['type_label_1'] : [],
            'type_label_2' => isset($back_pack_data['type_label_2']) ? $back_pack_data['type_label_2'] : [],
            'type_label_3' => isset($back_pack_data['type_label_3']) ? $back_pack_data['type_label_3'] : [],
            'type_label_4' => $rune_info_data,
            'type_label_5' => isset($back_pack_data['type_label_5']) ? $back_pack_data['type_label_5'] : [],
            'type_label_6' => $god_equip_data,
            'type_label_8' => $hero_pet_data,
        ]);
        $this->display();
    }

    /**
     * 英雄装备
     */
    public function hero_equip(){
        $hero_id = I('hero_id', '');
        $sid = I('sid', '0');
        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if(empty($hero_id) || empty($server_info)){
            $this->display();
            exit;
        }
        $this->data_db = connectionDb($server_info);    //连接游戏data库

        //获取玩家的道具背包
        $hero_equip = $this->data_db->table('hero_equip')->where("hero_id=$hero_id")->select();

        //获取道具基本数据
        $item_info = $this->platform_db->table('gift_item')->where("type_label=1")->select();
        $item_info_re = [];
        foreach($item_info as $item_val){
            $item_info_re[$item_val['id']] = $item_val;
        }
        unset($item_info);
        foreach($hero_equip as &$hero_equip_val){
            if(isset($item_info_re[$hero_equip_val['sys_id']])){
                $hero_equip_val['sys_name'] = $item_info_re[$hero_equip_val['sys_id']]['name'];
                $hero_equip_val['quality'] = $item_info_re[$hero_equip_val['sys_id']]['quality'];
                $hero_equip_val['star'] = $item_info_re[$hero_equip_val['sys_id']]['star'];
            }else{
                $hero_equip_val['sys_name'] = '';
                $hero_equip_val['quality'] = 0;
                $hero_equip_val['star'] = 0;
            }
        }
        $this->assign([
            'hero_equip' => $hero_equip,
        ]);
        $this->display();
    }

    /**
     * 英雄精灵
     */
    public function hero_rune(){
        $hero_id = I('hero_id', '');
        $sid = I('sid', '0');
        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if(empty($hero_id) || empty($server_info)){
            $this->display();
            exit;
        }
        $this->data_db = connectionDb($server_info);    //连接游戏data库

        //获取玩家的道具背包
        $hero_rune = $this->data_db->table('rune_info')->where("hero_id=$hero_id")->select();

        //获取道具基本数据
        $item_info = $this->platform_db->table('gift_item')->where("type_label=4")->select();
        $item_info_re = [];
        foreach($item_info as $item_val){
            $item_info_re[$item_val['id']] = $item_val;
        }
        unset($item_info);
        foreach($hero_rune as &$hero_rune_val){
            if(isset($item_info_re[$hero_rune_val['type_id']])){
                $hero_rune_val['type_name'] = $item_info_re[$hero_rune_val['type_id']]['name'];
                $hero_rune_val['quality'] = $item_info_re[$hero_rune_val['type_id']]['quality'];
            }else{
                $hero_rune_val['type_name'] = '';
                $hero_rune_val['quality'] = 0;
            }
        }
        $this->assign([
            'hero_rune' => $hero_rune,
        ]);
        $this->display();
    }

    /**
     * 英雄宝石
     */
    public function hero_jewel(){
        $hero_id = I('hero_id', '');
        $sid = I('sid', '0');
        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if(empty($hero_id) || empty($server_info)){
            $this->display();
            exit;
        }
        $this->data_db = connectionDb($server_info);    //连接游戏data库

        //获取玩家的道具背包
        $hero_jewel = $this->data_db->table('hero_jewel')->where("hero_id=$hero_id")->select();

        //获取道具基本数据
        $item_info = $this->platform_db->table('gift_item')->where("type_label=5")->select();
        $item_info_re = [];
        foreach($item_info as $item_val){
            $item_info_re[$item_val['id']] = $item_val;
        }
        unset($item_info);
        foreach($hero_jewel as &$hero_jewel_val){
            if(isset($item_info_re[$hero_jewel_val['sys_id']])){
                $hero_jewel_val['sys_name'] = $item_info_re[$hero_jewel_val['sys_id']]['name'];
                $hero_jewel_val['quality'] = $item_info_re[$hero_jewel_val['sys_id']]['quality'];
                $hero_jewel_val['star'] = $item_info_re[$hero_jewel_val['sys_id']]['star'];
            }else{
                $hero_jewel_val['sys_name'] = '';
                $hero_jewel_val['quality'] = 0;
                $hero_jewel_val['star'] = 0;
            }
        }
        $this->assign([
            'hero_jewel' => $hero_jewel,
        ]);
        $this->display();
    }

    /**
     * 英雄神装
     */
    public function hero_god_equip(){
        $hero_id = I('hero_id', '');
        $sid = I('sid', '0');
        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if(empty($hero_id) || empty($server_info)){
            $this->display();
            exit;
        }
        $this->data_db = connectionDb($server_info);    //连接游戏data库

        //获取玩家的道具背包
        $hero_god_equip = $this->data_db->table('god_equip')->where("hero_id=$hero_id")->select();

        //获取道具基本数据
        $item_info = $this->platform_db->table('gift_item')->where("type=12")->select();
        $item_info_re = [];
        foreach($item_info as $item_val){
            $item_info_re[$item_val['id']] = $item_val;
        }
        unset($item_info);
        foreach($hero_god_equip as &$hero_god_equip_val){
            if(isset($item_info_re[$hero_god_equip_val['sys_id']])){
                $hero_god_equip_val['type_name'] = $item_info_re[$hero_god_equip_val['sys_id']]['name'];
                $hero_god_equip_val['quality'] = $item_info_re[$hero_god_equip_val['sys_id']]['quality'];
            }else{
                $hero_god_equip_val['type_name'] = '';
                $hero_god_equip_val['quality'] = 0;
            }
        }
        $this->assign([
            'hero_god_equip' => $hero_god_equip,
        ]);
        $this->display();
    }

    /**
     * 英雄灵器
     */
    public function hero_reiki_equip(){
        $hero_id = I('hero_id', '');
        $sid = I('sid', '0');
        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if(empty($hero_id) || empty($server_info)){
            $this->display();
            exit;
        }
        $this->data_db = connectionDb($server_info);    //连接游戏data库

        //获取玩家的灵器数据
        $hero_reiki_equip = $this->data_db->table('reiki_equip')->where("hero_id=$hero_id")->select();

        //获取道具基本数据
        $item_info = $this->platform_db->table('gift_item')->where("type=17")->select();
        $item_info_re = [];
        foreach($item_info as $item_val){
            $item_info_re[$item_val['id']] = $item_val;
        }
        unset($item_info);
        foreach($hero_reiki_equip as &$hero_reiki_equip_val){
            if(isset($item_info_re[$hero_reiki_equip_val['sys_id']])){
                $hero_reiki_equip_val['type_name'] = $item_info_re[$hero_reiki_equip_val['sys_id']]['name'];
                $hero_reiki_equip_val['quality'] = $item_info_re[$hero_reiki_equip_val['sys_id']]['quality'];
            }else{
                $hero_reiki_equip_val['type_name'] = '';
                $hero_reiki_equip_val['quality'] = 0;
            }
        }
        $this->assign([
            'hero_reiki_equip' => $hero_reiki_equip,
        ]);
        $this->display();
    }

    /**
     * 英雄宠物
     */
    public function hero_pet(){
        $hero_id = I('hero_id', '');
        $sid = I('sid', '0');
        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if(empty($hero_id) || empty($server_info)){
            $this->display();
            exit;
        }
        $this->data_db = connectionDb($server_info);    //连接游戏data库

        //获取玩家英雄身上的宠物数据
        $hero_pet = $this->data_db->table('pet')->where("hero_id=$hero_id")->select();

        //获取属性表数据
        $attribute_data = $this->platform_db->table('attribute')->select();
        $attribute_data_re = [];
        foreach($attribute_data as $attribute_data_val){
            $attribute_data_re[$attribute_data_val['id']] = $attribute_data_val;
        }

        //获取宠物道具基本数据
        $item_info = $this->platform_db->table('gift_item')->where("type=18")->select();
        $item_info_re = [];
        foreach($item_info as $item_val){
            $item_info_re[$item_val['id']] = $item_val;
        }
        unset($item_info);

        //获取宠物属性基本数据
        $pet_things_data = $this->platform_db->table('pet_things')->select();
        $pet_things_data_re = [];
        foreach($pet_things_data as $pet_things_val){
            $pet_things_data_re[$pet_things_val['id']] = $pet_things_val;
        }
        unset($pet_things_data);

        //获取宠物等级属性基本数据
        $pet_level_data = $this->platform_db->table('pet_level')->select();
        $pet_level_data_re = [];
        foreach($pet_level_data as $pet_level_val){
            $pet_level_data_re[$pet_level_val['pet_id'] . '-' . $pet_level_val['level']] = $pet_level_val;
        }
        unset($pet_level_data);


        foreach($hero_pet as &$hero_pet_val){
            $pet_id = $hero_pet_val['sys_id'];
            //获取宠物名字
            if(isset($item_info_re[$pet_id])){
                $hero_pet_val['type_name'] = $item_info_re[$pet_id]['name'];
            }else{
                $hero_pet_val['type_name'] = '';
            }
            //获取品质和元素
            if(isset($pet_things_data_re[$pet_id])){
                $hero_pet_val['elem'] = $pet_things_data_re[$pet_id]['elem'];
                $hero_pet_val['quality'] = $pet_things_data_re[$pet_id]['quality'];
            }else{
                $hero_pet_val['elem'] = '0';
                $hero_pet_val['quality'] = '';
            }
            //获取宠物属性、技能和技能等级
            if(isset($pet_level_data_re[$pet_id . '-' . $hero_pet_val['level']])){
                $attribute = $pet_level_data_re[$pet_id . '-' . $hero_pet_val['level']]['attribute'];
                $hero_pet_val['skill'] = $pet_level_data_re[$pet_id . '-' . $hero_pet_val['level']]['skill'];
                $hero_pet_val['skill_level'] = $pet_level_data_re[$pet_id . '-' . $hero_pet_val['level']]['skill_level'];
            }else{
                $attribute = '';
                $hero_pet_val['skill'] = '';
                $hero_pet_val['skill_level'] = '';
            }
            $attribute_str = '';
            
            if(!empty($attribute)){
                $attribute = json_decode($attribute, true);
                foreach($attribute as $attribute_val){
                    foreach($attribute_val as $attribute_val_key=>$attribute_val_val){
                        if(isset($attribute_data_re[$attribute_val_key])){
                            $attribute_str .= $attribute_data_re[$attribute_val_key]['name'] . '-->' . $attribute_val_val . ';<br>';
                        }
                    }
                }
            }
            $hero_pet_val['attribute'] = $attribute_str;
        }
        $this->assign([
            'hero_pet' => $hero_pet,
        ]);
        $this->display();
    }

    /*上传公会科技配置*/
    public function UpClanSkillConfig(){
        $this->display();
    }

    /*上传公会科技配置ajax*/
    public function ajax_UpClanSkillConfig(){
        $params = I('post.');
        //获取活动数据，解析活动数据excel文件
        $excel_data = array();
        $now_time = time();
        if( $params['data_file'] && file_exists(LSS . '/Uploads/Excel/' . $params["data_file"]) ){
            $data_file = LSS . '/Uploads/Excel/' . $params['data_file'];
            $excel_read = getPHPExcelRead($data_file);
            //获取表格行数
            $rowCount = $excel_read->getActiveSheet()->getHighestRow();
            //获取表格列数
           $columnCount = $excel_read->getActiveSheet()->getHighestColumn();
            // $columnCount = 'D';

            /* 循环读取每个单元格的数据 */
            //行数循环
            //获取数据的key
            $fixed_row = 3;
            for ($column = 'A'; $column <= $columnCount; $column++) {
                $cell_val = $excel_read->getActiveSheet()->getCell($column . $fixed_row)->getValue();
                if(is_object($cell_val)){
                    $cell_val = $cell_val->__toString();
                }
                $data_key_arr[$column] = $cell_val;
            }
            for ($row = $fixed_row+1; $row <= $rowCount; $row++) {
                //列数循环 , 列数是以A列开始
                for ($column = 'A'; $column <= $columnCount; $column++) {
                    $cell_val = $excel_read->getActiveSheet()->getCell($column . $row)->getValue();
                    if(is_object($cell_val)){
                        $cell_val = $cell_val->__toString();
                    }
                    $excel_data[$row - $fixed_row - 1][$data_key_arr[$column]] = $cell_val;
                }
            }
        }
        foreach($excel_data as $excel_val){
            $insert_data[] = [
                'id' => $excel_val['idx'],
                'type' => $excel_val['type'],
                'occupation' => $excel_val['occupation'],
                'ability' => $excel_val['ability'],
                'name' => $excel_val['name'],
                'num' => $excel_val['num'],
                'created_at' => $now_time,
            ];
        }
        $save = M('clan_skill_config')->addAll($insert_data,[],true);
        if ($save) {
            $status = ['status'=>1,'message'=>'上传公会科技配置成功~'];
        }else{
            $status = ['status'=>0,'message'=>'上传公会科技配置失败'];
        }
        $this->ajaxReturn($status);
    }
}
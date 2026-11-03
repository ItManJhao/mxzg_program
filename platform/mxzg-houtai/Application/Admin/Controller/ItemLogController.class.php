<?php
namespace Admin\Controller;

use Think\Controller;

/*
 * 玩家道具日志
 */
class ItemLogController extends PublicController{

    protected $db;
    /*搜索*/
    public function index(){

        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where('parent_id>0')->select();
        //获取所有的服务器
        $servers = $this->platform_db->table('server')->select();
        //获取所有的游戏事件
        $event_list = $this->platform_db->table('game_event')->select();

        //获取所有的礼包道具
        $item_list = $this->platform_db->table('gift_item')->select();
        $item_info_re = [];
        foreach($item_list as $item_val){
            $item_info_re[$item_val['id']] = $item_val;
        }
        $item_datas = getItemTypeData($item_list);
        $item_class_arr = $item_datas['item_class_arr'];    //用于页面二级下拉框筛选

        $now_date = date('Y-m-d H:i:s');
        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $role_id = I('role_id', '');
        $item_type = I('item_type', '0');                //道具id
        $item_class = I('item_class', '0');               //道具分类
        $oprate = I('oprate', 'all');
        $game_event = I('game_event', '0');             //来源
        $start_time = I('start_time', date('Y-m-d H:i:s', strtotime("-7 day")));;
        $end_time = I('end_time', $now_date);

        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->select();

        //组件搜索条件的值
        $search_params = [
            'role_id' => $role_id,
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'oprate' => $oprate,
            'item_type' => $item_type,
            'item_class' => $item_class,
            'game_event' => $game_event,
            'start_time' => $start_time,
            'end_time' => $end_time,
        ];

        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'count'=>0, 'page'=>'', 'item_classs'=> $this->item_class, 'event_list'=> $event_list, 'item_class_arr'=>$item_class_arr, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        //判断时间是否都选择
        if(empty($start_time) || empty($end_time)){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间都必须选择！！！', 'count'=>0, 'page'=>'', 'item_classs'=> $this->item_class, 'event_list'=> $event_list, 'item_class_arr'=>$item_class_arr, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        if(date('Y-m', strtotime($start_time)) != date('Y-m', strtotime($end_time))){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间必须是同月！！！', 'count'=>0, 'page'=>'', 'item_classs'=> $this->item_class, 'event_list'=> $event_list, 'item_class_arr'=>$item_class_arr, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $this->db = connectionDb($server_info, 'log');     //连接游戏数据库

        $where = "1 ";
        if(!empty($role_id)){
            $where .= "and rid='$role_id' ";
        }
        if(!empty($c_son_id)){
            $where .= "and place in($c_son_id) ";
        }
        if($oprate == 1){
            if($item_class == 18){
                $where .= "and type=1 ";
            }else{
                $where .= "and delta>0 ";
            }
        }elseif($oprate == 2){
            if($item_class == 18){
                $where .= "and type=0 ";
            }else{
                $where .= "and delta<0 ";
            }
        }
        if(!empty($game_event)){
            $where .= "and event in($game_event) ";
        }
        $where .= "and time>=" . strtotime($start_time) . ' ';
        $where .= "and time<=" . strtotime($end_time) . ' ';

        if($item_class == 1){           //金币
            $table = 'gold_log' . getLogTable('month', $start_time);
        }elseif($item_class == 2){      //钻石
            $table = 'gem_log' . getLogTable('month', $start_time);
        }elseif($item_class == 3){      //角色经验
            $table = 'role_exp_log' . getLogTable('month', $start_time);
        }elseif($item_class == 5){      //英雄经验
            $table = 'hero_exp_log' . getLogTable('month', $start_time);
        }elseif($item_class == 8){      //精灵
            if(!empty($item_type)){
                $where .= "and type in($item_type) ";
            }
            $table = 'rune_log' . getLogTable('month', $start_time);
        }elseif($item_class == 61){      //装备
            if(!empty($item_type)){
                $where .= "and type in($item_type) ";
            }else{
                //查询装备的id集合
                $equips = $this->platform_db->table('gift_item')->field("id")->where("type=6 and type_label=1")->select();
                $equip_ids = array_column($equips, 'id');
                $equip_ids = implode(',', $equip_ids);
                $where .= "and type in ($equip_ids) ";
            }
            $table = 'item_log' . getLogTable('month', $start_time);
        }elseif($item_class == 65){      //宝石
            if(!empty($item_type)){
                $where .= "and type in($item_type) ";
            }else{
                //查询装备的id集合
                $equips = $this->platform_db->table('gift_item')->field("id")->where("type=6 and type_label=5")->select();
                $equip_ids = array_column($equips, 'id');
                $equip_ids = implode(',', $equip_ids);
                $where .= "and type in ($equip_ids) ";
            }
            $table = 'item_log' . getLogTable('month', $start_time);
        }elseif($item_class == 12){      //神装
            if(!empty($item_type)){
                $where .= "and sys_id in($item_type) ";
            }
            $table = 'god_equip_log' . getLogTable('month', $start_time);
        }elseif($item_class == 17){      //灵器
            if(!empty($item_type)){
                $where .= "and sys_id in($item_type) ";
            }
            $table = 'reiki_equip_log' . getLogTable('month', $start_time);
        }elseif($item_class == 18){      //宠物
            if(!empty($item_type)){
                $where .= "and sys_id in($item_type) ";
            }
            $table = 'pet_log' . getLogTable('month', $start_time);
        }elseif($item_class == 6){      //道具
            if(!empty($item_type)){
                $where .= "and type in($item_type) ";
            }else{
                //查询装备的id集合
                $equips = $this->platform_db->table('gift_item')->field("id")->where("type=6 and type_label in(1,5)")->select();
                $equip_ids = array_column($equips, 'id');
                $equip_ids = implode(',', $equip_ids);
                $where .= "and type not in ($equip_ids) ";
            }
            $table = 'item_log' . getLogTable('month', $start_time);
        }
        
        //判断表是否存在
        $is_table = checkTable($this->db, $table);
        if($is_table){
            $count = $this->db->table($table)
                ->where($where)
                ->count();
            $Page  = new \Think\Page($count, 50);
            $list = $this->db->table($table)
                ->where($where)
                ->order('time desc')
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();
        }else{
            $count = 0;
            $Page  = new \Think\Page($count, 50);
            $list = [];
        }
        

        $role_arr = [];     //存储角色信息数据，避免重复查询

        foreach($list as &$list_val){
            //处理操作变量
            if($item_class == 18){
                if($list_val['type'] == 1){
                    $list_val['oprate'] = '增加';
                }else{
                    $list_val['oprate'] = '消耗';
                }
            }else{
                if($list_val['delta'] > 0){
                    $list_val['oprate'] = '增加';
                }else{
                    $list_val['oprate'] = '消耗';
                }
            }

            if(!isset($role_arr[$list_val['rid']])){
                $role_arr[$list_val['rid']] = $this->platform_db->table('user_server')
                    ->alias('us')
                    ->field('us.*,ch1.name as channel_name,ch2.name as channel_name_son')
                    ->join("left join user on user.id=us.user_id")
                    ->join("left join channel as ch1 on ch1.id=user.c_id")
                    ->join("left join channel as ch2 on ch2.id=user.c_son_id")
                    ->where('role_id=' . $list_val['rid'])
                    ->find();
            }
            $list_val['role_name'] = $role_arr[$list_val['rid']]['role_name'];
            $list_val['user_id'] = $role_arr[$list_val['rid']]['user_id'];
            $list_val['channel_name'] = $role_arr[$list_val['rid']]['channel_name'];
            $list_val['channel_name_son'] = $role_arr[$list_val['rid']]['channel_name_son'];

            $list_val['item_name'] = '';
            $list_val['item_type_name'] = '';
            $list_val['item_quality'] = 0;
            if(in_array($item_class, [12,17,18])){  //神装，灵器。宠物
                $list_val['type'] = $list_val['sys_id'];
            }
            if(!in_array($item_class, [1,2,3,5])){
                //处理道具数据
                if(isset( $item_info_re[$list_val['type']] ) ){
                    $item_info = $item_info_re[$list_val['type']];
                    $list_val['item_name'] = $item_info['name'];
                    $list_val['item_type_name'] = $item_info['type_name'];
                    $list_val['item_quality'] = $item_info['quality'];
                }
            }
            
            if(isset($list_val['curr'])){
                $list_val['old'] = $list_val['curr'] - $list_val['delta'];
            }else{
                $list_val['old'] = '';
            }
            
        }

        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'item_classs'=> $this->item_class, 'event_list'=> $event_list, 'item_class_arr'=>$item_class_arr, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    //导出
    public function export(){
        ini_set('memory_limit','256M'); //临时提高内存

        //获取所有的礼包道具
        $item_list = $this->platform_db->table('gift_item')->select();
        $item_info_re = [];
        foreach($item_list as $item_val){
            $item_info_re[$item_val['id']] = $item_val;
        }

        $now_date = date('Y-m-d');
        //记录搜索条件
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '0');
        $role_id = I('role_id', '');
        $item_type = I('item_type', '0');                //道具id
        $item_class = I('item_class', '0');               //道具分类
        $oprate = I('oprate', 'all');
        $game_event = I('game_event', '0');             //来源
        $start_time = I('start_time', $now_date);
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
            $this->db = connectionDb($server_info, 'log');     //连接游戏数据库

            $where = "1 ";
            if(!empty($role_id)){
                $where .= "and rid='$role_id' ";
            }
            if(!empty($c_son_id)){
                $where .= "and place in($c_son_id) ";
            }
            if($oprate == 1){
                if($item_class == 18){
                    $where .= "and type=1 ";
                }else{
                    $where .= "and delta>0 ";
                }
            }elseif($oprate == 2){
                if($item_class == 18){
                    $where .= "and type=0 ";
                }else{
                    $where .= "and delta<0 ";
                }
            }
            if(!empty($game_event)){
                $where .= "and event in($game_event) ";
            }
            $where .= "and time>=" . strtotime($start_time) . ' ';
            $where .= "and time<=" . strtotime($end_time) . ' ';

            if($item_class == 1){           //金币
                $table = 'gold_log' . getLogTable('month', $start_time);
            }elseif($item_class == 2){      //钻石
                $table = 'gem_log' . getLogTable('month', $start_time);
            }elseif($item_class == 3){      //角色经验
                $table = 'role_exp_log' . getLogTable('month', $start_time);
            }elseif($item_class == 5){      //英雄经验
                $table = 'hero_exp_log' . getLogTable('month', $start_time);
            }elseif($item_class == 8){      //精灵
                if(!empty($item_type)){
                    $where .= "and type in($item_type) ";
                }
                $table = 'rune_log' . getLogTable('month', $start_time);
            }elseif($item_class == 61){      //装备
                if(!empty($item_type)){
                    $where .= "and type in($item_type) ";
                }else{
                    //查询装备的id集合
                    $equips = $this->platform_db->table('gift_item')->field("id")->where("type=6 and type_label=1")->select();
                    $equip_ids = array_column($equips, 'id');
                    $equip_ids = implode(',', $equip_ids);
                    $where .= "and type in ($equip_ids) ";
                }
                $table = 'item_log' . getLogTable('month', $start_time);
            }elseif($item_class == 65){      //宝石
                if(!empty($item_type)){
                    $where .= "and type in($item_type) ";
                }else{
                    //查询装备的id集合
                    $equips = $this->platform_db->table('gift_item')->field("id")->where("type=6 and type_label=5")->select();
                    $equip_ids = array_column($equips, 'id');
                    $equip_ids = implode(',', $equip_ids);
                    $where .= "and type in ($equip_ids) ";
                }
                $table = 'item_log' . getLogTable('month', $start_time);
            }elseif($item_class == 12){      //神装
                if(!empty($item_type)){
                    $where .= "and sys_id in($item_type) ";
                }
                $table = 'god_equip_log' . getLogTable('month', $start_time);
            }elseif($item_class == 17){      //灵器
                if(!empty($item_type)){
                    $where .= "and sys_id in($item_type) ";
                }
                $table = 'reiki_equip_log' . getLogTable('month', $start_time);
            }elseif($item_class == 18){      //宠物
                if(!empty($item_type)){
                    $where .= "and sys_id in($item_type) ";
                }
                $table = 'pet_log' . getLogTable('month', $start_time);
                
            }elseif($item_class == 6){      //道具
                if(!empty($item_type)){
                    $where .= "and type in($item_type) ";
                }else{
                    //查询装备的id集合
                    $equips = $this->platform_db->table('gift_item')->field("id")->where("type=6 and type_label in(1,5)")->select();
                    $equip_ids = array_column($equips, 'id');
                    $equip_ids = implode(',', $equip_ids);
                    $where .= "and type not in ($equip_ids) ";
                }
                $table = 'item_log' . getLogTable('month', $start_time);
            }
            
            //判断表是否存在
            $is_table = checkTable($this->db, $table);
            if($is_table){
                $list = $this->db->table($table)
                ->where($where)
                ->order('time desc')
                ->limit(C('EXPORT_LIMIT_NUM'))       //限制导出数量
                ->select();
            }else{
                $list = [];
            }

            $role_arr = [];     //存储角色信息数据，避免重复查询

            foreach($list as &$list_val){
                //处理操作变量
                if($item_class == 18){
                    if($list_val['type'] == 1){
                        $list_val['oprate'] = '增加';
                    }else{
                        $list_val['oprate'] = '消耗';
                    }
                }else{
                    if($list_val['delta'] > 0){
                        $list_val['oprate'] = '增加';
                    }else{
                        $list_val['oprate'] = '消耗';
                    }
                }

                if(!isset($role_arr[$list_val['rid']])){
                    $role_arr[$list_val['rid']] = $this->platform_db->table('user_server')
                        ->alias('us')
                        ->field('us.*,ch1.name as channel_name,ch2.name as channel_name_son')
                        ->join("left join user on user.id=us.user_id")
                        ->join("left join channel as ch1 on ch1.id=user.c_id")
                        ->join("left join channel as ch2 on ch2.id=user.c_son_id")
                        ->where('role_id=' . $list_val['rid'])
                        ->find();
                }
                $list_val['role_name'] = $role_arr[$list_val['rid']]['role_name'];
                $list_val['user_id'] = $role_arr[$list_val['rid']]['user_id'];
                $list_val['channel_name'] = $role_arr[$list_val['rid']]['channel_name'];
                $list_val['channel_name_son'] = $role_arr[$list_val['rid']]['channel_name_son'];

                $list_val['item_name'] = '';
                $list_val['item_type_name'] = '';
                $list_val['item_quality'] = 0;
                if(in_array($item_class, [12,17,18])){  //神装，灵器。宠物
                    $list_val['type'] = $list_val['sys_id'];
                }
                if(!in_array($item_class, [1,2,3,5])){
                    //处理道具数据
                    if(isset( $item_info_re[$list_val['type']] ) ){
                        $item_info = $item_info_re[$list_val['type']];
                        $list_val['item_name'] = $item_info['name'];
                        $list_val['item_type_name'] = $item_info['type_name'];
                        $list_val['item_quality'] = $item_info['quality'];
                    }
                }

                if(isset($list_val['curr'])){
                    $list_val['old'] = $list_val['curr'] - $list_val['delta'];
                }else{
                    $list_val['old'] = '';
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
        $letter = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P');
        //表头数组
        $tableheader = array('角色id','角色名称','子渠道','大渠道','账号id','区服id','道具id','道具','道具类型','品质','操作来源','操作类型','原有值','现有值','变化值','操作时间');
        //填充表头信息
        for($i = 0;$i < count($tableheader);$i++) {
            $excel->getActiveSheet()->setCellValue("$letter[$i]1","$tableheader[$i]");
        }
        $excel->getActiveSheet()->getDefaultColumnDimension()->setWidth(20);//所有单元格（列）默认宽度
        //填充表格信息
        for ($i = 2;$i <= count($list) + 1;$i++) {
            $excel->getActiveSheet()->setCellValue("A$i", $list[$i - 2]['rid']);
            $excel->getActiveSheet()->setCellValue("B$i", $list[$i - 2]['role_name']);
            $excel->getActiveSheet()->setCellValue("C$i", $list[$i - 2]['channel_name_son']);
            $excel->getActiveSheet()->setCellValue("D$i", $list[$i - 2]['channel_name']);
            $excel->getActiveSheet()->setCellValue("E$i", $list[$i - 2]['user_id']);
            $excel->getActiveSheet()->setCellValue("F$i", $sid);
            $excel->getActiveSheet()->setCellValue("G$i", $list[$i - 2]['type']);
            $excel->getActiveSheet()->setCellValue("H$i", $list[$i - 2]['item_name']);
            $excel->getActiveSheet()->setCellValue("I$i", $list[$i - 2]['item_type_name']);
            $excel->getActiveSheet()->setCellValue("J$i", $list[$i - 2]['item_quality']);
            $excel->getActiveSheet()->setCellValue("K$i", $list[$i - 2]['event'] . '--' . $list[$i - 2]['event_desc']);
            $excel->getActiveSheet()->setCellValue("L$i", $list[$i - 2]['oprate']);
            $excel->getActiveSheet()->setCellValue("M$i", $list[$i - 2]['old']);
            $excel->getActiveSheet()->setCellValue("N$i", $list[$i - 2]['curr']);
            $excel->getActiveSheet()->setCellValue("O$i", $list[$i - 2]['delta']);
            $excel->getActiveSheet()->setCellValue("P$i", date('Y-m-d H:i:s', $list[$i - 2]['time']));
        }

        //创建Excel输入对象
        ob_clean();
        $write = new \PHPExcel_Writer_Excel5($excel);
        header("Pragma: public");
        header("Expires: 0");
        $filename="item_log.xls";
        header("Content-Disposition: attachment;filename=$filename");
        header("Cache-Control:must-revalidate, post-check=0, pre-check=0");
        header("Content-Type:application/force-download");
        header("Content-Type:application/vnd.ms-execl");
        header("Content-Type:application/octet-stream");
        header("Content-Type:application/download");
        header("Content-Transfer-Encoding:binary");
        $write->save('php://output');
    }

}
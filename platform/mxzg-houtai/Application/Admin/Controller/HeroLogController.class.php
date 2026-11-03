<?php
namespace Admin\Controller;

use Think\Controller;

/*
 * 英雄获得/消耗日志
 */
class HeroLogController extends PublicController{
    protected $log_db;
    protected $data_db;

    /*搜索*/
    public function index(){
        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where('parent_id>0')->select();
        //获取所有的服务器
        $servers = $this->platform_db->table('server')->select();
        //获取所有的游戏事件
        $event_list = $this->platform_db->table('game_event')->select();
        //获取所有的英雄
        $hero_list = $this->platform_db->table('hero')->select();

        $now_date = date('Y-m-d H:i:s');
        //记录搜索条件
        $c_son_id = I('c_son_id', '0');
        $sid = I('sid', '0');
        $role_id = I('role_id', '');
        $oprate = I('oprate', 'all');
        $start_time = I('start_time', date('Y-m-d H:i:s', strtotime("-1 day")));
        $end_time = I('end_time', $now_date);
        $game_event = I('game_event', '0');             //来源
        $hero_id = I('hero_id', '0');             //来源
        $start_time = str_replace("+"," ",$start_time);
        $end_time = str_replace("+"," ",$end_time);

        
        $search_params = [
            'role_id' => $role_id,
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'oprate' => $oprate,
            'game_event' => $game_event,
            'hero_id' => $hero_id,
            'start_time' => $start_time,
            'end_time' => $end_time,
        ];
        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'count'=>0, 'page'=>'', 'hero_list' => $hero_list, 'event_list' => $event_list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        //判断时间是否都选择
        if(empty($start_time) || empty($end_time)){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间都必须选择！！！', 'count'=>0, 'page'=>'', 'hero_list' => $hero_list, 'event_list'=> $event_list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        if(date('Y-m', strtotime($start_time)) != date('Y-m', strtotime($end_time))){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间必须是同月！！！', 'count'=>0, 'page'=>'', 'hero_list' => $hero_list, 'event_list'=> $event_list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        $this->log_db = connectionDb($server_info, 'log');     //连接游戏日志数据库
        $this->data_db = connectionDb($server_info, 'data');     //连接游戏数据库

        $where = "1 ";
        if(!empty($role_id)){
            $where .= "and rid='$role_id' ";
        }
        if(!empty($c_son_id)){
            $where .= "and place in($c_son_id) ";
        }
        if(!empty($hero_id)){
            $where .= "and type in($hero_id) ";
        }
        if(!empty($game_event)){
            $where .= "and event in($game_event) ";
        }
        if($oprate == 1){
            $where .= "and delta>0 ";
        }elseif($oprate == 2){
            $where .= "and delta<0 ";
        }
        if(!empty($start_time)){
            $where .= "and time>=" . strtotime($start_time) . ' ';
        }
        if(!empty($end_time)){
            $where .= "and time<=" . strtotime($end_time) . ' ';
        }

        $table = 'hero_log' . getLogTable();
        $count = $this->log_db->table($table)
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,20);
        $list = $this->log_db->table($table)
            ->where($where)
            ->order('rid desc')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        //获取英雄数据
        $hero_data = $this->platform_db->table('hero')->select();
        $hero_data_re = [];
        foreach($hero_data as $hero_val){
            $hero_data_re[$hero_val['id']] = $hero_val;
        }
        unset($item_data);
        $hero_arr = [];     //存储英雄信息数据，避免重复查询
        $role_arr = [];     //存储角色信息数据，避免重复查询

        foreach($list as &$list_val){
            //获取角色信息
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
            $list_val['role_level'] = $role_arr[$list_val['rid']]['level'];
            $list_val['user_id'] = $role_arr[$list_val['rid']]['user_id'];
            $list_val['channel_name'] = $role_arr[$list_val['rid']]['channel_name'];
            $list_val['channel_name_son'] = $role_arr[$list_val['rid']]['channel_name_son'];

            //获取英雄信息
            if(!isset($hero_arr[$list_val['hero_id']])){
                $hero_arr[$list_val['hero_id']] = $this->data_db->table('hero')
                    ->where('id=' . $list_val['hero_id'])
                    ->find();
            }

            $list_val['elem'] = isset($hero_arr[$list_val['hero_id']]['elem']) ? $hero_arr[$list_val['hero_id']]['elem'] : 0;
            $list_val['occupation'] = isset($hero_arr[$list_val['hero_id']]['occupation']) ? $hero_arr[$list_val['hero_id']]['occupation'] : 0;

            //处理英雄信息
            $list_val['hero_name'] = isset($hero_data_re[$list_val['type']]) ? $hero_data_re[$list_val['type']]['name'] : '';
            $list_val['elem'] = isset($hero_data_re[$list_val['type']]) ? $hero_data_re[$list_val['type']]['elem'] : '';
            $list_val['occupation'] = isset($hero_data_re[$list_val['type']]) ? $hero_data_re[$list_val['type']]['occupation'] : '';

            //处理操作变量
            if($list_val['delta'] > 0){
                $list_val['oprate'] = '获得';
            }else{
                $list_val['oprate'] = '消耗';
            }
        }

        
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'hero_list' => $hero_list, 'event_list' => $event_list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    //导出
    public function export(){
        ini_set('memory_limit','256M'); //临时提高内存
        $now_date = date('Y-m-d H:i:s');
        //记录搜索条件
        $c_son_id = I('c_son_id', '0');
        $sid = I('sid', '0');
        $role_id = I('role_id', '');
        $oprate = I('oprate', 'all');
        $start_time = I('start_time', $now_date);
        $end_time = I('end_time', $now_date);
        $game_event = I('game_event', '0');             //来源
        $start_time = str_replace("+"," ",$start_time);
        $end_time = str_replace("+"," ",$end_time);

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
            $this->log_db = connectionDb($server_info, 'log');     //连接游戏日志数据库
            $this->data_db = connectionDb($server_info, 'data');     //连接游戏数据库

            $where = "1 ";
            if(!empty($role_id)){
                $where .= "and rid='$role_id' ";
            }
            if(!empty($c_son_id)){
                $where .= "and place in($c_son_id) ";
            }
            if(!empty($game_event)){
                $where .= "and event in($game_event) ";
            }
            if($oprate == 1){
                $where .= "and delta>0 ";
            }elseif($oprate == 2){
                $where .= "and delta<0 ";
            }
            if(!empty($start_time)){
                $where .= "and time>=" . strtotime($start_time) . ' ';
            }
            if(!empty($end_time)){
                $where .= "and time<=" . strtotime($end_time) . ' ';
            }

            $table = 'hero_log' . getLogTable();
            $list = $this->log_db->table($table)
                ->where($where)
                ->order('rid desc')
                ->limit(C('EXPORT_LIMIT_NUM'))       //限制导出数量
                ->select();
        }else{
            $list = [];
        }

        //获取英雄数据
        $hero_data = $this->platform_db->table('hero')->select();
        $hero_data_re = [];
        foreach($hero_data as $hero_val){
            $hero_data_re[$hero_val['id']] = $hero_val;
        }
        unset($item_data);
        $hero_arr = [];     //存储英雄信息数据，避免重复查询
        $role_arr = [];     //存储角色信息数据，避免重复查询

        foreach($list as &$list_val){
            //获取角色信息
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
            $list_val['role_level'] = $role_arr[$list_val['rid']]['level'];
            $list_val['user_id'] = $role_arr[$list_val['rid']]['user_id'];
            $list_val['channel_name'] = $role_arr[$list_val['rid']]['channel_name'];
            $list_val['channel_name_son'] = $role_arr[$list_val['rid']]['channel_name_son'];

            //获取英雄信息
            if(!isset($hero_arr[$list_val['hero_id']])){
                $hero_arr[$list_val['hero_id']] = $this->data_db->table('hero')
                    ->where('id=' . $list_val['hero_id'])
                    ->find();
            }

            $list_val['elem'] = isset($hero_arr[$list_val['hero_id']]['elem']) ? $hero_arr[$list_val['hero_id']]['elem'] : 0;
            $list_val['occupation'] = isset($hero_arr[$list_val['hero_id']]['occupation']) ? $hero_arr[$list_val['hero_id']]['occupation'] : 0;

            //处理英雄信息
            $list_val['hero_name'] = isset($hero_data_re[$list_val['type']]) ? $hero_data_re[$list_val['type']]['name'] : '';
            $list_val['elem'] = isset($hero_data_re[$list_val['type']]) ? $hero_data_re[$list_val['type']]['elem'] : '';
            $list_val['occupation'] = isset($hero_data_re[$list_val['type']]) ? $hero_data_re[$list_val['type']]['occupation'] : '';

            //处理操作变量
            if($list_val['delta'] > 0){
                $list_val['oprate'] = '获得';
            }else{
                $list_val['oprate'] = '消耗';
            }
        }

        vendor('PHPExcel.PHPExcel');
        vendor('PHPExcel.PHPExcel.Writer.Excel5');
        Vendor("PHPExcel.PHPExcel.IOFactory");
        $excel = new \PHPExcel();
        //Excel表格式,这里简略写了8列
        $letter = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P');
        //表头数组
        $tableheader = array('角色id','角色名称','子渠道','大渠道','账号id','区服id','角色等级','操作类型','操作途径','英雄名称','等级','星级','阶级','元素','职业','操作时间');
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
            $excel->getActiveSheet()->setCellValue("G$i", $list[$i - 2]['role_level']);
            $excel->getActiveSheet()->setCellValue("H$i", $list[$i - 2]['oprate']);
            $excel->getActiveSheet()->setCellValue("I$i", $list[$i - 2]['event'] . '--' . $list[$i - 2]['event_desc']);
            $excel->getActiveSheet()->setCellValue("J$i", $list[$i - 2]['hero_name']);
            $excel->getActiveSheet()->setCellValue("K$i", $list[$i - 2]['level']);
            $excel->getActiveSheet()->setCellValue("L$i", $list[$i - 2]['star']);
            $excel->getActiveSheet()->setCellValue("M$i", $list[$i - 2]['stage']);
            $excel->getActiveSheet()->setCellValue("N$i", $list[$i - 2]['elem']);
            $excel->getActiveSheet()->setCellValue("O$i", $list[$i - 2]['occupation']);
            $excel->getActiveSheet()->setCellValue("P$i", date('Y-m-d H:i:s', $list[$i - 2]['time']));
        }

        //创建Excel输入对象
        ob_clean();
        $write = new \PHPExcel_Writer_Excel5($excel);
        header("Pragma: public");
        header("Expires: 0");
        $filename="hero_log.xls";
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
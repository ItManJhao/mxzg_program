<?php
namespace Admin\Controller;

use Think\Controller;

/*
 * 玩家钻石日志
 */
class GemLogController extends PublicController{

    protected $db;
    /*搜索*/
    public function index(){
        $now_date = date('Y-m-d H:i:s');
        //记录搜索条件
        $sid = I('sid', '0');
        $role_id = I('role_id', '');
        $event = I('event', '');
        $oprate = I('oprate', 'all');
        $start_time = I('start_time', date('Y-m-d H:i:s', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);

        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        //获取所有的服务器
        $servers = M('server')->select();

        //组件搜索条件的值
        $search_params = [
            'role_id' => $role_id,
            'sid' => $sid,
            'event' => $event,
            'oprate' => $oprate,
            'start_time' => $start_time,
            'end_time' => $end_time,
        ];

        //判断时间是否都选择
        if(empty($start_time) || empty($end_time)){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间都必须选择！！！', 'count'=>0, 'page'=>'', 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        if(date('Y-m', strtotime($start_time)) != date('Y-m', strtotime($end_time)) &&
            date("Y-m", strtotime($start_time)) != date('Y-m', strtotime($end_time))){
            $this->assign(['list'=>[], 'error_msg'=> '开始时间和结束时间必须是同月！！！', 'count'=>0, 'page'=>'', 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        //获取服务器信息
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if($server_info){
            $this->db = connectionDb($server_info, 'log');     //连接游戏数据库

            $where = "1 ";
            if(!empty($role_id)){
                $where .= "and rid='$role_id' ";
            }
            if(!empty($event)){
                $where .= "and event='$event' ";
            }
            if($oprate == 1){
                $where .= "and delta>0 ";
            }elseif($oprate == 2){
                $where .= "and delta<0 ";
            }
            $where .= "and time>=" . strtotime($start_time) . ' ';
            $where .= "and time<=" . strtotime($end_time) . ' ';

            $table = 'gem_log' . getLogTable('month', $start_time);
            $count = $this->db->table($table)
                ->where($where)
                ->count();
            $Page  = new \Think\Page($count,20);
            $list = $this->db->table($table)
                ->where($where)
                ->order('time desc')
                ->limit($Page->firstRow.','.$Page->listRows)
                ->select();
        }else{
            $this->assign(['list'=>[], 'error_msg'=> '请先选择服务器', 'count'=>0, 'page'=>'', 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $role_arr = [];     //存储角色信息数据，避免重复查询
        foreach($list as &$list_val){
            if(!isset($role_arr[$list_val['rid']])){
                $role_arr[$list_val['rid']] = M('user_server')
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

            //处理操作变量
            if($list_val['delta'] > 0){
                $list_val['oprate'] = '增加';
            }else{
                $list_val['oprate'] = '消耗';
            }
            $list_val['old'] = $list_val['curr'] - $list_val['delta'];
        }
        
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    //导出
    public function export(){
        ini_set('memory_limit','256M'); //临时提高内存
        $now_date = date('Y-m-d H:i:s');
        //记录搜索条件
        $sid = I('sid', '0');
        $role_id = I('role_id', '');
        $event = I('event', '');
        $oprate = I('oprate', 'all');
        $start_time = I('start_time', $now_date);
        $end_time = I('end_time', $now_date);

        //判断时间是否都选择
        $is_error = 0;
        if(empty($start_time) || empty($end_time)){
            $is_error = 1;
        }
        if(date('Y-m', strtotime($start_time)) != date('Y-m', strtotime($end_time)) &&
            date("Y-m", strtotime($start_time)) != date('Y-m', strtotime($end_time))){
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
            if(!empty($event)){
                $where .= "and event='$event' ";
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

            $table = 'gem_log' . getLogTable('month', $start_time);
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
            if(!isset($role_arr[$list_val['rid']])){
                $role_arr[$list_val['rid']] = M('user_server')
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

            //处理操作变量
            if($list_val['delta'] > 0){
                $list_val['oprate'] = '增加';
            }else{
                $list_val['oprate'] = '消耗';
            }
            $list_val['old'] = $list_val['curr'] - $list_val['delta'];
        }

        vendor('PHPExcel.PHPExcel');
        vendor('PHPExcel.PHPExcel.Writer.Excel5');
        Vendor("PHPExcel.PHPExcel.IOFactory");
        $excel = new \PHPExcel();
        //Excel表格式,这里简略写了8列
        $letter = array('A','B','C','D','E','F','G','H','I','J','K','L','M');
        //表头数组
        $tableheader = array('角色id','角色名称','子渠道','大渠道','账号id','区服id','操作来源id','操作来源','操作类型','原有值','现有值','变化值','操作时间');
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
            $excel->getActiveSheet()->setCellValue("G$i", $list[$i - 2]['event']);
            $excel->getActiveSheet()->setCellValue("H$i", $list[$i - 2]['event_desc']);
            $excel->getActiveSheet()->setCellValue("I$i", $list[$i - 2]['oprate']);
            $excel->getActiveSheet()->setCellValue("J$i", $list[$i - 2]['old']);
            $excel->getActiveSheet()->setCellValue("K$i", $list[$i - 2]['curr']);
            $excel->getActiveSheet()->setCellValue("L$i", $list[$i - 2]['delta']);
            $excel->getActiveSheet()->setCellValue("M$i", date('Y-m-d H:i:s', $list[$i - 2]['time']));
        }

        //创建Excel输入对象
        ob_clean();
        $write = new \PHPExcel_Writer_Excel5($excel);
        header("Pragma: public");
        header("Expires: 0");
        $filename="gem_log.xls";
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
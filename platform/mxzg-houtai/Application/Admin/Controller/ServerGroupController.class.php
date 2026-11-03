<?php
namespace Admin\Controller;
use Think\Controller;
use Think\Db;

/*
 * 跨服分组管理
 */
class ServerGroupController extends PublicController{

    protected $data_center_db;

    /*搜索*/
    public function index(){
        //实例化中心库数据库
        $this->data_center_db = M('',null,'DB_DATA_CENTER');

        $cross_cluster = $this->data_center_db->table('cross_cluster')->find();
        $last_time = date('Y-m-d H:i:s', $cross_cluster['serial_number']);
        $next_time = $cross_cluster['regrouping_time'];
        $groups = $cross_cluster['groups'];

        //获取所有服务器信息
        $servers = $this->platform_db->table('server')
            ->field("id,server_name")
            ->select();
        $servers_re = [];
        foreach($servers as $servers_val){
            $servers_re[$servers_val['id']] = $servers_val;
        }
        unset($servers);

        //获取中心库所有服务器的世界等级和活跃玩家等级数
        $server_infos = $this->data_center_db->table('server_info')
            ->field("id,world_level,active_players_number")
            ->select();
        $server_infos_re = [];
        foreach($server_infos as $server_infos_val){
            $server_infos_re[$server_infos_val['id']] = $server_infos_val;
        }
        unset($server_infos);

        $list = [];

        $is_export = I('is_export', '0');
        if(!empty($is_export)){     //导出
            $huanhang_str = "\n";
        }else{
            $huanhang_str = "<br/>";
        }
        
        if(!empty($groups)){
            $group_arr = json_decode($groups, true);
            foreach($group_arr as $group_val){
                $server_info = '';
                foreach($group_val['serverIds'] as $server_id){
                    $server_info .= $server_id;
                    if(isset($servers_re[$server_id])){
                        $server_info .= '--' . $servers_re[$server_id]['server_name'];
                    }
                    if(isset($server_infos_re[$server_id])){
                        $server_info .= '--' . $server_infos_re[$server_id]['world_level'] . '--' . $server_infos_re[$server_id]['active_players_number'];
                    }
                    $server_info .= "；" . $huanhang_str;
                }
                $list[] = [
                    'group_id' => $group_val['groupId'],
                    'groupType' => $group_val['groupType'] == 'NEW_SERVER' ? '新服组' : '旧服组',
                    'full' => $group_val['full'] ? '已满' : '未满',
                    'server_info' => $server_info,
                ];
            }
        }
        
        if(!empty($is_export)){     //导出
            $this->export($list,$last_time,$next_time);
        }

        $this->assign(['list'=>$list, 'last_time'=>$last_time, 'next_time'=>$next_time]);
        $this->display();
    }

    //导出
    private function export($list,$last_time,$next_time){
        ini_set('memory_limit','256M'); //临时提高内存

        vendor('PHPExcel.PHPExcel');
        vendor('PHPExcel.PHPExcel.Writer.Excel5');
        Vendor("PHPExcel.PHPExcel.IOFactory");
        $excel = new \PHPExcel();
        //Excel表格式,这里简略写了8列
        $letter = array('A','B','C','D','E','F');
        //表头数组
        $tableheader = array('分组ID','分组类型','区服集合（id-区服名称-世界等级-活跃玩家数量）','是否已满','上次分组时间','下次分组时间');
        //填充表头信息
        for($i = 0;$i < count($tableheader);$i++) {
            $excel->getActiveSheet()->setCellValue("$letter[$i]1","$tableheader[$i]");
        }
        $excel->getActiveSheet()->getDefaultColumnDimension()->setWidth(20);//所有单元格（列）默认宽度
        // $excel->getActiveSheet()->getStyle('A4')->getAlignment()->setWrapText(true);
        //填充表格信息
        for ($i = 2;$i <= count($list) + 1;$i++) {
            $excel->getActiveSheet()->setCellValue("A$i", $list[$i - 2]['group_id']);
            $excel->getActiveSheet()->setCellValue("B$i", $list[$i - 2]['groupType']);
            $excel->getActiveSheet()->setCellValue("C$i", $list[$i - 2]['server_info']);
            $excel->getActiveSheet()->setCellValue("D$i", $list[$i - 2]['full']);
            $excel->getActiveSheet()->setCellValue("E$i", $last_time);
            $excel->getActiveSheet()->setCellValue("F$i", $next_time);
        }

        //创建Excel输入对象
        ob_clean();
        $write = new \PHPExcel_Writer_Excel5($excel);
        header("Pragma: public");
        header("Expires: 0");
        $filename="server_group.xls";
        header("Content-Disposition: attachment;filename=$filename");
        header("Cache-Control:must-revalidate, post-check=0, pre-check=0");
        header("Content-Type:application/force-download");
        header("Content-Type:application/vnd.ms-execl");
        header("Content-Type:application/octet-stream");
        header("Content-Type:application/download");
        header("Content-Transfer-Encoding:binary");
        $write->save('php://output');
    }


    // public function add(){
    //     //获取服务器信息
    //     $server_list = $this->platform_db->table('server')
    //         ->field('*')
    //         ->select();
    //     $this->assign(['server_list' => $server_list]);
    //     $this->display();
    // }

    // public function edit(){
    //     $id = I('id', 0);
    //     //获取服务器信息
    //     $server_list = $this->platform_db->table('server')
    //         ->field('*')
    //         ->select();
    //     //获取活动数据
    //     $group_info = $this->platform_db->table('group')->where('id = '.$id.'')->find();
    //     $sids = $this->platform_db->table('group_server')
    //         ->where('group_id = '.$id.'')
    //         ->getField('sid',true);
    //     if(!empty($sids)){
    //         $group_info['sids'] = $sids;
    //     }else{
    //         $group_info['sids'] = [];
    //     }
    //     $this->assign(['group_info'=>$group_info, 'server_list' => $server_list]);
    //     $this->display();
    // }

    // /*添加*/
    // public function ajax_add(){
    //     $params = I('post.');
    //     if(empty($params['name'])){
    //         $status = ['status'=>0,'message'=>'分组名称不能为空'];
    //         $this->ajaxReturn($status);
    //     }
    //     if (empty($params['server_ids'])){
    //         $status = ['status'=>1,'message'=>'请选择服务器'];
    //         $this->ajaxReturn($status);
    //     }
    //     $now_time = time();
    //     //分组表
    //     $data = [
    //         'name' => $params['name'],
    //         'is_new' => $params['is_new'],
    //         'created_at' => $now_time,
    //     ];
    //     $group_id = $this->platform_db->table('group')->add($data);

    //     //区服分组关联表
    //     $data_gs = [];
    //     foreach($params['server_ids'] as $server_val){
    //         $data_gs[] = [
    //             'sid' => $server_val,
    //             'group_id' => $group_id,
    //             'updated_at' => $now_time,
    //             'created_at' => $now_time,
    //         ];
    //     }
    //     $save = $this->platform_db->table('group_server')->addAll($data_gs);

    //     if ($save) {
    //         $status = ['status'=>1,'message'=>'添加成功~'];
    //     }else{
    //         $status = ['status'=>0,'message'=>'添加失败'];
    //     }
    //     $this->ajaxReturn($status);
    // }

    // /*修改*/
    // public function ajax_updata(){
    //     $params = I('post.');
    //     if(empty($params['name'])){
    //         $status = ['status'=>0,'message'=>'分组名称不能为空'];
    //         $this->ajaxReturn($status);
    //     }
    //     if (empty($params['server_ids'])){
    //         $status = ['status'=>1,'message'=>'请选择服务器'];
    //         $this->ajaxReturn($status);
    //     }

    //     $group_id = $params['id'];
    //     $now_time = time();
    //     //分组表
    //     $data = [
    //         'name' => $params['name'],
    //         'is_new' => $params['is_new'],
    //     ];
    //     $this->platform_db->table('group')->where("id=$group_id")->save($data);

    //     //区服分组关联表
    //     $this->platform_db->table('group_server')->where("group_id=$group_id")->delete();
    //     $data_gs = [];
    //     foreach($params['server_ids'] as $server_val){
    //         $data_gs[] = [
    //             'sid' => $server_val,
    //             'group_id' => $group_id,
    //             'updated_at' => $now_time,
    //             'created_at' => $now_time,
    //         ];
    //     }
    //     $save = $this->platform_db->table('group_server')->addAll($data_gs);

    //     if ($save) {
    //         $status = ['status'=>1,'message'=>'修改成功~'];
    //     }else{
    //         $status = ['status'=>0,'message'=>'修改失败'];
    //     }
    //     $this->ajaxReturn($status);
    // }

}
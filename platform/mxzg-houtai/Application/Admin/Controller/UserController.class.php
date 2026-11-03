<?php
namespace Admin\Controller;

use Think\Controller;

/*
 * 账号信息管理
 */
class UserController extends PublicController{

    protected $data_db;
    /*搜索*/
    public function index(){
        //记录搜索条件
        $now_date = date('Y-m-d');
        $id = I('id', '');
        $open_id = I('open_id', '');
        $c_son_id = I('c_son_id', '');
        $uuid = I('uuid', '');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);

        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        $channelss = M('channel')->select();
        $channels_re = [];
        foreach($channelss as $channels_val){
            $channels_re[$channels_val['id']] = $channels_val;
        }
        
        //组建搜索条件的值
        $search_params = [
            'id' => $id,
            'open_id' => $open_id,
            'c_son_id' => $c_son_id,
            'uuid' => $uuid,
            'start_time' => $start_time,
            'end_time' => $end_time,
        ];

        $where = "1 ";
        if(!empty($id)){
            $where .= "and user.id='$id' ";
        }
        if(!empty($open_id)){
            $where .= "and user.open_id='$open_id' ";
        }
        if(!empty($c_son_id)){
            $where .= "and user.c_son_id='$c_son_id' ";
        }
        if(!empty($uuid)){
            $where .= "and user.uuid like '%{$uuid}%' ";
        }
        if(!empty($start_time)){
            $where .= "and user.created_at>=" . strtotime($start_time) . " ";
        }
        if(!empty($end_time)){
            $where .= "and user.created_at<=" . strtotime($end_time . ' 23:59:59') . " ";
        }

        $count = $this->platform_db->table('user')
            ->join("left join server on server.id=user.last_login_sid")
            ->where($where)
            ->count("user.id");
        $Page  = new \Think\Page($count, 40);
        $list = $this->platform_db->table('user')
            ->field("user.*,server.server_name")
            ->join("left join server on server.id=user.last_login_sid")
            ->where($where)
            ->order("user.id desc")
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        foreach($list as &$val){
            //获取渠道名称
            if(isset($channels_re[$val['c_son_id']])){
                $val['channel_name'] = $channels_re[$val['c_son_id']]['name'];
                $val['parent_name'] = $channels_re[$channels_re[$val['c_son_id']]['parent_id']]['name'];
            }else{
                $val['channel_name'] = '';
                $val['parent_name'] = '';
            }
        }
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'channels' => $channels, 'search_params' => $search_params]);
        $this->display();
    }

    /*搜索*/
    public function export(){
        ini_set('memory_limit','256M'); //临时提高内存

        //记录搜索条件
        $now_date = date('Y-m-d');
        $id = I('id', '');
        $open_id = I('open_id', '');
        $c_son_id = I('c_son_id', '');
        $uuid = I('uuid', '');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', $now_date);

        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        $channelss = M('channel')->select();
        $channels_re = [];
        foreach($channelss as $channels_val){
            $channels_re[$channels_val['id']] = $channels_val;
        }

        $where = "1 ";
        if(!empty($id)){
            $where .= "and user.id='$id' ";
        }
        if(!empty($open_id)){
            $where .= "and user.open_id='$open_id' ";
        }
        if(!empty($c_son_id)){
            $where .= "and user.c_son_id='$c_son_id' ";
        }
        if(!empty($uuid)){
            $where .= "and user.uuid like '%{$uuid}%' ";
        }
        if(!empty($start_time)){
            $where .= "and user.created_at>=" . strtotime($start_time) . " ";
        }
        if(!empty($end_time)){
            $where .= "and user.created_at<=" . strtotime($end_time . ' 23:59:59') . " ";
        }

        $list = $this->platform_db->table('user')
            ->field("user.*,server.server_name")
            ->join("left join server on server.id=user.last_login_sid")
            ->where($where)
            ->order("user.id desc")
            ->limit(30000)       //限制导出数量
            ->select();

        foreach($list as &$val){
            //获取渠道名称
            if(isset($channels_re[$val['c_son_id']])){
                $val['channel_name'] = $channels_re[$val['c_son_id']]['name'];
                $val['parent_name'] = $channels_re[$channels_re[$val['c_son_id']]['parent_id']]['name'];
            }else{
                $val['channel_name'] = '';
                $val['parent_name'] = '';
            }
        }

        vendor('PHPExcel.PHPExcel');
        vendor('PHPExcel.PHPExcel.Writer.Excel5');
        Vendor("PHPExcel.PHPExcel.IOFactory");
        $excel = new \PHPExcel();
        //Excel表格式,这里简略写了8列
        $letter = array('A','B','C','D','E','F','G');
        //表头数组
        $tableheader = array('账号id','渠道uid','渠道','最后登录的区服','最后登陆时间','登录天数','创建时间');
        //填充表头信息
        for($i = 0;$i < count($tableheader);$i++) {
            $excel->getActiveSheet()->setCellValue("$letter[$i]1","$tableheader[$i]");
        }
        $excel->getActiveSheet()->getDefaultColumnDimension()->setWidth(20);//所有单元格（列）默认宽度
        //填充表格信息
        for ($i = 2;$i <= count($list) + 1;$i++) {
            $excel->getActiveSheet()->setCellValue("A$i", $list[$i - 2]['id']);
            $excel->getActiveSheet()->setCellValue("B$i", $list[$i - 2]['open_id']);
            $excel->getActiveSheet()->setCellValue("C$i", $list[$i - 2]['channel_name'] . '（' . $list[$i - 2]['parent_name'] . "）");
            $excel->getActiveSheet()->setCellValue("D$i", $list[$i - 2]['server_name'] . '（' . $list[$i - 2]['last_login_sid'] . "）");
            $excel->getActiveSheet()->setCellValue("E$i", date('Y-m-d H:i:s',$list[$i - 2]['last_login_time']));
            $excel->getActiveSheet()->setCellValue("F$i", $list[$i - 2]['login_days']);
            $excel->getActiveSheet()->setCellValue("G$i", date('Y-m-d H:i:s',$list[$i - 2]['created_at']));
        }

        //创建Excel输入对象
        ob_clean();
        $write = new \PHPExcel_Writer_Excel5($excel);
        header("Pragma: public");
        header("Expires: 0");
        $filename="user_list.xls";
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
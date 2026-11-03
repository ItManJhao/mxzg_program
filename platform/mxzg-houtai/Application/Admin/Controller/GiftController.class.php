<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 礼包的配置管理
 */
class GiftController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $name = I('name', '');
        $type = I('type', '-1');
        $device_type = I('device_type', 0);

        $where = "1 ";
        if(!empty($name)){
            $where .= "and name like '%{$name}%' ";
        }
        if($type != -1){
            $where .= "and type=$type ";
        }
        if($device_type == 0){
            $where .= "and device_type in(0,1,2) ";
        }else{
            $where .= "and device_type in(0,$device_type) ";
        }

        $count = M('gift')->count();
        $Page  = new \Think\Page($count,20);
        $list = M('gift')
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->order("id desc")
            ->select();

        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        $search_params = [
            'name' => $name,
            'type' => $type,
            'device_type' => $device_type,
        ];
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'channels' => $channels, 'search_params' => $search_params]);
        $this->display();
    }

    public function add(){
        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        //获取所有的服务器
        $server_list = M('server')->select();
        $server_list = array_chunk($server_list, 50);
        //获取所有的礼包道具
        $item_list = M('gift_item')->where("type!=7")->select();
        $this->assign(['channels' => $channels, 'server_list' => $server_list, 'item_data' => $item_list]);
        $this->display();
    }

    public function edit(){
        $id = I('id', 0);
        $gift_info = M('gift')->where('id = '.$id.'')->find();
        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        //获取所有的服务器
        $server_list = M('server')->select();
        $server_list = array_chunk($server_list, 50);
        //获取所有的礼包道具
        $item_list = M('gift_item')->where("type!=7")->select();

        if(isset($gift_info['c_son_id']) && !empty($gift_info['c_son_id'])){
            $gift_info['c_son_id'] = explode(',', $gift_info['c_son_id']);
        }
        if(isset($gift_info['sid']) && !empty($gift_info['sid'])){
            $gift_info['sid'] = explode(',', $gift_info['sid']);
        }

        //处理道具数据
        if(isset($gift_info['gift_item']) && !empty($gift_info['gift_item'])){
            $gift_item_data = json_decode($gift_info['gift_item'], true);
            foreach($gift_item_data as &$gift_item_val){
                $gift_item_val['item_data'] = $item_data[$gift_item_val['item_type_type']];
            }
        }
        //是否适用所有服务器
        $gift_info['is_all_server'] = 0;
        if(in_array('-1', $gift_info['sid'])){
            $gift_info['is_all_server'] = 1;
        }
        $this->assign(['gift_info' => $gift_info, 'channels' => $channels, 'server_list' => $server_list, 'item_data' => $item_list, 'gift_item_data' => $gift_item_data]);
        $this->display();
    }

    /*上传道具*/
    public function item(){
        $this->display();
    }
    /*上传道具*/
    public function ajax_item(){
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
            // $columnCount = 'Q';

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
            if(isset($this->item_desc[$excel_val['type']])){
                $insert_data[] = [
                    'id' => $excel_val['idx'],
                    'name' => $excel_val['note'],
                    'type' => $excel_val['type'],
                    'type_name' => $this->item_desc[$excel_val['type']],
                    'type_label' => $excel_val['place'],
                    'quality' => $excel_val['rare_mark'],
                    'star' => $excel_val['star'],
                    'created_at' => $now_time,
                ];
            }
            
        }
        $save = M('gift_item')->addAll($insert_data,[],true);
        if ($save) {
            $status = ['status'=>1,'message'=>'上传道具成功~'];
        }else{
            $status = ['status'=>0,'message'=>'上传道具失败'];
        }
        $this->ajaxReturn($status);
    }

    /*添加*/
    public function ajax_add(){
        ini_set('memory_limit','512M');
        $params = I('post.');
        if(empty($params['c_son_ids'])){
            $status = ['status'=>0,'message'=>'请选择渠道'];
            $this->ajaxReturn($status);
        }else{
            $c_son_id = implode(',', $params['c_son_ids']);
        }
        if($params['type'] == 'all'){
            $status = ['status'=>0,'message'=>'请选择礼包类型'];
            $this->ajaxReturn($status);
        }
        //获取礼包数据
        $gift_info = M('gift')->where("name='" . $params['name'] . "'")->find();
        if($gift_info){
            $status = ['status'=>0,'message'=>'礼包名称已经存在'];
            $this->ajaxReturn($status);
        }

        $now_time = time();
        if($params['server_ids']){
            if($params['is_all_server'] == 1){
                $sid = '-1,' . implode(',', $params['server_ids']);
            }else{
                $sid = implode(',', $params['server_ids']);
            }
        }else{
            $sid = '';
        }

        $gift_item_arr = [];
        foreach($params['item_type'] as $item_key=>$item_val){
            $gift_item_arr[] = [
                'item_type' => $item_val,
                'item_num' => $params['gift_item_num'][$item_key]
            ];
        }
        $gift_item = json_encode($gift_item_arr);

        //如果是通码则只生成一个
        if($params['type'] == 1){   //通码
            $num = 1;
            $use_num = 0;
        }elseif($params['type'] == 2){  //固定码
            if(empty($params['set_code'])){
                $status = ['status'=>0,'message'=>'请填写固定码'];
                $this->ajaxReturn($status);
            }
            $num = 1;
            $set_code = $params['set_code'];
            //判断固定码是否重复
            $gift_info = M('gift_code')->where("code='" . $set_code . "'")->find();
            if($gift_info){
                $status = ['status'=>0,'message'=>'固定码已经存在'];
                $this->ajaxReturn($status);
            }
            $use_num = 0;
        }elseif($params['type'] == 0){  //普通码
            $num = $params['num'];
            if(empty($num)){
                $status = ['status'=>0,'message'=>'普通码请输入礼包数量'];
                $this->ajaxReturn($status);
            }
            if($num >50000){
                $status = ['status'=>0,'message'=>'普通码礼包数量不能超过50000'];
                $this->ajaxReturn($status);
            }
            $use_num = $params['use_num'];
        }

//        $vip = '';
//        $level = '';
//        if(!empty($params['vip'][0])){
//            $vip = implode('-', $params['vip']);
//        }
//        if(!empty($params['level'][0])){
//            $level = implode('-', $params['level']);
//        }
        $data = [
            'name' => $params['name'],
            'note' => $params['note'],
            'type' => $params['type'],
            'num' => $num,
            'use_num' => $use_num,
            'gift_item' => $gift_item,
            'device_type' => $params['device_type'],
            'sid' => $sid,
            'c_son_id' => $c_son_id,
//            'vip' => $vip,
//            'level' => $level,
            'status' => $params['status'],
            'start_time' => strtotime($params['start_time']),
            'end_time' => strtotime($params['end_time']),
            'updated_at' => $now_time,
            'created_at' => $now_time,
        ];
        if($params['type'] == 2){
            $data['code'] = $set_code;
        }
        $gift_id = M('gift')->add($data);
        if ($gift_id) {
            //添加成功则生成对应数量的兑换码
            if($num > 0){
                //分批次写入数据库，每次最多5000条
                $mysql_nums = floor($num/5000);
                $add_num_arrs = [];
                for($i=0; $i<$mysql_nums; $i++){
                    $add_num_arrs[] = 5000;
                }
                $mysql_remainder = $num%5000;
                array_push($add_num_arrs, $mysql_remainder);
                foreach($add_num_arrs as $add_num_arrs_val){
                    $data_code = [];
                    if(isset($set_code)){
                        $data_code[] = [
                            'code' => $set_code,
                            'gift_id' => $gift_id,
                            'gift_name' => $params['name'],
                            'created_at' => $now_time,
                        ];
                    }else{
                        $data_code = $this->checkCode($gift_id,'',$params['name'],$add_num_arrs_val);
                    }
                    
                    $res = M('gift_code')->addAll($data_code);
                }
                
            }
            $status = ['status'=>1,'message'=>'添加成功~'];

        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }

        $this->ajaxReturn($status);
    }

    /*更新*/
    public function ajax_updata(){
        $params = I('post.');
        if(empty($params['c_son_ids'])){
            $status = ['status'=>0,'message'=>'请选择渠道'];
            $this->ajaxReturn($status);
        }else{
            $c_son_id = implode(',', $params['c_son_ids']);
        }
        if($params['type'] == 'all'){
            $status = ['status'=>0,'message'=>'请选择礼包类型'];
            $this->ajaxReturn($status);
        }

        
        if($params['server_ids']){
            if($params['is_all_server'] == 1){
                $sid = '-1,' . implode(',', $params['server_ids']);
            }else{
                $sid = implode(',', $params['server_ids']);
            }
        }else{
            $sid = '';
        }

        $gift_item_arr = [];
        foreach($params['item_type'] as $item_key=>$item_val){
            $gift_item_arr[] = [
                'item_type' => $item_val,
                'item_num' => $params['gift_item_num'][$item_key]
            ];
        }
        $gift_item = json_encode($gift_item_arr);

        $now_time = time();
        $data = [
            'name' => $params['name'],
            'note' => $params['note'],
//            'type' => $params['type'],
//            'num' => $params['num'],
            'use_num' => $params['use_num'],
            'gift_item' => $gift_item,
            'device_type' => $params['device_type'],
            'sid' => $sid,
            'c_son_id' => $c_son_id,
//            'vip' => implode('-', $params['vip']),
//            'level' => implode('-', $params['level']),
            'status' => $params['status'],
            'start_time' => strtotime($params['start_time']),
            'end_time' => strtotime($params['end_time']),
            'updated_at' => $now_time,
        ];
        $save = M('gift')->where("id=" . $params['id'])->save($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'修改失败'];
        }
        $this->ajaxReturn($status);
    }

    public function code()
    {
        $gift_id = I('gift_id', 0);
        $role_id = I('role_id', '');

        $where = "1 ";
        if(!empty($gift_id)){
            $where .= "and gc.gift_id=$gift_id ";
        }
        if(!empty($role_id)){
            $where .= "and gc.role_id=$role_id ";
        }

        $count = $this->platform_db->table('gift_code')->alias('gc')
            ->join("left join user_server as us on us.role_id=gc.role_id")
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,20);
        $gift_code = $this->platform_db->table('gift_code')
            ->alias('gc')
            ->field('gc.*,us.role_name')
            ->join("left join user_server as us on us.role_id=gc.role_id")
            ->where($where)
            ->order("use_time desc")
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
            $search_params = [
                'gift_id' => $gift_id,
                'role_id' => $role_id,
            ];
        $this->assign(['gift_code' => $gift_code, 'page'=>$Page->show(),'count'=>$count, 'search_params' => $search_params]);
        $this->display();
    }

    //导出兑换码
    public function exportcode(){
        $gift_id = I('get.gift_id', 0);
        $mark = I('get.mark', '');

        if(empty($gift_id)){
            echo "参数错误，请返回重试";
            exit;
        }
        $where ="gc.gift_id=$gift_id ";
        if(!empty($mark)){
            $where .= " and gc.mark='$mark'";
        }
        //表格数组
        $gift_code_data = M('gift_code')
            ->alias('gc')
            ->field("gc.code,concat_ws('--',gc.role_id,us.role_name) as role_info,gcl.created_at as use_time,gc.mark")
            ->join("left join user_server as us on us.role_id=gc.role_id")
            ->join("left join gift_code_log as gcl on gcl.code=gc.code")
            ->where($where)
            ->order("use_time desc")
            ->select();

        vendor('PHPExcel.PHPExcel');
        vendor('PHPExcel.PHPExcel.Writer.Excel5');
        Vendor("PHPExcel.PHPExcel.IOFactory");
        $excel = new \PHPExcel();
        //Excel表格式,这里简略写了8列
        $letter = array('A','B','C','D');
        //表头数组
        $tableheader = array('激活码','使用角色','使用时间','追加标识');
        //填充表头信息
        for($i = 0;$i < count($tableheader);$i++) {
            $excel->getActiveSheet()->setCellValue("$letter[$i]1","$tableheader[$i]");
        }
//        $excel->getActiveSheet()->getColumnDimension('A')->setWidth(10);
        $excel->getActiveSheet()->getDefaultColumnDimension()->setWidth(20);//所有单元格（列）默认宽度
        //填充表格信息
        for ($i = 2;$i <= count($gift_code_data) + 1;$i++) {
            $j = 0;
            foreach ($gift_code_data[$i - 2] as $key=>$value) {
                if($key == 'use_time'){
                    $value = date('Y-m-d H:i:s',$value);
                }
                $excel->getActiveSheet()->setCellValue("$letter[$j]$i","$value");
                $j++;
            }
        }

        //创建Excel输入对象
        ob_clean();
        $write = new \PHPExcel_Writer_Excel5($excel);
        header("Pragma: public");
        header("Expires: 0");
        $filename="gift_code.xls";
        header("Content-Disposition: attachment;filename=$filename");
        header("Cache-Control:must-revalidate, post-check=0, pre-check=0");
        header("Content-Type:application/force-download");
        header("Content-Type:application/vnd.ms-execl");
        header("Content-Type:application/octet-stream");
        header("Content-Type:application/download");
        header("Content-Transfer-Encoding:binary");
        $write->save('php://output');
    }


    /*追加兑换码*/
    public function addcode(){
        $gift_id = I('gift_id', 0);
        $this->assign(['gift_id' => $gift_id]);
        $this->display();
    }
    /*追加兑换码*/
    public function ajax_add_code(){
        ini_set('memory_limit','512M');
        $params = I('post.');

        if(empty($params['gift_id'])){
            $status = ['status'=>0,'message'=>'参数出错，请返回重试'];
            $this->ajaxReturn($status);
        }
        //获取礼包数据
        $gift_info = $this->platform_db->table('gift')->where('id=' . $params['gift_id'])->find();
        if(!$gift_info){
            $status = ['status'=>0,'message'=>'参数出错，请返回重试'];
            $this->ajaxReturn($status);
        }
        if(in_array($gift_info['type'], [1,2])){
            $status = ['status'=>0,'message'=>'只有普通码才能追加'];
            $this->ajaxReturn($status);
        }
        if(empty($params['mark'])){
            $status = ['status'=>0,'message'=>'请输入追加标识'];
            $this->ajaxReturn($status);
        }
        $add_nums = $params['add_num'];
        if(empty($add_nums)){
            $status = ['status'=>0,'message'=>'请输入追加数量'];
            $this->ajaxReturn($status);
        }
        if($params['add_num'] > 200000){
            $status = ['status'=>0,'message'=>'追加数量一次不能超10000'];
            $this->ajaxReturn($status);
        }
        //获取所有兑换码
        // $code_arr = $this->platform_db->table('gift_code')->getField('code',true);
        //分批次写入数据库，每次最多5000条
        $mysql_nums = floor($add_nums/5000);
        $add_num_arrs = [];
        for($i=0; $i<$mysql_nums; $i++){
            $add_num_arrs[] = 5000;
        }
        $mysql_remainder = $add_nums%5000;
        array_push($add_num_arrs, $mysql_remainder);
        //添加成功则生成对应数量的兑换码
        $gift_nums = 0;
        foreach($add_num_arrs as $add_num_arrs_val){
            $data_code = $this->checkCode($params['gift_id'],$params['mark'],$gift_info['name'],$add_num_arrs_val);
            $res = $this->platform_db->table('gift_code')->addAll($data_code);
            if($res){
                $gift_nums += $add_num_arrs_val;
            }
        }
        
        //修改礼包表的数量
        if($gift_nums > 0){
            $result = $this->platform_db->table('gift')->where('id=' . $params['gift_id'])->setInc('num', $gift_nums);
        }
        $status = ['status'=>1,'message'=>'追加成功~'];
        $this->ajaxReturn($status);
    }
    //验证兑换码是否存在数据库
    private function checkCode($gift_id,$mark,$name,$add_num_arrs_val){
        $code_arr = [];
        $data_code = [];
        $now_time = time();
        for($i=0; $i<$add_num_arrs_val; $i++){
            $code = $this->getCode($code_arr);
            array_push($code_arr, $code);
            $data_code[] = [
                'code' => $code,
                'gift_id' => $gift_id,
                'mark' => $mark,
                'gift_name' => $name,
                'created_at' => $now_time,
            ];
        }
        $code_str = implode(',', $code_arr);
        //判断生成的兑换码是否已经存在
        $gift_code_info = $this->platform_db->table('gift_code')->where(['code' => ['in', $code_str]])->find();
        if($gift_code_info){
            $data_code = $this->checkCode($gift_id,$mark,$name,$add_num_arrs_val);
        }
        return $data_code;
    }
    //递归获取唯一兑换码
    private function getCode($code_arr){
        $code = getOnlyCode(8);
        if(in_array($code, $code_arr)){
            $code = $this->getCode($code_arr);
        }
        return $code;
    }

    /*上传流失事件*/
    public function gameevent(){
        $this->display();
    }
    /*上传流失事件*/
    public function ajax_gameevent(){
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
//            $columnCount = $excel_read->getActiveSheet()->getHighestColumn();
            $columnCount = 'B';

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
                'name' => $excel_val['remark'],
                'created_at' => $now_time,
            ];
        }
        $save = M('game_event')->addAll($insert_data,[],true);
        if ($save) {
            $status = ['status'=>1,'message'=>'上传流水事件成功~'];
        }else{
            $status = ['status'=>0,'message'=>'上传流水事件失败'];
        }
        $this->ajaxReturn($status);
    }

    /*上传英雄*/
    public function hero(){
        $this->display();
    }
    /*上传英雄*/
    public function ajax_hero(){
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
//            $columnCount = $excel_read->getActiveSheet()->getHighestColumn();
            $columnCount = 'D';

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
                'id' => $excel_val['type'],
                'name' => $excel_val['note'],
                'elem' => $excel_val['elem'],
                'occupation' => $excel_val['occupation'],
                'created_at' => $now_time,
            ];
        }
        $save = M('hero')->addAll($insert_data,[],true);
        if ($save) {
            $status = ['status'=>1,'message'=>'上传英雄成功~'];
        }else{
            $status = ['status'=>0,'message'=>'上传英雄失败'];
        }
        $this->ajaxReturn($status);
    }
}
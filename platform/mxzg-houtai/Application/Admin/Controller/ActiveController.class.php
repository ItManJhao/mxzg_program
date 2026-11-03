<?php
namespace Admin\Controller;
use Think\Controller;
use Think\Db;

/*
 * 活动的配置管理
 */
class ActiveController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $id = I('id', '');
        $type_id = I('type_id', '');
        $name = I('name', '');
        $status = I('status', '0');
        $time_now = time();

        $where = "1 ";
        $where .= "and ba.status=1 ";
        if(!empty($id)){
            $where .= "and ba.id=$id ";
        }
        if(!empty($type_id)){
            $where .= "and ba.type_id=$type_id ";
        }
        if(!empty($name)){
            $where .= "and ba.name like '%{$name}%' ";
        }

        if($status == 1){
            $where .= "and ba.server_ids='' ";
        }elseif($status == 2){
            $where .= "and ba.start_time>$time_now ";
        }elseif($status == 3){
            $where .= "and ba.start_time<=$time_now and ba.end_time>=$time_now ";
        }elseif($status == 4){
            $where .= "and ba.end_time<$time_now and ba.clear_time>$time_now ";
        }elseif($status == 5){
            $where .= "and ba.clear_time<=$time_now ";
        }

        //获取活动类型数据
        $active_type = M('bms_active_type')
            ->alias('bat')
            ->select();

        $count = M('bms_active')
            ->alias('ba')
            ->join("left join bms_active_type as bat on bat.id=ba.type_id")
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,50);
        $list = M('bms_active')
            ->alias('ba')
            ->field('ba.*,bat.name as type_name')
            ->join("left join bms_active_type as bat on bat.id=ba.type_id")
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->order('ba.id desc')
            ->select();
        foreach($list as &$active_val){
            if(empty($active_val['server_ids'])){
                $active_val['status_name'] = '未发送服务器';
            }elseif($time_now < $active_val['start_time']){
                $active_val['status_name'] = '未开始';
            }elseif($time_now >= $active_val['start_time'] && $time_now < $active_val['end_time']){
                $active_val['status_name'] = '正在进行';
            }elseif($time_now >= $active_val['end_time'] && $time_now < $active_val['clear_time']){
                $active_val['status_name'] = '结束，未清除';
            }elseif($time_now >= $active_val['clear_time']){
                $active_val['status_name'] = '已清除';
            }else{
                $active_val['status_name'] = '未知';
            }
        }
        $show = $Page->show();
        $search_params = [
            'id' => $id,
            'name' => $name,
            'type_id' => $type_id,
            'status' => $status,
        ];
        $this->assign(['list'=>$list,'count'=>$count,'page'=>$show,'active_type' => $active_type, 'search_params' => $search_params]);
        $this->display();
    }


    public function add(){
//        $cate = $this->listMenu();
        //获取活动类型数据
        $active_type = M('bms_active_type')
            ->alias('bat')
            ->select();
        $this->assign(['active_type' => $active_type]);
        $this->display();
    }

    public function edit(){
        ini_set('memory_limit','512M');
        $id = I('id', 0);
        //获取活动类型数据
        $active_type = M('bms_active_type')
            ->alias('bat')
            ->select();
        //获取活动数据
        $active_info = M('bms_active')->where('id = '.$id.'')->find();
        //获取活动数据，解析活动数据excel文件
        $excel_data = array();
        if( $active_info && $active_info['data_file'] && file_exists(LSS . '/Uploads/Excel/' . $active_info["data_file"]) ){
            $data_file = LSS . '/Uploads/Excel/' . $active_info['data_file'];
            $excel_read = getPHPExcelRead($data_file);
            //获取表格行数
            $rowCount = $excel_read->getActiveSheet()->getHighestRow();
            //获取表格列数
            $columnCount = $excel_read->getActiveSheet()->getHighestColumn();

            /* 循环读取每个单元格的数据 */
            //行数循环
            for ($row = 1; $row <= $rowCount; $row++) {
//                echo $row . PHP_EOL;
                //列数循环 , 列数是以A列开始
                for ($column = 'A'; $column <= $columnCount; $column++) {
                    $cell_val = $excel_read->getActiveSheet()->getCell($column . $row)->getValue();
                    if(is_object($cell_val)){
                        $cell_val = $cell_val->__toString();
                    }
                    $excel_data[$row - 1][] = $cell_val;
                }
            }
        }

        $this->assign(['active_info'=>$active_info, 'active_type' => $active_type, 'excel_data' => $excel_data]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        ini_set('memory_limit','512M');
        $params = I('post.');
        if(empty($params['name'])){
            $status = ['status'=>0,'message'=>'活动名称不能为空'];
            $this->ajaxReturn($status);
        }
        $now_time = time();
        $data = [
            'name' => $params['name'],
            'type_id' => $params['type_id'],
            'desc' => $params['desc'],
            'data_file' => $params['data_file'],
            'updated_at' => $now_time,
            'created_at' => $now_time,
        ];
        $id = $this->platform_db->table('bms_active')->add($data);
        if ($id) {
            //修改文件名字拼接上活动id，作唯一处理
            $this->platform_db->table('bms_active')->save(['data_file' => $params['data_file']]);
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }
        $this->ajaxReturn($status);
    }

    /*修改*/
    public function ajax_updata(){
        ini_set('memory_limit','512M');
        $params = I('post.');
        if(empty($params['name'])){
            $status = ['status'=>0,'message'=>'活动名称不能为空'];
            $this->ajaxReturn($status);
        }
        $id = $params['id'];
        $now_time = time();
        $data = [
            'name' => $params['name'],
            'type_id' => $params['type_id'],
            'desc' => $params['desc'],
            'updated_at' => $now_time,
        ];
        if(!empty($params['data_file'])){
            //修改文件名字拼接上活动id，作唯一处理
            $data['data_file'] = $params['data_file'];
        }
        $save = M('bms_active')->where("id=" . $id)->save($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'修改失败'];
        }
        $this->ajaxReturn($status);
    }

    /*删除活动*/
    public function ajax_delete(){
        $id = I('id', 0);
        $time_now = time();
        $active_info = $this->platform_db->table('bms_active')->where("id=$id")->find();
        if(!$active_info){
            $status = ['status'=>0,'message'=>'参数错误，请返回重试'];
            $this->ajaxReturn($status);
        }
        if(empty($active_info['server_ids']) || $time_now < $active_info['start_time'] || $time_now < $active_info['clear_time']){
            $status = ['status'=>0,'message'=>'只有已清除才能删除'];
            $this->ajaxReturn($status);
        }
        
        $data = [
            'status' => 0,
            'updated_at' => $time_now,
        ];
        $res = $this->platform_db->table('bms_active')->where("id=$id")->save($data);
        if ($res) {
            $status = ['status'=>1,'message'=>'删除成功~'];
        }else{
            $status = ['status'=>0,'message'=>'删除失败'];
        }
        $this->ajaxReturn($status);
    }

    /*活动发送服务器*/
    public function server(){
        ini_set('memory_limit','512M');
        $id = I('id', 0);
        //获取活动类型数据
        $active_type = M('bms_active_type')
            ->alias('bat')
            ->select();
        //获取活动数据
        $active_info = M('bms_active')->where('id = '.$id.'')->find();
        //获取活动数据，解析活动数据excel文件
        $excel_data = array();
        if( $active_info && $active_info['data_file'] && file_exists(LSS . '/Uploads/Excel/' . $active_info["data_file"]) ){
            $data_file = LSS . '/Uploads/Excel/' . $active_info['data_file'];
            $excel_read = getPHPExcelRead($data_file);
            //获取表格行数
            $rowCount = $excel_read->getActiveSheet()->getHighestRow();
            //获取表格列数
            $columnCount = $excel_read->getActiveSheet()->getHighestColumn();

            /* 循环读取每个单元格的数据 */
            //行数循环
            for ($row = 1; $row <= $rowCount; $row++) {
//                echo $row . PHP_EOL;
                //列数循环 , 列数是以A列开始
                for ($column = 'A'; $column <= $columnCount; $column++) {
                    $cell_val = $excel_read->getActiveSheet()->getCell($column . $row)->getValue();
                    if(is_object($cell_val)){
                        $cell_val = $cell_val->__toString();
                    }
                    $excel_data[$row - 1][] = $cell_val;
                }
            }
        }

        //获取服务器信息
        $server_list = M('server')
            ->field('*')
            ->select();
        $server_list = array_chunk($server_list, 50);
        if(isset($active_info['server_ids']) && !empty($active_info['server_ids'])){
            $active_info['server_ids'] = explode(',', $active_info['server_ids']);
        }
        $this->assign(['active_info'=>$active_info, 'active_type' => $active_type, 'excel_data' => $excel_data, 'server_list' => $server_list]);
        $this->display();
    }

    /*活动发送服务器ajax*/
    public function ajax_server(){
        ini_set('memory_limit','512M');
        $params = I('post.');
        $server_ids = implode(',', $params['server_ids']);

        $id = $params['id'];
        if (empty($id)) {
            $status = ['status'=>1,'message'=>'参数出错，请返回重试1'];
            $this->ajaxReturn($status);
        }
        if (!$params['type_id']) {
            $status = ['status'=>1,'message'=>'参数出错，请返回重试2'];
            $this->ajaxReturn($status);
        }
        if (!$params['start_time']) {
            $status = ['status'=>1,'message'=>'参数出错，请返回重试3'];
            $this->ajaxReturn($status);
        }
        if (!$params['end_time']) {
            $status = ['status'=>1,'message'=>'参数出错，请返回重试4'];
            $this->ajaxReturn($status);
        }
        if (!$params['clear_time']) {
            $status = ['status'=>1,'message'=>'参数出错，请返回重试5'];
            $this->ajaxReturn($status);
        }
        if (strtotime($params['end_time']) <= strtotime($params['start_time'])){
            $status = ['status'=>1,'message'=>'结束时间不能小于开始时间'];
            $this->ajaxReturn($status);
        }
        if (strtotime($params['clear_time']) < strtotime($params['end_time'])){
            $status = ['status'=>1,'message'=>'清除时间不能小于结束时间'];
            $this->ajaxReturn($status);
        }
        if (empty($server_ids)){
            $status = ['status'=>1,'message'=>'请选择服务器'];
            $this->ajaxReturn($status);
        }
        $now_time = time();
        $data = [
            'server_ids' => $server_ids,
            'name' => $params['name'],
            'start_time' => strtotime($params['start_time']),
            'end_time' => strtotime($params['end_time']),
            'clear_time' => strtotime($params['clear_time']),
            'limit_days' => $params['limit_days'],
            'type_id' => $params['type_id'],
            'desc' => $params['desc'],
            'updated_at' => $now_time,
        ];
        $save = M('bms_active')->where("id=" . $id)->save($data);
        if ($save) {
            //处理发送服务器
            //获取活动数据，解析活动数据excel文件
            $excel_data = array();
            if( $params['data_file'] && file_exists(LSS . '/Uploads/Excel/' . $params["data_file"]) ){
                $data_file = LSS . '/Uploads/Excel/' . $params['data_file'];
                $excel_read = getPHPExcelRead($data_file);
                //获取表格行数
                $rowCount = $excel_read->getActiveSheet()->getHighestRow();
                //获取表格列数
                $columnCount = $excel_read->getActiveSheet()->getHighestColumn();

                /* 循环读取每个单元格的数据 */
                //行数循环
                //获取数据的key
                $fixed_row = 3;
                for ($column = 'A'; $column <= $columnCount; $column++) {
                    $data_key_arr[$column] = $excel_read->getActiveSheet()->getCell($column . $fixed_row)->getValue();
                }
//                var_dump($data_key_arr);exit;
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
            //获取要发送的服务器信息
            $server_list = M('server')
                    ->field('*')
                    ->where("id in (" . $server_ids . ")")
                    ->select();
            //记录发送失败的服务器
            $error_msg = '';
            foreach($server_list as $server_val){
                $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'] . C("ACTIVE_SEND_SERVER_URL");
                $send_data = [
                    'id' => $id,
                    'stime' => strtotime($params['start_time']),
                    'etime' => strtotime($params['end_time']),
                    'ctime' => strtotime($params['clear_time']),
                    'limit_days' => $params['limit_days'],
                    'type_id' => $params['type_id'],
                    'data' => $excel_data,
                ];

                $result = curlRequest($send_url, $request_type = 'post', ['data' => json_encode($send_data)]);
                $result_arr = json_decode($result, true);
                if(!$result_arr){
                    $status = 0;
                    $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '发送失败，原因：连接失败；';
                }else{
                    if(!$result_arr['code']){
                        $status = 0;
                        $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '发送失败，原因：' . $result_arr['msg'] . '；';
                    }else{
                        $status = $result_arr['code'];
                        if($status != 200){
                            $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '发送失败，原因：' . $result_arr['msg'] . '；';
                        }
                    }
                }
                //存储发送活动服务器的结果信息
                $data = [
                    'active_id' => $id,
                    'active_name' => $params['name'],
                    'active_type_id' => $params['type_id'],
                    'start_time' => strtotime($params['start_time']),
                    'end_time' => strtotime($params['end_time']),
                    'clear_time' => strtotime($params['clear_time']),
                    'server_id' => $server_val['id'],
                    'content' => json_encode($excel_data),
                    'debug' => $result,
                    'status' => $status,
                    'admin_id' => session('admin_user_id'),
                    'created_at' => $now_time,
                ];
                $save = M('send_active_server')->add($data);
            }
            if(!empty($error_msg)){
                $status = ['status'=>0,'message'=>$error_msg];
            }else{
                $status = ['status'=>1,'message'=>'发送服务器成功~'];
            }
        }else{
            $status = ['status'=>0,'message'=>'发送失败'];
        }
        $this->ajaxReturn($status);
    }

    //发送服务器日志
    public function send_server_log()
    {
        $active_id = I('active_id', 0);
        $count = M('send_active_server')
            ->where("active_id=$active_id")
            ->count();
        $Page  = new \Think\Page($count,20);
        $send_active_server = M('send_active_server')
            ->alias('sas')
            ->field('sas.*,server.server_name,bms_users.belongs_to as admin_name')
            ->join("left join server on server.id=sas.server_id")
            ->join("left join bms_users on bms_users.id=sas.admin_id")
            ->where("sas.active_id=$active_id")
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        $this->assign(['send_active_server' => $send_active_server, 'page'=>$Page->show(),'count'=>$count]);
        $this->display();
    }

    /*文件上传*/
    public function excel_upload()
    {
        //接收前台文件
        $file_data = $_FILES['file'];
        $file_name_prefix = I('file_name_prefix', '');
        if(!empty($file_name_prefix)){
            $res = move_uploaded_file($file_data["tmp_name"],LSS . '/Uploads/Excel/' . $file_name_prefix . '_' . $file_data["name"]);
        }else{
            $res = move_uploaded_file($file_data["tmp_name"],LSS . '/Uploads/Excel/' . $file_data["name"]);
        }

        if($res){
            $status = ['status'=>1,'message'=>'文件上传成功'];
        }else{
            $status = ['status'=>0,'message'=>'文件上传失败'];
        }
        $this->ajaxReturn($status);
    }

}
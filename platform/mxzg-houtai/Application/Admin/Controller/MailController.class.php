<?php
namespace Admin\Controller;
use Think\Controller;

/**
 * Class MailController
 * @package Admin\Controller
 * @desc 邮件管理
 */
class MailController extends PublicController{

    public function index(){
        //记录搜索条件
        $title = I('title', '');
        $role_id = I('role_id', '');
        $status = I('status', '-1');
        $oprate_type = I('oprate_type', '-1');

        $where = "1 ";
        if(!empty($title)){
            $where .= "and mail.title like '%{$title}%' ";
        }
        if(!empty($role_id)){
            $where .= "and find_in_set($role_id, mail.role_ids) ";
        }
        if($status != '-1'){
            $where .= "and mail.status=$status ";
        }
        if($oprate_type != '-1'){
            $where .= "and mail.oprate_type=$oprate_type ";
        }

        $count = M('mail')
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count, 50);
        $list = M('mail')
            ->field('mail.*,bms_users.belongs_to as admin_name')
            ->join("left join bms_users on bms_users.id=mail.admin_id")
            ->where($where)
            ->order('id desc')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        $show = $Page->show();

        //获取所有的礼包道具
        $item_list = M('gift_item')->select();
        $item_data = [];
        foreach($item_list as $item_val){
            $item_data[$item_val['id']] = $item_val;
        }
        foreach($list as &$mail_val){
            if(isset($mail_val['item_data']) && !empty($mail_val['item_data'])){
                $gift_item_data = json_decode($mail_val['item_data'], true);
                foreach($gift_item_data as &$gift_item_val){
                    $gift_item_val['item_name'] = $item_data[$gift_item_val['item_type']]['name'];
                }
                $mail_val['item_data'] = json_encode($gift_item_data, JSON_UNESCAPED_UNICODE);
            }
            //查询服务器
            $server_data = '';
            if(!empty($mail_val['sid'])){
                $servers = M('server')->field("id,server_name")->where("id in(" . $mail_val['sid'] . ")")->select();
                foreach($servers as $server_val){
                    $server_data .= $server_val['id'] . '-' . $server_val['server_name'] . "；";
                }
            }
            $mail_val['server_data'] = $server_data;
            //查询角色
            $role_data = '';
            if(!empty($mail_val['role_ids'])){
                $roles = M('user_server')->field("role_id,role_name")->where("role_id in(" . $mail_val['role_ids'] . ")")->select();
                foreach($roles as $role_val){
                    $role_data .= $role_val['role_id'] . '-' . $role_val['role_name'] . "；";
                }
            }
            $mail_val['role_data'] = $role_data;
        }

        $search_params = [
            'title' => $title,
            'status' => $status,
            'role_id'=> $role_id,
            'oprate_type' => $oprate_type
        ];
        $this->assign(['list'=>$list,'count'=>$count,'page'=>$show, 'search_params' => $search_params]);
        $this->display();
    }

    //单服添加邮件
    public function addsingle(){
        //获取所有的服务器
        $server_only = M('server')->field("id,server_name")->select();
        $server_list = array_chunk($server_only, 50);
        //获取所有的邮件模板
        $mail_templates = M('mail_template')->select();
        //获取所有的礼包道具
        $item_list = M('gift_item')->where("type!=7")->select();

        // $item_data = [];
        // foreach($item_list as $item_val){
        //     $item_data[$item_val['id']] = $item_val;
        // }
        // $item_type_type = [];
        // foreach($this->item as $item_type_key=>$item_type_val){
        //     $item_type_type[] = [
        //         'id' => $item_type_key,
        //         'name' => $item_type_val
        //     ];
        // }

        $mail_templates_re = [];
        foreach($mail_templates as $mail_templates_val){
            $mail_templates_val['item_data'] = json_decode($mail_templates_val['item_data'], true);
            // foreach($mail_templates_val['item_data'] as &$item_val){
            //     $item_val['item_data'] = $item_data[$item_val['item_type_type']];
            // }
            $mail_templates_re[$mail_templates_val['id']] = $mail_templates_val;
        }
        // $this->assign(['item_data' => $item_data, 'item_type_type' => $item_type_type, 'server_list' => $server_list, 'server_only' => $server_only, 'mail_templates' => $mail_templates_re]);
        $this->assign(['item_data' => $item_list, 'server_list' => $server_list, 'server_only' => $server_only, 'mail_templates' => $mail_templates_re]);
        
        $this->display();
    }

    //全服添加邮件
    public function addall(){
        //获取所有的服务器
        $server_only = M('server')->field("id,server_name")->select();
        $server_list = array_chunk($server_only, 50);
        //获取所有的邮件模板
        $mail_templates = M('mail_template')->select();
        //获取所有的礼包道具
        $item_list = M('gift_item')->where("type!=7")->select();

        // $item_data = [];
        // foreach($item_list as $item_val){
        //     $item_data[$item_val['id']] = $item_val;
        // }
        // $item_type_type = [];
        // foreach($this->item as $item_type_key=>$item_type_val){
        //     $item_type_type[] = [
        //         'id' => $item_type_key,
        //         'name' => $item_type_val
        //     ];
        // }

        $mail_templates_re = [];
        foreach($mail_templates as $mail_templates_val){
            $mail_templates_val['item_data'] = json_decode($mail_templates_val['item_data'], true);
            // foreach($mail_templates_val['item_data'] as &$item_val){
            //     $item_val['item_data'] = $item_data[$item_val['item_type_type']];
            // }
            $mail_templates_re[$mail_templates_val['id']] = $mail_templates_val;
        }
        // $this->assign(['item_data' => $item_data, 'item_type_type' => $item_type_type, 'server_list' => $server_list, 'server_only' => $server_only, 'mail_templates' => $mail_templates_re]);
        $this->assign(['item_data' => $item_list, 'server_list' => $server_list, 'server_only' => $server_only, 'mail_templates' => $mail_templates_re]);
        $this->display();
    }

    public function adds(){
        $this->display();
    }

    public function edit(){
        $id = I('id', 0);
        $mail_info = M('mail')->where('id = '.$id.'')->find();
        //获取所有的服务器
        $server_only = M('server')->select();
        $server_list = array_chunk($server_only, 50);
        //获取所有的邮件模板
        $mail_templates = M('mail_template')->select();
        //获取所有的礼包道具
        $item_list = M('gift_item')->where("type!=7")->select();

        $mail_templates_re = [];
        foreach($mail_templates as $mail_templates_val){
            $mail_templates_val['item_data'] = json_decode($mail_templates_val['item_data'], true);
            // foreach($mail_templates_val['item_data'] as &$item_val){
            //     $item_val['item_data'] = $item_data[$item_val['item_type_type']];
            // }
            $mail_templates_re[$mail_templates_val['id']] = $mail_templates_val;
        }

        //处理道具数据
        if(isset($mail_info['item_data']) && !empty($mail_info['item_data'])){
            $gift_item_data = json_decode($mail_info['item_data'], true);
            // foreach($gift_item_data as &$gift_item_val){
            //     $gift_item_val['item_data'] = $item_data[$gift_item_val['item_type_type']];
            // }
        }
        //处理区服数据
        if(isset($mail_info['sid']) && !empty($mail_info['sid'])){
            $mail_info['sid'] = explode(',', $mail_info['sid']);
        }
//        var_dump(json_encode($gift_item_data));exit;
        $this->assign(['mail_info' => $mail_info, 'item_data' => $item_list, 'server_list' => $server_list, 'server_only' => $server_only, 'mail_templates' => $mail_templates_re, 'gift_item_data' => $gift_item_data]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $params = I('post.');
        // var_dump($params);exit;
        // if(empty($params['mail_template_id'])){
        //     $status = ['status'=>0,'message'=>'请选择邮件模板'];
        //     $this->ajaxReturn($status);
        // }
        if(empty($params['sid']) && empty($params['server_ids'])){
            $status = ['status'=>0,'message'=>'请选择区服'];
            $this->ajaxReturn($status);
        }
        $now_time = time();
        $gift_item_arr = [];
        foreach($params['item_type'] as $item_key=>$item_val){
            $gift_item_arr[] = [
                'item_type' => $item_val,
                'item_num' => $params['gift_item_num'][$item_key]
            ];
        }
        $item_data = json_encode($gift_item_arr);
        if($params['type'] == 1){   //全服邮件
            $sid_str = implode(',', $params['server_ids']);
            $role_ids = '';
        }else{
            $sid_str = $params['sid'];
            if(empty($params['role_ids'])){
                $status = ['status'=>0,'message'=>'单服邮件需要填写角色id，请重试'];
                $this->ajaxReturn($status);
            }
            $role_ids = filterSpecialStr($params['role_ids']);
            //检验角色id是否合法
            $role_id_arr = explode(',', $role_ids);
            foreach($role_id_arr as $role_id){
                if(!is_numeric($role_id)){
                    $status = ['status'=>0,'message'=>'多个角色用英文逗号隔开'];
                    $this->ajaxReturn($status);
                }
            }
        }
        $data = [
            'mail_template_id' => $params['mail_template_id'],
            'type' => $params['type'],
            'title' => $params['title'],
            'content' => $params['content'],
            'item_data' => $item_data,
            'sid' => $sid_str,
            'role_ids' => $role_ids,
            'admin_id' => session('admin_user_id'),
            'updated_at' => $now_time,
            'created_at' => $now_time
        ];
        $id = M('mail')->add($data);
        if($id){
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }
        $this->ajaxReturn($status);
    }
    /*批量添加*/
    public function ajax_adds(){
        ini_set('memory_limit','256M'); //临时提高内存

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
            // $columnCount = 'E';

            /* 循环读取每个单元格的数据 */
            //行数循环
            //获取数据的key
            $fixed_row = 1;
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

        //获取所有的礼包道具
        $item_list = $this->platform_db->table('gift_item')->select();
        $item_info_re = [];
        foreach($item_list as $item_val){
            $item_info_re[$item_val['id']] = $item_val;
        }
        //获取所有的服务器数据
        $server_list = $this->platform_db->table('server')->select();
        $server_list_re = [];
        foreach($server_list as $server_list_val){
            $server_list_re[$server_list_val['id']] = $server_list_val;
        }

        foreach($excel_data as $excel_val){
            $item_data_joson = "[]";
            $rewards = $excel_val['rewards'];
            if(!empty($excel_val['server_id']) && is_numeric($excel_val['server_id']) && !empty($excel_val['rid']) && !empty($rewards)){

                //检验角色id是否合法
                $role_ids = filterSpecialStr($excel_val['rid']);
                $role_id_arr = explode(',', $role_ids);
                $is_error = 0;
                foreach($role_id_arr as $role_id){
                    if(!is_numeric($role_id)){
                        $is_error = 1;
                    }
                }
                
                if($is_error == 0){
                    $item_arr = json_decode($rewards, true);
                    $item_data = [];
                    foreach($item_arr as $item_arr_val){
                        if(isset($item_info_re[$item_arr_val['item_type']])){
                            $item_data[] = [
                                'item_type' => $item_arr_val['item_type'],
                                'item_type_type' => $item_info_re[$item_arr_val['item_type']]['type'],
                                'item_num' => $item_arr_val['item_num']
                            ];
                        }
                    }
                    $item_data_joson = json_encode($item_data);
                    
                    $insert_data[] = [
                        'type' => 2 ,   //1.全服邮件，2.单服邮件
                        'title' => $excel_val['title'],
                        'content' => $excel_val['content'],
                        'role_ids' => $role_ids,
                        'sid' => $excel_val['server_id'],
                        'item_data' => $item_data_joson,
                        'oprate_type' => 1,     //操作类型：0.手动添加，1.文件批量添加
                        'note' => '',
                        'admin_id' => session('admin_user_id'),
                        'created_at' => $now_time,
                    ];
                }
            }
        }

        M('mail')->addAll($insert_data);

        if(!empty($error_msg)){
            $status = ['status'=>0,'message'=>$error_msg];
        }else{
            $status = ['status'=>1,'message'=>'上传成功~'];
        }

        $this->ajaxReturn($status);
    }
    /*更新*/
    public function ajax_updata(){
        $params = I('post.');
        if(empty($params['mail_template_id'])){
            $status = ['status'=>0,'message'=>'请选择邮件模板'];
            $this->ajaxReturn($status);
        }
        $now_time = time();
        $gift_item_arr = [];
        foreach($params['item_type'] as $item_key=>$item_val){
            $gift_item_arr[] = [
                'item_type' => $item_val,
                'item_num' => $params['gift_item_num'][$item_key]
            ];
        }
        $item_data = json_encode($gift_item_arr);
        if($params['type'] == 1){   //全服邮件
            $sid_str = implode(',', $params['server_ids']);
            $role_ids = '';
        }else{
            $sid_str = $params['sid'];
            if(empty($params['role_ids'])){
                $status = ['status'=>0,'message'=>'单服邮件需要填写角色id，请重试'];
                $this->ajaxReturn($status);
            }
            $role_ids = filterSpecialStr($params['role_ids']);
            //检验角色id是否合法
            $role_id_arr = explode(',', $role_ids);
            foreach($role_id_arr as $role_id){
                if(!is_numeric($role_id)){
                    $status = ['status'=>0,'message'=>'多个角色用英文逗号隔开'];
                    $this->ajaxReturn($status);
                }
            }
        }
        $data = [
            'mail_template_id' => $params['mail_template_id'],
            'title' => $params['title'],
            'content' => $params['content'],
            'item_data' => $item_data,
            'sid' => $sid_str,
            'role_ids' => $role_ids,
            'admin_id' => session('admin_user_id'),
            'updated_at' => $now_time,
        ];
        $res = M('mail')->where("id=" . $params['id'])->save($data);
        if($res){
            $status = ['status'=>1,'message'=>'修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'修改失败'];
        }
        $this->ajaxReturn($status);
    }

    /*审核并发送邮件*/
    public function ajax_send(){
        $now_time = time();
        $id = I('id');
        $status = I('status', 1);
        if(!$id){
            $status = ['status'=>0,'message'=>'参数出错'];
            $this->ajaxReturn($status);
        }
        if($status == 1){
            $error_msg = $this->send_mail([$id]);
        }else{
            $data = [
                'status' => 2,
                'note' => '审核不通过',
                'updated_at' => $now_time,
            ];
            $res = M('mail')->where("id=" . $id)->save($data);
            $error_msg = '审核不通过成功';
        }
        
        if(!empty($error_msg)){
            $status = ['status'=>0,'message'=>$error_msg];
        }else{
            $status = ['status'=>1,'message'=>'审核成功~'];
        }

        $this->ajaxReturn($status);
    }

    /*批量审核并发送邮件*/
    public function ajax_sends(){
        ini_set('max_execution_time', '0');     //设置没有超时限制

        $ids = I('ids');
        if(!empty($ids)){
            $ids_arr = explode(',', substr($ids,0,-1));
            $error_msg = $this->send_mail($ids_arr);
        }else{
            $status = ['status'=>0,'message'=>'请选择邮件'];
            $this->ajaxReturn($status);
        }
        
        if(!empty($error_msg)){
            $status = ['status'=>0,'message'=>$error_msg];
        }else{
            $status = ['status'=>1,'message'=>'审核成功~'];
        }

        $this->ajaxReturn($status);
    }

    /*审核并发送邮件*/
    public function send_mail($ids){
        $now_time = time();
        $error_msgs = '';
        foreach($ids as $id){
            $error_msg = '';
            $mail_info = M('mail')
                ->field('mail.*')
                ->where('mail.id = ' . $id)
                ->find();
                
            if(!$mail_info){
                $error_msg .= '邮件id-' . $id . '-：发送失败，原因：非法邮件id' . $id . '；';
            }elseif($mail_info['status'] != 0){
                $error_msg .= '邮件id-' . $id . '：发送失败，原因：邮件id-' . $id . '-已经审核过；';
            }else{
                //获取要发送的服务器信息
                $server_list = M('server')
                    ->field('*')
                    ->where("id in (" . $mail_info['sid'] . ")")
                    ->select();

                if($mail_info['type'] == 1){    //全服发送
                    $mail_send_type = 1;
                    $role_ids = '';
                }else{
                    $mail_send_type = 2;
                    $role_ids = explode(',', $mail_info['role_ids']);
                    foreach ($role_ids as &$role_id){
                        $role_id = (int)$role_id;
                    }
                    $role_ids = json_encode($role_ids);
                }

                $send_data = [
                    'type' => $mail_send_type,
                    'title' => $mail_info['title'],
                    'content' => $mail_info['content'],
                    'roleIds' => $role_ids,
                    'goods' => $mail_info['item_data'],
                ];

                //记录发送失败的服务器
                foreach($server_list as $server_val){
                    $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'] . C("MAIL_SEND");
                    $send_url .= '?' . http_build_query($send_data);
                    $result = curlRequest($send_url, $request_type = 'get');
                    $result_arr = json_decode($result, true);
                    $status = $result_arr['code'];

                    if($status != 200){
                        $error_msg .= '邮件id-' . $id . '-：服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '发送失败，原因：' . $result_arr['msg'] . '；';
                    }
                }

                if(!empty($error_msg)){
                    $data = [
                        'status' => 2,
                        'note' => $error_msg,
                        'updated_at' => $now_time,
                    ];
                    $res = M('mail')->where("id=" . $id)->save($data);
                }else{
                    $data = [
                        'status' => 1,
                        'note' => '发送成功',
                        'updated_at' => $now_time,
                    ];
                    $res = M('mail')->where("id=" . $id)->save($data);
                }
            }
            
            $error_msgs .= $error_msg;
        }
        
        return $error_msgs;
    }

    /**
     * 玩家的邮件
     */
    public function RoleMail(){
        //获取所有的服务器
        $servers = $this->platform_db->table('server')->select();

        //记录搜索条件
        $sid = I('sid', '');
        $role_id = I('role_id', '');
        $oprate = I('oprate', '1');     //邮件类型，1.系统邮件，2.个人邮件

        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'role_id' => $role_id,
            'oprate' => $oprate,
        ];

        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'count'=>0, 'page'=>'', 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $where = "1 ";
        $server_info = $this->platform_db->table("server")->where("id=$sid")->find();
        if(!$server_info){
            $this->assign(['list'=>[], 'error_msg'=> '服务器不存在，请联系管理员！！！', 'count'=>0, 'page'=>'', 'servers' => $servers, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        $game_data_db = connectionDb($server_info, 'data');     //连接游戏数据库
        if($oprate == 1){   //系统邮件
            $table = "mail_some";
        }else{
            if(!empty($role_id)){
                $where .= "and rid=$role_id";
            }
            $table = "mail";
        }
        
        $count = $game_data_db->table($table)
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count, 50);
        $list = $game_data_db->table($table)
            ->where($where)
            ->order('id desc')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        if($oprate == 1){   //系统邮件
            foreach($list as &$list_val){
                $list_val['create_date'] = getMsecToMescdate($list_val['create_time']);
            }
        }else{
            foreach($list as &$list_val){
                $list_val['create_date'] = date('Y-m-d H:i:s', $list_val['time']);
            }

        }
        $show = $Page->show();
        
        $this->assign(['list'=>$list,'count'=>$count,'page'=>$show, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }
    /*批量删除玩家邮件*/
    public function ajax_del_rolemail($ids){
        $ids = I('ids');
        $sid = I('sid', '0');
        $oprate = I('oprate', '1');
        if(!empty($ids)){
            $ids_arr = explode(',', substr($ids,0,-1));
        }else{
            $status = ['status'=>0,'message'=>'请选择邮件'];
            $this->ajaxReturn($status);
        }
        
        $server_info = $this->platform_db->table("server")->where("id=$sid")->find();
        if(!$server_info){
            $status = ['status'=>0,'message'=>'服务器不存在，请联系管理员！！！'];
            $this->ajaxReturn($status);
        }

        if($oprate == 1){       //系统邮件
            $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . C("DELETE_SYSMAIL");
            $send_data = [
                'mailIds' => json_encode($ids_arr)
            ];
        }else{                  //个人邮件
            $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . C("DELETE_PERSONALMAIL");
            $send_data = [
                'mailIds' => json_encode($ids_arr)
            ];
        }
        $result = curlRequest($send_url, $request_type = 'post', $send_data);
        $result_arr = json_decode($result, true);

        $error_msg = '';
        if(!$result_arr){
            $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '删除失败，原因：连接失败；';
        }else{
            $status = $result_arr['code'];
            if($status != 200){
                $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '删除失败，原因：' . $result_arr['msg'] . '；';
            }
        }
        
        if(!empty($error_msg)){
            $status = ['status'=>0,'message'=>$error_msg];
        }else{
            $status = ['status'=>1,'message'=>'删除成功~'];
        }

        $this->ajaxReturn($status);
    }
}
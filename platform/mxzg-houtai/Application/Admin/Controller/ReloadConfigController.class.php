<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 后台刷新配置的接口
 */
class ReloadConfigController extends PublicController{
    protected $replace_str = "###serverid###";

    public function reload(){
        //获取所有的服务器
        $server_list = M('server')->select();
        $server_list = array_chunk($server_list, 50);
        $this->assign(['server_list' => $server_list]);
        $this->display();
    }

    /*后台刷新配置*/
    public function ajax_reload(){
        ini_set('max_execution_time', '0');     //设置没有超时限制

        $params = I('post.');
        if(empty($params['server_ids'])){
            $status = ['status'=>0,'message'=>'请选择服务器'];
            $this->ajaxReturn($status);
        }
        $server_ids_str = implode(',', $params['server_ids']);
        // $server_list = M('server')->field('id,intranet_host,http_port')->where("id in($server_ids_str)")->select();
        // $is_success = 1;
        // $send_data = [
        //     'configs' => $params['content'],
        // ];
        // $error_msg = '';
        // foreach($server_list as $server_val){
        //     $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'] . C("RELOAD_CONFIG");
        //     $send_url .= '?' . http_build_query($send_data);
        //     $result = curlRequest($send_url, $request_type = 'get');
        //     $result_arr = json_decode($result, true);
        //     $status = $result_arr['code'];
        //     if($status != 200){
        //         $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '刷新失败，原因：' . $result_arr['msg'] . '；';
        //     }
        // }


        $server_list = M('server')
            ->field('*')
            ->where("id in($server_ids_str)")
            ->select();

        //处理服务器数据，把服务器按照热更的每个服分组
        $server_list_new=[];
        foreach ($server_list as $server_val) {
            $server_list_new[$server_val['intranet_host']][] = $server_val;
        }
        $server_list_re=[];
        foreach ($server_list_new as $server_list_new_val) {
            foreach ($server_list_new_val as $server_re_key=>$server_re_val) {
                $server_list_re[$server_re_key][] = $server_re_val;
            }
        }

        //记录失败的服务器
        $error_msg = '';
        $send_data = [
            'configs' => $params['content'],
        ];
        foreach($server_list_re as $server_list_re_val){
            foreach($server_list_re_val as $server_val){
                $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'] . C("RELOAD_CONFIG");
                $send_url .= '?' . http_build_query($send_data);
                $result = curlRequest($send_url, $request_type = 'get');
                $result_arr = json_decode($result, true);

                if(!$result_arr){
                    $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '刷新失败，原因：连接失败；';
                }else{
                    $status = $result_arr['code'];
                    if($status != 200){
                        $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '刷新失败，原因：' . $result_arr['msg'] . '；';
                    }
                }
            }
        }


        if (empty($error_msg)) {
            $status = ['status'=>1,'message'=>'后台刷新配置成功~'];
        }else{
            $status = ['status'=>0,'message'=>$error_msg];
        }
        $this->ajaxReturn($status);
    }

    //热更后端代码
    public function hot_update(){
        //获取所有的服务器
        $server_list = $this->platform_db->table('server')->select();
        $server_list = array_chunk($server_list, 50);

        //获取所有的特殊服务器
        $special_server_list = $this->platform_db->table('special_server')->where("status=1")->select();
        $special_server_list = array_chunk($special_server_list, 50);
        $this->assign(['server_list' => $server_list, 'special_server_list' => $special_server_list]);
        $this->display();
    }

    /*热更后端代码*/
    public function ajax_hot_reload(){
        ini_set('max_execution_time', '0');     //设置没有超时限制
        
        $params = I('post.');
        if(empty($params['server_ids'])){
            $status = ['status'=>0,'message'=>'请选择服务器'];
            $this->ajaxReturn($status);
        }

        $server_ids_str = implode(',', $params['server_ids']);
        $server_list = M('server')
            ->field('*')
            ->where("id in($server_ids_str)")
            ->select();

        //处理服务器数据，把服务器按照热更的每个服分组
        $server_list_new=[];
        foreach ($server_list as $server_val) {
            $server_list_new[$server_val['intranet_host']][] = $server_val;
        }
        $server_list_re=[];
        foreach ($server_list_new as $server_list_new_val) {
            foreach ($server_list_new_val as $server_re_key=>$server_re_val) {
                $server_list_re[$server_re_key][] = $server_re_val;
            }
        }

        //记录失败的服务器
        $error_msg = '';
        foreach($server_list_re as $server_list_re_val){
            foreach($server_list_re_val as $server_val){
                $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'] . C("HOT_UPDATE");
                $result = curlRequest($send_url, $request_type = 'get');
                $result_arr = json_decode($result, true);

                if(!$result_arr){
                    $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '热更失败，原因：连接失败；';
                }else{
                    $status = $result_arr['code'];
                    if($status != 200){
                        $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '热更失败，原因：' . $result_arr['msg'] . '；';
                    }
                }
            }
        }
        
        if(!empty($error_msg)){
            $status = ['status'=>0,'message'=>$error_msg];
        }else{
            $status = ['status'=>1,'message'=>'热更成功~'];
        }
        $this->ajaxReturn($status);
    }

    /**
     * @desc 执行特殊sql
     * @notice $replace_str 替换符
     * @param $sid 要被执行的数据库集合
     * @param $name 要被执行的数据库的后缀名
     */
    public function doSpecialSql(){      
        ini_set('max_execution_time', '0');     //设置没有超时限制
        
        $now_date = date('Y-m-d');
        //记录搜索条件
        $server_ids = I('server_ids', '0');
        $server_ids_str = implode(',', $server_ids);
        $name = I('name', 'data');
        $sql = I('sql', '');

        //获取所有的服务器
        $servers = $this->platform_db->table('server')->select();
        $server_list = array_chunk($servers, 50);

        //组件搜索条件的值
        $search_params = [
            'server_ids' => $server_ids,
            'name' => $name,
            'sql' => $sql,
        ];
        $error_msg = '';
        if(empty($server_ids)){
            $error_msg = '请选择服务器！！！';
        }
        if(empty($name)){
            $error_msg = '请填写data或者log！！！';
        }
        if(empty($sql)){
            $error_msg = '请填写sql！！！';
        }
        if(!empty($error_msg)){
            $this->assign(['list'=>[], 'error_msg'=> $error_msg, 'count'=>0, 'page'=>'', 'server_list' => $server_list, 'search_params' => $search_params]);
            $this->display();
            exit;
        }
        //判断sql语句是否是查询语句
        if(strpos($sql,'update') !== false){ 
            $error_msg = 'sql不能是更改语句！！！';
        }if(strpos($sql,'insert') !== false){ 
            $error_msg = 'sql不能是添加语句！！！';
        }elseif(strpos($sql,'delete') !== false){
            $error_msg = 'sql不能是删除语句！！！';
        }elseif(strpos($sql,'select') === false){
            $error_msg = 'sql必须是查询语句！！！';
        }
        // $sid_arr = explode(',', $sid);
        // if(count($sid_arr) > 4){
        //     $error_msg = '服务器不能超过4个！！！';
        // }
        if(!empty($error_msg)){
            $this->assign(['list'=>[], 'error_msg'=> $error_msg, 'count'=>0, 'page'=>'', 'server_list' => $server_list, 'search_params' => $search_params]);
            $this->display();
            exit;
        }

        $list = [];
        // var_dump($server_ids_str);exit;
        $server_lists = $this->platform_db->table('server')->where("id in($server_ids_str)")->select();
        foreach($server_lists as $server_val){
            //sql替换服务器id
            $sql_re = str_replace($this->replace_str, $server_val['id'], $sql);
            $db = connectionDb($server_val, $name);     //连接游戏数据库
            $list_son = $db->query($sql_re);
            $list = array_merge($list, $list_son);
        }
        $count = count($list);
        $list_title = [];
        if(!empty($list)){
            foreach($list[0] as $list_key=>$list_val){
                $list_title[] = $list_key;
            }
        }
        $this->assign(['list'=>$list,'page'=>1,'count'=>$count, 'list_title' => $list_title, 'server_list' => $server_list, 'search_params' => $search_params]);
        $this->display();
    }
    /**
     * @desc 执行特殊sql
     * @notice $replace_str 替换符
     * @param $sid 要被执行的数据库集合
     * @param $name 要被执行的数据库的后缀名
     */
    public function doSpecialSqlExport(){
        ini_set('max_execution_time', '0');     //设置没有超时限制

        $now_date = date('Y-m-d');
        $exportData = I('exportData', '');
        $export_arr = json_decode($exportData, true);
        //记录搜索条件
        $server_ids = $export_arr['server_ids'];
        $server_ids_str = implode(',', $server_ids);
        $name = $export_arr['name'];
        $sql = $export_arr['sql'];

        $is_error == 1;
        if(empty($server_ids)){
            $is_error == 0;
        }
        if(empty($name)){
            $is_error == 0;
        }
        if(empty($sql)){
            $is_error == 0;
        }
        //判断sql语句是否是查询语句
        if(strpos($sql,'update') !== false){ 
            $is_error == 0;
        }if(strpos($sql,'insert') !== false){ 
            $is_error == 0;
        }elseif(strpos($sql,'delete') !== false){
            $is_error == 0;
        }elseif(strpos($sql,'select') === false){
            $is_error == 0;
        }
        // $sid_arr = explode(',', $sid);
        // if(count($sid_arr) > 4){
        //     $is_error == 0;
        // }

        $list = [];
        $list_title = [];
        $server_list = $this->platform_db->table('server')->where("id in($server_ids_str)")->select();
        if($is_error == 0 && $server_list){
            foreach($server_list as $server_val){
                //sql替换服务器id
                $sql_re = str_replace($this->replace_str, $server_val['id'], $sql);
                $db = connectionDb($server_val, $name);     //连接游戏数据库
                $list_son = $db->query($sql_re);
                $list = array_merge($list, $list_son);
            }
            $list_title = [];
            if(!empty($list)){
                foreach($list[0] as $list_key=>$list_val){
                    $list_title[] = $list_key;
                }
            }
        }
        
        vendor('PHPExcel.PHPExcel');
        vendor('PHPExcel.PHPExcel.Writer.Excel5');
        Vendor("PHPExcel.PHPExcel.IOFactory");
        $excel = new \PHPExcel();
        // for($i=65;$i<91;$i++){
        //     echo strtoupper(chr($i));//输出大写字母
        // }
        //Excel表格title
        // 根据字段个数，设置表头排序字母
        $letter_str = '';
        for($i='A',$k=0; $i<='Z'; $i++,$k++){
            if($k == count($list_title)){
                break;
            }

            // 最后一个取消逗号
            if($k == (count($list_title)-1)){
                $letter_str .= $i;
            } else {
                $letter_str .= $i.',';
            }
        }
        $letter = explode(',', $letter_str);
        // $letter = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P');
        //表头数组
        $tableheader = $list_title;
        //填充表头信息
        for($i = 0;$i < count($tableheader);$i++) {
            $excel->getActiveSheet()->setCellValue("$letter[$i]1","$tableheader[$i]");
        }
        $excel->getActiveSheet()->getDefaultColumnDimension()->setWidth(20);//所有单元格（列）默认宽度
        //填充表格信息
        for ($i = 2;$i <= count($list) + 1;$i++) {
            foreach($list_title as $list_title_key=>$list_title_val){
                $excel->getActiveSheet()->setCellValue($letter[$list_title_key] . "$i", $list[$i - 2][$list_title_val]);
            }
        }

        //创建Excel输入对象
        ob_clean();
        $write = new \PHPExcel_Writer_Excel5($excel);
        header("Pragma: public");
        header("Expires: 0");
        $filename="sql_data.xls";
        header("Content-Disposition: attachment;filename=$filename");
        header("Cache-Control:must-revalidate, post-check=0, pre-check=0");
        header("Content-Type:application/force-download");
        header("Content-Type:application/vnd.ms-execl");
        header("Content-Type:application/octet-stream");
        header("Content-Type:application/download");
        header("Content-Transfer-Encoding:binary");
        $write->save('php://output');

    }

    //扣除充值或道具列表
    public function CostRechargeItemList(){
        //获取所有的服务器
        $servers = M('server')->select();

        //记录搜索条件
        $sid = I('sid', '0');
        $role_id = I('role_id', '0');
        $type = I('type', '1');
        //组建搜索条件的值
        $search_params = [
            'sid' => $sid,
            'type' => $type,
        ];

        if($type == 1){
            $table = "cost_recharge";
        }else{
            $table = "cost_item";
        }

        $where = '1 ';
        if(!empty($sid)){
            $where .= "and sid in($sid) ";
        }
        if(!empty($role_id)){
            $where .= "and role_id=$role_id ";
        }
        $count = $this->platform_db->table($table)
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count, $count);
        $list = $this->platform_db->table($table . " as tmp")
            ->field("
                tmp.*,server.server_name
            ")
            ->join("LEFT JOIN server on server.id=tmp.sid")
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->order("id desc")
            ->select();
        if($type == 1){
            $list_title = [
                '主键ID','服务器','角色id','总值','周值','日值','返回值','时间'
            ];
            foreach($list as &$list_val){
                $list_val = [
                    $list_val['id'], $list_val['sid'] . '--' . $list_val['server_name'], $list_val['role_id'], $list_val['total'], $list_val['week'], $list_val['daily'], $list_val['debug'], date('Y-m-d H:i:s', $list_val['created_at'])
                ];
            }
        }else{
            $list_title = [
                '主键ID','服务器','角色id','道具','返回值','时间'
            ];
            foreach($list as &$list_val){
                $list_val = [
                    $list_val['id'], $list_val['sid'] . '--' . $list_val['server_name'], $list_val['role_id'], $list_val['item'], $list_val['debug'], date('Y-m-d H:i:s', $list_val['created_at'])
                ];
            }
        }

        $this->assign(['list'=>$list, 'list_title'=>$list_title, 'count'=>$count, 'page'=>$show, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }
    //扣除充值或道具
    public function CostRechargeItem(){
        //获取所有的服务器
        $server_list = M('server')->select();
        //获取所有的礼包道具
        $item_list = M('gift_item')->where("type!=7")->select();

        $this->assign(['server_list' => $server_list, 'item_data' => $item_list]);
        $this->display();
    }

    /*扣除充值或道具*/
    public function ajax_CostRechargeItem(){
        $params = I('post.');
        $sid = $params['sid'];
        if(empty($sid)){
            $status = ['status'=>0,'message'=>'请选择服务器'];
            $this->ajaxReturn($status);
        }
        
        $server_info = $this->platform_db->table('server')
            ->field('*')
            ->where("id=$sid")
            ->find();

        $type = $params['type'];
        $role_id = $params['role_id'];
        if($type == 1){     //扣除充值
            $send_data = [
                'rid' => $role_id,
                'total' => !empty($params['total']) ? $params['total'] : 0,
                'week' => !empty($params['week']) ? $params['week'] : 0,
                'daily' => !empty($params['daily']) ? $params['daily'] : 0,
            ];
            $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . C("COST_RECHARGE");

            //保存数据
            $data = [
                'role_id' => $role_id,
                'sid' => $sid,
                'total' => !empty($params['total']) ? $params['total'] : 0,
                'week' => !empty($params['week']) ? $params['week'] : 0,
                'daily' => !empty($params['daily']) ? $params['daily'] : 0,
                'created_at' => time(),
            ];
            $table = "cost_recharge";
        }else{              //扣除道具
            $gift_item_arr = [];
            foreach($params['item_type'] as $item_key=>$item_val){
                $gift_item_arr[$item_val] = !empty($params['gift_item_num'][$item_key]) ? $params['gift_item_num'][$item_key] : 0;
            }
            
            $item_json = json_encode($gift_item_arr);
            $send_data = [
                'rid' => $role_id,
                'item' => $item_json,
            ];
            $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . C("COST_ITEM");
            //保存数据
            $data = [
                'role_id' => $role_id,
                'sid' => $sid,
                'item' => $item_json,
                'created_at' => time(),
            ];
            $table = "cost_item";
        }
        $result = curlRequest($send_url, $request_type = 'post', $send_data);
        $data['debug'] = $result;
        $data['request_url'] = $send_url . '?' . http_build_query($send_data);
        $result_arr = json_decode($result, true);

        if(!$result_arr){
            $error_msg .= '服务器【' . $server_info['id'] . '】：' . $server_info['server_name'] . '扣除失败，原因：连接失败；';
        }else{
            $status = $result_arr['code'];
            if($status != 200){
                $error_msg .= '服务器【' . $server_info['id'] . '】：' . $server_info['server_name'] . '扣除失败，原因：' . $result_arr['msg'] . '；';
            }
        }

        //保存数据
        $this->platform_db->table($table)->add($data);
        if(!empty($error_msg)){
            $status = ['status'=>0,'message'=>$error_msg];
        }else{
            $status = ['status'=>1,'message'=>'扣除成功~'];
        }
        $this->ajaxReturn($status);
    }

    /*开放式特殊请求*/
    public function OpenReload(){
        //获取所有的服务器
        $server_list = M('server')->select();
        $server_list = array_chunk($server_list, 50);
        $this->assign(['server_list' => $server_list]);
        $this->display();
    }

    /*开放式特殊请求*/
    public function ajax_OpenReload(){
        ini_set('max_execution_time', '0');     //设置没有超时限制
        
        $server_ids = I('server_ids',[]);
        if(empty($server_ids)){
            $status = ['status'=>0,'message'=>'请选择服务器'];
            $this->ajaxReturn($status);
        }
        $reload = I('reload','');
        if(empty($reload)){
            $status = ['status'=>0,'message'=>'请输入功能和参数'];
            $this->ajaxReturn($status);
        }
        $server_ids_str = implode(',', $server_ids);
        $server_list = M('server')->field('id,intranet_host,http_port')->where("id in($server_ids_str)")->select();

        $error_msg = '';
        foreach($server_list as $server_val){
            $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'];
            $send_url .= $reload;
            $result = curlRequest($send_url, $request_type = 'get',[],5);
            $result_arr = json_decode($result, true);
            $status = $result_arr['code'];
            if($status != 200){
                $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '请求失败，原因：' . $result_arr['msg'] . '；';
            }
        }
        if (empty($error_msg)) {
            $status = ['status'=>1,'message'=>'请求成功~'];
        }else{
            $status = ['status'=>0,'message'=>$error_msg];
        }
        $this->ajaxReturn($status);
    }

    /*冠军赛清除弹幕（选服清除）*/
    public function ChampionCleanBiu(){
        //获取所有的服务器
        $server_list = M('server')->select();
        $server_list = array_chunk($server_list, 50);
        $this->assign(['server_list' => $server_list]);
        $this->display();
    }

    /*冠军赛清除弹幕（选服清除）*/
    public function ajax_ChampionCleanBiu(){
        ini_set('max_execution_time', '0');     //设置没有超时限制
        
        $server_ids = I('server_ids',[]);
        if(empty($server_ids)){
            $status = ['status'=>0,'message'=>'请选择服务器'];
            $this->ajaxReturn($status);
        }
        $server_ids_str = implode(',', $server_ids);
        $server_list = $this->platform_db->table('server')->field('id,intranet_host,http_port')->where("id in($server_ids_str)")->select();

        $error_msg = '';
        foreach($server_list as $server_val){
            $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'] . C("CHAMPION_CLEAN_BIU");
            $result = curlRequest($send_url, $request_type = 'get');
            $result_arr = json_decode($result, true);
            $status = $result_arr['code'];
            if($status != 200){
                $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '清除弹幕失败，原因：' . $result_arr['msg'] . '；';
            }
        }
        if (empty($error_msg)) {
            $status = ['status'=>1,'message'=>'清除弹幕成功~'];
        }else{
            $status = ['status'=>0,'message'=>$error_msg];
        }
        $this->ajaxReturn($status);
    }

    /*周冠军赛清除弹幕（跨服清除）*/
    public function WeekChampionCleanBiu(){
        $this->display();
    }

    /*周冠军赛清除弹幕（跨服清除）*/
    public function ajax_WeekChampionCleanBiu(){
        //实例化中心库数据库
        $data_center_db = M('',null,'DB_DATA_CENTER');
        $server_cross_list = $data_center_db->table("cross_config")->select();

        $error_msg = '';
        foreach($server_cross_list as $server_cross_val){
            $server_cross_val['port'] = 20004;
            $send_url = "http://" . $server_cross_val['ip'] . ':' . $server_cross_val['port'] . C("CHAMPION_CLEAN_BIU");
            $result = curlRequest($send_url, $request_type = 'get');
            $result_arr = json_decode($result, true);
            $status = $result_arr['code'];
            if($status != 200){
                $error_msg .= '跨服id【' . $server_cross_val['id'] . '】：清除弹幕失败，原因：' . $result_arr['msg'] . '；';
            }
        }
        if (empty($error_msg)) {
            $status = ['status'=>1,'message'=>'清除弹幕成功~'];
        }else{
            $status = ['status'=>0,'message'=>$error_msg];
        }
        $this->ajaxReturn($status);
    }

}
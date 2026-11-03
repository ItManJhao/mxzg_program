<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 订单列表
 */
class RechargeController extends PublicController{

    /*搜索*/
    public function index(){
        //获取所有的子渠道
        $channels = $this->platform_db->table('channel')->where('parent_id>0')->select();
        //获取所有的服务器
        $servers = $this->platform_db->table('server')->select();
        //获取所有的商品
        $product_list = $this->platform_db->table('product')->select();
        $product_list_re = [];
        foreach($product_list as $product_list_val){
            $product_list_re[$product_list_val['id']] = $product_list_val;
        }

        //记录搜索条件
        $role_id = I('role_id', '');
        $game_order_id = I('game_order_id', '');
        $sdk_order_id = I('sdk_order_id', '');
        $c_son_id = I('c_son_id', '0');
        $sid = I('sid', '0');
        $status = I('status', '0');
        $product_id = I('product_id', '0');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', date('Y-m-d'));
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        $where = "1 ";
        if(!empty($c_son_id)){
            $where .= "and us.c_son_id in($c_son_id) ";
        }
        if(!empty($sid)){
            $where .= "and recharge.sid in($sid) ";
        }
        if(!empty($role_id)){
            $where .= "and recharge.role_id='$role_id' ";
        }
        if(!empty($game_order_id)){
            $where .= "and recharge.game_order_id='{$game_order_id}' ";
        }
        if(!empty($sdk_order_id)){
            $where .= "and recharge.sdk_order_id='{$sdk_order_id}' ";
        }
        if(!empty($status)){
            $where .= "and recharge.status=$status ";
        }
        if(!empty($product_id)){
            $where .= "and recharge.goods_id in($product_id) ";
        }
        if(!empty($start_time)){
            $where .= "and recharge.created_at>=" . strtotime($start_time) . ' ';
        }
        if(!empty($end_time)){
            $where .= "and recharge.created_at<=" . strtotime($end_time . ' 23:59:59') . ' ';
        }

        $count = M('recharge')
            ->join("left join user_server as us on us.role_id=recharge.role_id")
            ->join("left join server on server.id=recharge.sid")
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count, 50);
        $list = M('recharge')
            ->field('recharge.*,us.role_name,server.server_name')
            ->join("left join user_server as us on us.role_id=recharge.role_id")
            ->join("left join server on server.id=recharge.sid")
            ->where($where)
            ->order('recharge.id desc')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        foreach($list as &$list_val){
            if(isset($product_list_re[$list_val['goods_id']])){
                $list_val['product_name'] = $product_list_re[$list_val['goods_id']]['product_name'];
            }else{
                $list_val['product_name'] = '';
            }
        }
        $search_params = [
            'role_id' => $role_id,
            'game_order_id' => $game_order_id,
            'sdk_order_id' => $sdk_order_id,
            'c_son_id' => $c_son_id,
            'sid' => $sid,
            'status' => $status,
            'product_id' => $product_id,
            'start_time' => $start_time,
            'end_time' => $end_time
        ];
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'product_list'=> $product_list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }
    //订单导出
    public function export(){
        ini_set('memory_limit','256M'); //临时提高内存
        //获取所有的商品
        $product_list = $this->platform_db->table('product')->select();
        $product_list_re = [];
        foreach($product_list as $product_list_val){
            $product_list_re[$product_list_val['id']] = $product_list_val;
        }

        //记录搜索条件
        $role_id = I('role_id', '');
        $game_order_id = I('game_order_id', '');
        $c_son_id = I('c_son_id', '0');
        $sid = I('sid', '0');
        $status = I('status', '0');
        $product_id = I('product_id', '0');
        $start_time = I('start_time', date('Y-m-d', strtotime("-7 day")));
        $end_time = I('end_time', date('Y-m-d'));
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        $where = "1 ";
        if(!empty($c_son_id)){
            $where .= "and us.c_son_id in($c_son_id) ";
        }
        if(!empty($sid)){
            $where .= "and recharge.sid in($sid) ";
        }
        if(!empty($role_id)){
            $where .= "and recharge.role_id='$role_id'";
        }
        if(!empty($game_order_id)){
            $where .= "and recharge.game_order_id=$game_order_id";
        }
        if(!empty($status)){
            $where .= "and recharge.status=$status";
        }
        if(!empty($product_id)){
            $where .= "and recharge.goods_id in($product_id) ";
        }
        if(!empty($start_time)){
            $where .= "and recharge.created_at>=" . strtotime($start_time) . ' ';
        }
        if(!empty($end_time)){
            $where .= "and recharge.created_at<=" . strtotime($end_time . ' 23:59:59') . ' ';
        }

        $list = M('recharge')
            ->field('recharge.*,us.role_name,server.server_name')
            ->join("left join user_server as us on us.role_id=recharge.role_id")
            ->join("left join server on server.id=recharge.sid")
            ->where($where)
            ->order('recharge.id desc')
            ->limit(C('EXPORT_LIMIT_NUM'))       //限制导出数量
            ->select();
        foreach($list as &$list_val){
            if(isset($product_list_re[$list_val['goods_id']])){
                $list_val['product_name'] = $product_list_re[$list_val['goods_id']]['product_name'];
            }else{
                $list_val['product_name'] = '';
            }
        }

        vendor('PHPExcel.PHPExcel');
        vendor('PHPExcel.PHPExcel.Writer.Excel5');
        Vendor("PHPExcel.PHPExcel.IOFactory");
        $excel = new \PHPExcel();
        //Excel表格式,这里简略写了8列
        $letter = array('A','B','C','D','E','F','G','H','I','J','K');
        //表头数组
        $tableheader = array('平台订单号','游戏订单号','SDK订单号','角色id','角色名字','区服','商品','金额','状态','发货返回值','创建时间');
        //填充表头信息
        for($i = 0;$i < count($tableheader);$i++) {
            $excel->getActiveSheet()->setCellValue("$letter[$i]1","$tableheader[$i]");
        }
        $excel->getActiveSheet()->getDefaultColumnDimension()->setWidth(20);//所有单元格（列）默认宽度
        //填充表格信息
        for ($i = 2;$i <= count($list) + 1;$i++) {
            $excel->getActiveSheet()->setCellValue("A$i", $list[$i - 2]['id']);
            $excel->getActiveSheet()->setCellValue("B$i", ' ' . $list[$i - 2]['game_order_id']);
            $excel->getActiveSheet()->setCellValue("C$i", $list[$i - 2]['sdk_order_id']);
            $excel->getActiveSheet()->setCellValue("D$i", $list[$i - 2]['role_id']);
            $excel->getActiveSheet()->setCellValue("E$i", $list[$i - 2]['role_name']);
            $excel->getActiveSheet()->setCellValue("G$i", $list[$i - 2]['sid'] . '--' . $list[$i - 2]['server_name']);
            $excel->getActiveSheet()->setCellValue("H$i", $list[$i - 2]['goods_id'] . '--' . $list[$i - 2]['product_name']);
            $excel->getActiveSheet()->setCellValue("I$i", $list[$i - 2]['money']);
            if($list[$i - 2]['status'] == 1){
                $excel->getActiveSheet()->setCellValue("J$i", '支付成功');
            }elseif($list[$i - 2]['status'] == 2){
                $excel->getActiveSheet()->setCellValue("J$i", '支付失败');
            }elseif($list[$i - 2]['status'] == 3){
                $excel->getActiveSheet()->setCellValue("J$i", '发货成功');
            }elseif($list[$i - 2]['status'] == 4){
                $excel->getActiveSheet()->setCellValue("J$i", '发货失败');
            }else{
                $excel->getActiveSheet()->setCellValue("J$i", '未支付');
            }
            $excel->getActiveSheet()->setCellValue("K$i", $list[$i - 2]['debug']);
            $excel->getActiveSheet()->setCellValue("L$i", date('Y-m-d H:i:s', $list[$i - 2]['created_at']));
        }

        //创建Excel输入对象
        ob_clean();
        $write = new \PHPExcel_Writer_Excel5($excel);
        header("Pragma: public");
        header("Expires: 0");
        $filename="recharge_data.xls";
        header("Content-Disposition: attachment;filename=$filename");
        header("Cache-Control:must-revalidate, post-check=0, pre-check=0");
        header("Content-Type:application/force-download");
        header("Content-Type:application/vnd.ms-execl");
        header("Content-Type:application/octet-stream");
        header("Content-Type:application/download");
        header("Content-Transfer-Encoding:binary");
        $write->save('php://output');
    }

    /*
     * 补单
     */
    public function ajax_supply_order(){
        $id = I('post.id', 0);

        $recharge_info = $this->platform_db->table('recharge')->where("id=$id")->find();
        if(!$recharge_info){
            $status = ['status'=>0,'message'=>'订单不存在，请返回重试'];
            $this->ajaxReturn($status);
        }

        $server_info = $this->platform_db->table('server')->where("id=" . $recharge_info['sid'])->find();
        if(!$server_info){
            $status = ['status'=>0,'message'=>'订单服务器不存在，请返回重试'];
            $this->ajaxReturn($status);
        }
        
        //处理发货
        // $send_data = [
        //     'action' => C("ORDER_SEND_ACTION"),
        //     'orderId' => $recharge_info['game_order_id'],
        //     'money' => $recharge_info['money'] * 100,
        //     'payTime' => time(),
        //     'status' => $recharge_info['status'] == 2 ? 2 : 1,
        //     'isTest' => $recharge_info['is_test'],
        //     'platformOrderId' => $recharge_info['game_order_id']
        // ];
        //生成发货的签名
        // $send_data['sign'] = getSign($send_data, $this->send_key);
        // $send_url = "http://" . $server_info['intranet_host'] . ':' . $server_info['http_port'] . C("ORDER_SEND_URL");

        //用curl请求发货
        // $send_url_str = $send_url . '?' . http_build_query($send_data);
        $send_result = pay_to_game($recharge_info['request_url']);

        //修改订单信息    
        if($send_result['repeat'] == 'yes'){    //重复订单
            $status = -11;
        }else{
            $status = $send_result['result'] == 'success' ? 3 : 4;
        }
        $debug = json_encode($send_result['debug']);
        
        $update_data = [
            'status' => $status,
            'server_status' => 1,
            'debug' => $debug,
            // 'request_url' => $request_url,
            'updated_at' => time()
        ];
        if(isset($send_result['debug']['data'])){
            $cp_data = $send_result['debug']['data'];
            if(isset($cp_data['cp_order_id'])){
                $update_data['game_order_id'] = $cp_data['cp_order_id'];
            }
            if(isset($cp_data['level'])){
                $update_data['level'] = $cp_data['level'];
            }
            if(isset($cp_data['vip'])){
                $update_data['vip'] = $cp_data['vip'];
            }
        }
        $res = $this->platform_db->table("recharge")->where("id=" . $recharge_info['id'])->save($update_data);    //更新数据

        if($status == 4){   //发货失败
            $status = ['status'=>0,'message'=>"发货失败：" . $debug . "，请求地址：" . $send_url_str];
            $this->ajaxReturn($status);
        }else{
            $status = ['status'=>1,'message'=>'发货成功'];
            $this->ajaxReturn($status);
        }

        $this->ajaxReturn($status);
    }


    /*游戏库的订单数据*/
    public function GameOrder(){
        //记录搜索条件
        $uid = I('uid', '');
        $role_id = I('role_id', '');
        $role_name = I('role_name', '');
        $sid = I('sid', '0');
        $c_son_id = I('c_son_id', '');
        $product_id = I('product_id', '0');
        $game_order_id = I('game_order_id', '');
        $give_state = I('give_state', '-1');
        $start_time = I('start_time', date('Y-m-d H:i:s', strtotime("-7 day")));
        $end_time = I('end_time', date('Y-m-d H:i:s'));
        $start_time = str_replace("+"," ", $start_time);
        $end_time = str_replace("+"," ", $end_time);

        //获取所有的子渠道
        $channels = M('channel')->where('parent_id!=0')->select();
        $channelss = M('channel')->select();
        $channels_re = [];
        foreach($channelss as $channels_val){
            $channels_re[$channels_val['id']] = $channels_val;
        }
        //获取所有的服务器
        $servers = M('server')->select();

        //获取所有的商品
        $product_list = $this->platform_db->table('product')->select();
        $product_list_re = [];
        foreach($product_list as $product_list_val){
            $product_list_re[$product_list_val['id']] = $product_list_val;
        }
        
        //组建搜索条件的值
        $search_params = [
            'uid' => $uid,
            'role_id' => $role_id,
            'role_name' => $role_name,
            'sid' => $sid,
            'c_son_id' => $c_son_id,
            'product_id' => $product_id,
            'game_order_id' => $game_order_id,
            'give_state' => $give_state,
            'start_time' => $start_time,
            'end_time' => $end_time
        ];

        //判断时间是否都选择
        if(empty($sid)){
            $this->assign(['list'=>[], 'error_msg'=> '请选择服务器！！！', 'count'=>0, 'page'=>'', 'product_list'=> $product_list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
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
            $where .= "and recharge.rid='$role_id' ";
        }
        if(!empty($role_name)){
            $where .= "and role.nick like '%{$role_name}%' ";
        }
        if(!empty($c_son_id)){
            $where .= "and role.place in($c_son_id) ";
        }
        if(!empty($product_id)){
            $where .= "and recharge.product_id in($product_id) ";
        }
        if(!empty($game_order_id)){
            $where .= "and recharge.id=$game_order_id ";
        }
        if($give_state != -1){
            $where .= "and recharge.give_state=$give_state ";
        }
        if(!empty($start_time)){
            $where .= "and recharge.time>=" . strtotime($start_time) . ' ';
        }
        if(!empty($end_time)){
            $where .= "and recharge.time<=" . strtotime($end_time) . ' ';
        }

        $count = $this->game_data_db->table('recharge')
            ->join("left join role on role.id=recharge.rid")
            ->where($where)
            ->count("recharge.id");
        $Page  = new \Think\Page($count, 40);
        $list = $this->game_data_db->table('recharge')
            ->field("
                recharge.rid as role_id,
                role.nick as role_name,
                role.user_id,
                role.place,
                recharge.id,
                recharge.product_id,
                recharge.pre_money,
                recharge.pay_money,
                recharge.give_state,
                recharge.give_time,
                recharge.time
            ")
            ->join("left join role on role.id=recharge.rid")
            ->where($where)
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        foreach($list as &$val){
            //获取渠道名称
            if(isset($channels_re[$val['place']])){
                $val['channel_name'] = $channels_re[$val['place']]['name'];
            }else{
                $val['channel_name'] = '';
            }
            //获取商品名称
            if(isset($product_list_re[$val['product_id']])){
                $val['product_name'] = $product_list_re[$val['product_id']]['product_name'];
            }else{
                $val['product_name'] = '';
            }
            $val['give_time'] = date("Y-m-d H:i:s", $val['give_time']);
            $val['time'] = date("Y-m-d H:i:s", $val['time']);
        }
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'product_list'=> $product_list, 'channels' => $channels, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }
}
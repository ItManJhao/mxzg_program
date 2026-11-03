<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 模拟充值列表
 */
class VirtualRechargeController extends PublicController{
    public function index(){
        //获取所有的服务器
        $servers = $this->platform_db->table('server')->select();
        //获取所有的商品
        $product_list = $this->platform_db->table('product')->select();

        $role_id = I('role_id', '');
        $role_name = I('role_name', '');
        $sid = I('sid', '0');
        $product_id = I('product_id', '0');
        $status = I('status', '-1');

        $where = "1 ";
        if(!empty($role_id)){
            $where .= "and vr.role_id='$role_id'";
        }
        if(!empty($role_name)){
            $where .= "and us.role_name like '%{$role_name}%'";
        }
        if(!empty($sid)){
            $where .= "and vr.sid in($sid) ";
        }
        if(!empty($product_id)){
            $where .= "and vr.product_id in($product_id)";
        }
        if($status != '-1'){
            $where .= "and vr.status=$status";
        }

        $count = M('virtual_recharge')
            ->alias('vr')
            ->join("left join user_server as us on us.role_id=vr.role_id")
            ->join("left join server on server.id=vr.sid")
            ->join("left join product on product.id=vr.product_id")
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,20);
        $list = M('virtual_recharge')
            ->alias('vr')
            ->field('vr.*,us.role_name,server.server_name,product.product_name,product.money,product.dollar_money')
            ->join("left join user_server as us on us.role_id=vr.role_id")
            ->join("left join server on server.id=vr.sid")
            ->join("left join product on product.id=vr.product_id")
            ->where($where)
            ->order('id desc')
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();
        $search_params = [
            'role_id' => $role_id,
            'role_name' => $role_name,
            'sid' => $sid,
            'product_id' => $product_id,
            'status' => $status,
        ];
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'product_list' => $product_list, 'servers' => $servers, 'search_params' => $search_params]);
        $this->display();
    }

    /*模拟充值*/
    public function add(){
        //获取所有的服务器
        $server_list = M('server')->select();
        //获取所有的商品
        $product_list = M('product')->field('*,convert(money/100,decimal(10,2)) as money')->select();
        $this->assign(['server_list' => $server_list, 'product_list' => $product_list]);
        $this->display();
    }

    /*模拟充值*/
    public function ajax_add(){
        $product_id_arr = I('post.product_id', '');    //string(3) "2,3"
        $sid = I('post.sid', '');
        $role_id = I('post.role_id', '');
        $note = I('post.note', '');

        if(empty($sid)){
            $status = ['status'=>0, 'message'=>'请选择服务器'];
            $this->ajaxReturn($status);
        }
        if(empty($role_id)){
            $status = ['status'=>0, 'message'=>'请填写角色id'];
            $this->ajaxReturn($status);
        }
        
        if(empty($product_id_arr)){
            $status = ['status'=>0, 'message'=>'请选择商品'];
            $this->ajaxReturn($status);
        }
        
        $data = [];
        foreach($product_id_arr as $product_ids){
            $product_ids = explode(',', $product_ids);
            foreach($product_ids as $product_id){
                if(!empty($product_id)){
                    $data[] = [
                        'product_id' => $product_id,
                        'role_id' => $role_id,
                        'sid' => $sid,
                        'note' => $note,
                        'created_at' => time()
                    ];
                }
            }
        }
        if(empty($data)){
            $status = ['status'=>0, 'message'=>'请选择商品'];
            $this->ajaxReturn($status);
        }
        $save = M('virtual_recharge')->addAll($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }
        $this->ajaxReturn($status);
    }

    public function product(){
        $product_name = I('product_name', '');
        $where = "1 ";
        if(!empty($product_name)){
            $where .= "and product_name like '%{$product_name}%'";
        }

        $search_params = [
            'product_name' => $product_name,
        ];
        $product = M('product')
            ->where($where)
            ->select();
        $this->assign(['list'=>$product, 'search_params' => $search_params]);
        $this->display();
    }
    /*添加商品*/
    public function addproduct(){
        $this->display();
    }
    /*修改商品*/
    public function editproduct(){
        $id = I('id', '0');
        $product_info = $this->platform_db->table('product')->where("id=$id")->find();
        $this->assign(['product_info' => $product_info]);
        $this->display();
    }

    /*添加商品*/
    public function ajax_addproduct(){
        $id = I('post.id', '');
        $three_product_id = I('post.three_product_id', '');
        $product_name = I('post.product_name', '');
        $goods_id = I('post.goods_id', '');
        $money = I('post.money', '');
        $dollar_money = I('post.dollar_money', '');
        if(empty($id)){
            $status = ['status'=>0, 'message'=>'请输入商品id'];
            $this->ajaxReturn($status);
        }
        if(empty($three_product_id)){
            $status = ['status'=>0, 'message'=>'请输入第三方商品id'];
            $this->ajaxReturn($status);
        }
        if(empty($product_name)){
            $status = ['status'=>0, 'message'=>'请输入商品名称'];
            $this->ajaxReturn($status);
        }
        if(empty($goods_id)){
            $status = ['status'=>0, 'message'=>'请输入商品code'];
            $this->ajaxReturn($status);
        }
        if(empty($money)){
            $status = ['status'=>0, 'message'=>'请输入商品金额'];
            $this->ajaxReturn($status);
        }
        if(empty($dollar_money)){
            $status = ['status'=>0, 'message'=>'请输入商品美金金额'];
            $this->ajaxReturn($status);
        }

        $data = [
            'id' => $id,
            'three_product_id' => $three_product_id,
            'product_name' => $product_name,
            'goods_id' => $goods_id,
            'money' => $money,
            'dollar_money' => $dollar_money,
            'created_at' => time()
        ];

        $save = $this->platform_db->table('product')->add($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }
        $this->ajaxReturn($status);
    }
    /*修改商品*/
    public function ajax_updataproduct(){
        $id = I('post.id', '');
        $product_info = $this->platform_db->table('product')->where("id=$id")->find();
        if(!$product_info){
            $status = ['status'=>0, 'message'=>'商品id出错，请返回重试'];
            $this->ajaxReturn($status);
        }
        $three_product_id = I('post.three_product_id', '');
        $product_name = I('post.product_name', '');
        $goods_id = I('post.goods_id', '');
        $money = I('post.money', '');
        $dollar_money = I('post.dollar_money', '');
        if(empty($three_product_id)){
            $status = ['status'=>0, 'message'=>'请输入第三方商品id'];
            $this->ajaxReturn($status);
        }
        if(empty($product_name)){
            $status = ['status'=>0, 'message'=>'请输入商品名称'];
            $this->ajaxReturn($status);
        }
        if(empty($goods_id)){
            $status = ['status'=>0, 'message'=>'请输入商品code'];
            $this->ajaxReturn($status);
        }
        if(empty($money)){
            $status = ['status'=>0, 'message'=>'请输入商品金额'];
            $this->ajaxReturn($status);
        }
        if(empty($dollar_money)){
            $status = ['status'=>0, 'message'=>'请输入商品美金金额'];
            $this->ajaxReturn($status);
        }

        $data = [
            'three_product_id' => $three_product_id,
            'product_name' => $product_name,
            'goods_id' => $goods_id,
            'money' => $money,
            'dollar_money' => $dollar_money,
        ];
        
        $save = $this->platform_db->table('product')->where("id=$id")->save($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'修改失败'];
        }
        $this->ajaxReturn($status);
    }

    /*上传商品*/
    public function upproduct(){
        $this->display();
    }
    /*上传商品*/
    public function ajax_upproduct(){
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
            // $columnCount = 'D';

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
                'product_name' => $excel_val['note'],
                'goods_id' => $excel_val['code'],
                'three_product_id' => isset($excel_val['three_product_id']) ? $excel_val['three_product_id'] : '',
                'product_type' => $excel_val['kind'],
                'money' => $excel_val['rmb'],
                'dollar_money' => isset($excel_val['dollar']) ? $excel_val['dollar'] : '0.00',
                'created_at' => $now_time,
            ];
        }
        $save = M('product')->addAll($insert_data,[],true);
        if ($save) {
            $status = ['status'=>1,'message'=>'上传商品成功~'];
        }else{
            $status = ['status'=>0,'message'=>'上传商品失败'];
        }
        $this->ajaxReturn($status);
    }
    

    /*批量审核并模拟充值*/
    public function ajax_send(){
        ini_set('max_execution_time', '0');     //设置没有超时限制

        $ids = I('ids', 0);
        $status = I('status', '0');
        if($status == 3){   //审核不通过
            $data_update = [
                'status' => 3,
                'note' => '审核不通过'
            ];
            $res = M('virtual_recharge')->where("id=" . $ids)->save($data_update);
            $status = ['status'=>1,'message'=>'审核不通过成功~'];
            $this->ajaxReturn($status);
        }else{      //审核并模拟充值
            if(!empty($ids)){
                $ids_arr = explode(',', substr($ids,0,-1));
                $error_msg = $this->ajax_send_true($ids_arr);
            }else{
                $status = ['status'=>0,'message'=>'请选择要审核的模拟充值'];
                $this->ajaxReturn($status);
            }
        }
        
        if(!empty($error_msg)){
            $status = ['status'=>0,'message'=>$error_msg];
        }else{
            $status = ['status'=>1,'message'=>'审核成功~'];
        }

        $this->ajaxReturn($status);
    }
    /*审批并模拟充值*/
    public function ajax_send_true($ids){
        $error_msgs = '';
        foreach($ids as $id){
            $error_msg = '';
            $virtual_recharge_info = M('virtual_recharge')
                ->alias('vr')
                ->field('vr.*, server.intranet_host, server.http_port')
                ->join("left join server on server.id=vr.sid")
                ->where('vr.id = ' . $id)
                ->find();
            if(!$virtual_recharge_info){
                $error_msg = '数据id-' . $id . '-：审核失败，原因：非法数据id' . $id . '；';
            }elseif($virtual_recharge_info['status'] != 0){
                $error_msg = '数据id-' . $id . '：审核失败，原因：数据id-' . $id . '-已经审核过；';
            }else{
                //模拟充值
                $send_url = "http://" . $virtual_recharge_info['intranet_host'] . ':' . $virtual_recharge_info['http_port'] . C("VIRTUAL_RECHARGE");
                $send_data = [
                    'rid' => $virtual_recharge_info['role_id'],
                    'productId' => (int)$virtual_recharge_info['product_id']
                ];
                $send_url .= '?' . http_build_query($send_data);
                $result = curlRequest($send_url, $request_type = 'get');
                $result_arr = json_decode($result, true);
                $status = $result_arr['code'];
                $data_update = [
                    'debug' => $result
                ];
            
                if($status != 200){
                    $error_msg = '数据id-' . $id . '-：服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '审核失败，原因：' . $result_arr['msg'] . '；';
                    $data_update['status'] = 2;
                }else{
                    $data_update['status'] = 1;
                }
        
                M('virtual_recharge')->where("id=" . $id)->save($data_update);
            }
            $error_msgs .= $error_msg;
        }
        return $error_msgs;
    }

}
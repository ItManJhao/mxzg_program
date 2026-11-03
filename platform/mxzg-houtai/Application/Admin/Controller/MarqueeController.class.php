<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 跑马灯的配置管理
 */
class MarqueeController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $name = I('name', '');
        $device_type = I('device_type', 0);

        $where = "1 ";
        if(!empty($name)){
            $where .= "and name like '%{$name}%' ";
        }
        if($device_type == 0){
            $where .= "and device_type in(0,1,2)";
        }else{
            $where .= "and device_type in(0,$device_type)";
        }

        $count = M('marquee')
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,20);
        $list = M('marquee')
            ->field('*')
            ->where($where)
            ->order("id desc")
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        $search_params = [
            'name' => $name,
            'device_type' => $device_type,
        ];
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'search_params' => $search_params]);
        $this->display();
    }

    public function add(){
        //获取所有的服务器
        $server_list = M('server')->select();
        $server_list = array_chunk($server_list, 50);
        $this->assign(['server_list' => $server_list]);
        $this->display();
    }

    public function edit(){
        $id = I('id', 0);
        $marquee_info = M('marquee')->where('id = '.$id.'')->find();
        //获取所有的服务器
        $server_list = M('server')->select();
        $server_list = array_chunk($server_list, 50);
        if(isset($marquee_info['sid']) && !empty($marquee_info['sid'])){
            $marquee_info['sid'] = explode(',', $marquee_info['sid']);
        }
        $this->assign(['marquee_info' => $marquee_info, 'server_list' => $server_list]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $params = I('post.');
        $now_time = time();
        if($params['server_ids']){
            $sid = implode(',', $params['server_ids']);
        }else{
            $sid = '';
        }

        $data = [
            'name' => $params['name'],
            'device_type' => $params['device_type'],
            'sid' => $sid,
            'content' => $params['content'],
            'loop_count' => $params['loop_count'],
            'updated_at' => $now_time,
            'created_at' => $now_time,
        ];
        $save = M('marquee')->add($data);

        if ($save) {
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }

        $this->ajaxReturn($status);
    }

    /*更新*/
    public function ajax_updata(){
        $params = I('post.');
        if($params['server_ids']){
            $sid = implode(',', $params['server_ids']);
        }else{
            $sid = '';
        }

        $now_time = time();
        $data = [
            'name' => $params['name'],
            'device_type' => $params['device_type'],
            'sid' => $sid,
            'content' => $params['content'],
            'sort' => $params['sort'],
            'loop_count' => $params['loop_count'],
            'updated_at' => $now_time,
            'created_at' => $now_time,
        ];
        $save = M('marquee')->where("id=" . $params['id'])->save($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'修改失败'];
        }
        $this->ajaxReturn($status);
    }

    /*开启跑马灯*/
    public function ajax_open(){
        $id = I('post.id', 0);
        if(!$id){
            $status = ['status'=>0,'message'=>'参数出错'];
            $this->ajaxReturn($status);
        }
        //获取数据
        $marquee_info = M('marquee')->where('id = '.$id.'')->find();
        if(!$marquee_info){
            $status = ['status'=>0,'message'=>'参数出错'];
            $this->ajaxReturn($status);
        }

        $save = M('marquee')->where("id=" . $id)->save(['status' => 1]);
        $server_ids = $marquee_info['sid'];
        //获取要发送的服务器信息
        $server_list = M('server')
            ->field('*')
            ->where("id in (" . $server_ids . ")")
            ->select();
        //记录发送失败的服务器
        $error_msg = '';
        foreach($server_list as $server_val){
            $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'] . C("MARQUEE_SEND");
            $send_data = [
                'content' => $marquee_info['content'],
                'loopCount' => $marquee_info['loop_count'],
                'platformId' => $marquee_info['id'],
            ];

            $send_url .= '?' . http_build_query($send_data);
            $result = curlRequest($send_url, $request_type = 'get');
            $result_arr = json_decode($result, true);
            $status = $result_arr['code'];

            if($status != 200){
                $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '开启失败，原因：' . $result_arr['msg'] . '；';
            }
        }
        if(!empty($error_msg)){
            $status = ['status'=>0,'message'=>$error_msg];
        }else{
            $status = ['status'=>1,'message'=>'开启成功~'];
        }

        $this->ajaxReturn($status);
    }

    /*关闭跑马灯*/
    public function ajax_close(){
        $id = I('post.id', 0);
        if(!$id){
            $status = ['status'=>0,'message'=>'参数出错'];
            $this->ajaxReturn($status);
        }
        //获取数据
        $marquee_info = M('marquee')->where('id = '.$id.'')->find();
        if(!$marquee_info){
            $status = ['status'=>0,'message'=>'参数出错'];
            $this->ajaxReturn($status);
        }
        $save = M('marquee')->where("id=" . $id)->save(['status' => 0]);
        $server_ids = $marquee_info['sid'];
        //获取要发送的服务器信息
        $server_list = M('server')
            ->field('*')
            ->where("id in (" . $server_ids . ")")
            ->select();
        //记录发送失败的服务器
        $error_msg = '';
        foreach ($server_list as $server_val) {
            $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'] . C("MARQUEE_CANCEL");
            $send_data = [
                'platformId' => $marquee_info['id'],
            ];

            $send_url .= '?' . http_build_query($send_data);
            $result = item($send_url, $request_type = 'get');
            $result_arr = json_decode($result, true);
            $status = $result_arr['code'];

            if ($status != 200) {
                $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '关闭失败，原因：' . $result_arr['msg'] . '；';
            }
        }
        if (!empty($error_msg)) {
            $status = ['status' => 0, 'message' => $error_msg];
        } else {
            $status = ['status' => 1, 'message' => '关闭成功~'];
        }
        $this->ajaxReturn($status);
    }
}
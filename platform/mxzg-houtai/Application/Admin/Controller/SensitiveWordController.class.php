<?php
namespace Admin\Controller;
use Think\Controller;

/*
 * 敏感词管理
 */
class SensitiveWordController extends PublicController{

    /*搜索*/
    public function index(){
        //记录搜索条件
        $sensitive_word = I('sensitive_word', '');

        $where = "1 ";
        if(!empty($sensitive_word)){
            $where .= "and sensitive_word like '%{$sensitive_word}%' ";
        }
        $where .="and status=1 ";

        $count = M('sensitive_word')
            ->where($where)
            ->count();
        $Page  = new \Think\Page($count,20);
        $list = M('sensitive_word')
            ->where($where)
            ->order("id desc")
            ->limit($Page->firstRow.','.$Page->listRows)
            ->select();

        $search_params = [
            'sensitive_word' => $sensitive_word,
        ];
        $this->assign(['list'=>$list,'page'=>$Page->show(),'count'=>$count, 'search_params' => $search_params]);
        $this->display();
    }

    public function add(){
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $sensitive_word = I('post.sensitive_word', '');
        if(empty($sensitive_word)){
            $status = ['status'=>0,'message'=>'请填写敏感词'];
            $this->ajaxReturn($status);
        }
        $now_time = time();
        $sensitive_word_info = M('sensitive_word')->where("sensitive_word='".$sensitive_word."' and status=1")->find();
        if($sensitive_word_info){
            $status = ['status'=>1,'message'=>'敏感词已经存在，请勿重复添加'];
            $this->ajaxReturn($status);
        }

        $data = [
            'sensitive_word' => $sensitive_word,
            'status' => 1,
            'admin_id' => session('admin_user_id'),
            'admin_name' => session('belongs_to'),
            'created_at' => $now_time,
        ];
        $save = M('sensitive_word')->add($data);

        if ($save) {
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }

        $this->ajaxReturn($status);
    }

    /*删除敏感词*/
    public function ajax_delete(){
        $id = I('post.id', 0);
        if(empty($id)){
            $status = ['status'=>0,'message'=>'参数出错，请返回重试'];
            $this->ajaxReturn($status);
        }
        $data_update = [
            'status' => 0,
            'admin_id' => session('admin_user_id'),
            'admin_name' => session('belongs_to'),
        ];
        $save = M('sensitive_word')->where("id=" . $id)->save($data_update);
        if ($save) {
            $status = ['status'=>1,'message'=>'删除成功~'];
        }else{
            $status = ['status'=>0,'message'=>'删除失败'];
        }
        $this->ajaxReturn($status);
    }

    /**
     * 发送敏感词
     */
    public function send(){
        //获取要发送的敏感词
        $sensitive_word_list = M('sensitive_word')->where('status=1')->select();
        $sensitive_word_str = '';
        foreach($sensitive_word_list as $sensitive_word_val){
            $sensitive_word_str .= $sensitive_word_val['sensitive_word'] . ',';
        }
        if(!empty($sensitive_word_str)){
            $sensitive_word_str = substr($sensitive_word_str,0,-1);
        }

        //获取所有的服务器
        $server_list = M('server')->select();
        $server_list = array_chunk($server_list, 50);
        $this->assign(['channels' => $channels, 'server_list' => $server_list, 'sensitive_word_str'=>$sensitive_word_str]);
        $this->display();
    }

    /**
     * 发送敏感词ajax
     */
    public function ajax_send(){
        
        $params = I('post.');
        if($params['server_ids']){
            $sid = implode(',', $params['server_ids']);
        }else{
            $sid = '';
        }
        //获取要发送的敏感词
        $sensitive_word_list = M('sensitive_word')->where('status=1')->select();
        $sensitive_word_str = '';
        foreach($sensitive_word_list as $sensitive_word_val){
            $sensitive_word_str .= $sensitive_word_val['sensitive_word'] . ',';
        }
        if(!empty($sensitive_word_str)){
            $sensitive_word_str = substr($sensitive_word_str,0,-1);
        }

        //获取要发送的服务器信息
        $server_list = M('server')
            ->field('*')
            ->where("id in (" . $sid . ")")
            ->select();
        //记录发送失败的服务器
        $error_msg = '';
        foreach($server_list as $server_val) {
            $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'] . C("SEND_SENSITIVE_WORD");
            $send_data = [
                'words' => $sensitive_word_str,
            ];
            $send_url .= '?' . http_build_query($send_data);
            $result = curlRequest($send_url, $request_type = 'get');
            $result_arr = json_decode($result, true);
            $status = $result_arr['code'];
            if($status != 200){
                $error_msg .= '服务器【' . $server_val['id'] . '】：' . $server_val['server_name'] . '发送失败，原因：' . $result_arr['msg'] . '；';
            }
        }

        $data = [
            'sensitive_words' => $sensitive_word_str,
            'sid' => $sid,
            'debug' => $error_msg,
            'admin_id' => session('admin_user_id'),
            'admin_name' => session('belongs_to'),
            'created_at' => time(),
        ];
        M('send_sensitive_word')->add($data);

        if(!empty($error_msg)){
            $status = ['status'=>0,'message'=>$error_msg];
        }else{
            $status = ['status'=>1,'message'=>'发送成功~'];
        }

        $this->ajaxReturn($status);
    }

    /**
     * 发送敏感词记录
     */
    public function send_log(){
        $list = M('send_sensitive_word')->order("id desc")->select();
        $this->assign(['list'=>$list]);
        $this->display();
    }
}
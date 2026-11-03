<?php
namespace Admin\Controller;
use Think\Controller;
class AdminlistController extends PublicController{

    /*搜索*/
    public function index(){
        $name = I('name', '');
        $belongs_to = I('belongs_to', '');
        $root_name = I('root_name', '');

        $where = "1 ";
        if(!empty($name)){
            $where .= "and bu.name like '%{$name}%' ";
        }
        if(!empty($belongs_to)){
            $where .= "and bu.belongs_to like '%{$belongs_to}%' ";
        }
        if(!empty($root_name)){
            $where .= "and bur.name like '%{$root_name}%' ";
        }

        $list = M("bms_users")
            ->alias('bu')
            ->field('bu.*,bur.name as root_name')
            ->join("left join bms_users_root as bur on bur.id=bu.root_id")
            ->where($where)
            ->order('id asc')
            ->select();
        $search_params = [
            'name' => $name,
            'belongs_to' => $belongs_to,
            'root_name' => $root_name,
        ];
        $this->assign(['list'=>$list, 'search_params' => $search_params]);
        $this->display();
    }

    public function add(){
        $root = M('bms_users_root')->where('status = 1')->order('id asc')->field('id,name')->select();
        $this->assign(['root'=>$root]);
        $this->display();
    }

    public function edit($id=''){
        $re = M('bms_users')->where('id = '.$id.'')->find();
        $root = M('bms_users_root')->where('status = 1')->order('id asc')->field('id,name')->select();
        $this->assign(['re'=>$re,'root'=>$root]);
        $this->display();
    }

    /*添加*/
    public function ajax_add(){
        $data = I('post.');
        $data['password'] = md5(md5($data['password']));
        $data['created_at'] = time();
        $data['updated_at'] = time();
        $save = M('bms_users')->add($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'添加成功~'];
        }else{
            $status = ['status'=>0,'message'=>'添加失败'];
        }
        $this->ajaxReturn($status);
    }

    /*更新*/
    public function ajax_updata(){
        $data = I('post.');
        $data['updated_at'] = time();
        if ($data['password']) {
            $data['password'] = md5(md5($data['password']));
        }else{
            unset($data['password']);
        }
        $save = M('bms_users')->where('id = '.$data['id'].'')->save($data);
        if ($save || $save === 0) {
            $status = ['status'=>1,'message'=>'修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'修改失败'];
        }
        $this->ajaxReturn($status);
    }

    /*修改状态*/
    public function ajax_updata_status(){
        $data = I('post.');
        $save = M('bms_users')->where('id = '.$data['id'].'')->save($data);
        if ($save) {
            $status = ['status'=>1,'message'=>'状态修改成功~'];
        }else{
            $status = ['status'=>0,'message'=>'状态修改失败'];
        }
        $this->ajaxReturn($status);
    }

    /*修改状态*/
    public function ajax_delete(){
        $data = I('post.');
        $delete = M('bms_users')->where('id = '.$data['id'].'')->delete();
        if ($delete) {
            $status = ['status'=>1,'message'=>'管理员删除成功~'];
            // if (!get_val('bms_users','id',session('admin_user_id'),'id')) {
            //     $this->redirect('login/index');
            // }
        }else{
            $status = ['status'=>0,'message'=>'管理员删除失败'];
        }
        $this->ajaxReturn($status);
    }
    
}
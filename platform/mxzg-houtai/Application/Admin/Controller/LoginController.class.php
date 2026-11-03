<?php
namespace Admin\Controller;
use Think\Controller;
class LoginController extends Controller{
    public function index(){
        $this->display();
    }
    public function verify(){
        ob_clean();
        $Verify = new \Think\Verify();
        $Verify->fontSize = 30;
        $Verify->length = 4;
        $Verify->useCurve = false;
        $Verify->useNoise = false;
        $Verify->codeSet = '0123456789';
        $Verify->entry();
    }
    //授权登录
    public function authLogin(){
        $name = $_GET['name'];
        $time = $_GET['time'];
        $sign = $_GET['sign'];
        $now_time = time();
        //验证签名
        $new_sign = md5($name . $time . C("LOGIN_TOKEN_KEY"));
        if(empty($name) || $new_sign != $sign){
            header("Location: " . C("LOGIN_CENTER_URL"));
            exit;
        }
        //判断时间是否超过LOGIN_TOKEN_EXPIRE
        if($now_time > $time + C("LOGIN_TOKEN_EXPIRE")){
            header("Location: " . C("LOGIN_CENTER_URL"));
            exit;
        }

        $condition['bu.name'] = $name;
        $admin_info = M('bms_users')
            ->alias('bu')
            ->field('bu.*,bsr.channels_id,bsr.menu_id')
            ->join("left join bms_users_root as bsr on bsr.id=bu.root_id")
            ->where($condition)->find();
        if (!$admin_info || $admin_info['status'] == 0) {
            $this->redirect('login/index');
        }else{
            session('admin_user_id',$admin_info['id']);
            session('admin_user_name',$admin_info['name']);
            session('belongs_to',$admin_info['belongs_to']);
            session('admin_channels_id',$admin_info['channels_id']);
            session('admin_menu_id',$admin_info['menu_id']);
            session('admin_user_time',time());
            session('logintime',time());
            $this->redirect('index/index');
        }
    }
    public function dologin(){
        M()->startTrans();//开启事务
        try{
            $data = I('post.');
            if(!empty($data['username']) && !empty($data['password'])){
                $condition['bu.name'] = base64_decode($data['username']);
                $condition['bu.password'] = md5(md5(base64_decode($data['password'])));
                $admin_info = M('bms_users')
                    ->alias('bu')
                    ->field('bu.*,bsr.channels_id,bsr.menu_id')
                    ->join("left join bms_users_root as bsr on bsr.id=bu.root_id")
                    ->where($condition)->find();
                if ($admin_info['status'] == 0) {
                   $json = array('status'=>0,'message'=>'用户不存在或被禁用');
                }else{
                    if(is_array($admin_info)){
                        session('admin_user_id',$admin_info['id']);
                        session('belongs_to',$admin_info['belongs_to']);
                        session('admin_channels_id',$admin_info['channels_id']);
                        session('admin_menu_id',$admin_info['menu_id']);
                        session('admin_user_time',time());
                        session('logintime',time());
                        $json = array('status'=>'success','url'=>'/admin.php/index/index');
                    }else{
                        $json = array('status'=>0,'message'=>'账号密码不正确');
                    }
                }
            }
            M()->commit();//提交事务
        }catch(\Exception $ex){
            M()->rollback();//事务回滚
            $json['message'] = $ex->getMessage();
        }
        $this->ajaxReturn($json);
    }

    public function updatepw(){
        $this->display();
    }
    public function ajax_updatepw(){
        $old_password = I('old_password', '');
        $new_password = I('new_password', '');
        $admin_user_id = session('admin_user_id');
        if(empty($old_password)){
            $status = ['status'=>0,'message'=>'请输入旧密码'];
            $this->ajaxReturn($status);
        }
        if(empty($new_password)){
            $status = ['status'=>0,'message'=>'请输入新密码'];
            $this->ajaxReturn($status);
        }
        $Model = M();
        $Model->startTrans();//开启事务
        try{
            $where = [
                'id' => $admin_user_id
            ];
            $admin_info = M('bms_users')->where($where)->find();
            if(!$admin_info){
                throw new \Exception("参数出错，请返回重试");
            }
            if($admin_info['password'] != md5(md5($old_password))){
                throw new \Exception("旧密码验证不通过，请重试");
            }
            $data_update = [
                'password' => md5(md5($new_password)),
                'updated_at' => time()
            ];
            $res = M('bms_users')->where($where)->save($data_update);
            if($res){
                $json = array('status'=>1,'message'=>'修改密码成功','url'=>'/admin.php/login/index');
            }else{
                $json = array('status'=>0,'message'=>'修改密码失败');
            }

            $Model->commit();//提交事务
        }catch(\Exception $ex){
            $json['message'] = $ex->getMessage();
            $Model->rollback();//事务回滚
            
        }
        $this->ajaxReturn($json);
    }

    public function quit(){
        session('admin_user_id',null);
        $this->redirect('login/index');
    }

}
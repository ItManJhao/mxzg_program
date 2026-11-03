<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 服务器心跳管理
 */
class ServerHeartBeatController extends PublicController{
 

    /**
     * 记录服务器的心跳
     */
    public function Record(){
        $retutn = [
            'code' => 0,
            'msg' => ''
        ];
        $sid = I('sid', '0');
        $server_info = $this->platform_db->table('server')->where("id=$sid")->find();
        if(!$server_info){
            $retutn['msg'] = '服务器不存在';
            $this->ajaxReturn($retutn);
        }

        $now_time = time();
        $res = $this->platform_db->table('server')->where("id=$sid")->save(['heart_beat_time' => $now_time]);
        if(!$res){
            $retutn['msg'] = '心跳更新失败';
            $this->ajaxReturn($retutn);
        }
        $retutn = [
            'code' => 1,
            'msg' => '心跳更新成功'
        ];
        $this->ajaxReturn($retutn);
    }

    /**
     * 查询正常运行的服务器的心跳是否停止，停止则发送警告邮件
     */
    public function entry(){
        $now_time = time();
        $check_time = $now_time - 10*60;
        $to_mails = C('MAIL_SERVER_HEART_BEAT');
        // $to_mails = ['360015056@qq.com'];
        //获取正常运行且心跳停止的服务器
        $server_data = $this->platform_db->table('server')
            ->where($this->server_where . " and defend_end_time<$now_time and heart_beat_time<$check_time")
            ->select();

        foreach($server_data as $server_val){
            $mail_title = "暗耀晶石警告邮件";
            $mail_content = "暗耀晶石服务器【" . $server_val['id'] . "--" . $server_val['server_name'] . "】心跳已经停止，请及时处理！！！";
            
            $data_mailbox_log = [
                'mail_title' => $mail_title,
                'mail_content' => $mail_content,
            ];
            foreach($to_mails as $to_mail){
                $data_mailbox_log['to_mail'] = $to_mail;
                $data_mailbox_log['created_at'] = time();
                if(sendMail($to_mail, $mail_title, $mail_content)){
                    $data_mailbox_log['status'] = 1;
                    echo '发送成功！';
                }else{
                    $data_mailbox_log['status'] = 0;
                    echo '发送失败！';
                }
                //记录发送的邮件
                $this->platform_db->table('mailbox_log')->add($data_mailbox_log);
            }
        }

    }

}
<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 测试
 */
class TestController extends PublicController{
 

    public function execTest(){
        // $start = "2020-01-01";
        // $end = "2020-02-28";
        // $start_time = strtotime($start);
        // $end_time = strtotime($end);
        // $days = ($end_time-$start_time)/86400;
        // for($i=0; $i<=$days; $i++){
        //     $date = date('Y-m-d', $start_time + $i * 86400);
        //     echo $date;
        //     echo PHP_EOL;
        //     // system("/usr/local/php/bin/php /home/wwwroot/houtai/cli.php RetainRechargeInterval/entry/date/" . $date . " 2>&1", $output);
        //     // var_dump($output);
        // }
    }

    public function ini(){
        phpinfo();
    }

    public function getTime(){
        echo date('Y-m-d H:i:s');
        echo '<br/>';
        echo time();
        exit;
    }

    public function sendMail() {
        $to_mail = '360015056@qq.com';
        $mail_title = "暗耀晶石警告邮件";
        $mail_content = "暗耀晶石服务器心跳已经停止，请及时处理！！！";
        if(sendMail($to_mail, $mail_title, $mail_content)){
            echo '发送成功！';
        }else{
            echo '发送失败！';
        }
    }
}
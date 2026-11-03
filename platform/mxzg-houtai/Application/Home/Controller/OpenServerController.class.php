<?php
namespace Home\Controller;

use Think\Controller;

/*
 * 定时开服
 */
class OpenServerController extends PublicController{

    /**
     * 自动发送服务器到游戏那边
     */
    public function entry(){

        $now_time = time();
        //查询未开放且开服时间已经到了的服务器
        $servers = $this->platform_db->table('server')
            ->where("status=0 open_time<=$now_time")
            ->select();
        foreach($servers as $server_val){
            //发送开服时间
            $send_url = "http://" . $server_val['intranet_host'] . ':' . $server_val['http_port'] . C("SEND_OPTIME");
            $send_url .= '?time=' . $server_val['open_time'];
            $result = curlRequest($send_url, $request_type = 'get');
            $result_arr = json_decode($result, true);
            $status = $result_arr['code'];
            if ($status == 200) {
                //修改服务器状态为流畅
                $this->platform_db->table('server')
                    ->where('id=' . $server_val['id'])
                    ->save(['status' => 2]);
                $msg = '开服成功！！！';
            }else{
                $msg = '开服失败！！！';
            }

            echo "服务器" . $server_val['server_name'] . "[" . $server_val['id'] . "]" . $msg;
        }
    }

    /**
     * 根据服务器的创角阈值自动开服下一个服务器
     */
    public function limitOpenServer(){
        //查询所有渠道
        $channels = $this->platform_db->table('channel')
            ->where($this->channel_where)
            ->select();
        $now_time = time();
        foreach($channels as $channel_val){
            //查询渠道推荐的服务器
            $server_channel = $this->platform_db->table('server_channel')
                ->alias('sc')
                ->field('sid')
                ->join("left join server on server.id=sc.sid")
                ->where("server.status>0 and server.is_new=1 and sc.c_son_id=" . $channel_val['id'])
                ->order("sort desc")
                ->find();
            if($server_channel){
                //验证渠道推荐的服务器是否已经达到阈值
                $server_info = $this->platform_db->table('server')
                    ->where("id=" . $server_channel['sid'] . " and role_nums>=role_nums_limit and role_nums_limit>0")
                    ->find();
                if($server_info){   //达到创角阈值，开启新服
                    $server_channel = $this->platform_db->table('server_channel')
                        ->alias('sc')
                        ->field('server.*')
                        ->join("left join server on server.id=sc.sid")
                        ->where("server.status=0 and server.is_new=1 and server.type=0 and sc.c_son_id=" . $channel_val['id'])
                        ->order("sort asc")
                        ->find();
                    if($server_channel){    //有数据则开启新服务器
                        //发送开服时间
                        $send_url = "http://" . $server_channel['intranet_host'] . ':' . $server_channel['http_port'] . C("SEND_OPTIME");
                        $send_url .= '?time=' . $now_time;
                        $result = curlRequest($send_url, $request_type = 'get');
                        $result_arr = json_decode($result, true);
                        $status = $result_arr['code'];
                        if ($status == 200) {
                            //修改服务器状态为流畅
                            $this->platform_db->table('server')
                                ->where('id=' . $server_channel['id'])
                                ->save(['open_time' => $now_time, 'status' => 2]);
                            //修改前一个服务器状态为爆满
                            $this->platform_db->table('server')
                                ->where('id=' . $server_info['id'])
                                ->save(['status' => 1]);
                            $msg = '开服成功！！！';
                        }else{
                            $msg = '开服失败！！！';
                        }

                        echo "服务器" . $server_channel['server_name'] . "[" . $server_channel['id'] . "]" . $msg;

                    }
                }
                
            }
            //修改最老的服务器为不是新服
            //查询渠道推荐的服务器
            $server_channel_data = $this->platform_db->table('server_channel')
                ->alias('sc')
                ->field('sid')
                ->join("left join server on server.id=sc.sid")
                ->where("server.status>0 and server.is_new=1 and type=0 and sc.c_son_id=" . $channel_val['id'])
                ->order("sort asc")
                ->select();
            $count = count($server_channel_data);
            if($count > 6){
                $this->platform_db->table('server')
                    ->where('id=' . $server_channel_data[0]['sid'])
                    ->save(['is_new' => 0]);
            }
        }
    }

    /**
     * 根据服务器的创角数是否发送警报邮件
     */
    public function OpenServerMail(){
        $to_mails = C('MAIL_SERVER_WARNING');
        //获取服务器创角阈值
        $global_config = $this->platform_db->table('global_config')
            ->find();
        if($global_config && !empty($global_config['role_nums_limit'])){
            //查询所有渠道
            $channels = $this->platform_db->table('channel')
                ->where($this->channel_where)
                ->select();
            $now_time = time();
            foreach($channels as $channel_val){
                //查询渠道推荐的服务器
                $server_channel = $this->platform_db->table('server_channel')
                    ->alias('sc')
                    ->field('sid,show_name')
                    ->join("left join server on server.id=sc.sid")
                    ->where("server.status>0 and server.is_new=1 and sc.c_son_id=" . $channel_val['id'])
                    ->order("sort desc")
                    ->find();
                if($server_channel){
                    //验证渠道推荐的服务器是否已经达到阈值
                    $server_info = $this->platform_db->table('server')
                        ->where("id=" . $server_channel['sid'] . " and role_nums>=" . $global_config['role_nums_limit'])
                        ->find();
                    if($server_info){       //发送警报短信
                        $mail_title = "暗耀晶石警告邮件";
                        $mail_content = "暗耀晶石服务器【" . $server_channel['sid'] . "--" . $server_channel['show_name'] . "】注册玩家达到【" . $server_info['role_nums'] . "】已超阈值【" . $global_config['role_nums_limit'] . "】，达到超负荷运行，请及时处理！！！";
                        
                        foreach($to_mails as $to_mail){
                            if(sendMail($to_mail, $mail_title, $mail_content)){
                                echo '发送成功！';
                            }else{
                                echo '发送失败！';
                            }
                        }
                    }
                }
            }
        }
        
    }


}
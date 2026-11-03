<?php
namespace app\controller;

class Platform extends \core\lss {

    protected $limit;
    function  __construct() {
        parent::__construct();
        $this->limit = 100;
    }

    public function test(){
        operateParam();
        var_dump($_REQUEST);
        $c_id = $this->getParam('open_id');
        var_dump($c_id);
        exit;
    }

    // 公告列表
    public function notice() {
        decryptParam();     //base64解密参数
        $language = $this->getParam('language', '');
        $c_id = $this->getParam('c_id');
        $c_son_id = $this->getParam('c_son_id');
        $uid = $this->getParam('uid');
        $device_type = $this->getParam('device_type', 0);

        $now_time = time();
        $where_str = "where start_time<$now_time and end_time>$now_time ";
        if(!empty($c_son_id)){
            $where_str .= "and find_in_set($c_son_id, c_son_id) ";
        }else{
            encryptOut([], '参数错误，请稍后再试', 10001);
        }
        if($device_type == 0){
            $where_str .= "and device_type in(0,1,2,3) ";
        }else{
            $where_str .= "and device_type in(0,$device_type) ";
        }

        //东南亚加上语言参数，拿不同语言的公告
        if(empty($language)){
            $language .= "all";     //默认公告（通用公告）
        }
        $where_language = "and language='$language' ";
        $this->db->db_tabel('notice');
        $field = "
            label,content
        ";
        $this->db->db_order('sort desc,updated_at desc');
        $ret = $this->db->db_find($field, $where_str . $where_language);
        if(!$ret){      //拿不到公告数据，拿通用公告
            $where_language = "and language='all' ";
            $ret = $this->db->db_find($field, $where_str . $where_language);
        }
        if(isset($ret['content']) && !empty($ret['content'])){
            $content = $ret['content'];
            $content = str_replace("\r\n", "\\r\\n", $content);
            $content = str_replace("\\/", "/", $content);
            $content = str_replace("\"", "\'", $content);
            $ret['content'] = $content;
        }

        encryptOut($ret,'ok',200,1);
    }
    
    // 获取玩家初始服务器信息
    public function getUserServer() {
        decryptParam();     //base64解密参数
        $channel = $this->getParam('channel', '');
        $open_id = $this->getParam('open_id');
        $c_id = $this->getParam('c_id');
        $c_son_id = $this->getParam('c_son_id');
        $device_type = $this->getParam('device_type', 0);
        $uuid = $this->getParam('uuid');
        $is_test = $this->getParam('is_test', 0);   //是否是测试
        $package_version = $this->getParam('package_version', 0);   //包版本，用来获取是否已过审
        $ip = get_ip();  //获取ip

        if($is_test == 0){
            //校验登录(2020-04-07-lby：新加的逻辑，应对港台东南亚韩国等sdk做的)
            if(!empty($channel)){
                $platform = $channel;  //获取平台英文小写
            }else{
                $platform = $this->getPlatform();  //获取平台英文小写
            }
            
            if(!empty($platform)){
                $sdk_class = "SDK{$platform}";
                $sdk_obj = $this->loadSDK($sdk_class);
                if(!$sdk_obj){
                    encryptOut([], '参数错误，请稍后再试', 10001);
                }
                $ret = $sdk_obj->checkLogin();
                if($ret['code'] == 0){
                    encryptOut([], $ret['msg'], 10001);
                }
            }else{
                encryptOut([], '未知平台', 10001);
            }
        }

        $where_str = 'where 1 ';
        if(!empty($open_id)){
            $where_str .= "and open_id='$open_id' ";
        }else{
            encryptOut([], '参数错误，请稍后再试', 10001);
        }
        if(!empty($c_id)){
            $where_str .= "and c_id=$c_id ";
        }else{
            encryptOut([], '参数错误，请稍后再试', 10001);
        }

        $where_device_type = '';
        if($device_type == 0){
            $where_device_type .= "and sc.device_type in(0,1,2,3) ";
        }else{
            $where_device_type .= "and sc.device_type in(0,$device_type) ";
        }

        //2020-9-16-lby：东南亚加上语言参数来
        $language = $this->getParam('language', '');
        $where_language = '';
        if(!empty($language)){
            if(in_array($language, ['idn', 'en'])){
                $language = 'cn_trad';
            }
            $where_language = "and server.language='$language' ";
        }

        $now_time = time();
        try {
            $this->db->begin();     //开始mysqli事务

            //获取用户信息
            $sql = "
                select * 
                from user
                $where_str
            ";
            $user_data = $this->db->db_sql($sql);

            if(empty($user_data)){      //新用户，要创建账号
                $keyarr = [
                    'open_id','c_id','c_son_id','device_type','uuid','created_at'
                ];
                $valuearr = [
                    "'$open_id'",$c_id,$c_son_id,$device_type,"'$uuid'",time()
                ];
                $this->db->db_tabel('user');
                $uid = $this->db->db_insert($keyarr, $valuearr);    //插入数据，获取主键uid
                $uid = (string)$uid;    //转换为字符串
                $server_data = '';
            }else{      //用户已经存在

                $uid = $user_data[0]['id'];
                

                $last_login_sid = $user_data[0]['last_login_sid'];
                //加入不是白名单不能看到未开放的服
                // if($is_white == 0){
                //     $where_white = " and sc.sid=$last_login_sid and server.status>0";
                // }else{
                //     $where_white = " and sc.sid=$last_login_sid ";
                // }
                $where_white = " and sc.sid=$last_login_sid ";
                //查询用户在用的区服信息
                $sql = "
                    select server.extranet_host as server_url,server.game_port as server_port,server.is_new,server.msg,sc.sid,server.status as server_status,server.defend_end_time,sc.show_name
                    from server 
                    left join server_channel as sc on sc.sid=server.id
                    where sc.c_son_id=$c_son_id $where_white
                    limit 1
                ";
                $server_data = $this->db->db_sql($sql);
            }

            //判断open_id和ip是否在白名单
            $is_white = '0';    //是否为白名单
            $sql = "
                select * 
                from white_list
                where (uid='" . $uid . "' or ip='$ip') and status=1
            ";
            $white_data = $this->db->db_sql($sql);
            if($white_data){    //在白名单
                $is_white = 1;
            }

            //白名单可以看到所有服务器，不是白名单要看版本号来查询服务器
            $where_server = '';
            $this->db->db_tabel('channel_version');
            if($is_white == 0 && !empty($package_version)){
                $channel_version = $this->db->db_find('*', "where c_son_id=$c_son_id and package_version='$package_version'");
                if($channel_version){
                    if($channel_version['is_past'] == 1){   //查询正式服数据
                        $where_server .= " and server.type=0 ";
                    }else{                                  //查询审核服数据
                        $where_server .= " and server.type=2 ";
                    }
                }
            }
            if(!$server_data){
                //获取一个推荐的服务器
                $sql = "
                    select server.extranet_host as server_url,server.game_port as server_port,server.is_new,server.msg,sc.sid,server.status as server_status,server.defend_end_time,sc.show_name
                    from server_channel as sc
                    left join server on server.id=sc.sid
                    where sc.c_son_id=$c_son_id $where_device_type $where_language $where_server
                    and is_new=1 and server.status>0
                    order by sc.sort desc 
                    limit 1
                ";
                $server_data = $this->db->db_sql($sql);
            }

            //如果没有服务器，则查询繁体的服务器
            $where_language = "and server.language='cn_trad' ";
            if(!$server_data){
                //获取一个推荐的服务器
                $sql = "
                    select server.extranet_host as server_url,server.game_port as server_port,server.is_new,server.msg,sc.sid,server.status as server_status,server.defend_end_time,sc.show_name
                    from server_channel as sc
                    left join server on server.id=sc.sid
                    where sc.c_son_id=$c_son_id $where_device_type $where_language $where_server
                    and is_new=1 and server.status>0
                    order by sc.sort desc 
                    limit 1
                ";
                $server_data = $this->db->db_sql($sql);
            }

            if($server_data){
                $return_data = [
                    'uid' => $uid,
                    'server_url' => $server_data[0]['server_url'],
                    'server_port' => $server_data[0]['server_port'],
                    'defend_end_time' => $server_data[0]['defend_end_time'],
                    'show_name' => $server_data[0]['show_name'],
                    'is_new' => $server_data[0]['is_new'],
                    'msg' => $server_data[0]['msg'],
                    'sid' => $server_data[0]['sid'],
                    'server_status' => $server_data[0]['server_status'],
                    'is_white' => $is_white,
                    'time' => $now_time
                ];

            }else{
                $return_data = [
                    'uid' => $uid,
                    'is_white' => $is_white,
                    'time' => $now_time
                ];
            }

            //获取用户的总在线时长
            $sql = "
                select sum(online_time) as all_online_time,sum(today_online_time) as all_today_online_time 
                from user_server as us 
                where user_id='$uid' 
                group by user_id 
                limit 1
            ";
            $user_server_all = $this->db->db_sql($sql);
            if($user_server_all){
                $return_data['online_time'] = $user_server_all[0]['all_online_time'];
                $return_data['today_online_time'] = $user_server_all[0]['all_today_online_time'];
            }else{
                $return_data['online_time'] = '';
                $return_data['today_online_time'] = '';
            }

            $this->db->commit();         //提交mysqli事务
        } catch (\Exception $e) {
            $this->db->rollBack();         //回滚mysqli事务
            encryptOut(array(),$e->getMessage(),$e->getcode());
        }

        if(!$return_data){
            encryptOut([]);
        }
        //生成sign签名
        $sign_data = [
            'uid' => $uid,
            'time' => $now_time
        ];
        $return_data['sign'] = md5($now_time . $uid . $this->platform_data['send_key']);
        encryptOut($return_data,'ok',200,1);
    }

    // 记录玩家登陆服务器信息
    public function login() {
        decryptParam();     //base64解密参数
        $uid = $this->getParam('uid');
        $c_id = $this->getParam('c_id');
        $c_son_id = $this->getParam('c_son_id');
        $sid = $this->getParam('sid');
        $ip = get_ip();  //获取ip

        $where_str = 'where 1 ';
        if(!empty($uid)){
            $where_str .= "and id=$uid ";
        }else{
            encryptOut([], 'uid:参数错误，请稍后再试', 10001);
        }
        if(empty($sid)){
            encryptOut([], 'sid:参数错误，请稍后再试', 10001);
        }
        $is_white = 0;
        $now_time = time();
        try {
            $this->db->begin();     //开始mysqli事务
            //判断uid和ip是否在白名单
            $sql = "
                select * 
                from white_list
                where (uid='" . $uid . "' or ip='$ip') and status=1
            ";
            $white_data = $this->db->db_sql($sql);
            if($white_data){    //在白名单
                $is_white = 1;
            }

            //获取用户信息
            $sql = "
                select * 
                from user
                $where_str
            ";
            $user_data = $this->db->db_sql($sql);
            if(!$user_data){
                throw new \Exception("玩家不存在或网络异常，请稍后再试", 10002);
            }

            //更新玩家登陆服务器信息
            if($user_data[0]['last_login_time'] == 0){
                $login_days = 1;
            }elseif(date('Y-m-d', $user_data[0]['last_login_time']) != date('Y-m-d')){
                $login_days = $user_data[0]['login_days'] + 1;
            }else{
                $login_days = $user_data[0]['login_days'];
            }
            $update_data = [
                'last_login_sid' => $sid,
                'last_login_time' => time(),
                'login_days' => $login_days
            ];
            $this->db->db_tabel('user');
            $res = $this->db->db_update($update_data,$where_str);    //更新数据

            //获取返回数据
            $sql = "
                select server.extranet_host as server_url,server.game_port as server_port,server.server_name,server.is_new,server.msg,sc.sid,server.status as server_status,server.defend_end_time,sc.show_name
                from server_channel as sc
                left join server on server.id=sc.sid
                where sc.c_son_id=$c_son_id and sid=$sid 
                limit 1
            ";
            $server_data = $this->db->db_sql($sql);
            $return_data = [
                'uid' => $uid,
                'server_url' => $server_data[0]['server_url'],
                'server_port' => $server_data[0]['server_port'],
                'defend_end_time' => $server_data[0]['defend_end_time'],
                'show_name' => $server_data[0]['show_name'],
                'is_new' => $server_data[0]['is_new'],
                'msg' => $server_data[0]['msg'],
                'sid' => $server_data[0]['sid'],
                'server_status' => $server_data[0]['server_status'],
                'is_white' => $is_white,
                'time' => $now_time
            ];

            //获取用户的总在线时长
            $sql = "
                select sum(online_time) as all_online_time,sum(today_online_time) as all_today_online_time 
                from user_server as us 
                where user_id='$uid' 
                group by user_id 
                limit 1
            ";
            $user_server_all = $this->db->db_sql($sql);
            if($user_server_all){
                $return_data['online_time'] = $user_server_all[0]['all_online_time'];
                $return_data['today_online_time'] = $user_server_all[0]['all_today_online_time'];
            }else{
                $return_data['online_time'] = '';
                $return_data['today_online_time'] = '';
            }
                
            $this->db->commit();         //提交mysqli事务
        } catch (\Exception $e) {
            $this->db->rollBack();         //回滚mysqli事务
            encryptOut(array(),$e->getMessage(),$e->getcode());
        }
        encryptOut($return_data,'ok',200,1);
    }

    // 记录玩家角色服务器信息
    public function recordRole() {
        // decryptParam();     //base64解密参数
        $c_son_id = $this->getParam('c_son_id', 0);
        $user_id = $this->getParam('user_id');
        $role_id = $this->getParam('role_id');
        $role_name = $this->getParam('role_name');
        $sid = $this->getParam('sid');
        $fighting = $this->getParam('fighting');
        $vip = $this->getParam('vip');
        $level = $this->getParam('level');
        $totalRecharge = $this->getParam('totalRecharge', 0);
        $headId = $this->getParam('headId');
        $borderId = $this->getParam('borderId');
        $online_time = $this->getParam('online_time', 0);
        $today_online_time = $this->getParam('today_online_time', 0);
        $gem = $this->getParam('gem', 0);

        $where_str = 'where 1 ';
        
        try {

            if(!empty($user_id)){
                $where_str .= "and id='$user_id' ";
            }else{
                throw new \Exception("user_id参数错误，请稍后再试", 10001);
            }
            if(empty($sid)){
                throw new \Exception("sid参数错误，请稍后再试", 10001);
            }
            if(empty($role_id)){
                throw new \Exception("role_id参数错误，请稍后再试", 10001);
            }

            //获取渠道信息
            $sql = "
                select * 
                from channel
                where id=$c_son_id
            ";
            $channel_data = $this->db->db_sql($sql);
            if(!$channel_data){
                throw new \Exception("c_son_id参数错误，请稍后再试", 10001);
            }
            $channel_data = $channel_data[0];
            $this->db->begin();     //开始mysqli事务
            
            //获取用户信息
            $sql = "
                select * 
                from user
                $where_str
            ";
            $user_data = $this->db->db_sql($sql);
            if(!$user_data){
                throw new \Exception("玩家不存在或网络异常，请稍后再试", 10002);
            }

            //判断玩家角色信息是否存在
            $sql = "
                select * 
                from user_server
                where role_id=$role_id
            ";
            $role_info = $this->db->db_sql($sql);
            if(!$role_info){    //添加数据
                $keyarr = [
                    'role_id','c_id','c_son_id','user_id','sid','role_name','fighting','vip','level','total_recharge','created_at','last_update_time','head_id','border_id','online_time','today_online_time','gem'
                ];
                $valuearr = [
                    $role_id,"'{$channel_data['parent_id']}'","'$c_son_id'","'$user_id'",$sid,"'$role_name'","'$fighting'","'$vip'","'$level'","'$totalRecharge'",time(),time(),"'$headId'","'$borderId'","'$online_time'","'$today_online_time'","'$gem'"
                ];
                $this->db->db_tabel('user_server');
                $uid = $this->db->db_insert($keyarr, $valuearr);    //插入数据，获取主键uid

                //给服务器注册数加1
                $field_arr = [
                    'role_nums'
                ];
                $this->db->db_tabel('server');
                $this->db->db_add_one($field_arr, "where id=$sid");    //更新数据

            }else{      //修改数据
                $update_data = [
                    'role_name' => $role_name,
                    'fighting' => $fighting,
                    'vip' => $vip,
                    'level' => $level,
                    'total_recharge' => $totalRecharge,
                    'last_update_time' => time(),
                    'head_id' => $headId,
                    'border_id' => $borderId,
                    'online_time' => $online_time,
                    'today_online_time' => $today_online_time,
                    'gem' => $gem,
                ];
                $this->db->db_tabel('user_server');
                $res = $this->db->db_update($update_data, "where role_id=$role_id");    //更新数据
            }

            $this->db->commit();         //提交mysqli事务
        } catch (\Exception $e) {
            $this->db->rollBack();         //回滚mysqli事务
            // encryptError($e->getMessage(),$e->getcode());
            error($e->getMessage(),$e->getcode());
        }
        // encryptSuccess();
        success();
    }

    // 更新角色的邀请人
    public function setInviteRole() {
        // decryptParam();     //base64解密参数
        $invite_rid = $this->getParam('invite_rid', 0); //邀请人角色id
        $role_id = $this->getParam('role_id', 0);    //被邀请人角色id

        
        try {
            if(empty($invite_rid)){
                throw new \Exception("邀请人不能为空", 1);
            }

            if(empty($role_id)){
                throw new \Exception("被邀请人不能为空", 2);
            }
            $this->db->begin();     //开始mysqli事务
            //获取邀请人的角色信息
            $this->db->db_tabel('user_server');
            $invite_info = $this->db->db_find('*', "where role_id='$invite_rid'");
            if(!$invite_info){
                throw new \Exception("邀请人不存在", 3);
            }

            //获取被邀请人的角色信息
            $role_info = $this->db->db_find('*', "where role_id='$role_id'");
            if(!$role_info){
                throw new \Exception("被邀请人不存在", 4);
            }

            if($role_info['invite_rid'] > 0){
                throw new \Exception("被邀请人的邀请人已经存在", 5);
            }

            //判断是否是互相邀请，互相邀请就不允许的
            if($invite_info['invite_rid'] > 0 && $invite_info['invite_rid'] == $role_id){
                throw new \Exception("邀请人与被邀请人不能互相邀请", 6);
            }

            //更新邀请人
            $update_data = [
                'invite_rid' => $invite_rid,
            ];
            $res = $this->db->db_update($update_data, "where role_id='$role_id'");    //更新数据

            $this->db->commit();         //提交mysqli事务
        } catch (\Exception $e) {
            $this->db->rollBack();         //回滚mysqli事务
            // encryptError($e->getMessage(),$e->getcode());
            error($e->getMessage(),$e->getcode());
        }
        // encryptSuccess('设置邀请人成功');
        success('设置邀请人成功');
    }

    // 获取邀请的角色数据
    public function getInviteRoles() {
        // decryptParam();     //base64解密参数
        $invite_rid = $this->getParam('invite_rid', 0);

        $where_str = 'where 1 ';
        if(!empty($invite_rid)){
            $where_str .= "and invite_rid=$invite_rid ";
        }else{
            // encryptOut([]);
            out([]);
        }

        $sql = "
            select * 
            from user_server
            $where_str
        ";
        $role_data = $this->db->db_sql($sql);
        // encryptOut($role_data);
        out($role_data);
    }

    // 获取所有大区数据
    public function serverAll() {
        decryptParam();     //base64解密参数
        $c_id = $this->getParam('c_id');
        $c_son_id = $this->getParam('c_son_id');

        $where_str = 'where 1 ';
        if(!empty($c_son_id)){
            $where_str .= "and c_son_id=$c_son_id ";
        }else{
            encryptOut([], '参数错误，请稍后再试', 10001);
        }

        $sql = "
            select * 
            from big_server
            $where_str
        ";
        $big_server_data = $this->db->db_sql($sql);
        encryptOut($big_server_data,'ok',200,1);
    }

    // 获取用户服务器角色信息
    public function serverRole() {
        decryptParam();     //base64解密参数
        $uid = $this->getParam('open_id');
        $c_son_id = $this->getParam('c_son_id');

        //查询最后登录的服务器
        $this->db->db_tabel('user');
        $user_info = $this->db->db_find('*', "where id=$uid");
        if(!$user_info){
            encryptOut([], '参数错误，请稍后再试', 10001);
        }
        $last_login_sid = $user_info['last_login_sid'];

        $where_str = 'where 1 ';
        if(!empty($uid)){
            $where_str .= "and us.user_id='$uid' ";
        }else{
            encryptOut([], '参数错误，请稍后再试', 10001);
        }
        if(!empty($c_son_id)){
            $where_str .= "and sc.c_son_id=$c_son_id ";
        }else{
            encryptOut([], '参数错误，请稍后再试', 10001);
        }

        //2020-9-16-lby：东南亚加上语言参数
        // $language = $this->getParam('language', '');
        // if(!empty($language)){
        //     $where_str .= "and server.language='$language' ";
        // }

        $sql = "
            select server.extranet_host as server_url,server.game_port as server_port,server.is_new,server.msg,server.id as sid,server.status as server_status,server.defend_end_time,sc.show_name,sc.sort,us.role_name,us.level,us.head_id,us.border_id
            from user_server as us 
            left join server on server.id=us.sid 
            left join server_channel as sc on server.id=sc.sid
            $where_str
        ";
        $user_server_data = $this->db->db_sql($sql);
        if(!$user_server_data){
            encryptOut([]);
        }
        foreach($user_server_data as &$user_server_val){
            if(!empty($last_login_sid) && $user_server_val['sid'] == $last_login_sid){
                $user_server_val['is_last_login'] = 1;
            }else{
                $user_server_val['is_last_login'] = 0;
            }
        }
        encryptOut($user_server_data,'ok',200,1);
    }

    // 获取最新推荐的服务器数据
    public function serverNew() {
        decryptParam();     //base64解密参数
        $c_id = $this->getParam('c_id');
        $c_son_id = $this->getParam('c_son_id');
        $package_version = $this->getParam('package_version', 0);
        $device_type = $this->getParam('device_type', 0);
        $uid = $this->getParam('uid');
        $ip = get_ip();  //获取ip

        $new_time = time();
        $where_str = 'where 1 ';
        if(!empty($c_son_id)){
            $where_str .= "and sc.c_son_id=$c_son_id ";
        }else{
            encryptOut([], '参数错误，请稍后再试', 10001);
        }
        $where_str .= "
            and server.is_new=1 
        ";

        if($device_type == 0){
            $where_str .= "and sc.device_type in(0,1,2,3) ";
        }else{
            $where_str .= "and sc.device_type in(0,$device_type) ";
        }

        //判断open_id和ip是否在白名单
        $sql = "
            select * 
            from white_list
            where (uid='" . $uid . "' or ip='$ip') and status=1
        ";
        $white_data = $this->db->db_sql($sql);
        if(!$white_data){    //不在白名单，只显示开放的服务器
            $where_str .= "and server.status>0 ";
        }
        //白名单可以看到所有服务器，不是白名单要看版本号来查询服务器
        $where_server = '';
        $this->db->db_tabel('channel_version');
        if(!$white_data && !empty($package_version)){
            $channel_version = $this->db->db_find('*', "where c_son_id=$c_son_id and package_version='$package_version'");
            if($channel_version){
                if($channel_version['is_past'] == 1){   //查询正式服数据
                    $where_server .= " and server.type=0 ";
                }else{                                  //查询审核服数据
                    $where_server .= " and server.type=2 ";
                }
            }
        }

        $sql = "
            select server.extranet_host as server_url,server.game_port as server_port,server.is_new,server.msg,server.id as sid,server.status as server_status,server.defend_end_time,server.open_time,server.language,sc.show_name,sc.sort
            from server_channel as sc 
            left join server on server.id=sc.sid
            $where_str $where_server
            order by sc.sort desc 
        ";
        $server_data = $this->db->db_sql($sql);
        if(!$server_data){
            encryptOut([]);
        }
        $is_update = [];
        foreach($server_data as &$server_val){
            if(!isset($is_update[$server_val['language']]) && $server_val['is_new'] == 1){
                $server_val['is_commend'] = 1;  //是否推荐
                $is_update[$server_val['language']] = 1;
                // $is_update = 1;
            }else{
                $server_val['is_commend'] = 0;
            }
        }
        encryptOut($server_data,'ok',200,1);
    }

    // 获取服务器分页数据
    public function serverPage() {
        decryptParam();     //base64解密参数
        $c_id = $this->getParam('c_id');
        $c_son_id = $this->getParam('c_son_id');
        $package_version = $this->getParam('package_version', 0);
        $device_type = $this->getParam('device_type', 0);
        $big_server_id = $this->getParam('big_server_id', 0);
        $uid = $this->getParam('uid', 0);
        $ip = get_ip();  //获取ip

        $where_str = 'where 1 ';
        if(!empty($c_son_id)){
            $where_str .= "and sc.c_son_id=$c_son_id ";
        }else{
            encryptOut([], '参数错误，请稍后再试', 10001);
        }
        if(empty($big_server_id)){
            encryptOut([], '参数错误，请稍后再试', 10001);
        }
        $where_str .= "
            and sc.big_server_id=$big_server_id
        ";
        if($device_type == 0){
            $where_str .= "and sc.device_type in(0,1,2,3) ";
        }else{
            $where_str .= "and sc.device_type in(0,$device_type) ";
        }

        //判断open_id和ip是否在白名单
        $sql = "
            select * 
            from white_list
            where (uid='" . $uid . "' or ip='$ip') and status=1
        ";
        $white_data = $this->db->db_sql($sql);
        if(!$white_data){    //不在白名单，只显示开放的服务器
            $where_str .= "and server.status>0 ";
        }
        //白名单可以看到所有服务器，不是白名单要看版本号来查询服务器
        $where_server = '';
        $this->db->db_tabel('channel_version');
        if(!$white_data && !empty($package_version)){
            $channel_version = $this->db->db_find('*', "where c_son_id=$c_son_id and package_version='$package_version'");
            if($channel_version){
                if($channel_version['is_past'] == 1){   //查询正式服数据
                    $where_server .= " and server.type=0 ";
                }else{                                  //查询审核服数据
                    $where_server .= " and server.type=2 ";
                }
            }
        }

        $sql = "
            select server.extranet_host as s_u,server.game_port as s_p,server.is_new,server.msg,server.id as sid,server.status as s_s,server.defend_end_time as det,sc.show_name as s_name,sc.sort
            from server_channel as sc 
            left join server on server.id=sc.sid
            $where_str $where_server
            order by sc.sort desc 
        ";
        $server_data = $this->db->db_sql($sql);
        $is_update = 0;
        foreach($server_data as &$server_val){
            if($is_update == 0 && $server_val['is_new'] == 1){
                $server_val['is_comd'] = 1;
                $is_update = 1;
            }
            // else{
            //     $server_val['is_comd'] = 0;
            // }
            //2020-06-09-lby：整理返回数据，去除不必要的默认数据，精简字段
            //"is_new": "0", "msg": "","defend_end_time": "0","is_commend": 0
            if(empty($server_val['is_new'])){
                unset($server_val['is_new']);
            }
            if($server_val['det'] <= time()){
                unset($server_val['msg']);
            }
        }

        //2020-07-14-lby：增加是否开启服务器爆满状态时禁止新用户进入游戏
        $this->db->db_tabel('global_config');
        $this->db->db_order('id desc');
        $global_config_info = $this->db->db_find('*');
        if($global_config_info){
            $is_server_full_tip = $global_config_info['is_server_full_tip'];
        }else{
            $is_server_full_tip = 0;
        }
        $res_data = [
            'big_server_id' => $big_server_id,
            'is_server_full_tip' => $is_server_full_tip,
            'data' => $server_data ? $server_data : []
        ];
        encryptOut($res_data,'ok',200,1);
    }

    // 更新大渠道版本号
    public function editChannelVersion() {
        decryptParam();     //base64解密参数
        $c_son_id = $this->getParam('c_son_id', 0);             //大渠道id
        $package_version = $this->getParam('package_version', '');      //包版本
        $version = $this->getParam('version', '');      //版本号
        
        try {
            $this->db->begin();     //开始mysqli事务
            if(empty($c_son_id) || empty($version)){
                throw new \Exception("参数不能为空，请检查参数", 10001);
            }
            $this->db->db_tabel('channel_version');
            $info = $this->db->db_find('*', "where c_son_id='$c_son_id' and package_version='$package_version'");
            if(!$info){
                throw new \Exception("数据不存在，请检查参数", 10001);
            }

            //更新
            $update_data = [
                'updated_at' => time(),
                'version' => $version,
            ];
            $res = $this->db->db_update($update_data, "where id=" . $info['id']);    //更新数据

            $this->db->commit();         //提交mysqli事务
        } catch (\Exception $e) {
            $this->db->rollBack();         //回滚mysqli事务
            encryptError($e->getMessage(),$e->getcode());
        }
        encryptSuccess('修改渠道版本号成功');
    }
    // 查询渠道版本号列表
    public function getChannelVersion() {
        decryptParam();     //base64解密参数
        $c_son_id = $this->getParam('c_son_id', 0);
        $package_version = $this->getParam('package_version', '');      //包版本
        $ret = [];
        if(!empty($c_son_id)){
            $where = "where c_son_id=$c_son_id and package_version='$package_version'";
            $this->db->db_tabel('channel_version');
            $ret = $this->db->db_find("*", $where);
        }
        
        encryptOut($ret,'ok',200,1);
    }

}


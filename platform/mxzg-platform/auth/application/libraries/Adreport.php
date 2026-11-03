<?php

import('Function.Url');
import('Function.Http');

// 要玩投放系统上报接口
class Adreport {
    function __construct() {
        $this->report_url = "http://advertising-platform.aloco.com/";
    }

    // 签名
    private function get_sign($argv, $appkey='^_^yaowan-php:start@signlib-get_sign@2016!') {
        $arr = array();
        ksort($argv);
        foreach ($argv as $key => $val) {
            if($key == 'sign') continue;
            if($val == '') continue;
            $arr[] = "$key=$val";
        }
        $str = implode("&", $arr)."&appkey=$appkey";
        $sign = strtolower($str);
        return md5($sign);
    }

    // 上报
    private function report($base_url, $data) {
        global $db;
        $platform = $data['platform'];
        $sql = "SELECT count(*) FROM adreport_platform WHERE platform LIKE '{$platform}%'";
        $can_report = $db->getFirstRow($sql);
        // if (!$can_report) return;
        $url = $this->report_url.$base_url.'?'.http_build_query($data);
        // addLog('ad_report', $url);
        sendGet($url, 2);
    }

    // 客户端首次启动应用上报-激活/安装 – 平台
    public function report_install($platform) {
        $data = [
            'game_type' => 'dfh',
            'platform' => $platform,
            'version' => GET::STR('sysver'),
            'imei' => GET::STR('imei'),
            'idfa' => GET::STR('idfa'),
            'idfv' => '',
            'ip' => getIP(),
        ];
        // 设备类型
        $os = GET::STR('os');
        if (!$os) $os = getOperateSystem();
        $device_type = 0;
        switch ($os) {
            case 'android':
                $device_type = 1;
                break;
            case 'ios':
                $device_type = 2;
                $data['idfv'] = GET::STR('MacId');
                break;
        }
        $data['device_type'] = $device_type;
        // 签名
        $data['sign'] = $this->get_sign($data);

        $this->report('api/user/install', $data);
    }

    // 创建账号上报 – 平台
    public function report_user_add($platform, $open_id, $create_time) {
        $data = [
            'game_type' => 'dfh',
            'platform' => $platform,
            'open_id' => $open_id,
            'create_time' => $create_time,
            'version' => GET::STR('sysver'),
            'imei' => GET::STR('imei'),
            'idfa' => GET::STR('idfa'),
            'idfv' => '',
            'ip' => getIP(),
        ];
        // 设备类型
        $os = GET::STR('os');
        if (!$os) $os = getOperateSystem();
        $device_type = 0;
        switch ($os) {
            case 'android':
                $device_type = 1;
                break;
            case 'ios':
                $device_type = 2;
                $data['idfv'] = GET::STR('MacId');
                break;
        }
        $data['device_type'] = $device_type;
        // 签名
        $data['sign'] = $this->get_sign($data);

        $this->report('api/user/user_add', $data);
    }

    // 充值成功上报 – 平台
    public function report_charge($platform, $open_id, $rid, $server_id, $order_id, $money, $goods_id, $ip, $time) {
        $data = [
            'game_type' => 'dfh',
            'platform' => $platform,
            'open_id' => $open_id,
            'rid' => $rid,
            'sid' => $server_id,
            'order_id' => $order_id,
            'money' => $money,
            'goods_id' => $goods_id,
            'ip' => $ip,
            'time' => $time,
        ];
        // 签名
        $data['sign'] = $this->get_sign($data);

        $this->report('api/user/charge', $data);
    }

    // 创建角色上报 – 客户端/后端
    public function report_role_add($platform, $open_id, $rid, $role_name, $sid, $ip, $create_time) {
        $data = [
            'game_type' => 'dfh',
            'platform' => $platform,
            'open_id' => $open_id,
            'rid' => $rid,
            'role_name' => $role_name,
            'sid' => $server_id,
            'ip' => $ip,
            'create_time' => $create_time,
        ];
        // 签名
        $data['sign'] = $this->get_sign($data);

        $this->report('api/user/role_add', $data);
    }

    // 角色登录上报 - 客户端/后端
    public function report_role_login($platform, $open_id, $rid, $role_name, $sid, $ip) {
        $data = [
            'game_type' => 'dfh',
            'platform' => $platform,
            'open_id' => $open_id,
            'rid' => $rid,
            'role_name' => $role_name,
            'sid' => $server_id,
            'ip' => $ip,
            'login_time' => time(),
        ];
        // 签名
        $data['sign'] = $this->get_sign($data);

        $this->report('api/user/role_login', $data);
    }
}

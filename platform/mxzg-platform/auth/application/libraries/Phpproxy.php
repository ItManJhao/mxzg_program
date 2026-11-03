<?php

// http://chenall.net/post/php_http_proxy/
// http://www.jianshu.com/p/0c8de9dc99ac
class Phpproxy {
    public function getMplist() {
        // 渠道标识=>array(渠道对应地址，合平台渠道列表(用于充值分发))
        $mplist = array(
            '248'=>array(
                'url'=>'http://manage.mini.yaowan.com:90',
                'mplist'=>array()
            ),
            'ipa-ios'=>array(
                'url'=>'http://ios-platform.dfh3.aloco.com',
                'mplist'=>array('mplatform')
            ),
            'apk-yyb'=>array(
                'url'=>'http://yyb-platform.dfh3.aloco.com',
                'mplist'=>array('mplatform')
            ),
            'apk-hf'=>array(
                'url'=>'http://hf-platform.dfh3.aloco.com',
                'mplist'=>array('mplatform')
            ),
            'mplatform'=>array(
                'url'=>'http://platform.clb.myqcloud.com',
                'mplist'=>array()
            ),
        );
        return $mplist;
    }

    private function getAllHeaders() {
        $headers = [];
        foreach ($_SERVER as $name => $value) {
            if (substr($name, 0, 5) == 'HTTP_') {
                $headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))))] = $value;
            }
        }
        $header_joins = [];
        foreach ($headers as $k => $v) {
            if ($k=='X-Pingplusplus-Signature' OR $k=='Content-Type') {
                array_push($header_joins, $k . ': ' . $v);
            }
        }
        // 将客户端的IP代理过去，在本框架获取ip的做法是 ecphp/Function/Client.php 下
        if ($_SERVER["HTTP_X_FORWARDED_FOR"]) {
            array_push($header_joins, 'X-FORWARDED-FOR: ' . $_SERVER["HTTP_X_FORWARDED_FOR"]);
        }
        if ($_SERVER["HTTP_CLIENT_IP"]) {
            array_push($header_joins, 'CLIENT-IP: ' . $_SERVER["HTTP_CLIENT_IP"]);
        }
        if (!$_SERVER["HTTP_X_FORWARDED_FOR"] AND !$_SERVER["HTTP_CLIENT_IP"]) {
            array_push($header_joins, 'CLIENT-IP: ' . getIp());
        }
        return $header_joins;
    }

    private function getRawData() {
        return file_get_contents('php://input');
    }

    function __construct() {
        $this->headers = $this->getAllHeaders();
        $this->raw_data = $this->getRawData();
    }

    public function proxy($url, $headers, $raw_data) {
        $user_agent = $_SERVER['HTTP_USER_AGENT'];
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");  // POST
        curl_setopt($ch, CURLOPT_POSTFIELDS, $raw_data);  // Post Data
        curl_setopt($ch, CURLOPT_URL, $url);//设置要访问的 URL
        curl_setopt($ch, CURLOPT_USERAGENT, $user_agent); //模拟用户使用的浏览器
        @curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1 );  // 使用自动跳转
        curl_setopt($ch, CURLOPT_TIMEOUT, 20);  //设置超时时间
        curl_setopt($ch, CURLOPT_AUTOREFERER, 1 ); // 自动设置Referer
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); // 收集结果而非直接展示
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers); // 自定义 Headers
        $result = curl_exec($ch);
        curl_close($ch);
        return $result;
    }

    public function post($url) {
        return $this->proxy($url, $this->headers, $this->raw_data);
    }
}

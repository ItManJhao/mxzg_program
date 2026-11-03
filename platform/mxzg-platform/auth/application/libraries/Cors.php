<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2015/7/6
 * Time: 11:31
 */
class Cors{
    protected $settings;

    public function __construct($settings = array()) {
        $this->settings = array_merge(array(
            'origin' => '*',    // Wide Open!
            'allowCredentials'  => true,
            'allowMethods' => 'GET,HEAD,PUT,POST,DELETE'
        ), $settings);
    }

    protected function setOrigin() {
        header('Access-Control-Allow-Origin:'.$this->settings['origin']);
    }
    protected function setExposeHeaders() {
        if (isset($this->settings->exposeHeaders)) {
            $exposeHeaders = $this->settings->exposeHeaders;
            if (is_array($exposeHeaders)) {
                $exposeHeaders = implode(", ", $exposeHeaders);
            }

            header('Access-Control-Expose-Headers:'.$exposeHeaders);
        }
    }
    protected function setMaxAge() {
        if (isset($this->settings['maxAge'])) {
            header('Access-Control-Max-Age:'.$this->settings['maxAge']);
        }
    }
    protected function setAllowCredentials() {
        if (isset($this->settings['allowCredentials']) && $this->settings['allowCredentials'] === True) {
            header('Access-Control-Allow-Credentials:true');
        }
    }
    protected function setAllowMethods() {
        if (isset($this->settings['allowMethods'])) {
            $allowMethods = $this->settings['allowMethods'];
            if (is_array($allowMethods)) {
                $allowMethods = implode(", ", $allowMethods);
            }

            header('Access-Control-Allow-Methods:'.$allowMethods);
        }
    }
    protected function setAllowHeaders() {
        if (isset($this->settings['allowHeaders'])) {
            $allowHeaders = $this->settings['allowHeaders'];
            header('Access-Control-Allow-Headers:'.$allowHeaders);
        }
    }
    protected function setCorsHeaders() {
        if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
            $this->setOrigin();
            $this->setMaxAge();
            $this->setAllowCredentials();
            $this->setAllowMethods();
            $this->setAllowHeaders();
        }
        else {
            $this->setOrigin();
            $this->setExposeHeaders();
            $this->setAllowCredentials();
        }
    }

    public function handle() {
        echo 11;exit;
        if(isset($_SERVER['HTTP_ORIGIN'])){
            $this->settings['origin'] = $_SERVER['HTTP_ORIGIN'];
        }
        if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'])){
            $this->settings['allowHeaders'] = $_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'];
        }
        $this->setCorsHeaders();
    }
}
<?php
namespace app\controller;

class Sdk extends \core\lss {

    protected $sdk_obj = false;
    protected $platform = '';
    function  __construct() {
        parent::__construct();
        $this->platform = $this->getPlatform();  //获取平台英文小写
        $this->sdk_obj = $this->loadSDK("SDK{$this->platform}");
    }

    // 获取角色列表
    public function getRoles() {
        if($this->sdk_obj){
            $this->sdk_obj->getRoles();
        }
        out([], '参数错误，请稍后再试', 10001);
    }

    // 获取服务器列表
    public function getServers() {
        if($this->sdk_obj){
            $this->sdk_obj->getServers();
        }
        out([], '参数错误，请稍后再试', 10001);
    }

    // 玩家可以购买礼包列表（礼包有限购）
    public function getDirectBuyGemList() {
        if($this->sdk_obj){
            $this->sdk_obj->getDirectBuyGemList();
        }

        out([], '参数错误，请稍后再试', 10001);
    }

    // 玩家是否可以购买礼包
    public function canDirectBuyGem() {
        if($this->sdk_obj){
            $this->sdk_obj->canDirectBuyGem();
        }
        out([], '参数错误，请稍后再试', 10001);
    }
    

}


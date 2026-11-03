<?php
namespace core\lib;
class log{
    static $class;#用于存储类
    /**
     * 加载存储方式
     * 1.确定日志的存储方式
     * 2.写日志
     */
    static public function init(){
        //确定存储方式
        $drive = conf::get('DRIVE','log');#驱动
        $class = '\core\lib\drive\log\\'.$drive;#类的名称
        self::$class = new $class;
    }
    static public function log($name,$file='log'){
        self::$class->log($name,$file);
    }

}
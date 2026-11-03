<?php
namespace core\lib\drive\log;
use core\lib\conf;
class file{
    public $path;#日志存储位置
    public function __construct()
    {
        $conf = conf::get('OPTION','log');
        $this->path = $conf['PATH'];
    }
    public function log($message){
        /**
         * 1.确定文件存储位置是否存在
         * 新建目录
         * 2.写入日志
         */
        if (!is_dir($this->path.date('Ym'))){
            mkdir($this->path.date('Ym'),'0777',true);
        }
        $file = file_put_contents($this->path.date('Ym').'/'.date('d').'.log',
            date('Y-m-d H:i:s').json_encode($message).PHP_EOL,FILE_APPEND);
        return $file;
    }

}
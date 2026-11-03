
<?php
namespace core\lib;#命名空间
class model extends \PDO{
    public function __construct()
    {
        $database = conf::all('database'); //引入全部文件
        try{
            parent::__construct($database['DSN'], $database['USERNAME'], $database['PASSWD']);
        }catch (\PDOException $e){
            print_r($e->getMessage());
        }
    }

}
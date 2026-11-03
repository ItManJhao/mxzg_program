<?php 

namespace core;

// use lib\Mysql;
class lss{
	public static $classMap = array();#用于判断类是否存在，节约性能
	public $assign;#用于判断类是否存在，节约性能
    public $db;
    protected $platform_host = array();
    protected $platform_data = array();      //参数数组
    function  __construct() {
        global $CONFIG_DATA;
        if(isset($CONFIG_DATA['PLATFORM_HOST'][$_SERVER['HTTP_HOST']])){
            $this->platform_host = $CONFIG_DATA['PLATFORM_HOST'][$_SERVER['HTTP_HOST']];
            $config_data_name = $this->platform_host['data'];
            global $$config_data_name;
            $this->platform_data = $$config_data_name;
        }
        
        $this->db = new \core\lib\mysqli();
    }
    /**
     * 基础类，自动加载类库
     * @param $class
     * @return bool
     */
    static public function load($class){
        //new \core\route();
        //$class = '\core\route';
        //LSS.'/core/route.php';
        if (isset($classMap[$class])){#类存在，即不引用类
            return true;
        }else{
            $class = str_replace('\\','/',$class);
            $file = LSS.'/'.$class.'.php';
            if (is_file($file)){
                include $file;#引用文件
                self::$classMap[$class] = $class;
            }else{
                return false;
            }
        }
    }

    /**
     * 获取平台信息
     * @return Platform
     */
    protected function getPlatform() {
        if(isset($this->platform_host['sdk'])){
            return $this->platform_host['sdk'];
        }
        return '';
    }

    /**
     * 加载不同的SDK处理类
     * @param string $sdk_class
     * @return AbstractSDK
     */
    protected function loadSDK($sdk_class) {
        $sdk_class_path = DIR_SDK . '/' . $sdk_class . '.php';
        if (!file_exists($sdk_class_path)) {
            return false;
        }
        include $sdk_class_path;
        return new $sdk_class;
    }
 
    /**
     * 运行控制器和方法
     * @throws \Exception
     */
    static public function run(){
        $route =new \core\lib\route();
        $ctrlClass = $route->ctrl;
        $action = $route->action;
        $ctrlFile = APP.'/controller/'.$ctrlClass.'.php';#控制器文件
        $ctrlClass = '\app\controller\\'.$ctrlClass;
        if (is_file($ctrlFile)){
            include $ctrlFile;
            $ctrl = new $ctrlClass();
            $ctrl->$action();
        }else{
            throw new \Exception('找不到控制器'.$ctrlClass);
        }
    }

    /**
     * 变量名替换
     * @param $name
     * @param $value
     */
    public function assign($name,$value){
        $this->assign[$name] = $value;
    }
 
    /**
     * 显示视图
     * @param $file
     */
    public function display($file){
        $file = APP.'/views/'.$file;
        if (is_file($file)){
            extract($this->assign);#从数组中将变量导入到当前的符号表
            include $file;
        }
    }

    public function getParam($param_name, $default_val=''){
        return isset($_REQUEST[$param_name]) ? $_REQUEST[$param_name] : $default_val;
    }

}
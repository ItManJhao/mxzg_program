<?php
namespace core\lib;

class mysqli{
	protected $host = '';
	protected $user = '';
	protected $pwd = '';
	protected $database = '';
	protected $port = '';
	public $db_tablename;  //表名
	public $db_conn;  //数据库连接
	public $db_order;
	public $db_limit;
	
	public function __construct($host = null, $user = null, $pwd = null, $database = null, $port = null){  //构造方法赋值
        //使用默认配置
		global $CFG_DB;
		$this->host = $CFG_DB[DEFAULT_CFG_DB]['HOST'];
		$this->user = $CFG_DB[DEFAULT_CFG_DB]['USER'];
		$this->pwd = $CFG_DB[DEFAULT_CFG_DB]['PWD'];
		$this->database = $CFG_DB[DEFAULT_CFG_DB]['DATABASE'];
		$this->port = $CFG_DB[DEFAULT_CFG_DB]['PORT'];
		$this->db_order="";
		$this->db_limit="";
		$this->db_getconn();
        mysqli_query($this->db_conn,'set names utf8');
	}

	public function db_getconn(){  //连接数据库
		$this->db_conn= mysqli_connect($this->host,$this->user,$this->pwd,$this->database,$this->port);
		if (!$this->db_conn)
		{
            echo "连接 MySQL 失败: " . mysqli_connect_error();
        }
	}
	

	//事务相关开始
	public function begin() {
		mysqli_autocommit($this->db_conn,false);
	}
	public function commit() {
		mysqli_commit($this->db_conn);
	}
	public function rollBack() {
		mysqli_rollback($this->db_conn);
	}
	//事务相关End


	public function db_tabel($db_tablename){  //设置表名
		$this->db_tablename=$db_tablename;
	}	
	
	public function  db_order($str){  //排序操作
		$this->db_order="order by $str";	
	}
	
	public function  db_limit($start,$end){  //分页操作
	  	$this->db_limit="limit $start,$end";
	}
	
	public function db_select($typearr='',$where=""){  //查询操作
		if(empty($typearr)){			
			$typearr="*";
		}
		if(empty($where)){			
			$where="";
		}else{			
			$where=$where;
		}		
		$arr=array();
		$sql="select $typearr from $this->db_tablename  $where $this->db_order $this->db_limit ";
		$result = mysqli_query($this->db_conn,$sql);
		if($result){
			while($row = $result->fetch_assoc()) {
				$arr[]=$row;
			}
		}
		return $arr;
	}

	public function db_find($typearr='',$where=""){  //查询操作
		if(empty($typearr)){			
			$typearr="*";
		}
		if(empty($where)){			
			$where="";
		}else{			
			$where=$where;
		}		
		$arr=array();
		$sql="select $typearr from $this->db_tablename  $where $this->db_order limit 1";
		$result = mysqli_query($this->db_conn,$sql);
		if($result){
			while($row = $result->fetch_assoc()) {
				$arr=$row;
			}
		}
		return $arr;
	}
	
	public function db_sql($sql){  //查询操作
		$arr=array();
		$result = mysqli_query($this->db_conn,$sql);
		if($result){
			while($row = $result->fetch_assoc()) {
				$arr[]=$row;
			}
		}
		return $arr;
	}

	public function db_insert($keyarr,$valuearr){  //插入操作
		$sql="insert into $this->db_tablename(".implode(",", $keyarr).") values(".implode(",", $valuearr).")";
		$res = mysqli_query($this->db_conn,$sql);
		if($res){
			$insert_id = mysqli_insert_id($this->db_conn);
			return $insert_id;
		}else{
			return false;
		}
	}

	public function db_update($update_data,$where=""){ //更新操作
        $sql="";
		if(empty($where)){
			$where="";
		}
		$sql.="update $this->db_tablename set ";
		$update_str = '';
		foreach ($update_data as $key=>$value){
		 	$update_str.=$key."='".$value."',";
		}
		if(!empty($update_str)){
			$update_str = substr($update_str, 0, -1);
			$sql .= $update_str;
		}else{
			return false;
		}
		$sql.=$where;
        $result = mysqli_query($this->db_conn,$sql);
        return $result;
	}

	public function db_add_one($field_arr,$where=""){ //字段值加1
        $sql="";
		if(empty($where)){
			$where="";
		}
		$sql.="update $this->db_tablename set ";
		$update_str = '';
		foreach ($field_arr as $value){
		 	$update_str.=$value."=".$value."+1,";
		}
		if(!empty($update_str)){
			$update_str = substr($update_str, 0, -1);
			$sql .= $update_str;
		}else{
			return false;
		}
		$sql.=' ' . $where;
        $result = mysqli_query($this->db_conn,$sql);
        return $result;
	}
	
	public function db_delete($typestr,$valuestr){  //删除操作
        $sql="delete from $this->db_tablename WHERE $typestr=$valuestr";
        mysqli_query($this->db_conn,$sql);
 
	}
	
	public function __destruct(){  //析构方法关闭连接
		mysqli_close($this->db_conn);
	}
}
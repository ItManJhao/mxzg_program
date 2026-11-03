<?php
namespace core\lib;
/**
 * Mysql数据库操作类
 */
class Mysql {
	protected $db = null;

	protected $use_transaction = false; //使用事务
	protected $is_connected = false; //是否已经连接

	protected $host = '';
	protected $user = '';
	protected $pwd = '';
	protected $database = '';

	protected $recordNum = 0; //使用分页查询pageQuery时得到的记录共数

	/**
	 * @param string $host example: 127.0.0.1:3306
	 * @param unknown $user 数据库用户名
	 * @param unknown $pwd 数据库密码
	 * @param unknown $database 数据库名
	 */
	public function __construct($host = null, $user = null, $pwd = null, $database = null) {

		$args = func_get_args();
		if (!$args) {
			//使用默认配置
			global $CFG_DB;
			$this->host = $CFG_DB[DEFAULT_CFG_DB]['HOST'];
			$this->user = $CFG_DB[DEFAULT_CFG_DB]['USER'];
			$this->pwd = $CFG_DB[DEFAULT_CFG_DB]['PWD'];
			$this->database = $CFG_DB[DEFAULT_CFG_DB]['DATABASE'];
		}
		else if (count($args) == 1) {
			//使用某个数据库配置
			global $CFG_DB;
			$db_key = $host;
			$this->host = $CFG_DB[$db_key]['HOST'];
			$this->user = $CFG_DB[$db_key]['USER'];
			$this->pwd = $CFG_DB[$db_key]['PWD'];
			$this->database = $CFG_DB[$db_key]['DATABASE'];
		}
		else {
			//自定义
			$this->host = $host;
			$this->user = $user;
			$this->pwd = $pwd;
			$this->database = $database;
		}
	}

	public function __destruct() {
		$this->close();
	}

	//只连接一次，如果$this->is_connected为true，就不连接了
	protected function connectOnce() {
		if (!$this->is_connected) {
			$this->connect($this->host, $this->user, $this->pwd, $this->database);
			if (AUTO_SET_NAMES) {
				$this->setNames(DB_CHARSET);
			}
		}
	}

	//连接数据库，之前的连接会关闭
	protected function connect($host, $user, $pwd, $database = null) {
		$this->close();

		$arr_tmp = explode(':', $host);
		$host = $arr_tmp[0];
		$port = (int) $arr_tmp[1];

		$this->db = new mysqli();
		$this->db->connect($host, $user, $pwd, $database, $port);
		if ($this->db->connect_errno != 0) {
			die("Connect Error ({$mysqli->connect_errno}) {$mysqli->connect_error}, $host:$port\n");
		}

		$this->is_connected = true;
	}

	/**
	 * @param string $database
	 * @return boolean
	 */
	public function selectDb($database) {
		return $this->db->select_db($database);
	}

	public function close() {
		if ($this->is_connected) {

			if ($this->db) {
				$this->db->close();
				$this->db = null;
			}
			$this->is_connected = false;
		}
	}

	//设置数据库读写编码
	public function setNames($chartset = 'UTF8') {
		$this->execute("SET NAMES {$chartset}");
	}

	//事务相关Begin
	public function begin() {
		$this->db->begin_transaction();
		$this->use_transaction = true;
	}
	public function commit() {
		$this->db->commit();
		$this->use_transaction = false;
	}
	public function rollBack() {
		$this->db->rollback();
		$this->use_transaction = false;
	}
	//事务相关End

	/**
	 * 执行SQL语句
	 * @param string $sql
	 * @return mysqli_result
	 */
	public function query($sql) {
		$args = func_get_args();
		if (count($args) > 1) {
			//使用安全的方法来构建SQL语句
			if (preg_match_all("/%[bcdeufFosxX]/", $sql, $matchs)) {
				$i = 1;
				foreach ($matchs[0] as $v) {
					if ($v == '%s') {
						//把字符串参数作escape处理
						$args[$i] = $this->escape($args[$i]);
					}
					$i += 1;
				}
			}

			foreach ($args as $k => $v) {
				if ($k == 0) {
					continue;
				}
				$sprintf_args .= ', $args[' . $k. ']';
			}
			if ($sprintf_args) {
				//非字符串参数（一般为数字型）在使用sprintf处理后变得安全
				eval("\$sql = sprintf(\$sql{$sprintf_args});");
			}
		}

		if (!$this->use_transaction) { //如果使用了事务处理，在执行SQL语句时就不用Die掉了。
			$result = $this->execute($sql);
			if (!$result) {
				_RUNTIME("Sql error, please contact us. Thanks.\n<p>\n" . $sql . "\n<p>\n" . $this->db->error);
				exit('sql error');
			}
		}
		else {
			$result = $this->execute($sql);
		}
		return $result;
	}

	/**
	 * 执行SQL语句
	 * @param string $sql
	 * @return mixed
	 */
	public function execute($sql) {
		$this->connectOnce();
		return $this->db->query($sql);
	}

	/**
	 * insert方法，支持唯一键冲突时update相应字段
	 * @param string $tablename
	 * @param array $array
	 * @param bool $insert_id
	 * @param bool $show_err
	 * @param array $update_fields
	 */
	public function insert($tablename, &$array, $insert_id = true, $show_err = true, $update_fields = array()) {
		if (!is_array($array)) {
			return false;
		}

		$keys = '';
		$values = '';
		foreach ($array as $k => $v) {
			if (!$keys) {
				$keys = '`' . $k . '`';
				$values = "'" . $this->escape($v) . "'";
			}
			else {
				$keys .= ', `' . $k . '`';
				$values .= ", '" . $this->escape($v) . "'";
			}
		}

		$update_str = '';

		foreach ($update_fields as $field) {
			if ($update_str) {
				$update_str .= ", ";
			}
			$update_str .= "`$field` = '" . $this->escape($array[$field]) . "'";
		}

		if ($update_str) {
			$update_str = "ON DUPLICATE KEY UPDATE $update_str";
		}

		$sql = "INSERT INTO $tablename ($keys) VALUES ($values) $update_str";

		if (AUTO_CHANGE_SQL_MODE) {
			$this->execute("SET @@sql_mode = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'");
		}

		$r = $show_err ? $this->query($sql) : $this->execute($sql);
		if ($insert_id)
			return $r ? $this->insertId() : false;
		else
			return $r;
	}

	/**
	 * insert方法，支持唯一键冲突时update相应字段
	 * @param string $tablename
	 * @param array $array
	 * @param bool $insert_id
	 * @param bool $show_err
	 * @param array $update_fields
	 */
	public function insert2($tablename, $array, $insert_id = true, $show_err = true, $update_fields = array()) {
		if (!is_array($array)) {
			return false;
		}

		$keys = '';
		$values = '';
		foreach ($array as $k => $v) {
			if (!$keys) {
				$keys = '`' . $k . '`';
				$values = "'" . $this->escape($v) . "'";
			}
			else {
				$keys .= ', `' . $k . '`';
				$values .= ", '" . $this->escape($v) . "'";
			}
		}

		$update_str = '';

		foreach ($update_fields as $field) {
			if ($update_str) {
				$update_str .= ", ";
			}
			$update_str .= "`$field` = '" . $this->escape($array[$field]) . "'";
		}

		if ($update_str) {
			$update_str = "ON DUPLICATE KEY UPDATE $update_str";
		}

		$sql = "INSERT INTO $tablename ($keys) VALUES ($values) $update_str";

		if (AUTO_CHANGE_SQL_MODE) {
			$this->execute("SET @@sql_mode = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'");
		}

		$r = $show_err ? $this->query($sql) : $this->execute($sql);
		if ($insert_id)
			return $r ? $this->insertId() : false;
		else
			return $r;
	}

	//更新记录
	public function update($tablename, $array, $whereplus, $exe_ways = "") {
		if (!is_array($array))
			return false;

		if (!is_array($exe_ways)) {
			foreach ($array as $key=>$value) {
				$update .= ",`$key`='" . $this->escape($value) . "'";
			}
		}
		else {
			foreach ($array as $key=>$value) {
				if ($exe_ways[$key])
					$update .= ",`$key`=$value";
				else
					$update .= ",`$key`='" . $this->escape($value) . "'";
			}
		}
		$update = substr($update, 1);
		if ($whereplus)
			$where = "WHERE $whereplus";
		$sql = "UPDATE $tablename SET $update $where";
		if ($this->query($sql))
			return $this->affectedRows();
		else
			return false;
	}

	//删除记录
	public function delete($tablename, $whereplus) {
		if ($whereplus)
			$where = "WHERE $whereplus";
		$sql = "DELETE FROM $tablename $where";
		if ($this->query($sql))
			return $this->affectedRows();
		else
			return false;
	}

	public function replace($tablename, $array, $show_err = true) {
		if (!is_array($array)) {
			return false;
		}

		$keys = '';
		$values = '';
		foreach ($array as $k => $v) {
			if (!$keys) {
				$keys = '`' . $k . '`';
				$values = "'" . $this->escape($v) . "'";
			}
			else {
				$keys .= ', `' . $k . '`';
				$values .= ", '" . $this->escape($v) . "'";
			}
		}
		$sql = "REPLACE INTO $tablename ($keys) VALUES ($values)";

		if (AUTO_CHANGE_SQL_MODE) {
			$this->execute("SET @@sql_mode = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'");
		}

		$r = $show_err ? $this->query($sql) : $this->execute($sql);
		return $r;
	}

	public function insertId() {
		return $this->db->insert_id;
	}

	public function affectedRows() {
		return $this->db->affected_rows;
	}

	//获取第一条记录
	public function getFirstRow($sql, $result_type = MYSQL_ASSOC) {
		$result = $this->query($sql);
		$row = $result->fetch_array($result_type);
		$result->free();
		return $row;
	}

	//获取第一条记录的某个字段值
	public function getField($sql, $field = 0) {
		$result = $this->query($sql);
		$arr = $result->fetch_array();
		$result->free();
		return $arr[$field];
	}

	public function getRows($sql, $field = '') {
		$result = $this->query($sql);
		return $this->getRowsFromResult($result, $field);
	}

	public function max($tablename, $fields, $whereplus = "") {
		if (is_array($fields)) {
			$str = "";
			foreach ($fields as $field) {
				$str .= "MAX($field),";
			}
			$str = substr($str, 0, -1);
		}
		else
			$str = "MAX($fields)";
		if ($whereplus)
			$where = "WHERE $whereplus";
		$sql = "SELECT $str FROM $tablename $where";
		$result = $this->query($sql);
		$row = $result->fetch_row();
		$result->free();
		if (count($row) <= 1) {
			return $row[0];
		}
		return $row;
	}

	public function sum($tablename, $fields, $whereplus = "") {
		if (is_array($fields)) {
			$str = "";
			foreach ($fields as $field) {
				$str .= "SUM($field),";
			}
			$str = substr($str, 0, -1);
		}
		else
			$str = "SUM($fields)";
		if ($whereplus)
			$where = "WHERE $whereplus";
		$sql = "SELECT $str FROM $tablename $where";
		$result = $this->query($sql);
		$row = $result->fetch_row();
		$result->free();
		if (count($row) <= 1) {
			return $row[0];
		}
		return $row;
	}

	public function count($tablename, $whereplus = "", $field = "*") {
		if ($whereplus)
			$where = "WHERE $whereplus";

		$sql = "SELECT COUNT($field) FROM $tablename $where";
		$this->getField($sql);
	}

	/**
	 * 批量INSERT
	 * @param string $tablename
	 * @param array $arr_data
	 * @param number $num
	 * @param array $duplicate_update_fields
	 * @return number
	 */
	public function insertBatch($tablename, &$arr_data, $num = 1000, $duplicate_update_fields = false) {
		$n = 0;
		$sql = '';
		$values = '';
		$sql_header = '';
		$update_str = '';

		$affected = 0;

		if (AUTO_CHANGE_SQL_MODE) {
			$this->execute("SET @@sql_mode = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'");
		}

		foreach ($arr_data as $data) {
			$n += 1;

			$values = '';
			foreach ($data as $v) {
				if (!$values) {
					$values = "'" . $this->escape($v) . "'";
				} else {
					$values .= ", '" . $this->escape($v) . "'";
				}
			}

			if ($n == 1) {
				$keys = array_keys($data);

				if (!$sql_header) {
					$sql_header = 'insert into ' . $tablename . ' (`' . implode('`, `', $keys) . '`) values ';
				}
				$sql = $sql_header . "($values)";

				// insert时唯一键冲突时的update语句
				if ($duplicate_update_fields && !$update_str) {
					if (is_array($duplicate_update_fields)) {
						$keys = &$duplicate_update_fields;
					}

					$flag = 0;
					foreach ($keys as $field) {
						if (!$flag) {
							$update_str = " ON DUPLICATE KEY UPDATE `$field` = VALUES(`$field`)";
							$flag = 1;
						} else {
							$update_str .= ", `$field` = VALUES(`$field`)";
						}
					}
				}

			} else {
				$sql .= ", ($values)";
			}

			if ($n == $num) {
				$this->query($sql . $update_str);
				$affected += $this->affectedRows();
				$n = 0;
			}
		}

		if ($n != 0) {
			$this->query($sql . $update_str);
			$affected += $this->affectedRows();
		}

		return $affected;
	}

	/**
	 * @param string $str
	 * @return string
	 */
	public function escape($str) {
		if ($str === null) {
			return '';
		}
		$this->connectOnce();
		return $this->db->real_escape_string($str);
	}

	//表是否存在
	public function tableExists($tablename) {
		$tablename = $this->escape($tablename);
		$result = $this->query("SHOW TABLES LIKE '$tablename'");
		$row = $result->fetch_row();
		$result->free();
		return $row ? true : false;
	}

	/**
	 * 分页用的query方法。执行后，能通过getRecordNum方法得到总记录数
	 * @param string $sql 无SQL_CALC_FOUND_ROWS、无LIMIT的“SELECT”SQL语句
	 * @param int $pageSize 每页记录数
	 * @param string $pageName
	 */
	public function pageQuery($sql, $pageSize = PAGE_SIZE, $pageName = PAGE_NAME) {
		$pageSize = $pageSize < 1 ? 1 : $pageSize;

		$page = GET::INT($pageName);
		if ($page < 1) {
			$page = 1;
		}
		$offset = ($page - 1) * $pageSize;

		$sql = preg_replace("/^\s*select /is", "select SQL_CALC_FOUND_ROWS ", $sql, -1, $count);
		if ($count != 1) {
			die("\"{$sql}\" is not a select sql.");
		}
		$sql .= " limit {$offset}, {$pageSize}";

		$result = $this->query($sql);
		$this->recordNum = $this->getField("SELECT FOUND_ROWS()");

		return $result;
	}

	/**
	 * 获取记录总数
	 */
	public function getRecordNum() {
		return $this->recordNum;
	}

	/**
	 * 分页用的getRows，获取当前页的记录。执行后，能通过getRecordNum方法得到总记录数
	 * @param string $sql
	 * @param int $pageSize
	 * @param string $pageName
	 */
	public function getPageRows($sql, $pageSize = PAGE_SIZE, $pageName = PAGE_NAME) {
		$result = $this->pageQuery($sql, $pageSize, $pageName);
		return $this->getRowsFromResult($result, '');
	}

	/**
	 *
	 * @param mysqli_result $result
	 * @param string $field
	 * @return unknown[]
	 */
	protected function getRowsFromResult(&$result, $field = '') {
		$data = array();
		if ($result) {
			if ($field) {
				while (($row = $result->fetch_assoc())) {
					$data[$row[$field]] = $row;
				}
			}
			else {
				while (($row = $result->fetch_assoc())) {
					$data[] = $row;
				}
			}
			$result->free();
		}
		return $data;
	}
}
?>

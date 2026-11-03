<html>
<head>
<title>TOOLS-TIME</title>

<style type="text/css">
body, td, input {
	font-size:14px;
}
</style>

</head>
<body style="padding-top:100px;">
<form action="<?=$_SERVER['REQUEST_URI']?>" method="post" id="form1">
  <table align="center">
    <tr>
      <td width="200" height="50">date('Y-m-d H:i:s')</td>
      <td>strtotime</td>
    </tr>
    <tr>
      <td height="50"><input type="text" name="t" value="<?=POST::INT('t')?>" /></td>
      <td><input type="text" name="s" value="<?=POST::STR('s')?>" /></td>
    </tr>
    <tr>
      <td height="50"><?=date('Y-m-d H:i:s', POST::INT('t'))?></td>
      <td><?=strtotime(POST::STR('s'))?></td>
    </tr>
    <tr>
      <td colspan="2" height="50"><input type="submit" value="Convert" /></td>
    </tr>
  </table>
  
</form>
</body>
</html>
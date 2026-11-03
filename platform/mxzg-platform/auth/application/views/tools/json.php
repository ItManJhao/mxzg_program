<html>
<head>
<title>TOOLS-JSON</title>
<script>

function buttonClick(flag) {
	document.getElementById("flag").value = flag;
	document.getElementById("form1").submit();
}

</script>

<style type="text/css">
body, td, input, textarea {
	font-size:14px;
}
pre {
	font-size:12px;
}
</style>

</head>
</head>
<body style="padding-top:50px;">

<table align="center">
  <tr>
    <td>
    <form action="<?=$_SERVER['REQUEST_URI']?>" method="post" id="form1">
	  <textarea rows="12" cols="60" name="str"><?=$_POST['str']?></textarea>
	  <input type="hidden" id="flag" name="flag" value="">
	  <br>
	  <input type="button" value="print_r" onclick="buttonClick(this.value)" />
	  <input type="button" value="var_export" onclick="buttonClick(this.value)" />
	  <input type="button" value="urlencode" onclick="buttonClick(this.value)" />
	  <input type="button" value="urldecode" onclick="buttonClick(this.value)" />
	</form>
    </td>
  </tr>
  <tr>
    <td>
    <pre style="width: 600px; overflow:visible"><?
	if ($_POST['flag'] == 'print_r') {
		print_r(json_decode($_POST['str'], true));
	} else if ($_POST['flag'] == 'var_export') {
		var_export(json_decode($_POST['str'], true));
	} else if ($_POST['flag'] == 'urlencode') {
		echo urlencode($_POST['str']);
	} else if ($_POST['flag'] == 'urldecode') {
		echo urldecode($_POST['str']);
	}
	?>
	</pre>
    </td>
  </tr>
</table>
</body>
</html>
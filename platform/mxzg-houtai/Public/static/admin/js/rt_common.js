//打开浏览选择图片
dName = "";
function BrowseServer(id) {
    dName = id;
    // You can use the "CKFinder" class to render CKFinder in a page:
    var finder = new CKFinder();
    finder.basePath = '/ckfinder/'; // The path for the installation of CKFinder (default = "/ckfinder/").
    finder.selectActionFunction = function(a,b){
        document.getElementById(b["selectActionData"]).value = decodeURI(a) ;
    };
    finder.selectActionData = id;  //接收地址的input ID
    finder.popup();
}

// 启用 CKEitor 的上传功能，使用了 CKFinder 插件
function editorReplace(textId) {
    CKEDITOR.replace( textId, {
        filebrowserBrowseUrl        : '/Public/Admin/plugins/ckfinder/ckfinder.html',
        filebrowserImageBrowseUrl   : '/Public/Admin/plugins/ckfinder/ckfinder.html?Type=Images',
        filebrowserFlashBrowseUrl   : '/Public/Admin/plugins/ckfinder/ckfinder.html?Type=Flash',
        filebrowserUploadUrl        : '/Public/Admin/plugins/ckfinder/core/connector/php/connector.php?command=QuickUpload&type=Files',
        filebrowserImageUploadUrl   : '/Public/Admin/plugins/ckfinder/core/connector/php/connector.php?command=QuickUpload&type=Images',
        filebrowserFlashUploadUrl   : '/Public/Admin/plugins/ckfinder/core/connector/php/connector.php?command=QuickUpload&type=Flash',
    });
}

//打开新页面
function openYemian(url,name) {
    parent.layer.open({
        type: 2,
        title: name,
        shade: 0.5,
        shadeClose : false,
        maxmin: true, //开启最大化最小化按钮
        area: ['70%', '80%'],
        content: url,
        end : function(){
            var handle_status = $("#handle_status").val();
            var handle_url = $("#handle_url").val();
            if(handle_status == '1'){
                if (handle_url && handle_url !== ''){
                    window.location.href = handle_url;
                }else{
                    window.location.href = location.href;
                }
            }
        }
    });
}

// 修改指定表的排序字段
function updateSort(table,id_name,id_value,field,obj){		       
	var value = $(obj).val();
	$.ajax({
		url:"/index.php?m=Admin&c=Common&a=changeTableVal&table="+table+"&id_name="+id_name+"&id_value="+id_value+"&field="+field+'&value='+value,
		success: function(data){									
			layer.msg('更新成功', {icon: 1});
		}
	});		
}

// 修改指定表的指定字段值，，1和0的字段
// 表名，条件-id，条件值，字段名，abj
function changeOnlyVal(table,id_name,id_value,field,obj){
	var src = "";
	var num = $(obj).data('num');
	if(num == 1){
		src = '/Public/Admin/images/cancel.png';
		var value = 0;
	}else{
		src = '/Public/Admin/images/yes.png';
		var value = 1;
	}
	$.ajax({
		url:"/index.php?m=Admin&c=Common&a=changeTableVal&table="+table+"&id_name="+id_name+"&id_value="+id_value+"&field="+field+'&value='+value,
		success: function(data){
			$(obj).data('num',value);
			$(obj).attr('src',src);
		}
	});
}

//异步获取列表
function getAjaxList(divId,page,url) {
    $.ajax({
        url: url+"/p="+page,
        type: "post",
        data: $("#formSearch").serialize(),
        success:function(data){
            $("#" + divId).html('');
            $("#" + divId).append(data);
        },
        error: function () {
            // layer.close(loading);
            layer.alert('执行错误，请联系管理员！', { icon: 2 });
        }
    });
}

/**
 * 删除商品栏目
 * @returns {void}
 */
function del_fun(del_url){
    parent.layer.confirm('确定要删除?', function(){
        parent.layer.closeAll('dialog');
        location.href = del_url;
    });
} 

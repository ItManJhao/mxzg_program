/*
**AJAX提交==统一
*/
var before_request = 0;
function ratuo_submit_form(form_id,submit_url){
    //如果是有CKEditor的话，需要update，否则取不到值
/*    if(before_request == 1){
        // location.href = location.href;
        top.layer.msg("请刷新页面！",{icon:2});
        return false;
    }*/

    if (window.CKEDITOR) {
        for (instance in CKEDITOR.instances)
            CKEDITOR.instances[instance].updateElement();
    }

    $.ajax({
        type : "POST",
        url  : submit_url,
        dataType: "JSON",
        data : $('#'+form_id).serialize(),// 你的formid
        error: function(request) {
            alert("服务器繁忙, 请联系管理员!");
        },
        success: function(v) {

                        // console.log(12);
            before_request = 1; // 标识ajax 请求已经返回

            // 验证成功提交表单
            if(v.status == 1){
                
                        // console.log(v.url);
                    top.layer.msg(v.message,{icon:1,time:2000});
                    parent.$("#content-main").find('iframe:visible')[0].contentWindow.$("#handle_status").val(v.status);
                    var index = top.layer.getFrameIndex(window.name); //获取窗口索引
                    if (v.url) {
                        parent.$("#content-main").find('iframe:visible')[0].contentWindow.$("#handle_url").val(v.url);
                        // console.log(v.url);
                        // window.location.href = v.url;
                    } else {
                        // window.location.href = location.href;
                    }
                    top.layer.close(index);
                    return true;
                
            }

            if(v.status == 0){
                top.layer.msg(v.message,{icon:2});
                return false;
            }
        }
    });
}

//删除某一记录
function rtdel(id,url) {
    parent.layer.confirm('确定要删除?', function(){
        parent.layer.closeAll('dialog');
        $.ajax({
            url:url,
            type:"post",
            dataType:"json",
            data:{"id":id,"act":"del"},
            success: function(v){
                if(v.status == 1){
                    parent.layer.msg(v.message, {icon: 1,time: 1500},function(){
                        $("#row_"+id).remove();
                    });
                }else{
                    parent.layer.msg(v.message, {icon: 2,time: 2000},function(){
                        if(v.url){
                            window.location.href = v.url;
                        }
                    });
                }
                return false;
            }
        });
        return false;
    });
}

/*
** 广告 增删改查
*/
//显示隐藏新增行
function showAddRow() {
    $("#addnew").toggleClass('hidden');
}
//显示编辑
function showEdit(id) {
    $("#row_" + id + " .rt-editpanel").hide();
    $("#row_" + id + " .rt-savepanel").removeClass('hidden');
}
//取消编辑
function cancelEdit(id) {
    $("#row_" + id + " .rt-editpanel").show();
    $("#row_" + id + " .rt-savepanel").addClass('hidden');
}

function doAdd(formid,url) {
    var strQuery = $("#" + formid + " .addnew").fieldSerialize();

    var loading = layer.load(0, {
        shade: [0.2, '#000'] //0.1透明度的背景
    });
    $.ajax({
        type: "POST",
        url: url,
        data: strQuery,
        dataType: "JSON",
        success: function (data) {
            if (data.status == "1") {
                layer.close(loading);
                layer.msg(data.message, {
                    time: 1000 //2秒关闭（如果不配置，默认是3秒）
                }, function () {
                    window.location.href = window.location.href;
                });
            } else if (data.status == "0") {
                layer.close(loading);
                layer.alert(data.message, { icon: 2 });

            }
        },
        error: function () {
            layer.close(loading);
            layer.alert('执行错误，请联系管理员！', { icon: 2 });
        }
    });
}
//执行异步编辑
function doEdit(formid, url, id) {
    var strQuery = $("#" + formid + " #row_" + id + " .rt-edit").fieldSerialize();
    var loading = layer.load(0, {
        shade: [0.2, '#000'] //0.1透明度的背景
    });
    $.ajax({
        type: "POST",
        url: url,
        data: strQuery,
        dataType: "JSON",
        success: function (data) {
            if (data.status == 1) {
                layer.close(loading);
                layer.msg(data.message, {
                    time: 1000 //2秒关闭（如果不配置，默认是3秒）
                }, function () {
                    window.location.href = window.location.href;
                });
            } else {
                layer.close(loading);
                layer.alert(data.message, { icon: 2 });
            }
        },
        error: function () {
            layer.close(loading);
            layer.alert('执行错误，请联系管理员！', { icon: 2 });
        }
    });
}
//后台异步删除
function doDel(url, id) {
    layer.confirm('确认要删除当前记录？此操作不可恢复！', {
        icon: 3,
        title: '系统提示',
        btn: ['确定', '取消 '] //按钮
    }, function () {
        var loading = layer.load(0, {
            shade: [0.2, '#000'] //0.1透明度的背景
        });
        $.ajax({
            type: "POST",
            url: url,
            data: 'id=' + id,
            dataType: "JSON",
            success: function (data) {
                if (data.status == 1) {
                    layer.close(loading);
                    layer.msg(data.message, {
                        time: 1000 //2秒关闭（如果不配置，默认是3秒）
                    }, function () {
                        if ($("#row_" + id).length > 0) {
                            $("#row_" + id).fadeOut(300).remove();
                        } else {
                            window.location.href = window.location.href;
                        }

                    });
                } else {
                    layer.close(loading);
                    layer.alert(data.message, { icon: 2 });

                }
            },
            error: function () {
                layer.close(loading);
                layer.alert('执行错误，请联系管理员！', { icon: 2 });
            }
        });
    }, function () {
    });
}
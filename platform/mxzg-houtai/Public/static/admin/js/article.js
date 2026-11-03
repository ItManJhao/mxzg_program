//
function openLayer(url,name){
    top.layer.open({
      type: 2,
      title: name,
      shadeClose: false,
      shade: 0.5,
      maxmin: true, //开启最大化最小化按钮
      area: ['70%', '70%'],
      content: url
    });
}

function hideModal(){
    $('.spinner123').modal('hide');
}

function showModal(){
    $('.spinner123').modal({backdrop:'static',keyboard:false});
}

function update_form(form_id,subbmit_url){
    showModal();
    //如果是有CKEditor的话，需要update，否则取不到值
    if (window.CKEDITOR) {
        for (instance in CKEDITOR.instances)
            CKEDITOR.instances[instance].updateElement();
    }
    var post_data = $("#"+form_id).serialize();
    // iframe_class = subbmit_url.replace(/ajax_updata/, "index");
    // console.log(iframe_class);
    $.ajax({
        url: subbmit_url,
        type: "post",
        dataType: "json",
        data: post_data,
        success:function(data){
            hideModal();
            top.layer.msg(data.message,
                {
                    time: 0, //4s后自动关闭
                    btn: ['明白了']
                }
            );
            return false;
            // if(data.status == 1){
            //     // parent.$("#content-main").find('iframe:visible')[0].contentWindow.$("#handle_status").val(data.status);
            //     // top.layer.msg(data.message);
            //     // var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
            //     // if (index) {
            //     //     // if (data.hasOwnProperty('url')) {
            //     //     //     parent.window.location.href = data.url;
            //     //     // } else {
            //     //     //     var _body = window.parent;
            //     //     //     // $("iframe[data-id='" + iframe_class + "']").contentWindow.location.reload(true);
            //     //     //     var _iframe1 = _body.$("iframe[data-id='" + iframe_class + "']");
            //     //     //     console.log(_iframe1);
            //     //     //     _iframe1.contentWindow.location.reload(true);
            //     //     //     // parent.window.location.reload();
            //     //     // }
            //     //     // top.layer.msg(data.message);
            //     //     alert(data.message);
            //     //     // return false;
            //     //     // window.location.href=location.href;
            //     //     // top.layer.close(index); //再执行关闭
            //     // }
            // }else if(data.status == 0){
            //     //layer.close();
            //     top.layer.msg(data.message,
            //             {
            //                 time: 0, //4s后自动关闭
            //                 btn: ['明白了']
            //             }
            //         );
            //     return false;
            // }
        }
    })
}

function getAjaxArticleList(divId,page) {
    $.ajax({
        url: "/index.php/Admin/Article/GetArticleList/p="+page,
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

function openYemian(url,name) {
    parent.layer.open({
        type: 2,
        title: name,
        shade: 0.5,
        shadeClose : false,
        maxmin: true, //开启最大化最小化按钮
        area: ['70%', '80%'],
        content: url,
        btn: ['关闭'],
        end : function(){
            var handle_status = $("#handle_status").val();
            var kind_id = $("#kind_id").val();
            if(kind_id > 0){
                window.location.href = '/Admin/Article/articleList/kind_id/'+kind_id+'.html';
            }else if(handle_status == '1'){
                window.location.href = location.href;
            }
        }
    });
}
function ajax_submit_form(form_id,submit_url){
    //如果是有CKEditor的话，需要update，否则取不到值
    // if (window.CKEDITOR) {
    //     for (instance in CKEDITOR.instances)
    //         CKEDITOR.instances[instance].updateElement();
    // }


    $.ajax({
        type : "POST",
        url  : submit_url,
        data : $('#'+form_id).serialize(),// 你的formid
        error: function(request) {
                alert("服务器繁忙, 请联系管理员!");
        },
        success: function(v) {
            console.log(typeof(v));
            before_request = 1;  // 标识ajax 请求已经返回
            var v =  eval('('+v+')');
                // 验证成功提交表单
            if(v.hasOwnProperty('status'))
            {
                top.layer.msg(v.message);
                parent.$("#content-main").find('iframe:visible')[0].contentWindow.$("#handle_status").val(v.status);
                if(v.status == 1){
                    var index = top.layer.getFrameIndex(window.name); //获取窗口索引
                    top.layer.close(index);
                    if(v.hasOwnProperty('data')){
                        if(v.data.hasOwnProperty('url')){
                            alert(v.data.url);
                            location.href = v.data.url;
                        }else{
                            alert(location.href);
                            location.href = location.href;
                        }
                    }else{
                        location.href = location.href;
                    }
                    return true;
                }

                if(v.status == 0)
                {
                    top.layer.msg(v.message);
                    return false;
                }
            }
        }
    });
}
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
function getAjaxUrl(divId,url) {
    $.ajax({
        url: url,
        type: "post",
        data: '',
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

// //复选框改变判断全选是否要选中
// function isCheckAlls(check_all, check_class){
//     var is_checked = 1;    
//     $("." + check_class).each(function(){
//         if($(this).is(":checked") == false) {    
//             is_checked = 0;
//         }
//     });
//     if(is_checked ==0){
//         $("#" + check_all).prop("checked",false);
//     }else{
//         $("#" + check_all).prop("checked",true);
//     }
// }
// //复选框全选或全不选
// function doCheckAlls(check_all, check_class){
//     var isCheckAll =$('input[id="' + check_all + '"]:checked').length;
//         if (isCheckAll==0) {
//             $("." + check_class).each(function() {
//                 this.checked = false;
//             });
//         } else if(isCheckAll==1) {
//             $("." + check_class).each(function() {
//                 this.checked = true;
//             });
//         }
// }
//复选框改变判断全选是否要选中
function isCheckAlls(check_all, check_class, last_this){
    var is_checked = 1;    
    $(last_this).parent().parent().find("." + check_class).each(function(){
        if($(this).is(":checked") == false) {
            is_checked = 0;
        }
    });
    if(is_checked == 0){
        $(last_this).parent().parent().parent().find("." + check_all).prop("checked",false);
    }else{
        $(last_this).parent().parent().parent().find("." + check_all).prop("checked",true);
    }
}
//复选框全选或全不选
function doCheckAlls(check_all, check_class, last_this){
    if($(last_this).is(":checked") == false) {
        $(last_this).parent().parent().parent().find("." + check_class).each(function() {
            if (this.value!="-1") {
                this.checked = false;
            }
        });
    }else{
        $(last_this).parent().parent().parent().find("." + check_class).each(function() {
            this.checked = true;
        });
    }
}

//搜索多选赋值
function doMultipleSelection(obj, class_name){
    var sid_str = '';
    var sid_text = '';
    $(obj).find("option:selected").each(function () {
        sid_str += $(this).val() + ",";
        sid_text += $(this).text() + ",";
    })
    if(sid_str != ''){
        sid_str = sid_str.slice(0,-1);
    }
    if(sid_text != ''){
        sid_text = sid_text.slice(0,-1);
    }
    $("input[name='" + class_name +"']").val(sid_str);
    $("." + class_name +"-text").html(sid_text);
}
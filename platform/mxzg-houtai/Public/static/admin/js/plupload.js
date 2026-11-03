//plupload文章多图上传
var pluploader = new plupload.Uploader({
//创建实例的构造方法
runtimes: 'html5,flash,silverlight,html4', 
//上传插件初始化选用那种方式的优先级顺序
browse_button: 'btn', // 上传按钮
url: "/index.php/Admin/Upload/more_img.html", //远程上传地址
flash_swf_url: 'plupload/Moxie.swf', //flash文件地址
silverlight_xap_url: 'plupload/Moxie.xap', //silverlight文件地址
filters: {
    max_file_size: '2mb', //最大上传文件大小（格式100b, 10kb, 10mb, 1gb）
    mime_types: [{title: "files", extensions: "jpg,png,gif,jpeg"}]
    //允许文件上传类型
},
multi_selection: false, //true:ctrl多文件上传, false 单文件上传
init: {
    FilesAdded: function(up, files) { //文件上传前 
        if ($("#ul_pics").children("tr").length > 10) {
            alert("您上传的图片太多了！");
            // uploader.destroy();
            return false;
        } else {
            var li = '';
            //上传进度条
            plupload.each(files, function(file) { //遍历文件
                // li += "<li id='" + file['id'] + "'><div class='progress'><span class='bar'></span><span class='percent'>0%</span></div></li>";
                li += "<tr id='" + file['id'] + "'></tr>";
            });
            $("#ul_pics").append(li);
            pluploader.start();
        }
    },
    UploadProgress: function(up, file) { //上传中，显示进度条
        // var percent = file.percent;
        // $("#" + file.id).find('.bar').css({"width": percent + "%"});
        // $("#" + file.id).find(".percent").text(percent + "%");
    },
    FileUploaded: function(up, file, info) { //文件上传成功的时候触发
        var data = JSON.parse(info.response);
        $("#" + file.id).html('<td><input type="text" class="form-control upload-path" name="slide_img[]" value="'+data.path+'"></td><td><input type="text" class="form-control" name="slide_alt[]" value="" placeholder="请输入图片标题"></td><td><input type="number" class="form-control" name="slide_order[]" value="50" placeholder="请输入图片序号"></td><td><button type="button" class="btn btn-sm btn-danger" onclick="$(this).parent().parent().remove()"><i class="fa fa-minus-square"></i> 删除</button></td>');
    },
    Error: function(up, err) { //上传出错的时候触发
        alert(err.message);
    }
}
});
pluploader.init();
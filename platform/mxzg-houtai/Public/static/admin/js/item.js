
function upitem(obj){
    // console.log(data_object);
    //获取所选值
    var selectedValue = $(obj).val();
    //先清空方向下拉菜单的option
    $(obj).next().empty();
    // 根据返回的数据拼接option
    var listFleet = "";
    $.each(data_object[selectedValue], function (key, item) {
        listFleet += "<option value='" + item.id + "'>" + item.id +"--"+ item.name + "</option>";
    });
    $(obj).next().append(listFleet); //填充selectFleet
}
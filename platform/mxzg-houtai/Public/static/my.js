//str 要截取的字符串
//len 要截取的长度
//dot 截取后，拼接什么字符
function substr_js(str,len,dot){
    if(str.length <= len){
      return str;
    }else{
      return str.substr(0,len)+dot;
    }    
}

function subString(str, len, hasDot)  
{  
    var newLength = 0;  
    var newStr = "";  
    var chineseRegex = /[^\x00-\xff]/g;  
    var singleChar = "";  
    var strLength = str.replace(chineseRegex,"**").length;
    for(var i = 0;i < strLength;i++)  
    {  
        singleChar = str.charAt(i).toString();  
        if(singleChar.match(chineseRegex) != null)  
        {  
            newLength += 2;  
        }      
        else  
        {  
            newLength++;  
        }  
        if(newLength > len)  
        {  
            break;  
        }  
        newStr += singleChar;
    }  

    if(hasDot && strLength > len)  
    {  
        newStr += "...";  
    }  
    return newStr;  
}

//time  时间戳 
function getLocalTime(time){
    // time = time + 8 * 3600;
    var d=new Date(time*1000);
    var day=d.getUTCDate();
    var month=d.getUTCMonth() + 1;
    var year=d.getUTCFullYear();
    var hour=d.getHours();     
    var minute=d.getMinutes();     
    var second=d.getSeconds();   

    // return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" +second;
    return year + "-" + month + "-" + day;
}
//time  时间戳 
function getYear(time){
    // time = time + 8 * 3600;
    var d=new Date(time*1000);
    var day=d.getUTCDate();
    var month=d.getUTCMonth() + 1;
    var year=d.getUTCFullYear();
    var hour=d.getHours();     
    var minute=d.getMinutes();     
    var second=d.getSeconds();   

    // return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" +second;
    return year + "-" + month;
}
function getDay(time){
    // time = time + 8 * 3600;
    var d=new Date(time*1000);
    var day=d.getUTCDate();
    var month=d.getUTCMonth() + 1;
    var year=d.getUTCFullYear();
    var hour=d.getHours();     
    var minute=d.getMinutes();     
    var second=d.getSeconds();   

    // return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" +second;
    return day;
}
function getLocalTime2(time){
    // time = time + 8 * 3600;
    var d=new Date(time*1000);
    var day=d.getUTCDate();
    var month=d.getUTCMonth() + 1;
    var year=d.getUTCFullYear();
    var hour=d.getHours();     
    var minute=d.getMinutes();     
    var second=d.getSeconds();   

    // return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" +second;
    return month + "-" + day;
}
function getLocalTime3(time){
    // time = time + 8 * 3600;
    var d=new Date(time*1000);
    var day=d.getUTCDate();
    var month=d.getUTCMonth() + 1;
    var year=d.getUTCFullYear();
    var hour=d.getHours();     
    var minute=d.getMinutes();     
    var second=d.getSeconds();   

    // return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" +second;
    return year;
}
//时间戳互换
function js_strto_time(str_time){
    var new_str = str_time.replace(/:/g,'-');
    new_str = new_str.replace(/ /g,'-');
    var arr = new_str.split("-");
    var datum = new Date(Date.UTC(arr[0],arr[1]-1,arr[2],arr[3]-8,arr[4],arr[5]));
    return strtotime = datum.getTime()/1000;
}

function js_date_time(unixtime) {
    var timestr = new Date(parseInt(unixtime) * 1000);
    var datetime = timestr.toLocaleString().replace(/年|月/g, "-").replace(/日/g, " ");
    return datetime;
}

//过滤hmtl标签
function removeHtml(str) {
    str = str.replace(/<\/?[^>]*>/g,''); //去除HTML tag
    str = str.replace(/[ | ]*\n/g,'\n'); //去除行尾空白
    //str = str.replace(/\n[\s| | ]*\r/g,'\n'); //去除多余空行
    str=str.replace(/ /ig,'');//去掉 
    return str;
}

//html字符串转换为 HTML 实体 htmlspecialchars
function htmlspecialchars(str){
    str = str.replace(/&/g, '&amp;');
    str = str.replace(/</g, '&lt;');
    str = str.replace(/>/g, '&gt;');
    str = str.replace(/"/g, '&quot;');
    str = str.replace(/'/g, '&#039;');
    return str;
}

//去掉html标签
function removeHtmlTab(tab) {  
return tab.replace(/<[^<>]+?>/g,'');//删除所有HTML标签 
} 
//普通字符转换成转意符
function html2Escape(sHtml) {  
    return sHtml.replace(/[<>&"]/g,function(c){return {'<':'<','>':'>','&':'&','"':'"'}[c];}); 
} 
//转意符换成普通字符
function escape2Html(str){
    var arrEntities={'lt':'<','gt':'>','nbsp':' ','amp':'&','quot':'"'};
    return str.replace(/&(lt|gt|nbsp|amp|quot);/ig,function(all,t){return arrEntities[t];});
}
//  转成空格
function nbsp2Space(str) { 
 var arrEntities = {'nbsp' : ' '}; 
  return str.replace(/&(nbsp);/ig, function(all, t){return arrEntities[t]})
 } 
//回车转为br标签
function return2Br(str) { 
 return str.replace(/\r?\n/g,"<br />"); 
} 
// 将多个连续空格合并成一个空格
function mergeSpace(str) { 
 str=str.replace(/(\s| )+/g,' '); 
  return str; 
} 
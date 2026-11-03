var $parentNode = window.parent.document;

function $childNode(name) {
    return window.frames[name]
}

// tooltips
$('.tooltip-demo').tooltip({
    selector: "[data-toggle=tooltip]",
    container: "body"
});

// 使用animation.css修改Bootstrap Modal
$('.modal').appendTo("body");

$("[data-toggle=popover]").popover();

//折叠ibox
$('.collapse-link').click(function () {
    var ibox = $(this).closest('div.ibox');
    var button = $(this).find('i');
    var content = ibox.find('div.ibox-content');
    content.slideToggle(200);
    button.toggleClass('fa-chevron-up').toggleClass('fa-chevron-down');
    ibox.toggleClass('').toggleClass('border-bottom');
    setTimeout(function () {
        ibox.resize();
        ibox.find('[id^=map-]').resize();
    }, 50);
});

//关闭ibox
$('.close-link').click(function () {
    var content = $(this).closest('div.ibox');
    content.remove();
});

//判断当前页面是否在iframe中
if (top == this) {
    var gohome = '<div class="gohome"><a class="animated bounceInUp" href="index.html?v=4.0" title="返回首页"><i class="fa fa-home"></i></a></div>';　
    $('body').append(gohome);
}

//animation.css
function animationHover(element, animation) {
    element = $(element);
    element.hover(
        function () {
            element.addClass('animated ' + animation);
        },
        function () {
            //动画完成之前移除class
            window.setTimeout(function () {
                element.removeClass('animated ' + animation);
            }, 2000);
        });
}

//拖动面板
function WinMove() {
    var element = "[class*=col]";
    var handle = ".ibox-title";
    var connect = "[class*=col]";
    $(element).sortable({
            handle: handle,
            connectWith: connect,
            tolerance: 'pointer',
            forcePlaceholderSize: true,
            opacity: 0.8,
        })
        .disableSelection();
};


//实现table表头左右拖动
$(function () {
    var isMouseDown = false;
    var currentTh = null;
   $('table th').bind({
       mousedown:function (e) {
           var $th = $(this);
           var left = $th.offset().left; //元素距左
           var rightPos = left + $th.outerWidth();
           if (rightPos-4<= e.pageX && e.pageX <= rightPos) {
               isMouseDown = true;
               currentTh = $th;
               $('table th').css('cursor','ew-resize');

               //创建遮罩层，防止mouseup事件被其它元素阻止冒泡，导致mouseup事件无法被body捕获，导致拖动不能停止
               var bodyWidth = $('body').width();
               var bodyHeight = $('body').height();
               $('body').append('<div id="mask" style="opacity:0;top:0px;left:0px;cursor:ew-resize;background-color:green;position:absolute;z-index:9999;width:'+bodyWidth+'px;height:'+bodyHeight+'px;"></div>');
           }
       }
       
   });

   $('body').bind({
       mousemove:function(e) {
           //移动到column右边缘提示
           $('table th').each(function (index,eleDom) {
               var ele = $(eleDom);
               var left = ele.offset().left; //元素距左
               var rightPos = left + ele.outerWidth();
               if (rightPos-4<= e.pageX && e.pageX <= rightPos) { //移到列右边缘
                   ele.css('cursor','ew-resize');
               }else{
                   if(!isMouseDown){ //不是鼠标按下的时候取消特殊鼠标样式
                       ele.css("cursor","auto");
                   }
               }
           });

           //改变大小
           if(currentTh != null){
               if(isMouseDown){ //鼠标按下了，开始移动
                   var left = currentTh.offset().left;
                   var paddingBorderLen = currentTh.outerWidth()-currentTh.width();
                   currentTh.width((e.pageX-left-paddingBorderLen)+'px');
               }
           }
       },
       mouseup:function (e) {
           isMouseDown = false;
           currentTh = null;
           $('table th').css('cursor','auto');
           $('#mask').remove();
       }
   });


});
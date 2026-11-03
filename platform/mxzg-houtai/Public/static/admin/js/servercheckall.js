$(".server-check").click(function(){    
    isCheckAlls('check-all','server-check', $(this));
});
$(".check-all").click(function () {
    doCheckAlls('check-all', 'server-check', $(this));
});
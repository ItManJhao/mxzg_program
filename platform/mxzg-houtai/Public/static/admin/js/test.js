$(function(){
	$(document).on('change','.category_add',function(){
		var ht = $(this);
		var val = ht.val();
		var count = parseInt(ht.attr('count'));

		// alert(count);
		if(val == 0){
			return false;
		}
		$('#category_pid').val(val);
		$('#category_count').val(count+1);
		ht.parent().nextAll().remove();
		// alert(val);
		// return false;
		$.ajax({ 
			url:category_add,
			// data:'acc=123',
			data:{val:val},
			type:'get',
			dataType:'json',
			success:function(result){
				// alert(result);
				var id = $('#category_id').val();//隐藏框的分类id
				if(result.category){
					var res = result.category;
					count++;
					var select = '<div class="col-sm-2"><select class="form-control category_add" count="'+count+'"><option value="0">请选择</option>';
					for(var i = 0 in res){
						if(res[i].id != id){
							select += '<option value="'+res[i].id+'">'+res[i].name+'</option>';
						}else{
							var pig = 1;
						}
					}	 
					if(pig == 1 && !res[1]){
						return false;
					}
					select += '</select></div>';
					ht.parent().parent().append(select);
					// $('select').select2();
				}
				// if(result.brand){
				// 	// alert(2);
				// 	var brand = result.brand;
				// 	var brand_radio = '';
				// 	for(var j = 0 in brand){
				// 		// alert(brand[j].name)
				// 		brand_radio += '<label><input type="radio" name="brand_id" value="'+brand[j].id+'" />'+brand[j].name+'<img src="'+upload+brand[j].img+'" height="28" width="96"/>'+'</label>';
				// 	}
				// 	// alert(brand_radio)
				// 	$('#brands_list .controls').html(brand_radio);
				// 	$('#brands_list').show();
				// }else{
				// 	// alert(1322);

				// 	$('#brands_list').hide();
				// 	$('#brands_list .controls').html('');					
				// }
				
			}
		});
		return false;
	});
});
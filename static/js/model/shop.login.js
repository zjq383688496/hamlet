/**
 * 
 */


$().ready(function() {
	
	var errorTimes = 0;

	var loginValidate = function(){
		var $userEmail = $('#userEmail');
		var $passwd = $('#passwd');
//		var $randomCode = $('#randomCode');
		
		var pass = true;
		
		if($userEmail.val() == null || $.trim($userEmail.val()) == ""){
			pass = false;
			$('.mail-error-tips').show();
		}
		
		if($passwd.val() == null || $.trim($passwd.val()) == ""){
			pass = false;
			$('#passwd').next().show();
		}
		
		
//		if($randomCode.val() == null || $.trim($randomCode.val()) == ""){
//			pass = false;
//			$('#randomCode').next('span').show();
//		}
		
		return pass;
	}


	var ajax_option = {
			beforeSubmit:function(){return loginValidate()},
			success:function(result){
				console.info(result);
				console.info(hamlet.base);
				if(result.status == 200){
					if($('#redirectUrl').val() == ""){
						window.location.href="/";
					}else{
						window.location.href=$('#redirectUrl').val();
					}
					
				}else if(result.status ==515){
					$('#randomCode').next().next().show();
				}else if(result.status == 517){
					$('.mail-error-tips').show();
				}else if(result.status == 518){
					$('#passwd').next().show();
				}
				
				errorTimes = errorTimes + 1;
				if(errorTimes >= 3){
					$('#needRandomCode').val("true");
					$('#needRandomCodeDiv').show();
				}
				
				$('#changeImg').trigger("click");
				
			}
	};
	
	$('#changeImg').click(function(){
		$('#reloadMobileImage').attr('src',hamlet.base+'/common/captcha.action?time='+new Date().getTime());
	});
	
	
	var $loginForm = $('#loginForm');
	
	$('#formSubmit').click(function(){
		
		$('#randomCode').next().next().hide();
		$('.mail-error-tips').hide();
		$('#passwd').next('span').hide();
		
		
		$loginForm.ajaxSubmit(ajax_option);
		return false;
		
	});
	
});
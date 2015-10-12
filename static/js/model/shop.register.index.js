/**
 * 
 */
var mobileValidate = function(){
	$userMobile = $('#userMobile');
	$mobileVCode = $('#mobileVCode');
	$mobileCode = $('#mobileCode');
	$repeatMPasswd = $('#repeatMPasswd');
	$repeatSPasswd = $('#repeatSPasswd');
	
	$('#userMobileTip').hide();
	$('#repeatMPasswdTip').hide();
	$('#repeatSPasswdTip').hide();
	$('#mobileVCodeTip').hide();
	$('#mobileCodeTip').hide();
	
	var pass = true;
	
	if(!$('#agreei').hasClass('focusin')){
		alert("请同意用户协议相关条款和条件");
		pass = false;
		return pass;
	}
	
	
	var mobilePatrn = /^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\d{8}$/;
	if (!mobilePatrn.exec($userMobile.val())){
		$('#userMobileTip span:first').text("请填写11位手机号码");
		$('#userMobileTip').show();
		pass =  false;
	}
	
	var repeatMPasswdPatrn = /^[\w.]{6,20}$/;
	if(!repeatMPasswdPatrn.exec($repeatMPasswd.val())){
		$('#repeatMPasswdTip span:first').text("请填写6-20位的密码，支持字母、数字或者符号");
		$('#repeatMPasswdTip').show();
		pass =  false;
	}
	
	if($repeatMPasswd.val() != $repeatSPasswd.val()){
		$('#repeatSPasswdTip span:first').text("两次密码不一致,请重新输入");
		$('#repeatSPasswdTip').show();
		pass =  false;
	}
	
	return pass;
}

var emailValidate = function(){
	var $userEmailTip = $('#userEmailTip');
	var $userPasswdTip = $('#userPasswdTip');
	var $repeatPasswdTip = $('#repeatPasswdTip');
	var $emailCodeTip = $('#emailCodeTip');
	
	$userEmailTip.hide();
	$userPasswdTip.hide();
	$repeatPasswdTip.hide();
	$emailCodeTip.hide();
	
	var pass = true;
	
	if(!$('#agreei').hasClass('focusin')){
		alert("请同意用户协议相关条款和条件");
		pass = false;
		return pass;
	};
	
	var emailPatrn = /^(\w)+(\.\w+)*@(\w)+((\.\w{2,3}){1,3})$/;
	
	
	if (!emailPatrn.exec($('#userEmail').val())){
		$('#userEmailTip span:first').text("请填写正确的邮箱");
		$('#userEmailTip').show();
		pass =  false;
	}
	
	
	if($('#userPasswd').val() != $('#repeatPasswd').val()){
		$('#repeatPasswdTip span:first').text("两次密码不一致,请重新输入");
		$('#repeatPasswdTip').show();
		pass =  false;
	}
	
	return pass;
	
};


var resendTime = 60;
function time(o) {
	var $o = o;
    if (resendTime == 0) {
        $o.removeAttr("disabled");
        $o.removeClass("off");
        $o.val("免费获取验证码");
        resendTime = 60;
    } else {
    	$o.attr("disabled", true);
        $o.val(resendTime+"秒后重新获取验证码");
        resendTime--;
        setTimeout(function() {
            time(o)
        },
        1000)
    }
}

$().ready(function() {
	
	var mobileVCodeErrorTimes = getCookie('memberVCodeErrorTimes');
	
	if(mobileVCodeErrorTimes>=3){
		$('#pictureV').show();
	}else{
		$('#pictureV').hide();
	}
	
	$('#agreei').click(function(){
		$(this).toggleClass('focusin');
	})
	
	$('#getVCode').click(function(){
		var mobilePatrn = /^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\d{8}$/;
		if (!mobilePatrn.exec($('#userMobile').val())){
			$('#userMobileTip span:first').text("请填写11位手机号码");
			$('#userMobileTip').show();
			return;
		}
		console.info($('#userMobile').val());
		$.post(hamlet.base+'/register/verification/getPhoneVerification.action',{'phoneNumber':$('#userMobile').val()},function(result){
			if(!result.status == '0'){
				alert('验证码已经发送')
				$('#getVCode').addClass("off");
				$('#getVCode').attr('disabled',"true");
				time($('#getVCode'));
			}else{
				alert(result.data);
			}
			
			
		});
	});
	
	
	
	$('#changeImg2').click(function(){
		$('#reloadMobileImage2').attr('src',hamlet.base+'/common/captcha.action?time='+new Date().getTime());
	});
	
	$('#changeImg').click(function(){
		$('#reloadMobileImage').attr('src',hamlet.base+'/common/captcha.action?time='+new Date().getTime());
	});
	
	
	var $MobileForm = $('#MobileForm');
	var $EmailForm = $('#EmailForm');
	
	
	
	$('.mobileReg').click(function(){
		$('#mobileWrapperFull').show();
		$('#registerWrapperFull').hide();
		$('.emailReg  i:first').removeClass('focusi');
		$('.mobileReg i:first').addClass('focusi');
		$('.siderbar').animate({left:'0px'})
		
		
	});
	
	
	$('.emailReg').click(function(){
		$('#mobileWrapperFull').hide();
		$('#registerWrapperFull').show();
		$('.mobileReg  i:first').removeClass('focusi');
		$('.emailReg i:first').addClass('focusi');
		$('.siderbar').animate({left:'375px'})
	});
	
	
	
	$('#regMobileSubmit').click(function(){
		$('#userMobileTip').hide();
		$('#repeatMPasswdTip').hide();
		$('#repeatSPasswdTip').hide();
		$('#mobileVCodeTip').hide();
		$('#mobileCodeTip').hide();
			var ajax_option = {
					beforeSubmit:function(){return mobileValidate()},
					success:function(result){
						if(result.status == 200){
							var h = new hamlet();
							window.location.href=h.base;
						}else if(result.status == 511 || result.status == 512){
							$('#mobileVCodeTip span:first').text(result.data);
							$('#mobileVCodeTip').show();
							mobileVCodeErrorTimes += 1;
						}else if(result.status == 513){
							$('#userMobileTip span:first').text(result.data);
							$('#userMobileTip').show();
						}else if(result.status == 514){
							$('#repeatMPasswdTip span:first').text(result.data);
							$('#repeatMPasswdTip').show();
						}else if(result.status ==515){
							$('#mobileCodeTip').show();
						}
						
						if(mobileVCodeErrorTimes>=3){
							$('#pictureV').show();
							$('#captchaId').val('true')
						};
					}
			};
			
			$MobileForm.ajaxSubmit(ajax_option);
		});
	
		$('#regEmailSubmit').click(function(){
			var ajax_option = {
					beforeSubmit:function(){return emailValidate()},
					success:function(result){
						var h = new hamlet();
						if(result.status == 200){
							window.location.href=h.base;
						}else if(result.status == 514){
							$('#repeatMPasswdTip span:first').text(result.data);
							$('#repeatMPasswdTip').show();
						}else if(result.status ==515){
							$('#emailCodeTip').show();
						}else if(result.status ==516){
							
							$('#userEmailTip span:first').text(result.data);
							$('#userEmailTip').show();
						}
						
					}
			};
			
			$EmailForm.ajaxSubmit(ajax_option);
		
	});
	
});
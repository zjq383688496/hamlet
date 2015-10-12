<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>${message("shop.login.title")}</title>

<link rel="icon" href="<@website.static />/resources/shop/images/favicon.ico" type="image/x-icon" />
<link href="<@website.static />/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="<@website.static />/resources/shop/css/login.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.validate.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/jsbn.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/prng4.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/rng.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/rsa.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/base64.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.form.js"></script>
<script type="text/javascript">
$().ready(function() {
 
 	
 	//var redirectUrl = "${redirectUrl}";
 	//if(redirectUrl == null || redirectUrl == ""){
 	//	redirectUrl = "/";
 	//}
	var $loginForm = $("#loginForm");
	var $username = $("#username");
	var $password = $("#password");
	var $captcha = $("#captcha");
	var $captchaImage = $("#captchaImage");
	var $isRememberUsername = $("#isRememberUsername");
	var $submit = $(":submit");
	
	// 记住用户名
	if (getCookie("memberUsername") != null) {
		$isRememberUsername.prop("checked", true);
		$username.val(getCookie("memberUsername"));
		$password.focus();
	} else {
		$isRememberUsername.prop("checked", false);
		$username.focus();
	}
	
	// 更换验证码
	$captchaImage.click(function() {
		$captchaImage.attr("src", "${base}/common/captcha.action?captchaId=${captchaId}&timestamp=" + (new Date()).valueOf());
	});
	
	// 表单验证、记住用户名
	$loginForm.validate({
		rules: {
			username: "required",
			password: "required"
			<#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberLogin")>
				,captcha: "required"
			</#if>
		},
		submitHandler: function(form) {
			$.ajax({
				url: "${base}/common/public_key.action",
				type: "GET",
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$submit.prop("disabled", true);
				},
				success: function(data) {
					var rsaKey = new RSAKey();
					rsaKey.setPublic(b64tohex(data.modulus), b64tohex(data.exponent));
					var enPassword = hex2b64(rsaKey.encrypt($password.val()));
					$.ajax({
						url: $loginForm.attr("action"),
						type: "POST",
						data: {
							username: $username.val(),
							enPassword: enPassword
							<#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberLogin")>
								,captchaId: "${captchaId}",
								captcha: $captcha.val()
							</#if>
						},
						dataType: "json",
						cache: false,
						success: function(message) {
							if ($isRememberUsername.prop("checked")) {
								addCookie("memberUsername", $username.val(), {expires: 7 * 24 * 60 * 60});
							} else {
								removeCookie("memberUsername");
							}
							$submit.prop("disabled", false);
							if (message.type == "success") {
								<#if redirectUrl??>
									location.href = "${redirectUrl}";
								<#else>
									location.href = "${base}/";
								</#if>
							} else {
								$.message(message);
								<#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberLogin")>
									$captcha.val("");
									$captchaImage.attr("src", "${base}/common/captcha.action?captchaId=${captchaId}&timestamp=" + (new Date()).valueOf());
								</#if>
							}
						}
					});
				}
			});
		}
	});

});
</script>
</head>
<body>
<#include "/shop/include/header.ftl" />

<div id="wrapper" >
	<form id="pwdforget" action="http://my.ule.com/usr/forgetUserInfor.do" method="post">
		<input type="hidden" name="item" id="item" value="passwd" />
		<input type="hidden" name="userNameForget" id="userNameForget" />
	</form>

	<form id="loginForm" action="<@website.web/>/login/submit/new.action" class="uiForm" method="post" autocomplete="off">
	<input name="token" id="token" type="hidden">
	<input name="redirectUrl" id="redirectUrl" type="hidden" value="${redirectUrl}">
	<input name="needRandomCode" id="needRandomCode" type="hidden" <#if Session["login.error.times"] gt 2> value="true"</#if>>
	<@ad_position id = 10 />
	<div class="wrapper-box" style="background: url(${loginAd}) 50% 50% no-repeat;"></div>
	<div class="login-box">
		<div class="login-form">
			<span class="del"></span>
			<span class="auto-mail-fixed"></span>
			<span class="box-title">登录</span>		
			<div class="email-wrap">
				<i class="email-icon"></i>
				<input type="text" id="userEmail" class="account" name="userEmail" autocomplete="off" placeholder="邮箱地址或手机号码">	
				<span class="mail-error-tips" >请输入正确的手机号码或邮箱地址</span>
			</div>

			<div class="input-wrap">
				<i class="pwd-icon"></i>
				<input type="password" id="passwd" class="password" name="passwd" autocomplete="off" placeholder="密码">
				<span class="psd-error-tips">请输入正确的密码</span>
			</div>

			<div id="needRandomCodeDiv" class="input-wrap" <#if Session["login.error.times"] lt 2>style="display:none"</#if>>
				<i class="code-icon"></i>
				<input type="text" id="randomCode" class="validate" name="randomCode" tabindex="2"  autocomplete="off" placeholder="验证码">
				<div class="wrapImg">
					<a id="changeImg" href="javascript:void(0)"><img class="captcha" name="reloadMobileImage" id="reloadMobileImage" src="<@website.web/>/common/captcha.action"></a>
				</div>
				<span class="psd-error-tips">请输入正确的验证码</span>
			</div>

			<div class="autologin">
				<!--<input type="checkbox" name="freeLogin" id="J_autologin" tabindex="3" value="Y" >
				<label for="J_autologin" class="autotip">这台电脑30天内免登录</label>-->
				<span class="forgot"><em id="forget">忘记密码？</em></span>
			</div>

			<input id="formSubmit" type="button" value="立即登录" tabindex="4" class="login-btn">

			<span class="no-account">没有帐号？<a href="<@website.web/>/register.action"><em id="reg">立即注册</em></a></span>
			
			<!--
			<div class="coop-site" id="openId">
				<span class="txt">您也可以使用以下合作网站登录</span>
				<a href="#" class="pic-link1 sina" onclick='openWind("http://my.ule.com/usr/ThirdpartyLogin.do?thirdtype=sina")'></a>
				<a href="http://my.ule.com/usr/ThirdpartyLogin.do?thirdtype=qq" class="pic-link2"></a>
				<a href="#" class="pic-link3 tom"></a>
				<a href="#" class="pic-link4 ziyouyizu"></a>
				<a href="https://passport.yusi.tv/?urlparam=user/ule/webtoule" class="pic-link5"></a>
			</div>
			-->

			<div class="alpha-layout"></div>
		</div>	
	</div>

	<div class="wrapper-container">
		<span  class="wrapper-btn"></span>
	</div>
	</form>
</div>





<!-- <div class="container login">
	<div class="span12">
		<@ad_position id = 9 />
	</div>
	<div class="span12 last">
		<div class="wrap">
			<div class="main">
				<div class="title">
					<strong>${message("shop.login.title")}</strong>USER LOGIN
				</div>
				<form id="loginForm" action="${base}/login/submit.action" method="post">
					<table>
						<tr>
							<th>
								<#if setting.isEmailLogin>
									${message("shop.login.usernameOrEmail")}:
								<#else>
									${message("shop.login.username")}:
								</#if>
							</th>
							<td>
								<input type="text" id="username" name="username" class="text" maxlength="${setting.usernameMaxLength}" />
							</td>
						</tr>
						<tr>
							<th>
								${message("shop.login.password")}:
							</th>
							<td>
								<input type="password" id="password" name="password" class="text" maxlength="${setting.passwordMaxLength}" autocomplete="off" />
							</td>
						</tr>
						<#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberLogin")>
							<tr>
								<th>
									${message("shop.captcha.name")}:
								</th>
								<td>
									<span class="fieldSet">
										<input type="text" id="captcha" name="captcha" class="text captcha" maxlength="4" autocomplete="off" /><img id="captchaImage" class="captchaImage" src="${base}/common/captcha.action?captchaId=${captchaId}" title="${message("shop.captcha.imageTitle")}" />
									</span>
								</td>
							</tr>
						</#if>
						<tr>
							<th>
								&nbsp;
							</th>
							<td>
								<label>
									<input type="checkbox" id="isRememberUsername" name="isRememberUsername" value="true" />${message("shop.login.isRememberUsername")}
								</label>
								<label>
									&nbsp;&nbsp;<a href="${base}/password/find.action">${message("shop.login.findPassword")}</a>
								</label>
							</td>
						</tr>
						<tr>
							<th>
								&nbsp;
							</th>
							<td>
								<input type="submit" class="submit" value="${message("shop.login.submit")}" />
							</td>
						</tr>
						<tr class="register">
							<th>
								&nbsp;
							</th>
							<td>
								<dl>
									<dt>${message("shop.login.noAccount")}</dt>
									<dd>
										${message("shop.login.tips")}
										<a href="${base}/register.action">${message("shop.login.register")}</a>
									</dd>
								</dl>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
</div> -->


 

<#include "/shop/include/footer.ftl" />
<script type="text/javascript" src="<@website.static />/resources/shop/js/model/shop.login.js"></script>
</body>
</html>
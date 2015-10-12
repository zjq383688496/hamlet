<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>${message("shop.register.title")}</title>

<link rel="icon" href="<@website.static />/resources/shop/images/favicon.ico" type="image/x-icon" />
<link href="<@website.static />/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="<@website.static />/resources/shop/css/register.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.validate.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.form.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/jsbn.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/prng4.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/rng.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/rsa.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/base64.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/shop/datePicker/WdatePicker.js"></script>
<script type="text/javascript">
$().ready(function() {
	console.info(hamlet.base);
}); 
</script>
</head>
<body>
<#include "/shop/include/header.ftl" />


<div id="register">
	<div id="wrapper">
		<!-- tab -->
		<div class="navul">
			<ul class="clearfix">
				<li class="mobileReg"><i class="focusi"></i>手机注册</li>
				<li class="emailReg"><i class=""></i>邮箱注册</li>
			</ul>
			<p class="siderbar"></p>
		</div>

		<!-- Mobile -->
		<div id="mobileWrapperFull" >
			<form action="<@website.web />/register/byPhone/submit.action" method="post" style="margin-left:93px;" id="MobileForm" name="MobileForm" onsubmit="return mobileValidate()" autocomplete="off">
				<fieldset>
					<div class="formRow">
						<label class="label" for="userMobile">手机号码</label>
						<div class="inputboxWrapperStd">
							<input type="text" id="userMobile" class="inputbox std" name="userMobile" value="" placeholder="请输入您的手机号" >
						</div>
						<span class="msgHolder">
							<span id="userMobileTip" style="display:none">
								<span class="error">请输入您的手机号</span>
							</span>
						</span>
					</div>
					
					
					<div class="formRow">
						<label class="label" for="mobileCode">短信验证码</label>
						<div class="wrapcode">
							<div class="wrapRandCode clearfix">
								<div class="inputboxWrapperShort">
									<input type="text" id="mobileVCode" class="inputbox short msged val" name="mobileVCode" maxlength="6" size="8">
									<input type="button" id="getVCode" name="getVCode" value="免费获取验证码">
								</div>
							</div>

						</div>
						<span class="msgHolder">
							<span id="mobileVCodeTip" class="onError" style="display:none">
								<span class="error">请输入你收到的短信验证码</span>
							</span>
						</span>
					</div>
					
					<div id="pictureV" class="formRow" style="display:none">
						<label class="label" for="mobileCode">验证码</label>
						<div class="wrapcode">
							<div class="wrapRandCode clearfix">
								<div class="inputboxWrapperShort">
									<input type="text" id="mobileCode" class="inputbox short msged val" name="mobileCode" maxlength="4" size="8">
								</div>
								<div class="wrapImg">
									<a href="javascript:void(0)" id="changeImg" class="changeImg">
										<input type="hidden" name="captchaId" id="captchaId"/>
										<img class="captcha" name="reloadMobileImage" id="reloadMobileImage" src="<@website.web/>/common/captcha.action">
									</a>
								</div>
							</div>

						</div>
						<span class="msgHolder">
							<span id="mobileCodeTip" class="onError" style="display:none">
								<span class="error">请输入图片验证码</span>
							</span>
						</span>
					</div>

					<div class="formRow">
						<label class="label" for="repeatMPasswd">设置密码</label>
						<div class="inputboxWrapperStd">
							<input type="password" id="repeatMPasswd" class="inputbox std" name="userPasswd"  />
						</div>
						<span class="msgHolder">
							<span id="repeatMPasswdTip" style="display:none">
								<span class="error">请输入你的密码</span>
							</span>
						</span>
					</div>
					
					<div class="formRow">
						<label class="label" for="repeatSPasswd">确认密码</label>
						<div class="inputboxWrapperStd">
							<input type="password" id="repeatSPasswd" class="inputbox std" name="repeatPasswd" >
						</div>
						<span class="msgHolder">
							<span id="repeatSPasswdTip" style="display:none">
								<span class="error">请输入确认密码</span>
							</span>
						</span>
					</div>
					
					<div class="formRow labelFree positr">
						<i id="agreei" class="focusin"></i>
						<input type="hidden" id="agreePrivacy2" name="agreePrivacy2"  value="1">
						<label for="agreePrivacy" class="secondary">
							我接受 <a class="blueLink" href="" target="_blank">《哈姆雷特用户协议》</a> 及其相关的条款和条件
						</label>
						<div id="policymobtips" class="policymobtips">
							<span class="msgRow"></span>
						</div>
					</div>

					<div class="formRow labelFree">
						<input type="hidden" id="regtype" name="regtype" value="mobile">
						<a id="regMobileSubmit" class="regMobBtn" href="javascript:void(0);">立即注册</a>
					</div>
				</fieldset>
			</form>
		</div>

		<!-- Email -->
		<div id="registerWrapperFull" style="display: none;">
			<input type="hidden" id="formDisplay" value="MobileForm" />
			<form id="EmailForm" name="EmailForm" action="<@website.web />/register/byEmail/submit.action" method="post">
				<input type="hidden" id="emailStatus" name="emailStatus" value="" />
				<input type="hidden" id="channelType" name="channelType" value="" />
				<input type="hidden" id="inviter" name="inviter" value="" />
				<input type="hidden" id="backurl" name="backurl" value="" />
				<fieldset>
					<div class="formRow">
						<label class="label" for="userEmail">邮箱地址</label>
						<div class="inputboxWrapperStd">
							<input type="text" id="userEmail" class="inputbox std" name="userEmail" value="" tabindex="1" />
						</div>
						<span class="msgHolder">
							<span id="userEmailTip" style="display:none">
								<span class="error">请输入您的邮箱地址</span>
							</span>
						</span>
					</div>

					<div class="formRow">
						<label class="label" for="userPasswd">密码</label>
						<div class="inputboxWrapperStd">
							<input type="password" id="userPasswd" class="inputbox std" name="userPasswd" tabindex="2" />
						</div>
						<span class="msgHolder">
							<span id="userPasswdTip" style="display:none">
								<span class="msgRow">请输入您的密码</span>
							</span>
						</span>
					</div>

					<div class="formRow">
						<label class="label" for="repeatPasswd">确认密码</label>
						<div class="inputboxWrapperStd">
							<input type="password" id="repeatPasswd" class="inputbox std" name="repeatPasswd" tabindex="3" />
						</div>
						<span class="msgHolder">
							<span id="repeatPasswdTip" style="display:none">
								<span class="msgRow">请输入确认密码</span>
							</span>
						</span>
					</div>

					<div class="formRow">

						<label class="label" for="randomCode">验证码</label>
						<div class="wrapcode">
							<div class="wrapRandCode clearfix">
								<div class="inputboxWrapperShort">
									<input name="keys" id="keys" type="hidden" >
									<input type="text" id="randomCode" class="inputbox short msged val" name="randomCode" maxlength="4" size="8">
								</div>
								<div class="wrapImg">
									<a href="javascript:void(0)" id="changeImg2" class="changeImg">
										<img class="captcha" name="reloadMobileImage" id="reloadMobileImage2" src="<@website.web/>/common/captcha.action">
									</a>
								</div>
							</div>

						</div>
						<span class="msgHolder">
							<span id="emailCodeTip" class="onError" style="display:none">
								<span class="error">验证码不正确</span>
							</span>
						</span>
						
					</div>



					<div class="formRow labelFree positr">
						<i id="agreei" class="focusin"></i>
						<input type="hidden" id="agreePrivacy" name="agreePrivacy"  value="1">
						<label for="agreePrivacy" class="secondary">
							我接受 <a class="blueLink" href="" target="_blank">《哈姆雷特用户协议》</a> 及其相关的条款和条件
						</label>
						<div id="policytips" class="policytip">
							<span class="msgRow"></span>
						</div>
					</div>

					<div class="formRow labelFree">
						<input type="hidden" id="regtype" name="regtype" value="email">
						<a id="regEmailSubmit" class="regMobBtn" href="javascript:void(0);">立即注册</a>
					</div>

				</fieldset>
			</form>
			
		</div>

	</div>
</div>



<!-- <div class="container register">
	<div class="span24">
		<div class="wrap">
			<div class="main clearfix">
				<div class="title">
					<strong>${message("shop.register.title")}</strong>USER REGISTER
				</div>
				<form id="registerForm" action="${base}/register/submit.action" method="post">
					<table>
						<tr>
							<th>
								<span class="requiredField">*</span>${message("shop.register.username")}:
							</th>
							<td>
								<input type="text" id="username" name="username" class="text" maxlength="${setting.usernameMaxLength}" />
							</td>
						</tr>
						<tr>
							<th>
								<span class="requiredField">*</span>${message("shop.register.password")}:
							</th>
							<td>
								<input type="password" id="password" name="password" class="text" maxlength="${setting.passwordMaxLength}" autocomplete="off" />
							</td>
						</tr>
						<tr>
							<th>
								<span class="requiredField">*</span>${message("shop.register.rePassword")}:
							</th>
							<td>
								<input type="password" name="rePassword" class="text" maxlength="${setting.passwordMaxLength}" autocomplete="off" />
							</td>
						</tr>
						<tr>
							<th>
								<span class="requiredField">*</span>${message("shop.register.email")}:
							</th>
							<td>
								<input type="text" id="email" name="email" class="text" maxlength="200" />
							</td>
						</tr>
						<@member_attribute_list>
							<#list memberAttributes as memberAttribute>
								<tr>
									<th>
										<#if memberAttribute.isRequired><span class="requiredField">*</span></#if>${memberAttribute.name}:
									</th>
									<td>
										<#if memberAttribute.type == "name">
											<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" maxlength="200" />
										<#elseif memberAttribute.type == "gender">
											<span class="fieldSet">
												<#list genders as gender>
													<label>
														<input type="radio" name="memberAttribute_${memberAttribute.id}" value="${gender}" />${message("Member.Gender." + gender)}
													</label>
												</#list>
											</span>
										<#elseif memberAttribute.type == "birth">
											<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" onfocus="WdatePicker();" />
										<#elseif memberAttribute.type == "area">
											<span class="fieldSet">
												<input type="hidden" id="areaId" name="memberAttribute_${memberAttribute.id}" />
											</span>
										<#elseif memberAttribute.type == "address">
											<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" maxlength="200" />
										<#elseif memberAttribute.type == "zipCode">
											<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" maxlength="200" />
										<#elseif memberAttribute.type == "phone">
											<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" maxlength="200" />
										<#elseif memberAttribute.type == "mobile">
											<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" maxlength="200" />
										<#elseif memberAttribute.type == "text">
											<input type="text" name="memberAttribute_${memberAttribute.id}" class="text" maxlength="200" />
										<#elseif memberAttribute.type == "select">
											<select name="memberAttribute_${memberAttribute.id}">
												<option value="">${message("shop.common.choose")}</option>
												<#list memberAttribute.options as option>
													<option value="${option}">
														${option}
													</option>
												</#list>
											</select>
										<#elseif memberAttribute.type == "checkbox">
											<span class="fieldSet">
												<#list memberAttribute.options as option>
													<label>
														<input type="checkbox" name="memberAttribute_${memberAttribute.id}" value="${option}" />${option}
													</label>
												</#list>
											</span>
										</#if>
									</td>
								</tr>
							</#list>
						</@member_attribute_list>
						<#if setting.captchaTypes?? && setting.captchaTypes?seq_contains("memberRegister")>
							<tr>
								<th>
									<span class="requiredField">*</span>${message("shop.captcha.name")}:
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
								<input type="submit" class="submit" value="${message("shop.register.submit")}" />
							</td>
						</tr>
						<tr>
							<th>
								&nbsp;
							</th>
							<td>
								${message("shop.register.agreement")}
							</td>
						</tr>
						<tr>
							<th>
								&nbsp;
							</th>
							<td>
								<div id="agreement" class="agreement">
									${setting.registerAgreement}
								</div>
							</td>
						</tr>
					</table>
					<div class="login">
						<@ad_position id = 8 />
						<dl>
							<dt>${message("shop.register.hasAccount")}</dt>
							<dd>
								${message("shop.register.tips")}
								<a href="${base}/login.action">${message("shop.register.login")}</a>
							</dd>
						</dl>
					</div>
				</form>
			</div>
		</div>
	</div>
</div> -->

<#include "/shop/include/footer.ftl" />
 
<script type="text/javascript" src="<@website.static />/resources/shop/js/model/shop.register.index.js"></script>
</body>
</html>
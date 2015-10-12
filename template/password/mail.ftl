<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>${message("shop.password.mailTitle")}</title>

<link rel="icon" href="<@website.static />/resources/shop/images/favicon.ico" type="image/x-icon" />
</head>
<body>
	<p>${username}:</p>
	<p>${message("shop.password.welcome")}</p>
	<p>${message("shop.password.content", setting.siteName)}<#if safeKey.expire??>(${message("shop.password.expire")}: ${safeKey.expire?string("yyyy-MM-dd HH:mm")})</#if></p>
	<p>
		<a href="${setting.siteUrl}/password/reset.action?username=${username}&key=${safeKey.value}" target="_blank">${setting.siteUrl}/password/reset.action?username=${username}&key=${safeKey.value}</a>
	</p>
	<p>${setting.siteName}</p>
	<p>${.now?string("yyyy-MM-dd")}</p>
</body>
</html>
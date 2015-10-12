<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>${message("shop.resourceNotFound.title")}</title>

<link rel="icon" href="<@website.static />/resources/shop/images/favicon.ico" type="image/x-icon" />
<link href="<@website.static />/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="<@website.static />/resources/shop/css/error.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
</head>
<body>
	<#include "/shop/include/header.ftl" />
	<div class="container error">
		<div class="span24">
			<div class="main">
				<dl>
					${message("shop.resourceNotFound.message")}
					<dd>
						<a href="javascript:;" onclick="window.history.back(); return false;">&gt;&gt; ${message("shop.resourceNotFound.back")}</a>
					</dd>
					<dd>
						<a href="${base}/">&gt;&gt; ${message("shop.resourceNotFound.home")}</a>
					</dd>
				</dl>
			</div>
		</div>
	</div>
	<#include "/shop/include/footer.ftl" />
</body>
</html>
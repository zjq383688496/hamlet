
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>订单支付</title>

<link rel="icon" href="<@website.static />/resources/shop/images/favicon.ico" type="image/x-icon" />
<link href="<@website.static />/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="<@website.static />/resources/shop/css/order.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/common.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.qrcode.min.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $dialogOverlay = $("#dialogOverlay");
	var $dialog = $("#dialog");
	var $other = $("#other");
	var $amountPayable = $("#amountPayable");
	var $fee = $("#fee");
	var $paymentForm = $("#paymentForm");
	var $paymentPluginId = $("#paymentPlugin :radio");
	var $paymentButton = $("#paymentButton");
	
		// 订单锁定
		//setInterval(function() {
		//	$.ajax({
		//		url: "lock.action",
		//		type: "POST",
		//		data: {sn: "${order.sn}"},
		//		dataType: "json",
		//		cache: false,
		//		success: function(data) {
		//			if (!data) {
		//				location.href = "view.action?sn=${order.sn}";
		//			}
		//		}
		//	});
		//}, 10000);

		// 检查支付
		//setInterval(function() {
		//	$.ajax({
		//		url: "check_payment.action",
		//		type: "POST",
		//		data: {sn: "${order.sn}"},
		//		dataType: "json",
		//		cache: false,
		//		success: function(data) {
		//			if (data) {
		//				location.href = "view.action?sn=${order.sn}";
		//			}
		//		}
		//	});
		//}, 10000);
	
	// 选择其它支付方式
	$other.click(function() {
		$dialogOverlay.hide();
		$dialog.hide();
	});
	
	// 支付插件
	//$paymentPluginId.click(function() {
	//	$.ajax({
	//		url: "calculate_amount.action",
	//		type: "POST",
	//		data: {paymentPluginId: $(this).val(), sn: "${order.sn}"},
	//		dataType: "json",
	//		cache: false,
	//		success: function(data) {
	//			if (data.message.type == "success") {
	//				$amountPayable.text(currency(data.amount, true, true));
	//				if (data.fee > 0) {
	//					$fee.text(currency(data.fee, true)).parent().show();
	//				} else {
	//					$fee.parent().hide();
	//				}
	//			} else {
	//				$.message(data.message);
	//				setTimeout(function() {
	//					location.reload(true);
	//				}, 3000);
	//			}
	//		}
	//	});
	//});
	
	$('#qrcode').qrcode({width:200,height:200,correctLevel:0,text:"${codeUrl}"});  
});
</script>
</head>
<body>
<div id="dialogOverlay" class="dialogOverlay"></div>
<script type="text/javascript">
$().ready(function() {

	var $headerLogin = $("#headerLogin");
	var $headerRegister = $("#headerRegister");
	var $headerUsername = $("#headerUsername");
	var $headerLogout = $("#headerLogout");
	var $productSearchForm = $("#productSearchForm");
	var $keyword = $("#productSearchForm input");
	var defaultKeyword = "";
	
	var username = getCookie("username");
	if (username != null) {
		$headerUsername.text("您好, " + username).show();
		$headerLogout.show();
	} else {
		$headerLogin.show();
		$headerRegister.show();
	}
	
	$keyword.focus(function() {
		if ($keyword.val() == defaultKeyword) {
			$keyword.val("");
		}
	});
	
	$keyword.blur(function() {
		if ($keyword.val() == "") {
			$keyword.val(defaultKeyword);
		}
	});
	
	$productSearchForm.submit(function() {
		if ($.trim($keyword.val()) == "" || $keyword.val() == defaultKeyword) {
			return false;
		}
	});

});
</script>

<!-- header -->
<div class="header">

	<!-- top -->
	<div class="head-top">
		<div class="layout">
			<ul class="userinfo">
				<li class="welcome"><span></span> 欢迎!</li>
				<li class="login">
					<a id="headerLogin" style="display:none" href="/login.action">登录</a>
					<a id="headerRegister" style="display:none" href="/register.action">注册</a>
					<a id="headerUsername" style="display:none"></a>
					<a id="headerLogout" style="display:none" href="/logout.action">[退出]</a>
				</li>

					<li class="buy-protect bldr icon-phone">
						<span>
							客服热线:
							<b class="red">400-8888888</b>
						</span>
					</li>

						<li class="buy-protect bldr">
							<a href="/member/index.action">会员中心</a>
						</li>
						<li class="buy-protect bldr">
							<a href="/article/list/3.action">购物指南</a>
						</li>
						<li class="buy-protect bldr">
							<a href="/article/list/7.action">关于我们</a>
						</li>
			</ul>
		</div>
	</div>

	<!-- main -->
	<div class="head-main layout">
		<div class="head-logo">
			<a class="logo-ule" href="/" style="background-image: url(http://static.hamlet365.com/upload/image/logo.gif)"></a>
		</div>

		<div class="head-cart">
			<a class="cw-icon" target="_blank" href="/cart/list.action">
				<i class="ci-left"></i>
				<i class="ci-right">&gt;</i>
				<span>购物车</span>
			</a>
		</div>

		<div class="head-search">
			<div class="head-search-input">
				<form id="productSearchForm" action="/product/search.action" method="get" target="_blank">
					<input class="txt-keyword keyword" type="text" name="keyword" placeholder="商品搜索" value="" autofocus="" autocomplete="off" maxlength="30" >
					<button class="btn-search" type="submit">搜索</button>
				</form>
			</div>
			<ul class="tag" style="display: none;">
						<li class="icon" style="background: url(http://www.bitbug.net/img/temp_background.png) right no-repeat;">
							<a href="/product/list.action?tagIds=1">热销</a>
						</li>
						<li class="icon" style="background: url(http://www.bitbug.net/img/temp_background.png) right no-repeat;">
							<a href="/product/list.action?tagIds=2">最新</a>
						</li>
			</ul>
			<div class="head-search-hot">
					热门搜索:
						<a href="/product/search.action?keyword=%E9%A3%9F%E5%93%81">食品</a>
						<a href="/product/search.action?keyword=%E9%A5%AE%E6%96%99">饮料</a>
			</div>
		</div>
	</div>

	<!-- nav -->
	<div class="head-nav">
		<div class="container">
			<ul class="navlinks">
				<li>
					<a href="/">首页</a>
				</li>
				<li>
					<a href="/product/list/1.action">进口食品</a>
				</li>
				<li>
					<a href="/product/list/2.action">进口饮料</a>
				</li>
				<li>
					<a href="/product/list/3.action">进口生鲜</a>
				</li>
			</ul>
		</div>
	</div>
</div>


<div class="container order">
	<div id="dialog" class="dialog">
		<dl>
			<dt>请在新打开的页面中完成付款</dt><dd>付款完成前请不要关闭此窗口</dd><dd>完成付款后请点击下面按钮</dd>
		</dl>
		<div>
			<a href="view.action?sn=20150905203">完成付款</a>
			<a href="/">遇到问题</a>
		</div>
		<a href="javascript:;" id="other">选择其它支付方式</a>
	</div>

	<div class="order-msg">
		<span class="icon-sus">订单提交成功，请在24小时内完成支付！</span>
	</div>


	<div class="span24">

		<div class="result">

			<div class="result-info">
				<div class="result-total">
					<span class="rt-left">订单号: <i>${order.sn}</i></span>
					<div class="rt-center">
						<span>支付方式</span>
						<i id="selectPay" style="background-image: url(http://static.hamlet365.com/demo-image/3.0/payment_plugin/alipay.gif);">微信支付</i>
						<a id="" href="javascript:;">变更</a>
					</div>
					<span class="rt-right">应付金额: <i>${currency(order.amountPayable, true, true)}</i></span>
				</div>

			</div>
	
			<a id="paymentButton" class="paymentButton" href="javascript:;">立即支付</a>
			<span class="result-msg">使用微信扫一扫支付更便捷</span>
			<div id="qrcode">
			</div>
			
		</div>
	</div>
</div>

<!-- footer -->
<div class="footer">
	<!-- nav -->
	<div class="footer-main">
		<div class="container">
			<ul class="bottomNav">
				<li>
					<a href="#">关于我们</a>
					|
				</li>
				<li>
					<a href="#">联系我们</a>
					|
				</li>
				<li>
					<a href="#">诚聘英才</a>
					|
				</li>
				<li>
					<a href="#">法律声明</a>
					|
				</li>
				<li>
					<a href="/friend_link.action">友情链接</a>
					|
				</li>
				<li>
					<a href="/article/list/4.action" target="_blank">支付方式</a>
					|
				</li>
				<li>
					<a href="/article/list/5.action" target="_blank">配送方式</a>
					
				</li>
			</ul>
		</div>
	</div>

	<!-- Copyright -->
	<div class="container">
		<div class="copyright">Copyright © 2005-2013 哈姆雷特精品会员店 版权所有</div>
	</div>

</div></body>
</html>
<script type="text/javascript">
$().ready(function() {

	var $headerLogin = $("#headerLogin");
	var $headerRegister = $("#headerRegister");
	var $headerUsername = $("#headerUsername");
	var $headerLogout = $("#headerLogout");
	var $productSearchForm = $("#productSearchForm");
	var $keyword = $("#productSearchForm input");
	var defaultKeyword = "${message("shop.header.keyword")}";
	
	var username = getCookie("username");
	if (username != null) {
		$headerUsername.text("${message("shop.header.welcome")}, " + username).show();
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
<div class="header header-simp">
	<!-- ad -->
	<div class="layout">
		<@ad_position id = 1 />
	</div>

	<!-- top -->
	<div class="head-top">
		<div class="layout">
			<ul class="userinfo">
				<li class="welcome"><span></span> 欢迎!</li>
				<li class="login">
					<a id="headerLogin" style="display:none" href="${base}/login.action">${message("shop.header.login")}</a>
					<a id="headerRegister" style="display:none" href="${base}/register.action">${message("shop.header.register")}</a>
					<a id="headerUsername" style="display:none"></a>
					<a id="headerLogout" style="display:none" href="${base}/logout.action">[${message("shop.header.logout")}]</a>
				</li>

				<#if setting.phone??>
					<li class="buy-protect bldr icon-phone">
						<span>
							${message("shop.header.phone")}:
							<b class="red">${setting.phone}</b>
						</span>
					</li>
				</#if>

				<@navigation_list position = "top">
					<#list navigations as navigation>
						<li class="buy-protect bldr">
							<a href="${base}${navigation.url}"<#if navigation.isBlankTarget> target="_blank"</#if>>${navigation.name}</a>
							<#-- <#if navigation_has_next>|</#if> -->
						</li>
					</#list>
				</@navigation_list>
			</ul>
		</div>
	</div>

	<!-- main -->
	<div class="head-main layout">
		<div class="head-logo">
			<a class="logo-ule" href="${base}/" style="background-image: url(${setting.logo})"></a>
		</div>

		<div class="head-cart-nav">
			<div class="step">
				<ul>
					<li><i>1.</i><span>${message("shop.cart.step1")}</span></li>
					<li><i>2.</i><span>${message("shop.cart.step2")}</span></li>
					<li><i>3.</i><span>${message("shop.cart.step3")}</span></li>
				</ul>
			</div>
		</div>

	</div>
</div>

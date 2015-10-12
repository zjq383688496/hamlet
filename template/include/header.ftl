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
<div class="header">
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

		<div class="head-cart">
			<a class="cw-icon" target="_blank" href="${base}/cart/list.action">
				<i class="ci-left"></i>
				<i class="ci-right">&gt;</i>
				<span>${message("shop.header.cart")}</span>
				<em class="hc-number">8</em>
			</a>
		</div>

		<div class="head-search">
			<div class="head-search-input">
				<form id="productSearchForm" action="${base}/product/search.action" method="get" target="_blank">
					<input class="txt-keyword keyword" type="text" name="keyword" placeholder="商品搜索" value="${productKeyword!message("shop.header.keyword")}" autofocus="" autocomplete="off" maxlength="30" >
					<button class="btn-search" type="submit">搜索</button>
				</form>
			</div>
			<ul class="tag" style="display: none;">
				<@tag_list type="product" count = 3>
					<#list tags as tag>
						<li<#if tag.icon??> class="icon" style="background: url(${tag.icon}) right no-repeat;"</#if>>
							<a href="${base}/product/list.action?tagIds=${tag.id}">${tag.name}</a>
						</li>
					</#list>
				</@tag_list>
			</ul>
			<div class="head-search-hot">
				<#if setting.hotSearches?has_content>
					${message("shop.header.hotSearch")}:
					<#list setting.hotSearches as hotSearch>
						<a href="${base}/product/search.action?keyword=${hotSearch?url}">${hotSearch}</a>
					</#list>
				</#if>
			</div>
		</div>
	</div>

	<!-- nav -->
	<div class="head-nav">
		<div class="container">
			<ul class="navlinks">
				<@navigation_list position = "middle">
					<#list navigations as navigation>
						<li<#if base+navigation.url = base+url> class="on"</#if>>
							<a href="${base}${navigation.url}"<#if navigation.isBlankTarget> target="_blank"</#if>>${navigation.name}</a>
							<#-- <#if navigation_has_next>|</#if> -->
						</li>
					</#list>
				</@navigation_list>
			</ul>
		</div>
	</div>
</div>

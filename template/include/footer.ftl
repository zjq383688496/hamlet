<!-- footer -->
<div class="footer">
	<!-- ad -->
	<div class="container">
		<@ad_position id = 2 />
	</div>

	<!-- nav -->
	<div class="footer-main">
		<div class="container">
			<ul class="bottomNav">
				<@navigation_list position = "bottom">
					<#list navigations as navigation>
						<li>
							<a href="${navigation.url}"<#if navigation.isBlankTarget> target="_blank"</#if>>${navigation.name}</a>
							<#if navigation_has_next>|</#if>
						</li>
					</#list>
				</@navigation_list>
			</ul>
		</div>
	</div>

	<!-- Copyright -->
	<div class="container">
		<div class="copyright">${message("shop.footer.copyright", setting.siteName)}</div>
	</div>

	<#include "/shop/include/statistics.ftl" />
</div>
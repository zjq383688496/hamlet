<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<@seo type = "brandList">
	<title><#if seo.title??><@seo.title?interpret /><#else>${message("shop.brand.title")}</#if></title>
	
	
	<#if seo.keywords??>
		<meta name="keywords" content="<@seo.keywords?interpret />" />
	</#if>
	<#if seo.description??>
		<meta name="description" content="<@seo.description?interpret />" />
	</#if>
</@seo>
<link href="<@website.static />/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="<@website.static />/resources/shop/css/product.css" rel="stylesheet" type="text/css" />
<link href="<@website.static />/resources/shop/css/brand.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.lazyload.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $logo = $("#list img");

	$logo.lazyload({
		threshold: 100,
		effect: "fadeIn"
	});
	
});
</script>
</head>
<body class="w1200">
<#include "/shop/include/header.ftl" />

<div class="container productList">
	<div class="productLeft">
		<div class="hotProductCategory">
			<@product_category_root_list>
				<#list productCategories as category>
					<dl>
						<dt>
							<a href="${base}${category.path}">${category.name}</a>
						</dt>
						<@product_category_children_list productCategoryId = category.id count = 4>
							<#list productCategories as productCategory>
								<dd>
									<a href="${base}${productCategory.path}">${productCategory.name}</a>
								</dd>
							</#list>
						</@product_category_children_list>
					</dl>
				</#list>
			</@product_category_root_list>
		</div>
		<!-- <div class="hotProduct">
			<div class="title">${message("shop.product.hotProduct")}</div>
			<ul>
				<#if productCategory??>
					<@product_list productCategoryId = productCategory.id count = 10 orderBy="monthSales desc">
						<#list products as product>
							<li<#if !product_has_next> class="last"</#if>>
								<a href="${base}${product.path}" title="${product.name}">${abbreviate(product.name, 30)}</a>
								<#if product.scoreCount gt 0>
									<div>
										<div>${message("Product.score")}: </div>
										<div class="score${(product.score * 2)?string("0")}"></div>
										<div>${product.score?string("0.0")}</div>
									</div>
								</#if>
								<div>${message("Product.price")}: <strong>${currency(product.price, true, true)}</strong></div>
								<div>${message("Product.monthSales")}: <em>${product.monthSales}</em></div>
							</li>
						</#list>
					</@product_list>
				<#else>
					<@product_list count = 10 orderBy="monthSales desc">
						<#list products as product>
							<li<#if !product_has_next> class="last"</#if>>
								<a href="${base}${product.path}" title="${product.name}">${abbreviate(product.name, 30)}</a>
								<#if product.scoreCount gt 0>
									<div>
										<div>${message("Product.score")}: </div>
										<div class="score${(product.score * 2)?string("0")}"></div>
										<div>${product.score?string("0.0")}</div>
									</div>
								</#if>
								<div>${message("Product.price")}: <strong>${currency(product.price, true, true)}</strong></div>
								<div>${message("Product.monthSales")}: <em>${product.monthSales}</em></div>
							</li>
						</#list>
					</@product_list>
				</#if>
			</ul>
		</div> -->
	</div>
	<div class="productRight">
		<form id="productForm" action="${base}${(productCategory.path)!"/product/list.jhtml"}" method="get">
			<input type="hidden" id="brandId" name="brandId" value="${(brand.id)!}" />
			<input type="hidden" id="promotionId" name="promotionId" value="${(promotion.id)!}" />
			<input type="hidden" id="orderType" name="orderType" value="${orderType}" />
			<input type="hidden" id="pageNumber" name="pageNumber" value="${page.pageNumber}" />
			<input type="hidden" id="pageSize" name="pageSize" value="${page.pageSize}" />
			<#if productCategory?? && (productCategory.children?has_content || productCategory.brands?has_content || productCategory.attributes?has_content)>
				<div id="filter" class="filter">
					<div class="title">${message("shop.product.filter")}</div>
					<div class="content clearfix">
						<#assign rows = 0 />
						<#if productCategory.children?has_content>
							<#assign rows = rows + 1 />
							<dl<#if !productCategory.brands?has_content && !productCategory.attributes?has_content> class="last"</#if>>
								<dt>${message("shop.product.productCategory")}:</dt>
								<#list productCategory.children as category>
									<dd>
										<a href="${base}${category.path}">${category.name}</a>
									</dd>
								</#list>
								<dd class="moreOption" title="${message("shop.product.moreOption")}">&nbsp;</dd>
							</dl>
						</#if>
						<#if productCategory.brands?has_content>
							<#assign rows = rows + 1 />
							<dl<#if !productCategory.attributes?has_content> class="last"</#if>>
								<dt>${message("shop.product.brand")}:</dt>
								<#list productCategory.brands as b>
									<dd>
										<a href="javascript:;"<#if b == brand> class="brand current" title="${message("shop.product.cancel")}"<#else> class="brand"</#if> brandId="${b.id}">${b.name}</a>	
									</dd>
								</#list>
								<dd class="moreOption" title="${message("shop.product.moreOption")}">&nbsp;</dd>
							</dl>
						</#if>
						<#list productCategory.attributes as attribute>
							<#assign rows = rows + 1 />
							<dl<#if rows == 3 || !attribute_has_next> class="last"</#if><#if rows > 3 && !attributeValue?keys?seq_contains(attribute)> style="display: none;"</#if>>
								<dt>
									<input type="hidden" name="attribute_${attribute.id}"<#if attributeValue?keys?seq_contains(attribute)> value="${attributeValue.get(attribute)}"<#else> disabled="disabled"</#if> />
									<span title="${attribute.name}">${abbreviate(attribute.name, 12)}:</span>
								</dt>
								<#list attribute.options as option>
									<dd>
										<a href="javascript:;"<#if attributeValue.get(attribute) == option> class="attribute current" title="${message("shop.product.cancel")}"<#else> class="attribute"</#if>>${option}</a>
									</dd>
								</#list>
								<dd class="moreOption" title="${message("shop.product.moreOption")}">&nbsp;</dd>
							</dl>
						</#list>
					</div>
					<div id="moreFilter" class="moreFilter">
						<#if rows gt 3>
							<a href="javascript:;">${message("shop.product.moreFilter")}</a>
						<#else>
							&nbsp;
						</#if>
					</div>
				</div>
			</#if>
			<div class="bar">
				<!-- <div id="layout" class="layout">
					<label>${message("shop.product.layout")}:</label>
					<a href="javascript:;" id="tableType" class="tableType">
						<span>&nbsp;</span>
					</a>
					<a href="javascript:;" id="listType" class="listType">
						<span>&nbsp;</span>
					</a>
					<label>${message("shop.product.pageSize")}:</label>
					<a href="javascript:;" class="size<#if page.pageSize == 20> current</#if>" pageSize="20">
						<span>20</span>
					</a>
					<a href="javascript:;" class="size<#if page.pageSize == 40> current</#if>" pageSize="40">
						<span>40</span>
					</a>
					<a href="javascript:;" class="size<#if page.pageSize == 80> current</#if>" pageSize="80">
						<span>80</span>
					</a>
					<span class="page">
						<label>${message("shop.product.totalCount", page.total)} ${page.pageNumber}/<#if page.totalPages gt 0>${page.totalPages}<#else>1</#if></label>
						<#if page.totalPages gt 0>
							<#if page.pageNumber != 1>
								<a href="javascript:;" id="previousPage" class="previousPage">
									<span>${message("shop.product.previousPage")}</span>
								</a>
							</#if>
							<#if page.pageNumber != page.totalPages>
								<a href="javascript:;" id="nextPage" class="nextPage">
									<span>${message("shop.product.nextPage")}</span>
								</a>
							</#if>
						</#if>
					</span>
				</div> -->
				<div id="sort" class="sort">
					<!-- <div id="orderSelect" class="orderSelect">
						<#if orderType??>
							<span>${message("Product.OrderType." + orderType)}</span>
						<#else>
							<span>${message("Product.OrderType." + orderTypes[0])}</span>
						</#if>
						<div class="popupMenu">
							<ul>
								<#list orderTypes as ot>
									<li>
										<a href="javascript:;"<#if ot == orderType> class="current" title="${message("shop.product.cancel")}"</#if> orderType="${ot}">${message("Product.OrderType." + ot)}</a>
									</li>
								</#list>
							</ul>
						</div>
					</div> -->
					<a href="javascript:;"<#if orderType == "priceAsc"> class="currentAsc current" title="${message("shop.product.cancel")}"<#else> class="asc"</#if> orderType="priceAsc">${message("shop.product.priceAsc")}</a>
					<a href="javascript:;"<#if orderType == "salesDesc"> class="currentDesc current" title="${message("shop.product.cancel")}"<#else> class="desc"</#if> orderType="salesDesc">${message("shop.product.salesDesc")}</a>
					<a href="javascript:;"<#if orderType == "scoreDesc"> class="currentDesc current" title="${message("shop.product.cancel")}"<#else> class="desc"</#if> orderType="scoreDesc">${message("shop.product.scoreDesc")}</a>
					<input type="text" id="startPrice" name="startPrice" class="startPrice" value="${startPrice}" maxlength="16" title="${message("shop.product.startPrice")}" onpaste="return false" />-<input type="text" id="endPrice" name="endPrice" class="endPrice" value="${endPrice}" maxlength="16" title="${message("shop.product.endPrice")}" onpaste="return false" />
					<button type="submit">${message("shop.product.submit")}</button>
				</div>
				<div class="tag">
					<label>${message("shop.product.tag")}:</label>
					<#assign tagList = tags />
					<@tag_list type = "product">
						<#list tags as tag>
							<label>
								<input type="checkbox" name="tagIds" value="${tag.id}"<#if tagList?seq_contains(tag)> checked="checked"</#if> />${tag.name}
							</label>
						</#list>
					</@tag_list>
				</div>
			</div>
			<div id="result" class="result table clearfix">
				<#if page.content?has_content>
					<ul>
						<#list page.content?chunk(4) as row>
							<#list row as product>
								<li>
									<a href="${base}${product.path}">
										<img src="${base}/upload/image/blank.gif" width="170" height="170" data-original="<#if product.thumbnail??>${product.thumbnail}<#else>${setting.defaultThumbnailProductImage}</#if>" />
										<span class="price">
											${currency(product.price, true)}
											<#if setting.isShowMarketPrice>
												<del>${currency(product.marketPrice, true)}</del>
											</#if>
										</span>
										<span title="${product.name}">${abbreviate(product.name, 60)}</span>
									</a>
								</li>
							</#list>
						</#list>
					</ul>
				<#else>
					${message("shop.product.noListResult")}
				</#if>
			</div>
			<@pagination pageNumber = page.pageNumber totalPages = page.totalPages pattern = "javascript: $.pageSkip({pageNumber});">
				<#include "/shop/include/pagination.ftl">
			</@pagination>
		</form>
	</div>
</div>

<#include "/shop/include/footer.ftl" />
</body>
</html>
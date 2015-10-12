<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>${message("shop.cart.title")}</title>

<link rel="icon" href="<@website.static />/resources/shop/images/favicon.ico" type="image/x-icon" />
<link href="<@website.static />/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="<@website.static />/resources/shop/css/cart.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">
$().ready(function() {

		
	
	var $quantity = $("input[name='quantity']");
	var $increase = $(".increase");
	var $decrease = $(".decrease");
	var $delete = $("a.delete");
	var $giftItems = $("#giftItems");
	var $promotion = $("#promotion");
	var $effectivePoint = $("#effectivePoint");
	var $effectivePrice = $("#effectivePrice");
	var $clear = $("#clear");
	var $submit = $("#submit");
	var timeouts = {};
	
	//修改头部样式
	$('.head-cart-nav .step ul li:first').addClass('current');
	
	// 初始数量
	$quantity.each(function() {
		var $this = $(this);
		$this.data("value", $this.val());
	});
	
	// 数量
	$quantity.keypress(function(event) {
		var key = event.keyCode ? event.keyCode : event.which;
		if ((key >= 48 && key <= 57) || key==8) {
			return true;
		} else {
			return false;
		}
	});
	
	// 减少数量
	$increase.click(function() {
		var $quantity = $(this).parent().find("input");
		var quantity = $quantity.val();
		if (/^\d*[1-9]\d*$/.test(quantity) && parseInt(quantity) > 1) {
			$quantity.val(parseInt(quantity) - 1);
		} else {
			$quantity.val(1);
		}
		edit($quantity);
	});
	
	// 增加数量
	$decrease.click(function() {
		var $quantity = $(this).parent().find("input");
		var quantity = $quantity.val();
		if (/^\d*[1-9]\d*$/.test(quantity)) {
			$quantity.val(parseInt(quantity) + 1);
		} else {
			$quantity.val(1);
		}
		edit($quantity);
	});
	
	// 编辑数量
	$quantity.bind("input propertychange change", function(event) {
		if (event.type != "propertychange" || event.originalEvent.propertyName == "value") {
			edit($(this));
		}
	});
	
	// 编辑数量
	function edit($quantity) {
		var quantity = $quantity.val();
		if (/^\d*[1-9]\d*$/.test(quantity)) {
			var $tr = $quantity.closest("tr");
			var id = $tr.find("input[name='id']").val();
			clearTimeout(timeouts[id]);
			timeouts[id] = setTimeout(function() {
				$.ajax({
					url: "edit.action",
					type: "POST",
					data: {id: id, quantity: quantity},
					dataType: "json",
					cache: false,
					beforeSend: function() {
						$submit.prop("disabled", true);
					},
					success: function(data) {
						if (data.message.type == "success") {
							console.info(data.quantity)
							$('#allQuantity').text(data.quantity);
							$quantity.data("value", quantity);
							$tr.find("span.subtotal").text(currency(data.subtotal, true));
							$tr.find("span.weight").text(data.weight+"kg");
							$('#sacleMoney').html(data.sacleMoney);
							if (data.giftItems != null && data.giftItems.length > 0) {
								$giftItems.html('<dt>${message("shop.cart.gift")}:<\/dt>');
								$.each(data.giftItems, function(i, giftItem) { 
									$giftItems.append('<dd><a href="${base}' + giftItem.gift.path + '" title="' + giftItem.gift.fullName + '" target="_blank">' + giftItem.gift.fullName.substring(0, 50) + ' * ' + giftItem.quantity + '<\/a><\/dd>');
								});
								$giftItems.show();
							} else {
								$giftItems.hide();
							}
							if (data.promotions != null && data.promotions.length > 0) {
								var promotionName = "";
								$.each(data.promotions, function(i, promotion) { 
									promotionName += promotion.name + " ";
								});
								$promotion.text(promotionName);
							} else {
								$promotion.empty();
							}
							if (!data.isLowStock) {
								$tr.find("span.lowStock").remove();
							}
							$effectivePoint.text(data.effectivePoint);
							$effectivePrice.text(currency(data.effectivePrice, true, true));
						} else if (data.message.type == "warn") {
							$.message(data.message);
							$quantity.val($quantity.data("value"));
						} else if (data.message.type == "error") {
							$.message(data.message);
							$quantity.val($quantity.data("value"));
							setTimeout(function() {
								location.reload(true);
							}, 3000);
						}
					},
					complete: function() {
						$submit.prop("disabled", false);
					}
				});
			}, 500);
		} else {
			$quantity.val($quantity.data("value"));
		}
	}


	// 删除所选
	$('#delSelect').click(function(){
		var idlist = new Array();
		var trlist = new Array();
		
		if (confirm("${message("shop.dialog.deleteConfirm")}")) {
			$('input[name="selectNode"]').each(function(){
				if(typeof $(this).attr('checked') !== 'undefined' &&  $(this).attr('checked') !== false){
					idlist.push($('input',$(this).parent().next()).val());
					trlist.push($(this).parent().parent());
				}
			})
			
			$.ajax({
				url:"deleteSelect.action",
				type:"POST",
				data:{"id":idlist.join(',')},
				beforeSend: function() {
					$submit.prop("disabled", true);
				},
				success: function(data) {
					if (data.message.type == "success" && data.cartClear == 'true') {
						$('#hasItems').toggle();
						$('#hasNotItems').toggle();
					}else{
						for(var i=0; i<trlist.length;i++){
							trlist[i].remove();
						}
					}
				}
				,
				complete: function() {
					$submit.prop("disabled", false);
				}
			})
			
		
		}
		
		return false;
	});
	
	// 删除
	$delete.click(function() {
		if (confirm("${message("shop.dialog.deleteConfirm")}")) {
			var $this = $(this);
			var $tr = $this.closest("tr");
			var id = $tr.find("input[name='id']").val();
			clearTimeout(timeouts[id]);
			$.ajax({
				url: "delete.action",
				type: "POST",
				data: {id: id},
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$submit.prop("disabled", true);
				},
				success: function(data) {
					if (data.message.type == "success") {
						if (data.quantity > 0) {
							$tr.remove();
							if (data.giftItems != null && data.giftItems.length > 0) {
								$giftItems.html('<dt>${message("shop.cart.gift")}:<\/dt>');
								$.each(data.giftItems, function(i, giftItem) { 
									$giftItems.append('<dd><a href="${base}' + giftItem.gift.path + '" title="' + giftItem.gift.fullName + '" target="_blank">' + giftItem.gift.fullName.substring(0, 50) + ' * ' + giftItem.quantity + '<\/a><\/dd>');
								});
								$giftItems.show();
							} else {
								$giftItems.hide();
							}
							if (data.promotions != null && data.promotions.length > 0) {
								var promotionName = "";
								$.each(data.promotions, function(i, promotion) { 
									promotionName += promotion.name + " ";
								});
								$promotion.text(promotionName);
							} else {
								$promotion.empty();
							}
							$effectivePoint.text(data.effectivePoint);
							$effectivePrice.text(currency(data.effectivePrice, true, true));
						} else {
							location.reload(true);
						}
					} else {
						$.message(data.message);
						setTimeout(function() {
							location.reload(true);
						}, 3000);
					}
				},
				complete: function() {
					$submit.prop("disabled", false);
				}
			});
		}
		return false;
	});
	
	// 清空
	$clear.click(function() {
		if (confirm("${message("shop.dialog.clearConfirm")}")) {
			$.each(timeouts, function(i, timeout) {
				clearTimeout(timeout);
			});
			$.ajax({
				url: "clear.action",
				type: "POST",
				dataType: "json",
				cache: false,
				success: function(data) {
					location.reload(true);
				}
			});
		}
		return false;
	});
	
	// 提交
	$submit.click(function() {
		var idlist = new Array();
		$('input[name="selectNode"]').each(function(){
				if(typeof $(this).attr('checked') !== 'undefined' &&  $(this).attr('checked') !== false){
					idlist.push($('input',$(this).parent().next()).val());
				}
			})
		$(this).attr("href","${base}/member/order/info.action?idlist="+idlist.join(","));	
		if (!$.checkLogin()) {
			$.redirectLogin("${base}/cart/list.action?idlist="+idlist.join(","), "${message("shop.cart.accessDenied")}");
			return false;
		}
	});
	
	
	$('#selectAll').click(function(){
		if($(this).attr('checked') == null){
			$('input[name="selectNode"]').removeAttr("checked");
			$('#barSelectAll').removeAttr("checked");
		}else{
			$('input[name="selectNode"]').attr("checked",true);
			$('#barSelectAll').attr("checked",true);
		}
	});
	
	
	$('#barSelectAll').click(function(){
		if($(this).attr('checked') == null){
			$('input[name="selectNode"]').removeAttr("checked");
			$('#selectAll').removeAttr("checked");
		}else{
			$('input[name="selectNode"]').attr("checked",true);
			$('#selectAll').attr("checked",true);
		}
	})
	
});
</script>
</head>
<body>
<#include "/shop/include/header_cart.ftl" />
	
<div class="container cart">
	<div class="container">
		<div id="hasItems" <#if cart?if_exists && !(cart.cartItems?has_content)> style="display:none" </#if>>
			<div class="title">
				<b>全部商品</b>
				<div>
					成为会员，最高立减 <span id="sacleMoney" class="red">${sacleMoney}</span>元。
					<a href="" target="_blank">立即开通>></a>
				</div>
			</div>
			<table>
				<tr>
					<th width="40" style="display:none">
						<input type="checkbox" id="selectAll" name="selectAll"  checked="true">
					</th>
					<th width="120">${message("shop.cart.image")}</th>
					<th width="210">${message("shop.cart.product")}</th>
					<th width="100">${message("shop.cart.price")}</th>
					<th width="100">${message("shop.cart.quantity")}</th>
					<th width="100">重量 (kg)</th>
					<th width="100">${message("shop.cart.subtotal")}</th>
					<th>${message("shop.cart.handle")}</th>
				</tr>
				<#list cart.cartItems as cartItem>
					<tr>
						<td  style="display:none">
							<input type="checkbox" name="selectNode" data-id="${cartItem.id}" checked="true">
						</td>
						<td>
							<input type="hidden" name="id" value="${cartItem.id}" />
							<img src="<#if cartItem.product.thumbnail??>${cartItem.product.thumbnail}<#else>${setting.defaultThumbnailProductImage}</#if>" alt="${cartItem.product.name}" />
						</td>
						<td class="td-info">
							<a href="${base}${cartItem.product.path}" title="${cartItem.product.fullName}" target="_blank">${abbreviate(cartItem.product.fullName, 60, "...")}</a>
							<#if cartItem.isLowStock>
								<span class="red lowStock">[${message("shop.cart.lowStock")}]</span>
							</#if>
							
							<#assign specificationValues = cartItem.product.goods.specificationValues />
							
							<#list cartItem.product.goods.specificationValues as specificationValue>
								<#if cartItem.product.specificationValues?seq_contains(specificationValue)>
									 <span>${specificationValue.specification.name} : ${specificationValue.name}
		                             </span><br/>
	                             </#if>
							</#list>
							
						</td>
						<td class="price">
							${currency(cartItem.price, true)}
							<a>
								<i></i>
								<span>
									<s></s>
									<b>会员优惠：<strong>¥30</strong></b>
									<b>商品优惠：金秋特惠 <strong>¥20</strong></b>
								</span>
							</a>
						</td>
						<td class="quantity">
							<span class="increase">-</span>
							<input type="text" name="quantity" value="${cartItem.quantity}" maxlength="4" onpaste="return false;" />
							<span class="decrease">+</span>
						</td>
						<td>
							<span class="weight">${cartItem.weight/1000}kg</span>
						</td>
						<td>
							<span class="subtotal">${currency(cartItem.subtotal, true)}</span>
						</td>
						<td class="td-ctrl">
							<div class="del-model show">
								<a href="javascript:;" class="delete">${message("shop.cart.delete")}</a>
								<div class="float-box">
									<i></i>
									<p>要删除这个商品吗？</p>
									<a href="javascript:;" class="btn-red">删除</a>
									<a href="javascript:;" class="btn-gray">取消</a>
								</div>
							</div>
							<!--<a href="javascript:;" class="add-wait">加入待购清单</a>-->
						</td>
					</tr>
				</#list>
			</table>
			<!-- <dl id="giftItems"<#if !cart.giftItems?has_content> class="hidden"</#if>>
				<#if cart.giftItems?has_content>
					<dt>${message("shop.cart.gift")}:</dt>
					<#list cart.giftItems as giftItem>
						<dd>
							<a href="${base}${giftItem.gift.path}" title="${giftItem.gift.fullName}" target="_blank">${abbreviate(giftItem.gift.fullName, 60, "...")} * ${giftItem.quantity}</a>
						</dd>
					</#list>
				</#if>
			</dl> -->

			<div class="total-box">
				<div class="total">
					<div class="container">
						<div class="total-left">
							<label>
								<input type="checkbox" id="barSelectAll" name="barSelectAll" checked="true">
								全选
							</label>
							<a href="javascript:;" id="delSelect">删除所选</a>
							<a href="javascript:;" id="clear" class="clear">${message("shop.cart.clear")}</a>
						</div>
						<div class="total-right">
							<a href="${base}/member/order/info.action" id="submit" class="submit">${message("shop.cart.submit")}</a>
							<div class="content">
								<!--<em id="promotion">
									<#list cart.promotions as promotion>
										${promotion.name}
									</#list>
								</em>
								<@current_member>
									<#if !currentMember??>
										<em>
											${message("shop.cart.promotionTips")}
										</em>
									</#if>
								</@current_member>-->
								<div class="price">
									共计 <span id="allQuantity" class="red">${cart.quantity}</span> 件商品  ${message("shop.cart.effectivePrice")}: 
									<!--${message("shop.cart.effectivePoint")}: <em id="effectivePoint">${cart.effectivePoint}</em>-->
									<strong id="effectivePrice">${currency(cart.effectivePrice, true, true)}</strong>
								</div>
								<div class="msg">
									成为会员立享 <span class="red">${memberRank.scale}</span> 优惠，总价仅需
			 						<span class="red">¥270.00</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div id="hasNotItems" <#if cart?? && cart.cartItems?has_content> style="display:none" </#if>>
			<p class="cart-error">
				<span>${message("shop.cart.empty")}</span>
				<a href="${base}/">去购物</a>
			</p>
		</div>
	</div>
</div>

<#include "/shop/include/footer.ftl" />
</body>
</html>
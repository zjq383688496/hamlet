<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" >
<title>${message("shop.order.info")}</title>

<link rel="icon" href="<@website.static />/resources/shop/images/favicon.ico" type="image/x-icon" />
<link href="<@website.static />/resources/shop/css/common.css" rel="stylesheet" type="text/css" />
<link href="<@website.static />/resources/shop/css/order.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.lSelect.js"></script>
<script type="text/javascript" src="<@website.static />/resources/shop/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/js/common.js"></script>
<script type="text/javascript">

$().ready(function() {

	var $dialogOverlay = $("#dialogOverlay");
	var $receiverForm = $("#receiverForm");
	var $receiver = $("#receiver ul");
	var $otherReceiverButton = $("#otherReceiverButton");
	var $newReceiverButton = $("#newReceiverButton");
	var $newReceiver = $("#newReceiver");
	var $areaId = $("#areaId");
	var $newReceiverSubmit = $("#newReceiverSubmit");
	var $newReceiverCancelButton = $("#newReceiverCancelButton");
	var $orderForm = $("#orderForm");
	var $receiverId = $("#receiverId");
	var $paymentMethodId = $("#paymentMethod :radio");
	var $shippingMethodId = $("#shippingMethod :radio");
	var $isInvoice = $("#isInvoice");
	var $invoiceTitleTr = $("#invoiceTitleTr");
	var $invoiceTitle = $("#invoiceTitle");
	var $code = $("#code");
	var $couponCode = $("#couponCode");
	var $couponName = $("#couponName");
	var $couponButton = $("#couponButton");
	var $useBalance = $("#useBalance");
	var $freight = $("#freight");
	var $promotionDiscount = $("#promotionDiscount");
	var $couponDiscount = $("#couponDiscount");
	var $tax = $("#tax");
	var $amountPayable = $("#amountPayable");
	var $submit = $("#submit");
	var shippingMethodIds = {};
	
	//修改头部样式
	$('.head-cart-nav .step ul li:first').next().addClass('current');
	
	
	<@compress single_line = true>
		<#list paymentMethods as paymentMethod>
			shippingMethodIds["${paymentMethod.id}"] = [
				<#list paymentMethod.shippingMethods as shippingMethod>
					"${shippingMethod.id}"<#if shippingMethod_has_next>,</#if>
				</#list>
			];
		</#list>
	</@compress>
	
	<#if !member.receivers?has_content>
		$dialogOverlay.show();
	</#if>
	
	// 地区选择
	$areaId.lSelect({
		url: "${base}/common/area.action"
	});
	
	// 收货地址
	$("#receiver li[name=address_li]").live("click", function() {
		var $this = $(this);
		$receiverId.val($this.attr("receiverId"));
		$("#receiver li").removeClass("selected");
		$this.addClass("selected");
		<#if setting.isInvoiceEnabled>
			if ($.trim($invoiceTitle.val()) == "") {
				$invoiceTitle.val($this.find("strong").text());
			}
		</#if>
	});
	
	// 其它收货地址
	$otherReceiverButton.click(function() {
		$otherReceiverButton.hide();
		$newReceiverButton.show();
		$("#receiver li").show();
	});
	
	// 新收货地址
	$newReceiverButton.click(function() {
		$dialogOverlay.show();
		$newReceiver.show();
	});
	
	// 新收货地址取消
	$newReceiverCancelButton.click(function() {
		if ($receiverId.val() == "") {
			$.message("warn", "${message("shop.order.receiverRequired")}");
			return false;
		}
		$dialogOverlay.hide();
		$newReceiver.hide();
	});
	
	// 计算
	function calculate() {
		$.ajax({
			url: "calculate.action",
			type: "POST",
			data: $orderForm.serialize(),
			dataType: "json",
			cache: false,
			success: function(data) {
				if (data.message.type == "success") {
					$freight.text(currency(data.freight, true));
					if (data.promotionDiscount > 0) {
						$promotionDiscount.text(currency(data.promotionDiscount, true));
						$promotionDiscount.parent().show();
					} else {
						$promotionDiscount.parent().hide();
					}
					if (data.couponDiscount > 0) {
						$couponDiscount.text(currency(data.couponDiscount, true));
						$couponDiscount.parent().show();
					} else {
						$couponDiscount.parent().hide();
					}
					if (data.tax > 0) {
						$tax.text(currency(data.tax, true));
						$tax.parent().show();
					} else {
						$tax.parent().hide();
					}
					$amountPayable.text(currency(data.amountPayable, true, true));
				} else {
					$.message(data.message);
					setTimeout(function() {
						location.reload(true);
					}, 3000);
				}
			}
		});
	}
	
	// 支付方式
	$paymentMethodId.click(function() {
		var $this = $(this);
		if ($this.prop("disabled")) {
			return false;
		}
		$this.closest("dd").addClass("selected").siblings().removeClass("selected");
		var paymentMethodId = $this.val();
		$shippingMethodId.each(function() {
			var $this = $(this);
			if ($.inArray($this.val(), shippingMethodIds[paymentMethodId]) >= 0) {
				$this.prop("disabled", false);
			} else {
				$this.prop("disabled", true).prop("checked", false).closest("dd").removeClass("selected");
			}
		});
		calculate();
	});
	
	// 配送方式
	$shippingMethodId.click(function() {
		var $this = $(this);
		if ($this.prop("disabled")) {
			return false;
		}
		$this.closest("dd").addClass("selected").siblings().removeClass("selected");
		calculate();
	});
	
	// 开据发票
	$isInvoice.click(function() {
		$invoiceTitleTr.toggle();
		calculate();
	});
	
	// 优惠券
	$couponButton.click(function() {
		if ($code.val() == "") {
			if ($.trim($couponCode.val()) == "") {
				return false;
			}
			$.ajax({
				url: "coupon_info.action",
				type: "POST",
				data: {code : $couponCode.val()},
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$couponButton.prop("disabled", true);
				},
				success: function(data) {
					if (data.message.type == "success") {
						$code.val($couponCode.val());
						$couponCode.hide();
						$couponName.text(data.couponName).show();
						$couponButton.text("${message("shop.order.codeCancel")}");
						calculate();
					} else {
						$.message(data.message);
					}
				},
				complete: function() {
					$couponButton.prop("disabled", false);
				}
			});
		} else {
			$code.val("");
			$couponCode.show();
			$couponName.hide();
			$couponButton.text("${message("shop.order.codeConfirm")}");
			calculate();
		}
	});
	
	// 使用余额
	$useBalance.click(function() {
		calculate();
	});
	
	// 订单提交
	$submit.click(function() {
		var $checkedPaymentMethodId = $paymentMethodId.filter(":checked");
		var $checkedShippingMethodId = $shippingMethodId.filter(":checked");
		if ($checkedPaymentMethodId.size() == 0) {
			$.message("warn", "${message("shop.order.paymentMethodRequired")}");
			return false;
		}
		//if ($checkedShippingMethodId.size() == 0) {
		//	$.message("warn", "${message("shop.order.shippingMethodRequired")}");
		//	return false;
		//}
		<#if setting.isInvoiceEnabled>
			if ($isInvoice.prop("checked") && $.trim($invoiceTitle.val()) == "") {
				$.message("warn", "${message("shop.order.invoiceTileRequired")}");
				return false;
			}
		</#if>
		$.ajax({
			url: "create.action",
			type: "POST",
			data: $orderForm.serialize(),
			dataType: "json",
			cache: false,
			beforeSend: function() {
				$submit.prop("disabled", true);
			},
			success: function(message) {
				if (message.type == "success") {
					location.href = "payment.action?sn=" + message.content;
				} else {
					$.message(message);
					setTimeout(function() {
						location.reload(true);
					}, 3000);
				}
			},
			complete: function() {
				$submit.prop("disabled", false);
			}
		});
	});
	
	// 表单验证
	$receiverForm.validate({
		rules: {
			consignee: "required",
			areaId: "required",
			address: "required",
			zipCode: "required",
			phone: "required"
		},
		submitHandler: function(form) {
			$.ajax({
				url: "${base}/member/order/save_receiver.action",
				type: "POST",
				data: $receiverForm.serialize(),
				dataType: "json",
				cache: false,
				beforeSend: function() {
					$newReceiverSubmit.prop("disabled", true);
				},
				success: function(data) {
					if (data.message.type == "success") {
						$receiverId.val(data.receiver.id);
						$("#receiver li").removeClass("selected");
						$receiver.append('<li class="selected" receiverId="' + data.receiver.id + '"><div><strong>' + data.receiver.consignee + '<\/strong> ${message("shop.order.receive")}<\/div><div><span>' + data.receiver.areaName + data.receiver.address + '<\/span><\/div><div>' + data.receiver.phone + '<\/div><\/li>');
						$dialogOverlay.hide();
						$newReceiver.hide();
						<#if setting.isInvoiceEnabled>
							if ($.trim($invoiceTitle.val()) == "") {
								$invoiceTitle.val(data.receiver.consignee);
							}
						</#if>
					} else {
						$.message(data.message);
					}
				},
				complete: function() {
					$newReceiverSubmit.prop("disabled", false);
				}
			});
		}
	});
	
});
</script>
</head>
<body>
<div id="dialogOverlay" class="dialogOverlay"></div>

<#include "/shop/include/header_cart.ftl" />

<div class="container order">
	<div class="span24">
		<div class="info">
			<form id="receiverForm" action="save_receiver.action" method="post">
				<div id="receiver" class="receiver clearfix">
					<div class="title">${message("shop.order.receiver")}</div>
					<ul>
						<#list member.receivers as receiver>
							<li<#if receiver_index == 0><#assign defaultReceiver = receiver /> class="selected"<#elseif receiver_index > 3> class="hidden"</#if> receiverId="${receiver.id}">
								<div>
									<strong>${receiver.consignee}</strong> ${message("shop.order.receive")}
								</div>
								<div>
									<span>${receiver.areaName}</span>
								</div>
								<div>
									<span>${receiver.address}</span>
								</div>
								<div>
									${receiver.phone}
								</div>
								<a class="address_edit" href="javascript:;">修改</a>
							</li>
						</#list>
						<li name="address_btn">
							<a href="javascript:;" id="newReceiverButton" class="add_address">增加新地址</a>
						</li>
					</ul>
					<p>
					</p>
				</div>

				<div class="newReceiver<#if member.receivers?has_content> hidden</#if>">
					<div class="title">编辑收货人信息</div>
					<table id="newReceiver">
						<tr>
							<th width="100">
								<span class="requiredField">*</span>${message("shop.order.consignee")}:
							</th>
							<td>
								<input type="text" id="consignee" name="consignee" class="text" maxlength="200" />
							</td>
						</tr>
						<tr>
							<th>
								<span class="requiredField">*</span>${message("shop.order.area")}:
							</th>
							<td>
								<span class="fieldSet">
									<input type="hidden" id="areaId" name="areaId" />
								</span>
							</td>
						</tr>
						<tr>
							<th>
								<span class="requiredField">*</span>${message("shop.order.address")}:
							</th>
							<td>
								<input type="text" id="address" name="address" class="text" maxlength="200" />
							</td>
						</tr>
						<tr>
							<th>
								<span class="requiredField">*</span>${message("shop.order.zipCode")}:
							</th>
							<td>
								<input type="text" id="zipCode" name="zipCode" class="text" maxlength="200" />
							</td>
						</tr>
						<tr>
							<th>
								<span class="requiredField">*</span>${message("shop.order.phone")}:
							</th>
							<td>
								<input type="text" id="phone" name="phone" class="text" maxlength="200" />
							</td>
						</tr>
						<tr>
							<th>
								${message("shop.order.isDefault")}:
							</th>
							<td>
								<input type="checkbox" name="isDefault" value="true" />
								<input type="hidden" name="_isDefault" value="false" />
							</td>
						</tr>
						<tr>
							<th>&nbsp;
								
							</th>
							<td>
								<input type="submit" id="newReceiverSubmit" class="button" value="${message("shop.order.ok")}" />
								<input type="button" id="newReceiverCancelButton" class="button" value="${message("shop.order.cancel")}" />
							</td>
						</tr>
					</table>
				</div>
			</form>
			<form id="orderForm" action="create.action" method="post">
				<input type="hidden" id="receiverId" name="receiverId"<#if defaultReceiver??> value="${defaultReceiver.id}"</#if> />
				<input type="hidden" name="cartToken" value="${cartToken}" />
				<div class="title" style="display:none">支付方式</div>


				<dl class="gold" style="display:none">
					<dt><input type="checkbox" id="userGold" name="usergold"></dt>
					<dd>
						使用金币
						<span>
							<input type="text" name="memo" maxlength="200" />
							(可用200金币)
							<b>-¥ 9.00</b>
						</span>
					</dd>
				</dl>
				<dl class="coupon" style="display:none">
					<dt><input type="checkbox" id="userCoupon" name="usercoupon"></dt>
					<dd>
						使用优惠券
						<span>
							<select>
								<option value="1">满1000元优惠200元</option>
								<option value="2">满100元优惠15元</option>
								<option value="3">满50元优惠5元</option>
							</select>
							<b>-¥ 9.00</b>
						</span>
					</dd>
				</dl>
				<div class="msg">您还需支付 <span id="balance">￥${order.amountPayable}</span> 元，您可选择以下方式继续支付：</div>

				<dl id="paymentMethod" class="select">
					<dt>${message("shop.order.paymentMethod")}</dt>
					<#list paymentMethods as paymentMethod>
						<dd>
							<label for="paymentMethod_${paymentMethod.id}">
								<input type="radio" id="paymentMethod_${paymentMethod.id}" name="paymentMethodId" value="${paymentMethod.id}" />
								<span>
									<#if paymentMethod.icon??>
										<em style="border-right: none; background: url(${paymentMethod.icon}) center no-repeat;">&nbsp;</em>
									</#if>
									<strong>${paymentMethod.name}</strong>
								</span>
								<span>${abbreviate(paymentMethod.description, 80, "...")}</span>
							</label>
						</dd>
					</#list>
				</dl>

				<!--<div class="title">配送方式</div>
				<dl id="shippingMethod" class="select">
					<dt>${message("shop.order.shippingMethod")}</dt>
					<#list shippingMethods as shippingMethod>
						<dd>
							<label for="shippingMethod_${shippingMethod.id}">
								<input type="radio" id="shippingMethod_${shippingMethod.id}" name="shippingMethodId" value="${shippingMethod.id}" />
								<span>
									<#if shippingMethod.icon??>
										<em style="border-right: none; background: url(${shippingMethod.icon}) center no-repeat;">&nbsp;</em>
									</#if>
									<strong>${shippingMethod.name}</strong>
								</span>
								<span>${abbreviate(shippingMethod.description, 80, "...")}</span>
							</label>
						</dd>
					</#list>
				</dl>-->
				<!--<#if setting.isInvoiceEnabled>
					<table>
						<tr>
							<th colspan="2">${message("shop.order.invoiceInfo")}</th>
						</tr>
						<tr>
							<td width="100">
								${message("shop.order.isInvoice")}:
							</td>
							<td>
								<label for="isInvoice">
									<input type="checkbox" id="isInvoice" name="isInvoice" value="true" />
									<#if setting.isTaxPriceEnabled>(${message("shop.order.invoiceTax")}: ${setting.taxRate * 100}%)</#if>
								</label>
							</td>
						</tr>
						<tr id="invoiceTitleTr" class="hidden">
							<td width="100">
								${message("shop.order.invoiceTitle")}:
							</td>
							<td>
								<input type="text" id="invoiceTitle" name="invoiceTitle" class="text"<#if defaultReceiver??> value="${defaultReceiver.consignee}"</#if> maxlength="200" />
							</td>
						</tr>
					</table>
				</#if>-->
				<div class="title">
					商品信息
					<a href="${base}/cart/list.action" class="gocart">返回购物车>></a>
				</div>
				<table class="product">
					<tr>
						<th width="120">${message("shop.order.image")}</th>
						<th width="250">${message("shop.order.product")}</th>
						<th width="110">${message("shop.order.price")}</th>
						<th width="110">${message("shop.order.quantity")}</th>
						<th width="110">重量 (kg)</th>
						<th width="110">${message("shop.order.subTotal")}</th>
					</tr>
					<#list order.orderItems as orderItem>
						<tr>
							<td>
								<img src="<#if orderItem.product.thumbnail??>${orderItem.product.thumbnail}<#else>${setting.defaultThumbnailProductImage}</#if>" alt="${orderItem.product.name}" />
							</td>
							<td>
								<a href="${base}${orderItem.product.path}" title="${orderItem.product.fullName}" target="_blank">${abbreviate(orderItem.product.fullName, 50, "...")}</a>
								<#if orderItem.isGift>
									<span class="red">[${message("shop.order.gift")}]</span>
								</#if>
								
								<#list orderItem.product.goods.specificationValues as specificationValue>
								<#if orderItem.product.specificationValues?seq_contains(specificationValue)>
									 <p>${specificationValue.specification.name} : ${specificationValue.name}</p>
	                             </#if>
							</#list>
							</td>
							<td>
								<#if !orderItem.isGift>
									${currency(orderItem.price, true)}
								<#else>
									-
								</#if>
							</td>
							<td>
								${orderItem.quantity}
							</td>
							<td>
								${orderItem.weight*orderItem.quantity/1000}kg
							</td>
							<td>
								<#if !orderItem.isGift>
									${currency(orderItem.subtotal, true)}
								<#else>
									-
								</#if>
							</td>
						</tr>
					</#list>
				</table>


				<div class="summary">
					<table class="summary-l">
						<tr>
							<td width="100">
								<label>
									<input type="checkbox" id="isInvoice" name="isInvoice" value="true" />
									开据发票:
								</label>
							</td>
							<td id="invoiceTitleTr" class="hidden">
								<input type="text" id="invoiceTitle" name="invoiceTitle" class="text" maxlength="200" placeholder="填写发票抬头">
								<select id="invoiceType" name="invoiceType">
									<option value="1">食品</option>
									<option value="2">酒</option>
									<option value="3">饮料</option>
								</select>
							</td>
						</tr>
					</table>

					<div class="summary-r">
						<ul class="statistic">
							<li>
								<span>商品售价: </span><em id="freight">￥${order.amountPayable}元</em>
							</li>
							<li>
								<span>会员折扣: </span><em id="couponDiscount">￥0.00元</em>
							</li>
							<li>
								<span>商品优惠: </span><em id="amountPayable">￥0.00元</em>
							</li>
							<li>
								<span>支付优惠: </span><em id="amountPayable">￥0.00元</em>
							</li>
						</ul>
					</div>
				</div>
				
				<div class="bottom">
					<div class="price">
						应付金额: <strong id="amountPayable"><i>￥</i>${order.amountPayable}元</strong>
					</div>
					<a href="javascript:;" id="submit" class="submit">${message("shop.order.submit")}</a>
				</div>

			</form>
		</div>
	</div>
</div>

<#include "/shop/include/footer.ftl" />
</body>
</html>
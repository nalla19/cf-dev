$(function() {

	var $btnSelect = $('.btn-select');
	$btnSelect.on('click', function() {
		var $price = $(this).siblings('.price');
		var $upsell = $(this).siblings('.upsell');
		$(this).hide();
		$price.hide();
		$upsell.show();
	})

	var $btnNo = $('.btn-no');
	$btnNo.on('click', function() {
		var $upsell = $(this).parent('.upsell');
		var $price = $upsell.siblings('.price');
		var $btnSelect = $upsell.siblings('.btn-select');
		$btnSelect.show();
		$price.show();
		$upsell.hide();
	});

	var $btnYes = $('.btn-yes');
	$btnYes.on('click', function() {
		$('#modal-setupaccount').modal('show');
	});

});
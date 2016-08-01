$(function() {

	// Popover for subscribe to alerts button
	// todo: automatically close other popovers when clicked
	$('[data-toggle="popover"]').popover({
		html: true,
		placement: 'bottom',
		content: function() {
			return $( $(this).data('content') ).html();
		}
	});

	// Slider for refine by salary option
	var $salarySliderWrap = $('.salary-slider-wrap');
	// var $salarySliderWrap = $('#salary-two');
	$salarySliderWrap.each(function() {
		var $slider = $(this).find('.salary-slider');
		var $min = $slider.siblings('.min');
		var $max = $slider.siblings('.max');
		$slider.slider({
			range: true,
			min: 50000,
			max: 300000,
			step: 1000,
			values: [ $min.val(), $max.val() ],
			slide: function(event,ui) {
				$min.val( dollarize(ui.values[0]) );
				$max.val( dollarize(ui.values[1]) );
				repositionSliderHandleLabels( $slider );
			}
		});
		repositionSliderHandleLabels( $(this).find('.salary-slider') );
	});

	// add dollar sign to initial state of each slider handle label
	$salarySliderWrap.find('.input').each(function() {
		$(this).val( dollarize( $(this).val() ) );
	});
	// update position of slider handle label when window is resized
	$(window).resize(function() {
		$salarySliderWrap.each(function() {
			repositionSliderHandleLabels( $(this).find('.salary-slider') );
		});
	});

	function repositionSliderLabel( handle, label ) {
		label.css({
			'top': handle.height() + 10,
			'left': handle.position().left - 40
		});
	}

	// set position of slider handle labels according their slider handle position
	function repositionSliderHandleLabels( $slider ) {

		var $sliderMinHandle = $slider.find('.ui-slider-handle').eq(0);
		// console.log( $sliderMinHandle );
		var $sliderMaxHandle = $slider.find('.ui-slider-handle').eq(1);
		var $min = $slider.siblings('.min');
		var $max = $slider.siblings('.max');
		$min.css({
			'top': $sliderMinHandle.height() + 10,
			'left': $sliderMinHandle.position().left - 40
		});
		$max.css({
			'top': $sliderMaxHandle.height() + 10,
			'left': $sliderMaxHandle.position().left - 40
		});
	}

	function dollarize( number ) {
		return '$' + number;
	}

	// Finder form 
	var $finderForm = $('.finder-form');
	var $finderInput = $finderForm.find('.input');
	var $finderSearch = $finderForm.find('.btn-search');
	var $finderCancel = $finderForm.find('.btn-cancel');
	var $finderMessage = $finderForm.siblings('.finder-message');
	var $finderChange = $finderMessage.find('.btn-change');
	// show cancel (x) button
	$finderInput.on('focus', function() {
		$finderCancel.css({ visibility: 'visible' });
	}).on('blur', function() {
		if ( $('#job-title').val() == '' && $('#job-location').val() == '' )
			$finderCancel.css({ visibility: 'hidden' });
	});
	// clear input
	$finderCancel.on('click', function() {
		$finderInput.each(function() {
			$(this).val('');
		});
	});
	// show and hide search form & search message boxes
	// some classes added/removed to override the bootstrap !important css
	$finderSearch.on('click', function() {
		$finderForm.hide().addClass('visible-desktop');
		$finderMessage.show().addClass('hidden-desktop');
	});
	$finderChange.on('click', function() {
		$finderMessage.hide().removeClass('hidden-desktop');
		$finderForm.show().removeClass('visible-desktop');
	});

	// Animate refine loading on first load or click
	var $btnRefine = $('.btn-refine');
	var $loading = $btnRefine.find('.loading');
	$btnRefine.on('click', function() {
		$loading.animate({
			'width': '100%'
		}, function() {
			$loading.css({ 'width': 0 });
		});
	});


});
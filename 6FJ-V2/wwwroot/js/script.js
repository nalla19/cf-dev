var epc = [];


//function to check required form fields and return if the form passed
epc.requiredFieldCheck = function(theScope) {
	var formPassed = true;
	
	$(".requiredField:enabled:visible",theScope).each(function() {
		if ( $.trim($(this).val()) == "" ) {
			
			$(this)
				.focus(function() {
					$(this)
						.removeClass('error')
						.off('focus');
				})
				.addClass('error');
				
			
			formPassed = false;
		}
	});
	
	return formPassed;
};



$(document).ready(function() {
	
	// Sign In form
	// add custom class by to background transparent so it's still a clickable area for closing the modal
	$('#signin').on('shown', function() {
		$("html, body").animate({ scrollTop: 0 }, 0);
		$('.modal-backdrop').addClass('signin-modalbackdrop');
	});
	
	
	//captcha logic
	var theCaptchaDiv = $("#captchaDiv");
	if (theCaptchaDiv.length) {
		
		theCaptchaDiv.load("showcaptcha");
		
		$("#reloadCaptchaLnk").click(function(e) {
			e.preventDefault();
			theCaptchaDiv.load("showcaptcha");
		});
		
	}
	
	
	
	//newsletter subscribe form
	$("#newsletterSubscribeFrm").on('submit', function(e) {
		
		if (!$("input[name=newsType]:checked").length) {
			return false;
		}
		
		return epc.requiredFieldCheck($(this));
		
	});
	
	
	$("#bestInClassCarousel").carousel({
		interval: 5000
	});
	
	
	
	//config the finder forms search by dropdown
	$(".searchByLnk").click(function(e) {
		
		e.preventDefault();
		
		var theTxt = $(this).text();
		var theFld = $(this).data('fldname');
		
		//change the display and field accordingly
		$(this)
			.parent()
				.parent()
					.prev()
						.html(theTxt + '<span class="caret"></span>')
						.parent()
							.prev()
								.attr('name', theFld);
		
	});
	

	//config the upper navbar search
	var configSearchNavBar = (function() {

		var navbar = $('#searchnavbar');
		var navsearchLink = navbar.find('.search');
		var navFinderForm = navbar.find('.finder-form');
		var navsearchCancelLink = navFinderForm.find('.cancel');
		
		
		function hideNavFinderForm() {
			navFinderForm.animate({
				'opacity': 0
			}, function() {
				$(this).hide();
			});
		}
		
		
		hideNavFinderForm();

		navsearchLink.on('click', function(e) {
			e.preventDefault(); // since text is inside logo link, disable from going to the homepage link
			navFinderForm.show().animate({
				'opacity': 1
			});
		});
		navsearchCancelLink.on('click', function() {
			hideNavFinderForm();
		});

	})();
	
	
	

//--------------------------------------------advertise start--------------------------------------------

	var advertiseFrm = $("#advertiseFrm");
	if (advertiseFrm.length){
				
		advertiseFrm.on('submit', function(e) {
			
			return epc.requiredFieldCheck(advertiseFrm);
			
		});
		
	}

//--------------------------------------------advertise end--------------------------------------------
	
	
	
	
	



//--------------------------------------------join start--------------------------------------------

	var joinFrm = $("#joinFrm");
	if (joinFrm.length){
				
		joinFrm.on('submit', function(e) {
			/*
			var pwdBox = $("#strPasswd", joinFrm).val();
			pwdBox = $.trim(pwdBox);
			if (pwdBox.length < 5 ){
				alert("not valid");
				addClass('error');
				return false;
			}
			*/
			return epc.requiredFieldCheck(joinFrm);
			
		});
		
	}

//--------------------------------------------join end--------------------------------------------





//--------------------------------------------password retrieval start--------------------------------------------

	var passwordFrm = $("#passwordFrm");
	if (passwordFrm.length){
				
		passwordFrm.on('submit', function(e) {
			
			return epc.requiredFieldCheck(passwordFrm);
			
		});
		
	}

//--------------------------------------------password retrieval end--------------------------------------------





//--------------------------------------------contact start--------------------------------------------

	var contactUsFrm = $("#contactUsFrm");
	if (contactUsFrm.length){
				
		contactUsFrm.on('submit', function(e) {
			
			return epc.requiredFieldCheck(contactUsFrm);
			
		});
		
	}

//--------------------------------------------contact end--------------------------------------------








//--------------------------------------------recruiter package start--------------------------------------------

	var configPackageFrm = (function(theFrm) {
			
		var billingBox = $("#billing-info", theFrm);
		var companyDetails = $("#company-details");
		var paymentDetails = $("#payment-details");
		var termsCheck = $("#terms", theFrm);
		var tprice = $("#tprice");
		var bp = tprice.data('bp');
		var sp = tprice.data('sp');
		
		$("input[name='blnSearch']").change(function() {
			
			if ( $(this).val() == 1 ) {
				tprice.text(bp+sp);
			} else {
				tprice.text(bp);
			}
			
		});
		
		//onload
		$("input[name='blnSearch']:checked").triggerHandler('change');
		
		
		$("#sameAsCheck", theFrm).click(function(e) {
			if ($(this).is(":checked")) {
				billingBox.fadeOut();
			} else {
				billingBox.fadeIn();
			}
		});
		
		
		$("#continueBtn", theFrm).click(function(e) {
			
			var gogo = true;
			
			if (!termsCheck.is(":checked")) {
				gogo = false;
				termsCheck.parent().parent().parent().addClass('error');
			}
			
			if (!epc.requiredFieldCheck(theFrm)) {
				gogo = false;
			}
			
			if (gogo) {
				companyDetails.fadeOut();
				paymentDetails.fadeIn();
			} else {
				e.preventDefault();
			}
			
		});
		
		
		packageFrm.on('submit', function() {
			return epc.requiredFieldCheck(packageFrm);
		});
		
	});

	var packageFrm = $("#packageFrm");
	if (packageFrm.length) {
		
		configPackageFrm(packageFrm);
		
	}
	
	

//--------------------------------------------recruiter package end--------------------------------------------









//--------------------------------------------recruiter pricing start--------------------------------------------

	var recruiterPricing = $("#recruiter-pricing");
	if (recruiterPricing.length) {

		var configRecruiterPricing = (function() {
			var packageBodyContainer = $("#packageBodyContainer");
		
			var $btnSelect = $('.btn-select', recruiterPricing);
			$btnSelect.on('click', function() {
				var $price = $(this).siblings('.price');
				var $upsell = $(this).siblings('.upsell');
				$(this).hide();
				$price.hide();
				$upsell.show();
			});

			
		})();

	}

//--------------------------------------------recruiter pricing end--------------------------------------------





//--------------------------------------------job listing start-----------------------------------------------
	var pageListing = $("#page-listing");
	if (pageListing.length) {

		// Popover for subscribe to alerts button
		// todo: automatically close other popovers when clicked
		$('[data-toggle="popover"]', pageListing).popover({
			html: true,
			placement: 'bottom',
			content: function() {
				return $( $(this).data('content') ).html();
			}
		});
	}
//--------------------------------------------job listing end-------------------------------------------------




//--------------------------------------------search results start--------------------------------------------

	var pageSearch = $("#page-search");
	if (pageSearch.length) {


		// Popover for subscribe to alerts button
		// todo: automatically close other popovers when clicked
		$('[data-toggle="popover"]', pageSearch).popover({
			html: true,
			placement: 'bottom',
			content: function() {
				return $( $(this).data('content') ).html();
			}
		});



		$(".searchFilterBtn", pageSearch).click(function(e) {

			if ($(this).text() == "Show more") {
				$(this).button('collapse');
			} else {
				$(this).button('reset');
			}
			
		});
		
		
		//there are two forms, one in the side menu and one in the top menu for mobile
		var navSearchFilterForm = $("form.navSearchFilterForm");
		navSearchFilterForm.each(function() {
			var theFrm = $(this);
			$("input[type='checkbox']", theFrm).change(function(e) {
				theFrm.submit();
			});
		});
		
		
		
		
		/*
		// Slider for refine by salary option
		var salarySliderWrap = $('#salary-one');
		
		if (salarySliderWrap.length) {
			
			
			function dollarize( number ) {
				return '$' + number;
			}
			
			
			// set position of slider handle labels according their slider handle position
			function repositionSliderHandleLabels( slider, min, max ) {
				var sliderMinHandle = slider.find('.ui-slider-handle').eq(0);
				var sliderMaxHandle = slider.find('.ui-slider-handle').eq(1);
				min.css({
					'top': sliderMinHandle.height() + 10,
					'left': sliderMinHandle.position().left - 40
				});
				max.css({
					'top': sliderMaxHandle.height() + 10,
					'left': sliderMaxHandle.position().left - 40
				});
			}
			
			
			var configSalarySlider = (function() {
				
				var theSlider = $('.salary-slider', salarySliderWrap);
				var min = theSlider.siblings('.min');
				var max = theSlider.siblings('.max');
				
				// update position of slider handle label when window is resized
				$(window).resize(function() {
					repositionSliderHandleLabels( theSlider, min, max);
				});
				
				theSlider.slider({
					theSlider: true,
					min: parseInt(min.val()),
					max: parseInt(max.val()),
					step: 1000,
					values: [ min.val(), max.val() ],
					slide: function(event,ui) {
						min.val( dollarize(ui.values[0]) );
						max.val( dollarize(ui.values[1]) );
						repositionSliderHandleLabels( theSlider, min, max );
					}
				});
				
				repositionSliderHandleLabels( theSlider, min, max );
				
				// add dollar sign to initial state of each slider handle label
				$('.input', salarySliderWrap).each(function() {
					$(this).val( dollarize( $(this).val() ) );
				});
				
			})()
			
		}
		*/
	


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
		
		

	}
	

//--------------------------------------------search results end--------------------------------------------

//-------------------------------------------member relocation-----------------------------------------
	$("#blnrelocateYes").click(function() {
		$("#relocateprefs").slideDown(500);
	});

	$("#blnrelocateNo").click(function() {
		$("#relocateprefs").slideUp(500);
	});
//-------------------------------------------member relocation end-----------------------------------------	

 $("#save_changes_confirm").fadeOut(3000);
 
 //---------------------------------------- auto suggest ---------------------------------------------------
 });

 
 

/* ---------------------------- */
/* XMLHTTPRequest Enable 		*/
/* ---------------------------- */
function createObject() {
	var request_type;
	var browser = navigator.appName;
	if(browser == "Microsoft Internet Explorer"){
		request_type = new ActiveXObject("Microsoft.XMLHTTP");
	}else{
		request_type = new XMLHttpRequest();
	}
		return request_type;
}


var http = createObject();
var execLocresults;
var execSchoolresults;
var strSchool;
var rowID;

/* -------------------------- */
/* SEARCH					 */
/* -------------------------- */
function execLocAutoSuggest(e, searchq) {	
	/*
	q = document.getElementById(searchq).value;	
	if (q.length >= 3){
		//document.getElementById('execLocresults').innerHTML="<img src='/images/loading.gif' border='0'>";
		document.getElementById('execLocresults').style.display="block";
		// Set te random number to add to URL request
		nocache = Math.random();
		http.open('get', 'utilities/execCityStateSearch.cfm?q='+q+'&nocache = '+nocache); 
		http.onreadystatechange = autosuggestReply;
		http.send(null);
	}else{
		document.getElementById('execLocresults').style.display="none";	
	}
	*/
	
	var e = (!e) ? window.event : e; 
	var target = (!e.target) ? e.srcElement : e.target; 
 	if (target.nodeType == 3) target = target.parentNode; 
	code = (e.charCode) ? e.charCode : ((e.keyCode) ? e.keyCode : ((e.which) ? e.which : 0)); 

	q = document.getElementById(searchq).value;	
	if (q.length >= 3){
		if (e.type == "keyup") { 
			isKeyUpDownPressed = false; 
			if ((code < 13 && code != 8) || (code >= 14 && code < 32) || (code >= 33 && code <= 46 && code != 38 && code != 40) || (code >= 112 && code <= 123)) { 
				document.getElementById('execLocresults').style.display="block";
				// Set te random number to add to URL request
				nocache = Math.random();
				http.open('get', '/autosuggest-city?q='+q+'&nocache = '+nocache); 
				http.onreadystatechange = autosuggestReply;
				http.send(null);
				return true;
			} else if (code == 13) {
				var cart = document.getElementById('execLocresults');
				var selectedIndex = cart.options.selectedIndex;
				var selectedValue = cart.options[selectedIndex].value;
				document.getElementById('execLocation').value = selectedValue;
				document.getElementById('execLocresults').style.display="none";			
				return false; 
			} else { 
				if (code == 40) { 
					var cart = document.getElementById('execLocresults'); 
					var selectedIndex = cart.options.selectedIndex; 
					if (selectedIndex != -1) { 
						if ((selectedIndex + 1) <= cart.options.length) { 
							cart.options.selectedIndex = selectedIndex + 1; 
						} 
					} else { 
						cart.options.selectedIndex = 0; 
					} 
					return true; 
				} else if (code == 38) { 
					var cart = document.getElementById('execLocresults'); 
					var selectedIndex = cart.options.selectedIndex; 
					if (cart.options.length > 0) { 
						cart.options.selectedIndex = selectedIndex - 1; 
					} 
					return true; 
				} 
				document.getElementById('execLocresults').style.display="block";
				// Set te random number to add to URL request
				nocache = Math.random();
				http.open('get', '/autosuggest-city?q='+q+'&nocache = '+nocache); 
				http.onreadystatechange = autosuggestReply;
				http.send(null);
				return true;  
			} 
		} else { 
			document.getElementById('execLocresults').style.display="block";
			// Set te random number to add to URL request
			nocache = Math.random();
			http.open('get', '/autosuggest-city?q='+q+'&nocache = '+nocache); 
			http.onreadystatechange = autosuggestReply;
			http.send(null);
			return true;   
		}
	}else{
		document.getElementById('execLocresults').style.display="none";	
	}
}

function autosuggestReply(){
	if(http.readyState == 4){
		var response = http.responseText;
		if(response!=""){
			//document.getElementById('execLocresults').innerHTML="<img src='/images/loading.gif' border='0'>";
			$('#execLocresults').empty();
			var autoSuggestCombo = document.getElementById('execLocresults'); 
			var option = document.createElement('option');
			
			var optionValue;
			var arry = response.split(';');
			for(var i=0; i<arry.length; i++){
				optionValue = arry[i].replace(/^\s+|\s+$/g,"");
				if (document.getElementById('execLocresults') != null && document.getElementById('execLocresults').options != null && optionValue != ''){
					document.getElementById('execLocresults').options[i] = new Option(optionValue, optionValue, false, false);
				}
			} 			
			document.getElementById('execLocresults').style.display="block";
		} else {
			document.getElementById('execLocresults').style.display="none";
		}
	}
}

function fillvalue(cityState){
	document.getElementById('execLocation').value = cityState;
	document.getElementById('execLocresults').style.display="none";
	return false;
}

function fillCityState(field){
	var cart = document.getElementById('execLocresults');
	var selectedIndex = cart.options.selectedIndex;
	var selectedValue = cart.options[selectedIndex].value;
		
	//10/02/2012
	var temp = new Array();
	// this will return an array with strings "1", "2", etc.
	temp = selectedValue.split(",");
	
	if (temp.length == 4){
		var zip = temp[0];
		var city = temp[1];
		var state = temp[2];
		var country = temp[3];
		
		
		//Set the Zip Code
		document.getElementById('execLocation').value = zip;
		//Set the City
		document.getElementById('strCity').value = city;
		
		//Set the State
		var s=document.getElementById('strState');	
		for ( var i = 0; i < s.options.length; i++ ) {
			if ( s.options[i].value == state ) {
				s.options[i].selected = true;
			}
	    }
	}else if (temp.length){
		var city = temp[0];
		var state = temp[1];
		var country = temp[2];
		
		//Set the Zip Code
		document.getElementById('execLocation').value = '';
		//Set the City
		document.getElementById('strCity').value = city;
		
		//Set the State
		var s=document.getElementById('strState');	
		for ( var i = 0; i < s.options.length; i++ ) {
			if ( s.options[i].value == state ) {
				s.options[i].selected = true;
			}
	    }
	}
	
	//document.getElementById('execLocation').value = field.value;

	//10/02/2012
	//document.getElementById('execLocation').value = selectedValue;
	$('#execLocresults').empty();
	document.getElementById('execLocresults').style.display="none";
	/**********Reset the border colors**********/
	//Zip Code
	document.getElementById('execLocation').style.borderColor = '';
	//City
	document.getElementById('strCity').style.borderColor = '';
	//State
	document.getElementById('strState').style.borderColor = '';
	//return false;
}

function parseCityState(){
	
	var zipCityState = document.getElementById('execLocation').value;
	
	//10/02/2012
	var temp = new Array();
	// this will return an array with strings "1", "2", etc.
	temp = zipCityState.split(",");
	
	if (temp.length == 4){
		var zip = temp[0];
		var city = temp[1];
		var state = temp[2];
		var country = temp[3];
		
		
		//Set the Zip Code
		document.getElementById('execLocation').value = zip;
		//Set the City
		document.getElementById('strCity').value = city;
		
		//Set the State
		var s=document.getElementById('strState');	
		for ( var i = 0; i < s.options.length; i++ ) {
			if ( s.options[i].value == state ) {
				s.options[i].selected = true;
			}
	    }
		//10/02/2012
		//document.getElementById('execLocation').value = selectedValue;
		$('#execLocresults').empty();
		document.getElementById('execLocresults').style.display="none";
		/**********Reset the border colors**********/
		//Zip Code
		document.getElementById('execLocation').style.borderColor = '';
		//City
		document.getElementById('strCity').style.borderColor = '';
		//State
		document.getElementById('strState').style.borderColor = '';	
	}else if (temp.length == 3){
		var city = temp[0];
		var state = temp[1];
		var country = temp[2];
		
		//Set the Zip Code
		document.getElementById('execLocation').value = '';
		//Set the City
		document.getElementById('strCity').value = city;
		
		//Set the State
		var s=document.getElementById('strState');	
		for ( var i = 0; i < s.options.length; i++ ) {
			if ( s.options[i].value == state ) {
				s.options[i].selected = true;
			}
	    }

		//10/02/2012
		//document.getElementById('execLocation').value = selectedValue;
		$('#execLocresults').empty();
		document.getElementById('execLocresults').style.display="none";
		/**********Reset the border colors**********/
		//Zip Code
		document.getElementById('execLocation').style.borderColor = '';
		//City
		document.getElementById('strCity').style.borderColor = '';
		//State
		document.getElementById('strState').style.borderColor = '';		
	}	
}

function execSchoolAutoSuggest(e, searchq, id) {	
	/*
	q = document.getElementById(searchq).value;	
	if (q.length >= 3){
		//document.getElementById('execLocresults').innerHTML="<img src='/images/loading.gif' border='0'>";
		document.getElementById('execLocresults').style.display="block";
		// Set te random number to add to URL request
		nocache = Math.random();
		http.open('get', 'utilities/execCityStateSearch.cfm?q='+q+'&nocache = '+nocache); 
		http.onreadystatechange = autosuggestReplySchool;
		http.send(null);
	}else{
		document.getElementById('execLocresults').style.display="none";	
	}
	*/
	
	var e = (!e) ? window.event : e; 
	var target = (!e.target) ? e.srcElement : e.target; 
 	if (target.nodeType == 3) target = target.parentNode; 
	code = (e.charCode) ? e.charCode : ((e.keyCode) ? e.keyCode : ((e.which) ? e.which : 0)); 
	
	execSchoolresults = 'execSchoolresults' + id;
	strSchool = 'strSchool' + id;
	rowID = id;
	
	q = document.getElementById(searchq).value;	
	
	if (q.length >= 0){
		if (e.type == "keyup") { 
			isKeyUpDownPressed = false; 
			if ((code < 13 && code != 8) || (code >= 14 && code < 32) || (code >= 33 && code <= 46 && code != 38 && code != 40) || (code >= 112 && code <= 123)) { 
				document.getElementById(execSchoolresults).style.display="block";
				// Set te random number to add to URL request
				nocache = Math.random();
				http.open('get', '/autosuggest-school?q='+q+'&nocache = '+nocache); 
				http.onreadystatechange = autosuggestReplySchool;
				http.send(null);
				return true;
			} else if (code == 13) {		
				var cart = document.getElementById(execSchoolresults);
				var selectedIndex = cart.options.selectedIndex;
				var selectedValue = cart.options[selectedIndex].value;
				document.getElementById(strSchool).value = selectedValue;
				document.getElementById(execSchoolresults).style.display="none";			
				return false; 
			} else { 
				if (code == 40) { 
					var cart = document.getElementById(execSchoolresults); 
					var selectedIndex = cart.options.selectedIndex; 
					if (selectedIndex != -1) { 
						if ((selectedIndex + 1) <= cart.options.length) { 
							cart.options.selectedIndex = selectedIndex + 1; 
						} 
					} else { 
						cart.options.selectedIndex = 0; 
					} 
					return true; 
				} else if (code == 38) { 
					var cart = document.getElementById(execSchoolresults); 
					var selectedIndex = cart.options.selectedIndex; 
					if (cart.options.length > 0) { 
						cart.options.selectedIndex = selectedIndex - 1; 
					} 
					return true; 
				} 
				document.getElementById(execSchoolresults).style.display="block";
				// Set te random number to add to URL request
				nocache = Math.random();
				http.open('get', '/autosuggest-school?q='+q+'&nocache = '+nocache); 
				http.onreadystatechange = autosuggestReplySchool;
				http.send(null);
				return true;  
			} 
		} else { 
			document.getElementById(execSchoolresults).style.display="block";
			// Set te random number to add to URL request
			nocache = Math.random();
			http.open('get', '/autosuggest-school?q='+q+'&nocache = '+nocache); 
			http.onreadystatechange = autosuggestReplySchool;
			http.send(null);
			return true;   
		}
	}else{
		document.getElementById(execSchoolresults).style.display="none";	
	}
}

function autosuggestReplySchool(){
	if(http.readyState == 4){
		var response = http.responseText;
		if(response!=""){
			//document.getElementById('execLocresults').innerHTML="<img src='/images/loading.gif' border='0'>";
			if (rowID == 1)
				$('#execSchoolresults1').empty();
			else if (rowID == 2)
				$('#execSchoolresults2').empty();
			else if (rowID == 3)
				$('#execSchoolresults3').empty();
			else if (rowID == 4)
				$('#execSchoolresults4').empty();
			else if (rowID == 5)
				$('#execSchoolresults5').empty();
						
			var autoSuggestCombo = document.getElementById(execSchoolresults); 
			var option = document.createElement('option');
			
			var optionValue;
			var arry = response.split(';');
			for(var i=0; i<arry.length; i++){
				optionValue = arry[i].replace(/^\s+|\s+$/g,"");
				if (document.getElementById(execSchoolresults) != null && document.getElementById(execSchoolresults).options != null && optionValue != ''){
					document.getElementById(execSchoolresults).options[i] = new Option(optionValue, optionValue, false, false);
				}
			} 			
			document.getElementById(execSchoolresults).style.display="block";
		} else {
			document.getElementById(execSchoolresults).style.display="none";
		}
	}
}

function fillvalue(cityState){
	document.getElementById(strSchool).value = cityState;
	document.getElementById(execSchoolresults).style.display="none";
	return false;
}

function fillSchool(field){
	var cart = document.getElementById(execSchoolresults);
	var selectedIndex = cart.options.selectedIndex;
	var selectedValue = cart.options[selectedIndex].value;
	document.getElementById(strSchool).value = selectedValue;
	
	//Empty all the School Results
	$('#execSchoolresults1').empty();
	$('#execSchoolresults2').empty();
	$('#execSchoolresults3').empty();
	$('#execSchoolresults4').empty();
	$('#execSchoolresults5').empty();
	
	document.getElementById(execSchoolresults).style.display="none";
}// JavaScript Document
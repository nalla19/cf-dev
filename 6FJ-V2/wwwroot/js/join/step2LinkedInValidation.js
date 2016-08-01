<!--
function checkform2(){
	var errormsg = '';
 	var errNum=0;
	
	
	var toggleValue = document.getElementById('USCAIntToggle').value;
	
	//US or Canda
	if (toggleValue == 1){
		//ZipCode
		if (document.ExecProfile.strUSCAZipCode.value == '' || document.ExecProfile.strUSCAZipCode.value == 'U.S or Canadian Zip/Postal Code'){
			document.getElementById('strUSCAZipCode').style.borderColor = '#F00';
			errNum+=1;
		}
		
		//Phone Number
		if (document.ExecProfile.strPhoneNumber.value == '' || document.ExecProfile.strPhoneNumber.value == 'Phone Number'){
			document.getElementById('strPhoneNumber').style.borderColor = '#F00';
			errNum+=1;
		}

	//International
	}else if (toggleValue == 2){
		//City
		if (document.ExecProfile.strIntntlCity.value == '' || document.ExecProfile.strIntntlCity.value == 'City'){
			document.getElementById('strIntntlCity').style.borderColor = '#F00';
			errNum+=1;
		}
		
		//Country		
		if (document.ExecProfile.strCountry.value == ''){
			document.getElementById('strCountry').style.borderColor = '#F00';
			errNum+=1;
		}	
	}
	
	//Privacy Setting
	if (document.ExecProfile.intPrivacySetting.value == ''){
		//document.getElementById('intPrivacySettingErrTxt').style.color = '#F00';
		document.getElementById('intPrivacySetting').style.borderColor = '#F00';
		errNum+=1;
	}
	
	
	//Current or most recent compensation package
	if ( document.getElementById('fltCompensation_package').selectedIndex == 0){
		document.getElementById('fltCompensation_package').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Desired Job Title
	if (document.ExecProfile.strDesiredJobTitle.value == '' || document.ExecProfile.strDesiredJobTitle.value == 'Desired Job Title'){
		document.getElementById('strDesiredJobTitle').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Year of Experience 
	if ( document.getElementById('intYrsExp').selectedIndex == 0){
		document.getElementById('intYrsExp').style.borderColor = '#F00';
		errNum+=1;
	}
	
	
	//Signup for InHouseEmail
	var blnInHouseEmail = document.getElementsByName('blnInHouseEmail');
	var isInHouseEmailchecked = false;
	for ( var i = 0; i < blnInHouseEmail.length; i++) {
		if(blnInHouseEmail[i].checked) {
			isInHouseEmailchecked = true;
		}
	}
	if(!isInHouseEmailchecked){ 
		document.getElementById('blnInHouseEmailErrTxt').style.color = '#F00';
		errNum+=1;
	}else{
		document.getElementById('blnInHouseEmailErrTxt').style.color = '';
	}
	
	
	//Signup for Newsletter
	var blnNewsLetter = document.getElementsByName('blnNewsLetter');
	var isNewsLetterchecked = false;
	for ( var i = 0; i < blnNewsLetter.length; i++) {
		if(blnNewsLetter[i].checked) {
			isNewsLetterchecked = true;
		}
	}
	if(!isNewsLetterchecked){
		document.getElementById('blnNewsLetterErrTxt').style.color = '#F00';
		errNum+=1;
	}else{
		document.getElementById('blnNewsLetterErrTxt').style.color = '';
	}
	
	
	//Signup for Job Alerts
	var blnEmail = document.getElementsByName('blnEmail');
	var isJobAlertchecked = false;
	for ( var i = 0; i < blnEmail.length; i++) {
		if(blnEmail[i].checked) {
			isJobAlertchecked = true;
		}
	}
	if(!isJobAlertchecked){
		document.getElementById('blnEmailErrTxt').style.color = '#F00';
		errNum+=1;
	}else{
		document.getElementById('blnEmailErrTxt').style.color = '';
	}
		
	//Signup for SpecialOffer
	var blnSpecialOffer = document.getElementsByName('blnSpecialOffer');
	var isblnSpecialOfferchecked = false;
	for ( var i = 0; i < blnSpecialOffer.length; i++) {
		if(blnSpecialOffer[i].checked) {
			isblnSpecialOfferchecked = true;
		}
	}
	if(!isblnSpecialOfferchecked){ //payment method button is not checked
		document.getElementById('blnSpecialOfferErrTxt').style.color = '#F00';
		errNum+=1;
	}else{
		document.getElementById('blnSpecialOfferErrTxt').style.color = '';
	}
	
	
	//Job Title 1
	if (document.ExecProfile.strExecJobTitle_1.value == '' || document.ExecProfile.strExecJobTitle_1.value == 'Most Recent Job Title'){
		document.getElementById('strExecJobTitle_1').style.borderColor = '#F00';
		errNum+=1;
	}

	//Job Company 1
	if (document.ExecProfile.strExecJOBCompany_1.value == '' || document.ExecProfile.strExecJOBCompany_1.value == 'Most Recent Company'){
		document.getElementById('strExecJOBCompany_1').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Job Title 2
	if (document.ExecProfile.strExecJobTitle_2.value == '' || document.ExecProfile.strExecJobTitle_2.value == 'Second Most Recent Job Title'){
		document.getElementById('strExecJobTitle_2').style.borderColor = '#F00';
		errNum+=1;
	}

	//Job Company 2
	if (document.ExecProfile.strExecJOBCompany_2.value == '' || document.ExecProfile.strExecJOBCompany_2.value == 'Second Most Recent Company'){
		document.getElementById('strExecJOBCompany_2').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Credit Card
	var blnLearn365 = document.getElementsByName('blnLearn365');
	var isLearn365checked = false;
	var isLearn365Value = 0;
	for ( var i = 0; i < blnLearn365.length; i++) {
		if(blnLearn365[i].checked) {
			isLearn365checked = true;
			isLearn365Value = blnLearn365[i].value;
		}
	}
	
	if(!isLearn365checked){
		document.getElementById('blnLearn365ErrTxt').style.color = '#F00';
		errNum+=1;
	}
	
	/*if(!isLearn365checked){
		document.getElementById('blnLearn365ErrTxt').style.color = '#F00';
		errNum+=1;
	}else{
		
		//alert(isLearn365Value);
		//return false;
		if (isLearn365Value == "1"){
			//Address 1
			if (document.ExecProfile.strAddress1.value == '' || document.ExecProfile.strAddress1.value == 'Address 1'){
				document.getElementById('strAddress1').style.borderColor = '#F00';
				errNum+=1;
			}
			
			//City
			if (document.ExecProfile.strCity.value == '' || document.ExecProfile.strCity.value == 'City'){
				document.getElementById('strCity').style.borderColor = '#F00';
				errNum+=1;
			}
			
			//State 
			if (document.ExecProfile.strState.value == ''){
				document.getElementById('strState').style.borderColor = '#F00';
				errNum+=1;
			}
			
			//Card Name
			if (document.ExecProfile.cardName.value == '' || document.ExecProfile.cardName.value == 'Name on Card'){
				document.getElementById('cardName').style.borderColor = '#F00';
				errNum+=1;
			}
			
			//Card Type
			if (document.ExecProfile.strCardType.value == ''){
				document.getElementById('strCardType').style.borderColor = '#F00';
				errNum+=1;
			}
			
			//Card Number
			if (document.ExecProfile.cardNumber.value == '' || document.ExecProfile.cardNumber.value == 'Credit Card Number'){
				document.getElementById('cardNumber').style.borderColor = '#F00';
				errNum+=1;
			}
			
			//Card Month
			if (document.ExecProfile.cardMonth.value == ''){
				document.getElementById('cardMonth').style.borderColor = '#F00';
				errNum+=1;
			}
			
			//Card Year
			if (document.ExecProfile.cardYear.value == ''){
				document.getElementById('cardYear').style.borderColor = '#F00';
				errNum+=1;
			}
			
			//Security Code 
			if (document.ExecProfile.securityCode.value == '' || document.ExecProfile.securityCode.value == 'Security Code'){
				document.getElementById('securityCode').style.borderColor = '#F00';
				errNum+=1;
			}
		}else{
			document.getElementById('blnLearn365ErrTxt').style.color = '';
		}
	}
*/
	
	/*
	
	//Industry Experience
	var indChkCnt = $("input[name='intsIndIDs']:checked").length;
	if (indChkCnt == 0 || indChkCnt> 5){
		document.getElementById('intsIndIDsErrTxt').style.color = '#F00';
		errNum+=1;
	}
	
	//Function Experience
	var funcChkCnt = $("input[name='intsFuncIDs']:checked").length;
	if (funcChkCnt == 0 || funcChkCnt > 5){
		document.getElementById('intsFuncIDsErrTxt').style.color = '#F00';
		errNum+=1;
	}
	
	
	
	//Zip Code
	if (document.ExecProfile.execLocation.value == '' || document.ExecProfile.execLocation.value == 'Zip/Postal Code'){
		document.getElementById('execLocation').style.borderColor = '#F00';
		errNum+=1;
	}


	//City
	if (document.ExecProfile.strCity.value == '' || document.ExecProfile.strCity.value == 'City'){
		document.getElementById('strCity').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//State/Country
	if ( document.getElementById('strState').selectedIndex == 0){
		document.getElementById('strState').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Home Phone
	if (document.ExecProfile.strHomePhone.value == '' || document.ExecProfile.strHomePhone.value == 'Home Phone'){
		document.getElementById('strHomePhone').style.borderColor = '#F00';
		errNum+=1;
	}else if (document.ExecProfile.strHomePhone.value != '' && document.ExecProfile.strHomePhone.value != 'Home Phone'){
		var re=/^\d+(.\d+)*$/;
		var val = re.test(document.ExecProfile.strHomePhone.value); 
		if (val==false){
			document.getElementById('strHomePhone').style.borderColor = '#F00';
			errNum+=1;
		}
	}
		
	//Mobile Phone
	if (document.ExecProfile.strMobilePhone.value == '' || document.ExecProfile.strMobilePhone.value == 'Mobile Phone'){
		document.getElementById('strMobilePhone').style.borderColor = '#F00';
		errNum+=1;
	}else if (document.ExecProfile.strMobilePhone.value != ''  && document.ExecProfile.strMobilePhone.value != 'Mobile Phone'){
		var re=/^\d+(.\d+)*$/;
		var val = re.test(document.ExecProfile.strMobilePhone.value); 
		if (val==false){
			document.getElementById('strMobilePhone').style.borderColor = '#F00';
			errNum+=1;
		}
	}
	
	//Resume File
	if (document.ExecProfile.resumeFile.value == ''){
		document.getElementById('resumeErrTxt').style.color = '#F00';
		document.getElementById('resumeFile').style.borderColor = '#F00';
		errNum+=1;
	}else{
		document.getElementById('resumeErrTxt').style.color = '#000';
		document.getElementById('resumeFile').style.borderColor = '#000';
	}
	
	//Resume Title
	if (document.ExecProfile.resumeTitle.value == '' || document.ExecProfile.resumeTitle.value == 'Resume Title'){
		document.getElementById('resumeTitle').style.borderColor = '#F00';
		errNum+=1;
	}else{
		document.getElementById('resumeTitle').style.borderColor = '#000';
	}
	
	//Signup for AAA
	var blnSignUpForAAA = document.getElementsByName('blnSignUpForAAA');
	var ischecked = false;
	for ( var i = 0; i < blnSignUpForAAA.length; i++) {
		if(blnSignUpForAAA[i].checked) {
			ischecked = true;
		}
	}
	if(!ischecked){ //payment method button is not checked
		document.getElementById('blnSignUpForAAAErrTxt').style.color = '#F00';
		errNum+=1;
	}else{
		document.getElementById('blnSignUpForAAAErrTxt').style.color = '';
	}
	
	
	
	
	//Highest Degree Earned
	if ( document.getElementById('strHighestDegree1').selectedIndex == 0){
		document.getElementById('strHighestDegree1').style.borderColor = '#F00';
		errNum+=1;
	}
	

	
	*/
	
	
	/*******************************************************
	********************************************************
	*******************************************************/
	
	//Errors
  	if (errNum > 0){
		document.getElementById('submitBtn').style.visibility = "visible";
		document.getElementById('errorDiv').style.display = "block";
		
		//Scroll to the top		
		$("html, body").animate({ scrollTop: 0 }, "fast");

  		return false ;
 	}else{
		$("#submitBtn").attr("disabled", "disabled");
		document.getElementById('errorDiv').style.display = "none";
  		return true ;
  	}
}

function validateFileExtension(fld) {
	if(!/(\.docx|\.doc|\.rtf|\.txt)$/i.test(fld.value)) {
		fld.focus();
		document.getElementById('resumeErrTxt').style.color = '#F00';
		return false;
	}else{
		document.getElementById('resumeErrTxt').style.color = '#000';
		document.getElementById('resumeFile').style.borderColor = '#000';
	}
	return true;
}


function checkUncheckAll(fieldName){
	var indChecked = 0;
	var funcChecked = 0;
	
	if (fieldName == 'industry'){    
		for (i=0; i<document.ExecProfile.intsIndIDs.length; i++){if (document.ExecProfile.intsIndIDs[i].checked==true){indChecked++;}}
		if (indChecked < 1 || indChecked > 5){
			document.getElementById('intsIndIDsErrTxt').style.color="#FF0000";
		}else{
			document.getElementById('intsIndIDsErrTxt').style.color="#000000";
		}
	}else if (fieldName == 'function'){
		for (i=0; i<document.ExecProfile.intsFuncIDs.length; i++){if (document.ExecProfile.intsFuncIDs[i].checked==true){funcChecked++;}}
		if (funcChecked < 1 || funcChecked > 5){
			document.getElementById('intsFuncIDsErrTxt').style.color="#FF0000";
		}else{
			document.getElementById('intsFuncIDsErrTxt').style.color="#000000";
		}
	}
}

var myDegreeCollege=1;
			
function addDegreeEduction(){
	//Increment the counter by 1
	myDegreeCollege = myDegreeCollege + 1
	//Get the tableID to make visible
	elementID = 'addEducationSchool' + myDegreeCollege;
	//make the table visible
	document.getElementById(elementID).style.display = 'block';
	
	//Also make the previous remove link invisible
	if (myDegreeCollege > 2){					
		removeWebSiteTextID = 'removeDegEduText' + (myDegreeCollege - 1);
		document.getElementById(removeWebSiteTextID).style.display = 'none';
	}
	
	if (myDegreeCollege < 5){
		document.getElementById('addDegreeSchool').style.display = 'block';
	}else{
		document.getElementById('addDegreeSchool').style.display = 'none';
	}
}

function removeDegreeEduction(rowID){
	//alert(rowID);
	//Get the tableID to make invisible
	elementID = 'addEducationSchool' + rowID;
	
	//Get the strHighestDegreeID 
	strHighestDegreeID = 'strHighestDegree' + rowID;
	document.getElementById(strHighestDegreeID).selectedIndex = 0;
	//Get the strSchoolID
	strSchoolID = 'strSchool' + rowID;
	document.getElementById(strSchoolID).value = '';
		
	//make the table invisible
	document.getElementById(elementID).style.display = 'none';
	
	//Also make the previous remove link visible
	if (rowID > 2){					
		removeDegEduTextID = 'removeDegEduText' + (rowID-1);
		document.getElementById(removeDegEduTextID).style.display = 'block';
	}
	
	//Decrement the myWebSiteCounter
	myDegreeCollege = myDegreeCollege - 1;
	
	if (myDegreeCollege < 5){
		document.getElementById('addDegreeSchool').style.display = 'block';
	}else{
		document.getElementById('addDegreeSchool').style.display = 'none';
	}	
}
	
function disableSchool(id, indexVal){
	schoolID = 'strSchool' + id;
	if (indexVal == 1){
		document.getElementById(schoolID).disabled = true;
	}else{
		document.getElementById(schoolID).disabled = false;
	}
		
}

function updateRegistrationStep(resID, step, dataField, formElement){
	var indChecked = 0;
	var funcChecked = 0;
	var regStepValue = 0;
	
	//Industry
	if ( dataField == 14){
		for (i=0; i<document.ExecProfile.intsIndIDs.length; i++){if (document.ExecProfile.intsIndIDs[i].checked==true){indChecked++;}}
		
		if (indChecked > 0){regStepValue = 1;}
	//Function
	}else if ( dataField == 15){
		for (i=0; i<document.ExecProfile.intsFuncIDs.length; i++){if (document.ExecProfile.intsFuncIDs[i].checked==true){funcChecked++;}}
		
		if (funcChecked > 0){regStepValue = 1;}
	}else{
		var formFieldValue = document.getElementById(formElement.id).value;
			
		if ( formFieldValue != ''){	regStepValue = 1;}
	}
		
	$.post("/js/join/updateRegistrationSteps.cfm?intResID=" + resID + "&step=" + step + "&dataField=" + dataField + "&regStepValue=" + regStepValue);
}
//-->
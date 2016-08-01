<script language="javascript">
<!--
var emailExistsErrTxt = '';

function checkform2(){
	var errormsg = '';
 	var errNum=0;
	
	//First Name
	if (document.ExecProfile.strFName.value == '' || document.ExecProfile.strFName.value == 'First Name'){
		document.getElementById('strFName').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Last Name
	if (document.ExecProfile.strLName.value == '' || document.ExecProfile.strLName.value == 'Last Name'){
		document.getElementById('strLName').style.borderColor = '#F00';
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
	
	//State/Country
	if ( document.getElementById('strState').selectedIndex == 0){
		document.getElementById('strState').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Email
	if (document.ExecProfile.strEmail.value == '' || document.ExecProfile.strEmail.value == 'Email Address'){
		document.getElementById('strEmail').style.borderColor = '#F00';
		//$("#strEmailErr").html("You can&#39;t leave this empty.");
		errNum+=1;
	}else{
		errtxt = checkemail();
		if (errtxt.length > 0){
			document.getElementById('strEmail').style.borderColor = '#F00';
			//$("#strEmailErr").html("Please enter a valid email address.");
			errNum+=1;
		}else if (emailExistsErrTxt.length > 0){
			document.getElementById('strEmail').style.borderColor = '#F00';
			//$("#strEmailErr").html(emailExistsErrTxt);
			errNum+=1;	
		}else{
			document.getElementById('strEmail').style.borderColor = '';	
			//$("#strEmailErr").html("");
		}
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

	
	//Username
	if (document.ExecProfile.strUserName.value == '' || document.ExecProfile.strUserName.value == 'User Name'){
		document.getElementById('strUserName').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Password
	if (document.ExecProfile.strCity.value == '' || document.ExecProfile.strPasswd.value == 'Password'){
		document.getElementById('strPasswd').style.borderColor = '#F00';
		errNum+=1;
	}
	
	
	//Relocation
	/*
	var blnRelocate = document.getElementsByName('blnrelocate');
	if(document.getElementsByName('blnrelocate')[0].checked) {
		document.getElementById('relocateOption').style.color = "#000000";
		//If Yes is checked make sure any value for relocation is selected.
		var relocationChkCnt = $("input[name='form_q_nst']:checked").length;
		if (relocationChkCnt == 0){
			document.getElementById('relocationText').style.color = "#FF0000";
			errNum+=1;
		}else{
			document.getElementById('relocationText').style.color = "#000";
		}
	}else if(document.getElementsByName('blnrelocate')[1].checked) {
		document.getElementById('relocateOption').style.color = "#000000";
	}else{
		document.getElementById('relocateOption').style.color = "#FF0000";
		errNum+=1;
	}
	*/
	
	
	//Relocation
	var relocationChkCnt = $("input[name='form_q_nst']:checked").length;
	var blnRelocate = document.getElementsByName('blnrelocate');
	var isblnblnRelocatechecked = false;
	for ( var i = 0; i < blnRelocate.length; i++) {
		if(blnRelocate[i].checked) {
			isblnblnRelocatechecked = true;
		}
	}
	
	
	if(!isblnblnRelocatechecked){ //payment method button is not checked
		document.getElementById('relocateOption').style.color = '#F00';
		errNum+=1;
	}else{
		document.getElementById('relocateOption').style.color = '';
		if (document.getElementById('blnrelocateYes').checked)
			relocate = 1;
		else if (document.getElementById('blnrelocateNo').checked)
			relocate = 0;
				
		//If Yes is checked
		if (relocate == 1){
			if (relocationChkCnt == 0 || relocationChkCnt > 10){
				document.getElementById('relocationDiv').style.display = "block";
				document.getElementById('relocationDiv').style.color = '#F00';
				errNum+=1;
			}else{
				document.getElementById('relocationDiv').style.display = "none";
			}
		}
	}
	
	
	//Privacy Setting
	if (document.ExecProfile.intPrivacySetting.value == ''){
		//document.getElementById('intPrivacySettingErrTxt').style.color = '#F00';
		document.getElementById('intPrivacySetting').style.borderColor = '#F00';
		errNum+=1;
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
	
	//Desired Job Title
	if (document.ExecProfile.strDesiredJobTitle.value == '' || document.ExecProfile.strDesiredJobTitle.value == 'Desired Job Title'){
		document.getElementById('strDesiredJobTitle').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Current or most recent compensation package
	if ( document.getElementById('fltCompensation_package').selectedIndex == 0){
		//document.getElementById('fltCompPackageErrTxt').style.color = '#F00';
		document.getElementById('fltCompensation_package').style.borderColor = '#F00';
		errNum+=1;
	}
	
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
	
	//Year of Experience 
	if ( document.getElementById('intYrsExp').selectedIndex == 0){
		document.getElementById('intYrsExp').style.borderColor = '#F00';
		errNum+=1;
	}
	
	//Highest Degree Earned
	if ( document.getElementById('strHighestDegree1').selectedIndex == 0){
		document.getElementById('strHighestDegree1').style.borderColor = '#F00';
		errNum+=1;
	}
	
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
  		document.ExecProfile.submit();
  	}
	
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

var myWebSiteCounter=0;

function addWebsite(){
	//Increment the counter by 1
	myWebSiteCounter = eval(myWebSiteCounter) + 1
	//Get the tableID to make visible
	elementID = 'myWebSitesID' + myWebSiteCounter;
	
	//make the table visible
	document.getElementById(elementID).style.display = 'block'
	
	
	//Also make the previous remove link invisible
	if (myWebSiteCounter > 2){					
		removeWebSiteTextID = 'removeWebSiteText' + (myWebSiteCounter - 1);
		document.getElementById(removeWebSiteTextID).style.display = 'none';
	}
	
	if (myWebSiteCounter < 5){
		document.getElementById('addWebSiteText').style.display = 'block'
	}else{
		document.getElementById('addWebSiteText').style.display = 'none'
	}
}

function removeWebSite(rowID){
	//Get the tableID to make invisible
	elementID = 'myWebSitesID' + rowID;
	
	//Get the resumeWebSitesCategoryID 
	resumeWebSitesCategoryID = 'resWebSiteCategory' + rowID;
	document.getElementById(resumeWebSitesCategoryID).selectedIndex = 0;
	
	//Get the resumeWebSiteNameID
	resumeWebSiteNameID = 'resWebSiteName' + rowID;
	
	//Get the resumeWebSiteURL
	resumeWebSiteURLID = 'resWebSiteURL' + rowID;

	//make the table visible
	document.getElementById(elementID).style.display = 'none';
	
	//Also make the previous remove link visible
	if (rowID > 2){					
		removeWebSiteTextID = 'removeWebSiteText' + (rowID-1);
		document.getElementById(removeWebSiteTextID).style.display = 'block';
	}
	
	//Decrement the myWebSiteCounter
	myWebSiteCounter = myWebSiteCounter = 1;
	
	if (myWebSiteCounter < 5){
		document.getElementById('addWebSiteText').style.display = 'block'
	}else{
		document.getElementById('addWebSiteText').style.display = 'none'
	}	
}

function validateNameURL(rowID){
	resumeWebSitesCategoryID = 'resWebSiteCategory' + rowID;
	categoryID = document.getElementById(resumeWebSitesCategoryID).value;

	//Get the resumeWebSiteNameID
	resumeWebSiteNameID = 'resWebSiteName' + rowID;
	categoryName = document.getElementById(resumeWebSiteNameID).value;
	
	//Get the resumeWebSiteURL
	resumeWebSiteURLID = 'resWebSiteURL' + rowID;
	categoryURL = document.getElementById(resumeWebSiteURLID).value;
	
	//If a categoryID is selected
	if (categoryID > 0){
		if (categoryName == ''){
			//Make the Category Name field red
			document.getElementById(resumeWebSiteNameID).style.borderColor="#FF0000";
		}else{
			document.getElementById(resumeWebSitesCategoryID).style.borderColor="#999999";
		}
		
		if (categoryURL == ''){
			//Make the Category URL field red
			document.getElementById(resumeWebSiteURLID).style.borderColor="#FF0000";
		}else{
			document.getElementById(resumeWebSitesCategoryID).style.borderColor="#999999";
		}
	}else{	
		//Reset the text field color
		document.getElementById(resumeWebSiteNameID).style.borderColor="#999999";
		document.getElementById(resumeWebSiteURLID).style.borderColor="#999999";
		
		document.getElementById(resumeWebSitesCategoryID).style.borderColor="#999999";
	}
}	

function validateWebSiteName(rowID){
	//Get the resumeWebSiteNameID
	resumeWebSiteNameID = 'resWebSiteName' + rowID;
	categoryName = document.getElementById(resumeWebSiteNameID).value;
	
	//Category Name
	if (categoryName.length > 0){
		document.getElementById(resumeWebSiteNameID).style.borderColor="#999999";
	}else{
		document.getElementById(resumeWebSiteNameID).style.borderColor="#FF0000";
	}
	
	resumeWebSitesCategoryID = 'resWebSiteCategory' + rowID;
	categoryID = document.getElementById(resumeWebSitesCategoryID).value;
	
	//Category Name
	if (categoryName.length > 0){
		if (categoryID == 0){
			document.getElementById(resumeWebSitesCategoryID).style.borderColor="#FF0000";
		}else{
			document.getElementById(resumeWebSitesCategoryID).style.borderColor="#999999";
		}
	}
}

function validateWebSiteURL(rowID){
	
	//Get the resumeWebSiteURLID
	resumeWebSiteURLID = 'resWebSiteURL' + rowID;
	categoryURL = document.getElementById(resumeWebSiteURLID).value;
	
	if (categoryURL.length > 0){
		document.getElementById(resumeWebSiteURLID).style.borderColor="#999999";
	}else{
		document.getElementById(resumeWebSiteURLID).style.borderColor="#FF0000";
	}
	
	resumeWebSitesCategoryID = 'resWebSiteCategory' + rowID;
	categoryID = document.getElementById(resumeWebSitesCategoryID).value;
	
	//Category Name
	if (categoryURL.length > 0){
		if (categoryID == 0){
			document.getElementById(resumeWebSitesCategoryID).style.borderColor="#FF0000";
		}else{
			document.getElementById(resumeWebSitesCategoryID).style.borderColor="#999999";
		}
	}
}

function resetValue(id){
	if (id.value == 'URL (ex: http://www.site.com)' || id.value == 'Website Title')
		id.value='';
}

function checkformWelcome(){
	var errNum = 0;
	
	//My Websites1
	if (!document.ExecProfile.resumeWebSitesCategory1){
		//Not Defined
	}else{
		if (document.ExecProfile.resumeWebSitesCategory1.selectedIndex > 0) {
			//My WebsiteName1		
			if(document.ExecProfile.resumeWebSiteName1.value.length < 1 || document.ExecProfile.resumeWebSiteName1.value == 'Website Title'){
				document.getElementById('resWebSiteName1').style.borderColor="#FF0000";
				errNum+=1;
			}else if (document.ExecProfile.resumeWebSiteName1.value.length > 0 && document.ExecProfile.resumeWebSiteName1.value != 'Website Title'){
				document.getElementById('resWebSiteName1').style.borderColor="";
			}
			
			//My WebsiteURL1
			if(document.ExecProfile.resumeWebSiteURL1.value.length < 1 || document.ExecProfile.resumeWebSiteURL1.value == 'URL (ex: http://www.mysite.com)'){
				document.getElementById('resWebSiteURL1').style.borderColor="#FF0000";
				errNum+=1;
			}else if (document.ExecProfile.resumeWebSiteURL1.value.length > 0 && document.ExecProfile.resumeWebSiteURL1.value != 'URL (ex: http://www.mysite.com)'){
				document.getElementById('resWebSiteURL1').style.borderColor="";
			}
		}else{
			//My WebsiteName1
			if( (document.ExecProfile.resumeWebSiteName1.value.length > 0 && document.ExecProfile.resumeWebSiteName1.value != 'Website Title') || (document.ExecProfile.resumeWebSiteURL1.value.length > 0 && document.ExecProfile.resumeWebSiteURL1.value != 'URL (ex: http://www.mysite.com)')){
				document.getElementById('resWebSiteCategory1').style.borderColor = "#FF0000";
				errNum+=1;
			}
		}
	}
	
	//My Websites2
	if (!document.ExecProfile.resumeWebSitesCategory2){
		//Not Defined
	}else{
		if (document.ExecProfile.resumeWebSitesCategory2.selectedIndex > 0) {
			//My WebsiteName2		
			if(document.ExecProfile.resumeWebSiteName2.value.length < 1 || document.ExecProfile.resumeWebSiteName2.value == 'Website Title'){
				document.getElementById('resWebSiteName2').style.borderColor="#FF0000";
				errNum+=1;
			}else if (document.ExecProfile.resumeWebSiteName2.value.length > 0 && document.ExecProfile.resumeWebSiteName2.value != 'Website Title'){
				document.getElementById('resWebSiteName2').style.borderColor="";
			}
			
			//My WebsiteURL2
			if(document.ExecProfile.resumeWebSiteURL2.value.length < 1 || document.ExecProfile.resumeWebSiteURL2.value == 'URL (ex: http://www.mysite.com)'){
				document.getElementById('resWebSiteURL2').style.borderColor="#FF0000";
				errNum+=1;
			}else if (document.ExecProfile.resumeWebSiteURL2.value.length > 0 && document.ExecProfile.resumeWebSiteURL2.value != 'URL (ex: http://www.mysite.com)'){
				document.getElementById('resWebSiteURL2').style.borderColor="";
			}
		}else{
			//My WebsiteName2
			if( (document.ExecProfile.resumeWebSiteName2.value.length > 0 && document.ExecProfile.resumeWebSiteName2.value != 'Website Title') || (document.ExecProfile.resumeWebSiteURL2.value.length > 0 && document.ExecProfile.resumeWebSiteURL2.value != 'URL (ex: http://www.mysite.com)')){
				document.getElementById('resWebSiteCategory2').style.borderColor = "#FF0000";
				errNum+=1;
			}
		}
	}

	//My Websites3
	if (!document.ExecProfile.resumeWebSitesCategory3){
		//Not Defined
	}else{
		if (document.ExecProfile.resumeWebSitesCategory3.selectedIndex > 0) {
			//My WebsiteName3		
			if(document.ExecProfile.resumeWebSiteName3.value.length < 1 || document.ExecProfile.resumeWebSiteName3.value == 'Website Title'){
				document.getElementById('resWebSiteName3').style.borderColor="#FF0000";
				errNum+=1;
			}else if (document.ExecProfile.resumeWebSiteName3.value.length > 0 && document.ExecProfile.resumeWebSiteName3.value != 'Website Title'){
				document.getElementById('resWebSiteName3').style.borderColor="";
			}
			
			//My WebsiteURL3
			if(document.ExecProfile.resumeWebSiteURL3.value.length < 1 || document.ExecProfile.resumeWebSiteURL3.value == 'URL (ex: http://www.mysite.com)'){
				document.getElementById('resWebSiteURL3').style.borderColor="#FF0000";
				errNum+=1;
			}else if (document.ExecProfile.resumeWebSiteURL3.value.length > 0 && document.ExecProfile.resumeWebSiteURL3.value != 'URL (ex: http://www.mysite.com)'){
				document.getElementById('resWebSiteURL3').style.borderColor="";
			}		
		}else{
			//My WebsiteName3
			if( (document.ExecProfile.resumeWebSiteName3.value.length > 0 && document.ExecProfile.resumeWebSiteName3.value != 'Website Title') || (document.ExecProfile.resumeWebSiteURL3.value.length > 0 && document.ExecProfile.resumeWebSiteURL3.value != 'URL (ex: http://www.mysite.com)')){
				document.getElementById('resWebSiteCategory3').style.borderColor = "#FF0000";
				errNum+=1;
			}
		}
	}
	
	//My Websites4
	if (!document.ExecProfile.resumeWebSitesCategory4){
		//Not Defined
	}else{
		if (document.ExecProfile.resumeWebSitesCategory4.selectedIndex > 0) {
			//My WebsiteName4		
			if(document.ExecProfile.resumeWebSiteName4.value.length < 1 || document.ExecProfile.resumeWebSiteName4.value == 'Website Title'){
				document.getElementById('resWebSiteName4').style.borderColor="#FF0000";
				errNum+=1;
			}else if (document.ExecProfile.resumeWebSiteName4.value.length > 0 && document.ExecProfile.resumeWebSiteName4.value != 'Website Title'){
				document.getElementById('resWebSiteName4').style.borderColor="";
			}
			
			//My WebsiteURL4
			if(document.ExecProfile.resumeWebSiteURL4.value.length < 1 || document.ExecProfile.resumeWebSiteURL4.value == 'URL (ex: http://www.mysite.com)'){
				document.getElementById('resWebSiteURL4').style.borderColor="#FF0000";
				errNum+=1;
			}else if (document.ExecProfile.resumeWebSiteURL4.value.length > 0 && document.ExecProfile.resumeWebSiteURL4.value != 'URL (ex: http://www.mysite.com)'){
				document.getElementById('resWebSiteURL4').style.borderColor="";
			}
		}else{
			//My WebsiteName4
			if( (document.ExecProfile.resumeWebSiteName4.value.length > 0 && document.ExecProfile.resumeWebSiteName4.value != 'Website Title') || (document.ExecProfile.resumeWebSiteURL4.value.length > 0 && document.ExecProfile.resumeWebSiteURL4.value != 'URL (ex: http://www.mysite.com)')){
				document.getElementById('resWebSiteCategory4').style.borderColor = "#FF0000";
				errNum+=1;
			}
		}
	}
	
	//My Websites5
	if (!document.ExecProfile.resumeWebSitesCategory5){
		//Not Defined
	}else{
		if (document.ExecProfile.resumeWebSitesCategory5.selectedIndex > 0) {
			//My WebsiteName5		
			if(document.ExecProfile.resumeWebSiteName5.value.length < 1 || document.ExecProfile.resumeWebSiteName5.value == 'Website Title'){
				document.getElementById('resWebSiteName5').style.borderColor="#FF0000";
				errNum+=1;
			}else if (document.ExecProfile.resumeWebSiteName5.value.length > 0 && document.ExecProfile.resumeWebSiteName5.value != 'Website Title'){
				document.getElementById('resWebSiteName5').style.borderColor="";
			}
			
			//My WebsiteURL5
			if(document.ExecProfile.resumeWebSiteURL5.value.length < 1 || document.ExecProfile.resumeWebSiteURL5.value == 'URL (ex: http://www.mysite.com)'){
				document.getElementById('resWebSiteURL5').style.borderColor="#FF0000";
				errNum+=1;
			}else if (document.ExecProfile.resumeWebSiteURL5.value.length > 0 && document.ExecProfile.resumeWebSiteURL5.value != 'URL (ex: http://www.mysite.com)'){
				document.getElementById('resWebSiteURL5').style.borderColor="";
			}
		}else{
			//My WebsiteName5
			if( (document.ExecProfile.resumeWebSiteName5.value.length > 0 && document.ExecProfile.resumeWebSiteName5.value != 'Website Title') || (document.ExecProfile.resumeWebSiteURL5.value.length > 0 && document.ExecProfile.resumeWebSiteURL5.value != 'URL (ex: http://www.mysite.com)')){
				document.getElementById('resWebSiteCategory5').style.borderColor = "#FF0000";
				errNum+=1;
			}
		}
	}
	
	//Relocation
	if (!document.ExecProfile.blnrelocate){
		//alert("Not Defined");
	}else{
		//blnRelocate
		var blnRelocate = document.getElementsByName('blnrelocate');
		
		if(document.getElementsByName('blnrelocate')[0].checked) {
			//If Yes is checked make sure any value for relocation is selected.
			var relocationChkCnt = $("input[name='form_q_nst']:checked").length;
			//alert('relocationChkCnt: ' + relocationChkCnt);
			if (relocationChkCnt == 0){
				document.getElementById('relocationText').style.color = "#FF0000";
				errNum+=1;
			}
		}else{
			document.getElementById('relocationText').style.color = "#000000";
		}
	}
	
	//alert(errNum);
	//Error
	if (errNum > 0)
		return false;
	else
		return true;
}

var myDegreeCollege=0;
			
function addDegreeEduction(){
	//Increment the counter by 1
	myDegreeCollege = eval(myDegreeCollege) + 1
	//Get the tableID to make visible
	elementID = 'addEducationSchool' + myDegreeCollege;
	//make the table visible
	document.getElementById(elementID).style.display = 'block'
	
	//Also make the previous remove link invisible
	if (myDegreeCollege > 2){					
		removeWebSiteTextID = 'removeDegEduText' + (myDegreeCollege - 1);
		document.getElementById(removeWebSiteTextID).style.display = 'none';
	}
	
	if (myDegreeCollege < 5){
		document.getElementById('addDegreeSchool').style.display = 'block'
	}else{
		document.getElementById('addDegreeSchool').style.display = 'none'
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
		document.getElementById('addDegreeSchool').style.display = 'block'
	}else{
		document.getElementById('addDegreeSchool').style.display = 'none'
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

function checkemail() {
	var errorMessage="";
	var email = document.ExecProfile.strEmail.value;
	var valid = "y";
	if (email != "") {
		if (email.length < 7 || email.indexOf("@.") != -1 || email.indexOf("-.") != -1 || email.indexOf("_.") != -1 || email.indexOf("..") != -1 || email.indexOf("._") != -1 || email.indexOf(".-") != -1 || email.indexOf(".@") != -1 || email.indexOf("@-") != -1 || email.indexOf("@_") != -1 || email.indexOf("@") != email.lastIndexOf("@") || email.indexOf("@") == -1 || email.indexOf(".") == -1 || (email.length - (email.lastIndexOf(".") + 1)) < 2) {
			valid = "n";
			//alert("The e-mail address you entered is invalid.");
			errorMessage = "<li><b>Email Required</b>: Please enter a valid email.</li>";
		}else {
			a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@-_.";
			b = 0;
			while (b < email.length) {
				if (a.indexOf(email.charAt(b)) == -1) {
					valid = "n";
					//alert("The e-mail address may not contain \"" + email.charAt(b) + "\".");
					errorMessage = "<li><b>Email Required</b>: Please enter a valid email.</li>";
					b = email.length;
				}
				b = b + 1;
			}
		}
	}
	
		
	if (valid == "y") {
		rx = /^[a-z0-9\-\._]*[a-z0-9_]@[a-z0-9][a-z0-9\-\.]*[a-z0-9]\.[a-z]{2,6}$/i; 
		if (rx.test(email)) {
			rx = /^[a-z0-9_]/i;
			if(!(rx.test(email))) {
				valid = "n";
				//alert("The e-mail address you entered is invalid.");
				errorMessage = "<li><b>Email Required</b>: Please enter a valid email.</li>."
			}
		}else {
			valid = "n";
			//alert("The e-mail address you entered is invalid.");
			errorMessage = "<li><b>Email Required</b>: Please enter a valid email.</li>"
		}
	}
	
	return errorMessage;
} 

function checkExecEmail_ClientSide(){
	//Get Form Field Value
	var emailaddress = document.ExecProfile.strEmail.value;
	if (emailaddress.length > 6){
		$.post("checkEmailExists.cfm?Email="+ emailaddress, function(data) {
	     	checkEmail_response(data, emailaddress);
	   	});
	}
}

//Object
function checkEmail_response(obj, emailAddress){
	emailResult = obj;
	emailExistsErrTxt="";
	if (emailResult == 1){	//email Already Exists
		emailExistsErrTxt = "Someone already has the email. " + emailAddress;
		document.getElementById('strEmail').style.borderColor = '#F00';
		$("#strEmailErr").html(emailExistsErrTxt);
	}else{
		emailExistsErrTxt="";
		document.getElementById('strEmail').style.borderColor = '';
		$("#strEmailErr").html("");
	}
	
}






//-->
</script>
<script src="/js/autoSuggest.js"/>
<cfoutput>
<!---//Education--->
        <script>
		myDegreeCollege = document.getElementById('resDegreeCount').value;
		</script>
        
        <cfloop index="i" from="1" to="5">
            <cfset j = i-1>
            <script>
            $("##removeDegEduText#i#").click(function() {
                $("##addEducationSchool#i#").slideUp(0);
                $("##removeDegEduText#j#").show();
                
                //Degree
                $("##strHighestDegree#i#")[0].selectedIndex = 0;
                //School University Name
                $("##strSchool#i#").val('')
                
                myDegreeCollege-=1;
                <cfif i is 5>
                   $("##addDegreeSchool").show();
                </cfif>
            });  	
            </script>
        </cfloop>
        <!---//Education--->
      
       <!--- //Websites and Online Profiles --->
        <script>
		myWebSiteCounter = document.getElementById('webSiteProfilesCount').value;
		</script>
        
        <cfloop index="i" from="1" to="5">
        <cfset j = i-1>
        <script>
		$("##removeWebSiteText#i#").click(function() {
            $("##myWebSitesID#i#").slideUp(0); 
            //Reset the Category Type
            $("##resWebSiteCategory#i#")[0].selectedIndex = 0;
            //Reset the Website Name
            $("##resWebSiteName#i#").val('')
            //Reset the website URl
            $("##resWebSiteURL#i#").val('')
            //Show the Remove Website Link
            $("##removeWebSiteText#j#").show();
            
            myWebSiteCounter-=1;
            <cfif i is 5>
               $("##addWebSiteText").show();
            </cfif>
        });  	
        </script>
        </cfloop> 
	</cfoutput>
function checkResumeUpload(){
	var errormsg = '';
 	var errNum=0;
	/*
	if (document.getElementById('resumeTitle').value == ''){
		document.getElementById('resumeTitle').style.borderColor = '#F00';
		errNum+=1;
		return false;
	}else{
		document.getElementById('resumeTitle').style.borderColor = '#000';	
	}
	*/
	if (document.getElementById('resumeFile').value == ''){
		document.getElementById('resumeUploadDiv').style.display = "block";
		errNum+=1;
		return false;
	} else{
		document.getElementById('resumeUploadDiv').style.display = "none";
	}
	
	//Signup for AAA
	if (document.myAccountResumeUpload.elements.namedItem("freeResumeCritique")){
		var freeResumeCritique = document.getElementsByName('freeResumeCritique');
		var ischecked = false;
		for ( var i = 0; i < freeResumeCritique.length; i++) {
			if(freeResumeCritique[i].checked) {
				ischecked = true;
			}
		}
	
		if(!ischecked){ //payment method button is not checked
			document.getElementById('blnResumeCritiqueErrTxt').style.color = '#F00';
			errNum+=1;
		}else{
			document.getElementById('blnResumeCritiqueErrTxt').style.color = '';
		}
	}
		
		
	if (errNum > 0){
  		return false ;
 	}else{
		document.getElementById('resUploadSubmitBtn').disabled=true;
		return true ;
  	}
}


function checkRelocation(){
	var errormsg = '';
 	var errNum=0;
	var relocate=0;
	
	//Relocation
	var relocationChkCnt = $("input[name='form_q_nst']:checked").length;
	var blnRelocate = document.getElementsByName('blnRelocate');
	var isblnblnRelocatechecked = false;
	for ( var i = 0; i < blnRelocate.length; i++) {
		if(blnRelocate[i].checked) {
			isblnblnRelocatechecked = true;
		}
	}
	
	if(!isblnblnRelocatechecked){ //payment method button is not checked
		document.getElementById('blnRelocationErrTxt').style.color = '#F00';
		errNum+=1;
	}else{
		document.getElementById('blnRelocationErrTxt').style.color = '';
		if (document.getElementById('blnrelocateYes').checked)
			relocate = 1;
		else if (document.getElementById('blnrelocateNo').checked)
			relocate = 0;
				
		//If Yes is checked
		if (relocate == 1){
			if (relocationChkCnt == 0 || relocationChkCnt > 10){
				document.getElementById('relocationDiv').style.display = "block";
				errNum+=1;
			}else{
				document.getElementById('relocationDiv').style.display = "none";
			}
		}
	}
			
	if (errNum > 0){
  		return false;
 	}else{
		return true;
  	}
}

function checkSocialMedia(){
	var errormsg = '';
 	var errNum=0;
	
	if ( document.getElementById('twitterProfile').value == '' && document.getElementById('linkedInProfile').value == '' ){
		document.getElementById('twitterProfile').style.borderColor = '#F00';
		document.getElementById('linkedInProfile').style.borderColor = '#F00';
		errNum+=1;	
	}else{
		document.getElementById('twitterProfile').style.borderColor = '#000';	
		document.getElementById('linkedInProfile').style.borderColor = '#000';
	}
	
	if (errNum > 0){
  		return false;
 	}else{
		return true;
  	}
}

function checkSocialMedia2(){
	var errormsg = '';
 	var errNum=0;
		
	if( document.getElementById('twitterProfile').value == ''){
		document.getElementById('twitterProfile').style.borderColor = '#F00';
		errNum+=1;	
	}else{
		document.getElementById('twitterProfile').style.borderColor = '#000';	
	}
	
	if (errNum > 0){
  		return false;
 	}else{
		return true;
  	}
}
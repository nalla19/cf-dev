<!--- <cfinclude template="/6fj/execs/resbuilder/_includes/isLoggedIn.cfm"> --->



<cfparam name="errTxt" default="" />

<cfif isdefined("form.fieldnames") and isdefined("form.execsummary")>
	<cfscript>
	//--------------------------- Executive Summary ---------------------------
	strExecJobTitle_1=trim(form.strExecJobTitle_1);
	//writeDump(strExecJobTitle_1);
	if (not(len(strExecJobTitle_1))){
  		blnInValidJobTitle1=1;
  		validSubmission = 0;
   		errTxt = errTxt & "<li><b>1st Job Title</b>: Please enter your most recent job title.</li>";
	}
	
	strExecJobCompany_1=trim(form.strExecJOBCompany_1);
	//writeDump(strExecJobTitle_1);
	if (not(len(strExecJobCompany_1))){
  		blnInValidJobCompany1=1;
  		validSubmission = 0;
   		errTxt = errTxt & "<li><b>1st Company</b>: Please enter the most recent company you worked for.</li>";
	}
	
			
	strExecJOBDescr_1=trim(form.strExecJOBDescr_1);
	word_cnt_1=listlen(strExecJOBDescr_1," ");
	
	if (word_cnt_1 gt 20){
 		blnInValidJobDescr1=1;
  		validSubmission = 0;
  	
		if (word_cnt_1 gt 20){
			errTxt = errTxt & "<li><b>1st Job Description</b>: Is longer than 20 words. Please shorten your description.</li>";
		}
	}

	strExecJobTitle_2=trim(form.strExecJobTitle_2);
	if (not len(strExecJobTitle_2)){
  		blnInValidJobTitle2=1;
  		validSubmission = 0 ;
    	errTxt = errTxt & "<li><b>2nd Job Title</b>: Please enter your most recent job title.</li>";
	}
	
	strExecJobCompany_2=trim(form.strExecJOBCompany_2);
	//writeDump(strExecJobTitle_1);
	if (not(len(strExecJobCompany_2))){
  		blnInValidJobCompany2=1;
  		validSubmission = 0;
   		errTxt = errTxt & "<li><b>2nd Company</b>: Please enter the most recent company you worked for.</li>";
	}
	
	strExecJOBDescr_2=trim(form.strExecJOBDescr_2);
	word_cnt_2=listlen(strExecJOBDescr_2," ");

	if (word_cnt_2 gt 20){
  		blnInValidJobDescr2=1;
  		validSubmission = 0 ;
    	
		if (word_cnt_2 gt 20){
  			errTxt = errTxt & "<li><b>2nd Job Description</b>: Is longer than 20 words. Please shorten your description.</li>";
  		}
	}

	description="";
	temp_txt=strExecJobTitle_1;
	
	if (len(strExecJOBCompany_1)){
  		temp_txt=temp_txt & " (#strExecJOBCompany_1#)";
	}
	
	temp_txt=temp_txt & ": " & strExecJOBDescr_1;
	temp_txt=temp_txt & chr(10) & chr(10) & strExecJobTitle_2;

	if (len(strExecJOBCompany_2)){
  		temp_txt=temp_txt & " (#strExecJOBCompany_2#)";
	}
	
	temp_txt=temp_txt & ": " & strExecJOBDescr_2;
	description=temp_txt;
	</cfscript>
	
       
	<cfif not len(errTxt)>
        <cfquery name="cfqUpdSummary" datasource="#application.dsn#">
        update 	tblResumes
		set 	dteEdited=getdate(),
				strExecJobTitle_1='#form.STREXECJOBTITLE_1#', 
				strExecJOBCompany_1='#form.STREXECJOBCOMPANY_1#', 
				strExecJOBDescr_1='#form.STREXECJOBDESCR_1#', 
				strExecJobTitle_2='#form.STREXECJOBTITLE_2#', 
				strExecJOBCompany_2='#form.STREXECJOBCOMPANY_2#', 
				strExecJOBDescr_2='#form.STREXECJOBDESCR_2#'
		where 	intResID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intresid#">
        </cfquery>
		
        <cflock scope="session" timeout="10" type="Exclusive">
			<cfset session.Exec.strExecJOBTitle_1 = form.STREXECJOBTITLE_1 />
			<cfset session.Exec.strExecJOBCompany_1  = form.STREXECJOBCOMPANY_1 />
			<cfset session.Exec.strExecJOBTitle_2 = form.STREXECJOBTITLE_2 />
			<cfset session.Exec.strExecJOBCompany_2 = form.STREXECJOBCOMPANY_2 />
		</cflock>
        
    	<!---
        <cfinvoke component="#resobj#" method="updateSummary">
            <cfinvokeargument name="jobTitle1" value="#form.STREXECJOBTITLE_1#" />
            <cfinvokeargument name="jobCompany1" value="#form.STREXECJOBCOMPANY_1#" />
            <cfinvokeargument name="jobDescription1" value="#form.STREXECJOBDESCR_1#" />  	
            <cfinvokeargument name="jobTitle2" value="#form.STREXECJOBTITLE_2#" />
            <cfinvokeargument name="jobCompany2" value="#form.STREXECJOBCOMPANY_2#" />
            <cfinvokeargument name="jobDescription2" value="#form.STREXECJOBDESCR_2#" />
            <cfinvokeargument name="description" value="#description#" />
        </cfinvoke>
    	--->
        
        <cfoutput>
        <!--- <meta http-equiv="refresh" content="0;url=/execs/resbuilder/execresSummary.cfm?#strAppAddToken#&confirm=#urlencodedformat('Your update was completed')#"> 
        <meta http-equiv="refresh" content="0;url=/execs/resbuilder/execresmanager.cfm?#strAppAddToken#&panel=1&confirm=#urlencodedformat('Your update was completed')#">--->
        </cfoutput>
		<!--- did we get here?
        <cfabort> --->
		
    </cfif>
</cfif>
<cfscript>
resObj = application.resume;
qgetResumeDetail = resObj.getResumeDetail(session.exec.intresid);
</cfscript>



<cfparam name="BLNINVALIDJOBTITLE1" default="" />
<cfparam name="BLNINVALIDJOBCOMPANY1" default="" />
<cfparam name="BLNINVALIDJOBDESCR1" default="" />

<cfparam name="BLNINVALIDJOBTITLE2" default="" />
<cfparam name="BLNINVALIDJOBCOMPANY2" default="" />
<cfparam name="BLNINVALIDJOBDESCR2" default="" />


<cfparam name="STREXECJOBTITLEVAL_1" default="#qgetResumeDetail.STREXECJOBTITLE_1#" />
<cfparam name="STREXECJOBCOMPANYVAL_1" default="#qgetResumeDetail.STREXECJOBCOMPANY_1#" />
<cfparam name="STREXECJOBDESCRVAL_1" default="#qgetResumeDetail.STREXECJOBDESCR_1#" />
<cfparam name="STREXECJOBTITLEVAL_2" default="#qgetResumeDetail.STREXECJOBTITLE_2#" />
<cfparam name="STREXECJOBCOMPANYVAL_2" default="#qgetResumeDetail.STREXECJOBCOMPANY_2#" />
<cfparam name="STREXECJOBDESCRVAL_2" default="#qgetResumeDetail.STREXECJOBDESCR_2#" />
<cfoutput>
<form name="ExecProfile" id="ExecProfile" action="/member-resume?activeTab=summary" method="post" onsubmit="return checkSummary(this);">
<!--- Word Count Here  --->
<input type="hidden" name="countDesc1" value="0">
<input type="hidden" name="countDesc2" value="0">	
<input type="hidden" name="notes" value="" />
<input type="hidden" name="execsummary" value="1" />


<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
  		<td>
 			<table cellpadding="10" cellspacing="0" border="0" width="100%">
            	<tr>
                	<td colspan="2">
                    	<span style="font-weight:bold;font-size:13px;color:##FF0000;">
                        Please review your <cfif application.sourceApp EQ "SalesStars">Professional<cfelse>Executive</cfif> Summary for accuracy and effectiveness...</span><br />
                        <div style="padding-bottom:12px;"></div>
                       	<li>You need to create a strong first impression.</li>
						<li>This is the first thing Employers &amp; Recruiters will see when searching candidate profiles.</li>
                        <div id="execsummary" style="display:none">
                        <img src="/images/registration/profileSnapshot.gif" />
						</div>
                        </li>
                        <li>We suggest you use keywords and list major accomplishments that are specific to your position.</li>
                  	</td>
              	</tr>
               
                <tr>
                	<!--- left side --->
                	<td class="standardBold" valign="top" width="50%">
                    	<table cellpadding="1" cellspacing="3" border="0" width="100%">
                    		<tr>
                      			<td class="standardBold" style="font-size:13px;">
					  				<span id="blnInValidJobTitle1"><!--- #checkValidation(' ---><strong>*Job Title 1:</strong><!--- ',blnInValidJobTitle1)# ---></span>
                              	</td>
                      			<td>
                                	<input tabindex="17" type="text" name="strExecJobTitle_1" value="#strExecJobTitleval_1#" maxlength="45" size="38"  class="exec_reg">
                              	</td>
                    		</tr>
                    		<tr>
                      			<td class="standardText" style="font-size:13px;"><!--- #checkValidation(' ---><strong>*Company 1:</strong><!--- ',blnInValidJobCompany1)# ---><br></td>
                      			<td>
                                	<input tabindex="18" type="text" name="strExecJOBCompany_1" value="#strExecJOBCompanyval_1#" maxlength="45" size="38"  class="exec_reg">
                               	</td>
                    		</tr>
                    		<tr>
                      			<td colspan="2" class="standardBold" style="font-size:13px;">
					  				<br />
					  				<span id="blnInValidJobDescr1">Job Description 1: Limit to 20 words or less</span>
					  				<textarea onClick="wordCount1();" onChange="wordCount1();" onKeyDown="wordCount1();" name="strExecJOBDescr_1" rows=8 cols="55" wrap="virtual" tabindex="19" style="font-size:13px; width:340px; max-width:340px; height:100px; max-height:100px; noresize:noresize;">#strExecJOBDescrval_1#</textarea>
                        			<br />	
									<div id="countDesc1" class="error_red"></div>   
									<!--- <img src="/images/registration/spellcheck.gif" onClick="doSpellCheck(document.ExecProfile, document.ExecProfile.strExecJOBDescr_1);return false;"> --->
                             	</td>
                    		</tr>
                  		</table>
                   	</td>
                	<!--- right side --->
                	<td class="standardBold" valign="top">
                    	<table cellpadding="1" cellspacing="3" border="0" width="100%">
                    		<tr>
                      			<td class="standardBold" style="font-size:13px;"><span id="blnInValidJobTitle2"><!--- #checkValidation(' ---><strong>*Job Title 2:</strong><!--- ',blnInValidJobTitle2)# ---></span></td>
                      			<td><input tabindex="20" type="text" name="strExecJobTitle_2" value="#strExecJobTitleval_2#" maxlength="45" size="38"  class="exec_reg"></td>
                    		</tr>
                    		<tr>
                      			<td class="standardText" style="font-size:13px;"><!--- #checkValidation(' ---><strong>*Company 2:</strong><!--- ',blnInValidJobCompany2)# ---></td>
                      			<td><input tabindex="21" type="text" name="strExecJOBCompany_2" value="#strExecJOBCompanyval_2#" maxlength="45" size="38"  class="exec_reg"></td>
                   	 		</tr>
                    
                    		<tr>
                      			<td colspan="2" class="standardBold" style="font-size:13px;">
					    			<br />
					  				<span id="blnInValidJobDescr2">Job Description 2: Limit to 20 words or less</span>
                        			<textarea onClick="wordCount2();" onChange="wordCount2();" onKeyDown="wordCount2();"   name="strExecJOBDescr_2" rows=8 cols="55" wrap="virtual" tabindex="22" style="font-size:13px; width:340px; max-width:340px; height:100px; max-height:100px; noresize:noresize;">#strExecJOBDescrval_2#</textarea>
                        			<br />
                        			<div id="countDesc2" class="error_red"></div>             
									<!--- <img src="/images/registration/spellcheck.gif" onClick="doSpellCheck(document.ExecProfile, document.ExecProfile.strExecJOBDescr_2);return false;"> --->
                             	</td>
                    		</tr>
                  		</table>
                    </td>
              	</tr>
            </table>
            <br />
 		</td>
  	</tr>
    <tr>
    	<td>
        	<!--- <input type="submit" class="exec_submit" value="Save Changes" /> --->
	        <!---<a href="##" class="executive_button" onclick="javascript:document.ExecProfile.submit();"><span>SAVE CHANGES</span></a>--->
            <div style="padding-bottom:5px;"></div>
			<a href="##" onclick="javascript:document.ExecProfile.submit();" role="button" class="btn btn-primary">Save Changes</a>

        </td>
    </tr>
</table> 

</form>

<!--- <script type='text/javascript' src="/js/execSummary.js"></script>
<script type='text/javascript' src="/js/wordCount.js"></script>
<script type='text/javascript' src="/js/spellchecker.js"></script> --->

<script type='text/javascript'>
// JavaScript Document

function checkSummary()		
{
 var errormsg = '';
 var errNum=0;	 
 
	wordCount1(); 	//Word Count 1
	wordCount2();  	//Word Count 2

//alert(userNameResult + emailResult); 
		  
  errormsg = "The following form fields are required to continue: <br>";
  erroremailmsg = "Email and confirmation email must match. \n Please re-enter your e-mail address.";
  emailInvalidMsg = "Please enter a valid value for the 'E-mail' field.";
  errPostalcode = "";
  	
	//Start List
	errormsg+= "<ul>";
	
  //Executive Summary
  if (document.ExecProfile.strExecJobTitle_1.value.length < 1) {
    errtxt = "<li><b>1st Job Title</b>: Please enter your most recent job title.</li>";
    errNum+=1;
	errormsg+= errtxt;			
document.getElementById('blnInValidJobTitle1').className="error_red";
		}
		else{			
document.getElementById('blnInValidJobTitle1').className="";
	}


if (parseInt(document.ExecProfile.countDesc1.value) < 5) {
    errtxt = "<li><b>1st Job Description</b>: Please enter your most recent job description.</li>";
    errNum+=1;
	errormsg+= errtxt;			
	document.getElementById('blnInValidJobDescr1').className="error_red";
	}
else if (parseInt(document.ExecProfile.countDesc1.value) > 21) {
    errtxt = "<li><b>1st Job Description</b>: The length <strong>("+ parseInt(document.ExecProfile.countDesc1.value) +")</strong> of your first job description is longer than 20 words. Please shorten your description</li>";
    errNum+=1;
	errormsg+= errtxt;
	document.getElementById('blnInValidJobDescr1').className="error_red";
}
else{			
	document.getElementById('blnInValidJobDescr1').className="";
	}


 if (document.ExecProfile.strExecJobTitle_2.value.length < 1) {
    errtxt = "<li><b>2nd Job Title</b>: Please enter your most recent job title.</li>";
    errNum+=1;
	errormsg+= errtxt;			
	document.getElementById('blnInValidJobTitle2').className="error_red";
		}
		else{			
	document.getElementById('blnInValidJobTitle2').className="";
	}

if (parseInt(document.ExecProfile.countDesc2.value) < 5) {
    errtxt = "<li><b>2nd Job Description</b>: Please enter your most recent job description.</li>";
    errNum+=1;
	errormsg+= errtxt;			
	document.getElementById('blnInValidJobDescr2').className="error_red";
	}
else if (parseInt(document.ExecProfile.countDesc2.value) > 21) {
    errtxt = "<li><b>2nd Job Description</b>: The length <strong>("+ parseInt(document.ExecProfile.countDesc2.value) +")</strong> of your first job description is longer than 20 words. Please shorten your description</li>";
    errNum+=1;
	errormsg+= errtxt;
	document.getElementById('blnInValidJobDescr2').className="error_red";
}
else{		
	document.getElementById('blnInValidJobDescr2').className="";
	}
	 
	 
  
  //End Error Message
  errormsg+=  "</ul>";
  //Errors
 
  if (errNum > 0){
  	displayError(errormsg);
  	return false ;
  }
  else{
  // ** END **			
	document.getElementById('errorDiv').style.display = "none";
  	
	return true ;	
  }

}
//Count Words Here For Job Description
function wordCount(theValue){
	var formcontent=theValue
	formcontent=formcontent.split(" ")
	return formcontent.length;
}


//Word Count
function wordCount1(){
		var formcontent=document.ExecProfile.strExecJOBDescr_1.value;
		formcontent=formcontent.split(" ");
		document.ExecProfile.countDesc1.value = formcontent.length;			
		document.getElementById('countDesc1').innerHTML=formcontent.length + " words and counting...";
		//Description 1
		if (document.ExecProfile.countDesc1.value > 5){			
		document.getElementById('countDesc1').innerHTML=formcontent.length + " words and counting...";
		}
		//Comp Green
		if (document.ExecProfile.countDesc1.value < 21){			
		document.getElementById('countDesc1').className="compGreen";
		}
		else{			
		document.getElementById('countDesc1').className="error_red";
		}
}

function wordCount2(){
		var formcontent=document.ExecProfile.strExecJOBDescr_2.value;
		formcontent=formcontent.split(" ");
		document.ExecProfile.countDesc2.value = formcontent.length;			
		document.getElementById('countDesc2').innerHTML=formcontent.length + " words and counting...";
		//Description 2
		if (document.ExecProfile.countDesc2.value > 5){			
		document.getElementById('countDesc2').innerHTML=formcontent.length + " words and counting...";
		}
		//Comp Green
		if (document.ExecProfile.countDesc2.value < 21){			
		document.getElementById('countDesc2').className="compGreen";
		}
		else{			
		document.getElementById('countDesc2').className="error_red";
		}
}


</script>

</cfoutput>
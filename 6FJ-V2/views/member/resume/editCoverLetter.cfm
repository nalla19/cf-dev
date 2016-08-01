<!--- <cfinclude template="/6fj/execs/resbuilder/_includes/isLoggedIn.cfm"> --->
<cfparam name="form.title" default="" />
<cfparam name="form.coverletter" default="" />
<cfparam name="confirmMessage" default="" />

<script language="JavaScript"type="text/javascript">

// JavaScript Document
function showHide(){
	var vis = document.getElementById('coverLetter').style.display;
	if (vis == 'none')
		document.getElementById('coverLetter').style.display = 'block';
	else
		document.getElementById('coverLetter').style.display = 'none';
}


function checkCoverLetter(){
	var errormsg = '';
 	var errNum=0;	 
 		  
  	errormsg = "The following form fields are required to continue: <br>";
  	erroremailmsg = "Email and confirmation email must match. \n Please re-enter your e-mail address.";
  	emailInvalidMsg = "Please enter a valid value for the 'E-mail' field.";
  	errPostalcode = "";
  	
	//Start List
	errormsg+= "<ul>";
	
	//Cover Letter Name
	if (document.ExecCover.title.value.length < 1) {
    	errtxt = "<li><b>Cover Letter Name</b>: Please enter your Cover Letter Name.</li>";
    	errNum+=1;
		errormsg+= errtxt;			
		document.getElementById('blnInValidCoverLetterName').className="error_red";
	}else{			
		document.getElementById('blnInValidCoverLetterName').className="";
	}
	
	//Cover Letter Content
	if (document.ExecCover.coverletter.value.length < 1) {
    	errtxt = "<li><b>Cover Letter</b>: Please enter your Cover Letter.</li>";
    	errNum+=1;
		errormsg+= errtxt;			
		document.getElementById('blnInValidCoverLetterContent').className="error_red";
	}else{			
		document.getElementById('blnInValidCoverLetterContent').className="";
	}	 
	//End Error Message
  	errormsg+=  "</ul>";
  	//Errors
 
  	if (errNum > 0){
  		displayError(errormsg);
  		return false ;
  	}else{
  		// ** END **			
		document.getElementById('errorDiv').style.display = "none";
  		return true ;	
  	}
}
</script>

<cftry>
	<cfparam name="URL.letterid" type="numeric" default="1" />
    <cfcatch>
    	<cfset URL.letterid = 1 />
  	</cfcatch>
</cftry>

<!----
APPLY TO JOB:
-------------
When coming from the apply to job page, the user needs to have a link
to go back to the Apply to Job page
------>
<cfparam name="strApplyToJobPage" default="" />
<cftry>
	<cfparam name="URL.blnapplytojob" type="numeric" default="0" />
  	<cfcatch>
    	<cfset URL.blnapplytojob = 0 />
  	</cfcatch>
</cftry>

<cfif (url.blnapplytojob) and url.blnapplytojob eq 1>
	<cfset strApplyToJobPage = cgi.http_referer>
</cfif>


<cfscript>
resObj = application.resume;
qgetCoverletter = resObj.getCoverLetterDetails(url.letterid);
</cfscript>

<cfparam name="blnInValidCoverLetterName" default="" />
<cfparam name="blnInValidCoverLetterContent" default="" />
<cfparam name="errTxt" default="" />

<cfif not(qgetCoverletter.recordcount)>
	<!--- <cfoutput>
	<meta http-equiv="refresh" content="0;url=/execs/resbuilder/execrescover.cfm?#application.strAppAddToken#&message=#urlencodedformat('This is not your Cover Letter')#">
	</cfoutput> --->
	<cfabort>
</cfif>
<cfif not isdefined("form.fieldnames")>
	<cfset form.title = "#qgetCoverletter.strCoverName#">
    <cfset form.coverletter = "#qgetCoverletter.strCoverLetter#">
    
<cfelseif isdefined("form.fieldnames")>
	
    
    <cfscript>
	//--------------------------- Cover Letter ---------------------------
	if (not(len(trim(form.title)))){
  		blnInValidCoverLetterName=1;
  		validSubmission = 0;
   		errTxt = errTxt & "<li><b>Cover Letter Name</b>: Please enter your cover letter name.</li>";
	}
	
	if (not(len(trim(form.coverletter)))){
  		blnInValidCoverLetterContent=1;
  		validSubmission = 0 ;
    	errTxt = errTxt & "<li><b>Cover Letter</b>: Please enter your cover letter.</li>";
	}
	</cfscript>
        
    <cfif not(len(errTxt))>
		<cfset void = resObj.updateCoverLetter(form.letterid,form.title,form.coverletter) />

       	<cfif strApplyToJobPage neq "">
			<cfset confirmMessage ="Your update was completed!">
           <!--- 	<cfoutput>
            <meta http-equiv="refresh" content="0;url=#strApplyToJobPage#">
            </cfoutput> --->
       	<cfelse>
			<!--- <cfoutput>
            <meta http-equiv="refresh" content="0;url=#request.secureURL#/execs/resbuilder/execresmanager.cfm?#application.strAppAddToken#&panel=2&confirm=#urlencodedformat('Your request was completed')#">
            </cfoutput> --->
			<!--- <cflocation url="/member-resume?activeTab=letters"> --->
			<cfset confirmMessage ="Your update was completed!">
        </cfif>
  		
    </cfif>
</cfif>

<cfoutput>
<div class="page-companies">
	<article class="section companies well">
		<div class="container">
		
		<form name="ExecCoverEdit" action="/member-letter-edit?#application.strAppAddToken#&resumeid=#session.exec.intresid#&letterid=#url.letterid#" method="post">
		<input type="hidden" name="letterid" value="#URL.letterid#" />
		<input type="hidden" name="strApplyToJobPage" value="#strApplyToJobPage#" />
		<cfif len(confirmMessage)>
			<table width="100%" border="0" cellpadding="0" cellspacing="3" class="table">
				<tr class="info">
					<td colspan="2" style="text-align:center">#confirmMessage#</td>
				</tr>
			</table>
			</cfif>
		<table width="100%" border="0" cellpadding="0" cellspacing="3">
			<tr>
				<td><h1>Edit Cover Letter</h1></td>
				<td align="right">
					<!--- <a href="/execs/resbuilder/execrescover.cfm?#application.strAppAddToken#">Back to Cover Letters</a> --->
					<!---
					APPLY TO JOB:
					-------------
					Link the user to the Apply to Job Page if coming from there
					--->
					<cfif strApplyToJobPage neq "">
						<a href="#strApplyToJobPage#" >Back to Apply Job</a>
					<cfelse>
						<a href="/member-resume?activeTab=letters&100k=1&panel=2?#application.strAppAddToken#&panel=2" >Back to Cover Letters</a>
					</cfif>
				</td>
						
			</tr>
			
			<tr>
				<td class="standardBold" colspan="2">
					<span id="coverlettername"><!--- #checkValidation(' ---><strong>*Cover Letter Name:</strong><!--- ',blnInValidCoverLetterName)# ---></span>
				</td>
			</tr>
			
			<tr>
				<td colspan="2">
					<input tabindex="17" type="text" name="title" value="#form.title#" maxlength="45" size="38"  class="exec_reg">
				</td>
			</tr>
			
			<tr>
				<td class="standardBold" colspan="2" style="padding-top:15px;">
				
					<span id="coverletter"><!--- #checkValidation(' ---><strong>*Cover Letter:</strong><!--- ',blnInValidCoverLetterContent)# ---></span>
				</td>
			</tr>
			
			<tr>
				<td colspan="2">
					<textarea name="coverLetter" rows=15 wrap="virtual" tabindex="2" style="width:100%; onClick="coverLetter();" onChange="coverLetter();" onKeyDown="coverLetter();" class="exec_reg">#form.coverletter#</textarea>
					
					</td>
			</tr>
			
		   <tr>
				<td colspan="2">
					<!--- <input type="submit" class="exec_submit" value="Save Changes" /> --->
					<a href="##" onclick="javascript:document.ExecCoverEdit.submit();" role="button" class="btn btn-primary btn-xs">Save Changes</a>
					
				</td>
			</tr>
		</table> 

		</form>
	</div>
	</article>
</div>
</cfoutput>
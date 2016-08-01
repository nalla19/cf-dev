<!--- <cfinclude template="/6fj/execs/resbuilder/_includes/isLoggedIn.cfm"> --->
<cfparam name="form.title" default="" />
<cfparam name="form.resume" default="" />
<cfparam name="form.resFileName" default="" />
<cfparam name="form.resumeFile" default="" />
<cfparam name="form.resFileAttachment" default="" />
<cfparam name="confirmMessage" default="" />   


<cftry>
	<cfparam name="URL.resumeid" type="numeric" default="1" />
  	<cfcatch>
    	<cfset URL.resumeid = 1 />
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
<!---
<cfoutput>
blnapplytojob=#url.blnapplytojob#<br />
strApplyToJobPage=#strApplyToJobPage#<br />
</cfoutput>
--->
<!--- ----->

<cfscript>
resObj = application.resume;
execObj = application.executive;

qgetResume = resObj.getResume(url.resumeid);
resObj.setResumePath(session.exec.intresid);
//Files Uploaded Here
resumeDirectory = resObj.getResumeDir(session.exec.intresid);
resumePath = resObj.getResumePath(session.exec.intresid);
</cfscript>


<cfparam name="blnInValidResumeName" default="" />
<cfparam name="blnInValidResumeContent" default="" />
<cfparam name="errTxt" default="" />

<cfif (isdefined("form.fieldnames") and isdefined("form.uploadFile")) and isdefined("form.uploadbutton")>
	<cfparam name="form.uploadbutton" default="" />
	<cfparam name="url.message" default="" />			
	<!--- File Length Is Not OK --->
	<!--- Size is Over 250,000 Bytes --->
	<cfif cgi.CONTENT_LENGTH gte 350000>
		<cfset url.message = "Uploaded file is too large. Please upload files smaller than 300KB.">				
	</cfif>
        
    <cfif len(url.message)>
    	<cfoutput>
        <meta http-equiv="refresh" content="0;url=#cgi.SCRIPT_NAME#?#application.STRAPPADDTOKEN#&message=#urlencodedformat( url.message)#" / > 
        </cfoutput>
        <cfabort>
   	</cfif>
    
    <cffile action="upload" destination="#resumeDirectory#" filefield="form.resumeFile" nameconflict="overwrite">
	<cfset uploadedFile = resumeDirectory & cffile.serverFile />
    <cfset parsedResume = execObj.parseResume(uploadedFile,1)/>
    <cfset form.resume = #parsedResume#>
    <cfset form.resFileName = cffile.serverFile />
</cfif> 


<cfif not(qgetResume.recordcount)>
hi
	<!--- <cfoutput>
	<meta http-equiv="refresh" content="0;url=/execs/resbuilder/execresmanager.cfm?#application.STRAPPADDTOKEN#&message=#urlencodedformat('This is not your resume')#">
	</cfoutput> --->
	<cfabort>
<cfelseif isdefined("form.fieldnames") and not isdefined("form.uploadbutton")>

	<cfscript>
	
	//if (not(len(form.title))){
	//	form.title = "My Resume";
	//}
	
	//--------------------------- Cover Letter ---------------------------
	if (not(len(trim(form.title)))){
  		blnInValidResumeName=1;
  		validSubmission = 0;
   		errTxt = errTxt & "<li><b>Resume Name</b>: Please enter your resume name.</li>";
	}
	
	if (not(len(trim(form.resume)))){
  		blnInValidResumeContent=1;
  		validSubmission = 0 ;
    	errTxt = errTxt & "<li><b>Executive Resume</b>: Please enter your executive resume.</li>";
	}
	</cfscript>
    
    <cfif not(len(errTxt))>
		<cfset void = resObj.updateResume(form.resumeid,form.title,form.resume, form.resFileName) />    
    
		<cfif strApplyToJobPage neq "">
			<cfset confirmMessage ="Your update was completed!">
        <cfelse>
			<cfset confirmMessage ="Your update was completed!">             
	
			<!---<cfoutput>
             <meta http-equiv="refresh" content="0;url=/execs/resbuilder/execresmanager.cfm?#application.STRAPPADDTOKEN#&confirm=#urlencodedformat('Your update was completed')#"> 
            <meta http-equiv="refresh" content="0;url=/execs/resbuilder/execresmanager.cfm?#application.STRAPPADDTOKEN#&panel=1&confirm=#urlencodedformat('Your update was completed')#">
            </cfoutput>
            <cfabort>--->
        </cfif>
    </cfif>
</cfif>

<cfscript>

if (not(len(form.title))){form.title=qgetResume.title;}
if (not(len(form.resume))){form.resume=qgetResume.resume;}

</cfscript>


<div class="page-companies">
	<article class="section companies well">
		<div class="container">
			<cfoutput>
			
			<!--- <form action="#cgi.SCRIPT_NAME#?#application.STRAPPADDTOKEN#&resumeid=#url.resumeid#" method="post"> --->
			
			<form action="/member-resume-edit?#application.STRAPPADDTOKEN#&resumeid=#url.resumeid#" method="post" enctype="multipart/form-data" name="uploadform" onsubmit="document.body.style.cursor='wait';">
			<input type="hidden" name="resumeid" value="#url.resumeid#" />
			<input type="hidden" name="resFileAttachment" value="#form.resumeFile#" />
			<input type="hidden" name="resFileName" value="#form.resFileName#" />
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
					<td><h1>Edit Resume</h1> </td>
					<td align="right">
						<!--- <a href="/execs/resbuilder/execresmanager.cfm?#application.STRAPPADDTOKEN#">Back to Resume Manager</a> --->
						<!---
						APPLY TO JOB:
						-------------
						Link the user to the Apply to Job Page if coming from there
						--->
						<cfif strApplyToJobPage neq "">
							<a href="#strApplyToJobPage#">Back to Apply to Job</a>
						<cfelse>
							<a href="/member-resume?#application.STRAPPADDTOKEN#" >Back to Resume Management</a>
						</cfif>
					</td>
				</tr>
				
				
				<cfif isBoolean(session.exec.isPremium) and not session.exec.isPremium>
				<tr>
					<td colspan="2" align="left">
						<!--- <form action="#cgi.SCRIPT_NAME#" enctype="multipart/form-data" name="uploadform" method="POST" onsubmit="document.body.style.cursor='wait';"> --->
						<input type="hidden" name="uploadFile" value="1" />
						<!-- Start Premium Membership -->
						<!--- <script language="JavaScript" src="/js/fileUpload.js" type="text/javascript"></script>
						<script language="JavaScript" src="/js/execResumeUpload.js" type="text/javascript"></script> --->
						<div id="new_closed" class="content" style="text-align:left; display:block; padding-bottom:8px;">
						<input type="button" name="hideMe" class="btn btn-primary btn-small" value="Replace Existing Resume" onclick="toggle('new_opened', 'new_closed');" style="display:block; text-decoration:none;">
						</div>
						
						<div id="new_opened" style="display:none;">
						<table cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td width="50%"></td>
							</tr>
							<tr>
								<td  valign="top">
									<!--- If Premium Member --->
									<table cellpadding="5" cellspacing="0" border="0" width="90%">
										<tr>
											<td class="content" style="font-size:14px; font-weight:bold;">Attach Resume</td>
										</tr>
										<tr>
											<td>
												<table cellpadding="0" cellspacing="0" border="0">
													<tr>
														<td>&nbsp;&nbsp;
															<input  name="resumeFile" id="resumeFile" type="file" size="40" value="" onchange="allowSubmit();">
														</td>
														<td><img src="/img/spacer.gif" width="5" height="5" alt=""></td>
														<td>
															<div id="upload">
															<input disabled="disabled" type="submit" id="uploadButton"  name="uploadButton" value="Upload Resume">
															</div>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td id="resumeFileText" style="padding: 0 0 15px 13px;"><strong>Please:</strong> Upload Microsoft Word&reg documents of up to 300 KB only.</td>
										</tr>
									</table>           
								</td>
							</tr>
						</table>
						</div>  
						<div class="page-spacer"></div>      
						<!--- </form> --->
					</td>
				</tr>
				</cfif>
				
				  
				<tr>
					<td colspan="2" class="standardBold" style="font-size:14px;">
						<span id="resume"><strong>* Resume Name:</strong>&nbsp;<strong><input name="title" id="title" value="#form.title#" size="50" maxlength="100" /></strong></span>        	
						<!--- <span class="header4">Resume Name:&nbsp;<strong><input name="title" id="title" value="#form.title#" size="50" maxlength="100" /></strong></span> --->
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2" class="standardBold" style="font-size:14px;">
						<span id="resume"><strong>* Executive Resume:</strong></span>
						<!--- <span class="header4">Executive Resume:&nbsp;</span> --->
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<textarea name="resume" class="form-control" rows="20" wrap="soft" style="width:100%;">#form.resume#</textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<!--- <input type="submit" class="exec_submit" name="SaveChanges" id="SaveChanges" value="Save Changes" /> --->
						<!---<a href="##" class="executive_button" onclick="javascript:document.uploadform.submit();" name="SaveChanges" id="SaveChanges"><span>SAVE CHANGES</span></a>--->
						<div style="padding-bottom:10px;"></div>
						
						<!--- <a href="##" onclick="javascript:document.uploadform.submit();" name="SaveChanges" id="SaveChanges"><img src="/images/save-changes-button-092012.png" border="0" /></a> --->
						<a href="##" onclick="javascript:document.uploadform.submit();" name="SaveChanges" id="SaveChanges" role="button" class="btn btn-primary btn-xs">Save Changes</a>
						<div style="padding-bottom:100px;"></div>
						
					</td>
				</tr>
			</table> 
			
			</form>
			</cfoutput>
		</div>
	</article>
</div>
<script>
// JavaScript Document
function validateFileExtension(fld) {	
	if(!/(\.docx|\.doc|\.rtf|\.txt)$/i.test(fld.value)) {
		fld.focus();
		return false;
	}		
	
	return true;
}


/* Disable Nodes */
d=document;
function showOne(){for(a=0;a<arguments.length;a++){if(a==0){show(arguments[a]);}else{hide(arguments[a]);}}return ;}
function toggle(B,A){d.getElementById(A).style.display="none";
d.getElementById(B).style.display="block";}
function hide(A){d.getElementById(A).className="hide";}
function show(A){d.getElementById(A).className="show";}
function showIn(A){d.getElementById(A).className="show_in";}
function showHide(A){
	if(d.getElementById(A).className=="show"){d.getElementById(A).className="hide";}
	else{d.getElementById(A).className="show";}}
function showHideIn(A){
	if(d.getElementById(A).className=="show_in"){d.getElementById(A).className="hide";}
	else{d.getElementById(A).className="show_in";}}
function hoverMe(B,A){B.className=(A==1)?"hover":A;}
function donothing(A){var B=A;}
function swapDiv(B,A){showHide(B);showHide(A);}
function swapDivIn(B,A){showHideIn(B);showHideIn(A);}


// JavaScript Document
function resetForm(){			
	document.getElementById('resumeFileText').className="";
	document.getElementById('uploadButton').disabled=true;
	document.getElementById('uploadButton').className="";
} 


function disableFields(){
			document.getElementById('resumeFileText').className="";
			document.getElementById('uploadButton').disabled=true;
			document.getElementById('resumeFileText').className="error_red";	 
}

function allowSubmit() {

	var validExtension = validateFileExtension(document.getElementById('resumeFile'));
	var enableUpload = (document.getElementById('resumeFile').value.length > 0) ? true : false;
	
	if(enableUpload && validExtension){
		//Enable Upload...
		document.getElementById('uploadButton').className="exec_submit";
		document.getElementById('uploadButton').disabled=false;						
		document.getElementById('resumeFileText').className="";								
	}
	else{
		disableFields();
	}
}
		
</script>
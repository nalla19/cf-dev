<script language="JavaScript" type="text/javascript">

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
  
<!--- <cfinclude template="/6fj/execs/resbuilder/_includes/isLoggedIn.cfm"> --->
<cfparam name="form.title" default="" />
<cfparam name="form.coverletter" default="" />

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

</cfscript>

<cfparam name="blnInValidCoverLetterName" default="" />
<cfparam name="blnInValidCoverLetterContent" default="" />
<cfparam name="errTxt" default="" />
<cfif isdefined("form.fieldnames")>	
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
    	<cfset void = resObj.insertCoverLetter(form.title, form.coverletter) />
        
    	<!---ISR <cfif strApplyToJobPage neq "">
           	<cfoutput>
            <meta http-equiv="refresh" content="0;url=#strApplyToJobPage#">
            </cfoutput>
        <cfelse>
  			<cfoutput>
    		<meta http-equiv="refresh" content="0;url=#request.secureURL#/execs/resbuilder/execresmanager.cfm?#application.strAppAddToken#&panel=2&confirm=#urlencodedformat('Your request was completed')#">
  			</cfoutput>
        </cfif>
  		<cfabort> --->
    </cfif>
</cfif>
<cfscript>
qgetCoverLetters = resObj.getCoverLetters(session.exec.intresid);
</cfscript>
<cfoutput>
<!--- <form name="ExecCover" id="ExecCover" action="#cgi.SCRIPT_NAME#?#application.strAppAddToken#" method="post" onsubmit="return checkSummary(this);"> --->
<!--- Word Count Here  --->


	<table cellpadding="0" cellspacing="5" border="0" width="100%">
		<tr>
			<td colspan="2"><br />
				<strong>You may store up to 3 cover letters and edit them at any time before applying to a job.</strong>
				<br />
			</td>
		</tr>
	</table>
         
    <form name="ExecCover" id="ExecCover" action="/member-resume?activeTab=letters&#application.strAppAddToken#" method="post" onsubmit="return checkCoverLetter(this);">
    <input type="hidden" name="strApplyToJobPage" value="#strApplyToJobPage#" />
   <table width="100%" class="table" >
  	 <tr>
		<th class="span5">Cover Letter</th><!--- 
		<th>Edited</th> --->
		<th>Actions</th>
	</tr>
	 <cfset clCnt = 0>
                <cfif qgetCoverLetters.recordcount gt 0>
	                <cfloop query="qgetCoverLetters">
                    <cfset clCnt = clCnt + 1>
					 <tr>
						<td><a href="/member-letter-edit?#application.strAppAddToken#&letterid=#intLetterID#">#strCoverName#</a>
						<br>
						(Last Edited: #dateformat(dteSubmit, 'mm/dd/yyyy')#)
						</td>
						<td>
							<div class="form-inline"></div>
								<a href="/member-letter-edit?#application.strAppAddToken#&letterid=#intLetterID#" role="button" class="btn btn-primary btn-xs" title="Edit"><i class="icon-edit icon-white"></i></a>
                           	 	&nbsp;<a href="/member-letter-preview?#application.strAppAddToken#&letterid=#intLetterID#" role="button" class="btn btn-primary btn-xs" title="Edit"><i class="icon-eye-open icon-white"></i></a>
                            	&nbsp;<a href="/member-letter-delete?#application.strAppAddToken#&letterid=#intLetterID#" role="button" class="btn btn-primary btn-xs" title="Edit"><i class="icon-trash icon-white"></i></a>
							</div>
						</td>
                     </tr>
                          
        	  		</cfloop>
				<cfelse>
					
						<tr>
							<td colspan="8" width="100%" style="font-size:13px;">
								You do not have any Cover Letters on file. Please click the link below to create cover letter(s).
							</td>
						</tr>
					
   </table>
               <!---  <cfset clCnt = 0>
                <cfif qgetCoverLetters.recordcount gt 0>
	                <cfloop query="qgetCoverLetters">
                    <cfset clCnt = clCnt + 1>
                    <div id="CoverLetterRow">
                        <div id="CoverLetter_Title">
                            #strCoverName#
                        </div>
                
                        <div id="CoverLetter_Edited">
                            #dateformat(dteSubmit, 'mm/dd/yyyy')#
                        </div>
                        
                        <div id="CoverLetter_Actions">
                           <table>
                                <tr>
                                    <td width="30" align="left" nowrap="nowrap"><a href="/member-letter-edit?#application.strAppAddToken#&letterid=#intLetterID#">Edit</a></td>
                                    <td width="50" align="left" nowrap="nowrap"><a href="/member-letter-preview?#application.strAppAddToken#&letterid=#intLetterID#">Preview</a></td>
                                    <td width="40" align="left" nowrap="nowrap"><a href="/member-letter-delete?#application.strAppAddToken#&letterid=#intLetterID#">Delete</a></td>
                                </tr>
                            </table>
                        </div>
                   	</div>
                    <div class="clear"></div>
                    </cfloop>
                    <div class="horizontal_solid_line" style="width:536px; float:left;"></div>
                <cfelse>
                <table>
                	<tr>
                        <td colspan="8" width="100%" style="font-size:13px;">
                        	You do not have any Cover Letters on file. Please click the link below to create cover letter(s).
                    	</td>
                   	</tr>
               	</table> --->
                </cfif>
          	<!--- </div>
        </td>
    </tr> --->
    
    <cfif clCnt lt 3>
        	<table width="100%" align="left">
            	<tr>
                	<td>
                        <div id="showCoverLetter" class="content" style="text-align:left; display:block;">
	        			<!--- <input type="button" class="exec_submit" name="hideMe" value="Create New Cover Letter" style="display:block; text-decoration:none;" onclick="javascript:showHide();"> --->
                        <div style="padding-bottom:12px;"></div>
                        <a href="##" name="hideMe" onclick="javascript:showHide();" role="button" class="btn btn-primary btn-small">Create New Cover Letter</a>
				        </div>
                    </td>
                </tr>
                
                <tr>
                	<td>
                		<table id="coverLetter" style="display:#iif((len(errTxt)),de('block'),de('none'))#;">
    					   	<tr>
                                <td><br /></td>
                            </tr>
                            
                            
                            <tr>
                      			<td class="standardBold" style="font-size:13px;">
					  				<label style="font-weight:bold"><!--- #checkValidation('<strong> --->* Cover Letter Name:</strong><!--- ',blnInValidCoverLetterName)# ---></label>
                              	</td>
                            </tr>
                            
                            <tr>
                      			<td>
                                	<input tabindex="17" type="text" name="title" value="#form.title#" maxlength="45" size="38"  class="exec_reg">
                              	</td>
                    		</tr>
                            
                            <tr>
                      			<td class="standardBold" style="font-size:13px; padding-top:12px;">
					  				<label style="font-weight:bold"><!--- #checkValidation('<strong> --->* Cover Letter:</strong><!--- ',blnInValidCoverLetterContent)# ---></label>
                              	</td>
                            </tr>
                            
                            <tr>
                      			<td>
                                	<textarea name="coverLetter" rows=15 cols=100 wrap="virtual" style="width:770px; max-width:770px; noresize:noresize;" tabindex="2" onClick="previewcl();" onChange="previewcl();" onKeyDown="previewcl();" class="exec_reg">#form.coverLetter#</textarea>
                              	</td>
                    		</tr>
                            
                            <tr>
                                <td width="" align="left">
									
                                    <div style="padding-bottom:10px;"></div>
                                    <a href="##" onclick="javascript:document.ExecCover.submit();" role="button" class="btn btn-primary btn-xs" >Save Changes</a>
                                </td>                    
                                <div id="body-content-div" style="display:none;"></div>
                            </tr>                	
	                  	</table>
                   
    </cfif>
    </form>
</table> 

<!--- </form> --->
</cfoutput>
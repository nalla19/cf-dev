<cfoutput>
<cfscript>
resObj = application.resume;
execObj = application.executive;

qresumes = resObj.getResumes();
resObj.setResumePath(session.exec.intresid);
//Files Uploaded Here
resumeDirectory = resObj.getResumeDir(session.exec.intresid);
resumePath = resObj.getResumePath(session.exec.intresid);
</cfscript>


<cfif (isdefined("form.fieldnames") and isdefined("form.updateResume"))>
	<!--- Reset the session variable for the changes on the My Account Page ---> 
	<cfif form.resSearchable eq "4">
		<cfset session.EXEC.blnSearchable = 0>
    <cfelse>
    	<cfset session.EXEC.blnSearchable = 1>
    </cfif>
	<cfset session.EXEC.intPostRecepient = form.resSearchable>
	
   
    <cfstoredproc procedure="spU_ExecResumeSearchable" datasource="#application.dsn#" returncode="Yes">
		<cfprocparam type="IN" dbvarname="@intresid" value="#session.exec.intresid#" cfsqltype="CF_SQL_INTEGER">
		<cfprocparam type="IN" dbvarname="@resumeid" value="#form.resumeid#" cfsqltype="CF_SQL_INTEGER">
		<cfprocparam type="IN" dbvarname="@resSearchable" value="#form.resSearchable#" cfsqltype="CF_SQL_INTEGER">
	</cfstoredproc>
	
	<!--- Check the status of the resume that has been activated has been set to private --->
	<cfif form.resSearchable is "4">
		
	<cfelse>
			
		<!--- Check to see if there is no a parsed resume for this resume --->
		<cfquery name="cfqCheckConsID" datasource="#application.dsn#">
		select consIntID from tblResumeProfiles (nolock) where fk_intresid = #session.exec.intresid# and blnactive = 1
		</cfquery>
		
		<cfif cfqCheckConsID.consIntID neq "">
			<cfset SovrenConsultantID=cfqCheckConsID.consIntID>
		<cfelse>
			<!--- Parse the resume --->
			<cfinclude template = "parseResume.cfm">
		</cfif>
		
		
	</cfif>
   
	<cfset url.confirm = "Your changes have been saved!">
	
<cfelseif (isdefined("form.fieldnames") and isdefined("form.uploadFile"))>
	
	<!--- File Length Is Not OK --->
	<!--- Size is Over 250,000 Bytes --->
	<cfif cgi.CONTENT_LENGTH gte 350000>
		<cfset url.confirm = "Uploaded file is too large. Please upload files smaller than 300KB.">
	<cfelse>
		<cfif NOT directoryExists(resumeDirectory)>
			<cfdirectory action="create" directory="#resumeDirectory#">
		</cfif>
	
		<!--- Uploaded File --->
		<cffile action="upload" destination="#resumeDirectory#" filefield="form.resumeFile" nameconflict="makeunique">
        
        
         <cfscript>		 
		 uploadedFile = resumeDirectory & cffile.serverFile;
         shortName = randrange(100,100000) & "." & cffile.clientFileExt;
         reNamedFile 	= resumeDirectory &  shortName;	
		 extList = "docx,doc,txt";
		 </cfscript>
		<cfif listFindNocase(extList,cffile.clientFileExt)>	
        
        <!--- Rename File --->	
        <cffile action="rename" destination="#reNamedFile#" source="#uploadedFile#"> 
        <cfset uploadedFile = reNamedFile />
        	
           	<!--- Parse It.  Insert It --->
           	<cfset parsedResume = execObj.parseResume(uploadedFile,1)/>
            <cfset void = resObj.insertResume('New Resume on #dateformat(now(),'mm/dd/yyyy')#',parsedResume,shortName) />
			<cfset session.EXEC.dteResumeEdited = DateFormat(Now(),"mmm dd, yyyy")>
           
		<cfelse>
           	<!--- Delete File --->
           	<cffile action="delete" file="#uploadedFile#">
			<!--- Not A Valid File Type --->
			<cfset url.confirm = "<li>Only Microsoft Word documents are supported &##40;e.g. - .doc, .docx&##41;.</li>">
		</cfif>					
	</cfif>
   
</cfif> 


<cfscript>
resObj = application.resume;
execObj = application.executive;

qresumes = resObj.getResumes();
resObj.setResumePath(session.exec.intresid);
//Files Uploaded Here
resumeDirectory = resObj.getResumeDir(session.exec.intresid);
resumePath = resObj.getResumePath(session.exec.intresid);
</cfscript>
<div id="save_changes_confirm" style="display:block; padding-top:6px; padding-bottom:6px; text-align:center">
<cfif isdefined("url.confirm")>
<span style="background-color:##d9edf7; font-size:16px; font-weight:bold; padding: 10px 15px 10px 15px; text-align:center">#url.confirm#</span>
</cfif>    
</div>

<!--- <div align="center" style="width:100%"> --->

	<!---Get the Honesty Online status for the candidate--->
    <cfparam name="honestyOnlineCredExists" default="false">
    <cfparam name="honestyOnlineCredStatus" default="">
    <cfscript>
	
    honestyOnlineObj = createObject('component', 'v16fj.execs.components.honestyOnline').init(
											dsn			= application.dsn,
											machine		= application.machine);
    honestyCredentials = honestyOnlineObj.get6FJHonestyOnlineCredential(session.exec.intResID);
    if (honestyCredentials.recordcount > 0){
        honestyOnlineCredExists = "true";
        honestyOnlineCredStatus = honestyCredentials.credentialStatus;
    }
    </cfscript>
    
    <!---Set up the tracking links--->
    <cfif application.machine EQ "DEV" OR application.machine EQ "LOCAL">
        <cfset signUpLinkId = "2200">
        <cfset credViewLinkId= "2201">
    <cfelseif application.machine EQ "UAT">
        <cfset signUpLinkId = "2200">
        <cfset credViewLinkId= "2201">
    <cfelse>
        <cfset signUpLinkId = "2200">
        <cfset credViewLinkId= "2201">
    </cfif>

<table width="100%" border="0" cellpadding="0" cellspacing="0">    
    <tr>
 		<td align="left">
        	<div class="row">
				<div class="span11">
				 <strong>You may upload and store up to 3 Word documents resumes.</strong><br />
                  <font color="##006600">Only one resume can be active at a time (this will be associated with your active profile)</font>.<br />          
                  
				</div>
			</div>
			 
			<!---Start the Honesty Online credential Verification---->
			<!---Credential Exists --->
			<cfif honestyOnlineCredExists>
				<!---Display the batch accordingly--->                           
				<cfif honestyOnlineCredStatus eq "ACTIVE">
				   <div class="row">
						<div class="span11">
						<img src="/images/HonestyOnline/verified-badge-114x30.gif" border="0" />
						<br />
						<a href="/click.cfm?#application.STRAPPADDTOKEN#&l=#credViewLinkId#" target="_blank" style="font-size:12px;">View Your Credential Report</a>
						</div>
				   </div>
				<cfelseif honestyOnlineCredStatus eq "PENDING">
					<div class="row">
						<div class="span11">
						<img src="/images/HonestyOnline/in-process-badge-114x30.gif" border="0" />
						<br />                            
						<span style="font-size:12px;">Currently in Process</span>
						</div>
				   </div>
				</cfif>	
			</cfif>
			<!---End the Honesty Online credential Verification---->
               
        </td>
 	</tr>

    <cfif qresumes.recordcount lt 3>
	<tr valign="top">
		<td class="greenline2">&nbsp;</td>
   	</tr>
    
    <tr>
		<td align="left">
			<!-- Start Premium Membership -->
			
			<script language="JavaScript">
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
						document.getElementById('uploadButton').className="btn btn-primary";
						document.getElementById('uploadButton').disabled=false;						
						document.getElementById('resumeFileText').className="";								
					}
					else{
						disableFields();
					}
				}
			</script>
			<div class="row" id="new_opened" style="display:visible;">
			<div class="span11">
			
				<form action="/member-resume" enctype="multipart/form-data" name="uploadform" method="POST" onSubmit="document.body.style.cursor='wait';" class="form-inline">
				<input type="hidden" name="uploadFile" value="1" />
           
					<div class="row-fluid" >
					
						<div class="span10">
							<font color="##303030"><b>Attach Resume</b></font>&nbsp;&nbsp;<input  name="resumeFile" id="resumeFile" type="file" class="span5" value="" onChange="allowSubmit();">
						<!--- </div>
						<div class="span4" id="upload"> --->
							<input class="btn btn-default" disabled="disabled" disabled="disabled" type="submit" name="uploadButton" id="uploadButton" value="Upload Resume">
						</div>
					</div>
					<div class="page-spacer"></div>
					<div class="row">
						<div class="span11">
							<strong>Please:</strong> Upload Microsoft Word&reg documents of up to 300 KB only.
						</div>
					</div>
											 
				
				</form>
				</div>
			</div>
		</td>
	</tr>
	</cfif>


    
    <tr>
    	<td colspan="7" width="100%">
        	<form action="/member-resume?#application.STRAPPADDTOKEN#" id="resumeManager" name="resumeManager" method="post">
            <input type="hidden" name="resSearchable" value="#qresumes.intPostRecepient#" />
            <input type="hidden" name="updateResume" value="1" />
            
			<script language="JavaScript">
				// JavaScript Document
				function showPrivacy(resid){
					//Show the text to the Executive to Save the Changes
					document.getElementById('save_changes_alert').style.display = 'block';
					
					//Hide the text which says Changes Saved
					document.getElementById('save_changes_confirm').style.display = 'none';
					
					if (document.getElementById) { // DOM3 = IE5, NS6
						document.getElementById(resid).style.display = 'block';
					}else {
						if (document.layers) { // Netscape 4
							document.getElementById(resid).style.display = 'block';
						}else { // IE 4
							document.getElementById(resid).style.display = 'block';
						}
					}
					getAllElements(resid);
				}
				
				function getAllElements(resid){
					for(i=0; i<document.resumeManager.elements.length; i++){
						var elementName = document.resumeManager.elements[i].name;
						var elementValue = document.resumeManager.elements[i].value;
						var elementLength = elementName.length
						var element1 = elementName.substring(0, 10);
						var resumeid = elementName.substring(10,elementLength);
						if (element1 == "activeRes_"){
							var divid = 'res' + resumeid;
							//if (elementValue == 0){
								if (divid != resid){
									hidePrivacy(divid);
								}
							//}
						}	
					}
				}
				
				function hidePrivacy(resid){
					if (document.getElementById) { // DOM3 = IE5, NS6
						document.getElementById(resid).style.display = 'none';
					}else {
						if (document.layers) { // Netscape 4
							document.getElementById(resid).style.display = 'none';
						}else { // IE 4
							document.getElementById(resid).style.display = 'none';
						}
					}
				} 
				
				function setPrivacyOption(resSearch){
					//Show the text to the Executive to Save the Changes
					document.getElementById('save_changes_alert').style.display = 'block';
					
					//Hide the text which says Changes Saved
					document.getElementById('save_changes_confirm').style.display = 'none';
					
					if (document.getElementById) { // DOM3 = IE5, NS6
						var x=document.getElementById(resSearch);
						document.resumeManager.resSearchable.value = x.options[x.selectedIndex].value;
					}else{
						if (document.layers) { // Netscape 4
							var x=document.getElementById(resSearch);
							document.resumeManager.resSearchable.value = x.options[x.selectedIndex].value;
						}else { // IE 4
							var x=document.getElementById(resSearch);
							document.resumeManager.resSearchable.value = x.options[x.selectedIndex].value;
						}
					}
				}
				
				
			
			</script>
           <table class="table table-striped">
		   	<tr>
				<th class="span1">Active</th>
				<!--- <th>Privacy Settings</th> --->
				<th class="span4">Resume</th>
				<!--- <th>Edited</th> --->
				<th class="span5">Actions</th>
			</tr>
			<tr>
			 <cfloop query="qresumes">
			
            	<td>
				<input type="hidden" name="activeRes_#resumeid#" value="#iif((isboolean(blnactive) and blnactive),de(1),de(0))#" />
         
                	<div id="Resume_Active">
                    	<label><input #iif((isboolean(blnactive) and blnactive),de('checked'),de(''))#  name="resumeid" type="radio" id="resumeid" value="#resumeid#" onClick="javascript:showPrivacy('res#resumeid#', #iif((isboolean(blnactive) and blnactive),de(1),de(0))#)"></label>
                    </div>
                 </td>
				
				 <td>       
                    <div id="Resume_Title">
                    	<cfset resTitle = #left(title, 30)#>
                    	<a href="/member-resume-preview?#application.STRAPPADDTOKEN#&resumeid=#resumeid#">#resTitle#</a>...
                   	</div>  
					<div>
					(Last Edited: #dateEdited#)
					</div>
					 <div id="Resume_Privacy">
                    	<div id="res#resumeid#" style="display:#iif((isboolean(blnactive) and blnactive),de('visible'),de('none'))#">
					 <select class="input-medium" name="resSearchable_#resumeid#" tabindex="7" id="resSearchable_#resumeid#" onChange="javascript:setPrivacyOption('resSearchable_#resumeid#')">
                     
							<option value="1" <cfif intPostRecepient neq "4">selected</cfif>>Searchable</option>
							<option value="4" <cfif intPostRecepient eq "4">selected</cfif>>Private</option>
							
                        </select>  
						</div> 
						</div>   
                 </td>
				
				  <td> 
                  
								<div class="form-inline">
								<a href="/member-resume-edit?#application.STRAPPADDTOKEN#&resumeid=#resumeid#" role="button" class="btn btn-primary btn-xs" title="Edit"><i class="icon-edit icon-white"></i></a>
								&nbsp;
								
								<a href="/member-resume-preview?#application.STRAPPADDTOKEN#&resumeid=#resumeid#" role="button" class="btn btn-primary btn-xs" title="Preview"><i class="icon-eye-open icon-white"></i></a>
								&nbsp;
								
                                    <cfif not (blnactive)>
                                        <a href="/member-resume-delete?#application.STRAPPADDTOKEN#&resumeid=#resumeid#" role="button" class="btn btn-primary btn-xs" Title="Delete"><i class="icon-trash icon-white"></i></a>
                                    	&nbsp;
									<cfelse>
                                        <a href="##" role="button" class="btn btn-default btn-xs disabled"  Title="Delete"><i class="icon-trash icon-gray"></i></a>
                                    	&nbsp;
									</cfif>
                            
                                    <cfif len(resumeFile) and fileExists(resumeDirectory & resumeFile)>
                                    <a href="/member-resume-download?#application.STRAPPADDTOKEN#&resumeid=#resumeid#"  role="button" class="btn btn-primary btn-xs"  Title="Download"><i class="icon-download icon-white"></i><!--- <img border="0" src="/img/word.gif" align="absmiddle"> ---></a>
                                    &nbsp;
									<cfelse>
									<a href="##" role="button" class="btn btn-default btn-xs disabled"  Title="Download"><i class="icon-download icon-gray"></i></a>
									&nbsp;
									</cfif>
                            
						</div>
				</td> 
               
				</tr>
				</cfloop>
		   </table>
	                  
          	</div>
            
           	<table>
                <tr>
                	<td colspan="10" align="left">
                    	<br />
                        
                        <div id="save_changes_alert" style="display:none;">
		  				<span style="color:##FF0000; font-size:14px">Please be sure to save your changes!</span>
						<br>
                        <a href="##" name="button" id="button" onclick="javascript:document.resumeManager.submit();"><input tabindex="32" class="btn btn-primary btn-large" type="button" name="validate" id="submitBtn" value="SAVE CHANGES"></a>
                       
                        </div>
                    </td>
      			</tr>
        	</table>        
            </form>
        </td>
   	</tr>
</table>
</cfoutput>

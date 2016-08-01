<!---ISR <link href="/join/assets/css/bootstrap.css" rel="stylesheet">
<link href="/join/assets/css/bootstrap-responsive.css" rel="stylesheet">
<cfinclude template="/6fj/_includes/templates/headers/preHeaderSetup.cfm"> --->

<!---ExecEditProfileVariables.cfm--->
<cfparam name="blnSearchable" default="">
<cfparam name="intPrivacySetting" default="">


<cfscript>
//Get the decrypted intResID
registrationObj = createObject('component', 'v16fj.join.components.registration').init(dsn = application.dsn);
resDetails = registrationObj.getResDetails(session.exec.intResID);
</cfscript>
    
<!---Parsing variables--->
<cfparam name="url.message" default="" />
<cfscript>
// Assume Parsing Is OK --->
inValidParse = 1;
//uploadedPath = application.sixfj.paths.webroot & "exports\";
uploadedPath = "C:\webroot\6figurejobs\exports\";
</cfscript>

<!---Create the resume upload directory if it does not exist already--->
<cfif not(directoryExists(uploadedPath))>
    <cfdirectory directory="#uploadedPath#" action="create" />
</cfif>

<!------------------------------------------------------------------------------------------------------------------------------------------------------->
<cfif len(session.exec.intResID)>
    <cfquery name="cfqGetResDetails" datasource="#application.dsn#">
    select * from tblResumes (nolock) where intResID = #session.exec.intResID#
    </cfquery>
    
    
	<cfset blnSearchable = cfqGetResDetails.blnSearchable>
    <cfset intPrivacySetting = cfqGetResDetails.intPostRecepient>    
</cfif>
<!------------------------------------------------------------------------------------------------------------------------------------------------------->


<cfoutput>
<!--- (if logged in and a "new" member)  OR (a 6FigureOnTrack Member awaiting reapproval) --->
<cfif not isdefined("session.exec.intResAdmcode")>
	<cflocation url="/index.cfm" addtoken="no">
<cfelseif (session.exec.intResAdmCode eq 2) OR (session.exec.intResAdmCode eq 4) AND (session.exec.intResStatusCode eq 2)>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr><td><!---ISR <cfinclude template="/6fj/t_PagePasswordText.cfm"> ---></td></tr>
    </table>
<cfelse>	    
	<cfif isDefined("form.fieldnames")>
	    <!---ISR <cfinclude template="ExecEditProfileSave.cfm"> --->
		<cfif form.intPrivacySetting eq 4>
			<cfset blnSearchable = 0>
			<cfset session.EXEC.blnSearchable = 0>
		<cfelse>
			<cfset blnSearchable = 1>
			<cfset session.EXEC.blnSearchable = 1>
		</cfif>
		
		<cfset intPostRecepient = form.intPrivacySetting>
		
		<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
			update tblResumes set
						blnSearchable= #blnSearchable#,
						intPostRecepient=#intPostRecepient#
			where intResid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<!---If the resume has been marked private, delete the resume from the Solr Index--->
		<cfif not(blnSearchable)>
			
			<!---01/09/2013
			<cfscript>
			solr =  createObject("component","/com/solr/SolColdfusion");
			solr.init(application.SOLRResumeServer, application.SOLRresumeServerPort,"/solr/candidates");
			result = XmlParse(solr.deleteById(session.exec.intresid));
			commit = XmlParse(solr.commit());
			</cfscript>
			--->
			
		<!---Else add the resume to the Solr Index--->
		<cfelse>
			<cfquery name="cfqGetResumes" datasource="#application.dsn#">
				select res.intresid, res.dteSubmitted, res.dteEdited, res.email, res.resume, res.resumeFile, prof.pk_managerid, prof.consIntID
				from tblResumes res (nolock)
					inner join tblresumeprofiles prof (nolock) on prof.fk_intresid = res.intResID
				where 1=1
				and prof.blnactive = 1
				and prof.fk_intresid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
			</cfquery>
		
			<cfset intResID = cfqGetResumes.intresID>
			<cfset dteCreated = cfqGetResumes.dteSubmitted>
			<cfset dteEdited = cfqGetResumes.dteEdited>
			<cfset resume =  cfqGetResumes.resume>
			<cfset resumeFile = cfqGetResumes.resumeFile>
			<cfset email = cfqGetResumes.email>
			<cfset pkManagerID = cfqGetResumes.pk_managerid>
			<cfset SovrenConsultantID = cfqGetResumes.consIntID>
		
			<!---If there is no parsed resume for this record, parse the resume--->
			<cfif not len(SovrenConsultantID)>
			
				<cfset currClientID = session.exec.intresid>
				<cfinclude template = "../resume/parseResume.cfm">
			</cfif>
			
			
			<!--- 01/09/2013
			<cfinclude template="AddResumeSolrIndex.cfm">
			--->
		</cfif>
		
		
       <div class="page-companies">
			<article class="section companies well">
				<div class="container">
                        <h1>Manage Privacy Setting </h1>
                        
                        <div class="alert alert-info" id="successMessage">
                        Your changes are saved successfully, please go back to the <a href="/member-dashboard">Dashboard</a>.
                        </div>
						<div class="page-spacer"><!--//--></div>
						<div class="page-spacer"><!--//--></div>
						<div class="page-spacer"><!--//--></div>
					
               	</div>
           	</article>
       	</div>
   	<cfelse>
    	<!---ISR <cfinclude template="ExecEditProfileVars.cfm"> --->
        <cfoutput>
        <form name="ExecProfile" id="ExecProfile" method="post" enctype="multipart/form-data" action="/member-privacy" onSubmit="return checkform2();">
        	<div class="page-companies">

				<article class="section companies well">
					<div class="container">
			
						<h1 class="page-title">Manage Privacy Settings</h1>
           
						<div class="row">
							
							<div class="span10">
								
								<div class="alert alert-error" id="errorDiv" style="max-width:600px;color:##F00; display:none;">
								<strong>Warning!</strong> Please complete the fields below highlighted in red.</div>
								<br>
								
								
								<a name="privacy" id="privacy"></a>          
								<!--- PRIVACY SETTING --->
								<!--- <div class="regsubheader"><h2>Privacy Setting</h2></div> --->
								<div class="row">
									<div class="span12 ">
										<div class="controls form-inline">
											<span id="intPrivacySettingErrTxt"><strong>Make My Profile &amp; Resume:</strong></span>&nbsp;&nbsp;
											<select tabindex="13" name="intPrivacySetting" id="intPrivacySetting" onFocus="this.style.borderColor = '';" onBlur="if(this.selectedIndex==0){this.style.borderColor= '##F00';}" style="width:auto;">
											<option value="">Choose one:</option>
											<option value="1" <cfif intPrivacySetting neq "4">selected</cfif>>Searchable</option>
									<option value="4" <cfif intPrivacySetting eq "4">selected</cfif>>Private</option>
											<!--- <option value="1" <cfif intPrivacySetting eq 1>selected</cfif>>Searchable by Employers & Recruiters</option>
											<option value="2" <cfif intPrivacySetting eq 2>selected</cfif>>Searchable by Employers Only</option>
											<option value="3" <cfif intPrivacySetting eq 3>selected</cfif>>Searchable by Recruiters Only</option>
											<option value="4" <cfif intPrivacySetting eq 4>selected</cfif>>Private to Employers & Recruiters</option> --->
											</select>
												&nbsp;&nbsp;&nbsp;&nbsp;
											<input tabindex="32" class="btn btn-primary btn-small" type="submit" name="validate" id="submitBtn" value="Save &amp; Continue" onclick="return checkform2();">
										</div>
									</div>
								</div>
								<div class="page-spacer"><!--//--></div>
								
								<!--- <div class="row">
									<div class="span5 pull-right">
									<input tabindex="32" class="btn btn-primary btn-small" type="submit" name="validate" id="submitBtn" value="SAVE &amp; CONTINUE" onclick="return checkform2();">
									</div>
								</div> --->
								<div class="page-spacer"><!--//--></div>
								<div class="page-spacer"><!--//--></div>
								<div class="page-spacer"><!--//--></div>
								
							</div>
						</div> <!-- /row -->
					</div> <!-- /container -->
				</article>
            </div> <!-- //Wrapper -->
       	
        </form>
        <div class="page-spacer"><!--//--></div>
        
        <!---For Valdidation---->
		<script type="text/javascript">
		var emailExistsErrTxt = '';

		function checkform2(){
			var errormsg = '';
			var errNum=0;
				
			//Privacy Setting
			if (document.ExecProfile.intPrivacySetting.value == ''){
				
				document.getElementById('intPrivacySetting').style.borderColor = '##F00';
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
				$("##submitBtn").attr("disabled", "disabled");
				document.getElementById('errorDiv').style.display = "none";
				document.ExecProfile.submit();
			}
			
		}
		</script>
		<!---ISR<cfif application.applicationname EQ "6FigureJobs">
            <script src="#request.url#/professional/privacy/js/editProfileValidation.js"></script> 
        <cfelseif application.applicationname EQ "SalesStars">
            <script src="#request.url#/professional/privacy/js/editProfileValidationSS.js"></script> 
        </cfif>       
             
        <script src="#request.url#/join/assets/js/jquery.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-transition.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-alert.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-modal.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-dropdown.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-scrollspy.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-tab.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-tooltip.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-popover.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-button.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-collapse.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-carousel.js"></script>
        <script src="#request.url#/join/assets/js/bootstrap-typeahead.js"></script>
        <script src="#request.url#/join/assets/js/jquery.placeholder.js"></script>
         
        <script src="#request.url#/js/facebox/facebox.js" type="text/javascript"></script>
         
        <script type="text/javascript" src="#request.url#/js/ajax-dynamic-content.js"></script>
        <script type="text/javascript" src="#request.url#/js/ajax.js"></script>
        <script type="text/javascript" src="#request.url#/js/ajax-tooltip.js"></script>       
        
        
        <script type="text/javascript">
        jQuery(document).ready(function($) {
            //For the BasicPlan popup
            $('a[rel*=facebox]').facebox() 
        })
        
        $('##myModal').modal('hide');
        
        // To test the @id toggling on password inputs in browsers that don’t support changing an input’s @type dynamically (e.g. Firefox 3.6 or IE), uncomment this:
        // $.fn.hide = function() { return this; }
        // Then uncomment the last rule in the <style> element (in the <head>).
        $(function() {
            // Invoke the plugin
            $('input, textarea').placeholder();
        });
        </script> --->
        
        
        
       
        
       
        
        
       
        </cfoutput>
    </cfif>
</cfif>
</cfoutput>
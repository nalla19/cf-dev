<!---ISR <link href="/join/assets/css/bootstrap.css" rel="stylesheet">
<link href="/join/assets/css/bootstrap-responsive.css" rel="stylesheet">
<cfinclude template="/6fj/_includes/templates/headers/preHeaderSetup.cfm"> --->

<!---ExecEditProfileVariables.cfm--->
<cfparam name="blnSearchable" default="">
<cfparam name="intPrivacySetting" default="">
<cfparam name="errorDivDisplay" default="">

<cfscript>
//Get the decrypted intResID
registrationObj = createObject('component', 'v16fj.join.components.registration').init(dsn = application.dsn);
resDetails = registrationObj.cfqGetFullResDetails(session.exec.intResID);
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

<cfoutput>
<!--- (if logged in and a "new" member)  OR (a 6FigureOnTrack Member awaiting reapproval) --->
<cfif not isdefined("session.exec.intResAdmcode")>
	<cflocation url="/index.cfm" addtoken="no">
<cfelseif (session.exec.intResAdmCode eq 2) OR (session.exec.intResAdmCode eq 4) AND (session.exec.intResStatusCode eq 2)>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr><td><!--- ---></td></tr>
    </table>
<cfelse>	    
	<cfif isDefined("form.fieldnames")>
		<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
		update tblResumes set
		  	   password= '#form.newpasswd#'
		 where intResid = <cfqueryparam value="#session.exec.intResID#" cfsqltype="cf_sql_integer" />
		</cfquery>
				
		<div class="page-companies">
			<article class="section companies well">
				<div class="container">
                        <h1>Manage Password</h1>
                        
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
        <form name="ExecProfile" id="ExecProfile" method="post" enctype="multipart/form-data" action="/change-password" onSubmit="return checkform2();">
        	<div class="page-companies">

				<article class="section companies well">
					<div class="container">
			
						<h1 class="page-title">Manage Password</h1>
           
						<div class="row">
							
							<div class="span10">
							
								<!---
								<div class="alert alert-error" id="errorDiv" style="max-width:600px;color:##F00; display:none;">
								<strong>Warning!</strong> Please complete the fields below highlighted in red.
								</div>
							
								<br>
								<div class="alert alert-error" id="errorDiv1" style="max-width:600px;color:##F00; display:none;">
								<strong>Warning!</strong> Password do not match</div>
								<br>
								---->
								
								<div class="alert alert-error" id="errorDiv" style="max-width:600px;color:##F00; display:none;">
									<strong>Warning!</strong> Please complete the fields below highlighted in red.
									<br>
									<span id="errorDiv1" style="max-width:600px;color:##F00; display:none;">
									Password do not match
									</span>
								</div>
								<br>
								
								<a name="privacy" id="privacy"></a>          
								<!--- PASSWORD SETTING --->
								<div class="row">
									<div class="span12">
										<div class="controls form-inline">
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="intPasswordErrTxt"><strong>New Password</strong></span>&nbsp;&nbsp;
											<input type="password" name="newpasswd" id="newpasswd" value="">
										</div>
									</div>
								</div>
								
								<br>
								
								<div class="row">
									<div class="span12">
										<div class="controls form-inline">
											<span id="intpasswordconfirmErrTxt"><strong>Confirm Password</strong></span>&nbsp;&nbsp;
											<input type="password" name="newpasswdconfirm" id="newpasswdconfirm" value="">
										</div>
									</div>
								</div>
								
								<br>
								
								<div class="row">
									<div class="span12">
										<input tabindex="32" class="btn btn-primary btn-small" type="submit" name="validate" id="submitBtn" value="Save &amp; Continue" onclick="return checkform2();">
									</div>
								</div>

								
								<div class="page-spacer"><!--//--></div>
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
				
			//New Password
			if (document.ExecProfile.newpasswd.value == ''){
				document.getElementById('newpasswd').style.borderColor = '##F00';
				errNum+=1;
			}else{
				document.getElementById('newpasswd').style.borderColor = '';
			}
			
			//New Password Confirm
			if (document.ExecProfile.newpasswdconfirm.value == ''){
				document.getElementById('newpasswdconfirm').style.borderColor = '##F00';
				errNum+=1;
			}else{
				document.getElementById('newpasswdconfirm').style.borderColor = '';
			}
			
			//Password Setting
			if (document.ExecProfile.newpasswd.value != '' && document.ExecProfile.newpasswdconfirm.value != ''){
				if (document.ExecProfile.newpasswd.value != document.ExecProfile.newpasswdconfirm.value ){
					errNum+=1;
	
					document.getElementById('submitBtn').style.visibility = "visible";
					
					document.getElementById('newpasswd').style.borderColor = '##F00';
					document.getElementById('newpasswdconfirm').style.borderColor = '##F00';
					
					document.getElementById('errorDiv').style.display = "block";
					document.getElementById('errorDiv1').style.display = "block";
					//Scroll to the top		
					$("html, body").animate({ scrollTop: 0 }, "fast");
					return false ;	
				}
			}
		
			//Errors
			if (errNum > 0){
				document.getElementById('submitBtn').style.visibility = "visible";
				document.getElementById('errorDiv').style.display = "block";
				document.getElementById('errorDiv1').style.display = "none";
				//Scroll to the top		
				$("html, body").animate({ scrollTop: 0 }, "fast");
				return false ;
			}else{
				$("##submitBtn").attr("disabled", "disabled");
				document.getElementById('errorDiv').style.display = "none";
				document.getElementById('errorDiv1').style.display = "none";
				document.ExecProfile.submit();
			}
		}
		</script>
		       
       
    </cfif>
</cfif>
</cfoutput>
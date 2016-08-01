<cfparam name="blnSendEmail" default="0">
<cfparam name="email" default="">
<cfparam name="blnSentEmail" default="0">
<cfparam name="blnDelete" default="0">
<cfparam name="blnPassChecks" default="1">

<cfoutput>
<cfif blnSendEmail neq 0>

	<cfset blnPassChecks = request.blnPassChecks />

  	<!--- check all the fields --->
  	<cfif len(trim(email)) eq 0>
    	<cfset blnPassChecks = 0 />
	</cfif>

	<!--- Validate the captcha --->
	<cfif NOT isDefined('session.captcha') OR request.captcha NEQ session.captcha>
		<cfset blnPassChecks = 0 />
	</cfif>


	<cfsavecontent variable="emailMessage">
        <table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
            <tr>
                <!-- MASTHEAD BEGIN -->
                 <td width="450">
					<a href="#cgi.HTTP_HOST#">
						<img src="#cgi.HTTP_HOST#/images/six-figure-jobs-logo-092012.png" border="0" alt="#application.sourceApp#"><br><br>
					</a>
                </td>
                <td width="200"></td>
                <!--- MASTHEAD END --->
            </tr>
        </table>
        
        <table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
            <tr>
                <td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">
        
                <!-- COMMUNICATION MESSAGE BEGIN -->
                <span style="font-size:18px; color:##9f58a2; font-weight:bold;">Here is the  password retrieval that was requested for your account.</span><br>
                <br>
                <strong>Username:</strong> #request.username#<br>
                <strong>Password:</strong> #request.password#<br><br>
                We recommend that you log into your account and change your password.<br><br>
        
                #application.sourceApp# Support<br><br>
                
        
                <!-- COMMUNICATION MESSAGE END -->
                </td>
          </tr>
        </table>
        
        <br>
        
        <table width="650" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
					&copy; #application.thisYear# 6FigureJobs.com | <a href="http://#cgi.HTTP_HOST#/6FigureJobs_PrivacyStatement.cfm">Privacy</a> | <a href="http://#cgi.HTTP_HOST#/6FigureJobs_TOS.cfm">Terms of Use</a> | <a href="http://#cgi.HTTP_HOST#/6FigureJobs_ContactUs.cfm">Contact</a> | <a href="http://#cgi.HTTP_HOST#/sitemap.cfm">Site Map</a>
					<br />
					6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
					<br /><br>
					You are receiving this email because there was a request for password retrieval for your 6FigureJobs account.
					<br /><br />
                </td>
            </tr>
        </table>	
	</cfsavecontent>
	
	<cfif blnPassChecks neq 0>
		<cftry>
			
			<cfset blnSentEmail = 1 />
	        
			<cfset application.emailManager.candForgotPassword(emailTo=request.email, emailSubject="#application.sourceApp# Password Retrieval", emailBody=emailMessage)>
    		        
            <cfcatch type="any">
            	
            </cfcatch>
		</cftry>
	</cfif>

</cfif>

<div class="page-about">

	<div class="section">
		<div class="container">

			<header class="page-about">
				<div class="container">
					<h1 class="page-title">Retrieve Password</h1>
				</div>
			</header>

			<div class="row">

				<div class="span12">
					
					<form action="recruiter-password" method="post" class="form form-horizontal" id="passwordFrm">
						<input type="hidden" name="blnSendEmail" value="1">

						<cfif blnPassChecks EQ 0 and request.recruiterInactive is 0>
							<div class="alert alert-error">
								Please make sure all information below is correct. Then resubmit.
							</div>
						</cfif>
                        
                        
						<cfif blnSentEmail NEQ 1>
                        
                            <div class="control-group">
								To receive your login information, please enter the account Email address with which you registered.
							</div>
                            
							<div class="control-group">
								<label class="control-label">Email Address</label>
								<div class="controls">
									<input type="email" name="email" value="#email#" size="35" class="requiredField">
								</div>
							</div>

							<div class="control-group">
								<label class="control-label">Enter Text Below</label>

								<div class="controls">
									<input type="text" name="captcha" class="input-small requiredField"><br>
									<div id="captchaDiv" style="margin-top:4px;"></div>
									Can't read? <a href="##" id="reloadCaptchaLnk">Reload</a>
								</div>
							</div>

							<div class="text-center">
								<input type="submit" class="btn btn-primary" value="Retrieve Password">
							</div>
						<cfelse>
                        
                        	<cfif request.recruiterInactive is 1>
								<div class="alert alert-error">
									Your request has been submitted. Your password will be emailed to you shortly.<br />
                                    Based on the Email address you provided, our records indicate that this account is inactive.
								</div>
                            <cfelse>
								<div class="alert alert-info">
									Your request has been submitted. Your password will be emailed to you shortly.
								</div>						
							</cfif>
	
						</cfif>

					</form>

				</div>

			</div>

		</div>

	</div>

</div>
</cfoutput>
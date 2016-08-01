<cfparam name="step" default="1">
<cfparam name="blnPass" default="1">
<cfparam name="MailSent" default="">
<cfparam name="ToEmail" default="">
<cfparam name="error" default="">
<cfparam name="form.department" default="">
<cfparam name="form.fname" default="">
<cfparam name="form.lname" default="">
<cfparam name="form.email" default="">
<cfparam name="form.phone" default="">
<cfparam name="form.operating" default="">
<cfparam name="form.browser" default="">
<cfparam name="form.ISP" default="">
<cfparam name="form.firewall" default="">
<cfparam name="form.subject" default="">
<cfparam name="form.comments" default="">


<cfif isdefined('url.dept')>
	<cfset form.department="#url.dept#" />
</cfif>


<cfif NOT isdefined('url.blnform')>

	<cfif step GT 1>


		<cfswitch expression="#form.department#">
			<cfcase value="1">
				<cfset Department="General Information" />
				<cfif step EQ "3">
					<cfset ToEmail="communitymanager@#application.sourceApp#.com" />
				</cfif>
			</cfcase>

			<cfcase value="2">
				<cfset Department="Employer and Recruiter Sales" />
				<cfif step EQ "3">
					<cfset ToEmail="sales@#application.sourceApp#.com" />
				</cfif>
			</cfcase>

			<cfcase value="3">
				<cfset Department="Advertising" />
				<cfif step EQ "3">
					<cfset ToEmail="advertising@#application.sourceApp#.com" />
				</cfif>
			</cfcase>

			<cfcase value="4">
				<cfset Department="Technical Support" />
				<cfif step EQ "3">
					<cfset ToEmail="support@#application.sourceApp#.com" />
				</cfif>
			</cfcase>

			<cfcase value="5">
				<cfset Department="Public/Investor Relations" />
				<cfif step EQ "3">
					<cfset ToEmail="paul.dinardo@#application.sourceApp#.com" />
				</cfif>
			</cfcase>

			<cfcase value="6">
				<cfset Department="Events/Workshops" />
				<cfif step EQ "3">
					<cfset ToEmail="advertising@#application.sourceApp#.com" />
				</cfif>
			</cfcase>

			<cfcase value="7">
				<cfset Department="#application.sourceApp# Networking" />
				<cfif step EQ "3">
					<cfset ToEmail="communitymanager@#application.sourceApp#.com" />
				</cfif>
			</cfcase>

			<cfdefaultcase><cfset Department="" /></cfdefaultcase>
		</cfswitch>


		<!--- Validate Form --->
		<cfif trim(form.department) EQ "">
			<cfset blnPass = "0" />
			<cfset error = ListAppend(Error,"department",",") />
		</cfif>


		<cfif step EQ "3">
			
			<!---Validate the captcha--->
			<cfif NOT isDefined('session.captcha') OR request.captcha NEQ session.captcha>
				<cfset blnPass = "0" />
				<cfset error = ListAppend(Error,"captcha",",") />
			</cfif>
		
			<cfif trim(form.fname) NEQ "">
				<cfset FName=form.fname />
			<cfelse>
				<cfset blnPass = "0" />
				<cfset error = ListAppend(Error,"FName",",") />
			</cfif>
			<cfif trim(form.Lname) NEQ "">
				<cfset LName=form.Lname />
			<cfelse>
				<cfset blnPass = "0" />
				<cfset error = ListAppend(Error,"LName",",") />
			</cfif>
			<cfif trim(form.email) NEQ "">
				<cfset fromEmail=form.email />
			<cfelse>
				<cfset blnPass = "0" />
				<cfset error = ListAppend(Error,"EMail",",") />
			</cfif>
			<cfif form.department EQ "4">
				<cfif trim(form.operating) NEQ "">
					<cfset operating=form.operating />
				<cfelse>
					<cfset blnPass = "0" />
					<cfset error = ListAppend(Error,"Operating",",") />
				</cfif>
				<cfif trim(form.browser) NEQ "">
					<cfset browser=form.browser />
				<cfelse>
					<cfset blnPass = "0" />
					<cfset error = ListAppend(Error,"Browser",",") />
				</cfif>
				<cfif trim(form.ISP) NEQ "">
					<cfset ISP=form.ISP />
				<cfelse>
					<cfset blnPass = "0" />
					<cfset error = ListAppend(Error,"ISP",",") />
				</cfif>
				<cfif trim(form.firewall) NEQ "">
					<cfset firewall=form.firewall />
				<cfelse>
					<cfset blnPass = "0" />
					<cfset error = ListAppend(Error,"firewall",",") />
				</cfif>
			</cfif>
			<!--- Add default subject for dept 7 (networking)? --->
			<cfif trim(form.subject) NEQ "">
				<cfset subject=form.subject />
			<cfelse>
				<cfset blnPass = "0" />
				<cfset error = ListAppend(Error,"subject",",") />
			</cfif>
			<cfif trim(form.comments) NEQ "">
				<cfset comments=form.comments />
			<cfelse>
				<cfset blnPass = "0" />
				<cfset error = ListAppend(Error,"comments",",") />
			</cfif>
		</cfif>
	</cfif>
	<cfif blnPass NEQ "1">
		<CFSET STEP = STEP-1 />
	</cfif>
<cfelse>
	<cfset Department="General Inquiries" />
</cfif>



<div class="page-advertise">

	<div class="section">
		<div class="container">

			<header class="page-header">
				<div class="container">
					<h1 class="page-title">Contact Us</h1>
				</div>
			</header>

			<div class="well">
				<p>
					Before you contact us, please read these Frequently Asked Questions. We will answer your questions as soon as we can. We value your support and feedback. Thank you for your patience!
				</p>

				<cfoutput>
				<table class="table">
					<tr>
						<td>
							<img src="#application.v1URL#/images/CCR_<cfif NOT isDefined('gbl_blnExecSide') OR gbl_blnExecSide NEQ 0>ER</cfif>Step1.gif" width="24" height="24" border="0">
						</td>
						<td><strong>Choose a department you wish to contact</strong></td>
					</tr>
					<tr>
						<td>
							<img src="#application.v1URL#/images/CCR_<cfif NOT isDefined('gbl_blnExecSide') OR gbl_blnExecSide NEQ 0>ER</cfif>Step2.gif" width="24" height="24" border="0">
						</td>
						<td>
							<cfif step gte 2><b></cfif>Email us your concern<cfif step gte 2></b></cfif>
						</td>
					</tr>
				</table>
				</cfoutput>

			</div>

		</div>
	</div>


	<div class="section">

		<div class="container">

			<cfif step EQ 1>

				<div class="row">
					<div class="span6 well">
						<cfoutput>
						<form action="contact?#application.strAppAddToken#&step=2&am=150" method="post" name="StepOne" class="form form-horizontal">
		
							<div class="control-group <cfif ListContains(error,"department",",")>error</cfif>">
								<label class="control-label">Department To Contact:</label>
								<div class="controls">
									<select name="department" class="input-xlarge">
										<option value="" <cfif form.department EQ "">selected</cfif>>- Choose One -</option>
										<option value="1" <cfif form.department EQ "1">selected</cfif>>General Information</option>
										<option value="2" <cfif form.department EQ "2">selected</cfif>>Employer and Recruiter Sales</option>
										<option value="3" <cfif form.department EQ "3">selected</cfif>>Advertising</option>
										<option value="4" <cfif form.department EQ "4">selected</cfif>>Technical Support</option>
										<option value="5" <cfif form.department EQ "5">selected</cfif>>Public/Investor Relations</option>
										<option value="6" <cfif form.department EQ "6">selected</cfif>>Events/Workshops</option>
										<option value="7" <cfif form.department EQ "7">selected</cfif>>#application.sourceApp# Networking</option>
									</select>
								</div>
							</div>
		
							<input type="submit" value="Next" class="btn btn-primary btn-large pull-right">
							
						</form>
						</cfoutput>
					</div>
				</div>
				

			<cfelseif step EQ 2>


				<div class="row">
							
					<div class="span12">
					
						<div class="well clearfix">
						
						<cfoutput>
						<p>Before contacting our <strong>#Department#</strong> department, please visit our <a href="faq">Frequently Asked Questions page</a> to see if you have a common question.</p>
		
						<form action="#application.secureURL#/contact?#application.strAppAddToken#&step=3&am=150" method="post" name="StepTwo" id="contactUsFrm">
		
							<cfif error NEQ "">
								<div class="alert alert-error">
									Some of the required fields are missing from your submission.
									<br>
									Please correct the items marked in red below
								</div>
							</cfif>
		

		
							<div class="row">
							
								<div class="span5">
		
									<div class="control-group <cfif ListContains(error,"FName",",")>error</cfif>">
										<label class="control-label">First Name*</label>
		
										<div class="controls">
											<input type="hidden" name="department" value="#form.department#">
											<input type="text" name="FName" size="30" maxlength="50" value="#form.FName#" class="requiredField">
										</div>
									</div>
		
									<div class="control-group <cfif ListContains(error,"EMail",",")>error</cfif>">
										<label class="control-label">Email Address*</label>
		
										<div class="controls">
											<input type="email" name="Email" size="30" maxlength="50" value="#form.Email#" class="requiredField">
										</div>
									</div>
		
									<cfif isdefined('form.department') and form.department EQ "4">
		
										<div class="control-group <cfif ListContains(error,"Operating",",")>error</cfif>">
											<label class="control-label">Operating System</label>
		
											<div class="controls">
												<input type="text" name="Operating" size="30" maxlength="50" value="#form.Operating#">
											</div>
										</div>
		
										<div class="control-group <cfif ListContains(error,"Browser",",")>error</cfif>">
											<label class="control-label">Browser Name/Version*</label>
		
											<div class="controls">
												<input type="text" name="Browser" size="30" maxlength="50" value="#form.Browser#" class="requiredField">
											</div>
										</div>
		
									</cfif>
		
									<div class="control-group <cfif ListContains(error,"subject",",")>error</cfif>">
										<label class="control-label">Specific Request</label>
		
										<div class="controls">
											<select name="subject" class="requiredField">
												<!--- General Information and Tech Support (general#application.defaultEmail#) --->
												<cfif form.department EQ "1" or form.department EQ "4">
													<option value=""<cfif form.subject EQ "">selected</cfif>>- Choose One -</option>
													<option value="#Department# - Resume Add/Edit"<cfif form.subject EQ "#Department# - Resume Add/Edit">selected</cfif>>Resume Add/Edit</option>
													<option value="#Department# - Job Searches"<cfif form.subject EQ "#Department# - Job Searches">selected</cfif>>Job Searches</option>
													<option value="#Department# - Resume Manager"<cfif form.subject EQ "#Department# - Resume Manager">selected</cfif>>Resume Manager</option>
													<option value="#Department# - Username/Password"<cfif form.subject EQ "#Department# - Username/Password">selected</cfif>>Username/Password</option>
													<option value="#Department# - Job Applications"<cfif form.subject EQ "#Department# - Job Applications">selected</cfif>>Job Applications</option>
													<option value="#Department# - Login Problems"<cfif form.subject EQ "#Department# - Login Problems">selected</cfif>>Login Problems</option>
													<option value="#Department# - Activate/Deactivate Profile"<cfif form.subject EQ "#Department# - Activate/Deactivate Profile">selected</cfif>>Activate/Deactivate Profile</option>
													<option value="#Department# - Compensation Inquiries"<cfif form.subject EQ "#Department# - Compensation Inquiries">selected</cfif>>Compensation Inquiries</option>
													<option value="#Department# - Change Email Address"<cfif form.subject EQ "#Department# - Change Email Address">selected</cfif>>Change Email Address</option>
													<option value="#Department# - Connection Problems"<cfif form.subject EQ "#Department# - Connection Problems">selected</cfif>>Connection Problems</option>
													<option value="#Department# - Other"<cfif form.subject EQ "#Department# - Other">selected</cfif>>Other</option>
				
													<!--- Employer/Recruiter Sales (JobPosting@#application.sourceApp#.com) --->
												<cfelseif form.department EQ "2">
													<option value=""<cfif form.subject EQ "">selected</cfif>>- Choose One -</option>
													<option value="#Department# - User-License Limit Error"<cfif form.subject EQ "#Department# - User-License Limit Error">selected</cfif>>User-License Limit Error</option>
													<option value="#Department# - Re-Activation of your account"<cfif form.subject EQ "#Department# - Re-Activation of your account">selected</cfif>>Re-Activation of your account</option>
													<option value="#Department# - Need More Jobs"<cfif form.subject EQ "#Department# - Need More Jobs">selected</cfif>>Need More Jobs</option>
													<option value="#Department# - Need to re-activate archived job"<cfif form.subject EQ "#Department# - Need to re-activate archived job">selected</cfif>>Need to re-activate archived job</option>
													<option value="#Department# - Other"<cfif form.subject EQ "#Department# - Other">selected</cfif>>Other</option>
			
													<!--- Advertising Sales (adsales@#application.sourceApp#.com) --->
												<cfelseif form.department EQ "3">
													<option value=""<cfif form.subject EQ "">selected</cfif>>- Choose One -</option>
													<option value="#Department# - Media Kit"<cfif form.subject EQ "#Department# - Media Kit">selected</cfif>>Media Kit</option>
													<option value="#Department# - Lead Generation Program"<cfif form.subject EQ "#Department# - Lead Generation Program">selected</cfif>>Lead Generation Program</option>
													<option value="#Department# - Affiliate Program"<cfif form.subject EQ "#Department# - Affiliate Program">selected</cfif>>Affiliate Program</option>
													<option value="#Department# - Partnership Ideas"<cfif form.subject EQ "#Department# - Partnership Ideas">selected</cfif>>Partnership Ideas</option>
													<option value="#Department# - Other"<cfif form.subject EQ "#Department# - Other">selected</cfif>>Other</option>
												<cfelseif form.department EQ "6">
													<option value=""<cfif form.subject EQ "">selected</cfif>>- Choose One -</option>
													<option value="#Department# - Seminars/teleconferences/webinars"<cfif form.subject EQ "#Department# - Seminars/teleconferences/webinars">selected</cfif>>Seminars/teleconferences/webinars</option>
													<option value="#Department# - Personal Coaching request"<cfif form.subject EQ "#Department# - Personal Coaching request">selected</cfif>>Personal Coaching request</option>
													<option value="#Department# - Networking questions"<cfif form.subject EQ "#Department# - Networking questions">selected</cfif>>Networking questions</option>
													<option value="#Department# - Event Feedback"<cfif form.subject EQ "#Department# - Event Feedback">selected</cfif>>Event Feedback</option>
													<option value="#Department# - Other"<cfif form.subject EQ "#Department# - Other">selected</cfif>>Other</option>
													
													<!--- Networking --->
												<cfelseif form.department EQ "7">
													<option value=""<cfif form.subject EQ "">selected</cfif>>- Choose One -</option>
													<option value="#Department# - General Inquiries"<cfif form.subject EQ "#Department# - General Inquiries">selected</cfif>>General Inquiries</option>
													<option value="#Department# - Login Issues"<cfif form.subject EQ "#Department# - Login Issues">selected</cfif>>Login Issues</option>
													<option value="#Department# - Member-to-Member Connection Issues"<cfif form.subject EQ "#Department# - Member-to-Member Connection Issues">selected</cfif>>Member-to-Member Connection Issues</option>
													<option value="#Department# - Forum and Topic Issues"<cfif form.subject EQ "#Department# - Forum and Topic Issues">selected</cfif>>Forum and Topic Issues</option>
													<option value="#Department# - Profile Issues"<cfif form.subject EQ "#Department# - Profile Issues">selected</cfif>>Profile Issues</option>
													<option value="#Department# - Group Issues"<cfif form.subject EQ "#Department# - Group Issues">selected</cfif>>Group Issues</option>
													<option value="#Department# - Other"<cfif form.subject EQ "#Department# - Other">selected</cfif>>Other</option>
													
													<!--- Investor Relations (investorrelations#application.defaultEmail#) --->
												<cfelse>
													<option value=""<cfif form.subject EQ "">selected</cfif>>- Choose One -</option>
													<option value="#Department# - Request an Investor Kit"<cfif form.subject EQ "#Department# - Request an Investor Kit">selected</cfif>>Request an Investor Kit</option>
													<option value="#Department# - Earnings Release Questions<"<cfif form.subject EQ "#Department# - Earnings Release Questions<">selected</cfif>>Earnings Release Questions</option>
													<option value="#Department# - Stock Exchange"<cfif form.subject EQ "#Department# - Stock Exchange">selected</cfif>>Stock Exchange</option>
													<option value="#Department# - Shareholder Questions"<cfif form.subject EQ "#Department# - Shareholder Questions">selected</cfif>>Shareholder Questions</option>
													<option value="#Department# - Other"<cfif form.subject EQ "#Department# - Other">selected</cfif>>Other</option>
												</cfif>
											</select>
										</div>
									</div>
		
								</div>
		
								<div class="span5">
		
									<div class="control-group <cfif ListContains(error,"LName",",")>error</cfif>">
										<label class="control-label">Last Name*</label>
		
										<div class="controls">
											<input type="text" name="LName" size="30" maxlength="50" value="#form.LName#" class="requiredField">
										</div>
									</div>
		
									<div class="control-group <cfif ListContains(error,"phone",",")>error</cfif>">
										<label class="control-label">Phone Number</label>
		
										<div class="controls">
											<input type="text" name="Phone" size="30" maxlength="50" value="#form.Phone#">
										</div>
									</div>
		
									<cfif isdefined('form.department') and form.department EQ "4">
		
										<div class="control-group <cfif ListContains(error,"ISP",",")>error</cfif>">
											<label class="control-label">Internet Service Provider*</label>
		
											<div class="controls">
												<input type="text" name="ISP" size="30" maxlength="50" value="#form.ISP#" class="requiredField">
											</div>
										</div>
		
										<div class="control-group <cfif ListContains(error,"Browser",",")>error</cfif>">
											<label class="control-label">Do you use a personal firewall?*</label>
		
											<div class="controls">
												<label class="radio">
													<input type="radio" name="firewall" value="Yes"<cfif form.firewall EQ "Yes">checked</cfif>>
													Yes
												</label>
												<label class="radio">
													<input type="radio" name="firewall" value="No"<cfif form.firewall EQ "No">checked</cfif>>
													No
												</label>
											</div>
										</div>
									</cfif>
		
								</div>
								
							</div>
							
							<div class="row">
								
								<div class="span10">
									
									<div class="control-group <cfif ListContains(error,"comments",",")>error</cfif>">
										<label class="control-label">Comments*</label>
		
										<div class="controls">
											<textarea rows="10" name="comments" class="input-xxlarge requiredField">#form.comments#</textarea>
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
									
								</div>
								
							</div>
		
							
							<input type="submit" value="Submit" class="btn btn-primary btn-large pull-right">
		
						</form>
						</cfoutput>
						</div>
						
						<p>
							<a href="#application.url#/contact?#application.strAppAddToken#&step=3&blnform=0&am=150">Click here</a> if you would like to see our alternate contact information.
						</p>
					</div>
						
				</div>

			<cfelseif step EQ "3">

				<cfif not isdefined('url.blnForm')>

					<cfif ToEmail NEQ "" and Email NEQ "" and department NEQ "" and subject NEQ "" and comments NEQ "">

						<cfif form.department EQ "4">

							<cfmail to="#ToEmail#" from="#application.defaultEmail#" subject="#subject#" type="html">
								<!--- #ToEmail# --->
								<cfmailparam name="Reply-To" value="#Email#">
								<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
									<tr>
										<td width="350">
											<a href="#application.url#">
												<img src="#application.v1url#/images/six-figure-jobs-logo-092012.png" border="0" alt="#application.sourceApp#"><br><br>
											</a>
										</td>
										<td width="250" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333;">
											<strong>#subject#</strong>
										</td>
									</tr>
								</table>

								<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
									<tr>
										<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">
											<strong>**Any replies to this email will be sent to the #application.sourceApp#.com user's email address: #email#
											<br /><br />
											The following information has been submitted from the Contact Us section:
											</strong>
											<br><br>

											Customer Name: #FName# #LName# <br />
											Email Address: #Email# <br />
											Phone Number: #Phone# <br />
											******************************************************* <br />
											<strong>Technical Information<strong> <br />
											Operating System: #Operating# <br />
											Internet Service Provider: #ISP# <br />
											Personal Firewall: #Firewall# <br /><br /><br />
											#comments# 
										</td>
									</tr>
								</table>

								<br>

								<table width="650" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
											&copy; #application.thisYear# 6FigureJobs.com | <a href="#application.url#/6FigureJobs_PrivacyStatement.cfm">Privacy</a> | <a href="#application.url#/6FigureJobs_TOS.cfm">Terms of Use</a> | <a href="#application.url#/6FigureJobs_ContactUs.cfm">Contact</a> | <a href="#application.url#/sitemap.cfm">Site Map</a>
											<br />
											6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
											<br /><br>
										</td>
									</tr>
								</table>
							</cfmail>

						<cfelse>
							<cfmail to="#ToEmail#" from="#application.defaultEmail#" subject="#subject#" type="html">
								<!--- #ToEmail# --->
								<cfmailparam name="Reply-To" value="#Email#">
								<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
									<tr>
										<td width="350">
											<a href="#application.url#">
												<img src="#application.v1URL#/images/six-figure-jobs-logo-092012.png" border="0" alt="#application.sourceApp#"><br><br>
											</a>
										</td>
										<td width="250" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333;">
											<strong>#subject#</strong>
										</td>
									</tr>
								</table>

								<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
									<tr>
										<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">
											<strong>**Any replies to this email will be sent to the #application.sourceApp#.com user's email address: #email#
											<br /><br />
											The following information has been submitted from the Contact Us section:
											</strong>
											<br><br>

											Customer Name: #FName# #LName# <br />
											Email Address: #Email# <br />
											Phone Number: #Phone# <br />
											******************************************************* <br />
											<strong>Technical Information<strong> <br />
											Operating System: #Operating# <br />
											Internet Service Provider: #ISP# <br />
											Personal Firewall: #Firewall# <br /><br /><br />
											#comments#
										</td>
									</tr>
								</table>

								<br>

								<table width="650" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
											&copy; #application.thisYear# 6FigureJobs.com | <a href="#application.url#/privacy">Privacy</a> | <a href="#application.url#/terms">Terms of Use</a> | <a href="#application.url#/contact">Contact</a> | <a href="#application.url#/sitemap">Site Map</a>
											<br />
											6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
										</td>
									</tr>
								</table>
							</cfmail>

						</cfif>

						<cfset MailSent = "1" />
					<cfelse>
						<cfset MailSent = "0" />
					</cfif>

				</cfif>

				<cfoutput>
				<cfif MailSent EQ "1">
					<div class="alert alert-success">
						Your inquiry has been submitted to our #Department# department.
						<br>
						Our <strong>#Department#</strong> team will make every effort to reply within 1 business day.
					</div>
				<cfelseif MailSent EQ "0">
					<div class="alert alert-error">
						There was a problem with your inquiry.
						<br>
						Please click your browser's Back Button to correct any missing fields.
					</div>
				</cfif>

				<a href="#application.url#?#application.strAppAddToken#" class="btn btn-primary btn-large">Return Home</a>
				</cfoutput>
			</cfif>

		</div>

	</div>

</div>
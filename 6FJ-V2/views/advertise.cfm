<cfparam name="blnSendEmail" default="0">
<cfparam name="strName" default="">
<cfparam name="strCom" default="">
<cfparam name="strEmail" default="">
<cfparam name="strPhone" default="">
<cfparam name="blnPassChecks" default="1">
<cfparam name="blnSentEmail" default="0">


<cfoutput>
<cfif blnSendEmail neq 0>

	<cfset blnPassChecks = 1 />

  	<!--- check all the fields --->
  	<cfif len(trim(strEmail)) eq 0>
    	<cfset blnPassChecks = 0 />
    <cfelse>

    	<cfif (ListContainsNoCase(strEmail, '@') is not 0) And (
				(ListContainsNoCase(strEmail, '.ae') is not 0) OR
				(ListContainsNoCase(strEmail, '.ar') is not 0) OR
				(ListContainsNoCase(strEmail, '.at') is not 0) OR
				(ListContainsNoCase(strEmail, '.au') is not 0) OR
				(ListContainsNoCase(strEmail, '.be') is not 0) OR
				(ListContainsNoCase(strEmail, '.biz') is not 0) OR
				(ListContainsNoCase(strEmail, '.bm') is not 0) OR
				(ListContainsNoCase(strEmail, '.br') is not 0) OR
				(ListContainsNoCase(strEmail, '.bz') is not 0) OR
				(ListContainsNoCase(strEmail, '.ca') is not 0) OR
				(ListContainsNoCase(strEmail, '.cc') is not 0) OR
				(ListContainsNoCase(strEmail, '.ch') is not 0) OR
				(ListContainsNoCase(strEmail, '.cn') is not 0) OR
				(ListContainsNoCase(strEmail, '.co') is not 0) OR
				(ListContainsNoCase(strEmail, '.com') is not 0) OR
				(ListContainsNoCase(strEmail, '.de') is not 0) OR
				(ListContainsNoCase(strEmail, '.dk') is not 0) OR
				(ListContainsNoCase(strEmail, '.edu') is not 0) OR
				(ListContainsNoCase(strEmail, '.es') is not 0) OR
				(ListContainsNoCase(strEmail, '.gov') is not 0) OR
				(ListContainsNoCase(strEmail, '.gr') is not 0) OR
				(ListContainsNoCase(strEmail, '.fr') is not 0) OR
				(ListContainsNoCase(strEmail, '.fm') is not 0) OR
				(ListContainsNoCase(strEmail, '.hk') is not 0) OR
				(ListContainsNoCase(strEmail, '.hu') is not 0) OR
				(ListContainsNoCase(strEmail, '.kr') is not 0) OR
				(ListContainsNoCase(strEmail, '.id') is not 0) OR
				(ListContainsNoCase(strEmail, '.ie') is not 0) OR
				(ListContainsNoCase(strEmail, '.il') is not 0) OR
				(ListContainsNoCase(strEmail, '.in') is not 0) OR
				(ListContainsNoCase(strEmail, '.it') is not 0) OR
				(ListContainsNoCase(strEmail, '.jp') is not 0) OR
				(ListContainsNoCase(strEmail, '.mil') is not 0) OR
				(ListContainsNoCase(strEmail, '.mx') is not 0) OR
				(ListContainsNoCase(strEmail, '.name') is not 0) OR
				(ListContainsNoCase(strEmail, '.net') is not 0) OR
				(ListContainsNoCase(strEmail, '.nl') is not 0) OR
				(ListContainsNoCase(strEmail, '.nz') is not 0) OR
				(ListContainsNoCase(strEmail, '.org') is not 0) OR
				(ListContainsNoCase(strEmail, '.rr') is not 0) OR
				(ListContainsNoCase(strEmail, '.ru') is not 0) OR
				(ListContainsNoCase(strEmail, '.uk') is not 0) OR
				(ListContainsNoCase(strEmail, '.us') is not 0) OR
				(ListContainsNoCase(strEmail, '.vg') is not 0) OR
				(ListContainsNoCase(strEmail, '.se') is not 0) OR
				(ListContainsNoCase(strEmail, '.sg') is not 0) OR
				(ListContainsNoCase(strEmail, '.th') is not 0) OR
				(ListContainsNoCase(strEmail, '.to') is not 0) OR
				(ListContainsNoCase(strEmail, '.tr') is not 0) OR
				(ListContainsNoCase(strEmail, '.tv') is not 0) OR
				(ListContainsNoCase(strEmail, '.ws') is not 0) OR
				(ListContainsNoCase(strEmail, '.za') is not 0) )>
			<cfset blnPassChecks=1>
		<cfelse>
			<cfset blnPassChecks=0>
		</cfif>
	</cfif>


	<cfif len(trim(strName)) EQ 0 OR len(trim(strCom)) EQ 0 OR len(trim(strPhone)) EQ 0>
		<cfset blnPassChecks = 0 />
	</cfif>


	<!--- Validate the captcha --->
	<cfif NOT isDefined('session.captcha') OR request.captcha NEQ session.captcha>
		<cfset blnPassChecks = 0 />
	</cfif>


	<cfsavecontent variable="emailMessage">
		<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
			<tr>
				<td width="350">
					<a href="#application.url#">
						<img src="#application.url#/images/six-figure-jobs-logo-092012.png" border="0" alt="#application.sourceApp#"><br><br>
					</a>
				</td>
				<td width="250" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333;">
					<strong>Advertising - Request for Media Kit</strong><br>
				</td>
			</tr>
		</table>

		<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
			<tr>
				<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">
					<strong>**Any replies to this email will be sent to the #application.sourceApp#.com user's email address: #strEmail#
					<br /><br />
					The following person has requested a media kit for #application.sourceApp#.com advertising:</strong><br>
					<br>
					Name: #strName#<br />
					Company: #strCom#<br />
					Email: #strEmail#<br />
					Phone: #strPhone#
				</td>
			</tr>
		</table>

        <table width="650" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
					&copy; #application.thisYear# 6FigureJobs.com | <a href="#application.url#/privacy">Privacy</a> | <a href="#application.url#/terms">Terms of Use</a> | <a href="#application.url#/contact">Contact</a> | <a href="#application.url#/sitemap">Site Map</a>
					<br />
					6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
                </td>
            </tr>
        </table>
	</cfsavecontent>


	<cfif blnPassChecks neq 0>

		<cfset blnSentEmail = 1 />

		<cfmail to="pdinardo@calliduscloud.com" bcc="vnalla@calliduscloud.com" from="#application.defaultEmail# (#application.sourceApp#.com)" subject="Advertising - Request for Media Kit" type="html">
			<cfmailparam name="Reply-To" value="#strEmail#">
			#emailMessage#
		</cfmail>

	</cfif>

</cfif>


<div class="page-advertise">

	<div class="section">
		<div class="container">

			<header class="page-header">
				<div class="container">
					<h1 class="page-title">Advertise on #application.sourceApp#.com</h1>
				</div>
			</header>

			<div class="well">
				<p>
					This page is intended for national marketers who seek to advertise their products and/or services to the audience of #application.sourceApp#.
					If you are an Employer or Recruiter and are looking to advertise your open positions or search our resume database, please <a href="/pricing?#application.strAppAddToken#&tm=30">click here</a>.
				</p>


				<h3>Why Advertise with #application.sourceApp#?</h3>
				<p>#application.sourceApp# is the premier executive career management site where high profile executives go to post their resumes, with full confidentiality, and search through thousands of $100K+ executive and management level opportunities.</p>

				<h3>#application.sourceApp# Executive Profile</h3>
				<p>When you advertise with us, you can expect to gain maximum exposure to our executive membership base. We have 700,000+ executives actively registered with our site, all carefully screened to match our minimum experience and compensation criteria.</p>
			</div>

		</div>
	</div>

	<div class="section">

		<div class="container">

			<div class="row">

				<div class="well span6">

					<form action="advertise?#application.strAppAddToken#" method="post" class="form form-horizontal" id="advertiseFrm">
						<input type="hidden" name="blnSendEmail" value="1">

						<h3>Request the Advertising Rate Card</h3>
						
						<cfif blnPassChecks EQ 0>
							<div class="alert alert-error">
								Please make sure all information below is correct. Then resubmit.
							</div>
						</cfif>


						<cfif blnSentEmail NEQ 1>
							<div class="control-group">
								<label class="control-label">Name</label>
								<div class="controls">
									<input type="text" name="strName" value="#strName#" size="35" class="requiredField">
								</div>
							</div>

							<div class="control-group">
								<label class="control-label">Company</label>
								<div class="controls">
									<input type="text" name="strCom" value="#strCom#" size="35" class="requiredField">
								</div>
							</div>

							<div class="control-group">
								<label class="control-label">Email</label>
								<div class="controls">
									<input type="text" name="strEmail" value="#strEmail#" size="35" class="requiredField">
								</div>
							</div>

							<div class="control-group">
								<label class="control-label">Phone</label>
								<div class="controls">
									<input type="text" name="strPhone" value="#strPhone#" size="35" class="requiredField">
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

							<div class="text-right">
								<input type="submit" class="btn btn-primary" value="Submit">
							</div>
						<cfelse>
							<div class="alert alert-info">
								Your request has been submitted. Our advertising department will be contacting you shortly.
							</div>
						</cfif>

					</form>

				</div>

				<!--- <div class="well span5">
					<h3>Download the Advertising Media Kit</h3>

					<a href="#application.v1URL#/documents/media/6FJ_AdvertisingMediaKit2013.pdf" target="_blank">
						<img src="#application.v1URL#/images/adobe_pdf_icon.gif" alt="Advertise to Executives" border="0" />
					</a>
					<a href="#application.v1URL#/documents/media/6FJ_AdvertisingMediaKit2013.pdf" target="_blank">2013 Advertising Media Kit</a>
				</div> --->
				
				<div class="well span5">
					Or contact us directly:<br>
					800.605.5154<br>
					<a href="mailto:advertising@#application.sourceApp#.com">advertising@#application.sourceApp#.com</a>
				</div>

			</div>

		</div>

	</div>

</div>
</cfoutput>
<cfsetting showdebugoutput="no">

<cfparam name="request.url" default="https://www.6figurejobs.com" />
<cfif cgi.http_host contains "uat2" or cgi.http_host contains "uat" or cgi.http_host contains "dev">
	<cfset request.url = "http://uat.6figurejobs.com" />
<cfelse>
	<cfset request.url = "https://www.6figurejobs.com" />
</cfif>

<cfset requestBody = toString( getHttpRequestData().content ) />
 
<!--- Double-check to make sure it's a JSON value. --->
<cfif isJSON( requestBody )>


 <cfset emailReturn = #deserializeJSON( requestBody )#>
  <cfset blnValid = IsValid( "email", emailReturn.email ) />
 <cfoutput>
 <cfif blnValid>
 	<!--- check if email address is active in our system --->
	<cfquery name="check6FJUser" datasource="#application.dsn#">
		select * from tblResumes
		where (username = '#emailReturn.email#')
		AND blnDelete=0
	</cfquery>
	
	<cfif check6FJUser.recordcount GTE 1>
		<!--- info to modal --->
		<cfoutput><h2>Hi #check6FJUser.fname#,</h2>
		<p>Looks like you already have a 6FigureJobs account created.  No need to login, we just sent
		you an email to the <em>#emailReturn.email#</em> you used while signing up for Learn365.  Please find the email
		from <em><strong>support@6figurejobs.com</strong></em>, with a subject of <em>"<strong>6FigureJobs Login Request</strong>"</em> and click on the 
		link within the email so that we can securely log you into your 6FigureJobs account to complete 
		your Learn365 registration.</p>
		
		<p>If you'd prefer to keep your 6FigureJobs and Learn365 accounts seperate, no problem, simply
		use a different email address while registering with Learn365.</p>
		
		<p>Happy Learning.</p>
		</cfoutput>
		
		<!--- info to modal --->
		<cfset Username=trim(URLdecode(check6FJUser.username))>
		<cfset Password=trim(URLdecode(check6FJUser.password))>
		<cfset blnRememberMe=trim(URLdecode(1))>
		

		<!--- Encrypt the value. --->
		<cfset Username = Encrypt(
			Username,
			application.encryptionKeyRM,
			"AES",
			"hex"
			) />
			<cfset Password = Encrypt(
			Password,
			application.encryptionKeyRM,
			"AES",
			"hex"
			) />
		
		<cfset emailLoginURL = "#request.url#/api/autoLoginEmail.cfm?100k=1&mz6ntxa3=#Username#&kB2MxfRR=#Password#&blnRememberMe=1&location=L365SU">
		
		<cfsavecontent variable="emailMessage">
			<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
				<tr>
					<td width="450">
						<a href="#emailLoginURL#"><img src="http://www.6figurejobs.com/images/six-figure-jobs-logo-092012.png" border="0" alt="Learn365"></a>
					</td>
				</tr>
			</table>
			
			<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
				<tr>
					<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">
						
						<h2>Hi #check6FJUser.fname#,</h2>
						Thanks for your interest in joining the Learn365 community.  We found that you already
						have a 6FigureJobs account, so to help you complete your Learn365 registration, we provided
						the below link to securely log you into your 6FigureJobs account in order to complete
						this registration.
						
						If you'd prefer to keep your 6FigureJobs and Learn365 accounts seperate, no problem, simply
						use a different email address while registering with Learn365.
						
						<p><a href="#emailLoginURL#">Click here to login</a></p>
						
						Happy Learning.
						
						
					</td>
				</tr>
			</table>
			<br>
			<table width="650" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
						
						&copy; #year(now())# #application.sourceApp#.com | <a href="#request.url#/6FigureJobs_PrivacyStatement.cfm">Privacy</a> | <a href="#request.url#/6FigureJobs_TOS.cfm">Terms of Use</a> | <a href="#request.url#/6FigureJobs_ContactUs.cfm">Contact</a> | <a href="#request.url#/sitemap.cfm">Site Map</a>
						<br />
						#application.sourceApp#.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
						<br /><br>
						You are receiving this email because you recently registered to become a member of #application.sourceApp#.com.
						<br><br>
						
					</td>
				</tr>
			</table>
			
		</cfsavecontent>
		
		
		<cfmail to="#emailReturn.email#" from="support@6figurejobs.com" subject="6FigureJobs Login Request" type="html">
			#emailMessage#
		</cfmail>
	<cfelse>
		
	</cfif>
	
 <cfelse>
 	Oops! That was an invalid email address, try again!
 </cfif>
 
 	
 </cfoutput>
 
 
 
</cfif>
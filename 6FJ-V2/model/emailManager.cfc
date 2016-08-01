<cfcomponent output="false">
	
	<cffunction name="init" access="public" output="false" returntype="emailManager">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="sourceApp" type="string" required="true" />
		<cfargument name="defaultEmail" type="string" required="true" />
		<cfargument name="url" type="string" required="true" />
		<cfscript>
			variables.dsn = arguments.dsn;
			variables.sourceApp = arguments.sourceApp;
			variables.defaultEmail = arguments.defaultEmail;
			variables.theURL = arguments.url;
			
			variables.theMailServer = "smtp.sendgrid.net";
			variables.mailUsers = structNew();
			variables.mailUsers.SalesStars = "LrdgN0ZRULmtG3ul";
			variables.mailUsers.6FigureJobs = "4bhNJRCTJity1Mv0";
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="sendThankYouEmail" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
		<cfargument name="firstName" type="string" required="true" />
		<cfargument name="theLearn365" type="string" required="false" default="0"/>
        
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs Membership <info@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars Membership <info@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="Welcome to #variables.sourceApp#!" type="html">
			<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
				<tr>
					<td width="450">
						<a href="#variables.theURL#"><img src="#variables.theURL#/images/six-figure-jobs-logo-092012.png" border="0" alt="#variables.sourceApp#"></a>
					</td>
				</tr>
			</table>
			
			<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
				<tr>
					<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">
						<span style="font-size:18px; line-height:22px; font-weight:bold;">#arguments.firstName#,</span>
						<br>
						<div style="padding-bottom: 6px;"></div>
						<span style="color:##7C4495; font-weight:bold;font-size:18px; line-height:24px;">
							Thank You for Registering!
							<br>
							Our Membership Committee is reviewing your application.*
							<br>
							You will receive a membership status email within 1 business day.
						</span>
						<br><br>
						<strong>*** PLEASE NOTE ***</strong>
						<br>
						6FigureJobs is a niche, senior-level and executive job board. Our Membership Committee pre-screens all new member registrations. This is a service that corporate and executive recruiters who use 6FigureJobs value and expect. This is also a service to you because recruiters will be confident in searching and reviewing legitimate and qualified profiles.
						<br><br>
						Thank you for your understanding!
						<br>
						The 6FigureJobs Team
						<br><br>
						<cfif arguments.theLearn365 NEQ 1>
							<table cellpadding="5" style="background-color:##E4DFE6">
								<tr>
									<td valign="top" colspan="2">
										<table style="text-align:center; background-color:##1f0845;margin-top:10px;padding:10px 10px 10px 10px;width:100%;">
										<tr>
										<td><img src="http://www.6figurejobs.com/images/learn365/Learn365-SEL.png" style="width:207px;"></td>
										<td> 
											&nbsp;&nbsp;<b style="color:##FFFFFF;">$19.95</b> <b style="color:##FFFFFF;">per month</b> <i style="color:##FFFFFF;">Cancel anytime</i>
										</td>
										</tr>
										</table>
										
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<h4>Are you prepared to begin interviewing? Could you use a few pointers or suggestions to try?</h4>
										<p>
										Do you feel your negotiation abilities are strong enough to get the compensation package you deserve?</p>
										<p style="margin-top:-15px">
										6FigureJobs is your go-to career resource. 
										We're excited to announce <b>Learn365, the new eLearning solution 
										for business professionals that are career focused like you!</b></p>
										<p style="margin-top:-15px">
										<b>Learn at your own pace through self-guided courses</b> taught by experts, thought leaders, researchers, and certified 
										trainers covering topics such as career, leadership, strategy, selling, as well as design and technical skills.
										</p>
										<p>
										 <a href="#application.URL#/learn365-dashboard" target="_blank">Click here</a> to learn more and preview our growing course catalog!
										</p>
									</td>
								</tr>
								<tr>
									<td>
										<div style="border:1px solid ##cccccc; text-align:center;max-width:255px; background-color:##FFF;">
											<div style="padding-top:10px">
												<img src="https://www.opensesame.com/courseimage/5101c3ac-0c22-3510-1c3a-c0c22a070050" style="height:119px; width:auto;">
											</div>
											<div>
												<h5 style="text-align:center">Interviewing Skills 101</h5>
											</div>
											<div>
												<p style="text-align:center "><a href="#application.URL#/learn365?coursecat=5##courses" target="_blank" class="btn btn-primary btn-small" role="button">Preview</a></p>
											</div>
										</div>
									</td>
									<td align="left">
										<div style="border:1px solid ##cccccc; text-align:center;max-width:255px; background-color:##FFF;">
											<div style="padding-top:10px">
												<img src="https://www.opensesame.com/courseimage/4ef3a853-0482-54ef-3a85-30482b962002" style="height:119px; width:auto;">
											</div>
											<div>
												<h5 style="text-align:center">Negotiating and Starting Right</h5>
											</div>
											<div>
												<p style="text-align:center "><a href="#application.URL#/learn365?coursecat=5##courses" target="_blank" class="btn btn-primary btn-small" role="button">Preview</a></p>
											</div>
										</div>
									</td>
								</tr>
							</table>
						</cfif>
						<table>
							<tr>
								<td style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 30px; color:##333333;">
									Be sure to connect with us here!
									<br>
									<a href="http://www.twitter.com/6figurejobs"><img src="#variables.theURL#/images/6FJ-Twitter.gif" border="0"></a>
									<a href="http://www.facebook.com/pages/6FigureJobs/218497995001?ref=ts"><img src="#variables.theURL#/images/6FJ-Facebook.gif" border="0" hspace="10"></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<br>
			<table width="650" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
						
						&copy; #year(now())# #variables.sourceApp#.com | <a href="#variables.theURL#/6FigureJobs_PrivacyStatement.cfm">Privacy</a> | <a href="#variables.theURL#/6FigureJobs_TOS.cfm">Terms of Use</a> | <a href="#variables.theURL#/6FigureJobs_ContactUs.cfm">Contact</a> | <a href="#variables.theURL#/sitemap.cfm">Site Map</a>
						<br />
						#variables.sourceApp#.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
						<br /><br>
						You are receiving this email because you recently registered to become a member of #variables.sourceApp#.com.
						<br><br>
						
					</td>
				</tr>
			</table>
		</cfmail>
	</cffunction>
	
	
	<cffunction name="sendWelcomeEmail" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
		<cfargument name="firstName" type="string" required="true" />
        <cfargument name="theSourceApp" type="string" required="true" />
		
        <cfif arguments.theSourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs Membership <info@6figurejobs.com>" />
            <cfset theURL = "http://www.6figurejobs.com">
		<cfelseif arguments.theSourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars Membership <info@salesstars.com>" />
            <cfset theURL = "http://www.salesstars.com">
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="Welcome to #arguments.theSourceApp#!" type="html">
			<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
				<tr>
					<td width="450">
						
						<a href="#theURL#">
							<cfif arguments.theSourceApp EQ "6FigureJobs">
								<img src="#theURL#/images/six-figure-jobs-logo-092012.png" border="0" alt="#variables.sourceApp#"><br><br>
							<cfelseif arguments.theSourceApp EQ "SalesStars">
								<img src="#theURL#/_includes/templates/assets/img/salesstars-logo-black-beta.png" border="0" alt="#arguments.theSourceApp#"><br><br>
							</cfif>
						</a>
						
					</td>
				</tr>
			</table>
			
			<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
				<tr>
					<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">
						<span style="font-size:18px; line-height:22px; font-weight:bold;">#arguments.firstName#,</span>
						<br>
						<div style="padding-bottom: 6px;"></div>
						<span style="color:##7C4495; font-weight:bold;font-size:18px; line-height:24px;">
							Welcome to #arguments.theSourceApp#!
							<cfif arguments.theSourceApp EQ "6FigureJobs">
								<br>
								Your membership has been approved.
							</cfif>
						</span>
						<br><br>
						<span style="color:##000000; font-weight:bold;font-size:18px; line-height:22px;">Important Next Step...</span>
						<br><br>
						<a href="#theURL#/ExecLogin.cfm" style="color:##7C4495; font-weight:bold;font-size:16px; line-height:20px;">Please upload your resume.</a>
						<br>
						In order to be searchable by recruiters, you need to have a resume added to your profile.
						<br><br>
						
						<span style="color:##000000; font-weight:bold;font-size:18px; line-height:22px;">Here's an Important Tip...</span>
						<br><br>
						<span style="color:##7C4495; font-weight:bold;font-size:16px; line-height:20px;">Refresh Your Resume Often To Stay On Top!</span>
						<br>
						If you're an aggressive job seeker who wants to get noticed by recruiters, we recommend you "Refresh Your Resume" often to ensure your profile gets listed near the top of talent searches. The longer your profile/resume lays dormant, the less likely you will appear when recruiters conduct searches. To do this, simply log in and click on the "Refresh Resume" button located on your Dashboard.
							
                        <table cellpadding="5" style="background-color:##E4DFE6">
							<tr>
								<td valign="top">
									<table style="text-align:center; background-color:##1f0845;margin-top:10px;padding:10px 10px 10px 10px;width:100%;">
									<tr>
									<td><img src="http://www.6figurejobs.com/images/learn365/Learn365-SEL.png" style="width:207px;"></td>
									<td> 
										&nbsp;&nbsp;<b style="color:##FFFFFF;">$19.95</b> <b style="color:##FFFFFF;">per month</b> <i style="color:##FFFFFF;">Cancel anytime</i>
									</td>
									</tr>
									</table>
									
								</td>
							</tr>
							<tr>
								<td>
									<h4>Are you prepared to begin interviewing? Could you use a few pointers or suggestions to try?</h4>
									<p>
									Do you feel your negotiation abilities are strong enough to get the compensation package you deserve?</p>
									<p style="margin-top:-15px">
									6FigureJobs is your go-to career resource. 
									We're excited to announce <b>Learn365, the new eLearning solution 
									for business professionals that are career focused like you!</b></p>
									<p style="margin-top:-15px">
									<b>Learn at your own pace through self-guided courses</b> taught by experts, thought leaders, researchers, and certified 
									trainers covering topics such as career, leadership, strategy, selling, as well as design and technical skills.
									</p>
									<p>
									 <a href="#application.url#/learn365-dashboard" target="_blank">Click here</a> to learn more and preview our growing course catalog!
									</p>
								</td>
							</tr>
						</table>
						<cfif arguments.theSourceApp EQ "SalesStars">
							<br><br>
							<span style="color:##7C4495; font-weight:bold;font-size:16px; line-height:20px;">Be sure to follow us here, to receive career advice and get a heads up on new jobs that are being posted by recruiters.</span>
							<br>
							<a href="http://www.twitter.com/sales_stars">
								<img src="#theURL#/images/SalesStars-Twitter.gif" border="0" vspace="8">
							</a>
							<a href="http://www.linkedin.com/groups/SalesStars-4831049/about">
								<img src="#theURL#/images/SalesStars-LinkedIn.png" border="0" vspace="8" hspace="10">
							</a>
						<cfelse>
							<br><br>
							<span style="color:##7C4495; font-weight:bold;font-size:16px; line-height:20px;">Be sure to follow us here, to receive career advice and get a heads up on new jobs that are being posted by recruiters.</span>
							<br>
							<a href="http://www.facebook.com/pages/6FigureJobs/218497995001?ref=ts">
								<img src="#theURL#/images/socialmedia/6FJ-FaceBook.png" border="0" vspace="8" hspace="10">
							</a>
							<a href="http://www.twitter.com/6FigureJobs">
								<img src="#theURL#/images/socialmedia/6FJ-Twitter.png" border="0" vspace="8">
							</a>
							<a href="https://plus.google.com/105332100153951435724/posts">
								<img src="#theURL#/images/socialmedia/6FJ-GooglePlus.png" border="0" vspace="8">
							</a>
							<a href="http://www.linkedin.com/groups?gid=21210">
								<img src="#theURL#/images/socialmedia/6FJ-LinkedIn.png" border="0" vspace="8">
							</a>
							<a href="http://www.pinterest.com/6figurejobs/">
								<img src="#theURL#/images/socialmedia/6FJ-Pinterest.png" border="0" vspace="8">
							</a>
						</cfif>	
					</td>
				</tr>
			</table>
			<br>
			<table width="650" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
						
						<cfif arguments.theSourceApp EQ "SalesStars">
							&copy; #year(now())# SalesStars.com | <a href="#theURL#/SalesStars_PrivacyStatement.cfm">Privacy</a> | <a href="#theURL#/SalesStars_TOS.cfm">Terms of Use</a> | <a href="#theURL#/SalesStars_ContactUs.cfm">Contact</a> | <a href="#theURL#/sitemap.cfm">Site Map</a>
							<br />
					        SalesStars.com | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
					        <br /><br>
					        You are receiving this email because you recently registered to become a member of SalesStars.com.
					        <br>
					        This email is a confirmation that your membership is active.
					        <br /><br />
						<cfelse>
							&copy; #year(now())# 6FigureJobs.com | <a href="#theURL#/6FigureJobs_PrivacyStatement.cfm">Privacy</a> | <a href="#theURL#/6FigureJobs_TOS.cfm">Terms of Use</a> | <a href="#theURL#/6FigureJobs_ContactUs.cfm">Contact</a> | <a href="#theURL#/sitemap.cfm">Site Map</a>
							<br />
							6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
							<br /><br>
							You are receiving this email because you recently registered to become a member of 6FigureJobs.com.
							<br>
							This email is a confirmation that your membership is active.
							<br /><br />
						</cfif>
						
					</td>
				</tr>
			</table>	
			
		</cfmail>
	</cffunction>
	
    <!---Send 6FigureJobs Dashboard Invite Welcome Email--->
    <cffunction name="send6FJSSInvWelcomeEmail" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
		<cfargument name="firstName" type="string" required="true" />
        <cfargument name="theSourceApp" type="string" required="true" />
		
        <cfif arguments.theSourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs Membership <info@6figurejobs.com>" />
            <cfset theURL = "http://www.6figurejobs.com">
		<cfelseif arguments.theSourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars Membership <info@salesstars.com>" />
            <cfset theURL = "http://www.salesstars.com">
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="Welcome to #arguments.theSourceApp#!" type="html">
			<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
				<tr>
					<td width="450">
						
						<a href="#theURL#">
							<cfif arguments.theSourceApp EQ "6FigureJobs">
								<img src="#theURL#/images/six-figure-jobs-logo-092012.png" border="0" alt="#variables.sourceApp#"><br><br>
							<cfelseif arguments.theSourceApp EQ "SalesStars">
								<img src="#theURL#/_includes/templates/assets/img/salesstars-logo-black-beta.png" border="0" alt="#arguments.theSourceApp#"><br><br>
							</cfif>
						</a>
						
					</td>
				</tr>
			</table>
			
			<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
				<tr>
					<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">
						<span style="font-size:18px; line-height:22px; font-weight:bold;">#arguments.firstName#,</span>
						<br>
						<div style="padding-bottom: 6px;"></div>
						<span style="color:##7C4495; font-weight:bold;font-size:18px; line-height:24px;">
							Welcome to #arguments.theSourceApp#!
						</span>
                        <br>
                        <br>
                        <span style="font-size:16px; line-height:22px;">
                        	<strong>Username:</strong> your email address<br>
							<strong>Password:</strong> same as your 6FigureJobs password
                        </span>
						<br><br>
						<span style="color:##000000; font-weight:bold;font-size:18px; line-height:22px;">Recommended Next Steps...</span>
						<br><br>
						<a href="#theURL#/ExecLogin.cfm" style="color:##7C4495; font-weight:bold;font-size:16px; line-height:20px;">Create a Job Search Alert</a>
						<br>
						<strong>Strongly Recommended</strong> so that we can notify you about new jobs that get posted.
						<br><br>
						<cfif arguments.theSourceApp EQ "SalesStars">
							<a href="#theURL#/search" style="color:##7C4495; font-weight:bold;font-size:16px; line-height:20px;">Search Sales Jobs</a>
							<br><br><br>
							
						<cfelse>
							<a href="#theURL#/ExecSearchJobs.cfm" style="color:##7C4495; font-weight:bold;font-size:16px; line-height:20px;">Search $100K+ Jobs</a>
							<br><br>
							<a href="#theURL#/ExecFeaturedCompanies.cfm" style="color:##7C4495; font-weight:bold;font-size:16px; line-height:20px;">View Our Featured Hiring Companies</a>
							<br><br><br>
						</cfif>
						
						
						<span style="color:##000000; font-weight:bold;font-size:18px; line-height:22px;">Here's an Important Tip...</span>
						<br><br>
						<span style="color:##7C4495; font-weight:bold;font-size:16px; line-height:20px;">Refresh Your Resume Often To Stay On Top!</span>
						<br>
						If you're an aggressive job seeker who wants to get noticed by recruiters, we recommend you "Refresh Your Resume" often to ensure your profile gets listed near the top of talent searches. The longer your profile/resume lays dormant, the less likely you will appear when recruiters conduct searches. Simply log in and click on the "Refresh Resume" button on your Dashboard.
						
						<cfif arguments.theSourceApp EQ "6FigureJobs">
                        	<br><br>
							<span style="color:##7C4495; font-weight:bold;font-size:16px; line-height:20px;">Be Sure to Connect With Us Here</span>
							<br>
							<a href="http://www.twitter.com/sales_stars">
								<img src="#theURL#/images/SalesStars-Twitter.gif" border="0" vspace="8">
							</a>
							<a href="http://www.linkedin.com/groups/SalesStars-4831049/about">
								<img src="#theURL#/images/SalesStars-LinkedIn.png" border="0" vspace="8" hspace="10">
							</a>
                       	</cfif>

					</td>
				</tr>
			</table>
			<br>
			<table width="650" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
						
						<cfif arguments.theSourceApp EQ "SalesStars">
							&copy; #year(now())# SalesStars.com | <a href="#theURL#/SalesStars_PrivacyStatement.cfm">Privacy</a> | <a href="#theURL#/SalesStars_TOS.cfm">Terms of Use</a> | <a href="#theURL#/SalesStars_ContactUs.cfm">Contact</a> | <a href="#theURL#/sitemap.cfm">Site Map</a>
							<br />
					        SalesStars.com | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
					        <br /><br>
					        You are receiving this email because you recently registered to become a member of SalesStars.com.
					        <br>
					        This email is a confirmation that your membership is active.
					        <br /><br />
						<cfelse>
							&copy; #year(now())# 6FigureJobs.com | <a href="#theURL#/6FigureJobs_PrivacyStatement.cfm">Privacy</a> | <a href="#theURL#/6FigureJobs_TOS.cfm">Terms of Use</a> | <a href="#theURL#/6FigureJobs_ContactUs.cfm">Contact</a> | <a href="#theURL#/sitemap.cfm">Site Map</a>
							<br />
							6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
							<br /><br>
							You are receiving this email because you recently registered to become a member of 6FigureJobs.com.
							<br>
							This email is a confirmation that your membership is active.
							<br /><br />
						</cfif>
						
					</td>
				</tr>
			</table>	
			
		</cfmail>
	</cffunction>
    	
	<cffunction name="sendJobAlert" access="public" output="false" returntype="void">
    	<cfargument name="emailTo" type="string" required="true" />
		<cfargument name="theEmailSubject" type="string" required="true" />
        <cfargument name="theEmail" type="string" required="true" />
        <cfargument name="theSourceApp" type="string" required="true" />
        
		<cfset var theEmailURL = "" />
		<cfset var thePW = "" />
		<cfset var theSendAddress = "" />
		
		
		<cfif arguments.theSourceApp EQ "6FigureJobs">
			<cfset theEmailURL = "http://www.6figurejobs.com">
			<cfset theSendAddress = "jobs@6figurejobs.com (6FigureJobs Alert)" />
		<cfelseif arguments.theSourceApp EQ "SalesStars">
			<cfset theEmailURL = "http://www.salesstars.com">
			<cfset theSendAddress = "jobs@salesstars.com (SalesStars Alert)" />
		</cfif>
		
		<cfif structKeyExists(variables.mailUsers, arguments.theSourceApp)>
			<cfset thePW = variables.mailUsers["#arguments.theSourceApp#"] />
			<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.theEmailSubject#" type="html" server="#variables.theMailServer#" username="#arguments.theSourceApp#" password="#thePW#">
				<cfmailparam name="X-SMTPAPI" value='{"category": "Job Search Alert"}'>
				<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
					<tr>
						<td width="400">
							<a href="#theEmailURL#">
								<cfif arguments.theSourceApp EQ "6FigureJobs">
									<img src="#theEmailURL#/images/six-figure-jobs-logo-092012.png" width="50%" alt="#arguments.theSourceApp#.com Job Search Alert" border="0">
								<cfelseif arguments.theSourceApp EQ "SalesStars">
									<img src="#theEmailURL#/_includes/templates/assets/img/salesstars-logo-black-beta.png" width="50%" alt="#arguments.theSourceApp#.com Job Search Alert" border="0">
								</cfif>
							</a>
						</td>
					</tr>
				</table>
				
				<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; border-top:10px solid ##7C4495; padding:15px;" width="650">
					<tr>
						<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 18px; color:##333333;">
							<div style="color:##7C4495; font-weight:bold;font-size:20px; line-height:28px;">Saved Job Search Alert</div>
							<br><br>
							
							#arguments.theEmail#
							
							<br><br><br>
							
							<div style="border-top:1px dotted ##999999; border-bottom:1px dotted ##999999; padding-top:10px; padding-bottom:10px;">
								Want more relevancy? <a href="#theEmailURL#/ExecLogin.cfm" target="_blank" style="padding-right:8px; color:##7C4495">Edit Job Search Criteria</a>|<a href="#theEmailURL#/ExecLogin.cfm" style="padding-right:8px; padding-left:8px; color:##7C4495">Turn Alert OFF</a>|<a href="#theEmailURL#/ExecLogin.cfm" target="_blank" style="padding-right:15px; padding-left:8px; color:##7C4495">Create New Job Alert</a>
								<br>
							</div>
							<br><br>
							
							<table style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px;">
								<tr>
									<td width="350" valign="top" style="border-right:1px solid ##999999; padding-right:10px;">
										<div style="color:##7C4495; font-weight:bold;font-size:16px; line-height:20px; margin-bottom:5px;">Refresh Your Resume Often To Stay On Top!</div>
										Did you know that the longer your profile remains dormant, the less likely you will appear in recruiters' searches? Remember to upload a current resume whenever you can or login and click on the "Refresh Resume" button on your Dashboard.<br><br>
										<a href="#theEmailURL#/ExecLogin.cfm" style="border:1px solid ##cccccc; background:##F5F5F5; text-decoration:none; padding:10px; font-size:16px;">Refresh Resume</a>
									</td>
									<td valign="top" style="padding-left:10px;">
										<div style="color:##7C4495; font-weight:bold;font-size:16px; line-height:20px; margin-bottom:5px;">Stay Connected & Informed</div>
										Get the latest jobs, industry news, and job search advice from #arguments.theSourceApp#.<br>
										
										<cfif arguments.theSourceApp EQ "SalesStars">
											<a href="http://www.twitter.com/sales_stars">
												<img src="#theEmailURL#/images/SalesStars-Twitter.gif" border="0" vspace="8">
											</a>
											<br>
											<a href="http://www.linkedin.com/groups/SalesStars-4831049/about">
												<img src="#theEmailURL#/images/SalesStars-LinkedIn.png" border="0" vspace="8" hspace="10">
											</a>
										<cfelse>
											<a href="http://www.twitter.com/6figurejobs">
												<img src="#theEmailURL#/images/6FJ-Twitter.gif" border="0" vspace="8">
											</a>
											<br>
											<a href="http://www.facebook.com/pages/6FigureJobs/218497995001?ref=ts">
												<img src="#theEmailURL#/images/6FJ-Facebook.gif" border="0">
											</a>
										</cfif>
									</td>
								</tr>
							</table>
							
							<br>
						</td>
					</tr>
				</table>
				
				
				<table width="650" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
							
							<cfif arguments.theSourceApp EQ "SalesStars">
								&copy; #year(now())# SalesStars.com | <a href="#theEmailURL#/SalestStars_PrivacyStatement.cfm">Privacy</a> | <a href="#theEmailURL#/SalesStars_TOS.cfm">Terms of Use</a> | <a href="#theEmailURL#/SalesStars_ContactUs.cfm">Contact</a> | <a href="#theEmailURL#/sitemap.cfm">Site Map</a> <br />
								SalesStars.com | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154<br /><br>
							<cfelse>
								&copy; #year(now())# 6FigureJobs.com | <a href="http://www.6figurejobs.com/6FigureJobs_PrivacyStatement.cfm">Privacy</a> | <a href="http://www.6figurejobs.com/6FigureJobs_TOS.cfm">Terms of Use</a> | <a href="http://www.6figurejobs.com/6FigureJobs_ContactUs.cfm">Contact</a> | <a href="http://www.6figurejobs.com/sitemap.cfm">Site Map</a> <br />
								6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154<br /><br>
							</cfif>
							
						</td>
					</tr>
				</table>
				
			</cfmail>
		
		</cfif>
	</cffunction>


	<cffunction name="sendJobApplNotification" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailAttachment" type="string" required="true" />
        <cfargument name="emailReplyTo" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <jobapplication@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <jobapplication@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html" mimeattach="#arguments.emailAttachment#">
			<cfmailparam name="Reply-To" value="#arguments.emailReplyTo#">
			#emailBody#
		</cfmail>
	</cffunction>
    
    <cffunction name="sendJobApplConfirmation" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <jobapplication@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <jobapplication@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>
    
    
    <cffunction name="erRegConfirmation" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <sales@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <sales@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" bcc="#theSendAddress#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>
    
    <cffunction name="erWelcomeEmail" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <info@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <info@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>	
    
    <cffunction name="erJobPostAcceptConfirm" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <jobs@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <jobs@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>	

    <cffunction name="erJobPostRejectConfirm" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <jobs@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <jobs@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>	

    <cffunction name="erJobPostIncomplConfirm" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <jobs@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <jobs@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>
    
    <cffunction name="candRegistrationReject" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
        <cfargument name="theSourceApp" type="string" required="true" />
		
        <cfif arguments.theSourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <info@6figurejobs.com>" />
		<cfelseif arguments.theSourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <info@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>
    
    <cffunction name="candRegistrationIncomplete" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		<cfargument name="theSourceApp" type="string" required="true" />
        
        <cfif arguments.theSourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <info@6figurejobs.com>" />
		<cfelseif arguments.theSourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <info@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>
    
    <cffunction name="candForgotPassword" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <support@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <support@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>
    
    <cffunction name="emailColleague" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailFromName" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailAttachment" type="string" required="true" />
        <cfargument name="emailReplyTo" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "#emailFromName# <info@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "#emailFromName# <info@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html" mimeattach="#arguments.emailAttachment#">
			<cfmailparam name="Reply-To" value="#arguments.emailReplyTo#">
			#emailBody#
		</cfmail>
	</cffunction>
    
    <cffunction name="RecruiterActivityReport" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailReplyTo" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <#arguments.emailReplyTo#>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <#arguments.emailReplyTo#>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
        	<cfmailparam name="Reply-To" value="#arguments.emailReplyTo#">
			#emailBody#
		</cfmail>
	</cffunction>
	
    
    
    <cffunction name="JobRedFlagAlert" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <communitymanager@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <communitymanager@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>
    
	    
    <cffunction name="deletedProfileConfirmation" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <communitymanager@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <communitymanager@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>
    
     <cffunction name="candidateSearchAlert" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <candidates@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <candidates@salesstars.com>" />
		</cfif>
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>
    
    <cffunction name="cplOptinConfEmail" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		
        <cfif variables.sourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs <leads@6figurejobs.com>" />
		<cfelseif variables.sourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars <leads@salesstars.com>" />
		</cfif>
        
        <cfprocessingdirective suppresswhitespace="No">
			<cfmail from="#theSendAddress#" to="#arguments.emailTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
			</cfmail>
        </cfprocessingdirective>
	</cffunction>
    
    
	<cffunction name="sendSalesAssessmentEmail" access="public" output="false" returntype="void">
    	<cfargument name="theEmailSubject" type="string" required="true" />
		<cfargument name="theEmail" type="string" required="true" />
        <cfargument name="theSourceApp" type="string" required="true" />
		<cfargument name="theEmailBody" type="string" required="true" />
        
		<cfset var theEmailURL = "" />
		<cfset var thePW = "" />
		<cfset var theSendAddress = "" />
				
		<cfset theEmailURL = "http://www.salesstars.com">
		<cfset theSendAddress = "info@salesstars.com (SalesStars Assessment Report)" />
		
		
		<cfif structKeyExists(variables.mailUsers, arguments.theSourceApp)>
			<cfset thePW = variables.mailUsers["#arguments.theSourceApp#"] />
			<cfmail from="#theSendAddress#" to="#arguments.theEmail#" subject="#arguments.theEmailSubject#" type="html" server="#variables.theMailServer#" username="#arguments.theSourceApp#" password="#thePW#">
			#theEmailBody#			
			</cfmail>
		</cfif>
	</cffunction>            
    
    
    <!---Exec Incomplete Registration Reminder Email --->        
    <cffunction name="execIncRegReminderEmail" access="public" output="false" returntype="void">
    	<cfargument name="theEmailSubject" type="string" required="true" />
		<cfargument name="theEmail" type="string" required="true" />
        <cfargument name="theSourceApp" type="string" required="true" />
		<cfargument name="theEmailBody" type="string" required="true" />
        
		<cfset var thePW = "" />
		<cfset var theSendAddress = "" />
		<cfset var theURL = "" />	
		<cfif arguments.theSourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs Membership <info@6figurejobs.com>" />
            <cfset theURL = "http://www.6figurejobs.com">
		<cfelseif arguments.theSourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars Membership <info@salesstars.com>" />
            <cfset theURL = "http://www.salesstars.com">
		</cfif>
		
		<cfif structKeyExists(variables.mailUsers, arguments.theSourceApp)>
			<cfset thePW = variables.mailUsers["#arguments.theSourceApp#"] />
			<cfmail from="#theSendAddress#" to="#arguments.theEmail#" subject="#arguments.theEmailSubject#" type="html" server="#variables.theMailServer#" username="#arguments.theSourceApp#" password="#thePW#">
			#theEmailBody#			
			</cfmail>
		</cfif>
	</cffunction>
    
    
    <!---Exec Resume Refresh Reminder Email --->        
    <cffunction name="execResRefreshReminderEmail" access="public" output="false" returntype="void">
    	<cfargument name="theEmailSubject" type="string" required="true" />
		<cfargument name="theEmail" type="string" required="true" />
        <cfargument name="theSourceApp" type="string" required="true" />
		<cfargument name="theEmailBody" type="string" required="true" />
        
		<cfset var thePW = "" />
		<cfset var theSendAddress = "" />
		<cfset var theURL = "" />	
		<cfif arguments.theSourceApp EQ "6FigureJobs">
			<cfset theSendAddress = "6FigureJobs Membership <info@6figurejobs.com>" />
            <cfset theURL = "http://www.6figurejobs.com">
		<cfelseif arguments.theSourceApp EQ "SalesStars">
			<cfset theSendAddress = "SalesStars Membership <info@salesstars.com>" />
            <cfset theURL = "http://www.salesstars.com">
		</cfif>
		
		<cfif structKeyExists(variables.mailUsers, arguments.theSourceApp)>
			<cfset thePW = variables.mailUsers["#arguments.theSourceApp#"] />
			<cfmail from="#theSendAddress#" to="#arguments.theEmail#" subject="#arguments.theEmailSubject#" type="html" server="#variables.theMailServer#" username="#arguments.theSourceApp#" password="#thePW#">
			#theEmailBody#			
			</cfmail>
		</cfif>
	</cffunction>   
	
	
<!--- learn365 emails --->	
	<cffunction name="sendL365ThankYouEmail" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
		<cfargument name="firstName" type="string" required="true" />
		<cfargument name="bccTo" type="string" required="true" />
       
		<cfset theSendAddress = "Learn365 Membership <info@6figurejobs.com>" />
		
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" bcc="#arguments.bccTo#" subject="Welcome to Learn365!" type="html">
			<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
				<tr>
					<td width="450">
						<a href="#variables.theURL#/learn365"><img src="http://www.6figurejobs.com/images/learn365/Learn365-tag-whitebg.png" border="0" alt="Learn365"></a>
					</td>
				</tr>
			</table>
			
			<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
				<tr>
					<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">
						<span style="font-size:18px; line-height:22px; font-weight:bold;">#arguments.firstName#,</span>
						<br>
						<div style="padding-bottom: 6px;"></div>
						<span style="color:##7C4495; font-weight:bold;font-size:18px; line-height:24px;">
							Thank you  and you are now part of the Learn365 community, and can begin learning!
						</span>
						<br><br>
						<p>Learn365 strives to be your daily go-to for developing, 
						strengthening, or refreshing a skill to create new
						opportunities or open new doors for your career, or generally
						to inspire new ideas.</p>
						<p>
						<a href="#variables.theURL#/learn365">Click here</a> to log into your Learn365 account.
						</p>
						
						<p><b>Dashboard</b>
						- As you start and complete courses, your learning history will be tracked
						here.  Additionally, as we release new courses, you will first be notified
						within your Learn365 dashboard.
						</p>
						<p>
						<b>Courses</b>
						- This button will launch the library of content.  With your membership,
						you will have access to all content.  Within the Learning Management System (LMS)
						that will be launched in a separate browser, click the "Course Library" tab
						in order to search the course library using a "Google-like" search box 
						or using a CATEGORY filter dropdown to view a category of courses.
						</p>
						<p>
						<b>Profile</b>
						- Here is where you will manage your Learn365 profile including account
						and membership details.
						</p>
						<p>
						If you have any questions or issues, please reach us at communitymanager@6figurejobs.com.</p>
						<p>Happy Learning,<br>
						Your Learn365 team</p>
						<br><br>
						
					</td>
				</tr>
			</table>
			<br>
			<table width="650" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
						
						&copy; #year(now())# #variables.sourceApp#.com | <a href="#variables.theURL#/6FigureJobs_PrivacyStatement.cfm">Privacy</a> | <a href="#variables.theURL#/6FigureJobs_TOS.cfm">Terms of Use</a> | <a href="#variables.theURL#/6FigureJobs_ContactUs.cfm">Contact</a> | <a href="#variables.theURL#/sitemap.cfm">Site Map</a>
						<br />
						#variables.sourceApp#.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
						<br /><br>
						You are receiving this email because you recently registered to become a member of #variables.sourceApp#.com.
						<br><br>
						
					</td>
				</tr>
			</table>
		</cfmail>
	</cffunction>
	
	<cffunction name="cancelL365Confirmation" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		<cfargument name="bccTo" type="string" required="true" />
		
		<cfset theSendAddress = "Learn365 <communitymanager@6figurejobs.com>" />
		
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" bcc="#arguments.bccTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>
	
	<cffunction name="reactivateL365Confirmation" access="public" output="false" returntype="void">
		<cfargument name="emailTo" type="string" required="true" />
        <cfargument name="emailSubject" type="string" required="true" />
        <cfargument name="emailBody" type="string" required="true" />
		<cfargument name="bccTo" type="string" required="true" />
		
		<cfset theSendAddress = "Learn365 <communitymanager@6figurejobs.com>" />
        
		<cfmail from="#theSendAddress#" to="#arguments.emailTo#" bcc="#arguments.bccTo#" subject="#arguments.emailSubject#" type="html">
			#emailBody#
		</cfmail>
	</cffunction>
	         
</cfcomponent>
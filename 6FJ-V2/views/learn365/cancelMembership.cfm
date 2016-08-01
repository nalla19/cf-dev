<cfparam name="strMode" default="showForm">

<cfoutput>
	<article class="section companies well">
		<div class="container">
			<h1>Cancel Membership</h1>
			<div class="row-fluid">
				<div class="span12 accountprofile">
					<cfswitch expression="#strMode#">
						<cfcase value="showForm">
							<form action="/learn365-cancel?#application.strAppAddToken#" method="post" name="deleteAccout" >
							<input type="hidden" name="strMode" value="process">
						   
							<div class="row-fluid">
								<div class="span12  ">
									<h3>Are you sure you want to cancel your Learn365 membership?</h3>
								</div>
							</div>
							<div class="page-spacer"></div>
							<div class="row-fluid">
								<div class="span12" style="padding-left:10px;">
									 <!--- <span class="label label-info">Note </span>  --->
									 This option will move all of your information into our inactive database until you choose to reactivate your membership. You will also have access to your Learn365 account until the last day of your billing cycle.
								<!--- <label class="radio" style="font-size:16px"><input type="radio" name="blnAction" value="11" checked> Cancel My Learn365 Membership</label> --->
								</div>
							</div>
							
							<div class="page-spacer"></div>
							<div class="row-fluid">
								<div class="span12">
									<a href="##" id="Continuebutton" role="button" class="btn btn-primary btn-medium" onclick="document.deleteAccout.submit();"> Cancel Learn365 Membership </a>
								</div>
							</div>
							<!--- <div class="page-spacer"></div>
							<div class="row-fluid">
								<div class="span12">
									<span class="label label-info">Note </span> This option will move all of your information into our inactive database until you choose to reactivate your membership.
								</div>
							</div> --->
							</form>
						</cfcase>
						<cfcase value="process">
						
							<!--- deactive user's recurring profile in Paypal --->	
							<cfsilent>
							<cfscript>
							premiumObj  = application.premium;
							resObj 		= application.resume;
							payPalObj  	= application.payflowpro;
							qProfile 	= resObj.getResumeDetail(session.exec.intresid); 
							 
							paypalObj.setUpdatedBillingCC(session.exec.intresid,0,"4111111111111111","01#(year(now()+366))#");
							qTransaction = payPalObj.setPremiumOff(qprofile.profileid);
							//Update DB
							if (isdefined("qTransaction") and qTransaction.result eq 0){	
								//Active
								if (qTransaction.RESPMSG eq "Approved"){
									//Update DB HERE
									 premiumObj.setPremiumCancel(session.exec.intresid,qprofile.profileid);
								}
							}	
							
							</cfscript>
			   				</cfsilent>
							<!---  deactive user on litmos & update database to set learn365 user to active=0: this will happen as part of the daily job. --->
						    
							<!--- update Learn365: set cleanupFlag = 1 --->
							<cfquery name="updateLearn365User" datasource="#application.dsn#">
								UPDATE [tblLearn365Users]
								set [cleanupFlag] = 1
								,dteCanceled = '#dateformat(now(),'mm/dd/yyyy')#'
								,dteReactivated = ''
								where INTRESID = #qProfile.intresid#
							</cfquery>
							<!--- send email --->
							
							<!--- START EMAIL --->
							<cfset theURL = "http://www.6figurejobs.com">
							
							<!--- Get Profile Info --->
							<cfscript>
								profileid =  application.executive.getProfileidByResumeid(qProfile.intresid).profileid;
								premiumObj 	= application.premium;
								qPackage 	= premiumObj.getPremiumPackageDetails(profileid); 
								
							</cfscript>
							
							<cfoutput>
							<cfsavecontent variable="emailMessage">
							<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
								<tr>
									<!-- MASTHEAD BEGIN -->
									<td width="350">
										<a href="#theURL#">
											<img src="#theURL#/images/Learn365/Learn365-tag-whitebg.png" border="0" alt="#application.applicationName#"><br><br>
										</a>	
									</td>
									<td width="250" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333;">&nbsp;</td>
								  <!-- MASTHEAD END -->
								</tr>
							</table>
							
							<table cellpadding="0" cellspacing="0" style="border:1px solid ##e3e3e3; padding:10px;" width="650">
								<tr>
									<td valign="top" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 22px; color:##333333; padding-right:10px; padding-left:5px; padding-top:3px;">
										<!--- COMMUNICATION MESSAGE BEGIN --->
										<span style="font-size:20px; color:##9f58a2; font-weight:bold; line-height:26px;">We're sad to see you go!</span><br>
										<p>This is a confirmation email that your profile on Learn365 has been canceled.</p>
										
										<p>Your recurring payment of <strong>$19.95</strong> has been stopped on <strong>#dateformat(NOW(),"mm/dd/yy")#</strong>.</p>
										
										<p>You will still have access to the library of courses until <strong>#dateformat(qPackage.dteexpires,"mm/dd/yy")#</strong> .</p>
										
										<p>Thank You,<br>
										
										The Learn365 Team<br><br>
										</p>
										
										<!--- COMMUNICATION MESSAGE END --->
									</td>
								</tr>
							</table>
							
							<br>
							
							<table width="650" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
										&copy; #year(now())# 6FigureJobs.com | <a href="#theURL#/6FigureJobs_PrivacyStatement.cfm">Privacy</a> | <a href="#theURL#/6FigureJobs_TOS.cfm">Terms of Use</a> | <a href="#theURL#/6FigureJobs_ContactUs.cfm">Contact</a> | <a href="#theURL#/sitemap.cfm">Site Map</a>
										<br />
										6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
										<br /><br>
										You are receiving this email because you have deleted your profile with 6FigureJobs.com
										<br /><br />
									</td>
								</tr>
							</table>	
							</cfsavecontent>
							
							<cfset emailList="">
							<cfset emailList=ListAppend(emailList,email)>
							<cfif cgi.http_host contains "uat2" or cgi.http_host contains "uat" or cgi.http_host contains "dev">
								<cfset bccEmail = 'irodela@calliduscloud.com'>
							<cfelse>
								<cfset bccEmail = 'msaddoris@calliduscloud.com,irodela@calliduscloud.com'>
							</cfif>
							
							
							
							<cfloop list="#emailList#" delimiters="," index="emailID">
								<cftry>	
									<cfset application.emailManager.cancelL365Confirmation(emailTo=emailID, emailSubject="Canceled Learn365 Membership Confirmation", emailBody=emailMessage,bccTo=bccEmail)>    
									
									<cfcatch type="any"></cfcatch>
								</cftry>
							</cfloop>
							</cfoutput>
									
							<!--- END EMAIL --->
							
							<!--- send user to deactivation confirmation page --->
							<div class="row-fluid">
								<div class="span12  ">
									<h3>We're sorry to see you go!</h3>
								</div>
							</div>
							<div class="page-spacer"></div>
							<div class="row-fluid">
								<div class="span12" style="padding-left:10px;">
									<p>We have stopped your recurring membership with Learn365. You will have access to the courses until the last day of your billing cycle. </p>
									<p>Remember, you can start up your membership at any time!</p>
								</div>
							</div>
											
						</cfcase>
					</cfswitch>
				</div>
			</div>
		</div>
	</article>
</cfoutput>
<!--- <cfinclude template="/6fj/isLoggedIn.cfm">
 --->
<cfoutput>
<cfparam name="strMode" default="showForm">
<cfparam name="blnAction" default="0">
<cfparam name="blnConfirm" default="0">
<cfparam name="blnNewsletter" default="0">
<cfset blnThisArchived=session.EXEC.blnArchived>
 <div class="page-companies">
			<article class="section companies well">
				<div class="container">
<!--- <img src="images/header_myaccount.gif" width="131" height="14" alt="My 6FigureJobs.com Account" border="0"><br><br> --->
<h2 class="PageHeader">My Account Status</h2>


	 <table cellspacing="0" cellpadding="0" border="0"  width="100%">
	 	<tr>
        	<td>
				<cfswitch expression="#strMode#">
					<cfcase value="showForm">
	 					<form action="/member-cancel?#application.strAppAddToken#" method="post" name="deleteAccout">
                        <input type="hidden" name="strMode" value="validate">
                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                        	<tr><td></td></tr>
                        </table>
                        
                        <table cellspacing="0" cellpadding="2" border="0">
                        	<tr><td colspan="2" align="left"><span style="color:000000;font-size:14px; font-weight:bold;line-height:24px;">You may <cfif blnThisArchived eq 1><u>reactivate</u><cfelse><u>deactivate</u></cfif><cfif not session.exec.isLearn365Active> or <u>delete</u></cfif> your resume entirely using this form.</span></td></tr>                     
                        	<tr><td colspan="2">&nbsp;<!---  <hr size="1" width="40%"> ---></td></tr>
                        	<tr>
                            	<td align="right" valign="top"><input type="radio" name="blnAction" value="11" checked></td>
                        		<td align="left" valign="top">
                        			<span style="color:000000;font-weight:bold;"><cfif blnThisArchived>Reactivate<cfelse>Deactivate</cfif> Resume</span>
                        			<br>
									<cfif blnThisArchived neq 1><span style="color:000000;">This option will move all of your information into our inactive database until you choose to reactivate your resume. Your resume/profile will be hidden from Employers and Recruiters. We recommend this option if you plan on coming back to use our service again. This option will also save you time by not having to go through our registration process again.</span></cfif>
		                        </td>
                        	</tr>
							<cfif not session.exec.isLearn365Active>
                        	<tr><td colspan="2">&nbsp;</td></tr>
                        	<tr>
                        		<td align="right" valign="top"><input type="radio" name="blnAction" value="21"></td>
                        		<td align="left" valign="top">
                        			<span style="color:000000;font-weight:bold;">Delete Entire Account from the Database</span>
                        			<br>
                                    <span style="color:##cc0000;">Warning: </span><span style="color:000000;"> This option will delete all of your information from our system. If you decide to come back later and use our service, you will have to go through our registration process again to create a new account.</span>
                        		</td>
                        	</tr>
							</cfif>
                        	<tr><td colspan="2">&nbsp;</td></tr>
                        	<tr>
                        		<td align="center" valign="top">&nbsp;</td>
                        		<td align="center" valign="top">
                                	<!--- <input type="submit" class="exec_submit" value="Continue"> --->
                                    <a href="##" id="Continuebutton" role="button" class="btn btn-primary btn-large" onclick="document.deleteAccout.submit();"> Continue </a></td>
                        	</tr>
                        </table>
                        </form>
                 	</cfcase>
	
		
					<!------------ validate form ------------------>
                    <cfcase value="validate">
						<!--- confirm deactivate or reactivate the account --->
                        <cfset strConfirm="">
                        <!---<cfset strConfirmNO="No, Go to My Account">--->
                        <form action="/member-cancel?#application.strAppAddToken#" method="post" name="Status">
                        <input type="hidden" name="strMode" value="process">
                        <input type="hidden" name="blnAction" value="#blnAction#">
                        <input type="hidden" name="blnNewsletter" value="#blnNewsletter#">
                        <table cellspacing="0" cellpadding="2" border="0" width="100%">
                            <cfswitch expression="#blnAction#">
	                            <cfcase value="11">
    		                        <cfif blnThisArchived>
            		        	        <cfset strConfirm="Are you sure you want to reactivate your resume?">
                    		        	<!---<cfset strConfirmYES="Yes, Reactivate My Resume">--->
                            		<cfelse>
                            			<cfset strConfirm="Are you sure you want to deactivate your resume?">
                            			<!---<cfset strConfirmYES="Yes, Deactivate My Resume">--->
                            		</cfif>
                           	 		<tr><td align="left" valign="top" colspan="2" style="font-weight:bold; color:##000000;">#strConfirm#</td></tr>
                            		<tr>
                            			<td align="left">
                            				<table border=0 cellspacing=0 cellpadding=0 width="80%">
                            					<tr>
                                                	<td align="left" style="padding-top:20px;">
                            							<!--- <input type="submit" style="width:50" class="exec_submit" name="blnConfirm" value="YES">&nbsp;&nbsp;&nbsp;
                            							<input type="submit" style="width:50" class="exec_submit" name="blnConfirm" value="NO"> --->
                                                        <input type="hidden" name="blnConfirm" value="" />
                                                        <a href="##" role="button" class="btn btn-primary btn-small" onclick="document.Status.blnConfirm.value='YES'; document.Status.submit();" style="font-size:13px; font-weight:bold;">YES</a>&nbsp;&nbsp;&nbsp;
                                                        <a href="##" role="button" class="btn btn-primary btn-small" onclick="document.Status.blnConfirm.value='NO'; document.Status.submit();" style="font-size:13px; font-weight:bold;">NO</a>
                            						</td>
                                              	</tr>
                        					</table>
                        				</td>
                        			</tr>
                        		</cfcase> 
                        
                        		<cfcase value="21">
                        			<!--- <cfset strConfirm="Are you sure you want to delete your full resume posting<br>from the 6FigureJobs database?"> --->
                        			<!---<cfset strConfirmYES="Yes, Delete My Information Now">--->
                        			<tr>
                        				<td align="left" valign="top" colspan="2">
                        					<table cellpadding="0" cellspacing="0" border="0" width="100%">
                        						<tr><td valign="top" style="line-height:18px; font-weight:bold;">Are you sure you want to delete your account?<br />
                                                You can simply deactivate your resume so it is inactive in our database, so that you can reactivate it at a later time. </td></tr>
                                                 <tr><td align="center" valign="top">&nbsp;</td></tr>
                                                  <script language="JavaScript">
                                                    function deleteacct(s)
                                                    {
                                                        document.Status.blnConfirm.value=s;
                                                        //alert(document.Status.blnConfirm.value);
                                                        document.Status.submit();
                                                    }
                                                  </script>
                                                <tr>
                                                   <td align="center">
                                                        <table border=0 cellspacing=0 cellpadding=0 width="100%">
                                                            <tr>
                                                            	
                                                            	<td >
                                                                <input type="Hidden" name="blnConfirm" value="">
                                                                <a href="##" role="button" class="btn btn-primary btn-small" id="DeactivateAcctbutton" onclick="deleteacct('Resume');">Deactivate</a>
                                                                <a href="##" role="button" class="btn btn-primary btn-small" id="DeleteAcctbutton" onclick="deleteacct('Yes');">Delete</a>
                                                            </td></tr>
                                                        </table>
                                                   </td>
                                                </tr>
                        					</table>
                        				</td>
                        			</tr>
                               	</cfcase> 
                        	</cfswitch>
                     	</table>
                        </form>
                    </cfcase>
	
					<!------------ process form ------------------>
                    <cfcase value="process">                    
                    	<cfif blnConfirm eq "YES" or blnConfirm eq "RESUME">
                    		<!--- deactivate or reactivate the account --->
                    		<cfif blnAction eq 11>
                    			<cfif session.EXEC.blnArchived>
                    				<cfset blnThisArchived=0>
                    			<cfelse>
                    				<cfset blnThisArchived=1>
                    			</cfif>
                   
								<!--- update resume table --->
                                <cfquery name="cfqResume" datasource="#application.dsn#">
                                update tblResumes
                                set blnArchived=#blnThisArchived#
                                where intresid=#session.exec.intResID#
                                </cfquery>
								
                                <!---08/10/2011: Cancel the Premium membership if exists >
                                <cfinclude template="t_execCancelPremium.cfm">
                                --->
                                
								<!--- Update Archived flag --->
                                <!--- <cflock scope="session" timeout="10" type="Exclusive"> --->
	                                <cfset session.EXEC.blnArchived=blnThisArchived>
                              <!---   </cflock> --->
								
    			                <script language="JavaScript">location.href="/member-cancel?#application.strAppAddToken#&strmode=confirm";</script>
                    		</cfif>   
                    
                    		<!--- delete the account --->
                    		<cfif blnAction eq 21>
                    			<cfif blnConfirm eq "Resume">
                                    <cfquery name="cfqResume" datasource="#application.dsn#">
                                    update tblResumes
                                    set blnArchived=1
                                    where intresid=#session.exec.intResID#
                                    </cfquery>
	    
                                    <!---08/10/2011: Cancel the Premium membership if exists
    	                            
                                    <cfinclude template="t_execCancelPremium.cfm">
									--->
                                    
				                    <!--- Update Archived flag --->
                				    <!--- <cflock scope="session" timeout="10" type="Exclusive"> --->
                    					<cfset session.Exec.blnArchived=1>
                    				<!--- </cflock> --->
                    				<script language="JavaScript">location.href="/member-cancel?#application.strAppAddToken#&strmode=confirm";</script><br>
                    			<cfelse>
									<!--- delete the resume --->
                                    <cfquery name="cfqResume" datasource="#application.dsn#">
                                    update tblResumes
                                    set 
                                    blnValidated=0,
                                    blnBigs=0,
                                    blnArchived=1,	     
                                    blnDelete=1,
                                    intStatusCode=1,
                                    listCompletedSteps='',
                                    intAdmCode=10,
									blnLearn365=0,
									blnLearn365Lead=0,
									blnLearn365Newsletter = 0,
									blnHide6FJBtn = 0
                                    where intresid=#session.exec.intResID#
                                    </cfquery>
															
	
                                    <!---08/10/2011: Cancel the Premium membership if exists >
    	                            <cfinclude template="t_execCancelPremium.cfm">
       								--->
                                    <cfquery name="cfqGetEmail" datasource="#application.dsn#">
                                    select fname,lname,email 
                                    from tblResumes
                                    where intresid=#session.exec.intResID#
                                    </cfquery>
                                    <cfset email=cfqGetEmail.Email>
                                    <cfset Fname=cfqGetEmail.FName>
									<cfset lname=cfqGetEmail.lname>
									
									<!--- delete L365 User from DB & Litmos --->
									<cfif isDefined("session.EXEC.isLearn365Active") and session.EXEC.isLearn365Active EQ 0 >
										
										<cfquery name="checkLearn365" datasource="#application.dsn#">
											select * from tblLearn365Users
											where intresid=#session.exec.intResID#
										</cfquery>
										
										<cfif checkLearn365.recordcount GTE 1>
											<cfquery name="deleteLearn365" datasource="#application.dsn#">
												delete from tblLearn365Users
												where intresid=#session.exec.intResID#
											</cfquery>
										
											<cfset learn365Username = "delete_#email#">
											<cfset learn365FirstName = firstName>
											<cfset learn365LastName = lastName>
											<cfset learn365UserId = #session.EXEC.learn365UserID#>
											<cfset learn365Active = 0>
											
											<cfinclude template="api/updateUser.cfm">
											
											<cfmail from="support@6figurejobs.com" to="irodela@calliduscloud.com" subject="Delete Learn365User" type="html">
											Delete this account from Litmos: delete_#email#
											</cfmail>
										</cfif>
									</cfif>
									
									
                                    <!--- <cfinclude template="t_emailDeleteProfile.cfm"> --->
									<!--- START EMAIL --->
                    					<cfif application.sourceapp eq "6FigureJobs">
											<cfset theURL = "http://www.6figurejobs.com">
										<cfelseif application.sourceapp eq "SalesStars">
											<cfset theURL = "http://www.salesstars.com">
										</cfif>
										
										<cfoutput>
										<cfsavecontent variable="emailMessage">
										<table cellpadding="0" cellspacing="0" style="padding:10px;" width="650">
											<tr>
												<!-- MASTHEAD BEGIN -->
												<td width="350">
													<a href="#theURL#">
														<cfif application.sourceapp EQ "6FigureJobs">
															<img src="#theURL#/images/six-figure-jobs-logo-092012.png" border="0" alt="#application.applicationName#"><br><br>
														<cfelseif application.sourceapp EQ "SalesStars">
															<img src="#theURL#/_includes/templates/assets/img/salesstars-logo-black-beta.png" border="0" alt="#application.applicationName#">
														</cfif>
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
													This is a confirmation email that your profile on #application.applicationName#.com has been deleted.<br><br>
													
													We hope that you were able to find a new job and that you found us to be a resourceful job search tool. We invite you to come back and visit us again, whether you are actively or passively looking for a new job. We will always continue to grow and improve our service.<br><br>
													
													If you have a moment, we would love to get your feedback!<br><br>
													<a href="https://www.surveymonkey.com/s/575CMHZ" style="font-size:20px; color:##9f58a2;">Take our quick exit survey</a><br>
													<i>It takes less than 30 seconds!</i><br><br>
													
													We wish you the best of luck in your career!<br><br>
													
													Successfully Yours,<br>
													
													The #application.applicationName# Team<br><br>
													
													<cfif application.applicationName EQ "6FigureJobs">
														<table>
															<tr>
																<td style="font-family:Arial, Helvetica, sans-serif; font-size:14px; line-height: 30px; color:##333333;">
																Follow us here to stay informed of new developments at 6FigureJobs!<br>
																<a href="http://www.twitter.com/6figurejobs"><img src="http://www.6figurejobs.com/images/6FJ-Twitter.gif" border="0"></a>
																<a href="http://www.facebook.com/pages/6FigureJobs/218497995001?ref=ts"><img src="http://www.6figurejobs.com/images/6FJ-Facebook.gif" border="0" hspace="10"></a></td>
															</tr>
														</table>
													</cfif>
													<!--- COMMUNICATION MESSAGE END --->
												</td>
											</tr>
										</table>
										
										<br>
										
										<table width="650" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td style="font-family:Arial, Helvetica, sans-serif; font-size:12px; line-height: 18px; color:##333333;">
												<cfif application.applicationName EQ "SalesStars">
														&copy; #year(now())# SalesStars.com | <a href="#theURL#/SalesStars_PrivacyStatement.cfm">Privacy</a> | <a href="#theURL#/SalesStars_TOS.cfm">Terms of Use</a> | <a href="#theURL#/SalesStars_ContactUs.cfm">Contact</a> | <a href="#theURL#/sitemap.cfm">Site Map</a>
														<br />
														SalesStars.com | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
														<br /><br>
														You are receiving this email because you have deleted your profile with SalesStars.com
														<br /><br />
													<cfelse>
														&copy; #year(now())# 6FigureJobs.com | <a href="#theURL#/6FigureJobs_PrivacyStatement.cfm">Privacy</a> | <a href="#theURL#/6FigureJobs_TOS.cfm">Terms of Use</a> | <a href="#theURL#/6FigureJobs_ContactUs.cfm">Contact</a> | <a href="#theURL#/sitemap.cfm">Site Map</a>
														<br />
														6FigureJobs.com, Inc. | 145 West 57th Street, 15th Floor | New York, NY 10019 | 800.605.5154
														<br /><br>
														You are receiving this email because you have deleted your profile with 6FigureJobs.com
														<br /><br />
													</cfif>
												</td>
											</tr>
										</table>	
										</cfsavecontent>
										
										<cfset emailList="">
										<cfset emailList=ListAppend(emailList,email)>
										<!--- <cfset emailList="irodela@calliduscloud.com"> --->
										
										<cfloop list="#emailList#" delimiters="," index="emailID">
											<cftry>	
												<cfset application.emailManager.deletedProfileConfirmation(emailTo=emailID, emailSubject="Deleted Account Confirmation", emailBody=emailMessage)>    
												
												<cfcatch type="any"></cfcatch>
											</cftry>
										</cfloop>
										</cfoutput>
									
									<!--- END EMAIL --->
									<!--- Take away all privlidges --->
                                    <cflock scope="session" timeout="10" type="Exclusive">
                                    	<cfif not StructIsEmpty(session)> 
                                    		<cfset strSesionKeys=StructKeyList(session)>
                                    		<cfloop list="#strSesionKeys#" index="ListElement">
                                    			<cfset rc=StructDelete(session, "#ListElement#", "True")>
                                    		</cfloop>
                   	 					</cfif>
                    				</cflock>
                    
                                    <table cellspacing="2" cellpadding="2" border="0">
	                                    <tr><td style="font-size:14px; font-weight:bold; color:##000000;">We're sorry to see you go.<br />
                                        Your resume, along with all of your information, has been deleted from the 6FigureJobs database.<br /><br /></td></tr>
        	                            <tr><td style="font-size:14px; font-weight:bold; color:##000000;">Thank you for using 6FigureJobs.com</td></tr>
                                    </table>
                    			</cfif>
                    		</cfif>
                    	<cfelse>
                    		<!--- <script language="JavaScript">location.href="pg_execloginprocess.cfm?#strAppAddToken#";</script> --->
                   	 		<cflocation url="/member-dashboard?#application.strAppAddToken#" addtoken="No">
                    		<!--- <script language="JavaScript">location.href="ExecMyAccount.cfm?#strAppAddToken#";</script> --->
                    	</cfif>
                    </cfcase>
	 
                    <cfcase value="confirm">
    	                <table cellspacing="0" cellpadding="0" border="0" width="100%">
	            	        <cfif session.Exec.blnArchived>
                    			<tr><td style="font-size:14px; font-weight:bold; color:##000000;">Your 6FigureJobs resume has been deactivated.<br />
                                All of your information has been placed in an inactive database until you choose to reactivate your resume.<br /><br />
                                If you wish to reactivate your resume, login and click on Change Account Status.<br /><br /></td></tr>
                                <tr><td colspan="2"><a href="/member-dashboard?#application.strAppAddToken#" style="font-size:13px; font-weight:bold;">RETURN TO MY ACCOUNT</a></td></tr>
			                    <!--- <tr><td>Thank you for using 6FigureJobs.com</td></tr> --->
            			        <tr><td><!---  <cf_ct_CPLPartner formID=1 targetID=3 loggedIn=1 displayMsg=0 ActiveLeftNav=#m# ActiveLeftSubNav=#am# datasource="#strsixfigdata#" CFIDToken="#strAppAddToken#" LockTimeOut="#strLockTimeOut#" returnLink="ExecMyAccount.cfm?#strAppAddToken#" returnText="Back to the Resume Center">---></td></tr>
		                    <cfelse>
                    			<tr><td align="center" colspan="2">&nbsp;</td></tr>
                    			<tr><td colspan="2" class="bold">Your 6FigureJobs resume is now active.<br><br><a href="/member-dashboard?#application.strAppAddToken#" class="executive_button"><span>RETURN TO MY ACCOUNT</span></a></td></tr>
            			        <tr><td align="center" colspan="2">&nbsp;</td></tr>	
                    		</cfif>
                    	</table>
                    </cfcase>
				</cfswitch>
			</td>
    	</tr>
	</table>
<!--- </cfif> --->
	</div>
           	</article>
       	</div>
</cfoutput>
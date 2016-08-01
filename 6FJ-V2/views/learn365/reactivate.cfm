<cfparam name="form.blnTermsConditions" default="0">
<cfparam name="form.blnL365Newsletter" default="1">
<cfparam name="form.bln6FJAccount" default="1">


<cfparam name="firstName" default="">
<cfparam name="lastName" default="">
<cfparam name="email" default="">
<cfparam name="password" default="">

<cfparam name="phonenumber" default="">
<cfparam name="strAddress1" default="">
<cfparam name="strAddress2" default="">
<cfparam name="strCity" default="">
<cfparam name="strState" default="">
<cfparam name="strZipCode" default="">

<cfparam name="cardname" default="">
<cfparam name="strCardType" default="">
<cfparam name="cardNumber" default="">
<cfparam name="cardMonth" default="">
<cfparam name="cardYear" default="">
<cfparam name="securityCode" default="">

<cfparam name="intResID" default="">
<cfparam name="blnLearn365" default=0>
<cfparam name="bln6FJLead" default=0>
<cfparam name="blnTermsConditions" default=0>
<cfparam name="blnL365Newsletter" default=1>

<cfparam name ="errMsg" default="">

<!--- <cfoutput>
#datediff('d',now(),url.expireDt)#
<cfif datediff('d',now(),url.expireDt) LTE 0>
hello
#dateformat(dateadd('d', 1, now()),'mm/dd/yyyy')#
</cfif>
</cfoutput> --->


<!--- if logged in and not a learning user, get all their 6FJ --->
<cfif (isdefined("session.exec.blnValidLogin") and session.exec.blnValidLogin) and (isdefined("session.exec.blnLearn365") and session.exec.blnLearn365)>
	<cfquery name="getCurrentUser" datasource="#application.dsn#">
		SELECT 
		intResID,
		email, 
		fname,
		lname,
		address,
		city,
		state,
		zip,
		home_phone,
		username,
		password,
		blnLearn365
		FROM tblResumes (nolock) 
		WHERE intResID = #session.EXEC.intResID#
	</cfquery>
	<cfif getCurrentUser.recordcount EQ 1>
		<cfset firstName=getCurrentUser.fname>
		<cfset lastName=getCurrentUser.lname>
		<cfset email=getCurrentUser.email>
		<cfset password=getCurrentUser.password>
		
		<cfset phonenumber = getCurrentUser.home_phone>
		<cfset strAddress1=getCurrentUser.address>
		<cfset strCity=getCurrentUser.city>
		<cfset strState=getCurrentUser.state>
		<cfset strZipCode=getCurrentUser.zip>
		<cfset intResID=getCurrentUser.intResID>
		<cfset blnLearn365=getCurrentUser.blnLearn365>
	</cfif>
<cfelse>

	<!--- take them to their learning dashboard --->
	<cfif (isdefined("session.exec.blnValidLogin") and session.exec.blnValidLogin) and (isdefined("session.exec.isLearn365Active") and session.exec.isLearn365Active)>
		<!--- <cflocation url="/learn365-dashboard"> --->
	<cfelse>
		<cflock scope="session" timeout="10" type="Exclusive">
		 <cfif not StructIsEmpty(session)> 
          <cfset strSesionKeys=StructKeyList(session)>
          <cfloop list="#strSesionKeys#" index="ListElement">
           <cfset rc=StructDelete(session, "#ListElement#", "True")>
          </cfloop>
         </cfif>
        </cflock>
		<cflocation url="/learn365-dashboard">
	</cfif>
	
</cfif>



<!---  form submission --->
<cfif isdefined("form.fieldnames")>
	


	<!---Check if a new learn365 User & new 6FJ User --->
	<cfset firstName=form.firstName>
	<cfset lastName=form.lastName>
    <cfset email=form.email>
   
	
	<cfset phonenumber = form.phonenumber>
	<cfset strAddress1=form.strAddress1>
	<cfset strAddress2=form.strAddress2>
	<cfset strCity=form.strCity>
	<cfset strState=form.strState>
	<cfset strZipCode=form.strZipCode>
	<cfset intResID=form.intResID>
	<cfset bln6FJLead=form.frm6FJLead>
	<cfset blnLearn365=form.blnLearn365>
	<cfset blnTermsConditions=form.blnTermsConditions>
	<cfset blnL365Newsletter=form.blnL365Newsletter>
	
	<!--- check here if email is duplicate. if it is, send them to sign in and send them to sign up page. --->
	<cfquery name="checkLearn365User" datasource="#application.dsn#">
		select * from tblLearn365Users
		where learn365Username = '#email#'
	</cfquery>
	

	
		
			
		<!--- update profile w/ form data  --->		  
		<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
			update tblResumes  set
				dteEdited= getdate(),
				address = '#strAddress1# #strAddress2#',
				city=<cfqueryparam value="#strCity#" cfsqltype="cf_sql_varchar" />,
				state=<cfqueryparam value="#strState#" cfsqltype="cf_sql_varchar" />,
				zip=<cfqueryparam value="#strZipCode#" cfsqltype="cf_sql_varchar" />,
				home_phone= <cfqueryparam value="#phonenumber#" cfsqltype="cf_sql_varchar" />,
				blnLearn365Newsletter = #blnL365Newsletter#
				where intResid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
		</cfquery> 
			
		<!--- get components ready and update paypal w/ billing & card. this will activate the profile --->
		<cfsilent>
		<cfscript>
		payPalObj 	= application.payflowpro;
		resObj 		= application.resume;
		qProfile 	= resObj.getResumeDetail(intResID); 
		premiumObj 	= application.premium;
		
		paypalObj.setUpdatedBillingDetails(session.exec.intresid,'#strAddress1# #strAddress2#',strZipCode);
		
		</cfscript>
		 <cfset expDate = "#form.cardmonth##form.cardyear#">
			
		 <cfstoredproc procedure="spU_ExecUpdateCC" datasource="#application.dsn#" returncode="no">
			<cfprocparam type="IN" dbvarname="@intresid" value="#intresid#" cfsqltype="cf_sql_integer" />
			<cfprocparam type="IN" dbvarname="@blnCCCharged" value="1" cfsqltype="cf_sql_integer" />
			<cfprocparam type="IN" dbvarname="@name" value="#form.cardname#" cfsqltype="cf_sql_varchar" />
			<cfprocparam type="IN" dbvarname="@cardType" value="#form.strcardType#" cfsqltype="cf_sql_varchar" />
			<cfprocparam type="IN" dbvarname="@cardnumber" value="#form.cardnumber#" cfsqltype="cf_sql_varchar" />
			<cfprocparam type="IN" dbvarname="@expDate" value="#expDate#" cfsqltype="cf_sql_varchar" />
			<cfprocparam type="IN" dbvarname="@cscCode" value="#form.securityCode#" cfsqltype="cf_sql_varchar" />
			<cfprocparam type="IN" dbvarname="@ipaddress" value="#cgi.REMOTE_ADDR#" cfsqltype="cf_sql_varchar" />
		</cfstoredproc>
		 <cfscript>
			cardnumber  = form.cardnumber;
			expDate = trim(expDate);
			profileid =  application.executive.getProfileidByResumeid(intresid).profileid;
		    getResponse = payPalObj.setUpdatedBillingCC(intresid,0,cardnumber,expdate);
			
			if (isdefined("getResponse.authcode")){  authcode = getResponse.authcode; } else{ authcode = ""; }
			if (isdefined("getResponse.RPREF")){ RPREF = getResponse.RPREF; }else{ RPREF = "";}
			if (isdefined("getResponse.TRXPNREF")){ TRXPNREF = getResponse.TRXPNREF; } else{ TRXPNREF = "";	 }
			if (isdefined("getResponse.TRXRESPMSG")){ TRXRESPMSG = getResponse.TRXRESPMSG; } else{ TRXRESPMSG = "";	 }	
			
			cost = payPalObj.getPremiumObj(1).intialcost;
			 cost = numberformat(cost, "______.__"); 
			 months =  payPalObj.getPremiumObj(1).months;
		</cfscript>
		</cfsilent>
		<cfif (getResponse.RESULT eq 0 and getResponse.RESPMSG eq "Approved")>
		
			<!--- update start date to today if expireddt has passed or is today. if expired date has not passed, do not update the start date. --->
			<cfif datediff('d',NOW(),url.expireDt) LTE 0>
				<cfset updateStartDate = dateformat(dateadd('d', 1, now()),'mm/dd/yyyy')>
				<cfset updateExpireDate = dateformat(dateadd('m', 1, updateStartDate),'mm/dd/yyyy')>
				<cfscript>
					paypalObj.setUpdatedRecurringStartDate(session.exec.intresid,0,updateStartDate);
				</cfscript>
			<cfelse>
				<cfset updateExpireDate = dateformat(url.expireDt,'mm/dd/yyyy')>
				<cfset updateStartDate = dateformat(dateadd('m', -1, updateExpireDate),'mm/dd/yyyy')>
			</cfif>
			
			<!--- insert new transactiong into BOALogs: get previous transaction and increment payment number by 1 --->		
				<cfinvoke component="#premiumObj#" method="setPremiumTransaction" returnvariable="qtransaction">
					<cfinvokeargument name="authCode" value="#authcode#"/>
					<cfinvokeargument name="intresid" value="#intresid#"/>
					<cfinvokeargument name="name" value="#firstName# #lastname#"/>
					<cfinvokeargument name="email" value="#email#"/>
					<cfinvokeargument name="cardtype" value="#form.strCardType#"/>
					
					<cfinvokeargument name="cardnumber" value="#right(form.cardnumber,4)#"/>
					<cfinvokeargument name="cscCode" value=""/>
					<!--- Card Security Code --->
					<cfinvokeargument name="expDate" value="#form.cardMonth#/#form.cardYear#"/>
					<cfinvokeargument name="responseCode" value="#ucase(getResponse.result)#"/>
					<cfinvokeargument name="responseDesc" value="#getResponse.RESPMSG#"/>
					<cfinvokeargument name="transid" value="#RPREF#"/>
					<cfinvokeargument name="TransactionID" value="#TRXPNREF#"/>
					<cfinvokeargument name="TransactionMsg" value="#iif(TRXRESPMSG eq 'Approved',de('Active'),de(TRXRESPMSG))#"/>
					<cfinvokeargument name="cost" value="#cost#"/>
					<cfinvokeargument name="months" value="#months#"/>
					<cfinvokeargument name="ipaddress" value="#cgi.REMOTE_ADDR#"/>
					<cfinvokeargument name="avsAddrResp" value=""/>
					<cfinvokeargument name="AvsZipResp" value=""/>
					<cfinvokeargument name="profileid" value="#profileid#"/>
				</cfinvoke>
			<cfdump var="#qtransaction#">
			<cfoutput>#qtransaction.logid#</cfoutput>
			<!--- <cfabort> --->
			<!--- update tblBOALogs w/ correct start date if needed --->
				
				<cfquery name="updateLearn365User" datasource="#application.dsn#">
					UPDATE [tblBOALogs]
						   set dteSubmitted = '#updateStartDate#',
						   dteExpires = '#updateExpireDate#'
					where IOC_Trans_ID = #qtransaction.logid#
				</cfquery>
				
			
			<!--- update Learn365 User table to active --->
				<cfquery name="updateLearn365User" datasource="#application.dsn#">
					UPDATE [tblLearn365Users]
						   set [blnActive] = 1
						   ,[cleanupFlag] = 0
						   ,dteCanceled = ''
						   ,dteReactivated = getdate()
					where INTRESID = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
				</cfquery>
			
			<!--- update litmos user if expired date has passed: make sure for nightly clean up we set up a flag system 0:active | 1:to be processed | 2:processed --->
			<cfset learn365Username = email>
			<cfset learn365FirstName = firstName>
			<cfset learn365LastName = lastName>
			<cfset learn365UserId = session.EXEC.learn365UserID>
			<cfset learn365Active = 1>
			
			<cfinclude template="api/updateUser.cfm">
			<!--- send thank you email here? --->
			
			<!--- START EMAIL --->
			<cfset theURL = "http://www.6figurejobs.com">
			
			
			<cfscript>
				profileid =  application.executive.getProfileidByResumeid(intresid).profileid;
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
							<img src="#theURL#/images/Learn365-tag-whitebg.png" border="0" alt="#application.applicationName#"><br><br>
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
						<span style="font-size:20px; color:##9f58a2; font-weight:bold; line-height:26px;"></span>Welcome Back!</span><br>
						<p>This is a confirmation email that your profile on Learn365 has been reactivated.</p>
						
						<p>Your recurring payment will be <strong>$19.95</strong> and will begin on <strong>#dateformat(NOW(),"mm/dd/yy")#</strong>.</p>
						
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
					<cfset application.emailManager.reactivateL365Confirmation(emailTo=emailID, emailSubject="Reactived Learn365 Membership Confirmation", emailBody=emailMessage,bccTo=bccEmail)>    
					
					<cfcatch type="any"></cfcatch>
				</cftry>
			</cfloop>
			</cfoutput>
					
			<!--- END EMAIL --->
			
			
			<!--- redirect to profile --->
			<cflocation url="/learn365-profile?reactivate=1">
		<cfelse>
			<!--- stop processing, send user info about why transaction failed --->
			<!--- <cfoutput>#getResponse.RESPMSG#</cfoutput> --->
			<cfset errMsg = "<strong>Warning!</strong><br> #getResponse.RESPMSG#">
		</cfif>
</cfif>

<cfoutput>
<div class="page-spacer"></div>
<form action="" method="post" name="L365Profile" onSubmit="return checkLearn365Form();" autocomplete="off">
<div class="container">
	<div class="row-fluid">
		<div class="span12">
			<h1>Membership Billing Set Up</h1>
			
			<div class="row-fluid">
				<cfif len(errMsg)>
					<div class="alert alert-error" id="displaySave_account">
						<button type="button" class="close" data-dismiss="alert">&times;</button>
						#errMsg#
					</div>
				<cfelse>
					
						<div class="alert alert-info" id="displaySave_account">
							<button type="button" class="close" data-dismiss="alert">&times;</button>
							<strong>Reactivate Now!</strong><br>Complete the form and become a Learn365 member again!
						</div>
					
				</cfif>
			</div>
		</div>
	</div>

	<div class="row-fluid">
		<div class="span6">
			<div class="row-fluid">
				<div class="accountprofile" style="height:290px">
					<h3>Billing Address Details</h3>
					<div class="row-fluid">
						<div class="span8"><input name="phonenumber" type="text" class="input input-medium span12" id="phonenumber" tabindex="3" placeholder="Phone Number" value="#phonenumber#" maxlength="20"></div>
						
					</div>
					<div class="row-fluid">
						<div>
							<input tabindex="17" id="strAddress1" name="strAddress1" type="text" value="#strAddress1#" class="input input-small span12 requiredField" maxlength="145" placeholder="Address 1" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';};">
						</div>
					</div>
					<div class="row-fluid">
						<div>
							<input tabindex="17" id="strAddress2" name="strAddress2" type="text" value="#strAddress2#"  class="input input-medium span12" maxlength="145" placeholder="Address 2" onFocus="this.style.borderColor = '';">
						</div>
					</div>
					<div class="row-fluid">
						<div>
							<input tabindex="17" id="strCity" name="strCity" type="text" value="#strCity#" class="input input-medium span12 requiredField" maxlength="60" placeholder="City" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; ">
						</div>
					</div>
					<div class="row-fluid">
						<div class="span6">
							
							<select id="strState" class="input input-medium span12 requiredField" name="strState" tabindex="17">
								<option value="">State</option>
								<cfloop index="request.s" from="1" to="#arrayLen(request.ary_states)#">
									
									<option value="#request.ary_states[request.s][2]#" <cfif strState EQ request.ary_states[request.s][2]>selected="true"</cfif>> #request.ary_states[request.s][2]# </option>
								</cfloop>
							</select>
						</div>
						<div class="span6">
						
							<input tabindex="17" id="strZipCode" name="strZipCode" type="text" value="#strZipCode#" class="input input-medium span12 requiredField" maxlength="19" placeholder="Zip Code" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; ">
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="span6">
			<div class="row-fluid">
				<div class="accountprofile" style="height:290px">
					<h3>Credit Card Information</h3>
					<div class="row-fluid">
						<div>
							<input id="cardName"  type="text" name="cardName" value="#cardName#" size="28" maxlength="50" placeholder="Name on Card" class="input input-medium span12 requiredField">
						</div>
					</div>
					<div class="row-fluid">
						<div>
							<select  id="strCardType"  name="strCardType" class="input input-small span12 requiredField">
								<option value="">Choose Credit Card
								<option value="mc" <cfif strCardType eq "mc">selected</cfif>>MasterCard</option>
								<option value="visa" <cfif strCardType eq "visa">selected</cfif>>Visa</option>
								<option value="amex" <cfif strCardType eq "amex">selected</cfif>>Amex</option>
								<option value="discover" <cfif strCardType eq "discover">selected</cfif>>Discover</option>
								<option value="diners" <cfif strCardType eq "diners">selected</cfif>>Diners Club</option>
							</select>
						</div>
					</div>
					<div class="row-fluid">
						<div>
							<input id="cardNumber" autcomplete="off" type="text" name="cardNumber" value="#cardNumber#" size="28" maxlength="25" placeholder="Credit Card Number" class="input input-medium span12 requiredField">
						</div>
					</div>
					<div class="row-fluid">
						<div class="span4">
							<select id="cardMonth" name="cardMonth" class="input input-medium span12 requiredField">
							<option value="">Card Month</option>
							<option value="01" <cfif cardMonth eq "01"> selected</cfif> > 01 </option>
							<option value="02" <cfif cardMonth eq "02"> selected</cfif> > 02 </option>
							<option value="03" <cfif cardMonth eq "03"> selected</cfif> > 03 </option>
							<option value="04" <cfif cardMonth eq "04"> selected</cfif> > 04 </option>
							<option value="05" <cfif cardMonth eq "05"> selected</cfif> > 05 </option>
							<option value="06" <cfif cardMonth eq "06"> selected</cfif> > 06 </option>
							<option value="07" <cfif cardMonth eq "07"> selected</cfif> > 07 </option>
							<option value="08" <cfif cardMonth eq "08"> selected</cfif> > 08 </option>
							<option value="09" <cfif cardMonth eq "09"> selected</cfif> > 09 </option>
							<option value="10" <cfif cardMonth eq "10"> selected</cfif> > 10 </option>
							<option value="11" <cfif cardMonth eq "11"> selected</cfif> > 11 </option>
							<option value="12" <cfif cardMonth eq "12"> selected</cfif> > 12 </option>
							</select>
							
						</div>
						<div class="span4">
							<select id="cardYear"  name="cardYear" class="input input-medium span12 requiredField">
							<option value="">Card Year</option>
							<cfloop from="#year(now())#" to="#(year(now()) +10)#" index="yearLoop">
							<option value="#yearLoop#" <cfif cardYear eq "#yearLoop#"> selected</cfif> > #yearLoop#</option>
							</cfloop>
							</select>
						</div>
						<div class="span4">
							<input  id="securityCode"  type="text" name="securityCode" value="#securityCode#" size="10" maxlength="4" placeholder="Security Code" class="input input-medium span12 requiredField">
						</div>
					</div>
					
				</div>
				
			</div>
		</div>
	</div>
	<div class="page-spacer"></div>
	
	<div class="row-fluid">
		<div class="span12 accountprofile">
			<!--- left  start --->
			<div class="row-fluid">
				<div class="span12">
				<h3>Learn365 - Simple. Everyday. Learning.</h3>
				</div>
			</div>
			<div class="row-fluid">
				<div class="span6" >
						<div>eLearning solution for business professionals</div>
						<div  class="page-spacer"></div>
						<div>Month-to-Month, cancel at anytime<br>
						$19.95/month</div>
						<div  class="page-spacer"></div>
						<div>Learn a new skill every day or take a skill to the next level. 
								Be Inspired. Create new opportunities. Open new doors for 
								your career.</div>
				</div>
				<div class="span6" >
						
						<div>What's included:</div>
						<div><i class="fa fa-play-circle-o fa-lg membershipIcon"></i>&nbsp;&nbsp;Unlimited Access to our entire library, always!</div>
						<div  class="page-spacer"></div>
						<div ><i class="fa fa-cloud fa-lg membershipIcon"></i>&nbsp;&nbsp;New Courses added monthly</div>
						<div  class="page-spacer"></div>
						<div><i class="fa fa-trophy fa-lg membershipIcon"></i>&nbsp;&nbsp;History of completed and in progress learning</div>
						<div  class="page-spacer"></div>
						<div><i class="fa fa-certificate fa-lg membershipIcon"></i>&nbsp;&nbsp;Inspiration!</div>
						
				</div>
			</div>
			
			<!--- left  end --->	
		</div>
	</div>
	<div class="page-spacer"></div>
	<div class="row-fluid">
		<div class="span12">
		<label class="checkbox inline" id="terms"><input type="checkbox" name="blnTermsConditions" id="blnTermsConditions" value="1" <cfif blnTermsConditions>checked</cfif>>I agree to the <a href="/terms" target="_blank">terms of service & privacy policy</a>.</label>
		</div>
	</div>
	<div class="page-spacer"></div>
	<div class="row-fluid">
		<div class="span12">
		<label class="checkbox inline"><input type="checkbox" name="blnL365Newsletter" id="blnL365Newsletter" value="1" <cfif blnL365Newsletter>checked</cfif>> I would like to receive the monthly Litmos eLearning tips and tricks newsletter.</label>
		</div>
	</div>
	<div class="page-spacer"></div>
	<div class="row-fluid">
		<div>
			
			<input type="submit" value="Activate Membership" class="btn btn-primary btn-large"> &nbsp;&nbsp;&nbsp; <a href="/learn365-profile">No Thanks!</a>
			<br>
			<input name="firstName" type="hidden" id="firstName" value="#firstName#">
			<input name="lastName" type="hidden" id="lastName" value="#lastName#">
			<input name="email" type="hidden" id="email" value="#email#">
			<input type="hidden" name="frm6FJLead" value="#bln6FJLead#"> 
			<input type="hidden" name="intResID" value="#intResID#"> 
			<input type="hidden" name="blnLearn365" value="#blnLearn365#"> 
		</div>
	</div>
</div>
</cfoutput>

</form>

<script language="javascript">
	function checkLearn365Form(){
	
		var errormsg = '';
 		var errNum=0;
					
		//Phone
			if (document.L365Profile.phonenumber.value == '' || document.L365Profile.phonenumber.value == 'Phone Number'){
				document.getElementById('phonenumber').style.borderColor = '#F00';
				errNum+=1;
			}	
			
		//Address 1
			if (document.L365Profile.strAddress1.value == '' || document.L365Profile.strAddress1.value == 'Address 1'){
				document.getElementById('strAddress1').style.borderColor = '#F00';
				errNum+=1;
			}
			
		//City
			if (document.L365Profile.strCity.value == '' || document.L365Profile.strCity.value == 'City'){
				document.getElementById('strCity').style.borderColor = '#F00';
				errNum+=1;
			}
			
		//State
			if (document.L365Profile.strState.value == ''){
				document.getElementById('strState').style.borderColor = '#F00';
				errNum+=1;
			}
			
		//Zip Code
			//if (document.L365Profile.strState.value == ''){
				//document.getElementById('strState').style.borderColor = '#F00';
				//errNum+=1;
			//}
			
		//Card Name
			if (document.L365Profile.cardName.value == '' || document.L365Profile.cardName.value == 'Name on Card'){
				document.getElementById('cardName').style.borderColor = '#F00';
				errNum+=1;
			}
			
		//Card Type
			if (document.L365Profile.strCardType.value == ''){
				document.getElementById('strCardType').style.borderColor = '#F00';
				errNum+=1;
			}
			
		//Card Number
			if (document.L365Profile.cardNumber.value == '' || document.L365Profile.cardNumber.value == 'Credi Card Number'){
				document.getElementById('cardNumber').style.borderColor = '#F00';
				errNum+=1;
			}
			
		//Card Month
			if (document.L365Profile.cardMonth.value == ''){
				document.getElementById('cardMonth').style.borderColor = '#F00';
				errNum+=1;
			}
			
		//Card Year
			if (document.L365Profile.cardYear.value == ''){
				document.getElementById('cardYear').style.borderColor = '#F00';
				errNum+=1;
			}
			
		//Card Security Code
			if (document.L365Profile.securityCode.value == '' || document.L365Profile.securityCode.value == 'Security Code'){
				document.getElementById('securityCode').style.borderColor = '#F00';
				errNum+=1;
			}
			
		//Terms
			if (!document.getElementById('blnTermsConditions').checked){
				document.getElementById('terms').style.color = '#F00';
				errNum+=1;
			
			}
				
			
		//Errors
		if (errNum > 0){
			return false;
			document.getElementById('submitBtn').style.visibility = "visible";
			document.getElementById('errorDiv').style.display = "block";
			
			//Scroll to the top		
			$("html, body").animate({ scrollTop: 0 }, "fast");
			
		}else{
			$("#submitBtn").attr("disabled", "disabled");
			document.getElementById('errorDiv').style.display = "none";
			return true ;
		}
	} 

</script>
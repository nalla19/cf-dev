<cfif isdefined("url.login")>
				<cfstoredproc procedure="sp_exec_login" datasource="#application.dsn#" returncode="Yes">
					<cfprocparam type="IN" variable="@username" value="#form.strUsername#" cfsqltype="CF_SQL_VARCHAR">
					<cfprocparam type="IN" variable="@password" value="#form.strPassword#" cfsqltype="CF_SQL_VARCHAR">
					<cfprocparam type="IN" variable="@sourceApp" value="#application.sourceApp#" cfsqltype="CF_SQL_VARCHAR">
					<cfprocparam type="OUT" variable="proc_returnCode" cfsqltype="CF_SQL_INTEGER">
					<cfprocresult resultset="1" name="cfqExecLogin">
				</cfstoredproc>
				
				<cfswitch expression="#proc_returnCode#">
					<cfcase value="1">
						<cfset intResID = cfqExecLogin.intresid>
						<!--- <cfoutput>#intResID#</cfoutput>
						<cfdump var="#cfqExecLogin#">
						<cfabort> --->
						<cfinclude template="../join/joinLogin.cfm">
						
						<!--- create auto login cookie --->
						 <cfset strRememberMe = (
							CreateUUID() & ":" &
							#getUserInfo.username# & ":" &
							#getUserInfo.password# & ":" &
							"6FJ:" &
							CreateUUID()
							) />
					
						<!--- Encrypt the value. --->
						<cfset strRememberMe = Encrypt(
							strRememberMe,
							application.encryptionKeyRM,
							"AES",
							"hex"
							) />
					
						<!--- Store the cookie such that it never expires. --->
					   <cfcookie
							name="RememberMe"
							value="#strRememberMe#"
							expires="never"
							/>
						</cfcase>
						<cfdefaultcase>
							<cflocation url="#application.url#/member-invalid-login" addtoken="no">
							<cfabort>
						</cfdefaultcase>
					</cfswitch>

</cfif>

<!--- <cfif isDefined("cookie.sixFJResTracker")>

cookie.sixFJResTracker - <cfoutput>#cookie.sixFJResTracker#</cfoutput>
</cfif> --->
<cfparam name="form.blnTermsConditions" default="0">
<cfparam name="form.blnL365Newsletter" default="1">
<cfparam name="form.bln6FJAccount" default="0">

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
<cfparam name="blnLearn365Lead" default=0>
<cfparam name="blnTermsConditions" default=0>
<cfparam name="blnL365Newsletter" default=1>
<cfparam name="bln6FJAccount" default=0>



<cfparam name="tCode" default="-1">

<cfparam name ="errMsg" default="">


<cfif isDefined("url.dupe")>
	<cfset errMsg = "<strong>Account Exists!</strong><br> The email address you entered is already a Learn365 member. Sign in now to start learning!">
</cfif>

<cfif isDefined("url.dupe2")>
	<cfset errMsg = "<strong>Account Exists!</strong><br> The email address you entered is already a 6FigureJobs member. Sign in now to create your account!">
</cfif>

<cfif isDefined("url.dupe3")>
	<cfset errMsg = "<strong>Account Exists!</strong><br> The email address you entered is already a Learn365 member. Contact support for more information.">
</cfif>

<cfif isDefined("url.reactivate")>
	<cfset errMsg = "<strong>Activate Your Account!</strong><br> The email address you entered is an inactive account. Sign in now to activate your account!">
</cfif>

<!--- if logged in and not a learning user, get all their 6FJ --->
<cfif (isdefined("session.exec.blnValidLogin") and session.exec.blnValidLogin) and (isdefined("session.exec.blnLearn365") and not session.exec.blnLearn365)>
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
<!--- coming from 6FJ step2 --->	
<cfelseif isDefined("url.Fy4ZT9ZUv")>	
	<cfscript>
	//Get the decrypted intResID
	intResID = application.registration.getDecryptedResID(url.Fy4ZT9ZUv);
	</cfscript>
	
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
		WHERE intResID = #intResID#
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
	<cfset bln6FJLead = 1>
<cfelse>

	<!--- take them to their learning dashboard --->
	<cfif (isdefined("session.exec.blnValidLogin") and session.exec.blnValidLogin) and (isdefined("session.exec.isLearn365Active") and session.exec.isLearn365Active)>
		<cflocation url="/learn365-dashboard">
	<cfelse>
		<cflock scope="session" timeout="10" type="Exclusive">
		 <cfif not StructIsEmpty(session)> 
          <cfset strSesionKeys=StructKeyList(session)>
          <cfloop list="#strSesionKeys#" index="ListElement">
           <cfset rc=StructDelete(session, "#ListElement#", "True")>
          </cfloop>
         </cfif>
        </cflock>
		
	</cfif>
	
</cfif>



<!---  form submission --->
<cfif isdefined("form.fieldnames") and isdefined("form.firstName")>
	


	<!---Check if a new learn365 User & new 6FJ User --->
	<cfset firstName=form.firstName>
	<cfset lastName=form.lastName>
    <cfset email=form.email>
    <cfset password=form.password>
	
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
	<cfset bln6FJAccount = form.bln6FJAccount>
	
	<!--- check here if email is duplicate. if it is, send them to sign in and send them to sign up page. --->
	<cfquery name="checkLearn365User" datasource="#application.dsn#">
		select * from tblLearn365Users
		where learn365Username = '#email#'
	</cfquery>
	
	<cfif checkLearn365User.recordcount GT 0 and checkLearn365User.blnActive EQ 1>
	<!--- user's email exists --->
	<!--- send them over to exits page to sign in --->
	<cfif bln6FJLead>
		<cflocation url="/join-step3b?Fy4ZT9ZUv=#URLEncodedFormat(url.Fy4ZT9ZUv)#&dupe=1">
	<cfelse>
		<cflocation url="/learn365-signup?dupe=1">
	</cfif>
		
		<cfabort>
	</cfif>
	
	
	<cfif checkLearn365User.recordcount GT 0 and checkLearn365User.blnActive EQ 0>
	<!--- user's email exists --->
	<!--- send them over to exits page to sign in --->
		<cfif bln6FJLead>
			<cflocation url="/join-step3b?Fy4ZT9ZUv=#URLEncodedFormat(url.Fy4ZT9ZUv)#&reactivate=1">
		<cfelse>
			<cflocation url="/learn365-signup?reactivate=1">
		</cfif>
		
		<cfabort>
	</cfif>
	
	<cfif intResID EQ "">
		<cfquery name="check6FJUser" datasource="#application.dsn#">
			select * from tblResumes
			where email = '#email#'
			
		</cfquery>
		
		<cfif check6FJUser.recordcount GT 0 and check6FJUser.blnLearn365 EQ 0>
		<!--- user's email exists --->
		<!--- send them over to exits page to sign in --->
		
			<cfif bln6FJLead>
				<cflocation url="/join-step3b?Fy4ZT9ZUv=#URLEncodedFormat(url.Fy4ZT9ZUv)#&dupe2=1">
			<cfelse>
				<cflocation url="/learn365-signup?dupe2=1">
			</cfif>
		
			
			<cfabort>
		</cfif>
	</cfif>	
	
	
	
	<cfif intResID EQ "">	
		<cfif isDefined("cookie.sixFJResTracker") and cookie.sixFJResTracker neq "">
		    <!---This is the intTrackingID--->
			<cfset trackingID = cookie.sixFJResTracker>
			<cfif not isnumeric(trackingID)>
				<cfquery name="cfqGetLeadID" datasource="#application.dsn#">
					select intTrackingID
					from tblHowFindTracking (nolock)
					where strTrackCode = <cfqueryparam value="#trackingID#" cfsqltype="cf_sql_varchar" />
				</cfquery>
				<cfset trackingID = cfqGetLeadID.intTrackingID>
			</cfif>
			
	        <!---Get the tracking Code--->
	        <cfquery name="cfqGettCode" datasource="#application.dsn#">
	        	select strTrackCode 
				from tblHowFindTracking (nolock) 
				where intTrackingID = <cfqueryparam value="#trackingID#" cfsqltype="cf_sql_integer" />
	        </cfquery>
	       	<cfif cfqGettCode.recordcount gt 0>
		       	<cfset tcode = cfqGettCode.strTrackCode>
	       </cfif>
	    </cfif>
			
		<!--- new account & set intResID--->
		<cfscript>
			//Register the user
			request.intResID = application.registration.execStep1Registration(fname=firstName, lname=lastName, email=email, passwd=password, sourceApp=application.sourceApp, tCode=tCode);
			theKey=generateSecretKey('AES');
			encryptedResID = application.registration.getEncryptedResID(request.intResID);
		</cfscript>
		
		<cfset intResID = request.intResID>
		
		
	</cfif>		
	
	<cfif not bln6FJLead>
		<cfif bln6FJAccount>
			<cfset blnHide6FJ = 0>
		<cfelse>
			<cfset blnHide6FJ = 1>
		</cfif>
		<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
			update tblResumes  set
			blnLearn365Lead = 1,
			blnHide6FJBtn  = #blnHide6FJ#
			where intResid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cfif>
	
	<!--- get components ready --->
	<cfscript>
	payPalObj 	= application.payflowpro;
	resObj 		= application.resume;
	qProfile 	= resObj.getResumeDetail(intResID); 
	premiumObj 	= application.premium;
	</cfscript>
	<!--- create litmos user and make sure not dupe in system --->
	
	
	
	
	
	<!--- <cfif form.intResID NEQ "">  --->
		<!--- existing 6FJ account --->
		<!--- <cfif not blnLearn365> --->
			<!--- update profile w/ form  --->		  
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
			
			
		
			<!--- Run card through PayPal --->
			<cfsilent>
			<cfinvoke component="#payPalObj#" method="setPremiumSubscription" returnvariable="qTransaction">
				<cfinvokeargument name="intresid" value="#intresid#"/>
				<cfinvokeargument name="premiumid" value="1"/>
				<cfinvokeargument name="isRenewable" value="1"/>
				<cfinvokeargument name="acct" value="#form.cardnumber#"/>
				<cfinvokeargument name="expdate" value="#form.cardmonth##form.cardyear#"/>
				<cfinvokeargument name="cvv2" value="#form.securityCode#"/>
				<cfinvokeargument name="firstname" value="#firstName#"/>
				<cfinvokeargument name="Lastname" value="#lastName#"/>
				<cfinvokeargument name="email" value="#email#"/>
				<cfinvokeargument name="address1" value="#strAddress1#"/>
				<cfinvokeargument name="phone" value="#iif(len(phonenumber),de(phonenumber),de(phonenumber))#"/>
				<cfinvokeargument name="City" value="#strCity#"/>
				<cfinvokeargument name="State" value="#strState#"/>
				<cfinvokeargument name="ZIP" value="#strZipCode#"/>
				<cfinvokeargument name="Country" value="US"/>
				<cfinvokeargument name="ipaddress" value="#cgi.REMOTE_ADDR#"/>
			</cfinvoke>
			</cfsilent>
			<!--- <cfdump var="#qTransaction#"> --->
			<cfscript>
			if (isdefined("qTransaction.authcode")){  authcode = qTransaction.authcode; } else{ authcode = ""; }
			if (isdefined("qTransaction.profileid")){ profileid = qTransaction.profileid; } else{ profileid = ""; }
			if (isdefined("qTransaction.RPREF")){ RPREF = qTransaction.RPREF; }else{ RPREF = "";}
			//Address
			if (isdefined("qTransaction.AVSADDR")){ avsAddr = qTransaction.AVSADDR; } else{ avsAddr =  "";}
			if (isdefined("qTransaction.AVSZIP")){ avsZip = qTransaction.AVSZIP; } else{ AVSZIP = "";	 }
			//Recurring Model	
			if (isdefined("qTransaction.TRXPNREF")){ TRXPNREF = qTransaction.TRXPNREF; } else{ TRXPNREF = "";	 }
			if (isdefined("qTransaction.TRXRESPMSG")){ TRXRESPMSG = qTransaction.TRXRESPMSG; } else{ TRXRESPMSG = "";	 }	
			 
			 cost = payPalObj.getPremiumObj(1).intialcost;
			 cost = numberformat(cost, "______.__"); 
			 months =  payPalObj.getPremiumObj(1).months;
			</cfscript>
		
		<!--- Send Email Saying OK --->
		<!--- <cfif (qTransaction.RC eq 0 and qTransaction.RESULT eq 0 and qTransaction.RESPMSG eq "Approved")> --->
		<cfif (isDefined("qTransaction.RESULT") and qTransaction.RESULT eq 0 and isDefined("qTransaction.RESPMSG") and qTransaction.RESPMSG eq "Approved")>
			<cfset intresid = intresid />
			<cfset email = email />
			<cfset RPREF =  qTransaction.RPREF />
			<!--- Include Email Page --->
			<cfset session.exec.blnLearn365 = 1 />
			<!---send the confirmation email--->
			<!--- <cfinclude template="/6fj/execs/premium/_includes/emailconfirmation.cfm" /> --->
			<!--- Log Transaction --->
			<cfinvoke component="#premiumObj#" method="setPremiumTransaction">
				<cfinvokeargument name="authCode" value="#authcode#"/>
				<cfinvokeargument name="intresid" value="#intresid#"/>
				<cfinvokeargument name="name" value="#firstName# #lastname#"/>
				<cfinvokeargument name="email" value="#email#"/>
				<cfinvokeargument name="cardtype" value="#form.strCardType#"/>
				
				<cfinvokeargument name="cardnumber" value="#right(form.cardnumber,4)#"/>
				<cfinvokeargument name="cscCode" value=""/>
				<!--- Card Security Code --->
				<cfinvokeargument name="expDate" value="#form.cardMonth#/#form.cardYear#"/>
				<cfinvokeargument name="responseCode" value="#ucase(qTransaction.result)#"/>
				<cfinvokeargument name="responseDesc" value="#qTransaction.RESPMSG#"/>
				<cfinvokeargument name="transid" value="#RPREF#"/>
				<cfinvokeargument name="TransactionID" value="#TRXPNREF#"/>
				<cfinvokeargument name="TransactionMsg" value="#iif(TRXRESPMSG eq 'Approved',de('Active'),de(TRXRESPMSG))#"/>
				<cfinvokeargument name="cost" value="#cost#"/>
				<cfinvokeargument name="months" value="#months#"/>
				<cfinvokeargument name="ipaddress" value="#cgi.REMOTE_ADDR#"/>
				<cfinvokeargument name="avsAddrResp" value="#AVSADDR#"/>
				<cfinvokeargument name="AvsZipResp" value="#AVSZIP#"/>
				<cfinvokeargument name="profileid" value="#profileid#"/>
			</cfinvoke>
		</cfif>
		
		<cfif isDefined("qTransaction.RESULT") and  qTransaction.RESULT eq 0 and isDefined("qTransaction.RESPMSG") and qTransaction.RESPMSG eq "Approved">
			<!--- what if something goes wrong, how do we handle that? --->
				<!--- Create 365Login --->
				<cfset learn365Username = '#qProfile.email#'>
				<cfset learn365FirstName = '#qProfile.fName#'>
				<cfset learn365LastName = '#qProfile.lName#'>
				
				<cfinclude template="api/addNewUser.cfm">
				
				<cfif learn365UserId is "">
					
					<cfmail to="irodela@calliduscloud.com" from="support@6figurejobs.com" subject="Failed Litmos Creation">
						User already in Litmos
						Email: #qProfile.email#
						Resume ID: #intresid#
					</cfmail>
				<cfelse>
				<!--- Add to Learn365 Team --->
				<cfinclude template="api/addUserToTeam.cfm">
				
				
				</cfif>
			
			
			<cfquery name="insertLearn365User" datasource="#application.dsn#">
				INSERT INTO [tblLearn365Users]
					   ([intResId]
					   ,[learn365UserId]
					   ,[learn365Username]
					   ,[dteCreated]
					   ,[blnActive])
				 VALUES
					   (<cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
					   ,<cfqueryparam value="#learn365UserId#" cfsqltype="CF_SQL_VARCHAR" />
					   ,<cfqueryparam value="#learn365Username#" cfsqltype="CF_SQL_VARCHAR" />
					   ,getDate()
					   ,1)
			</cfquery>
			
			<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
				update tblResumes  set
				blnLearn365 = 1,
				profileID = <cfqueryparam value="#profileid#" cfsqltype="CF_SQL_VARCHAR" />
				where intResID =<cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfif frm6FJLead>
				<!---Update tblREsumes for the listcompletedsteps--->
				<cfquery name="cfqUpdResumes" datasource="#application.dsn#">
				update tblResumes set listcompletedsteps = '1,2,3', intadmcode = 2 where intResID = #intResID#
				</cfquery>
				<!---Update tblResumes so that we set to show the CPL Step again upon the registration is approved --->
				<cfquery name="request.cfqCheckStep3" datasource="#application.dsn#">
				update tblResumes set blnCPLPageVisited = 0 where intResID = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
				</cfquery>
				
				<!--- send email --->
				
				<cfset email = qprofile.email>
				<!--- <cfset email = "irodela@calliduscloud.com">  --->
				
				<!---Send the Thank you registering/Confirmation email (for for 6figurejobs because of the wait to be approved process)--->
				<cfif application.sourceApp EQ "6FigureJobs" AND isValid("email",email)>
					<cfquery name="cfqGetfname" datasource="#application.dsn#">
						SELECT fname 
						FROM tblResumes (nolock) 
						WHERE intresid = #intresid# 
					</cfquery>
					<cfset fname = cfqGetfname.fname />
					
					<cfif cgi.http_host contains "uat2" or cgi.http_host contains "uat" or cgi.http_host contains "dev">
						<cfset email = 'irodela@calliduscloud.com'>
					</cfif>
					
					<cfif isDefined("email") AND isDefined("fname")>
						<cfset application.emailManager.sendThankYouEmail(emailTo=email,firstname=fname,theLearn365=1)>
					</cfif>
					
					<!--- send Learn365 --->
					<cfif cgi.http_host contains "uat2" or cgi.http_host contains "uat" or cgi.http_host contains "dev">
						<cfset bccEmail = 'irodela@calliduscloud.com'>
					<cfelse>
						<cfset bccEmail = 'msaddoris@calliduscloud.com,irodela@calliduscloud.com,rcameron@calliduscloud.com'>
					</cfif>
					
					<cfif isDefined("email") AND isDefined("fname")>
						<cfset application.emailManager.sendL365ThankYouEmail(emailTo=email,firstname=fname,bccTo=bccEmail)>
					</cfif>
				</cfif>
				
				<!--- <cflocation url="thankyou.cfm?Fy4ZT9ZUv=#URLEncodedFormat(url.Fy4ZT9ZUv)#" addtoken="no"> --->
				<cfinclude template="../join/joinLogin.cfm">
				
				<!--- create auto login cookie --->
				 <cfset strRememberMe = (
					CreateUUID() & ":" &
					#getUserInfo.username# & ":" &
					#getUserInfo.password# & ":" &
					"6FJ:" &
					CreateUUID()
					) />
			
				<!--- Encrypt the value. --->
				<cfset strRememberMe = Encrypt(
					strRememberMe,
					application.encryptionKeyRM,
					"AES",
					"hex"
					) />
			
				<!--- Store the cookie such that it never expires. --->
			   <cfcookie
					name="RememberMe"
					value="#strRememberMe#"
					expires="never"
					/>
					
				<cflocation url="/join-thank-you?Fy4ZT9ZUv=#URLEncodedFormat(url.Fy4ZT9ZUv)#&learn365=1" addtoken="no">
			
			<cfelse>
				<!--- Go to thank you page & log user in! --->
				<!--- send email --->
				
				 <cfset email = qprofile.email>
				
				<!---Send the Thank you registering/Confirmation email (for for 6figurejobs because of the wait to be approved process)--->
				<cfif application.sourceApp EQ "6FigureJobs" AND isValid("email",email)>
					<cfquery name="cfqGetfname" datasource="#application.dsn#">
						SELECT fname 
						FROM tblResumes (nolock) 
						WHERE intresid = #intresid# 
					</cfquery>
					<cfset fname = cfqGetfname.fname />
					
					<cfif cgi.http_host contains "uat2" or cgi.http_host contains "uat" or cgi.http_host contains "dev">
						<cfset bccEmail = 'irodela@calliduscloud.com'>
					<cfelse>
						<cfset bccEmail = 'msaddoris@calliduscloud.com,irodela@calliduscloud.com,rcameron@calliduscloud.com'>
					</cfif>
					
					
					<cfif isDefined("email") AND isDefined("fname")>
						<cfset application.emailManager.sendL365ThankYouEmail(emailTo=email,firstname=fname,bccTo=bccEmail)>
					</cfif>
				</cfif>
				<cfinclude template="../join/joinLogin.cfm">
				
				<!--- create auto login cookie --->
				 <cfset strRememberMe = (
					CreateUUID() & ":" &
					#getUserInfo.username# & ":" &
					#getUserInfo.password# & ":" &
					"L365:" &
					CreateUUID()
					) />
			
				<!--- Encrypt the value. --->
				<cfset strRememberMe = Encrypt(
					strRememberMe,
					application.encryptionKeyRM,
					"AES",
					"hex"
					) />
			
				<!--- Store the cookie such that it never expires. --->
			   <cfcookie
					name="RememberMe"
					value="#strRememberMe#"
					expires="never"
					/>
					
				<cflocation url="/learn365-thankyou">
				<cfabort>
			
			</cfif>
			
			<!--- what if user exists? how do we handle? --->
			
		<cfelse>
			<cfscript>
				// Sorry
				errMsg= "&nbsp;<strong>An error occurred with your credit card submission.</strong><br>";
				errMsg = errMsg & "<ul>";
				if (isdefined("qTransaction.TRXRESPMSG")){
					errMsg = errMsg & "<li>&nbsp;#qTransaction.TRXRESPMSG#</li>";
				}else{
					errMsg = errMsg & "<li>&nbsp;#qTransaction.RESPMSG#</li>";				
				}
				errMsg = errMsg & "</ul>";	
			</cfscript>
		</cfif>
</cfif>

<cfoutput>
<div class="page-spacer"></div>
<form action="" method="post" name="L365Profile" onSubmit="return checkLearn365Form();" autocomplete="off">
<div class="container">
	<div class="row">
		<div class="span12">
			<h1>Membership Billing Set Up</h1>
			<div class="row-fluid">
				<cfif len(errMsg)>
					<div class="alert alert-error" id="displaySave_account">
						<button type="button" class="close" data-dismiss="alert">&times;</button>
						#errMsg#
					</div>
				<cfelse>
					<cfif not isdefined("session.exec.blnValidLogin") and not bln6FJLead>
						<div>
							<div class="alert alert-info" id="displaySave_account">
								<button type="button" class="close" data-dismiss="alert">&times;</button>
								<strong>Are you a 6FigureJobs member?</strong><br>Sign in and we'll pull your information over and you can join even faster! <a href="##signin2" data-toggle="modal" class="signin-link">Sign In</a>
							</div>
							<div class="signin modal modal2 hide fade" id="signin2">
								<ul class="signin-nav row-fluid">
									<li class="active"><nobr><a href="##members" class="tab" data-toggle="tab">Learn365 Members</a></nobr></li>
								</ul>
								<cfoutput>
								<div class="tab-content signin-members<cfif request.signinactivetab EQ 'member'> active</cfif>" id="members">
									
									<form action="/learn365-signup?login=y" method="post" id="signin6FJ">
										<cfif isDefined("request.intJobId") and len(request.intJobId)>
											<input type="hidden" name="strCaller" value="execOneClickApply">
										</cfif>
										<div><input name="strUsername" id="strUsername" type="text" class="input input-small" placeholder="Username"></div>
										<div><input name="strPassword" id="strPassword" type="password" class="input input-small" placeholder="Password"></div>
										<p class="submit-wrap">
											<label class="checkbox inline" id="blnRememberMe"><input type="checkbox" name="blnRememberMe" id="blnRememberMe" value="1" checked> Keep me logged in</label>
											<br><br>
											<button type="submit" class="btn btn-primary btn-small btn-signin">Sign in</button>
											<a href="/member-password">Forgot your password?</a>
										</p>
										<!--- 
										<p class="submit-wrap" style="margin-top:25px;">
											<a href="/home">Click here to sign in with 6FigureJobs.</a>
										</p> --->
										<input type="hidden" name="strloginLoc" value="L365">
									</form>
									
								</div>
								</cfoutput>
							</div><!-- /.signin -->
						</div>
					</cfif>
				</cfif>
			</div>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span12 accountprofile">
			<!--- left  start --->
			<div class="row-fluid">
				<div class="span12">
				<h3>eLearning solution for business professionals</h3>
				</div>
			</div>
			<div class="row-fluid">
				<div class="span6" >
						<!--- <div>eLearning solution for business professionals</div>
						<div  class="page-spacer"></div>
						<div>Month-to-Month, cancel at anytime<br>
						$19.95/month</div>
						<div  class="page-spacer"></div>
						<div>Learn a new skill every day or take a skill to the next level. 
								Be Inspired. Create new opportunities. Open new doors for 
								your career.</div> --->
					<div style="text-align:center; background-color:##1f0845;width:245px;height:212px;margin:0 auto;margin-top:10px;padding:10px 10px 10px 10px;">
					  <div style="vertical-align:middle;margin-top:55px">
						  <img src="/images/learn365/Learn365-SEL.png">
						  <br>
						  <h2 style="color:##FFFFFF;">$19.95</h2>
						  <p style="color:##FFFFFF; line-height:5px">PER MONTH</p>
						   <p style="color:##FFFFFF; margin-top:-15px;font-size:12px">Cancel anytime</p>
					  </div>
					</div>
					
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
						<div  class="page-spacer"></div>
						<div>Learn a new skill every day or take a skill to the next level. 
								Be Inspired. Create new opportunities. Open new doors for 
								your career.</div>
				</div>
			</div>
			
			<!--- left  end --->	
			<div  class="page-spacer"></div>
		</div>
		
	</div>
	<div  class="page-spacer"></div>
	<div class="row-fluid">
		<div class="span12">
			<!--- right start --->
			<div class="accountprofile" style="min-height:175px">
				<h3>Account Details</h3>
				<div class="row-fluid">
					<div class="span6"><input name="firstName" type="text" class="input input-medium span12" id="firstName" tabindex="1" placeholder="First Name" value="#firstName#" maxlength="60" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';};"></div>
					<div class="span6"> <input name="lastName" type="text" class="input input-medium span12" id="lastName" tabindex="2" placeholder="Last Name" value="#lastName#" maxlength="60" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';};"></div>
				</div>
				
				<div class="row-fluid">
					<div class="span6"><input name="email" type="text" maxlength="80" class="input input-medium span12" id="email" tabindex="3" placeholder="Email" value="#email#" <cfif isdefined("session.exec.blnValidLogin") or bln6FJLead>readonly</cfif> onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}<cfif isdefined("session.exec.blnValidLogin") or bln6FJLead><cfelse>else{checkEmail();}</cfif>;"></div>
				
					<div class="span6"><input name="password" type="password" maxlength="80" class="input input-medium span12" id="password" tabindex="3" placeholder="Password" value="#password#" <cfif isdefined("session.exec.blnValidLogin") or bln6FJLead>readonly</cfif> onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';};"></div>
				</div>
				<!---<cfif not isdefined("session.exec.blnValidLogin") and not bln6FJLead>
					 <div class="row-fluid">
						<div class="span12">
						<label class="checkbox inline" id="6FJAccount"><input type="checkbox" tabindex="3" name="bln6FJAccount" id="bln6FJAccount" value="1" <cfif bln6FJAccount>checked</cfif>>Yes, I want to create a <a href="/join" target="_blank">6FigureJobs</a> account too.</label>
						</div>
					</div> 
				<cfelse>--->
					<input type="hidden" value="1" name="bln6FJAccount">
				<!--- </cfif> --->
			</div>
		</div>
		<!--- account end --->	
	</div>
	<div  class="page-spacer"></div>
	<div class="row-fluid" >
		<!--- billing info --->
		<div class="span6" >
			<div class="accountprofile" style="min-height:300px">
				<h3>Billing Address Details</h3>
				<div class="row-fluid">
					<div class="span8"><input name="phonenumber" type="text" maxlength="20" class="input input-medium span12" id="phonenumber" tabindex="3" placeholder="Phone Number" value="#phonenumber#" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';};"></div>
					
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
						<input tabindex="17" id="strCity" name="strCity" type="text" value="#strCity#" class="input input-medium span12 requiredField" maxlength="19" placeholder="City" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; ">
					</div>
				</div>
				<div class="row-fluid">
					<div class="span6">
						
						<select id="strState" class="input input-medium span12 requiredField" name="strState" tabindex="17" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';};">
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
		<!--- billing info --->
		<!--- credit card --->
		<div class="span6" >
			<div class="accountprofile" style="min-height:300px">
				<h3>Credit Card Information</h3>
				<div class="row-fluid">
					<div>
						<input id="cardName"  type="text" name="cardName" value="#cardName#" size="28" maxlength="50" placeholder="Name on Card" class="input input-medium span12 requiredField" tabindex="18" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';};">
					</div>
				</div>
				<div class="row-fluid">
					<div>
						<select  id="strCardType" tabindex="18"  name="strCardType" class="input input-small span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';};">
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
						<input id="cardNumber" tabindex="18" autcomplete="off" type="text" name="cardNumber" value="#cardNumber#" size="28" maxlength="25" placeholder="Credit Card Number" class="input input-medium span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';};">
					</div>
				</div>
				<div class="row-fluid">
					<div class="span4">
						<select id="cardMonth" name="cardMonth" tabindex="18" class="input input-medium span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';};">
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
						<select id="cardYear"  name="cardYear" tabindex="18" class="input input-medium span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';};">
						<option value="">Card Year</option>
						<cfloop from="#year(now())#" to="#(year(now()) +10)#" index="yearLoop">
						<option value="#yearLoop#" <cfif cardYear eq "#yearLoop#"> selected</cfif> > #yearLoop#</option>
						</cfloop>
						</select>
					</div>
					<div class="span4">
						<input  id="securityCode"  tabindex="18" type="text" name="securityCode" value="#securityCode#" size="10" maxlength="4" placeholder="Security Code" class="input input-medium span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';};">
					</div>
				</div>
			</div>
		</div>
		<!--- credit card --->
	</div>
	<div class="page-spacer"></div>
	<div class="row-fluid">
		<div class="span12">
		<label class="checkbox inline" id="terms"><input type="checkbox" tabindex="18" name="blnTermsConditions" id="blnTermsConditions" value="1" <cfif blnTermsConditions>checked</cfif>>I agree to the <a href="/terms" target="_blank">terms of service & privacy policy</a>.</label>
		</div>
	</div>
	<div class="page-spacer"></div>
	<div class="row-fluid">
		<div class="span12">
		<label class="checkbox inline"><input type="checkbox" name="blnL365Newsletter" tabindex="18" id="blnL365Newsletter" value="1" <cfif blnL365Newsletter>checked</cfif>> I would like to receive the monthly Learn365 eLearning tips and tricks newsletter.</label>
		</div>
	</div>
	<div class="page-spacer"></div>
	<div class="row-fluid">
		<div>
			
			<input type="submit" value="Join Learn365" tabindex="18" class="btn btn-primary btn-large"> &nbsp;&nbsp;&nbsp; <cfif bln6FJLead><a href="/join-step3?Fy4ZT9ZUv=#URLEncodedFormat(url.Fy4ZT9ZUv)#">No Thanks!</a></cfif>
			<br>
			<input type="hidden" name="frm6FJLead" value="#bln6FJLead#"> 
			<input type="hidden" name="intResID" value="#intResID#"> 
			<input type="hidden" name="blnLearn365" value="#blnLearn365#"> 
		</div>
	</div>
</div>
</cfoutput>

</form>

<div id="myModaEmailCheck" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Learn365 - Simple. Everyday. Learning.</h3>
  </div>
  <div class="modal-body" id="dumphere">
    
  </div>
  <div class="modal-footer">
    <button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Close</button>
  </div>
</div>



<script language="javascript">
	function checkLearn365Form(){
	
		var errormsg = '';
 		var errNum=0;
		//First Name
			if (document.L365Profile.firstName.value == '' || document.L365Profile.firstName.value == 'First Name'){
				document.getElementById('firstName').style.borderColor = '#F00';
				errNum+=1;
			}	
			
		//Last Name
			if (document.L365Profile.lastName.value == '' || document.L365Profile.lastName.value == 'Last Name'){
				document.getElementById('lastName').style.borderColor = '#F00';
				errNum+=1;
			}	
			
		//Email
			if (document.L365Profile.email.value == '' || document.L365Profile.email.value == 'Email'){
				document.getElementById('email').style.borderColor = '#F00';
				errNum+=1;
			}	
			
		//Password
			if (document.L365Profile.password.value == '' || document.L365Profile.password.value == 'Password'){
				document.getElementById('password').style.borderColor = '#F00';
				errNum+=1;
			}
			
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

 <script type="text/javascript">
 	function checkEmail(emailAddress){
        // Define the data packet that we are going to post to the
        // server. This will be "stringified" as a JSON value.
        
		var postData = {
            email: document.L365Profile.email.value
        };
 
 //alert(document.L365Profile.email.value);
        // Post the data to the server as the HTTP Request Body.
        // To do this, we have to stringify the postData value
        // and pass it in a string value (so that jQuery won't try
        // to process it as a query string).
        var ajaxResponse = $.ajax({
            type: "post",
            url: "/api/sendLoginEmail.cfm",
            contentType: "application/json",
            data: JSON.stringify( postData )
        })
 
 
        // When the response comes back, output the HTML.
        ajaxResponse.then(
            function( apiResponse ){
 				//apiResponse.indexOf("New") != -1
				//alert(apiResponse.length);
				
                if(apiResponse.length == 0){
				
				}else{
					// Dump HTML to page for debugging.
					$( "#dumphere" ).html( apiResponse );
					$('#myModaEmailCheck').modal('show');
 				}
            }
        );
	}

    </script>
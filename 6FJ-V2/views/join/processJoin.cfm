<cfparam name="strFname" default="" />
<cfparam name="strLname" default="" />
<cfparam name="strPasswd" default="" />
<cfparam name="strEmail" default="" />
<cfparam name="url.tkcd" default="-1">
<cfparam name="tCode" default="-1">

<cfparam name="request.emailErrorMsg" default="">
<cfparam name="request.emailBorderColor" default="##F00">

<!--- CJ Tracking --->
<cfparam name="URL.AID" default="">
<cfparam name="URL.PID" default="">
<cfparam name="URL.SID" default="">
<cfparam name="Query_String" default="">
<cfparam name="session.exec.intsitevisitjobid" default="">

<cfif len(URL.AID) and len(URL.PID)>
	<cfparam name="how_find" default="CJ">
	<cfcookie name="strExecCJID" expires="5" value="#QUERY_STRING#">
</cfif>

<!--- This is the jobid where the user is coming to the site from --->
<cfif isDefined("url.Qf7DS7PEi") and url.Qf7DS7PEi neq "">
	<cfset session.exec.intsitevisitjobid=url.Qf7DS7PEi>
</cfif>

<!---Set the intJobID in session if coming from the Apply Job link and the candidate is not a member yet--->
<cfif isDefined("url.Pf9ZL4URh") and url.Pf9ZL4URh neq "">
	<cfset session.exec.jaQintJobID = url.Pf9ZL4URh>
<!---Set the JobId as the one the user came to the site--->
<cfelse>
	<cfif isDefined("url.Qf7DS7PEi") and url.Qf7DS7PEi neq "">
		<cfset session.exec.jaQintJobID = url.Qf7DS7PEi>
	</cfif>
</cfif>

<!---//START: PROCESS THE FORM//---->
<cfif isDefined("form.fieldnames")>
	<cfset fname=form.strFName>
	<cfset lname=form.strLName>
    <cfset email=form.strEmail>
    <cfset passwd=form.strPasswd>
    <cfset tCode=form.tCode>
	
	<!--- double check that the user doesn't always exist instead of assuming the person didn't get around the javascript --->
	<cfquery name="request.cfqCheckEmail" datasource="#application.dsn#">
		SELECT email 
		FROM tblResumes (nolock) 
		WHERE email = <cfqueryparam value="#email#" cfsqltype="cf_sql_varchar" />
		AND sourceApp = <cfqueryparam value="#application.sourceApp#" cfsqltype="cf_sql_varchar" />
	</cfquery>
	
	<cfif NOT request.cfqCheckEmail.recordcount>		
		
		<!---Set the tracking from the cookie--->
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
		
		<!---If the user did not enter the password let the user know if the issue--->
		<cfif len(passwd)>
			<cfscript>
			//Register the user
			request.intResID = application.registration.execStep1Registration(fname=fname, lname=lname, email=email, passwd=passwd, sourceApp=application.sourceApp, tCode=tCode);
			theKey=generateSecretKey('AES');
			encryptedResID = application.registration.getEncryptedResID(request.intResID);
			</cfscript>
		
			<!---11252013, Insert the record into the registration process tracking--->
			<cfquery name="cfqInsRec" datasource="#application.dsn#">
			insert into tblResRegStepsTracking (intResID) values (#request.intResID#);
			</cfquery>
		
		   <cflocation url="/join-step2?Fy4ZT9ZUv=#URLEncodedFormat(encryptedResID)#" addtoken="no">
		<cfelse>
			<cfset redirectQString = "">
			
			<cfif len(fname)>
				<cfset redirectQString = redirectQString & "fn10dtz=#fname#">
			</cfif>
			
			<cfif len(lname)>
				<cfset redirectQString = redirectQString & "&ln09gTc=#lname#">
			</cfif>
			
			<cfif len(email)>
				<cfset redirectQString = redirectQString & "&em87LTr=#email#">
			</cfif>
			
			<cfif len(passwd)>
				<cfset redirectQString = redirectQString & "&pd23pqE=#passwd#">
			</cfif>
			
			<cfif isDefined("session.exec.intsitevisitjobid") and session.exec.intsitevisitjobid neq "">
				<cfset redirectQString = redirectQString & "&Qf7DS7PEi=#session.exec.intsitevisitjobid#">
			</cfif>
		
			<cfif isDefined("session.exec.jaQintJobID") and session.exec.jaQintJobID neq "">
				<cfset redirectQString = redirectQString & "&Pf9ZL4URh=#session.exec.jaQintJobID#">
			</cfif>
			
			<cfset redirectQString = URLEncodedFormat(redirectQString)>
			
			<cfoutput>
			<cflocation url="/join?error=1&errorcode=4&#redirectQString#" addtoken="no">
			</cfoutput>
			<!--- <cfabort> --->
		</cfif>		
	<cfelse>
		<cfset redirectQString = "?s=0">

		<cfif isDefined("session.exec.intsitevisitjobid") and session.exec.intsitevisitjobid neq "">
			<cfset redirectQString = redirectQString & "&Qf7DS7PEi=#session.exec.intsitevisitjobid#">
		</cfif>
		
		<cfif isDefined("session.exec.jaQintJobID") and session.exec.jaQintJobID neq "">
			<cfset redirectQString = redirectQString & "&Pf9ZL4URh=#session.exec.jaQintJobID#">
		</cfif>
		
		<cfoutput>
		<cflocation url="/member.exists#redirectQString#" addtoken="no">
		</cfoutput>
		<!--- <cfabort> --->
	</cfif>
</cfif>
<!---//END: PROCESS THE FORM//---->
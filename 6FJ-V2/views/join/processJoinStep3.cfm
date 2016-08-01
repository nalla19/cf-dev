<!---Start: CPL's that have been selected YES--->
<cfset CPLMemberIDList = "" />
<cfloop index="field" list="#form.fieldnames#">
	<cfif field contains 'bln'>
		<cfif evaluate(field) is "1">
			<cfset intMemberID = replacenocase(field, "BLN", "", "ALL") />
			<cfquery name="cfqGetCPLmemberList" datasource="#application.dsn#">
				SELECT intMemberID 
				FROM tblCPLMember (nolock) 
				WHERE intMemberID = <cfqueryparam value="#intMemberID#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			<cfset CPLMemberIDList = ListAppend(CPLMemberIDList, cfqGetCPLmemberList.intMemberID, ",") />
		</cfif>
	</cfif>
</cfloop>
<!---End: CPL's that have been selected YES--->


<!---Send the Thank you registering/Confirmation email (for for 6figurejobs because of the wait to be approved process)--->
<cfif application.sourceApp EQ "6FigureJobs" AND isValid("email",email)>
	<cfquery name="cfqGetfname" datasource="#application.dsn#">
		SELECT fname 
		FROM tblResumes (nolock) 
		WHERE intresid = #intresid# 
	</cfquery>
	<cfset fname = cfqGetfname.fname />
	<!--- <cfinclude template="/6fj/t_emailExecResumeReceived.cfm"> --->
	<cfif cgi.http_host contains "uat2" or cgi.http_host contains "uat" or cgi.http_host contains "dev">
		<cfset email = 'irodela@calliduscloud.com'>
	</cfif>
	
	<cfif isDefined("email") AND isDefined("fname")>
		<cfset application.emailManager.sendThankYouEmail(emailTo=email,firstname=fname)>
	</cfif>
</cfif>

<cfset new_resID = intResID />

<cfif listLen(CPLMemberIDList) gt 0>
	<cfquery name="cfqGetCPLResInfo" datasource="#application.dsn#">
		SELECT fname, lname, address, zip, work_phone, mobile_phone,home_phone, email, city, state, strHighestDegree 
		FROM tblResumes (nolock) 
		WHERE intResID=#new_resID# 
	</cfquery>
	<cfif cfqGetCPLResInfo.RecordCount eq 1>
		<cfoutput query="cfqGetCPLResInfo">
			<cfset CPLFname=trim(fname) />
			<cfset CPLLname=trim(lname) />
			<cfset CPLAddr=trim(address) />
			<cfif not len(CPLAddr)>
				<cfset CPLAddr = "N/A" />
			</cfif>
			<cfset CPLAddr2="" />
			<cfset CPLZip=trim(zip) />
			<cfset CPLDPhone=iif(len(trim(cfqGetCPLResInfo.mobile_phone)),de(trim(cfqGetCPLResInfo.mobile_phone)),de(trim(cfqGetCPLResInfo.home_phone))) />
			<cfset CPLEPhone=trim(home_phone) />
			<cfset CPLEmail=trim(email) />
			<cfset CPLCity=trim(city) />
			<cfset CPLCntry=state />
			<cfset strEducationLevel=trim(strHighestDegree) />
			<cfset blnResPage=1 />
			<cfset blnCPLoggedIn=1 />
			<cfinclude template="CPartnerConfirm.cfm">
			<!---
				<cfif (blnSmithBarneyCPL eq 1)>
				<cfinclude template="t_email_cpl_reg_SB.cfm">
				</cfif>
				--->
		</cfoutput>
	</cfif>
</cfif>



<!---Update tblREsumes for the listcompletedsteps--->
<cfquery name="cfqUpdResumes" datasource="#application.dsn#">
	UPDATE tblResumes set 
		listcompletedsteps = '1,2,3', 
		<cfif application.sourceApp EQ "SalesStars">
			intAdmCode = 17
		<cfelse>
			intAdmCode = 2
		</cfif>
	WHERE intResID = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
</cfquery>

<cfif application.sourceApp NEQ "SalesStars">
	<cfif freeResumeCritique is 1>
		<cftry>
			<cfquery datasource="#application.dsn#">
			insert into tblAAABatch (intresid, dateStamp, optinStep, regComplete) values (#intResID#,getDate(), 3, 0)
			</cfquery>
			<cfcatch type="any"></cfcatch>
		</cftry>
	</cfif>
</cfif>

<!--- if it's sales stars, put the record into the tempresapprbin right away and trigger a thread to process it --->
<!--- <cfif application.applicationname EQ "SalesStars">
	<cfquery name="cfqInsRec" datasource="#strsixfigdata#">
		INSERT INTO tblTempResApprBin (intResID, intResStatusCode, blnRecProcessed)
		VALUES (<cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="30" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="7" cfsqltype="cf_sql_tinyint">)
	</cfquery>
	
	<cfthread action="run" priority="HIGH" theResId="#intResID#" name="ProcessSalesStarResume">
		<cfset theRealAttributes = structCopy(attributes) />   
		<cfinclude template="/6fj/s7n4a1p3e14/6Fig/jobs/ApprResumes_SendLyrisEmail.cfm">
	</cfthread>
</cfif> --->

<cfinclude template="joinLogin.cfm">
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
<cflocation url="/join-thank-you?Fy4ZT9ZUv=#URLEncodedFormat(url.Fy4ZT9ZUv)#" addtoken="no">
<cfabort />
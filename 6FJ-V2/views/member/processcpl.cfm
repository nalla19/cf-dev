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
		WHERE intresid = #session.exec.intresid# 
	</cfquery>
	<cfset fname = cfqGetfname.fname />
	<!--- <cfinclude template="/6fj/t_emailExecResumeReceived.cfm"> --->
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
		</cfoutput>
	</cfif>
</cfif>

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

<!---Update tblResumes that the CPL page has been visited and processed--->
<cfquery datasource="#application.dsn#">
update tblResumes set blnCPLPageVisited = 1 where intresid = <cfqueryparam value="#intResID#" cfsqltype="cf_sql_integer" />
</cfquery>

<!---Update the session variables that the CPL page has been visited--->
<cfset session.exec.blnCPLPageVisisted = 1>

<cflocation url="/member-dashboard" addtoken="no">
<cfabort />
<meta name="robots" content="noindex,nofollow" />
<meta name="robots" content="none" />
<cfsetting showdebugoutput="no" />

<cfparam name="pk_execid" default="">
<cfparam name="intJobID" default="0">
<cfparam name="strSEOJobURL" default="">
<cfparam name="blnValid_pk_execid" default="false">
<cfparam name="blnValid_JobID" default="false">
<cfparam name="strUserName" default="">
<cfparam name="strPassword" default="">

<!---
Sample URL
 UAT: http://uat.6figurejobs.com/job/?tid=9324B4ED-A5EF-45E6-8864-8B899B87F9A5&jid=1177566
LIVE: https://www.6figurejobs.com/job/?tid=9324B4ED-A5EF-45E6-8864-8B899B87F9A5&jid=1177566
--->

<cfoutput>
<!---pk_execid---->
<cfif isDefined("url.tid") and url.tid neq "">
	<cfset pk_execid = url.tid>
	
	<cfquery name="cfqValidatepkexecid" datasource="#application.dsn#">
	select username, password from tblResumes (nolock) where pk_execid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pk_execid#" /> and sourceApp = <cfqueryparam cfsqltype="cf_sql_varchar" value="6FigureJobs" />
	</cfquery>
	
	<cfif cfqValidatepkexecid.recordcount gt 0>
		<cfset strUserName 			= cfqValidatepkexecid.username>
		<cfset strPassword 			= cfqValidatepkexecid.password>
		<cfset blnValid_pk_execid 	= true>
	</cfif>
</cfif>


<!---Job ID--->
<cfif isDefined("url.jid") and url.jid neq "">
	<cfset intJobID = url.jid>
	
	<cfquery name="cfqValidatejobid" datasource="#application.dsn#">
	select intJobID, seoJobURL from tblJobs (nolock) where intJobID = <cfqueryparam cfsqltype="cf_sql_integer" value="#intJobID#" />  and sourceApp = <cfqueryparam cfsqltype="cf_sql_varchar" value="6FigureJobs" />
	</cfquery>
	
	<cfif cfqValidatejobid.recordcount gt 0>
		<cfset strSEOJobURL 	= cfqValidatejobid.seoJobURL>
		<cfset blnValid_JobID 	= true>
	</cfif>
</cfif>

<!---
pk_execid=#pk_execid#<br>
intJobID=#intJobID#<br>
strUserName=#strUserName#<br>
strPassword=#strPassword#<br>
blnValid_pk_execid=#blnValid_pk_execid#<br>
strSEOJobURL=#strSEOJobURL#<br>
blnValid_JobID=#blnValid_JobID#<br>
--->

<cfparam name="request.url" default="https://www.6figurejobs.com" />
<cfif cgi.http_host contains "uat2" or cgi.http_host contains "uat" or cgi.http_host contains "dev">
	<cfset request.url = "http://uat.6figurejobs.com" />
<cfelse>
	<cfset request.url = "https://www.6figurejobs.com" />
</cfif>

<!---If valid pk_execid--->
<cfif blnValid_pk_execid>
	<!---Valid JobID--->
	<cfif blnValid_JobID>
		<cflocation url="#request.url#/member-login?100k=1&strUsername=#strUserName#&strPassword=#strPassword#&blnRememberMe=1&strCaller=execOneClickApply&intJobID=#intJobID#" addtoken="no">
	<!---Invalid JobID--->
	<cfelse>
		<cflocation url="#request.url#/member-login?100k=1&strUsername=#strUserName#&strPassword=#strPassword#&blnRememberMe=1" addtoken="no">
	</cfif>
<!---If not a valid pk_execid--->
<cfelse>
	<!---If valid JobID--->
	<cfif blnValid_JobID>
		<cflocation url="#request.url##strSEOJobURL#" addtoken="no">
	<!---If not a valid JobID--->
	<cfelse>
		<cflocation url="#request.url#" addtoken="no">
	</cfif>
</cfif>
</cfoutput>
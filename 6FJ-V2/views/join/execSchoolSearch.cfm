<cfsetting showdebugoutput="false">
<cfparam name="url.q" default="asdf">

<cfset strSearchKeyword = URL.q />

<cfif len(strSearchKeyword) gte "1">
	<cfquery name="getSchoolName"  datasource="#application.dsn#">
		select strUnivCollegeName 
		from tblUnivColleges(nolock) 
		where strUnivCollegeName like <cfqueryparam value="#strSearchKeyword#%" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfoutput query="getSchoolName">#strUnivCollegeName#;</cfoutput>
</cfif>
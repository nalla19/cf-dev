<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<cftry>
	<cfif isDefined("url.code") and isDefined("url.state") and isDefined("session.state") and url.state is session.state>
  		<cfset session.licode = url.code>

		<!--- <cfset redirurl = urlEncodedFormat("#request.url#/join/linkedin/redir.cfm")> --->
		<cfif cgi.HTTP_HOST EQ "6figurejobs.com" OR cgi.HTTP_HOST EQ "www.6figurejobs.com" OR cgi.HTTP_HOST EQ "web1.6figurejobs.com" OR cgi.HTTP_HOST EQ "web2.6figurejobs.com" OR cgi.HTTP_HOST EQ "web3.6figurejobs.com" OR cgi.HTTP_HOST EQ "access.6figurejobs.com" OR cgi.HTTP_HOST EQ "salesstars.com" OR cgi.HTTP_HOST EQ "www.salesstars.com">
			<cfset redirurl = urlEncodedFormat("https://www.6figurejobs.com/join-linkedin-redirect")>
		<cfelseif cgi.HTTP_HOST EQ "uat.6figurejobs.com" OR cgi.HTTP_HOST EQ "uat2.6figurejobs.com" OR cgi.HTTP_HOST EQ "uat.salesstars.com">
			<cfset redirurl = urlEncodedFormat("http://uat.6figurejobs.com/join-linkedin-redirect")>
		<cfelseif cgi.HTTP_HOST EQ "dev.6figurejobs.com" OR cgi.HTTP_HOST EQ "dev.salesstars.com">
			<cfset redirurl = urlEncodedFormat("http://dev.6figurejobs.com/join-linkedin-redirect")>
		</cfif>
		
		
		<cfset liAccessTokenURL = "https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code" &
                "&code=#session.licode#&redirect_uri=#redirurl#" & 
                "&client_id=#application.linkedin.apikey#" & 
                "&client_secret=#application.linkedin.secretkey#">
		<cfhttp url="#liAccessTokenURL#">
	
		<!--- <cfoutput>cfhttp.filecontent=#cfhttp.filecontent#</cfoutput> --->

		<cfif isJSON(cfhttp.filecontent)>
			<cfset res = deserializeJSON(cfhttp.filecontent)>
			<cfset session.liaccesstoken = res.access_token>
		
			<!--- Location of the Redirect ---->
			<cflocation url="/join-linkedin" addtoken="false">
		<cfelse>
			<!---
			This is an error case. 
			--->
			<cfdump var="#cfhttp#">
		</cfif>
 
 
 
	<cfelseif isDefined("url.error_reason")>
 	
		<!--- Handle error here. Variables are: url.error_reason and error_description--->
		<cfif cgi.HTTP_HOST EQ "6figurejobs.com" OR cgi.HTTP_HOST EQ "www.6figurejobs.com" OR cgi.HTTP_HOST EQ "web1.6figurejobs.com" OR cgi.HTTP_HOST EQ "web2.6figurejobs.com" OR cgi.HTTP_HOST EQ "web3.6figurejobs.com" OR cgi.HTTP_HOST EQ "access.6figurejobs.com" OR cgi.HTTP_HOST EQ "salesstars.com" OR cgi.HTTP_HOST EQ "www.salesstars.com">
			<cflocation url="https://www.6figurejobs.com" addtoken="no">
		<cfelseif cgi.HTTP_HOST EQ "uat.6figurejobs.com" OR cgi.HTTP_HOST EQ "uat2.6figurejobs.com" OR cgi.HTTP_HOST EQ "uat.salesstars.com">
			<cflocation url="http://uat.6figurejobs.com" addtoken="no">
		<cfelseif cgi.HTTP_HOST EQ "dev.6figurejobs.com" OR cgi.HTTP_HOST EQ "dev.salesstars.com">
			<cflocation url="http://dev.6figurejobs.com" addtoken="no">
		</cfif>
	
	<cfelseif isDefined("url.error") and url.error eq "access_denied">
	
		<cfif cgi.HTTP_HOST EQ "6figurejobs.com" OR cgi.HTTP_HOST EQ "www.6figurejobs.com" OR cgi.HTTP_HOST EQ "web1.6figurejobs.com" OR cgi.HTTP_HOST EQ "web2.6figurejobs.com" OR cgi.HTTP_HOST EQ "web3.6figurejobs.com" OR cgi.HTTP_HOST EQ "access.6figurejobs.com" OR cgi.HTTP_HOST EQ "salesstars.com" OR cgi.HTTP_HOST EQ "www.salesstars.com">
			<cflocation url="https://www.6figurejobs.com" addtoken="no">
		<cfelseif cgi.HTTP_HOST EQ "uat.6figurejobs.com" OR cgi.HTTP_HOST EQ "uat2.6figurejobs.com" OR cgi.HTTP_HOST EQ "uat.salesstars.com">
			<cflocation url="http://uat.6figurejobs.com" addtoken="no">
		<cfelseif cgi.HTTP_HOST EQ "dev.6figurejobs.com" OR cgi.HTTP_HOST EQ "dev.salesstars.com">
			<cflocation url="http://dev.6figurejobs.com" addtoken="no">
		</cfif>
		
	</cfif>
	
	<cfcatch type="any">
		<cfif cgi.HTTP_HOST EQ "6figurejobs.com" OR cgi.HTTP_HOST EQ "www.6figurejobs.com" OR cgi.HTTP_HOST EQ "web1.6figurejobs.com" OR cgi.HTTP_HOST EQ "web2.6figurejobs.com" OR cgi.HTTP_HOST EQ "web3.6figurejobs.com" OR cgi.HTTP_HOST EQ "access.6figurejobs.com" OR cgi.HTTP_HOST EQ "salesstars.com" OR cgi.HTTP_HOST EQ "www.salesstars.com">
			<cflocation url="https://www.6figurejobs.com" addtoken="no">
		<cfelseif cgi.HTTP_HOST EQ "uat.6figurejobs.com" OR cgi.HTTP_HOST EQ "uat2.6figurejobs.com" OR cgi.HTTP_HOST EQ "uat.salesstars.com">
			<cflocation url="http://uat.6figurejobs.com" addtoken="no">
		<cfelseif cgi.HTTP_HOST EQ "dev.6figurejobs.com" OR cgi.HTTP_HOST EQ "dev.salesstars.com">
			<cflocation url="http://dev.6figurejobs.com" addtoken="no">
		</cfif>
	</cfcatch>
</cftry>

</body>
</html>
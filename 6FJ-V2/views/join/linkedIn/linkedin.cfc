<cfcomponent output="false">
 
  <cffunction name="init" access="public" returnType="linkedin" output="false">
		<cfargument name="accesstoken" type="string" required="true">
		<cfset variables.accesstoken = arguments.accesstoken>
		<cfreturn this>
	</cffunction>
 
	<cffunction name="getFriends" access="public" returnType="struct" output="false">
		<cfargument name="start" type="numeric">
		<cfargument name="count" type="numeric">
 
		<cfset var httpResult = "">
		<cfset var theURL = "https://api.linkedin.com/v1/people/~/connections?oauth2_access_token=#session.liaccesstoken#">
 
		<cfif structKeyExists(arguments,"start") and isNumeric(arguments.start)>
			<cfset theURL &= "&start=#arguments.start#"> 
		</cfif>
		<cfif structKeyExists(arguments,"count") and isNumeric(arguments.count)>
			<cfset theURL &= "&count=#arguments.count#"> 
		</cfif>
 
		<cfhttp url="#theURL#" result="httpResult">
			<cfhttpparam type="header" name="x-li-format" value="json">
		</cfhttp>
 
		<cfreturn deserializeJSON(httpResult.fileContent)>
 
	</cffunction>
 
	<cffunction name="getMe" access="public" returnType="struct" output="false">
		<cfset var httpResult = "">
 		
		<!---
		<cfhttp url="https://api.linkedin.com/v1/people/~?oauth2_access_token=#variables.accesstoken#" result="httpResult">
			<cfhttpparam type="header" name="x-li-format" value="json">
		</cfhttp>
		<cfreturn deserializeJSON(httpResult.fileContent)>
		--->

		<cfhttp url="https://api.linkedin.com/v1/people/~:(last-modified-timestamp,first-name,last-name,email-address,headline,picture-url,location,summary,positions,skills,industry,educations,main-address,phone-numbers,languages,certifications,twitter-accounts,public-profile-url)?oauth2_access_token=#variables.accesstoken#" result="httpResult">
			<cfhttpparam type="header" name="x-li-format" value="json">
		</cfhttp>
		<cfreturn deserializeJSON(httpResult.fileContent)>
 		
		
	</cffunction>
 
	<cffunction name="sendMessage" access="public" returnType="boolean" output="false">
		<cfargument name="recipients" type="any" required="true">
		<cfargument name="subject" type="string" required="true">
		<cfargument name="body" type="string" required="true">
 
		<cfset var httpResult = "">
 
		<cfset var x = "">
		<cfset var m = structNew()>
 
		<cfset var recips = arrayNew(1)>
		<cfif not isArray(recipients)>
			<cfset arrayAppend(recips, recipients)>
		<cfelse>
			<cfset recips = recipients>
		</cfif>
 
		<cfset m["recipients"] = structNew()>
		<cfset m["recipients"]["values"] = arrayNew(1)>
		<cfloop index="x" from="1" to="#arrayLen(recips)#">
			<cfset m["recipients"]["values"][x] = structNew()>
			<cfset m["recipients"]["values"][x]["person"] = structNew()>
			<cfset m["recipients"]["values"][x]["person"]["_path"] = "/people/#recips[x]#">
		</cfloop>
 
		<cfset m["subject"] = arguments.subject>
		<cfset m["body"] = arguments.body>
 
		<cfhttp url="https://api.linkedin.com/v1/people/~/mailbox?oauth2_access_token=#session.liaccesstoken#"
				  method="post" result="httpResult">
			<cfhttpparam type="header" name="x-li-format" value="json">
 
				  <cfhttpparam type="body" value="#serializeJSON(m)#">
		</cfhttp>
 
		<cfreturn httpResult.responseHeader["Status_Code"] eq 201>
	</cffunction>
 
</cfcomponent>
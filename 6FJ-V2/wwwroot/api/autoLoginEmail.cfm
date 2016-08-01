<cfif isdefined("url.mz6ntxa3") and isdefined("url.kB2MxfRR") and len(url.mz6ntxa3) and len(url.kB2MxfRR)>
	<cfset strUsername=trim(urldecode(url.mz6ntxa3))>
	<cfset strPassword=trim(urldecode(url.kB2MxfRR))>
	<cfset location=trim(url.location)>
	<cfset strloginLoc = "6FJ">
	
	<cfset strUsername = decrypt(
			strUsername,
			application.encryptionKeyRM,
			"AES",
			"hex"
			) />
	<cfset strPassword = decrypt(
			strPassword,
			application.encryptionKeyRM,
			"AES",
			"hex"
			) />
		
	<!--- create auto login cookie --->
	 <cfset strRememberMe = (
		CreateUUID() & ":" &
		strUsername & ":" &
		strPassword & ":" &
		strloginLoc & ":" &
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
		
	<cfinclude template="/api/autoLogin.cfm">
	
	<!--- <cfoutput>
	strUsername = #strUsername#<br>
	strPassword = #strPassword#<br>
	location = #url.location#
	</cfoutput>
	<cfabort> --->
	
	<cfswitch expression="#location#">
		<cfcase value="L365SU">
			<cflocation url="/learn365-signup" addtoken="no">
		</cfcase>
		<cfdefaultcase>
			<cflocation url="/home" addtoken="no">
		</cfdefaultcase>
	</cfswitch>
<cfelse>
	<cflocation url="/home" addtoken="no">
</cfif>



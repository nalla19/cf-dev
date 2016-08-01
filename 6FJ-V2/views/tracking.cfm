<cfparam name="seoJobURL" default="">
<cfparam name="dollarPos" default="1">
<cfparam name="seoJobURL2" default="">
<cfparam name="forwardSlashPos" default="">

<!--- If a cookie is already defined assign the value back to the url.tkcd --->
<cfif isdefined("cookie.sixFJResTracker") and cookie.sixFJResTracker neq "">
	<cfset url.tkcd = cookie.sixFJResTracker>
<cfelseif url.tkcd neq "-1" and url.tkcd neq "">
	<cfcookie name="sixFJResTracker" expires="30" value="#url.tkcd#">
<cfelse>
	<cfif url.act eq "listing" or url.act eq "pricing">
		<cfset dollarPos = Find("$", seoJobURL, 1)>
		<cfif dollarPos gt 0>
			<cfset seoJobURL2 = Right(seoJobURL, len(seoJobURL) - dollarPos)>
			<cfset forwardSlashPos = Find("/", seoJobURL2, 1)>
			<cftry>
				<cfset url.tkcd = left(seoJobURL2, forwardSlashPos-1)>
				<cfcatch type="any"></cfcatch>
			</cftry>
			<cfcookie name="sixFJResTracker" expires="30" value="#url.tkcd#">
		</cfif>
	<!--- <cfelse>
		<cfcookie name="sixFJResTracker" expires="30" value="0"> --->
	</cfif>
</cfif>
<cfoutput>
<!--- <cfif isdefined("cookie.sixFJResTracker")>
tracking cookie: #cookie.sixFJResTracker#
</cfif> --->
</cfoutput>
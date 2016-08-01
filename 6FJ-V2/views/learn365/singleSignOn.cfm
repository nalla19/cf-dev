
<cfif isDefined("session.exec.blnLearn365") and session.exec.blnLearn365>

		
		<cfif isDefined("session.exec.learn365UserID") and len(session.exec.learn365UserID)>
			<cfset learn365UserId = session.exec.learn365UserID>
			<cfinclude template="api/singleSignOn.cfm">
			
			<cflocation url="#mydoc.User.LoginKey.XmlText#">
		<cfelse>
			<cflocation url="/home">
		</cfif>
<cfelse>
		<cflocation url="/learn365">
</cfif>
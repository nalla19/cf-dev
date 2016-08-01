<meta name="robots" content="noindex,nofollow" />
<meta name="robots" content="none" />

<cfsetting showdebugoutput="no" />
<cfparam name="token" default="">

<cfparam name="request.url" default="https://www.6figurejobs.com" />
<cfif cgi.http_host contains "uat2" or cgi.http_host contains "uat" or cgi.http_host contains "dev">
	<cfset request.url = "http://uat.6figurejobs.com" />
<cfelse>
	<cfset request.url = "https://www.6figurejobs.com" />
</cfif>

<cfoutput>
	
<cfif isDefined("url.id") and url.id neq "">
	<cfset token= url.id />
	
	<cfquery name="cfqValidatepkexecid" datasource="#application.dsn#">
	select username, password from tblResumes (nolock) where pk_execid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#token#" /> and sourceApp = <cfqueryparam cfsqltype="cf_sql_varchar" value="6FigureJobs" />
	</cfquery>
	
	<cfif cfqValidatepkexecid.recordcount gt 0>
		<cfscript>
		request.blnValidToken	= true;
		request.tokenExpired	= false;
		</cfscript>
			
		<cfset strUserName 			= cfqValidatepkexecid.username>
		<cfset strPassword 			= cfqValidatepkexecid.password>
	</cfif>
	
	<!---Take the user to the Learn365 Dashboard--->
	<cfif isDefined("url.loginType") and url.loginType is "learnlanding">
		<cflocation url="#request.url#/member-login?100k=1&strUsername=#strUserName#&strPassword=#strPassword#&blnRememberMe=1&loginType=learnlanding" addtoken="no">
	<cfelse>
		<cflocation url="#request.url#/member-login?100k=1&strUsername=#strUserName#&strPassword=#strPassword#&blnRememberMe=1" addtoken="no">
	</cfif>
	
<cfelse>
	
	<cfset token= listlast(cgi.query_string, "&") />

	<cfif len(token)>
		<cfquery name="cfqValidateToken" datasource="#application.dsn#">
	    select * from tblJobSeekerAccessToken (nolock) 
		 where token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#token#" />
		   and dateTokenExpires > getdate()
	    </cfquery>
       
		<!---Record exists--->
	    <cfif cfqValidateToken.recordcount gt 0>
			<cfscript>
			request.blnValidToken	= true;
			request.tokenExpired	= false;
			</cfscript>
		
	    	<cfset intresid 	= cfqValidateToken.intresid>
	        <cfset pk_id 		= cfqValidateToken.pk_id>
			<cfset landingPage 	= cfqValidateToken.strLandingPage>
			
			<cfquery name="cfqGetCredentials" datasource="#application.dsn#">
			select username, password from tblResumes (nolock) where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intresid#" />
			</cfquery>
		
			<cfset username 	= cfqGetCredentials.username>
			<cfset password 	= cfqGetCredentials.password>
    			
	   		<!---Update the record for downloaded to 1--->	
		   	<cfquery name="cfqUpdResDownload" datasource="#application.dsn#">
			update tblJobSeekerAccessToken set blnJobSeekerLoggedIn = 1, dateJobSeekerLoggedIn = getdate() where pk_id = #pk_id# and intresid = #intresid#
			</cfquery>
		
			<cfswitch expression="#landingPage#">
				<cfcase value="Dashboard">
					<!--- Auto Log the user to the dashboard --->
					<cflocation url="#request.url#/member-login?100k=1&strUsername=#username#&strPassword=#password#&blnRememberMe=1" addtoken="no">
				</cfcase>
				
				<cfcase value="Learn365">
					<!--- Auto Log the user to the dashboard --->
					<cflocation url="#request.url#/member-login?100k=1&strUsername=#username#&strPassword=#password#&blnRememberMe=1&loginType=learnlanding" addtoken="no">
				</cfcase>
			
				<cfdefaultcase>
					<!--- Auto Log the user to the dashboard --->
					<cflocation url="#request.url#/member-login?100k=1&strUsername=#username#&strPassword=#password#&blnRememberMe=1" addtoken="no">
				</cfdefaultcase>
			</cfswitch>
	                          
    	<!--- Check to see if the token exists or not and if it expired or not --->
	    <cfelse>
			<!---Check if the token expired--->
			<cfquery name="cfqValidateToken" datasource="#application.dsn#">
		    select * from tblJobSeekerAccessToken (nolock) 
			 where token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#token#" />
	    	</cfquery>
		
			<cfif cfqValidateToken.recordcount gt 0>
				<cfscript>
	    		request.blnValidToken	= true;
				request.tokenExpired	= true;
				</cfscript>
			<cfelse>
				<cfscript>
	    		request.blnValidToken	= false;
				request.tokenExpired	= true;
				</cfscript>
			</cfif>
	    </cfif>
	<cfelse>
		<cfscript>
	   	request.blnValidToken 	= false;
		request.tokenExpired	= true;
		</cfscript>
	</cfif>
	
</cfif>

</cfoutput>
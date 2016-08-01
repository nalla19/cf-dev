
<cfif request.newsType EQ "er" OR request.newsType EQ "both">
	
	<cfset request.gogo = true />
	
	<!--- verify the email does not exist for a current member --->
	<cfquery name="request.checkEmail" datasource="#application.dsn#" maxrows="1">
		SELECT intEmployerID
		FROM tblEmployers
		WHERE stremail = <cfqueryparam value="#request.email#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	
	<cfif !request.checkEmail.RecordCount>
	
		<!--- verify this person has not already signed up for the newsletter --->
		<cfquery name="request.checkNewsEmail" datasource="#application.dsn#" maxrows="1">
			SELECT strEmail
			FROM tblERNewsletter
			WHERE strEmail = <cfqueryparam value="#request.email#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif request.checkNewsEmail.RecordCount>
			<cfset request.gogo = false />
		</cfif>
	
	<cfelse>
		<cfset request.gogo = false />
	</cfif>
	
	
	<cfif request.gogo>
		<!--- insert the rec into the dB --->
		<cfquery datasource="#application.dsn#">
			INSERT INTO tblERNewsletter (stremail, strFName, strLName, intType) 
			VALUES ( <cfqueryparam value="#request.email#" cfsqltype="cf_sql_varchar">, <cfqueryparam value="FName" cfsqltype="cf_sql_varchar">, <cfqueryparam value="LName" cfsqltype="cf_sql_varchar">,  <cfqueryparam value="0" cfsqltype="cf_sql_integer">)
		</cfquery>
		
		<!--- Adding the Record to the Nurture_Marketing_Campaign_Active_Recruiter_List2 List --->
		<cfset message = application.leadFormixManager.addERContact(list_name	=	'Recruiter Newsletter 9-5-13', 
    	                                                             list_type	=	'Newsletter', 
																	 owner_name	=	'Michelle Martin', 
																	owner_email	=	'mmartin@calliduscloud.com', 
																  contact_email	=	'#request.email#', 
															 contact_first_name	=	'', 
															  contact_last_name	=	'', 
																   company_name	=	''
	                                                                    )> 
	</cfif>

</cfif>






<cfif request.newsType EQ "exec" OR request.newsType EQ "both">

	<cfset request.gogo = true />
	

	<!--- verify the email does not exist for a current member --->
	<cfquery name="request.checkEmail" datasource="#application.dsn#" maxrows="1">
		SELECT intResID 
		FROM tblResumes
		WHERE email = <cfqueryparam value="#request.email#" cfsqltype="cf_sql_varchar">
		AND blnDelete = 0
	</cfquery>
	
	
	<cfif !request.checkEmail.RecordCount>
	
		<!--- verify this person has not already signed up for the newsletter --->
		<cfquery name="request.checkNewsEmail" datasource="#application.dsn#" maxrows="1">
			SELECT strEmail
			FROM tblExNewsletter
			WHERE strEmail = <cfqueryparam value="#request.email#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif request.checkNewsEmail.RecordCount>
			<cfset request.gogo = false />
		</cfif>
	
	<cfelse>
		<cfset request.gogo = false />
	</cfif>
	
	
	<cfif request.gogo>
		<!--- insert the rec into the dB --->
		<cfquery datasource="#application.dsn#">
			INSERT INTO tblExNewsletter (stremail, strFName, strLName, intSalaryRange, intEmailOpened, intBounced, intEmailsent) 
			VALUES ( <cfqueryparam value="#request.email#" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam value="FName" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam value="LName" cfsqltype="cf_sql_varchar">,
			         <cfqueryparam value="1" cfsqltype="cf_sql_integer">,
					 <cfqueryparam value="0" cfsqltype="cf_sql_integer">,
					 <cfqueryparam value="0" cfsqltype="cf_sql_integer">,
					 <cfqueryparam value="0" cfsqltype="cf_sql_integer">
					 )
		</cfquery> 
		
		<cfset application.leadFormixManager.addContact(list_name	=	'Seeker Newsletter Opt In List 10-21-13', 
														list_type	=	'Newsletter', 
														owner_name	=	'Michelle Martin', 
														owner_email	=	'mmartin@calliduscloud.com', 
													  contact_email	=	'#request.email#', 
												 contact_first_name	=	'', 
												  contact_last_name	=	''
												  		)>
	</cfif>
	
</cfif>
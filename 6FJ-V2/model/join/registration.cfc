<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="registration">
		<cfargument name="dsn" type="string" required="true" />
		<cfscript>
			variables.dsn = arguments.dsn;
			
			variables.theKey = 'VhnSz48Nx1IN8IzaXY0WVQ==';
			
			return this;
		</cfscript>
	</cffunction>
	

	<cffunction access="public" name="execStep1Registration" output="false" returntype="numeric" hint="Returns ResumeID">
		<cfargument name="fname" type="string" required="Yes" default="" />
		<cfargument name="lname" type="string" required="Yes" default="" />
		<cfargument name="email" type="string" required="Yes" default="" />
		<cfargument name="passwd" type="string" required="Yes" default="" />
		<cfargument name="sourceApp" type="string" required="true">
		<cfargument name="tCode" type="string" required="no" default="0" />
		<cfargument name="intResTrkID" type="string" required="no" default="0" />
		
		<!--- <cfparam name="v_intResTrkID" default="0"> --->
		<!--- <cfoutput>
		tCode - #arguments.tCode#<br>
		intResTrkID - #arguments.intResTrkID#
		</cfoutput> --->
	
		
		<cfif (arguments.tCode neq "-1") AND (arguments.tCode neq "")>
		
			<!--- if there is a lead ID to grab --->
			<cfquery name="cfqGetLeadID" datasource="#variables.dsn#">
				SELECT intTrackingID 
				FROM tblHowFindTracking (nolock) 
				WHERE strTrackCode=<cfqueryparam value="#arguments.tCode#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfif cfqGetLeadID.RecordCount eq 1>
				<cfset arguments.intResTrkID = cfqGetLeadID.intTrackingID />
			</cfif>
			<!--- <cfoutput>
		2tCode - #arguments.tCode#<br>
		2intResTrkID - #arguments.intResTrkID#
		</cfoutput> --->
		</cfif>
		
		<!--- <cf_ct_getServerName> --->
		<cfparam name="intServerNbr" default="0">
		
		<cfquery datasource="#variables.dsn#" name="cfqNewRecord">
			SET NOCOUNT ON 
			INSERT INTO tblResumes(blnbigs,
									fname,
									lname,
									email,
									username,
									password,
									listcompletedsteps,
									intRegStep,
									intServerNo,
									StrBrowserName,
									intResTrkID,
									sourceApp)
			VALUES( 0, 
					<cfqueryparam value="#arguments.fname#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.lname#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.passwd#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="1" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="1" cfsqltype="cf_sql_integer" />,
					#intServerNbr#, 
					<cfqueryparam value="#left(cgi.user_agent, 190)#" cfsqltype="cf_sql_varchar" />, 
					#arguments.intResTrkID#,
					<cfqueryparam value="#arguments.sourceApp#" cfsqltype="cf_sql_varchar" />)
			SET NOCOUNT OFF 
			
			SELECT intIDno=@@IDENTITY
		</cfquery>
		<!---<cfoutput>
		xxTracking - #arguments.intResTrkID#<br>
		</cfoutput>
		<cfabort>  --->
		<cfreturn cfqNewRecord.intIDno />
	</cffunction>


	<cffunction access="public" name="getEncryptedResID" output="false" returntype="string" hint="returns an encrypted intResID">
		<cfargument name="intResID" type="numeric" required="yes" default="0" />
		<!--- <cfset theKey=generateSecretKey('AES')> --->
		<!---Use this Static Key--->
		<cfset encrypted=encrypt(arguments.intResID, variables.theKey, 'AES', 'Base64') />
		<cfreturn encrypted />
	</cffunction>


	<cffunction access="public" name="getDecryptedResID" output="false" returntype="string" hint="returns an encrypted intResID">
		<cfargument name="encryptedResID" type="string" required="yes" default="0" />
		<!--- <cfset theKey=generateSecretKey('AES')> --->
		<!---Use this Static Key--->
		<cfreturn decrypt(arguments.encryptedResID, variables.theKey, 'AES', 'Base64') />
	</cffunction>


	<cffunction access="public" name="getResDetails" output="false" returntype="query" hint="returns an query with First Name, Last Name and Email Address">
		<cfargument name="intResID" type="numeric" required="yes" default="0" />
		<cfset var cfqGetResDetails = "" />
		
		<cfquery name="cfqGetResDetails" datasource="#variables.dsn#">
			SELECT fname, lname, email, username, password, fltCompensation_package, strfuncs, strexecJobtitle_1, strexecJobtitle_2
			FROM tblResumes (nolock) 
			WHERE intResID = <cfqueryparam value="#arguments.intResID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn cfqGetResDetails>
	</cffunction>
	
	<cffunction access="public" name="cfqGetFullResDetails" output="false" returntype="query" hint="returns an query with First Name, Last Name and Email Address">
		<cfargument name="intResID" type="numeric" required="yes" default="0" />
		<cfset var cfqGetFullResDetails = "" />
		
		<cfquery name="cfqGetFullResDetails" datasource="#variables.dsn#">
			SELECT *
			FROM tblResumes (nolock) 
			WHERE intResID = <cfqueryparam value="#arguments.intResID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn cfqGetFullResDetails>
	</cffunction>
	
	<cffunction access="public" name="cfqGetResUploadCnt" output="false" returntype="numeric" hint="returns an count">
		<cfargument name="intResID" type="numeric" required="yes" default="0" />
		<cfset var cfqResDetailsCnt = "" />
		
		<cfquery name="cfqResDetailsCnt" datasource="#variables.dsn#">
			SELECT COUNT(*) resCnt
			 FROM tblresumeprofiles (nolock) 
			WHERE blnActive = 1
			  AND fk_intresid = <cfqueryparam value="#arguments.intResID#" cfsqltype="cf_sql_integer" />
			  AND title NOT LIKE '%LinkedInProfile%'
		</cfquery>
		
		<cfreturn cfqResDetailsCnt.resCnt>
	</cffunction>
	
</cfcomponent>

<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="jobGateway">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="machine" type="string" required="true" />
		<cfargument name="sourceApp" type="string" required="true" />
		<cfscript>
			variables.dsn = arguments.dsn;
			variables.machine = arguments.machine;
			variables.sourceApp = arguments.sourceApp;
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="read" access="public" output="false" returntype="query">
		<cfargument name="intJobId" type="string" required="true" />
		<cfset var qry_j = "" />
		
		<cfquery name="qry_j" datasource="#variables.dsn#">
			SELECT j.intJobID, 
					j.jpname, 
					j.title, 
					j.location, 
					cast(replace(replace(cast(j.description as nvarchar(max)),'$$DQ$$','"'),'$$SQ$$','''') as ntext) as description,
					j.intEmployerId,
					s.strName as state,
					j.strOpportunity, 
					j.date_submitted, 
					j.seoJobURL,
					j.fltSalary_desiredlow,
					<!---> j.strAboutCompany, --->
					cast(replace(replace(cast(j.strAboutCompany as nvarchar(max)),'$$DQ$$','"'),'$$SQ$$','''') as ntext) as strAboutCompany,
					j.strCompanyPerks,
					era.strMasterLogo,
					era.strMasterLogoAltTag		
			FROM tblJobs j
			LEFT OUTER JOIN tblERAssets era
			ON era.intEmployerID = j.intEmployerID
			INNER JOIN		tblStates s
			ON j.state = s.intOldId
			WHERE j.intJobId = <cfqueryparam value="#arguments.intJobId#" cfsqltype="cf_sql_integer" />
			<cfif variables.machine NEQ "DEV" AND variables.machine NEQ "LOCAL">
				AND j.blnActive=1
				AND j.blnValidated=1
			</cfif>
			AND j.sourceApp in ('#variables.sourceApp#', 'Both')
		</cfquery>
				
		<cfreturn qry_j>
	</cffunction>
	
	<cffunction name="qry_employerJobs" access="public" output="false" returntype="query">
		<cfargument name="employerIds" type="string" required="true" />
		<cfset var qry_j = "" />
		
		<cfquery name="qry_j" datasource="#variables.dsn#">
			SELECT j.intJobID, 
					j.jpname, 
					j.title, 
					j.location, 
					j.intEmployerId,
					s.strName as state,
					j.strOpportunity, 
					j.date_submitted, 
					j.seoJobURL,
					j.fltSalary_desiredlow,
					j.strAboutCompany,
					j.strCompanyPerks,
					era.strMasterLogo,
					era.strMasterLogoAltTag
			FROM tblJobs j
			LEFT OUTER JOIN tblERAssets era
			ON era.intEmployerID = j.intEmployerID
			INNER JOIN		tblStates s
			ON j.state = s.intOldId			
			WHERE j.intEmployerID in (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.employerIds#" />)
			<cfif variables.machine NEQ "DEV" AND variables.machine NEQ "LOCAL">
				AND j.blnActive=1
				AND j.blnValidated=1
				AND j.blnArchived=0
			</cfif>
			AND j.sourceApp in ('#variables.sourceApp#', 'Both')
			<!--->
			AND j.blnShowCoPage=1
			ORDER BY #corpsort# #CorpSortorder#
			<cfif sort eq "state">,location #corpsortorder#</cfif>
			--->
		</cfquery>
				
		<cfreturn qry_j>
	</cffunction>
	
	<cffunction name="qry_jobAtts" access="public" output="false" returntype="query">
		<cfargument name="intJobId" type="string" required="true" />
		<cfset var qry_a = "" />
		
		<cfquery name="qry_a" datasource="#variables.dsn#">
			SELECT intAttID 
			FROM tblJobAtt (NOLOCK) 
			WHERE intJobId = <cfqueryparam value="#arguments.intJobId#" cfsqltype="cf_sql_integer" /> 
			ORDER BY intAttID 
		</cfquery>
			
		<cfreturn qry_a>
	</cffunction>
	
	<cffunction name="qry_jobIndustries" access="public" output="false" returntype="query">
		<cfargument name="intJobId" type="string" required="true" />
		<cfset var qry_a = "" />
		
		<cfquery name="qry_a" datasource="#variables.dsn#">
			SELECT strIndName
			FROM tblJobAtt ja,
				tblIndustries i
			WHERE ja.intAttID = i.intOldIndId
			AND ja.intJobId = <cfqueryparam value="#arguments.intJobId#" cfsqltype="cf_sql_integer" /> 
			ORDER BY strIndName 
		</cfquery>
			
		<cfreturn qry_a>
	</cffunction>
	
	<cffunction name="qry_jobFunctions" access="public" output="false" returntype="query">
		<cfargument name="intJobId" type="string" required="true" />
		<cfset var qry_a = "" />
		
		<cfquery name="qry_a" datasource="#variables.dsn#">
			SELECT strFunctionName
			FROM tblJobAtt ja,
				tblFunctions i
			WHERE ja.intAttID = i.intOldFunctionId
			AND ja.intJobId = <cfqueryparam value="#arguments.intJobId#" cfsqltype="cf_sql_integer" /> 
			ORDER BY strFunctionName 
		</cfquery>
			
		<cfreturn qry_a>
	</cffunction>
		
</cfcomponent>
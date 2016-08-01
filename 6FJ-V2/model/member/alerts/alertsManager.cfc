<cfcomponent output="false">
	
	<cffunction name="init" access="public" output="false" returntype="alertsManager">
		<cfargument name="dsn" type="string" required="true" />
		
		<cfscript>
			variables.dsn = arguments.dsn;
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getLocations" access="public" output="false" returntype="query">
		<cfargument name="includeAll" type="boolean" required="false" default="0">
		<cfargument name="country" type="string" required="false" default=""/>
		<cfset var qry_locations = "" />
		
		<cfquery name="qry_locations" datasource="#variables.dsn#">
			SELECT [intStateID]
				  ,[intOldID]
				  ,[intERStateID]
				  ,[blnStateInd]
				  ,[blnDisplayInd]
				  ,[intRegionCode]
				  ,[strName]
				  ,[strShortName]
				  ,[strAbbrev]
				  ,[strCountry]
				  ,[intDisplayOrder]
			  FROM tblStates
			  where intDisplayOrder is not null
			  	<cfif arguments.country NEQ ""> 
			  		<cfif arguments.country EQ "INT">
						and strCountry NOT IN ('CA','US')
					<cfelse>
						and strCountry = '#arguments.country#'
					</cfif>
				</cfif>
			  order by intDisplayOrder
  
		</cfquery>
		
		<cfreturn qry_locations>
	</cffunction>
	
	<cffunction name="getSalaries" access="public" output="false" returntype="query">
		<cfset var qry_salaries = "" />
		
		<cfquery name="qry_salaries" datasource="#variables.dsn#">
			SELECT[salaryID]
      ,[salaryDesc]
      ,[salaryActive]
			  FROM tblSalary
			  
			  order by salaryDesc
  
		</cfquery>
		
		<cfreturn qry_salaries>
	</cffunction>
	
</cfcomponent>
<cfcomponent hint="CPL Based Inquires">
<!--- <cfset this.dsn = "6Figs" /> --->

<cffunction name="isCPLValidbyIP" access="public" returntype="boolean" output="false" hint="Returns Whether the CPL is Valid in order to receive international leads">
	<cfargument name="memberid" default="" required="yes" type="string" hint="Member Number" />
	<cfargument name="state" default="" required="yes" type="string" hint="State Selected" />
    <!--- Long Number --->  
    <cfset longnumber = createObject("component","v26fj.model.ip2location").getIpLongNumber() />
        

<!--- 
<cfstoredproc procedure="spS_CPL_IsGeoOkByLongNumber" datasource="#this.dsn#">
            <cfprocparam type="In" cfsqltype="cf_sql_integer" value="#trim(arguments.memberid)#" variable="memberid" null="no">
            <cfprocparam type="In" cfsqltype="cf_sql_integer" value="#trim(longnumber)#" variable="longnumber" null="no">
            <cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#trim(arguments.state)#" variable="state" null="no">
            <cfprocresult name="qgetLocation">
        </cfstoredproc> 
--->


<cfquery name="q" datasource="#application.dsn#">
exec dbo.spS_CPL_IsGeoOkByLongNumber #trim(arguments.memberid)#, #trim(longnumber)#,'#trim(arguments.state)#'
</cfquery>

	
	<cfreturn iif(q.totalcount gt 0,1,0) />
</cffunction>

</cfcomponent>

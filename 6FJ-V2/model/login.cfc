<cfcomponent output="false">
	<cffunction name="init" access="public" output="false" returntype="util">
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
	
	<!--- check for cookies --->
	<cffunction name="getUserCookies" access="public" output="false" returntype="any">
		
	</cffunction>
	
	<cffunction name="setUserCookies" access="public" output="false" returntype="any">
		
	</cffunction>
	
	
	
	<!--- log user in --->
	
	
</cfcomponent>
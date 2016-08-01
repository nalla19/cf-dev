<cfcomponent output="false">
	<cffunction name="init" access="public" output="false" returntype="jobManager">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="machine" type="string" required="true" />
		<cfargument name="sourceApp" type="string" required="true" />
		<cfscript>
			variables.dsn = arguments.dsn;
			variables.machine = arguments.machine;
			variables.sourceApp = arguments.sourceApp;
			
			variables.jobGateway = createObject('component', 'jobGateway').init(dsn=variables.dsn,
																				machine=variables.machine,
																				sourceApp=variables.sourceApp);
			
			return this;
		</cfscript>
	</cffunction>
	
		
</cfcomponent>
<cfcomponent>
	<cfparam name="variables.dsn" default="6figs">
	
	<cffunction name="init" access="public" output="false" returntype="resume">
		<cfargument name="dsn" type="string" required="true" />
		<!--- <cfargument name="resumeroot" type="string" required="true" /> --->
		<cfscript>
			variables.dsn = arguments.dsn;
			//variables.resumeroot = arguments.resumeroot;

			return this;
		</cfscript>
	</cffunction>
	
	<cffunction access="public" name="updateUserProfile" output="false" returntype="numeric" hint="Returns ResumeID">
	</cffunction>
</cfcomponent>
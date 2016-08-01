<cfcomponent displayname="Application" output="false">
	<cfscript>
		variables.MyMappings = StructNew();
		
		if (cgi.HTTP_HOST contains "xxxx") {
			variables.MyMappings["/v16fj"] = "xxxx";
			variables.MyMappings["/v26fj"] = "xxxx";
			this.customTagPaths = "xxxx";
		} else if (cgi.HTTP_HOST contains "xxxx") {
			variables.MyMappings["/v16fj"] = "xxxx";
			variables.MyMappings["/v26fj"] = "xxxx";
			this.customTagPaths = "xxxxx";
		} else {
			variables.MyMappings["/v16fj"] = "xxxx";
			variables.MyMappings["/v26fj"] = "Cxxxx";
			this.customTagPaths = "xxxxx";
		}

		this.name = "xxxx";
		this.mappings = MyMappings;
		this.clientmanagement = "no";
		this.sessionmanagement = "yes";
		this.setclientcookies = "yes";
		this.setdomaincookies = "no";
		this.sessiontimeout = CreateTimeSpan(0,0,40,0);

		//set reload to 0 when in production (when 1 the onAppStart runs on every page load for development)
		variables.reload = 0;
	</cfscript>

	<cffunction name="onApplicationStart" output="false">
		<cfscript>
			application.thisYear = dateformat(now(), 'YYYY');
			
			//appversionnumber is used in the css and js script includes, to avoid cache issues
			application.dateInitialized = now();
			application.appVersionNumber = (application.dateInitialized * 1);

			application.sourceApp = "6FigureJobs";
			
			application.sixfj.paths.webroot = GetDirectoryFromPath(GetCurrentTemplatePath());
			
			application.linkedin = structNew();
			
			application.encryptionKeyRM = "xxxxx";
			
			//Learn365 API			
			application.api365URL = "xxxx";
			application.api365KeyName = "xxxxx";
			application.api365SourceName = "CallidusCloud";
			
			//application.url var setup
			if (cgi.HTTP_HOST EQ "xxxxxx" OR cgi.HTTP_HOST EQ "xxxx") {
				application.machine 					= "LIVE";
				application.url 						= "xxxxx";
				application.secureURL					= "xxxx";
				application.v1URL						= "xxxx";
				application.v1SecureURL					= "xxxx";
				application.dsn 						= "6Figs";
				
				application.sixfj.paths.resumeroot		= "xxxxxx";

				application.SOLRjobServer				= "xxxxx";
				application.SOLRjobServerPort			= "xxxx";
				application.SOLRresumeServer			= "xxxx";
				application.SOLRresumeServerPort		= "xxxx";
				application.SOLRpath					= "/solr/jobs";
				application.parserURL					= "xxxxx";
				
				application.linkedin.apikey 			= "xxxxx";
				application.linkedin.secretkey	 		= "xxxxx";

			}  else if (cgi.HTTP_HOST EQ "uat.6figurejobs.com") {
				application.machine 					= "UAT";
				application.url 						= "xxxxx";
				application.secureURL					= "xxxx";
				application.v1URL						= "xxxxx";
				application.v1SecureURL					= "xxxx";
				application.dsn 						= "6Figs";
				
				application.sixfj.paths.resumeroot 		= "xxxxxx";

				application.SOLRjobServer				= "xxxxx";
				application.SOLRjobServerPort			= "xxx";
				application.SOLRresumeServer			= "xxxxx";
				application.SOLRresumeServerPort		= "xxxx";
				application.SOLRpath					= "/solr/jobs";
				application.parserURL					= "xxxxxx";
				
				application.linkedin.apikey 			= "xxxxx";
				application.linkedin.secretkey 			= "xxxxx";

			} else {
				application.machine 					= "LOCAL";
				application.url 						= "xxxx";
				application.secureURL					= "xxxx";
				application.v1URL						= "xxxxx";
				application.v1SecureURL					= "xxxxxx";
				application.dsn 						= "6Figs";
				
				//application.sixfj.paths.resumeroot 		= "#application.sixfj.paths.webroot#\Upload\Attachments\";

				application.SOLRjobServer				= "xxxx";
				application.SOLRjobServerPort			= "xxxx";
				application.SOLRresumeServer			= "xxxx";
				application.SOLRresumeServerPort		= "xxxx";
				application.SOLRpath					= "/solr/jobs";
				application.parserURL					= "xxxxx";
				
				application.linkedin.apikey 			= "xxxxx";
				application.linkedin.secretkey 			= "xxxxx";

			}


			//no clue what this is but it is on some links from the prev site
			application.strAppAddToken 			= "100k=1";
			application.defaultEmail 			= "ixxxxx";


			// Get the base directory for the application.
			application.rootDirectory 			= getDirectoryFromPath( expandPath('../') );
			// Get the temp directory for scratch disk.
			application.tempDirectory 			= "#application.rootDirectory#temp/";
			

			//managers (stored in the application scope for performance)
			application.executive = createObject('component', 'v26fj.model.member.executive').init(
											dsn			= application.dsn,
											dsnAllen	= 'allen',
											url			= application.parserURL,
											sourceApp=application.sourceApp);
											
			application.resume = createObject('component', 'v26fj.model.member.resume').init(
											dsn			= application.dsn,
											resumeroot	= application.sixfj.paths.resumeroot);
											
			application.registration = createObject('component', 'v26fj.model.join.registration').init(
			dsn=application.dsn);
											
			
			application.jobManager = createObject('component', 'v26fj.model.job.jobManager').init(
												dsn=application.dsn,
												machine=application.machine,
												sourceApp=application.sourceApp);

			application.companyManager = createObject('component', 'v26fj.model.company.companyManager').init(
												dsn=application.dsn,
												jobManager=application.jobManager);

			application.industryManager = createObject('component', 'v16fj._includes.model.industryManager').init(
												dsn=application.dsn);
												
			application.functionManager = createObject('component', 'v16fj._includes.model.functionManager').init(
			dsn=application.dsn);
			
			application.alertsManager = createObject('component', 'v26fj.model.member.alerts.alertsManager').init(
			dsn=application.dsn);

			application.util = createObject('component', 'v26fj.model.util').init(
												dsn=application.dsn,
												machine=application.machine,
												sourceApp=application.sourceApp);

			application.emailManager = createObject('component', 'v26fj.model.emailManager').init(
														dsn			= application.dsn,
														sourceApp	= application.sourceApp,
														defaultEmail= application.defaultEmail,
														url 		= application.url);
														
			application.leadFormixManager = createObject('component', 'v16fj._includes.model.leadFormixManager').init(
											dsn			= application.dsn,
											sourceApp	= application.sourceApp);
											
			application.payflowpro = createObject('component', 'v26fj.model.join.payflowpro').init(
														dsn			= application.dsn,
														machine		= application.machine,
														resume		= application.resume,
														profileName = "Learn365 Membership");
														
		 application.premium = createObject('component', 'v26fj.model.join.premium').init(
											dsn			= application.dsn,
											executive	= application.executive,
											payflowpro	= application.payflowpro,
											resume		= application.resume);
		</cfscript>

		<!--- include v1 recruiter pricing packages which get stored in the application scope --->
		<cfinclude template="/v16fj/t_erPackages.cfm">
	</cffunction>

	<cffunction name="onApplicationEnd" output="false">

	</cffunction>

	<cffunction name="onSessionStart" output="false">
		
	</cffunction>

	<cffunction name="onSessionEnd" output="false">

	</cffunction>

	<cffunction name="onRequestStart" output="false" hint="setup to trigger the application reload if variables are set">
		<cfif variables.reload EQ 1 OR isDefined("url.reinit")>
			<cfset url.reinitpkg = 1 /><!--- for v1 recuriter pricing package reload --->
			<cfset OnApplicationStart() />
		</cfif>
		
		
		
	</cffunction>

	<cffunction name="onRequestEnd" output="false">

	</cffunction>

	<cffunction name="onError" hint="triggered whenever an application error happens">
		<cfargument name="exception" type="any" required="true" hint="I am the error object." />
		<cfset var ErrorDumps = "" />
		<cfset var TempErrorFileName = "" />

		<!--- Save the Dumps --->
		<cfsavecontent variable = "ErrorDumps">
			<cfif IsDefined('ARGUMENTS.Exception')>
				<cfdump var="#ARGUMENTS.Exception#" label="ARGUMENTS.Exception"><br>
			</cfif>

			<cfdump var="#variables#" Expand="Yes" label="Local Variables"><br>

		    Application<BR><cfdump var="#application#" label = "Application Variables" metainfo="no" showUDfs="no" hide="EncryptionKey"><BR>
		    <cfif isDefined("session")>
		    	Session<BR><cfdump var="#session#" label = "Session Variables"><BR>
			</cfif>
		    Client<BR><cfdump var="#client#" label = "Client Variables"><BR>
		    Cookie<BR><cfdump var="#cookie#" label = "Cookie Variables"><BR>
		    Form<BR><cfdump var="#form#" label = "Form Variables"><BR>
			Request<BR><cfdump var="#request#" label = "Request Variables"><BR>
		    Url<BR><cfdump var="#url#" label = "URL Variables"><BR>
		    Cgi<BR><cfdump var="#cgi#" label = "CGI Variables">
		</cfsavecontent>

		<!--- temp dump to override beta server error catching --->
		<cfheader statuscode="500">


		<cfif application.machine NEQ "LOCAL" AND cgi.remote_addr NEQ "xxxxxx" and cgi.remote_addr NEQ "xxxxxx" and cgi.REMOTE_ADDR NEQ "xxxxx" AND cgi.REMOTE_ADDR NEQ "xxxx0" and cgi.REMOTE_ADDR NEQ "xxxxx">

			<!--- Create temp htm file --->
			<cfset TempErrorFileName = "Error_#DateFormat(Now(), 'mmddyy')##TimeFormat(Now(), 'HHmmss')#.htm">
			<cffile action="WRITE"
			        file="#application.tempDirectory##TempErrorFileName#"
			        output="#ErrorDumps#"
			        addnewline="Yes"
			        fixnewline="No">

			<!--- Attach to error email --->
			<cfmail from="xxxxx" to="xxxxxxx@calliduscloud.com,venkatram.nalla@6figurejobs.com" subject="CFERROR: [#application.machine#] v2.6figurejobs.com" type="html">
				Please see the attached file for the error details.<br><br>
				<cfif Len(cgi.http_user_agent)>CGI.HTTP_USER_AGENT: #cgi.http_user_agent#<br><br></cfif>
				<cfif Len(cgi.remote_addr)>CGI.REMOTE_ADDR: #cgi.remote_addr#<br></cfif>
				<cfif Len(cgi.remote_host)>CGI.REMOTE_HOST: #cgi.remote_host#</cfif>
				<!--- Remove=true will delete the temporary file once it is sent cffile action=delete can't be used as it might delete the file before it is sent --->
				<cfmailparam file = "#application.tempDirectory##TempErrorFileName#" type="html" remove="true">
			</cfmail>

		<cfelse>
			<cfoutput>#ErrorDumps#</cfoutput>
		</cfif>
		<cfabort>
	</cffunction>


</cfcomponent>
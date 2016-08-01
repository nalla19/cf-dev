<cfcomponent displayname="Application" output="false">
	<cfscript>
		variables.MyMappings = StructNew();
		
		if (cgi.HTTP_HOST contains "uat.6figurejobs.com") {
			variables.MyMappings["/v16fj"] = "C:\webroot\6figurejobs\";
			variables.MyMappings["/v26fj"] = "C:\webroot\v2.6figurejobs.com\";
			this.customTagPaths = "C:\webroot\6figurejobs.com\_customTags\";
		} else if (cgi.HTTP_HOST contains "v2.6figurejobs.localhost") {
			variables.MyMappings["/v16fj"] = "C:\websites\v1.6figurejobs.com\";
			variables.MyMappings["/v26fj"] = "C:\websites\v2.6figurejobs.com\";
			this.customTagPaths = "C:\websites\v1.6figurejobs.com\_customTags\";
		} else {
			variables.MyMappings["/v16fj"] = "C:\webroot\6figurejobs\";
			variables.MyMappings["/v26fj"] = "C:\webroot\v2.6figurejobs.com\";
			this.customTagPaths = "C:\webroot\6figurejobs.com\_customTags\";
		}

		this.name = "v2.6figurejobs.com";
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
			
			application.encryptionKeyRM = "qxhu4OR+QQZ/yWRkE4t5Jw==";
			
			//Learn365 API			
			application.api365URL = "https://api.litmos.com/v1.svc/";
			application.api365KeyName = "52D0A2AE-BB48-452E-862C-99BAC93B1C13";
			application.api365SourceName = "CallidusCloud";
			
			//application.url var setup
			if (cgi.HTTP_HOST EQ "www.6figurejobs.com" OR cgi.HTTP_HOST EQ "6figurejobs.com") {
				application.machine 					= "LIVE";
				application.url 						= "https://www.6figurejobs.com";
				application.secureURL					= "https://www.6figurejobs.com";
				application.v1URL						= "https://access.6figurejobs.com";
				application.v1SecureURL					= "https://access.6figurejobs.com";
				application.dsn 						= "6Figs";
				
				application.sixfj.paths.resumeroot		= "\\444854-DB1\Upload\Attachments\";

				application.SOLRjobServer				= "192.168.100.23";
				application.SOLRjobServerPort			= "8983";
				application.SOLRresumeServer			= "198.61.145.28";
				application.SOLRresumeServerPort		= "9100";
				application.SOLRpath					= "/solr/jobs";
				application.parserURL					= "http://198.61.145.20";
				
				application.linkedin.apikey 			= "dkk3v7yu4h1o";
				application.linkedin.secretkey	 		= "j3wLPz6Cy3a2s7tU";

			}  else if (cgi.HTTP_HOST EQ "uat.6figurejobs.com") {
				application.machine 					= "UAT";
				application.url 						= "http://uat.6figurejobs.com";
				application.secureURL					= "http://uat.6figurejobs.com";
				application.v1URL						= "http://uat2.6figurejobs.com";
				application.v1SecureURL					= "https://uat2.6figurejobs.com";
				application.dsn 						= "6Figs";
				
				application.sixfj.paths.resumeroot 		= "C:\webroot\6figurejobs\exports\Upload\Attachments\";

				application.SOLRjobServer				= "198.61.145.27";
				application.SOLRjobServerPort			= "8983";
				application.SOLRresumeServer			= "198.61.145.27";
				application.SOLRresumeServerPort		= "9100";
				application.SOLRpath					= "/solr/jobs";
				application.parserURL					= "http://uat2.6figurejobs.com/extensions/components/executives";
				
				application.linkedin.apikey 			= "6xvzbqrg07bf";
				application.linkedin.secretkey 			= "i1uMeFXVh9Apxb34";

			} else {
				application.machine 					= "LOCAL";
				application.url 						= "http://v2.6figurejobs.localhost";
				application.secureURL					= "http://v2.6figurejobs.localhost";
				application.v1URL						= "http://6figurejobs.localhost";
				application.v1SecureURL					= "http://6figurejobs.localhost";
				application.dsn 						= "6Figs";
				
				//application.sixfj.paths.resumeroot 		= "#application.sixfj.paths.webroot#\Upload\Attachments\";

				application.SOLRjobServer				= "198.61.145.27";
				application.SOLRjobServerPort			= "8983";
				application.SOLRresumeServer			= "198.61.145.27";
				application.SOLRresumeServerPort		= "9100";
				application.SOLRpath					= "/solr/jobs";
				application.parserURL					= "http://uat2.6figurejobs.com/extensions/components/executives";
				
				application.linkedin.apikey 			= "6xvzbqrg07bf";
				application.linkedin.secretkey 			= "i1uMeFXVh9Apxb34";

			}


			//no clue what this is but it is on some links from the prev site
			application.strAppAddToken 			= "100k=1";
			application.defaultEmail 			= "info@6figurejobs.com";


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


		<cfif application.machine NEQ "LOCAL" AND cgi.remote_addr NEQ "104.1.83.217" and cgi.remote_addr NEQ "76.23.141.164" and cgi.REMOTE_ADDR NEQ "207.237.212.168" AND cgi.REMOTE_ADDR NEQ "108.228.61.0" and cgi.REMOTE_ADDR NEQ "162.17.1.181">

			<!--- Create temp htm file --->
			<cfset TempErrorFileName = "Error_#DateFormat(Now(), 'mmddyy')##TimeFormat(Now(), 'HHmmss')#.htm">
			<cffile action="WRITE"
			        file="#application.tempDirectory##TempErrorFileName#"
			        output="#ErrorDumps#"
			        addnewline="Yes"
			        fixnewline="No">

			<!--- Attach to error email --->
			<cfmail from="errors@epicenterconsulting.com" to="irodela@calliduscloud.com,venkatram.nalla@6figurejobs.com" subject="CFERROR: [#application.machine#] v2.6figurejobs.com" type="html">
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
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


	<!--- start CRUD methods --->
	<cffunction name="getJob" access="public" output="false" returntype="job">
		<cfargument name="intJobId" type="numeric" required="false" default="" />
		<cfargument name="includeIndustries" type="boolean" required="false" default="true" />
		<cfargument name="includeFunctions" type="boolean" required="false" default="true" />
		<cfset var job = createObject('component', 'job') />
		
		<cfif intJobId GT 0>
			<cfset job = setJob(qry_job=variables.jobGateway.read(
											intJobId=arguments.intJobId),
										queryRow=1,
										includeIndustries=arguments.includeIndustries,
										includeFunctions=arguments.includeFunctions) />
		</cfif>
		
		<cfreturn job>
	</cffunction>

	<cffunction name="setJob" access="private" output="false" returntype="job">
		<cfargument name="qry_job" type="query" required="true" />
		<cfargument name="queryRow" type="numeric" required="true" />
		<cfargument name="job" type="job" required="false" />
		
		<cfargument name="includeIndustries" type="boolean" required="false" default="false" />
		<cfargument name="includeFunctions" type="boolean" required="false" default="false" />
		
		<cfif NOT isDefined("arguments.job")>
			<cfset arguments.job = createObject('component', 'job') />
		</cfif>
		
		<cfif arguments.qry_job.recordcount GTE arguments.queryRow>
			<cfscript>
				arguments.job.setIntJobId(qry_job.intJobId[arguments.queryRow]);

				arguments.job.setJpname(qry_job.jpname[arguments.queryRow]);
				arguments.job.setTitle(qry_job.title[arguments.queryRow]);
				arguments.job.setLocation(qry_job.location[arguments.queryRow]);
				
				arguments.job.setintEmployerId(qry_job.intEmployerId[arguments.queryRow]);
				
				if (isDefined("qry_job.description")) {
					arguments.job.setDescription(qry_job.description[arguments.queryRow]);
				}
				
				arguments.job.setState(qry_job.state[arguments.queryRow]);
				
				arguments.job.setStrOpportunity(qry_job.strOpportunity[arguments.queryRow]);
				arguments.job.setDate_Submitted(qry_job.date_submitted[arguments.queryRow]);
				arguments.job.setSeoJobURL(qry_job.seojoburl[arguments.queryRow]);
				
				arguments.job.setFltSalary_desiredlow(qry_job.fltSalary_desiredlow[arguments.queryRow]);
				
				if (arguments.includeIndustries) {
					arguments.job.setJobIndustries(variables.jobGateway.qry_jobIndustries(intJobId=arguments.job.getIntJobId()));
				}
				
				if (arguments.includeFunctions) {
					arguments.job.setJobFunctions(variables.jobGateway.qry_jobFunctions(intJobId=arguments.job.getIntJobId()));
				}
				
				arguments.job.setStrAboutCompany(qry_job.strAboutCompany[arguments.queryRow]);
				arguments.job.setStrCompanyPerks(qry_job.strCompanyPerks[arguments.queryRow]);
				arguments.job.setStrMasterLogo(qry_job.strMasterLogo[arguments.queryRow]);
				arguments.job.setStrMasterLogoAltTag(qry_job.strMasterLogoAltTag[arguments.queryRow]);
				
			</cfscript>
		</cfif>
		
		<cfreturn arguments.job>
	</cffunction>
	<!--- end CRUD methods --->



	<!--- start query/data methods --->
	<cffunction name="getEmployerJobs" access="public" output="false" returntype="array">
		<cfargument name="employerIds" type="string" required="true">
		<cfset var ary_jobs = ArrayNew(1) />
		<cfset var qry_jobs = variables.jobGateway.qry_employerJobs(employerIds=arguments.employerIds) />
		
		<cfloop query="qry_jobs">
			<cfset ary_jobs[qry_jobs.currentrow] = setJob(
															qry_job 		= qry_jobs,
															queryRow 		= qry_jobs.currentrow) />
		</cfloop>
		
		<cfreturn ary_jobs>
	</cffunction>
	
	<cffunction name="getJobFunctions" access="public" output="false" returntype="query">
		<cfif cfqJobAtts.RecordCount gt 0>
			<cfset listintAttIDs=#ValueList(cfqJobAtts.intAttID)# />
			
			<!--- build Cat Att list --->
			<cfloop list="#listintAttIDs#" index="ListElement">
				<cfloop index="intIndexNo" from="1" to="#intIndsArrLen#">
					<cfif ListElement eq #arrInds[intIndexNo][1]#>
						<cfset intsIndIDs=ListAppend(intsIndIDs, '#arrInds[intIndexNo][1]#') />
					</cfif>
				</cfloop>
			</cfloop>
			
			<!--- build Func Att list --->
			<cfloop list="#listintAttIDs#" index="ListElement">
				<cfloop index="intIndexNo" from="1" to="#intFuncsArrLen#">
					<cfif ListElement eq arrFuncs[intIndexNo][1]>
						<cfset intsFuncIDs=ListAppend(intsFuncIDs, '#arrFuncs[intIndexNo][1]#') />
					</cfif>
				</cfloop>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="getJobIndustries" access="public" output="false" returntype="query">
	
	</cffunction>
	<!--- end query/data methods --->



	
	<!--- start misc methods --->
		
	<!--- end misc methods --->

</cfcomponent>
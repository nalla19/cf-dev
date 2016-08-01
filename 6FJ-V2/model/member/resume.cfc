<cfcomponent output="false">
	
	<cfparam name="variables.dsn" default="6figs">
	
	<cffunction name="init" access="public" output="false" returntype="resume">
		<cfargument name="dsn" type="string" required="true" />
		<cfargument name="resumeroot" type="string" required="true" />
		<cfscript>
			variables.dsn = arguments.dsn;
			variables.resumeroot = arguments.resumeroot;

			return this;
		</cfscript>
	</cffunction>
	

	<cffunction name="getResume" access="public" returntype="query" hint="Returns the resume">
		<cfargument type="numeric" name="resumeid" required="yes" default="0" hint="Resume ID" />
		<cfset var q = "" />
		
		<cfstoredproc procedure="spS_ExecResumeRead" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(session.exec.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@resumeid" value="#val(arguments.resumeid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocresult resultset="1" name="q">
		</cfstoredproc>
		
		<cfreturn q />
	</cffunction>
	
	<cffunction name="getResumeDetail" access="public" returntype="query" hint="Insert Resume">
		<cfargument type="numeric" name="intresid" required="yes" default="0" hint="Resume ID" />
		<cfset var q = "" />
		
		<cfstoredproc procedure="sp_readResume" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(arguments.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocresult resultset="1" name="q">
		</cfstoredproc>
		
		<cfreturn q />
	</cffunction>
	


	<cffunction name="getAAAResume" access="remote" returntype="any" hint="Returns the AAA Resume for Ice">
		<cfargument type="string" name="passcode" required="yes" default="0" hint="AAA Specialized Code" />
		<cfargument type="string" name="emailaddress" required="yes" default="" hint="Email Assoicated With Account" />
		<cfargument type="numeric" name="intresid" required="yes" default="0" hint="Resume ID" />
		<cfscript>
			var resObj = createObject("component","/6fj/execs/resbuilder/components/executive");
			if (isvalid("email",arguments.emailaddress)){
				 arguments.intresid = resObj.getResumeidByEmail(arguments.emailaddress).intresid;
			}
		</cfscript>
		
		<cfif (arguments.passcode eq "clientpush") and (len(arguments.emailaddress) or arguments.intresid neq 0)>
			<cfscript>
				clientFile = getResumesQuery(arguments.intresid).resumefile;
				resumeFile = getResumeDir(arguments.intresid) & clientFile;
				resumeFile = trim(resumeFile);
			</cfscript>
			
			<!--- If File Exists --->
			<cfif fileExists(resumeFile)>
				<cfheader name="Content-Disposition" value="inline; filename=#clientFile#">
				<cfcontent type="application/msword" file="#resumeFile#">
			</cfif>
		</cfif>
		
		<cfreturn 1 />
	</cffunction>



	<cffunction name="getResumesQuery" access="private" returntype="query" hint="Same As Below">
		<cfargument type="numeric" name="intresid" required="yes" default="0" hint="Resume ID" />
		<cfset var q = "" />
		
		<cfstoredproc procedure="spS_ExecResumeManager" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(arguments.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocresult resultset="1" name="q">
		</cfstoredproc>
		
		<cfreturn q />
	</cffunction>

	<cffunction name="getResumes" access="public" returntype="query" hint="Returns the list of resumes that are in the profiles table">
		<cfset var q = "" />
		
		<cfstoredproc procedure="spS_ExecResumeManager" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(session.exec.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocresult resultset="1" name="q">
		</cfstoredproc>
		
		<cfreturn q />
	</cffunction>
	


	<cffunction name="setActiveResume" access="public" returntype="query" hint="Returns the list of resumes">
		<cfargument type="numeric" name="resumeid" required="yes" default="0" hint="Resume ID" />
		<cfargument type="numeric" name="resSearchable" required="yes" default="0" hint="Resume Searchable" />
		<cfset var q = "" />
		
		<cfstoredproc procedure="spU_ExecResumeSearchable" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(session.exec.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@resumeid" value="#val(arguments.resumeid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@resSearchable" value="#val(arguments.resSearchable)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocresult resultset="1" name="q">
		</cfstoredproc>
		
		<cfreturn q />
	</cffunction>


	<cffunction name="updateSummary" access="public" returntype="void" hint="Insert Resume">
		<cfargument type="string" name="jobTitle1" required="yes" default="" hint="" />
		<cfargument type="string" name="jobCompany1" required="yes" default="" hint="" />
		<cfargument type="string" name="jobDescription1" required="yes" default="" hint="" />
		<cfargument type="string" name="jobTitle2" required="yes" default="" hint="" />
		<cfargument type="string" name="jobCompany2" required="yes" default="" hint="" />
		<cfargument type="string" name="jobDescription2" required="yes" default="" hint="" />
		<cfargument type="string" name="description" required="yes" default="" hint="" />
		<cfset var resInfo = getResumeDetail(session.exec.intresid) />
		
		<cfstoredproc procedure="sp_exec_stepfour" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intProcType" value="2" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(session.exec.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@listCompletedSteps" value="#resInfo.listCompletedSteps#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@description" value="#arguments.description#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@strExecJobTitle_1" value="#arguments.jobTitle1#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@strExecJOBCompany_1" value="#arguments.jobCompany1#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@strExecJOBDescr_1" value="#arguments.jobDescription1#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@strExecJobTitle_2" value="#arguments.jobTitle2#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@strExecJOBCompany_2" value="#arguments.jobCompany2#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@strExecJOBDescr_2" value="#arguments.jobDescription2#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@resume" value="#resInfo.resume#" cfsqltype="cf_sql_varchar">
		</cfstoredproc>
	</cffunction>




	<cffunction name="insertResume" access="public" returntype="void" hint="Insert Resume">
		<cfargument type="string" name="title" required="yes" default="" hint="Resume Title" />
		<cfargument type="string" name="resume" required="yes" default="" hint="Resume" />
		<cfargument type="string" name="resumeFile" required="yes" default="" hint="Resume File" />
		
		<cfstoredproc procedure="spI_ExecResumeManager" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(session.exec.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@title" value="#arguments.title#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@resume" value="#arguments.resume#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@resumeFile" value="#arguments.resumeFile#" cfsqltype="cf_sql_varchar">
		</cfstoredproc>
	</cffunction>

	<cffunction name="updateResume" access="public" returntype="void" hint="Update Resume">
		<cfargument type="numeric" name="resumeid" required="yes" default="0" hint="Resume ID" />
		<cfargument type="string" name="title" required="yes" default="" hint="Resume Title" />
		<cfargument type="string" name="resume" required="yes" default="" hint="Resume" />
		<cfargument type="string" name="resfile" required="yes" default="" hint="Resume File" />
		
		<cfstoredproc procedure="spU_ExecResumeManagerUpdate" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(session.exec.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@resumeid" value="#val(arguments.resumeid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@title" value="#arguments.title#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@resume" value="#arguments.resume#" cfsqltype="CF_SQL_LONGVARCHAR">
			<cfprocparam type="IN" dbvarname="@resfile" value="#arguments.resfile#" cfsqltype="cf_sql_varchar">
		</cfstoredproc>
	</cffunction>

	<cffunction name="deleteResume" access="public" returntype="void" hint="Delete Resume">
		<cfargument type="numeric" name="resumeid" required="yes" default="0" hint="Resume ID" />
		
		<cfstoredproc procedure="spD_ExecResumeManager" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(session.exec.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@resumeid" value="#val(arguments.resumeid)#" cfsqltype="CF_SQL_INTEGER">
		</cfstoredproc>
	</cffunction>



	<cffunction name="setResumePath" access="public" returnType="void" output="false" hint="Set Resume Directory">
		<cfargument name="intresid" type="numeric" required="true" />
		<cfscript>
			var myNumDir = "" ;
			var dir = "";
			
			for (dirBuilder = 1; dirBuilder lte len(arguments.intresid); dirBuilder = dirBuilder + 1){
				myNumDir = listappend(myNumDir,left(arguments.intresid,dirBuilder),"\") ;
				dir = variables.resumeroot & myNumDir & "\";
			}
		</cfscript>
		
		<!--- Set Resume Directory --->
		<cfif len(dir) and not(directoryExists(dir))>
			<cftry>
				<!--- Try To Create Directory --->
				<cfdirectory directory="#dir#" action="create" />
				<cfcatch type="any"><!--- Disregard Errors ---></cfcatch>
			</cftry>
		</cfif>
	</cffunction>

	<cffunction name="getResumePath" hint="Get Resume Resume Path" returnType="string">
		<cfargument name="intresid" type="numeric" required="true" />
		<cfscript>
			var myNumDir = "" ;
			var dir = "";
			
			for (dirBuilder = 1; dirBuilder lte len(arguments.intresid); dirBuilder = dirBuilder + 1){
				myNumDir = listappend(myNumDir,left(arguments.intresid,dirBuilder),"/") ;
				dir = "/" & myNumDir & "/";
			}
			
			return "/resumes" & dir;
		</cfscript>
	</cffunction>

	<cffunction name="getResumeDir" hint="Get Resume Resume Director" returnType="string">
		<cfargument name="intresid" type="numeric" required="true" />
		<cfscript>
			var myNumDir = "" ;
			var dir = "";
			
			for (dirBuilder = 1; dirBuilder lte len(arguments.intresid); dirBuilder = dirBuilder + 1){
				myNumDir = listappend(myNumDir,left(arguments.intresid,dirBuilder),"\") ;
				dir = variables.resumeroot &  myNumDir & "\";
			}
			
			return dir;
		</cfscript>
	</cffunction>



	<cffunction name="getCoverLetters" access="public" returntype="query" hint="Returns the list of Cover Letters that are in the tblCoverLetters">
		<cfargument type="numeric" name="intresid" required="yes" default="0" hint="Resume ID" />
		<cfstoredproc procedure="sp_exec_getCoverLetters" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(arguments.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocresult resultset="1" name="q">
		</cfstoredproc>
		<cfreturn q />
	</cffunction>

	<cffunction name="getCoverLetterDetails" access="public" returntype="query" hint="Returns the cover letters details from tblCoverLetters">
		<cfargument type="numeric" name="letterid" required="yes" default="0" hint="Resume ID" />
		<cfset var q = "" />
		
		<cfstoredproc procedure="sp_readCoverLetter" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@letterid" value="#val(arguments.letterid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocresult resultset="1" name="q">
		</cfstoredproc>
		
		<cfreturn q />
	</cffunction>



	<cffunction name="updateCoverLetter" access="public" returntype="void" hint="Update Cover Letter">
		<cfargument type="numeric" name="letterid" required="yes" default="0" hint="Cover Letter ID" />
		<cfargument type="string" name="title" required="yes" default="" hint="Cover Letter Title" />
		<cfargument type="string" name="coverletter" required="yes" default="" hint="Cover Letter" />
		
		<cfstoredproc procedure="spU_ExecCoverLetterUpdate" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(session.exec.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@letterid" value="#val(arguments.letterid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@title" value="#arguments.title#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@coverletter" value="#arguments.coverletter#" cfsqltype="cf_sql_varchar">
		</cfstoredproc>
	</cffunction>

	<cffunction name="deleteCoverLetter" access="public" returntype="void" hint="Delete Cover Letter">
		<cfargument type="numeric" name="letterid" required="yes" default="0" hint="Cover Letter ID" />
		
		<cfstoredproc procedure="spD_ExecCoverLetter" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(session.exec.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@letterid" value="#val(arguments.letterid)#" cfsqltype="CF_SQL_INTEGER">
		</cfstoredproc>
	</cffunction>

	<cffunction name="insertCoverLetter" access="public" returntype="void" hint="Insert Cover Letter">
		<cfargument type="string" name="title" required="yes" default="" hint="Cover Letter Title" />
		<cfargument type="string" name="coverletter" required="yes" default="" hint="Cover Letter" />
		
		<cfstoredproc procedure="spI_ExecCoverLetter" datasource="#variables.dsn#" returncode="Yes">
			<cfprocparam type="IN" dbvarname="@intresid" value="#val(session.exec.intresid)#" cfsqltype="CF_SQL_INTEGER">
			<cfprocparam type="IN" dbvarname="@title" value="#arguments.title#" cfsqltype="cf_sql_varchar">
			<cfprocparam type="IN" dbvarname="@coverletter" value="#arguments.coverletter#" cfsqltype="cf_sql_varchar">
		</cfstoredproc>
	</cffunction>

</cfcomponent>
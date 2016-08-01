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


	<!--- start query/data methods --->
	<cffunction name="getIndustries" access="public" output="false" returntype="query">
		<cfset var qry_industries = "" />
		<cfset var i = "" />

		<cfquery name="qry_industries" datasource="#variables.dsn#">
			SELECT intOldIndId, strIndName, intSHKeywordID
			FROM tblIndustries
			ORDER BY intindid
		</cfquery>

		<cfreturn qry_industries>
	</cffunction>

	<cffunction name="getFunctions" access="public" output="false" returntype="query">
		<cfset var qry_functions = "" />
		<cfset var i = "" />

		<cfquery name="qry_functions" datasource="#variables.dsn#">
			SELECT intOldFunctionId, strFunctionName, intSHKeywordID
			FROM tblFunctions (nolock)
			ORDER BY strFunctionName
		</cfquery>

		<cfreturn qry_functions>
	</cffunction>

	<cffunction name="getStates" access="public" output="false" returntype="array">
		<cfset var ary_states = ArrayNew(2)>
		<cfset var qry_states = "" />
		<cfset var i = "" />

		<cfquery name="qry_states" datasource="#variables.dsn#">
			SELECT strName,strshortname, intOldId,strAbbrev,strCountry
			  FROM tblstates(nolock)
			 WHERE intStateID not in (1000, 1050, 24000,15200)
		     ORDER BY intDisplayOrder
		</cfquery>

		<cfloop index="i" from="1" to="#qry_states.RecordCount#">
			<cfset ary_states[i][1] = qry_states.intOldId[i]>
            <cfset ary_states[i][2] = qry_states.strName[i]>
            <cfset ary_states[i][3] = qry_states.strAbbrev[i]>
            <cfset ary_states[i][4] = qry_states.strCountry[i]>
            <cfset ary_states[i][5] = qry_states.strShortName[i]>
		</cfloop>

		<cfreturn ary_states>
	</cffunction>

	<cffunction name="getErHowFind" access="public" output="false" returntype="query">
		<cfset var cfqGetERHowFind = "" />

		<cfquery name="cfqGetERHowFind" datasource="#variables.dsn#">
			SELECT intTrackingID, strName, strTrackCode
			FROM tblHowFindTracking (nolock)
			WHERE blnHidden=0
			AND blnDelete=0
			AND blnExec=0
			ORDER BY strName
		</cfquery>

		<cfreturn cfqGetERHowFind>
	</cffunction>
	<!--- end query/data methods --->




	<!--- start misc methods --->
	<cffunction name="getCPLMember" access="public" output="false" returntype="string">
		<cfargument name="intMemberID" type="numeric" required="true" />
		<cfset var qry_cpl = "" />

		<cfquery name="qry_cpl" datasource="#variables.dsn#">
			SELECT cast(replace(replace(cast(strHTMLBody as nvarchar(max)),'$$DQ$$','"'),'$$SQ$$','''') as ntext) as theText
			FROM tblCPLMember (nolock)
			WHERE intMemberID = <cfqueryparam value="#arguments.intMemberID#" cfsqltype="cf_sql_integer" />
			AND blnActive=1
		</cfquery>

		<cfreturn qry_cpl.theText>
	</cffunction>

    <cffunction name="getActiveMembers" access="public" output="false" returntype="numeric">
    	<cfset var qry_activemembers = "" />

		<cfquery name="qry_activemembers" datasource="#variables.dsn#">
			SELECT COUNT(intResID) activemembers
			FROM tblResumes (nolock)
			WHERE blnDelete = <cfqueryparam value="0" cfsqltype="cf_sql_integer" />
			AND intAdmCode in (4,5)
			AND email is not null
			AND sourceApp = <cfqueryparam value="#variables.sourceApp#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn qry_activemembers.activemembers>
	</cffunction>

	<cffunction name="getRecruiterPackage" access="public" output="false" returntype="query">
		<cfargument name="qry_packages" type="query" required="true" />
		<cfargument name="package_id" type="numeric" required="true" />
		<cfset var qry_package = "" />

		<cfquery name="qry_package" dbtype="query">
			SELECT *
			FROM arguments.qry_packages
			WHERE package = <cfqueryparam value="#arguments.package_id#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfreturn qry_package>
	</cffunction>

    <cffunction name="getAdvertisingBanner" access="public" output="false" returntype="query">
		<cfargument name="display_page" type="string" required="true" />
		<cfset var qry_advertisingbanner = "" />

		<cfquery name="qry_advertisingbanner" datasource="#variables.dsn#">
			SELECT *
			FROM tblAdverstingBanner (nolock)
			WHERE blnAdvBannerActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />
			<cfif arguments.display_page is "jobsearch">
				AND blnshowJobsearch = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />
			<cfelseif arguments.display_page is "jobsearchresults">
				AND blnshowJobSearchResults = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />
			</cfif>
		</cfquery>

		<cfreturn qry_advertisingbanner>
	</cffunction>




    <cffunction name="getAverageJobSalary" access="public" output="false" returntype="numeric">
    	<cfset var qry_averagejobsalary = "" />

		<cfquery name="qry_averagejobsalary" datasource="#variables.dsn#">
			 SELECT SUM(B.fltSalary_desiredLow)/COUNT(b.fltSalary_desiredLow) average_job_salary
  			  FROM (
	    			SELECT COUNT(A.fltSalary_desiredLow)cnt, fltSalary_desiredLow
          			  FROM (
                            SELECT intEmployerID,
                                    case
                                    when fltSalary_desiredLow < 100 then 100

                                    when intEmployerID = 19946 then 120

                                    when intEmployerID = 16349 then 150
                                    when intEmployerID = 17498 then 150
                                    when intEmployerID = 17514 then 150

                                    when intEmployerID = 7907 then 130
                                    when intEmployerID = 15074 then 130
                                    when intEmployerID = 17435 then 130
                                    else fltSalary_desiredLow
                                    end fltSalary_desiredLow
                               FROM tblJobs (nolock)
                              WHERE 1=1
                                AND blnActive = 1
                                AND intEmployerID > 0
                                AND sourceApp = <cfqueryparam value="#variables.sourceApp#" cfsqltype="cf_sql_varchar">
				           ) A
  					 WHERE 1=1
                     GROUP BY A.fltSalary_desiredLow
				  )B
		</cfquery>

		<cfreturn qry_averagejobsalary.average_job_salary>
	</cffunction>


	<cffunction name="getMemberLoginInfo" access="public" output="false" returntype="query">
		<cfargument name="username" type="string" required="true" />
		<cfset var qry_memberlogininfo = "" />

		<cfquery name="qry_memberlogininfo" datasource="#variables.dsn#">
			SELECT fname, lname, email, username, password, intAdmCode, blndelete
			FROM tblResumes (nolock)
			WHERE (email = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar"> or username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">)
			AND sourceApp = <cfqueryparam value="#variables.sourceApp#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn qry_memberlogininfo>
	</cffunction>


	<cffunction name="getRecruiterLoginInfo" access="public" output="false" returntype="query">
		<cfargument name="email" type="string" required="true" />
		<cfset var qry_recruiterlogininfo = "" />

		<cfquery name="qry_recruiterlogininfo" datasource="#variables.dsn#">
			SELECT pwd.strFirstName, pwd.strLastName, pwd.strEmail, emp.strusername, pwd.strPassword, emp.dteAcctExp
			FROM tblEmployers emp (nolock)
				INNER JOIN tblERPwds pwd (nolock)
					ON pwd.intEmployerID = emp.intEmployerID
			WHERE pwd.strEmail = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
			AND emp.sourceApp = <cfqueryparam value="#variables.sourceApp#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn qry_recruiterlogininfo>
	</cffunction>

	<cffunction name="getIndustryDemographics" access="public" output="false" returntype="query">
		<cfset var qry_topindustries = "" />

		<cfquery name="qry_topindustries" datasource="#variables.dsn#" maxRows="4">
			SELECT ind.strIndName, (indcount.IndCnt * 100.0 ) / indcount.TotalResCnt percentCount
			FROM tblIndustries ind (nolock)
			LEFT JOIN
			(
				SELECT count(ind.intAttID) IndCnt, ind.intAttID industry
						,(select COUNT(intResID) totalCnt from tblResumes res (nolock) where res.blnDelete = <cfqueryparam value="0" cfsqltype="cf_sql_integer" /> and res.intAdmCode in (4,5) and res.email is not null and res.sourceApp = <cfqueryparam value="#variables.sourceApp#" cfsqltype="cf_sql_varchar"> ) TotalResCnt
				FROM tblResumes res (nolock)
				LEFT JOIN tblResAtt Ind (nolock)
					ON ind.intResID = res.intResID
				WHERE res.blnDelete = <cfqueryparam value="0" cfsqltype="cf_sql_integer" />
				AND res.intAdmCode in (4,5)
				AND res.email is not null
				AND res.sourceApp = <cfqueryparam value="#variables.sourceApp#" cfsqltype="cf_sql_varchar">
				AND ind.intAttID in (select intOldIndID from tblIndustries (nolock) where intOldIndID <> <cfqueryparam value="644" cfsqltype="cf_sql_integer" />)
				GROUP BY ind.intAttID
			)indCount
			ON IndCount.industry = ind.intOldIndID
			ORDER BY indCount.IndCnt desc
		</cfquery>

		<cfreturn qry_topindustries>
	</cffunction>
	
	
	<cffunction name="getLeadId" access="public" output="false" returntype="numeric">
		<cfargument name="tcode" type="string" required="true" />
    	<cfset var qry_leadid = "" />

		<cfquery name="qry_leadid" datasource="#variables.dsn#">
			 select intTrackingID
		  		from tblHowFindTracking (nolock)
		  		where strTrackCode = <cfqueryparam value="#arguments.tcode#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfreturn qry_leadid.intTrackingID>
	</cffunction>
	
	<cffunction name="getRemoveQuotes" access="public" output="false" returntype="string">
		<cfargument name="strStrip" default="" type="string" required="false">
		<cfargument name="blnRemove" default="1" type="string" required="false">
		
		<cfset strTemp=arguments.strStrip />

		<cfif arguments.blnRemove neq 0>
			<!--- remove the quotes --->
			<cfset strTempText=Replace(strTemp,     chr(34), "$$DQ$$", "ALL") />
			<cfset strTempText=Replace(strTempText, chr(39), "$$SQ$$", "ALL") />
			<cfset strTempText=Replace(strTempText, chr(34), "$$dq$$", "ALL") />
			<cfset strTempText=Replace(strTempText, chr(39), "$$sq$$", "ALL") />
		<cfelse>
			<!--- add the quotes --->
			<cfset strTempText=Replace(strTemp,     "$$DQ$$", chr(34), "ALL") />
			<cfset strTempText=Replace(strTempText, "$$SQ$$", chr(39), "ALL") />
			<cfset strTempText=Replace(strTempText, "$$dq$$", chr(34), "ALL") />
			<cfset strTempText=Replace(strTempText, "$$sq$$", chr(39), "ALL") />
		</cfif>
		
		<cfset strTemp=strTempText />
		
    	<cfreturn strTemp>
	</cffunction>
	
	
	
	
	
	
	
	
	<!--- end misc methods --->
	
</cfcomponent>
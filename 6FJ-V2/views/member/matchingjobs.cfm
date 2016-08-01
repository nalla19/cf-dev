<!---t_CandidateMatchingJobs.cfm--->
<!---Solr Query--->
<cfoutput>
<cfparam name="intJobTitleSearch" default="1">
<cfparam name="strJobTitle" default="">
<cfparam name="strKeywords" default="">
<cfparam name="strSkills" default="">
<cfparam name="strLocation" default="">
<cfparam name="intNoOfJobs" default="6">

<!---Get the desired job title for the candidate--->
<cfquery name="cfqGetJobTitle" datasource="#application.dsn#">
select strDesiredJobTitle from tblResumes (nolock) where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />
</cfquery>
<cfif len(cfqGetJobTitle.strDesiredJobTitle)>
	<cfset strJobTitle = cfqGetJobTitle.strDesiredJobTitle>
</cfif>

<cfset solr = createObject('component', 'v16fj.com.solr.SolColdfusion').init(application.SOLRjobServer,application.SOLRjobServerPort,application.SOLRpath) />
<!--- <cfset solr = createObject('component', 'com.solr.SolColdfusion') />
<cfset solr.init("#application.SOLRjobServer#", "#application.SOLRjobServerPort#","#application.SOLRpath#") /> --->

<!---
<cfset solrQueryStartDate = dateformat(now()-7, 'YYYY-MM-DD')>
<cfset solrQueryEndDate = dateformat(now(), 'YYYY-MM-DD')>
--->

<!--- call solr and return intJobIDList --->
<cfset keywords = "">
<cfif intJobTitleSearch EQ 1>
	<cfif strJobTitle NEQ "">
        <cfset keyWords = strJobTitle>
    <cfelseif strJobTitle eq "">
		<cfif strkeywords NEQ "">
    		<cfset keyWords = strSkills>
		<cfelseif strSkills NEQ "">
            <cfset keyWords = strSkills>
        <cfelse>
            <cfset keywords="*:*">
    	</cfif>
    </cfif>
<cfelseif intJobTitleSearch is 0>
    <cfif strkeywords NEQ "">
    	<cfset keyWords = strkeywords>
	<cfelseif strSkills NEQ "">
        <cfset keyWords = strSkills>
    <cfelse>
        <cfset keywords = "*:*">
    </cfif>
<cfelseif intJobTitleSearch is "">
    <cfset keywords = strkeywords>	
</cfif>

<cfif trim(keywords) EQ "">
	<cfset keywords = "*:*">
<cfelse>	
    <cfset keywords = Replace(keywords, "$$SQ$$", "", "all")>
    <cfset keywords = Replace(keywords, "$$DQ$$", "", "all")>
</cfif>


<!--- ========================================== JOB TITLE SEARCH ========================================== --->
<cfset params 	= StructNew() />
<cfset a 		= StructInsert(params, "start",0) />
<cfset a 		= StructInsert(params, "rows", #intNoOfJobs#) />
<cfset a 		= StructInsert(params, "indent", "on") />
<cfset a 		= StructInsert(params, "fl", "*,score") />
<cfset a 		= StructInsert(params, "hl", "true") />
<cfset a 		= StructInsert(params, "hl.fragsize", "250")/>
<cfset a 		= StructInsert(params, "hl.fl", "jpname,description,location,state,strName") />
<cfset a 		= StructInsert(params, "defType", "dismax") />
<cfset a 		= StructInsert(params, "qf", "title^10 description jpname^9 location^8 strName strCats date_submitted") />
<cfset a 		= StructInsert(params, "sort", "score desc") />
<cfset a 		= StructInsert(params, "q", '"#keywords#"') />

<cfif isDefined("solrQueryStartDate") and len("solrQueryStartDate") and isDefined("solrQueryEndDate") and len("solrQueryEndDate")>
	<cfif len(strLocation)> 
		<cfset a 		= StructInsert(params, "fq", 'date_submitted:[#solrQueryStartDate#T00:00:00Z TO #solrQueryEndDate#T23:59:59.999Z] AND title:("#keywords#") AND location:("#strLocation#", "National")') />
    <cfelse>
    	<cfset a 		= StructInsert(params, "fq", 'date_submitted:[#solrQueryStartDate#T00:00:00Z TO #solrQueryEndDate#T23:59:59.999Z] AND title:("#keywords#")') />
    </cfif>    
<cfelse>
	<cfif len(strLocation)> 
		<cfset a 		= StructInsert(params, "fq", 'title:("#keywords#") AND location:("#strLocation#", "National")') />
    <cfelse>
    	<cfset a 		= StructInsert(params, "fq", 'title:("#keywords#")') />
    </cfif>    
</cfif>

<!--- set the source app --->
<cfparam name="request.sourceApp" default="">
<cfset params.fq_sourceApp = 'sourceApp:("6FigureJobs", "Both")' />

<!--- <cfdump var="#params#"> --->
<cfset result 	= XmlParse(solr.search(params)) />
<cfset results	= xmlSearch(result,"/response/result") /> 

<cfset intSolrJobsIDList = "">
<cfloop from="1" to="#arraylen(results[1].XmlChildren)#" index="i">
	<cfset doc 			= results[1]["doc"][i] />
	<cfset id 			= xmlSearch(result,"/response/result/doc[#i#]/str[@name='intJobID']") />
    <cfset intSolrJobsIDList = listAppend(intSolrJobsIDList, "#ID[1].xmltext#")>
</cfloop>
<!--- ========================================== END JOB TITLE SEARCH ========================================== --->

<!---Get the remaining jobs--->
<cfset intNoOfJobs = intNoOfJobs - listLen(intSolrJobsIDList)>

<cfset intSolrJobsIDList1 = "">
<!--- If the Job Title Search returned less than 6 jobs do the keyword search on the Skills --->
<cfif intNoOfJobs gt 0>
	<cfset intJobTitleSearch = 0>
	<!--- call solr and return intJobIDList --->
	
	<cfset strkeywords = "">
	<cfif len(cfqGetJobTitle.strDesiredJobTitle)>
		<cfset strkeywords = cfqGetJobTitle.strDesiredJobTitle>
	</cfif>
	
	<cfif intJobTitleSearch EQ 1>
		<cfif strJobTitle NEQ "">
			<cfset keyWords = strJobTitle>
		<cfelseif strJobTitle eq "">
			<cfif strkeywords NEQ "">
				<cfset keyWords = strSkills>
			<cfelseif strSkills NEQ "">
				<cfset keyWords = strSkills>
			<cfelse>
				<cfset keywords="*:*">
			</cfif>
		</cfif>
	<cfelseif intJobTitleSearch is 0>
		<cfif strkeywords NEQ "">
			<cfset keyWords = strkeywords>
		<cfelseif strSkills NEQ "">
			<cfset keyWords = strSkills>
		<cfelse>
			<cfset keywords = "*:*">
		</cfif>
	<cfelseif intJobTitleSearch is "">
		<cfset keywords = strkeywords>	
	</cfif>
	
	<cfif trim(keywords) EQ "">
		<cfset keywords = "*:*">
	<cfelse>	
		<cfset keywords = Replace(keywords, "$$SQ$$", "", "all")>
		<cfset keywords = Replace(keywords, "$$DQ$$", "", "all")>
	</cfif>
	
	<!--- ========================================== SKILLS SEARCH ========================================== --->
	<cfset params 	= StructNew() />
	<cfset a 		= StructInsert(params, "start",0) />
	<cfset a 		= StructInsert(params, "rows", #intNoOfJobs#) />
	<cfset a 		= StructInsert(params, "indent", "on") />
	<cfset a 		= StructInsert(params, "fl", "*,score") />
	<cfset a 		= StructInsert(params, "hl", "true") />
	<cfset a 		= StructInsert(params, "hl.fragsize", "250")/>
	<cfset a 		= StructInsert(params, "hl.fl", "jpname,description,location,state,strName") />
	<cfset a 		= StructInsert(params, "defType", "dismax") />
	<cfset a 		= StructInsert(params, "qf", "title^10 description jpname^9 location^8 strName strCats date_submitted") />
	<cfset a 		= StructInsert(params, "sort", "score desc") />
	
	<!--- 
	<cfset a 		= StructInsert(params, "q", '"#keywords#"') /> 
	--->
	<cfset a 		= StructInsert(params, "q", "#keywords#") />
		
	<!--- set the source app --->
	<cfparam name="request.sourceApp" default="">
	<cfset params.fq_sourceApp = 'sourceApp:("6FigureJobs", "Both")' />
	
	<!--- <cfdump var="#params#">  --->
	<cfset result 	= XmlParse(solr.search(params)) />
	<cfset results	= xmlSearch(result,"/response/result") /> 
	
	<cfset intSolrJobsIDList1 = "">
	<cfloop from="1" to="#arraylen(results[1].XmlChildren)#" index="i">
		<cfset doc 			= results[1]["doc"][i] />
		<cfset id 			= xmlSearch(result,"/response/result/doc[#i#]/str[@name='intJobID']") />
		<cfset intSolrJobsIDList1 = listAppend(intSolrJobsIDList1, "#ID[1].xmltext#")>
	</cfloop>
	<!--- ========================================== END SKILLS SEARCH ========================================== --->
</cfif>

<cfset intJobIDList="">
<cfif listLen(intSolrJobsIDList) gt 0>
	<cfset intJobIDList=ListAppend(intJobIDList, intSolrJobsIDList)>
</cfif>

<cfif listLen(intSolrJobsIDList1) gt 0>
	<cfset intJobIDList=ListAppend(intJobIDList, intSolrJobsIDList1)>
</cfif>

<!---Get the matching Jobs from the Job Title search--->
<cfif ListLen(intSolrJobsIDList) gt 0 or ListLen(intSolrJobsIDList1) gt 0>
	<cfif not ListLen(intSolrJobsIDList)>
		<cfset intSolrJobsIDList = 0>
	</cfif>
	
	<cfif not ListLen(intSolrJobsIDList1)>
		<cfset intSolrJobsIDList1 = 0>
	</cfif>
	
	<cfquery name="cfqGetJobs1" datasource="#application.dsn#">
	select  jobs.intJobID, jobs.title, jobs.jpname, jobs.location, jobs.state, jobs.fltSalary_desiredLow, jobs.seoJobURL, states.strName
  	  from tblJobs jobs(nolock)
  	 inner join tblStates states (nolock)
 		on states.intOldID = jobs.state
 	 where 1=1
	   and jobs.intJobID in (#intSolrJobsIDList#) 
   	   and jobs.blnActive = 1
	   <!---Exclude the jobs that this candidate has applied to within the last 14 days --->
	   and jobs.intJobID not in (select intJobID from tblOneClickHist (nolock) where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intResID#" /> and dteSubmit >= GETDATE()-14)
	  
	</cfquery>
	<cfset intRelevantJobCount = cfqGetJobs1.recordcount>
	
	<cfquery name="cfqGetJobs2" datasource="#application.dsn#">
	select jobs.intJobID, jobs.title, jobs.jpname, jobs.location, jobs.state, jobs.fltSalary_desiredLow, jobs.seoJobURL, states.strName
  	  from tblJobs jobs(nolock)
  	 inner join tblStates states (nolock)
 		on states.intOldID = jobs.state
 	 where jobs.intJobID in (#intSolrJobsIDList1#) 
	   and jobs.blnActive = 1
	   
	   <!---Exclude any jobs that were returned from the job title search--->
	   <cfif ListLen(intSolrJobsIDList) gt 0>
	   and jobs.intJobID not in (#intSolrJobsIDList#)
	   </cfif>
	   
	   <!---Exclude the jobs that this candidate has applied to within the last 14 days --->
	   and jobs.intJobID not in (select intJobID from tblOneClickHist (nolock) where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intResID#" /> and dteSubmit >= GETDATE()-14)
	</cfquery>
	<cfset intRelevantJobCount = intRelevantJobCount + cfqGetJobs2.recordcount>
	
	<cfif cfqGetJobs1.recordcount gt 0 or cfqGetJobs2.recordcount gt 0>
		<div class="row">
			<div class="pull-left">
				<cfif url.act is "member-dashboard">
				<h5>Jobs You May Be Interested In</h5>
				<cfelseif url.act is "job-apply">
				<h5>Be Sure To Check Out These Similar Opportunities</h5>
				</cfif>
			</div>
			
			<cfif url.act is "member-dashboard">
				<div class="pull-right"><a href="/search?strTitle=#keyWords#&strLocation="><h6>Search More Jobs</h6></a></div>
			</cfif>
		</div>
			
			<cfloop query="cfqGetJobs1">
			<div class="row">
				<div class="pull-left" style="font-size:12px">
					<cfif len(title) lte 55>
						<strong><a href="#cfqGetJobs1.seoJobURL#" title="#title#">#title#</a></strong><br />
					<cfelse>
						<cfset shortTitle = left(title,52)>
						<strong><a href="#cfqGetJobs1.seoJobURL#" title="#title#">#shortTitle#...</a></strong><br />
					</cfif>
					<div style="font-size:12px">#cfqGetJobs1.jpname# - #cfqGetJobs1.location#, #cfqGetJobs1.strName#</div>
				</div>
				<div class="pull-right" style="font-size:12px">
					<strong>$#cfqGetJobs1.fltSalary_desiredLow#,000</strong><br />
					min salary
				</div>
			</div>
				
			</cfloop>
			
			<cfloop query="cfqGetJobs2">
			<div class="row">
				<div class="pull-left" style="font-size:12px">
					<cfif len(title) lte 55>
						<strong><a href="#cfqGetJobs2.seoJobURL#" title="#title#">#title#</a></strong><br />
					<cfelse>
						<cfset shortTitle = left(title,52)>
						<strong><a href="#cfqGetJobs2.seoJobURL#" title="#title#">#shortTitle#...</a></strong><br />
					</cfif>
					#cfqGetJobs2.jpname# - #cfqGetJobs2.location#, #cfqGetJobs2.strName#
				</div>
				<div class="pull-right" style="font-size:12px">
					<strong>$#cfqGetJobs2.fltSalary_desiredLow#,000</strong><br />
					min salary
				</div>
			</div>
				
			</cfloop>
	</cfif>
</cfif>


<cfif ListLen(intJobIDList) is 0>
	<cfset intRelevantJobCount = 0> 
</cfif>

</cfoutput>
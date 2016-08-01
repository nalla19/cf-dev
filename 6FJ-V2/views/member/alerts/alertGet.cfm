<!--- start get --->
		<cfparam name="strTitle" default="">
		<cfparam name="dteCrt" default=""> 
		<cfparam name="session.exec.agentCriteria" default="">
		<cfset strKeywords="">
		<!---  
		<cfset intsIndIDs="#arrInds[1][1]#">
		<cfset intsFuncIDs="#arrFuncs[1][1]#"> 
		--->
		<cfset intsIndIDs="">
		<cfset intsFuncIDs="">
		<cfset listStateIDs="#arrStates[1][1]#">
		<cfset blnFulltime="0">
		<cfset blnContract="0">
		<cfset blnStartup="0">
		<cfset strSearchType="broad">
		
		<cfquery name="cfqAgent" datasource="#application.dsn#">
		select *
		from tblSearchAgent (NOLOCK)
		where intresid=#intResID# and strTitle='#strTitle#'
		</cfquery>
		
		<cfif cfqAgent.RecordCount eq 1>
			<cflock scope="session" timeout="10" type="Exclusive">
				<cfset session.SearchJobs.strKeyWords="">
				<!---   
				<cfset session.SearchJobs.intsIndIDs="#arrInds[1][1]#">
				<cfset session.SearchJobs.intsFuncIDs="#arrFuncs[1][1]#">  
				--->
				<cfset session.SearchJobs.intsIndIDs="">
				<cfset session.SearchJobs.intsFuncIDs=""> 
				<cfset session.SearchJobs.intsStateIDs="#arrStates[1][1]#">
				<cfset session.SearchJobs.strSearchType ="broad">
				<cfset session.SearchJobs.blnFulltime="0">
				<cfset session.SearchJobs.blnContract="0">
				<cfset session.SearchJobs.blnstartup="0">
				<cfset session.SearchJobs.blnSearched="0">
				<cfset session.SearchJobs.cfqIntJobIDs="">
				<cfset session.SearchJobs.NbrFavJobs="">
				<cfset session.SearchJobs.NbrSearchAss="">
				<cfset session.SearchJobs.NbrAppHist="">  
				<cfset session.SearchJobs.blnSearched="0">
				<cfset session.SearchJobs.cfqIntJobIDs="">
				<cfset session.SearchJobs.blnSearchAgent="0">
			</cflock>
				
			<cfif cfqAgent.strTitle neq "">
				<cfif strMode neq "run">
					<!--- add the quotes --->
					<!--- <cf_ct_removeQuotes strStrip="#cfqAgent.strTitle#" blnRemove="0">
					<cfset strTitle=strStrip> --->
					<cfset strstrip = application.util.getRemoveQuotes(strStrip="#cfqAgent.strTitle#",  blnRemove="0")>
					<cfset strTitle=strstrip>
				<cfelse>
					<cfset strTitle=cfqAgent.strTitle>
					<cflock scope="SESSION" type="EXCLUSIVE" timeout="10">
						<cfset session.Searchjobs.SHIsSearchAgent=1>
					</cflock>
				</cfif>
			</cfif>
		
			<cfif cfqAgent.strKeywords neq "">
				<!--- add the quotes --->
				<!--- <cf_ct_removeQuotes strStrip="#cfqAgent.strKeywords#" blnRemove="0"> --->
				<cfset strstrip = application.util.getRemoveQuotes(strStrip="#cfqAgent.strTitle#",  blnRemove="0")>
				<cfset strKeywords=strstrip>
				<!--- <cfset strKeywords=strStrip>   --->
			</cfif> 
		
			<cfset strAtts=cfqAgent.strAtts>
			<cfset blnFulltime=cfqAgent.blnFulltime>
			<cfset blnContract=cfqAgent.blnContract>
			<cfset blnStartup=cfqAgent.blnStartup>
			<cfset strSearchType=cfqAgent.strSearchType>
			<cfset dteCrt=cfqAgent.dteCreated>
			<cfset blnEmailAgent=cfqAgent.blnEmailAgent>
			<!--- <cfif newfeed eq "1"> --->
			<cfset blnWeekly=cfqAgent.blnWeekly>
			<!--- </cfif> --->
		
			<!--- build Industry list --->
			<cfset intsIndIDs="">
			<cfloop index="intIndexNo" from="1" to="#intIndsArrLen#">
				<cfif ListFind(#cfqAgent.strAtts#, #arrInds[intIndexNo][1]#) is not 0>
					<cfset intsIndIDs=ListAppend(intsIndIDs, #arrInds[intIndexNo][1]#)>
				</cfif>
			</cfloop>
		  
			<cfif (ListLen(intsIndIDs) eq 1) and (ListFind(intsIndIDs, 600))>
				<cfset intsIndIDs="">
			<cfelseif (ListLen(intsIndIDs) gt 0) and (ListFind(intsIndIDs, 600))>
				<cfset intPosition=ListFind(intsIndIDs, 600)>
				<cfif intPosition neq 0>
					<cfset intsIndIDs=ListDeleteAt(intsIndIDs, intPosition)>
				</cfif>
			</cfif>
			
			<!--- build Function list --->
			<cfset intsFuncIDs="">
			<cfloop index="intIndexNo" from="1" to="#intFuncsArrLen#">
				<cfif ListFind(#cfqAgent.strAtts#, #arrFuncs[intIndexNo][1]#) is not 0>
					<cfset intsFuncIDs=ListAppend(intsFuncIDs, #arrFuncs[intIndexNo][1]#)>
				</cfif>
			</cfloop>
		  
			<cfif (ListLen(intsFuncIDs) eq 1) and (ListFind(intsFuncIDs, 800))>
				<cfset intsFuncIDs="">
			<cfelseif (ListLen(intsFuncIDs) gt 0) and (ListFind(intsFuncIDs, 800))>
				<cfset intPosition=ListFind(intsFuncIDs, 800)>
				<cfif intPosition neq 0>
					<cfset intsFuncIDs=ListDeleteAt(intsFuncIDs, intPosition)>
				</cfif>
			</cfif>
		 
			<!--- build State list --->
			<cfset listStateIDs="">
			<cfloop index="intIndexNo" from="1" to="#intStatesArrLen#">
				<cfif ListFind(#cfqAgent.strAtts#, #arrStates[intIndexNo][1]#) is not 0>
					<cfset listStateIDs=ListAppend(listStateIDs, #arrStates[intIndexNo][1]#)>
				</cfif>
			</cfloop>
		  
			<cfset form.strKeyWords=strKeyWords>
			<cfset form.intsIndIDs=intsIndIDs>
			<cfset form.intsFuncIDs=intsFuncIDs>
			<cfset form.listStateIDs=listStateIDs>
			<cfset form.strSearchType=strSearchType>
			<cfset form.blnFulltime=blnFulltime> 
			<cfset form.blnContract=blnContract>
			<cfset form.blnStartup=blnStartup>
			<cfset form.blnEmailAgent=blnEmailAgent>
			<!--- <cfif newfeed eq "1"> --->
			<cfset form.blnWeekly=blnWeekly>
			<!--- </cfif> --->
			<!---  --->
			<cfset blnform=1>
			
			<!--- start: save search criteria to session var --->
			<cfset session.SearchJobs.strKeyWords="#form.strKeyWords#">
			<cfset session.SearchJobs.intsIndIDs="#form.intsIndIDs#">
			<cfset session.SearchJobs.intsFuncIDs="#form.intsFuncIDs#">
			<cfset session.SearchJobs.intsStateIDs="#form.listStateIDs#">
			<cfset session.SearchJobs.strSearchType="#form.strSearchType#">
			<cfset session.SearchJobs.blnFulltime="#form.blnFulltime#">
			<cfset session.SearchJobs.blnContract="#form.blnContract#">
			<cfset session.SearchJobs.blnStartup="#form.blnStartup#">
				
			<cfset session.exec.agentCriteria = "100k=1&blnContract=" & blnContract & "&blnform=0" & "&blnFulltime=" & blnFulltime & "&blnStartup=" & blnStartup &
												 "&intsFuncIDs=" & intsFuncIDs & "&intsIndIDs=" & intsIndIDs & "&liststateids="  & listStateIDs & "&quicksearch=1" &
												 "&&SEARCHFEATURED=&SEARCHFORM=6FJ&STRKEYWORDS=" & strKeyWords & "&strsearchtype=" & strSearchType>
													
											
		</cfif>
<!--- end get --->
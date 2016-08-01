<cfparam name="blnFirstPass" default=1>
<cfparam name="blnNewRcrd" default=0>
<cfparam name="strMode" default="select">
<cfparam name="strTitle" default="">
<cfparam name="expid" default="0">
<cfparam name="strAtts" default="">
<cfparam name="form.strKeyWords" default="">
<cfparam name="form.intsIndIDs" default="">
<cfparam name="form.intsFuncIDs" default="">
<cfparam name="form.listStateIDs" default="">
<cfparam name="form.strSearchType" default="broad">
<cfparam name="form.blnFulltime" default="0">
<cfparam name="form.blnContract" default="0">
<cfparam name="form.blnstartup" default="0">
<cfset intResID = session.exec.intResID>
<cfset blnValidLogin = session.EXEC.blnValidLogin>
<cfset strAppAddToken = application.strAppAddToken>
<cfparam name="tm" default="30">
<cfparam name="m" default="2">
<!--- main menu --->
<cfparam name="am" default="25">
<!--- active menu --->
<cfparam name="asm" default="0">

<cfoutput>
<cfif ((expid eq 1) AND (blnFirstPass neq 0))>
	<!--- save search criteria from main search --->
	<cfset strmode="mainSearch" />
	<cfset blnNewRcrd=1 />
</cfif>

<!--- <h2 class="PageHeader">Job Search Alerts</h2> --->
<cfinclude template="alertAttributes.cfm">

<div class="page-dashboard">

	<article class="section">
		<div class="container">
			<!--- <table border="0" cellpadding="2" cellspacing="2" width="100%" > --->
			<cfif ((not(len(intResID))) and (blnValidLogin neq 1))>
				<!--- <tr>
					<td> --->
					do we ever get here?<!---ISR <cfinclude template="t_PagePasswordText.cfm"> ---><!--- </td>
				</tr> --->
			<cfelse>
				<!--- <tr>
					<td> --->
						
						<cfswitch expression="#strmode#">
			<!--- start select agent --->
							<cfcase value="select">
								<cfparam name="strEmailAgent" default="">
								
								<cflock scope="SESSION" type="exclusive" timeout="10">
									<cfset session.exec.SHKeywordString="">
									<cfset session.Searchjobs.SHstrTitle="">
									<cfset session.Searchjobs.SHlocation="">
									<cfset session.Searchjobs.SHstrKeywordExactPhrase="">
									<cfset session.Searchjobs.SHintDatescope="">
									<cfset session.Searchjobs.SHintMiles="">
									<cfset session.Searchjobs.SHJobType="">
									<cfset session.Searchjobs.SHSearchForm="">
								</cflock>
								
								<cfquery name="cfqAgentOriginal" datasource="#application.dsn#" maxrows="3">
								  select strTitle,blnEmailAgent
								  from tblSearchAgent (NOLOCK)
								  where intresid=#intResID#
								  order by dteCreated
								</cfquery>
								
								<cfset strAllAgents="">
								<cfloop from="1" to="#cfqAgentOriginal.Recordcount#" index="r">
									<cfset strAllAgents = "#ListAppend(strAllAgents,Replace(cfqAgentOriginal.strTitle[r],",","^","all"),",")#">
								</cfloop>
								
								<cfparam name="strEmailAgent" default="">
								<cfquery name="cfqAgent" datasource="#application.dsn#" maxrows="3">
								select strTitle,blnEmailAgent,blnweekly
								from tblSearchAgent (NOLOCK)
								where intresid=#intResID#
								order by dteCreated
								</cfquery>
								<h1 class="page-title">Job Search Alerts</h1>
									 <div class="row">
										<div class="span12">
											<div class="page-spacer"></div>
											<div>
												<strong>Job Search Alerts</strong> allow you to quickly search for jobs by defining keywords specific to the job title(s) or description(s) 
												you are looking for.  You are allowed to store three search alerts at a time.
											</div>
										
											<div class="page-spacer"></div>
											<div>
												<!--- <cfif cfqAgentOriginal.recordcount eq "0">
													Select the "Edit" or click the "Create Job Search Alert" button to define your job search alert and its email delivery setting.
												<cfelse> --->
													Select the "Edit" or click the "Create Job Search Alert" button to define your job search alert and its email delivery setting.
												<!--- </cfif> --->
											</div>
											<div class="page-spacer"></div>
											<div class="span12">
												<cfif isdefined('blnSuccess') and blnSuccess eq 1>
												<span style="color:990000;font-weight:bold;">Your settings have successfully been modified.</span>
												<br>
												</cfif>
											</div>
										
											<div class="table-responsive">
												<table class="table table-striped table-bordered" width="100%">
					
													<thead>
													<tr><td colspan="4" style="font-size:13px; font-weight:bold;">Search Alerts:&nbsp;<b>#cfqAgent.RecordCount#</b></td></tr>
													<tr>
														<th style="text-align:left;">Run Search</th>
														<th style="text-align:left;">Search Title</th>
														<th style="text-align:left;">Receive by Email</th>
														<th style="text-align:left;">Edit Search</th>
													</tr>
									
													</thead>
												
													<tbody>
													<cfif cfqAgent.RecordCount eq 0>
														<tr><td colspan="4" class="exec_lite_gry" align="center" style="font-size:13px;">You have no Job Search Alerts stored.</td></tr>
														<tr><td colspan="4" style="font-size:13px;"><a class="bold" href="/member-job-alerts?#strAppAddToken#&strMode=new&am=#am#&tm=#tm#">Add a Job Search Alert</a></td></tr>
													<cfelse>
														<cfloop query="cfqAgent">
															<cfif currentRow mod 2 eq 0>
																<cfset td_class="exec_dark_gry">
															<cfelse>
																<cfset td_class="exec_lite_gry">
															</cfif>
															<cfif cfqAgent.strTitle neq "">
																<!--- add the quotes --->
																<!--- <cf_ct_removeQuotes strStrip="#cfqAgent.strTitle#" blnRemove="0"> --->
																<cfset strstrip = application.util.getRemoveQuotes(strStrip="#cfqAgent.strTitle#",  blnRemove="0")>
																<cfset strtitle=strstrip>
															<cfelse>
																<cfset strStrip="">
																<cfset strtitle="">
															</cfif>
															<tr>
																<td class="span1" style="text-align:left;">
																	<a href="/member-job-alerts?#strAppAddToken#&strMode=run&strTitle=#URLEncodedFormat(strTitle)#&am=#am#&tm=#tm#">Run Search</a>
																</td>
																<td class="span2" style="text-align:left;">
																	#strStrip#
																</td>
																<td class="span1" style="text-align:left;">
																	<cfif blnEmailAgent eq "1">
																		<cfif blnWeekly eq "1">
																			Weekly
																		<cfelse>
																			Daily
																		</cfif>
																	<cfelse>
																		No
																	</cfif>
																</td>
																<td class="span1" style="text-align:left;">
																	<a href="/member-job-alerts?#strAppAddToken#&strMode=edit&strTitle=#URLEncodedFormat(strTitle)#&am=#am#&tm=#tm#">Edit</a>
																</td>
															</tr>
														</cfloop>
														
														<!--- new search row --->
														<cfif cfqAgent.RecordCount lt 3>
															<tr><td colspan="4"><img src="/img/spacer.gif" border=0 height=5></td></tr>
															<tr><td colspan="4">
																<a id="CreateSearchAlertbutton" href="/member-job-alerts?#strAppAddToken#&strMode=new&am=#am#&tm=#tm#"><input class="btn btn-primary" type="button" name="validate" id="submitBtn" value="&nbsp;Create Job Search Alert&nbsp;"></a>
																<!--- <a id="CreateSearchAlertbutton" href="ExecSearchAgent.cfm?#strAppAddToken#&strMode=new&am=#am#&tm=#tm#"><cfif cfqAgent.recordcount gt 0> </cfif></span></a> --->
															</td></tr>
															<cfelse>
															<tr><td colspan="4"><img src="/img/spacer.gif" border=0 height=5></td></tr>                
														</cfif>
													</cfif>
													</tbody>
												</table>
											</div>
										</div>
									</div>
							</cfcase>
			<!--- end select agent --->				
							<cfcase value="new">
							
								<cfset blnNewRcrd=1 />
								<cfinclude template="alertEdit.cfm">
							</cfcase>
							
							<cfcase value="edit">
							
								<cfset blnNewRcrd=0 />
								<cfinclude template="alertEdit.cfm">
							</cfcase>
							
							<cfcase value="save">
							
								<cfinclude template="alertSave.cfm">
								
							</cfcase>
			<!--- start run agent --->
							<cfcase value="run">
							
								<cfset reinitVar=0>
								<cfif isDefined("url.reinit")>
									<cfif  url.reinit gt "0">
										<cfset reinitVar=url.reinit>
									</cfif>
								</cfif>
								
								<cflock scope="Application" timeout="10" type="readonly">
									<cfscript>
									//Multiple If for Code Readability
									if (isDefined("Application.sixfj.query.Industries") or isDefined("Application.sixfj.query.Functions") or isDefined("Application.sixfj.query.States")){
										tempSetApp = 0;
									}else{
										tempSetApp = 1;
									}
									
									strSixFigData="6Figs";
									Attributes="Exec";
									
									//Set Array Variables
									if (not(tempSetApp)){
										//Categories
										arrInds=Application.sixfj.query.Industries;
										intIndsArrLen=ArrayLen(arrInds);
										
										//Functions
										arrFuncs=Application.sixfj.query.Functions;
										intFuncsArrLen=ArrayLen(arrFuncs);
										
										//States
										arrStates=Application.sixfj.query.States;
										intStatesArrLen=ArrayLen(arrStates);
									}
									</cfscript>
								</cflock>
								
								<cfif reinitVar gt 0>
									<cfset tempSetApp = 1>
								</cfif>
								
								<!--- Check Wheather To Process Arrays --->
								<cfif tempSetApp>
									<cflock scope="Application" timeout="10" type="exclusive">
										<!--- CATEGORIES --->
										<cfset arrInds=ArrayNew(2)>
										<cfquery name="cfqGetIndustries" datasource="#application.dsn#"><!--- cachedwithin="#CreateTimeSpan(0,1,0,0)#">--->
										select intOldIndId,strIndName,intSHKeywordID from tblIndustries order by intindid
										</cfquery>
										<cfloop from="1" to="#cfqGetIndustries.RecordCount#" index="i">
											<cfset arrInds[i][1] = cfqGetIndustries.intOldIndId[i]>
											<cfset arrInds[i][2] = cfqGetIndustries.strIndName[i]>
											<cfset arrInds[i][3] = cfqGetIndustries.intSHKeywordID[i]>
										</cfloop>
										<cfset intIndsArrLen=ArrayLen(arrInds)> 
										
										<!--- FUNCTIONS --->
										<cfset arrFuncs=ArrayNew(2)> 
										<!---Do not pull the All Functions option--->
										<cfquery name="cfqGetFunctions" datasource="#application.dsn#"><!--- cachedwithin="#CreateTimeSpan(0,1,0,0)#">--->
										select intOldFunctionId,strFunctionName,intSHKeywordID from tblFunctions (nolock) where 1=1 and intOldFunctionId != 800 order by strFunctionName
										</cfquery>
										
										<!---Set the All Functions to be the first in the array--->                
										<cfset arrFuncs[1][1] = 800>
										<cfset arrFuncs[1][2] = "All Functions">
										<cfset arrFuncs[1][3] = "">
										
										<cfloop from="1" to="#cfqGetFunctions.RecordCount#" index="f">
											<cfset k=f+1>
											<cfset arrFuncs[k][1] = cfqGetFunctions.intOldFunctionId[f]>
											<cfset arrFuncs[k][2] = cfqGetFunctions.strFunctionName[f]>
											<cfset arrFuncs[k][3] = cfqGetFunctions.intSHKeywordID[f]>
										</cfloop>
										<cfset intFuncsArrLen=ArrayLen(arrFuncs)> 
										
										<!--- STATES ---> 
										<cfset arrStates=ArrayNew(2)> 
										<cfquery name="cfqGetStates" datasource="#application.dsn#"><!---  cachedwithin="#CreateTimeSpan(0,1,0,0)#" --->
										select strName,strshortname, intOldId,strAbbrev,strCountry from tblstates(nolock) order by intStateID
										</cfquery>
										<cfloop from="1" to="#cfqGetStates.RecordCount#" index="s">
											<cfset arrStates[s][1] = cfqGetStates.intOldId[s]>
											<cfset arrStates[s][2] = cfqGetStates.strName[s]>
											<cfset arrStates[s][3] = cfqGetStates.strAbbrev[s]>
											<cfset arrStates[s][4] = cfqGetStates.strCountry[s]>
											<cfset arrStates[s][5] = cfqGetStates.strShortName[s]>
										</cfloop>
										<cfset intStatesArrLen=ArrayLen(arrStates)>
										
										<cfscript>
										Application.sixfj.query.Industries = arrInds; 
										Application.sixfj.query.Functions =  arrFuncs;
										Application.sixfj.query.States = arrStates;
										</cfscript>
									</cflock>
								</cfif>
								
								<cfinclude template="alertRun.cfm">
							</cfcase>
		<!--- end run agent --->
							<cfcase value="JobDetail">
							JobDetail
								<!--- <cfinclude template="t_execSearchJobsDetail.cfm"> --->
							</cfcase>
							
							<cfcase value="mainSearch">
							mainSearch
								<!--- <cfinclude template="t_execSearchAgentMainSearch.cfm"> --->
							</cfcase>
							
							<cfdefaultcase>
							we are here.
								<!--- <cfinclude template="t_execSearchAgentSelect.cfm"> --->
							</cfdefaultcase>
						</cfswitch>
					<!--- </td>
				</tr> --->
			</cfif>
			<!--- </table> --->
		</div>
	</article>
</div>
</cfoutput>

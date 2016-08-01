<cfinclude template="alertAttributes.cfm">
<cfparam name="intJobID" default="0">
<cfparam name="blnNatnlPostingBtn" default="0">
<cfparam name="tm" default="30"><!--- Top menu (redesign) --->
<cfparam name="m" default="2"> <!--- main menu --->
<cfparam name="am" default="3"> <!--- active menu --->
<cfparam name="asm" default="0"> <!--- active sub-menu --->
<cfoutput>
<!--- build Job Att lists --->
<cfset listintAttIDs="">
<cfset intsIndIDs="">
<cfset intsFuncIDs="">

<!--- get job details --->
<cfquery name="cfqJobDetail" datasource="#application.dsn#">
select *
from tblJobs (NOLOCK)
where intJobID=#intJobID#
</cfquery>

<cfif cfqJobDetail.RecordCount eq 1>
	<!--- get job attributes --->
  	<cfquery name="cfqJobAtts" datasource="#application.dsn#">
   	select intAttID
   	from tblJobAtt (NOLOCK)
   	where intJobId='#intJobID#'
   	order by intAttID
  	</cfquery>

  	<!--- build Industry and Function integer lists --->
  	<cfif cfqJobAtts.RecordCount gt 0>
   		<cfset listintAttIDs=#ValueList(cfqJobAtts.intAttID)#>
		<!--- build Cat Att list --->
        <cfloop list="#listintAttIDs#" index="ListElement">
	        <cfloop index="intIndexNo" from="1" to="#intIndsArrLen#">
    		    <cfif ListElement eq arrInds[intIndexNo][1]>
        			<cfset intsIndIDs=ListAppend(intsIndIDs, '#arrInds[intIndexNo][1]#')>
        		</cfif>
        	</cfloop>
        </cfloop>

		<!--- build Func Att list --->
        <cfloop list="#listintAttIDs#" index="ListElement">
	        <cfloop index="intIndexNo" from="1" to="#intFuncsArrLen#">
    		    <cfif ListElement eq arrFuncs[intIndexNo][1]>
        			<cfset intsFuncIDs=ListAppend(intsFuncIDs, '#arrFuncs[intIndexNo][1]#')>
        		</cfif>
        	</cfloop>
        </cfloop>
  	</cfif>
</cfif>
</cfoutput>
<div class="page-dashboard">
	<article class="section">
		<div class="container">
			
			<div class="table-responsive">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<cfif cfqJobDetail.RecordCount eq 1>
					<cfoutput>
					<tr>
						<td><h1 class="page-title">Application History</h1></td>
						<td align="right" width="50%">
							
										 <a href="##" class="executive_button" onclick="window.location='/member-job-history?#application.strAppAddToken#&am=#am#&tm=#tm#&jrl=1';">Return to Application History</a>
									
						</td>
					</tr>
					</cfoutput>
					<tr>
						<td>&nbsp;</td>
					</tr>
					
					<tr>
						<td colspan="2">
							<cfoutput query="cfqJobDetail"> 
							<!--- display job --->
											
							<cfparam name="intResID" default="">
							<cfparam name="blnBigs" default="0">
							<cfparam name="intERPwdID" default="">
							<cfparam name="blnNewRecord" default="0">
							<cfparam name="blnSinglePost" default="0">
							<cfparam name="strViewMode" default="">
							<cfparam name="strAdminMode" default="">
							<cfparam name="intFoundCode" default="0">
							<cfparam name="blnPrnFriendly" default="0">
							<cfparam name="blnShowCorpPage" default="0">
							<cfparam name="intResAdmCode" default="0">
							<cfparam name="blnUnarchiveJob" default="0">
							<cfparam name="blnVI" default="0"> <!--- set from the "get" of the job details --->
							<!-- Strip job code from URL -->
							<cfscript>
							urlLength=#len(strJobURL)#;
							regex='[?]';
							querystringposition=#refind(regex, strJobURL)#;
							querystringstart=#querystringposition#+1;
							strJobCode=#Mid(strJobURL, querystringstart, urlLength)#;
							</cfscript>
							
							<!-- End strip job code from URL -->
							<cfparam name="intShowIframe" default="0">
							
							<!--- Pass the National Posting Flag --->
							
							
							<cfif len(description)>
								<!--- add the quotes --->
								<cfset strstrip = application.util.getRemoveQuotes(strStrip="#description#",  blnRemove="0")>
								<cfset description1=strStrip>
								<cfset description1=Replace(description1, "&amp;", "&", "ALL")> 
								<!--- Change Ampersand Symbols ---> 
							<cfelse>
								<cfset description1="">
							</cfif>
							
							<cfif compensation neq "">
								<!--- add the quotes --->
								<cfset strstrip = application.util.getRemoveQuotes(strStrip="#compensation#",  blnRemove="0")>
								<cfset compensation1=strStrip>
							<cfelse>
								<cfset compensation1="">
							</cfif>
							
							<cfif isDefined("aboutCompany") and aboutCompany neq "">
								<!--- add the quotes --->
								<cfset strstrip = application.util.getRemoveQuotes(strStrip="#aboutCompany#",  blnRemove="0")>
								<cfset aboutCompany1=strStrip>
							<cfelse>
								<cfset aboutCompany1="">
							</cfif>
							
							<cfif isDefined("companyPerks") and companyPerks neq "">
								<!--- add the quotes --->
								<cfset strstrip = application.util.getRemoveQuotes(strStrip="#companyPerks#",  blnRemove="0")>
								<cfset companyPerks1=strStrip>
							<cfelse>
								<cfset companyPerks1="">
							</cfif>
							
							<!--- build state string --->
							<cfset strState="">
							<cfloop index="intIndexNo" from="1" to="#intStatesArrLen#">
								<cfif state eq #arrStates[intIndexNo][1]#>
									<cfset strState=#arrStates[intIndexNo][2]#>
									<cfbreak>
								</cfif>
							</cfloop>
							
							<table border="0" cellpadding="3" cellspacing="0" width="100%">
								<!--- <cfif (blnVi eq 1)>
								<tr>
									<td colspan="2" align="right" valign="top" class="bold">
										<cfinclude template="/v_JobAlert.cfm">
									</td>
								</tr>
								</cfif> --->
								
								<cfparam name="titledisplay" default="">
								<cfif title neq "">
									<!--- remove the quotes --->
									<cfset strstrip = application.util.getRemoveQuotes(strStrip="#title#",  blnRemove="0")>
									<cfset titledisplay=strStrip>
								</cfif>
								
								<tr><td align="left" valign="top" colspan="2"><b>Title:</b> #titledisplay#</td></tr>
								<tr><td align="left" valign="top" colspan="2"><b>Candidates you would like applying to this position:</b> #strDesiredApplicants#</td></tr>
								
								<tr><td valign="top" colspan="2"><b>Company:</b> #jpname#<cfif blnShowCorpPage neq 0>&nbsp;&nbsp;(<a href="/ExecCorpJobs.cfm?#strAppAddToken#&intEmpID=#cfqJobDetail.intEmployerID#&blnUpdID=1&intPageNo=#intPageNo#&strActionFile=#strActionFile#<cfif strCaller eq "ExecSearchAgent">&strMode=run&strTitle=#strTitle#&strCaller=#strCaller#</cfif>">view all posted jobs</a>)</cfif></td></tr>
								
								<tr><td align="left" valign="top" colspan="2"><b>Job Code:</b> #jcode#</td></tr>
								
								<!---DaveP added code for multiple locations--->
								<cfif blnNewRecord eq 0>
									<cfif blnNatnlPostingBtn eq 1>
										<tr>
											<td align=left valign=top colspan="2">
												<b>Location(s):</b>&nbsp;National Posting
											</td>
										</tr>
									<cfelse>
										<tr>	
											<td align=left valign=top colspan="2">
												<table cellpadding="0" cellspacing="0" border="0">
													<tr>
														<td><b>Location(s):</b>&nbsp;</td>
														<td>
															<cfif (blnSinglePost eq 1) or (((strViewMode eq "detail") or (strAdminMode eq "detail")) and (intsLocations neq "0"))> 
																<table border="0" width="100%" class="bold">
																	<cfloop query="cfqGetJobState">
																	<tr>
																		<cfloop index="intIndexNo" from="1" to="#intStatesArrLen#">
																			<cfif state eq #arrStates[intIndexNo][1]#>
																				<cfset strJobState=#arrStates[intIndexNo][2]#>
																				<td align="left" valign="top">#strJobState#<cfif location neq ""> - #location#</cfif></td>
																				<cfbreak>
																			</cfif>
																		</cfloop>
																	</tr>
																	</cfloop>
																</table>
															<cfelse>				
																<cfset strState="">
																<cfloop index="intIndexNo" from="1" to="#intStatesArrLen#">
																	<cfif #state# eq #arrStates[intIndexNo][1]#>
																		<cfset strState=#arrStates[intIndexNo][2]#>
																	</cfif>
																</cfloop>
																
																<cfif strState is not "">
																#strState#
																</cfif>
																
																<cfif location is not "">
																- #location#
																</cfif>
															</cfif>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</cfif>
								<cfelse> 
									<cfif blnUnarchiveJob neq 0>
										<cfif blnNatnlPostingBtn eq 1>
											<tr>
												<td align=left valign=top colspan="2">
													<b>Location(s):</b>&nbsp;National Posting
												</td>
											</tr>
										<cfelse>
											<tr>
												<td align=left valign=top colspan="2">
													<table cellpadding="0" cellspacing="0" border="0">
														<tr>
															<td><b>Location(s):</b>&nbsp;</td>
															<td>
																<cfset strState="">
																<cfloop index="intIndexNo" from="1" to="#intStatesArrLen#">
																	<cfif #state# eq #arrStates[intIndexNo][1]#>
																		<cfset strState=#arrStates[intIndexNo][2]#>
																	</cfif>
																</cfloop>
																<cfif strState is not "">#strState#</cfif>
																<cfif location is not "">- #location#</cfif>
															</td>
														</tr>
													</table>
												</td>
											</tr>
										</cfif>
									<cfelse>
										<cfif blnNatnlPostingBtn eq 1>
											<tr>
												<td align=left valign=top colspan="2">
													<b>Location(s):</b>&nbsp;National Posting
												</td>
											</tr>
										<cfelse>
											<tr>
												<td align=left valign=top colspan="2">
													<table cellpadding="0" cellspacing="0" border="0">
														<tr>
															<td><b>Location(s):</b>&nbsp;</td>
															<td>
																<cfloop index="intIndexNum" from="1" to="#intTotalJobsAvailable#">
																	<cfswitch expression="#intIndexNum#">
																		<cfcase value="1"><cfset StateName=state1><cfset LocationName=location1><cfset zipcode=zipcode1></cfcase>
																		<cfcase value="2"><cfset StateName=state2><cfset LocationName=location2><cfset zipcode=zipcode2></cfcase>
																		<cfcase value="3"><cfset StateName=state3><cfset LocationName=location3><cfset zipcode=zipcode3></cfcase>
																		<cfcase value="4"><cfset StateName=state4><cfset LocationName=location4><cfset zipcode=zipcode4></cfcase>
																		<cfcase value="5"><cfset StateName=state5><cfset LocationName=location5><cfset zipcode=zipcode5></cfcase>
																		<cfcase value="6"><cfset StateName=state6><cfset LocationName=location6><cfset zipcode=zipcode6></cfcase>
																		<cfcase value="7"><cfset StateName=state7><cfset LocationName=location7><cfset zipcode=zipcode7></cfcase>
																		<cfcase value="8"><cfset StateName=state8><cfset LocationName=location8><cfset zipcode=zipcode8></cfcase>
																		<cfcase value="9"><cfset StateName=state9><cfset LocationName=location9><cfset zipcode=zipcode9></cfcase>
																		<cfcase value="10"><cfset StateName=state10><cfset LocationName=location10><cfset zipcode=zipcode10></cfcase>
																	</cfswitch>
																	
																	<cfif #StateName# neq "">
																		<cfset strState="">
																		<cfloop index="intIndexNo" from="1" to="#intStatesArrLen#">
																			<cfif #StateName# eq #arrStates[intIndexNo][1]#>
																				<cfset strState=#arrStates[intIndexNo][2]#>
																			</cfif>
																		 </cfloop>
																		 <cfif strState is not "">#strState#</cfif>
																		 <cfif LocationName is not "">- #LocationName#<br><cfelse><br></cfif>
																	</cfif>
																</cfloop>
															</td>
														</tr>
													</table>
												</td>
											</tr>
										</cfif>
									</cfif>
								</cfif>
								
								<!---DaveP end--->
								<tr>
									<td align="left" valign="top" colspan="2"><b>Industries:</b><br>
										<cfloop list="#intsIndIDs#" index="ListElement">
											<cfloop index="intIndexNo" from="1" to="#intIndsArrLen#">
												<cfif ListElement eq arrInds[intIndexNo][1]>
													#arrInds[intIndexNo][2]#<br>
													<cfbreak>
												</cfif>
											</cfloop>
										</cfloop>
									</td>
								</tr>
								
								<tr>
									<td align="left" valign="top"><b>Functions:</b><br>
										<cfloop list="#intsFuncIDs#" index="ListElement">
											<cfloop index="intIndexNo" from="1" to="#intFuncsArrLen#">
												<cfif ListElement eq arrFuncs[intIndexNo][1]>
													#arrFuncs[intIndexNo][2]#<br>
													<cfbreak>
												</cfif>
											</cfloop>
										</cfloop>
									</td>
								</tr>
								
								<tr><td valign="top" colspan="2"><b>Job Type:</b> #strOpportunity#&nbsp;</td></tr>
								<tr><td valign="top" colspan="2"><b>Compensation:</b><br>#compensation1#&nbsp;</td></tr>
								<tr><td valign="top" colspan="2"><b>About the Company:</b><br>#aboutCompany1#&nbsp;</td></tr>
								<tr><td valign="top" colspan="2"><b>Company Perks:</b><br>#companyPerks1#&nbsp;</td></tr>
								<tr>
									<td align="left" valign="top">
										<b>Description</b><br>
										<cfparam name="strKeyWords" default="">
										<cfif len(strKeyWords)>
											<cf_ct_findKeywords KeyWordStr="#strKeyWords#" SearchStr=#description1#>
											<cfset KeyWordStr=replace(KeyWordStr, chr(10), "<br>", "ALL")>
											#KeyWordStr#
										<cfelse>
											<cfset description1=replace(description1, chr(10), "<br>", "ALL")>
											#description1#
										</cfif>
										<!---#ParagraphFormat(description1)#&nbsp;--->
										&nbsp;<input type="hidden" name="str6FJ" value="6Figurejobs">
									</td>
								</tr>
								
								<!---DaveP check to see if we show Email or URL --->
								<tr>
									<td align="left" valign="top" colspan="2">
										<cfif intAppMeth neq 2 and intShowIframe neq 1><b>Apply Here</b><br></cfif>
										<cfif ( ((intResID eq "") and (blnBigs eq 0) and (intERPwdID neq "")) OR 
												((blnNewRecord eq 1) and (blnSinglePost eq 1)) OR ((intResID neq "") and (intERPwdID eq "") and ((intResAdmCode neq 2) AND (intResAdmCode neq 1))) OR 
												((strViewMode eq "detail") OR (strAdminMode eq "detail")) )>
											<table cellspacing="2" cellpadding="0" border="0">
												<cfif intAppMeth eq 1>
													<cfif (blnShowREyes neq 0)> <!--- show any member --->
														<cfif (strContactName is not "") and (blnShowName eq 1)><tr><td valign="top">Name:</td><td valign="top">#strContactName#</td></tr></cfif>
														<cfif (phone is not "") and (blnShowPhone eq 1)><tr><td valign="top">Phone:</td><td valign="top">#phone#</td></tr></cfif>
														<cfif (fax is not "") and (blnShowFax eq 1)><tr><td valign="top">Fax:</td><td valign="top">#fax#</td></tr></cfif>
														<cfif (email is not "") and (blnShowEmail neq 0)><tr><td valign="top">Email:</td><td valign="top"><a href="mailto:#email#">#email#</a></td></tr></cfif>
														<cfif (strJobURL is not "") and (blnShowJobURL neq 0)><tr><td valign="top">Website:</td><td valign="top"><a href="#strJobURL#" target="_new">#strJobURL#</a></td></tr></cfif>
													<cfelse>
														<cfif (intResAdmCode eq 4)> <!--- no info displayed to the RE member --->
															The Employer/Recruiter has requested that you apply for this position directly through the "Apply Now" link.
														<cfelse> <!--- else, show the info --->
															<cfif (strContactName is not "") and (blnShowName eq 1)><tr><td valign="top">Name:</td><td valign="top">#strContactName#</td></tr></cfif>
															<cfif (phone is not "") and (blnShowPhone eq 1)><tr><td valign="top">Phone:</td><td valign="top">#phone#</td></tr></cfif>
															<cfif (fax is not "") and (blnShowFax eq 1)><tr><td valign="top">Fax:</td><td valign="top">#fax#</td></tr></cfif>
															<cfif (email is not "") and (blnShowEmail neq 0)><tr><td valign="top">Email:</td><td valign="top"><a href="mailto:#email#">#email#</a></td></tr></cfif> 
															<!---          --->
															<!-- If JobG8 job, go to iframe page, otherwise go to external job page -->
															<cfif (strJobURL is not "") and (blnShowJobURL neq 0)>
																<cfif intShowIframe IS 1>
																	<tr><td\</td><td valign="top"><a href="/ExecApplyJob.cfm?#strAppAddToken#&code=#strJobCode#&tm=#tm#&ResID=#ResID#&intJobID=#intJobID#&intPageNo=#intPageNo#&strParent=ExecCorpJobDetail&intCorpID=#intcorpID#&jrl=1&sort=#sort#&sortorder=#sortorder#" onclick="showdiv()" target="_new"><span class="alert6 style1"><strong>Apply to Job</strong></span></a></td></tr>
																<cfelse>
																	<tr><td valign="top"><a href="#strJobURL#" target="_new">#strJobURL#</a></td></tr>
																</cfif>
															</cfif>
															<!--- End if JobG8 job, go to iframe page, otherwise go to external job page --->
															<!--- --->
														</cfif>
													</cfif>
												<cfelseif intAppMeth eq 2>  
													<!--- ---->
												<cfelse>
													<tr><td valign="top">The Employer/Recruiter has requested that you apply for this position directly through the "Apply Now" link.</td></tr>
												</cfif>
											</table>
										<!---<cfelse>
											<!--- If JobG8 job, go to iframe page, otherwise go to external job page --->
											 <cfif (strJobURL is not "") and (blnShowJobURL neq 0)>
												<cfif intShowIframe IS 1>
													<cfif blnValidlogin neq "1">
													<tr><td valign="top"><a href="/ExecApplyJob.cfm?#strAppAddToken#&code=#strJobCode#" rel="external"><span class="alert6 style1"><strong>Apply to Job</strong></span></a></td>
													</tr>
													<cfelse>
													<tr><td valign="top"><a href="/ExecApplyJob.cfm?#strAppAddToken#&code=#strJobCode#" target="_blank"><span class="alert6 style1"><strong>Apply to Job</strong></span></a></td></tr>
													</cfif>
												<cfelse>
													<cfswitch expression="#intResAdmCode#">
														<cfcase value="1">
														In order to view the contact details for this job, you must be a full member of 6FigureJobs. Membership is FREE! Please finish submitting your profile by <a href="/ExecEditProfile.cfm?#strAppAddToken#">clicking here</a>.
														</cfcase>
														<cfcase value="2">
														Your application for membership to 6FigureJobs is under consideration. Expect a response within one business day.  Until then, you cannot apply to a job posting.
														</cfcase>
														<cfdefaultcase>
														In order to view the contact details for this job, you must be a member of 6FigureJobs. Membership is FREE! If you are already a member, please login to your account. If you are not a member, please <a href="/ExecBecomeMember.cfm?#strAppAddToken#">click here</a> to learn more about 6Figurejobs or <a href="/execs/resbuilder/ExecResStart.cfm?#strAppAddToken#">register today</a>!
														</cfdefaultcase>
													</cfswitch>
												</cfif>
											</cfif> --->
										</cfif>
									</td>
								</tr>
							</table>
							
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<cfoutput>
					<tr>
						<td colspan="2">
							<table border=0 cellpadding=0 cellspacing=0 width="100%">
								<tr>
									<td align="right">
									<a href="##" class="executive_button" onclick="window.location='/member-job-history?#application.strAppAddToken#&am=#am#&tm=#tm#&jrl=1';"><span>Return to Application History</span></a>
									</td>
								</tr>
							</table>	
						</td>
					</tr>
					</cfoutput>
				<cfelse>
					<tr><td align="center">Job Record not found.</td></tr>
				</cfif>
			</table>
			</div>
		</div>
	</article>
</div>
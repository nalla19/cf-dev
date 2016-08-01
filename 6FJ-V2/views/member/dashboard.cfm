<!--- Show "Helpful Hits" if List Views or Detail Views is clicked --->
<cfif isdefined("url.hints") and url.hints EQ 1>
	<cfinclude template="tipsHints.cfm">
	<cfabort>
</cfif>

<cfparam name="request.thePNotification" default="">
<cfparam name="strRelocPref" default="">
<cflock scope="session" timeout="10" type="Exclusive">
	<cfset session.strSection="Exec" />
	<cfset strSection=session.strSection />
	<cfparam name="session.EXEC.intResAdmCode" default="0">
	<cfset lcl_intResAdmCode=session.EXEC.intResAdmCode />
	<cfset intResID =session.EXEC.intResID />
	
	
</cflock>
        
        <cfif application.sourceApp EQ "6FigureJobs">
            <cfif listFind("3", lcl_intResAdmCode)>
            	
            	<cfelse>
                <cfparam name="url.message" default="">
                <cfparam name="url.messagecode" default="">
                
                <!--- AAA --->
                <cfif isdefined("session.exec.ispremium") and not(session.exec.ispremium)>
                    <cftry>
                        <!--- Check For AAA Lead --->
                        <cfset qetAAA = application.executive.getAllenClientData(email=session.exec.strEmail) />
                    
                        <!--- Update Lead On 6FJ Side --->
                        <cfif qetAAA.recordcount>
                            <cfset qetAAA = application.executive.setAAAPremium(email=session.exec.strEmail) />
                            <cfset session.exec.ispremium = 1 />
                        </cfif>
                        
                        <cfcatch type="any">
                        <!--- // --->
                        </cfcatch>
                    </cftry>
                </cfif><!---ISR--->
                
                <cfoutput>
                
                <!--- Redirect User if OK --->
                <!--- ISR: where are we going? --->
                <cfif listfindnocase('5',lcl_intResAdmCode) and isdefined("client.redirect.refenc")>
                    <cfscript>
                    client.redirect.refenc = replacenocase(client.redirect.refenc,"|","?");
                    client.redirect.refenc = replacenocase(client.redirect.refenc,"|","&","ALL");
                    redirect = client.redirect.refenc;
                    structdelete(client,"redirect.refenc");
                    </cfscript>
                
                    <script>
                    window.open('#redirect#',"win",'');
                    </script>
                    <script>javascript:history.go(-1);</script>
                    <cfabort>
                </cfif>
                
                <!---set the default for RelevantJobCount to default of 6 so that the Featured Company does not show up --->
                <cfparam name="intRelevantJobCount" default="6">
                
                <!--- drop a cookie so we can remember which side they belong to --->
                <cfcookie name="sixFJSite" value="1">
                
                
                <cfparam name="blnDisplayNetworking" default="0">
                <!------------------------------------------------------------------------------------------------------------->
                <!------------------------------------------------------------------------------------------------------------->
                <!------------------------------------------------------------------------------------------------------------->
                
                
                <!---Process the incomplete section form submission--->
                <cfif isDefined("form.fieldnames") or isDefined("url.zTyD4g9l3d2") and zTyD4g9l3d2 is 1>
                   <!---User has chosen to complete the social media profile information later--->
					<cfif isDefined("url.zTyD4g9l3d2") and zTyD4g9l3d2 is 1>
						
						<!---Check if there is a LinkedIn Record for the User--->
						<cfquery name="cfqCheckLIRec" datasource="#application.dsn#">
							select * 
							  from tblResumesWebSites (nolock)
							 where intWebSiteCategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="8" />
							   and intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />
						</cfquery>
						
						<cfif cfqCheckLIRec.recordcount is 0>
							<cfquery name="cfqInsRecord" datasource="#application.dsn#">
							insert into tblResumesWebSites (intWebSiteCategoryID, intResID) values (<cfqueryparam cfsqltype="cf_sql_integer" value="8" />, <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />)	
							</cfquery>
						</cfif>
						<!----//LI Record Check--->
						
						
						<!---Check if there is a Twitter Record for the User--->
						<cfquery name="cfqCheckTwitterRec" datasource="#application.dsn#">
							select * 
							  from tblResumesWebSites (nolock)
							 where intWebSiteCategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="9" />
							   and intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />
						</cfquery>
						
						<cfif cfqCheckTwitterRec.recordcount is 0>
							<cfquery name="cfqInsRecord" datasource="#application.dsn#">
							insert into tblResumesWebSites (intWebSiteCategoryID, intResID) values (<cfqueryparam cfsqltype="cf_sql_integer" value="9" />, <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />)	
							</cfquery>
						</cfif>
						<!----//Twitter Record Check--->
						
					<!--- User is filling out the missing peices of the gamification --->	
					<cfelse>
						
						<cfswitch expression="#section#">
							
							<cfcase value="resumeUpload">
								<cfscript>
								// Assume Parsing Is OK --->
								inValidParse = 1;
								// ISR uploadedPath = application.sixfj.paths.webroot & "exports\";
								uploadedPath = "C:\webroot\6figurejobs\exports\";
								</cfscript>
								
									
								<!---Create the resume upload directory if it does not exist already--->
								<cfif not(directoryExists(uploadedPath))>
									<cfdirectory directory="#uploadedPath#" action="create" />
								</cfif>
						
								<cfif len(form.resumeFile)>
									
									<!--- File Length Is Not OK Size is Over 153600 Bytes --->
									<cfif cgi.CONTENT_LENGTH gte 153600>
										<cfset url.message = "Uploaded file is too large. Please upload files smaller than 150KB.">
										<cfset url.messagecode = 1>
									<cfelse>
										<cftry>
											<!--- Upload File --->
											<cffile action="upload" destination="#uploadedPath#" filefield="form.resumeFile" nameconflict="makeunique">
											<cfset uploadedFile = uploadedPath & cffile.serverFile />
											<cfset extList = "docx,doc,pdf" />
							
											<cfset shortName = randrange(100,100000) & "." & cffile.clientFileExt>
											<cfset reNamedFile 	= uploadedPath &  shortName>
											<cffile action="rename" destination="#reNamedFile#" source="#uploadedFile#">
											<cfset uploadedFile = reNamedFile />
						
											<cfset sovConsultantID = application.executive.getStoredResumeID(resumeFile=uploadedFile,resumePath=uploadedPath) />
											
											<cfset sovRenResumeID = sovConsultantID>
											
											<cfif len(sovRenResumeID) gt 10>
												<cfset url.message = "Issue Uploading the Resume">
												<cfset url.messagecode = 0>
											</cfif>
										
											<cfcatch type="any">
												<cfset url.message = "Issue Uploading the Resume">
												<cfset url.messagecode = 0>
											</cfcatch>
										</cftry>
									</cfif>
					
									
									
									<cfif not(len(url.message))>
										<cfif isdefined("uploadedFile") and len(uploadedFile)>
											<!--- Create Folder if Needed --->
											<cftry>
												 <cfscript>
												resObj = application.resume;
												resObj.setResumePath(intResid);
												//Files Uploaded Here
												resumeDirectory = resObj.getResumeDir(intResid);
												resumePath = resObj.getResumePath(intResid);
												copyFile =  uploadedPath & shortName;
												</cfscript><!---ISR --->
					
												<cfif fileExists(copyFile)>
													<!--- Copy Source File if Directory Exists --->
													<cfif directoryExists(resumeDirectory)>
														<cffile action="copy" destination="#resumeDirectory#" source="#copyFile#">
													</cfif>
					
													<cfquery datasource="#application.dsn#">
													update tblResumes 
													   set resumeFile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#" />
													 where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />
													</cfquery>
												</cfif>
					
												<cfcatch type="any">
													<!---Log the error to the cflog file--->
												</cfcatch>
											</cftry>
										</cfif>
										<!----End: Upload the initial resume upload--->
					
					
										<!--- Resume Was Parsed, update the resume content on step1 --->
										<cfif len(sovRenResumeID)>
											<!---ISR  ---><cfset consultants = application.executive.getParsedConsultants(consultantid=sovRenResumeID) />
											<cfset parsedResume = consultants.resume />
											<cfset parsedAddress = consultants.address1 />
									
											<cfif len(parsedResume)>
												<!---Update the Username for this intResID as the procedure sp_exec_registration does not update the username--->
												<cfquery name="cfqUpdResume" datasource="#application.dsn#">
												update tblresumes 
												   set resume = <cfqueryparam cfsqltype="cf_sql_varchar" value="#parsedResume#">
													   ,blnBigs = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
												 where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
												</cfquery>
											</cfif>
										</cfif>
					
										<cfquery name="cfqUpdInsRecord" datasource="#application.dsn#">
											update tblResumeProfiles set blnactive = 0 where fk_intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
											
											insert into tblResumeProfiles(fk_intresid, blnactive, dteCreated, dteEdited, title, resumeFile, consIntID)
											values (#intResID#, 1, getdate(), getdate(),'New Resume #dateformat(NOW(),'mm/dd/yy')#', '#shortName#', '#sovRenResumeID#')
									
											update tblResumeProfiles 
											   set resume = <cfqueryparam cfsqltype="cf_sql_varchar" value="#parsedResume#">
											where fk_intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
											  and blnactive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
										</cfquery>
										
										<!--- If the Option to Signup for the FREE resume critique is offered--->
										<cfif isDefined("form.freeResumeCritique") and form.freeResumeCritique neq "">
											<!--- Insert the Record into the tblAAABatch if the Candidate chose to receive the FREE Critique--->
											<cfif freeResumeCritique is 1>
												<cftry>
													<!--- Option Step 4 is dashboard --->
													<cfquery datasource="#application.dsn#">
													insert into tblAAABatch (intresid, dateStamp, optinStep, regComplete) values (#intResID#,getDate(), 4, 0)
													</cfquery>
													<cfcatch type="any"></cfcatch>
												</cftry>
											</cfif>
										</cfif>
										<cfset session.EXEC.dteResumeEdited = DateFormat(Now(),"mmm dd, yyyy")>				
									</cfif>
								</cfif>
								<!--- <cfabort> --->
							</cfcase>
							
							
							<cfcase value="relocation">
								
								<!--- If the candidate has chosen not to relocate --->
								<cfif blnRelocate is 0>
									<cfquery name="cfqUpdRelocation" datasource="#application.dsn#">
									update tblResumes 
									   set relocate = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
									  where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
									</cfquery>
								<!--- If the candidate has chosen to relocate --->
								<cfelseif blnRelocate is 1>
									<cfset statesList = "">
									<cfloop list="#form.form_q_nst#" index="state" delimiters=",">
										<cfset statesList = ListAppend(statesList, "'#state#'")>
									</cfloop>
									
									<cfquery name="cfqGetStates" datasource="#application.dsn#">
									select intOldID From tblStates (nolock) where strName in (#preserveSingleQuotes(statesList)#)
									</cfquery>
									<cfset stateIDsList = valueList(cfqGetStates.intOldID)>
									
									<cfquery name="cfqUpdRelocation" datasource="#application.dsn#">
									update tblResumes 
									   set relocate = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
										   ,location_preference = <cfqueryparam cfsqltype="cf_sql_varchar" value="#stateIDsList#">
									 where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResID#">
									</cfquery>
								</cfif>
								
							</cfcase>
							
							
							<cfcase value="socialMedia">
								
								<!---If the twitter profile is entered--->
								<cfif isDefined("form.twitterprofile") and len(form.twitterprofile)>	
									<!--- Check to see if there is twitter profile for this candidate already in the system --->
									<cfquery name="cfqgetTwitter" datasource="#application.dsn#">
									select * from tblResumesWebSites (nolock) where intResumeWebSiteID = <cfqueryparam cfsqltype="cf_sql_integer" value="9"> and intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#intresid#">
									</cfquery>
					
									<cfif cfqgetTwitter.recordcount gt 0>
										<!---Update--->
										<cfquery name="cfqgetUpdTwitterProf" datasource="#application.dsn#">
										update tblResumesWebSites set strResumeWebSiteName = <cfqueryparam cfsqltype="cf_sql_varchar" value="My Twitter Profile"> , strResumeWebSiteURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.twitterprofile#"> where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intresid#">
										</cfquery>
									<cfelse>
										<cfquery name="cfqInsMyWebsites" datasource="#application.dsn#">
										insert into tblResumesWebSites (intResID, intWebSiteCategoryID, strResumeWebSiteName, strResumeWebSiteURL)
										values (<cfqueryparam cfsqltype="cf_sql_integer" value="#intresid#"> , <cfqueryparam cfsqltype="cf_sql_integer" value="9">, <cfqueryparam cfsqltype="cf_sql_varchar" value="My Twitter Profile"> , <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.twitterprofile#">)
										</cfquery>
									</cfif>
								</cfif>
								
								
								<!---If the LinkedIn profile is entered--->
								<cfif isDefined("form.linkedinprofile") and len(form.linkedinprofile)>	
									<!--- Check to see if there is twitter profile for this candidate already in the system --->
									<cfquery name="cfqgetlinkedin" datasource="#application.dsn#">
									select * from tblResumesWebSites (nolock) where intResumeWebSiteID = <cfqueryparam cfsqltype="cf_sql_integer" value="8"> and intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#intresid#">
									</cfquery>
					
									<cfif cfqgetlinkedin.recordcount gt 0>
										<!---Update--->
										<cfquery name="cfqgetUpdLinkedinProf" datasource="#application.dsn#">
										update tblResumesWebSites set strResumeWebSiteName = <cfqueryparam cfsqltype="cf_sql_varchar" value="My LinkedIn Profile"> , strResumeWebSiteURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.linkedinprofile#"> where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#intresid#">
										</cfquery>
									<cfelse>
										<cfquery name="cfqInsMyWebsites" datasource="#application.dsn#">
										insert into tblResumesWebSites (intResID, intWebSiteCategoryID, strResumeWebSiteName, strResumeWebSiteURL)
										values (<cfqueryparam cfsqltype="cf_sql_integer" value="#intresid#"> , <cfqueryparam cfsqltype="cf_sql_integer" value="9">, <cfqueryparam cfsqltype="cf_sql_varchar" value="My LinkedIn Profile"> , <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.linkedinprofile#">)
										</cfquery>
									</cfif>
								</cfif>
								
								
							</cfcase>
						</cfswitch>
					</cfif>
                </cfif>
                
                <!---//Process the incomplete section form submission--->
                
                
                <!--------------------------------------------------------------------------
                -------------------------Start:Gamification Piece---------------------------
                --------------------------------------------------------------------------->
                <cfparam name="blnShowWebsiteProfiles" default="1">
                <cfparam name="blnShowTwitterProfile" default="1">
                <cfparam name="blnShowLinkedInProfile" default="1">
                <cfparam name="blnShowRelocation" default="1">
                <cfparam name="blnShowResume" default="1">
                <cfparam name="freeResumeCritique" default="1">
                <cfparam name="progressBarPercentage" default="100">
                
                <cfparam name="url.message" default="" />
                <cfparam name="url.messagecode" default="" />
                
                <!---Featured company of the week --->
                <cfquery name="cfqFeatCompanyOfWeek" datasource="#application.dsn#">
                SELECT ercp.intCorpID,
                                    
                        ercp.strCoName,
                        ercp.strDescription,
                        ercp.strFeaturedURL,
                            
                        emp.seoStrCompany,
                        emp.strCity,
                        emp.strState,
                                    
                        era.strProfilePgLogo,
                        era.strProfilePgLogoAltTag,
                        era.strMasterLogo,
                        era.strMasterLogoAltTag,
                        era.strHomePgFeatureLogo,
                        era.strHomePgFeatureLogoAltTag,
                        era.strHomePgSliderLogo,
                        era.strHomePgSliderLogoAltTag,
                                    
                        era.strCorporateVideo,
                        era.strTwitterLink,
                        era.strFacebookLink,
                        era.strLinkedInLink,
                        era.strGooglePlusLink,
                        era.strYoutubeLink,
                        era.strPinterestLink,
                        era.strOpportunites as strOpportunities,
                        era.strPerks,
                        era.strBenfGrowthPros,
                        era.strSummary,
                                    
                        era.strProfilePgTrackURL,
                        era.strJobDetPgTrackURL,
                        era.strHomePgTrackURL
                
                   FROM tblERCorpPage ercp,
                        tblCorpID corp,
                        tblEmployers emp
                   LEFT OUTER JOIN tblErAssets era ON (emp.intEmployerID = era.intEmployerID)
                  WHERE ercp.intCorpID=corp.intCorpID
                    AND corp.intEmployerID=emp.intEmployerID
                    AND emp.blnFeaturedHomePage = 1 
                    AND emp.dteAcctExp >= '#DateFormat(now(),"mm/dd/yyyy")#'
                </cfquery>
                
                <cfoutput>
                <cfif session.EXEC.strRegistrationMethod is "LinkedIn">
                    <!---Check If the Candidate filled in LinkedIn Profile--->
                    <cfquery name="cfqLinkedInProfile" datasource="#application.dsn#">
                    select * from tblResumesWebSites (nolock) where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intResID#" /> and intWebsiteCategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="8" />
                    </cfquery>
                    
                    <cfif cfqLinkedInProfile.recordcount gt 0>
                        <!---Do not show the website profiles---->
                        <cfset blnShowLinkedInProfile = 0>
                    </cfif>
                    
                    <!---Check If the Candidate filled in Twitter Profile--->
                    <cfquery name="cfqTwitterProfile" datasource="#application.dsn#">
                    select * from tblResumesWebSites (nolock) where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intResID#" /> and intWebsiteCategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="9" />
                    </cfquery>
                    
                    <cfif cfqTwitterProfile.recordcount gt 0>
                        <!---Do not show the website profiles---->
                        <cfset blnShowTwitterProfile = 0>
                    </cfif>
                    
                    <cfif blnShowLinkedInProfile is 0 and blnShowTwitterProfile is 0>
                        <cfset blnShowWebsiteProfiles = 0>
                    </cfif>
                    
                <cfelse>
                    <!---Check If the Candidate filled in atleast one Website Profile--->
                    <cfquery name="cfqWebSiteProfiles" datasource="#application.dsn#">
                    select * from tblResumesWebSites (nolock) where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intResID#" />
                    </cfquery>
                    
                    <cfif cfqWebSiteProfiles.recordcount gt 0>
                        <!---Do not show the website profiles---->
                        <cfset blnShowWebsiteProfiles = 0>
                    </cfif>
                </cfif>
                
                <!---Check if the Candidate filled in the relocation information--->
                <cfquery name="cfqGetRelocation" datasource="#application.dsn#">
                select relocate from tblResumes (nolock) where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intResID#" />
                </cfquery>
                
                <cfif cfqGetRelocation.relocate eq 1 or cfqGetRelocation.relocate eq 0>
                    <cfset blnShowRelocation = 0>
                </cfif>
               
                <cfif session.EXEC.strRegistrationMethod is "LinkedIn">
                    <!---
                    We upload a primary resume when a candidate is registering using LinkedIn, we have to check to see if the candidate has uploaded a new resume other than the
                    one we created for them based on their LinkedIn Profile
                    --->
                    <cfquery name="cfqCheckResumes" datasource="#application.dsn#">
                    select count(*) resCnt from tblResumeProfiles (nolock) where fk_intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intResID#" />
                    </cfquery>
                    
                    <cfif cfqCheckResumes.resCnt gt 1>
                        <cfset blnShowResume = 0>
                    </cfif>
                    
                    <!---12/12/13: Don't show the resume upload for the LinkedIn Registrants---->
                    <cfset blnShowResume = 0>
                <cfelse>
                    <!--- Check if the Candidate has a resume uploaded --->
                    <cfquery name="cfqResume" datasource="#application.dsn#">
                    select resume from tblResumes (nolock) where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intResID#" /> and resume is not null
                    </cfquery>
                    
                    <cfif cfqResume.recordcount gt 0>
                        <cfset blnShowResume = 0>
                    </cfif>
                </cfif>
                
                <!--- Free Resume Critique --->
                <cfquery name="cfqFreeResCritique" datasource="#application.dsn#">
                select * from tblAAABatch (nolock) where intresid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.exec.intResID#" />
                </cfquery>
                    
                <cfif cfqFreeResCritique.recordcount gt 0>
                    <cfset freeResumeCritique = 0>
                </cfif>
                
                <cfif blnShowWebsiteProfiles is 1>
                    <cfset progressBarPercentage = progressBarPercentage - 10> 
                </cfif>
                
                <cfif blnShowRelocation is 1>
                    <cfset progressBarPercentage = progressBarPercentage - 10> 
                </cfif>
                
                <cfif blnShowResume is 1>
                    <cfset progressBarPercentage = progressBarPercentage - 10> 
                </cfif>
                </cfoutput>
                <!--------------------------------------------------------------------------
                --------------------------End:Gamification Piece----------------------------
                --------------------------------------------------------------------------->
                
                <!--- Get the Resume Profiles dteEdited  --->
                <cfparam name="resumeLastEditedDate" default="">
                <cfset resumeLastEditedDate = session.EXEC.dteResumeEdited>
                
                <!---Get the contact info---->
                <cfparam name="strPhoneNumber" default="">
                                
                <cfif len(session.EXEC.strHomePhone)>
                    <cfset strPhoneNumber = session.EXEC.strHomePhone>
                <cfelseif len(session.EXEC.strMobilePhone)>
                    <cfset strPhoneNumber = session.EXEC.strMobilePhone>
                <cfelseif len(session.EXEC.strWorkPhone)>
                    <cfset strPhoneNumber = session.EXEC.strWorkPhone>
                </cfif>
                
                <div id="page-dashboard">
                    <article class="section">
                    	#request.thePNotification#
                       
                        <!---Show the Modules if the application is complete, do not show account profile and other modules if the application is incomplete or under review--->
                        <cfif not lcl_intResAdmCode eq 1 and not lcl_intResAdmCode eq 2 and not lcl_intResAdmCode eq 20  and not lcl_intResAdmCode eq 10> <!--- incomplete or "in-review" profile --->
                        
                            <div class="container">	
                                <div class="row">
                                <div class="span6" >
                                    <!---<cfif lcl_intResAdmCode eq 6>
                                        <cfinclude template="/6fj/t_ExecMyAccount_jobSearchmgmt.cfm">
                                        
                                        <div class="spacer"></div>
                                        <cfinclude template="/6fj/t_ExecMyAccount_acctprofile.cfm">
                                
                                    <!--- Resume is Complete... --->	
                                    <cfelseif lcl_intResAdmCode neq 1>--->
                                     <cfif lcl_intResAdmCode neq 1>       
                                        <div class="accountprofile" >	
                                            <div class="row">
                                                <div class="span6"><h3>#session.exec.strfirstname# #session.exec.strlastname#</h3></div>	
                                            </div>
                                                
                                            <div class="push2"></div>
                                            
                                            <!---Current Position--->	
                                            <div class="row">
                                                <div class="span2 profile">Current</div>
                                                <div >
                                                    <strong>#session.exec.strExecJOBTitle_1#</strong>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="span2 profile"></div>
                                                <div> 
                                                	#session.exec.strExecJOBCompany_1#
                                                </div>
                                            </div>
                                            <!---//Current Position--->								
                                                        
                                            <div class="page-spacer"></div>
                                            
                                            <!---Previous Position--->	
                                            <div class="row">
                                                <div class="span2 profile">Previous</div>
                                                <div >
                                                    <strong>#session.exec.strExecJOBTitle_2#</strong>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="span2 profile"></div>
                                                <div> 
                                                	#session.exec.strExecJOBCompany_2#
                                                </div>
                                            </div>
                                           					
                                            <!---//Previous Position--->		
                                            
                                            <div class="page-spacer"></div>
                                            
                                            <!---Location--->
                                            <div class="row">
                                                <div class="span2 profile">Location</div>
                                                <div>
                                                    <!---<strong>#strCity#, #strState# #strZip#</strong>--->
                                                   #session.EXEC.strCity#, #session.EXEC.strState# #session.EXEC.strZip#
                                                </div>
                                            </div>
                                            
                                            <!---//Location--->
                                                
                                            <div class="page-spacer"></div>
                                            
                                            <!---Contact Info--->	
                                            <div class="row">
                                                <div class="span2 profile">Contact</div>
                                                <div>
                                                   
                                                    #session.exec.strEmail#
                                                </div>
                                            </div>	
                                            <div class="row">
                                                <div class="span2 profile"></div>
                                                <div>
                                                    #strPhoneNumber#
                                                </div>
                                            </div>						
                                            <!---//Contact Info--->
                                                
                                            <div class="page-spacer"></div>								
                                            
                                            <!---Edit Profile--->							
                                            <div class="row">
                                                <cfif progressBarPercentage	lt 100 and blnShowResume is 1 and not session.exec.strRegistrationMethod eq "LinkedIn">
                                                    
                                                    <div class="span2">
                                                        <input class="btn btn2 btn-default btn-small" type="button" name="validate" id="submitBtn" value="&nbsp;Edit Profile&nbsp;" disabled>
														
                                                    </div>
                                                
                                                    <div class="redalert">No resume on file. Please upload a resume.</div>
                                                                            
                                                <cfelse>
                                                    
                                                    <div class="span2">
                                                        <a href="/member-profile" class="btn btn2 btn-primary btn-small" role="button">&nbsp;Edit Profile&nbsp;</a>
														
														<!--- <input class="btn btn-primary" type="button" name="validate" id="submitBtn" value="&nbsp;Edit Profile&nbsp;"> --->
                                                    </div>
                                                
                                                    <cfset profupdtDate 		 = dateformat(session.exec.dteEdited, 'YYYY/MM/DD')>
                                                    <cfset profupdtMonth  		 = Month(profupdtDate)>
                                                    <cfset profupdtMonthAsString = MonthAsString(profupdtMonth)>
                                                    <cfset profupdtday    		 = day(profupdtDate)>
                                                    <cfset profupdtYear   		 = year(profupdtDate)>
                                                    
                                                    <div style="font-size:14px">Last Updated: #profupdtMonthAsString# #profupdtday#, #profupdtYear#<br>
														<a href="/change-password">Change password</a></div>
                                                    
                                                </cfif>
                                            </div>	
                                            <!---//Edit Profile--->	
                                            
                                            <div class="page-spacer"></div>	
                                            
                                            <!---Edit Resume--->	
                                            <div class="row">
                                                <div class="span2">
                                                    <cfif len(resumeLastEditedDate)>
														<a href="/member-resume" class="btn btn2 btn-primary btn-small" role="button">&nbsp;My Resume&nbsp;</a>
                                                        <!--- <a href="/member-resume"><input class="btn btn-primary" type="button" name="validate" id="submitBtn" value="My Resume"></a> --->
                                                    <cfelse>
                                                        <input class="btn btn2 btn-default btn-small" type="button" name="validate" id="submitBtn" value="My Resume" disabled>
                                                    </cfif>
                                                </div>
                                            
                                                <cfif len(resumeLastEditedDate)>
                                                    <cfset resupdtDate 		 	 = dateformat(resumeLastEditedDate, 'YYYY/MM/DD')>
                                                    <cfset resupdtMonth  		 = Month(resupdtDate)>
                                                    <cfset resupdtMonthAsString  = MonthAsString(resupdtMonth)>
                                                    <cfset resupdtday    		 = day(resupdtDate)>
                                                    <cfset resupdtYear   		 = year(resupdtDate)>
                                                
                                                    <div style="font-size:14px">Last Updated: #resupdtMonthAsString# #resupdtday#, #resupdtYear#</div>
                                                <cfelse>
                                                    <div class="redalert">No resume on file. Please upload a resume.</div>
                                                </cfif>
                                            </div>
                                            <!---//Edit Resume--->
                                                
                                            <div class="page-spacer"></div>	
                                            
                                            <!---Edit Privacy--->
                                            <div class="row">
                                                
                                                
                                                <!---If the Candidate has not uploaded a resume yet, set the privacy setting to be private--->
                                                <cfif progressBarPercentage	lt 100 and blnShowResume is 1>
                                                    <div class="span2">
                                                    <input class="btn btn2 btn-default btn-small" disabled type="button" name="validate" id="submitBtn" value="&nbsp;&nbsp;&nbsp;&nbsp;Privacy&nbsp;&nbsp;&nbsp">
                                                    </div>
                                                
                                                    <div><span class="redalert">Your profile is "Private"</span></div>	
                                                <cfelse>
                                                    <div class="span2">
													<a href="/member-privacy" class="btn btn2 btn-primary btn-small" role="button">&nbsp;&nbsp;&nbsp;&nbsp;Privacy&nbsp;&nbsp;&nbsp</a>
                                                       <!---  <a href="/member-privacy"><input class="btn btn-primary" type="button" name="validate" id="submitBtn" value="&nbsp;&nbsp;&nbsp;&nbsp;Privacy&nbsp;&nbsp;&nbsp"></a> --->
                                                    </div>
                                                    
                                                    <cfif session.EXEC.blnSearchable is 1>
                                                        <div style="font-size:14px">
                                                            Your profile is "Searchable by Recruiters"
                                                            <div class="spacer"></div>
                                                            <a href="##myModal" data-toggle="modal">Here's how recruiters see you</a>
                                                        </div>
                                                    <cfelse>
                                                        <div style="font-size:14px">
                                                            <span class="redalert">Your profile is "Private"</span>
                                                            <br>
                                                            <a href="/member-profile##privacy" style="font-size:14px; ">Make your profile searchable to recruiters</a>
                                                        </div><!---  --->	
                                                    </cfif>
                                                </cfif>
                                                                    
                                                <!-- List View Modal Begin -->
                                                <div class="modal hide fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                                    <div class="modal-header">
                                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                                                        <h4 id="myModalLabel">Example: How you will show up in search results.</h4>
                                                    </div>
                                                    <div class="modal-body">
                                                        <img src="/img/searchresults_example.png">
                                                    </div>
                                                </div>
                                                <!-- List View Modal End -->		
                                            </div>
                                            <!---//Edit Privacy--->
                
                                            <div class="page-spacer"></div>	
                                                
                                            <div class="profile-links row">
                                                <div class="span2">
                                                    <strong>Profile Views</strong>
                                                </div>
                                                <div><a href="javascript://" onclick='addwindow=window.open("/member-dashboard?hints=1","popResViews","scrollbars=yes,width=300,height=350,resizable"); return false;' title="List Views">#session.exec.intListViews# List Views</a>&nbsp;|&nbsp;<a href="javascript://" onclick='addwindow=window.open("/member-dashboard?hints=1","popResViews","scrollbars=yes,width=300,height=350,resizable"); return false;' title="Resume Detail Views">#session.exec.intDetailViews# Detail Views</a>&nbsp;|&nbsp;<a href="/member-stats">Reset Stats</a></div>
                                            </div>	
                                                
                                            <div class="page-spacer"></div>	
                                        </div>
                                            
                                        <div class="page-spacer"></div>	
                                        
                                        <!---Job Alerts--->	
                                        <div class="accountprofile">
                                                
                                            <div class="row">	
                                                <div class="page-spacer"></div>	
                                                                                        
                                                <div class="span2">
													<a href="/member-job-alerts" class="btn btn2 btn-primary btn-small" role="button">My Job Alerts</a>
                                                    <!--- <a href="/member-job-alerts"><input class="btn btn-primary" type="button" name="validate" id="submitBtn" value="My Job Alerts"></a> --->
                                                </div>
                                                    
                                                <cfquery datasource="#application.dsn#" name="GetAgents">
                                                select strTitle
                                                from tblSearchAgent (NOLOCK)
                                                where intresid=<cfqueryparam  cfsqltype="cf_sql_integer" value="#session.exec.intResID#" />
                                                order by dteCreated
                                                </cfquery>
                                    			
                                                <cfif GetAgents.recordcount gt 0>
                                                    <div>
                                                        <cfloop query="GetAgents">
														<cfset strTitle = application.util.getRemoveQuotes(strStrip="#strTitle#",  blnRemove="0")>
                                                        <!---ISR<a href="/ExecSearchAgent.cfm?#strAppAddToken#&strMode=run&strTitle=#URLEncodedFormat(strTitle)#" title="Run"><cf_ct_removeQuotes strStrip="#strTitle#" blnRemove="0"><cfset Agent=trim(strStrip)>#Agent#</a>--->
                                                       
														<a href="/member-job-alerts?#application.strAppAddToken#&strMode=run&strTitle=#URLEncodedFormat(strTitle)#" title="Run">#strTitle#<!--- <cf_ct_removeQuotes strStrip="#strTitle#" blnRemove="0"><cfset Agent=trim(strStrip)>#Agent# ---></a>
                                                        
                                                        <br />
                                                        <cfset Agent="">
                                                        </cfloop>
                                                    </div>
                                                <cfelse>
                                                    <div class="redalert">You have 3 unused Job Search Alerts</div>
                                                </cfif>
                                               </div>
											   <div class="row">           
                                                <div class="span6">
                                                    <div class="page-spacer"></div>	
                                                    <a href="/member-job-history">View jobs that I've applied to</a>
                                                    <div class="page-spacer"></div>	
                                                </div>
                                                    
                                                <div class="page-spacer"></div>										
                                            </div>							
                                        </div> 
                                        <!---//Job Alerts--->
                    
                                        <div class="page-spacer"></div>	
                
                                        <!---Email Subscriptions--->
                                        <div class="accountprofile">
                                            <div class="page-spacer"></div>	
                
                                            <div class="row">
                                                <div class="span3">
                                                    <strong>Email Subscriptions</strong>
                                                </div>
                                                    
                                                <div class="span4">
                                                <a href="/member-email-subscriptions">Manage Email Subscriptions</a>
                                                </div>
                                            </div>
                                            <div class="page-spacer"></div>				
                                        </div>
                                        <!---//Email Subscriptions--->
                                    </cfif>
                                </div>
                               
                                
                                <!-------------------------------------------------------------------------------------->
                                <!---------------------------- If the profile is 100% complete ------------------------->
                                <!-------------------------------------------------------------------------------------->
                                <cfif progressBarPercentage is 100>
                                    <div class="span5 offset1">
                                        <div class="row">
                                            <div>
                                                <h4>#session.exec.strFirstName#, your profile is #progressBarPercentage#% complete.</h4>
                                                <div class="progress progress-success">
                                                    <div class="bar" style="width:#progressBarPercentage#%"></div>
                                                </div>				
                                            </div>
                                        </div>
                                        <!---Run the queries to get the matching jobs--->
                                        <cfinclude template="matchingjobs.cfm">
	
                                        <cfif intRelevantJobCount lte 3 >
                                            <div class="spacer"></div>
                                            <div class="spacer"></div>
                                            <div class="row pull-left">
                                                <h4>Featured company of the week</h4>
                                                <p class="pull-left"><a href="/company/#cfqFeatCompanyOfWeek.seoStrCompany#"><img src="/images/#cfqFeatCompanyOfWeek.strHomePgFeatureLogo#" alt="#cfqFeatCompanyOfWeek.strHomePgFeatureLogoAltTag#"></a></p>
                                                <br clear="all" />
                                                <p>#cfqFeatCompanyOfWeek.strSummary#</p>
                                                <p class="featured-links"><a href="/company/#cfqFeatCompanyOfWeek.seoStrCompany#">Learn more</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="/company/#cfqFeatCompanyOfWeek.seoStrCompany#">View job openings</a></p>
                                            </div>
                                        </cfif>
                                     </div>
                                <!-------------------------------------------------------------------------------------->
                                <!------------------------- If the profile is not 100% complete ------------------------>
                                <!-------------------------------------------------------------------------------------->
								 <cfelse>
                                	<div class="span5 offset1">                                        
                                        <div class="row">
                                            <div>
                                                <h4>#session.exec.strFirstName#, your profile is #progressBarPercentage#% complete.</h4>
                                                    <div class="progress progress-success">
                                                    <div class="bar" style="width:#progressBarPercentage#%"></div>
                                                </div>
                                                <h5>Please complete the following to optimize your profile and user experience.</h5>
                                            </div>
                                        </div>
                                        <div class="page-spacer"></div>	
                                        
                                        <!---If the resume has not been uploaded yet, give the user option to upload the resume--->
                                        <cfif blnShowResume is 1>
                                            <div class="row resumeupload pull-left">
                                                <!--- <form name="myAccountResumeUpload" id="myAccountResumeUpload"  action="ExecMyAccount.cfm" method="post" enctype="multipart/form-data" onSubmit="return checkResumeUpload();"> --->
												<form name="myAccountResumeUpload" id="myAccountResumeUpload"  action="/member-dashboard" method="post" enctype="multipart/form-data" onSubmit="return checkResumeUpload();">
                                                	<input type="hidden" name="section" value="resumeUpload" />
                                                    <div>
                                                        <cfif url.messagecode is 1>
                                                            <div class="alert alert-error">
                                                            Woops! We could not process the information submitted.
                                                            <br />
                                                            #URL.message#
                                                            </div>
                                                        <cfelseif url.messagecode is 0>
                                                            <div class="alert alert-error">Woops! We could not process the information submitted. Please try again.</div>
                                                        </cfif>
                                                    
                                                        <h5>Please Upload Your Resume (Important)</h5>
                                                        <h6>A resume is required if you want recruiters to search for you and if you want to apply to jobs.</h6>
                                                        <!--- <input type="text"  name="resumeTitle" value="" id="resumeTitle" placeholder="Name your resume" class="input-small span4"  maxlength="35"  />
                                                        <div class="page-spacer"></div> --->
                                                       
                                                        <div class="page-spacer"></div>
														 <h6>Microsoft Word or PDF files only.</h6>
                                                        <input name="resumeFile" value="" type="file" size="30" id="resumeFile"  />
                                                        <div id="resumeUploadDiv" style="color:##F00; display:none;"><strong>Please select a resume to upload to continue.</strong></div>
                                                    
                                                        <!--- Show the FREE Resume Critique if the candidate did not optin on step3 --->
                                                        <cfif freeResumeCritique is 1>
                                                           
                                                            <div class="page-spacer"></div>
                                                            <h5 id="blnResumeCritiqueErrTxt">Want a FREE resume critique from our resume writing partner?</h5>
															<label class="radio inline"><input name="freeResumeCritique" type="radio" id="freeResumeCritiqueYes" value="1">Yes</label> &nbsp; <label class="radio inline"><input name="freeResumeCritique" type="radio" id="freeResumeCritiqueNo"value="0" >No</label>
                                                        </cfif>
                                                        <!--- //Show the FREE Resume Critique if the candidate did not optin on step3 --->
                                                    
                                                       <!---  <div class="page-spacer"></div>
                                                        <div class="page-spacer"></div>
                                                        <div class="page-spacer"></div> --->
                                                        <div class="page-spacer"></div>
                                                        <input class="btn btn-primary" type="submit" name="validate" id="resUploadSubmitBtn" value="Upload Resume">
                                                    </div>
                                                </form>							
                                            </div>
                                            <div class="page-spacer"></div>
                                        <cfelse>
                                            <!---Run the queries to get the matching jobs--->
                                            <cfinclude template="matchingjobs.cfm">
                                            
                                            <cfif (intRelevantJobCount lte 3 and blnShowRelocation is 1 and blnShowWebsiteProfiles is 0) or 
                                                  (intRelevantJobCount lte 3 and blnShowRelocation is 0 and blnShowWebsiteProfiles is 1) or 
                                                  (intRelevantJobCount lte 3 and blnShowRelocation is 0 and blnShowWebsiteProfiles is 0) >
                                                <div class="page-spacer"></div>
                                                <div class="page-spacer"></div>
                                                    <div class="row pull-left">
                                                        <h4>Featured company of the week</h4>
                                                        <p class="pull-left"><a href="/company/#cfqFeatCompanyOfWeek.seoStrCompany#"><img src="/images/#cfqFeatCompanyOfWeek.strHomePgFeatureLogo#" alt="#cfqFeatCompanyOfWeek.strHomePgFeatureLogoAltTag#"></a></p>
                                                        <br clear="all" />
                                                        <p>#cfqFeatCompanyOfWeek.strSummary#</p>
                                                        <p class="featured-links"><a href="/company/#cfqFeatCompanyOfWeek.seoStrCompany#">Learn more</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="/company/#cfqFeatCompanyOfWeek.seoStrCompany#">View job openings</a></p>
                                                    </div>
                                            </cfif>
                                        </cfif>
                                        <!---//If the resume has not been uploaded yet, give the user option to upload the resume--->
                                    
                                        
                                        <!---If the relocation information has not been entered yet, give the user option to enter the relocation info--->
                                        <cfif blnShowRelocation is 1>
                                            <div class="row relocation pull-left">
                                                <form name="myAccountRelocate" id="myAccountRelocate"  action="/member-dashboard" method="post" enctype="multipart/form-data" onsubmit="return checkRelocation();">
                                                	<input type="hidden" name="section" value="relocation" />
                                                	<div class="row-fluid">
														<h5><span id="blnRelocationErrTxt">Are you willing to relocate?</span>&nbsp;&nbsp; <label class="radio inline"><input type="radio" name="blnRelocate" id="blnrelocateYes" value="1">Yes&nbsp;</label>&nbsp;&nbsp; <label class="radio inline"><input type="radio" name="blnRelocate" id="blnrelocateNo" value="0">No&nbsp;</label>&nbsp;&nbsp;&nbsp;<input class="btn btn-primary" type="submit" name="validate" id="submitBtn" value="Save"></h5>
														<div class="row leftPadding pull-left" id="relocateprefs" style="display:none;">
															<div id="relocationDiv" class="redalert" style="display:none;"><h6>Please select upto only 10 locations where you would like to relocate to</h6></div>
															<div class="span5">
																<div id="relocationText"><h6>Where would you relocate?</h6></div>
															</div>
															<div class="page-spacer"></div>
															<div class="span5"><cfinclude template="relocation_list.cfm"></div>
														</div>		
													</div>				
                                                </form>	
                                            </div>
                                            <div class="page-spacer"></div>
                                        </cfif>
                                        <!---//If the relocation information has not been entered yet, give the user option to enter the relocation info--->
                                        <!---If the Website Profiles information has not been entered yet, give the user option to enter the Website Profiles info--->
                                        <cfif blnShowWebsiteProfiles is 1>
                                            <div class="row socialmedia pull-left">
                                                <cfif session.EXEC.strRegistrationMethod is "LinkedIn">
                                                    
                                                    <form name="myAccountwebsiteProfile" id="myAccountwebsiteProfile"  action="/member-dashboard" method="post" enctype="multipart/form-data" onsubmit="return checkSocialMedia2();" >
                                                    	<input type="hidden" name="section" value="socialMedia" />
                                                    	<div class="row-fluid">
                                                        	<h6>(Optional) Share your other social media profiles with recruiters.</h6>
                                                        	<img src="/images/dashboard/icon-twitter.png" />&nbsp;&nbsp;<input type="text" name="twitterProfile" id="twitterProfile" value="" placeholder="Ex: http://www.twitter.com/username" class="span10" maxlength="175" />
                                                        	<div class="page-spacer"></div>
                                                        	<div class="leftPadding"><input class="btn btn-primary" type="submit" name="validate" id="submitBtn" value="Save">&nbsp;&nbsp;<a href="/member-dashboard?zTyD4g9l3d2=1">No Thanks. Not now.</a></div>
                                                    	</div>
                                                    </form>
                                                
                                                <cfelse>
                                                    
                                                    <form name="myAccountwebsiteProfile" id="myAccountwebsiteProfile"  action="/member-dashboard" method="post" enctype="multipart/form-data" onsubmit="return checkSocialMedia();" >
                                                    	<input type="hidden" name="section" value="socialMedia" />
                                                    	<div class="row-fluid">
                                                        	<h5>(Optional) Share your other social media profiles with recruiters.</h5>
                                                        	
															<img src="/images/dashboard/icon-twitter.png" /><input type="text" name="twitterProfile" id="twitterProfile" value="" placeholder="Ex: http://www.twitter.com/username" class="span10" maxlength="175" />
                                                        	
															<div class="page-spacer"></div>
                                                        	<img src="/images/dashboard/icon_linkedin.png" /><input type="text" name="linkedInProfile" id="linkedInProfile" value="" placeholder="Ex: http://www.linkedin.com/username" class="span10" maxlength="175" /><br />
                                                        	<div class="page-spacer"></div>
                                                       	 	<div class="leftPadding"><input class="btn btn-primary" type="submit" name="validate" id="submitBtn" value="Save">&nbsp;&nbsp;<a href="/member-dashboard?zTyD4g9l3d2=1">No Thanks. Not now.</a></div>
                                                    	</div>
                                                    </form>
                                                    
                                                </cfif>
                                            </div>
                                        </cfif>
                                        <!---//If the Website Profiles information has not been entered yet, give the user option to enter the Website Profiles info--->
                                        
                                     </div>  
                                 </cfif>
                                 </div>
                        </cfif>
                        	<!---//Show the Modules if the application is complete, do not show account profile and other modules if the application is incomplete or under review--->			
                    </article>
                </div> <!--- //End InnerContainer --->
                
            
                <!--- // 12/01/2013 - Load scripts --->
                
                <!--- Google Conversion Code --->
                <!-- Google Code for Other Conversion Page --> 
                <script language="JavaScript" type="text/javascript">
                <!--
                var google_conversion_id = 1071435707;
                var google_conversion_language = "en_US"; 
                var google_conversion_format = "1"; 
                var google_conversion_color = "666666"; 
                var google_conversion_label = "default"; //--> 
                </script> 
                <script language="JavaScript" src="https://www.googleadservices.com/pagead/conversion.js"></script>
                <noscript>
                <img height=1 width=1 border=0 src="https://www.googleadservices.com/pagead/conversion/1071435707/?label=default&script=0">
                </noscript>
                </cfoutput>
                
                
                
            </cfif>
 
        </cfif>
		 <script language="JavaScript" src="/js/candidatedashboard.js"></script>
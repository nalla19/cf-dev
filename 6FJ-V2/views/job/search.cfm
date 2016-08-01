<!--- <cfdump var="#session.exec.queryParams#"> --->

<div class="page-search" id="page-search">
	<cfif request.qry_advertisingbanner.strAdvBannerType is 1>
    	<div class="advertising-banner">
	    <cfoutput><a href="#request.qry_advertisingbanner.strAdvBannerURLLink#" target="_blank"><img src="#application.v1URL#/images/adbanners/#request.qry_advertisingbanner.strAdvBannerImg#" alt="Advertising Banner" /></a></cfoutput>
        </div>
	<cfelseif request.qry_advertisingbanner.strAdvBannerType is 2>
		<div class="advertising-banner">
	    <cfoutput>#request.qry_advertisingbanner.strAdvBannerText#</cfoutput>
        </div>
    </cfif>
    
	<header class="page-header visible-desktop">
		<div class="container">
			<h1 class="page-title">Search Jobs</h1>
		</div>
	</header>

	<div class="finder">
		<div class="container">
			<cfoutput>
			<form method="get" action="/search" class="form finder-form clearfix row-fluid keep-fluid">
				<div class="finder-form-wrap">
					<cfparam name="session.exec.queryParams.title" default="">
					<cfparam name="titleSkillSearch"  default="">
					
					<cfparam name="skillSearchTerm"  default="">
					<cfparam name="titleSearchTerm"  default="">
					
					<cfparam name="session.exec.queryparams.loc" default="">
					<cfparam name="locationSearch"  default="">
					
					<!---Skill Search--->
					<cfif isDefined("session.exec.queryParams.q") and len(session.exec.queryParams.q) >
					 	<cfset titleSkillSearch = session.exec.queryParams.q>
						<cfset session.exec.queryParams.title = "">
						<cfset skillSearchTerm = titleSkillSearch>
					<!---Job Title Search --->
					<cfelseif isDefined("session.exec.queryParams.title") and len(session.exec.queryParams.title)>
						<cfset titleSkillSearch = session.exec.queryParams.title>
						<cfset titleSearchTerm = titleSkillSearch>
					<cfelseif len(request.strTitle) and session.exec.queryParams.q is "">
						<cfset session.exec.queryParams.title = request.strTitle>
						<cfset titleSkillSearch = request.strTitle>
						<cfset titleSearchTerm = titleSkillSearch>
					</cfif>
					
					<!---location --->
					<cfif len(request.strLocation) and request.strLocation neq "Any Location">
						<cfset session.exec.queryparams.loc = request.strlocation>
						<cfset locationSearch = session.exec.queryparams.loc>
					<cfelseif isDefined("session.exec.queryparams.loc") and len(session.exec.queryparams.loc)>
						<cfset locationSearch = session.exec.queryparams.loc>
					</cfif>
					
					<div class="input-group-jobtitle">
						<input type="text" placeholder="Find by title or skills&hellip;" name="strTitle" class="job-title input input-large" <cfif titleSkillSearch neq "Any Job Title" and titleSkillSearch neq "Any Skills"> value="#titleSkillSearch#" </cfif> >
						<div class="btn-group-jobtitle">
							
							<cfif isDefined("session.exec.queryParams.q") and len(session.exec.queryParams.q)>
								<button class="btn btn-primary btn-small btn-dropdown-jobtitle" type="button" data-toggle="dropdown">
								By Skills
								<span class="caret"></span>
								</button>
							<cfelse>
								<button class="btn btn-primary btn-small btn-dropdown-jobtitle" type="button" data-toggle="dropdown">
								By Title
								<span class="caret"></span>
								</button>
							</cfif>
							
							<ul class="dropdown-menu">
								<li><a href="##" class="searchByLnk" data-fldname="strTitle">By Title</a></li>
								<li><a href="##" class="searchByLnk" data-fldname="strSkills">By Skills</a></li>
							</ul>
													
						</div>
					</div>
					
					<input type="text" placeholder="Location (optional)" name="strLocation" id="job-location" class="job-location input input-large" <cfif locationSearch neq "Any Location"> value="#locationSearch#" </cfif> >
					<button type="submit" class="btn btn-primary btn-large btn-search">Search</button>
					<button type="button" class="btn btn-link btn-cancel"><span class="icn icn-cancel"></span></button>
				</div>
			</form>
			</cfoutput>
		</div><!--/.container-->
	</div><!--/.finder-->

	<div class="results section">
		<div class="container">
			<div class="row-fluid">
				<div class="results-list span8">
					
					<cfset numJobsFound=results[1].XmlAttributes['numFound']>
					
					<header class="header visible-desktop row-fluid">
						<h2 class="results-list-title span5">Results (<cfoutput>#NumberFormat(numJobsFound, "," )#</cfoutput>)</h2>
					
						
						<div class="span7">
						<cfif isdefined("session.exec.blnValidLogin") and isdefined("session.exec.intResID") and session.exec.blnValidLogin>
							 <cfset intResID = session.exec.intResID>
								<cfquery name="cfqAgent" datasource="#application.dsn#" maxrows="3">
								select strTitle,blnEmailAgent,blnweekly
								from tblSearchAgent (NOLOCK)
								where intresid=#intResID#
								order by dteCreated
								</cfquery>
							<cfif cfqAgent.RecordCount lt 3>
								 <cfoutput>
									<a href="/member-job-alerts?100k=1&strMode=new&am=25&tm=30&strSkills=#skillSearchTerm#&strTitle=#titleSearchTerm#&strLocation=#locationSearch#">
									<button class="btn btn-primary btn-min btn-block">Save Search as Job Alert</button>
									</a>
								</cfoutput>
							</cfif>
						<cfelse>
							<button class="btn btn-primary btn-min btn-block" data-toggle="popover" data-content="#subscribe-popover" data-container="#results-subscribe" data-title="You need to be a member to use this feature">Subscribe to this search and receive alerts</button>
							<div class="hide" id="subscribe-popover">
								<strong><a href="/join">Join Free</a></strong>
								<a href="#signin" data-toggle="modal" class="signin-link">Sign in</a>
							</div>
							<div class="subscribe subscribe-popover" id="results-subscribe"></div>
						</div>
						</cfif>
					</header>
					
					<!---------------------------------------------------------------->
					<!--- Start: Get the EmployerId for the StartDate Labs/AppCast --->
					<!---------------------------------------------------------------->
					<cfset intAppCastLabsEmpID = "0">
					<cfquery name="cfqGetEmployerID" datasource="#application.dsn#">
					select intEmployerID from tblEmployers (nolock) where strcompany = 'StartDate Labs'
					</cfquery>
					
					<cfif len(cfqGetEmployerID.intEmployerID)>
						<cfset intAppCastLabsEmpID = cfqGetEmployerID.intEmployerID>
					</cfif>
					<!---------------------------------------------------------------->
					<!---  End: Get the EmployerId for the StartDate Labs/AppCast  --->
					<!---------------------------------------------------------------->
					
<!--- ---------------------------------------------- start results ---------------------------------------- --->
					<cfoutput>
					<ul>
						<cfloop index="i" from="1" to="#arraylen(results[1].XmlChildren)#" >

						    <cfset vanityURL = xmlSearch(result,"/response/result/doc[#i#]/str[@name='seoJobURL']") />
							<cfif isArray(vanityURL) AND arrayLen(vanityURL)>
								<cfset seoJobURL = vanityURL[1].xmltext>
							<cfelse>
								<cfset seoJobURL = "" />
							</cfif>

							<!--- only display if the SEO job url is set --->
							<cfif len(seoJobURL)>

								<cfset doc = results[1]["doc"][i] />
								<cfset id = xmlSearch(result,"/response/result/doc[#i#]/str[@name='intJobID']") />
								
								<cfset empid = xmlSearch(result,"/response/result/doc[#i#]/str[@name='intEmployerID']") />
								<cfset intJobPostingEmpID = empid[1].xmltext />
								
								<cfset employer = xmlSearch(result,"/response/result/doc[#i#]/str[@name='jpname']") />
								<!---><cfset url = xmlSearch(result,"/response/result/doc[#i#]/str[@name='strJobURL']") />--->

								<!---><cfset postedDate = xmlSearch(result,"/response/result/doc[#i#]/date[@name='date_submitted']") />--->
								<cfset state = xmlSearch(result,"/response/result/doc[#i#]/str[@name='strName']") />
								<!---><cfset opportunity = xmlSearch(result,"/response/result/doc[#i#]/str[@name='strOpportunity']") />--->
								<cfset location = xmlSearch(result,"/response/result/doc[#i#]/str[@name='location']") />
								<cfset salary = xmlSearch(result,"/response/result/doc[#i#]/str[@name='fltSalary_desiredLow']") />

								<cfset title = xmlSearch(result,"/response/result/doc[#i#]/str[@name='title']") />
							    <cfset title_hl = xmlSearch(result,"/response/lst[@name='highlighting']/lst[@name='#id[1].XmlText#']/arr[@name='title']/str") />

								<cfset titleText = ""/>
								<cfif arrayLen(title_hl) gt 0>
									<cfset titleText = "#title_hl[1]#"/>
								<cfelseif arrayLen(title) gt 0>
									<cfset titleText = "#title[1]#"/>
								<cfelse>
									<cfset titleText = "Job Title not Defined"/>
								</cfif>

								<li class="result row-fluid">
									<a href="#seoJobURL#" class="clearfix">
										<!--->
                                        <div class="span2">
											<img src="http://placehold.it/80x47/f6f6f3/cccccc" alt="Job image" class="image hidden-phone">
										</div>
                                        --->
										<div class="result-info span8">
											<h3 class="result-title">#titleText#</h3>
											<p class="result-company"><cfif arrayLen(employer)>#employer[1]#<cfelse> Employer not defined</cfif> &ndash; <cfif arrayLen(location)>#REReplace( location[1].xmltext , "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" )# </cfif>, <cfif arrayLen(state)>#state[1].xmltext#</cfif></p>
										</div>
																				
										<!--- Show the salary information only if the Job is not posted by StartDate Labs / AppCast --->					
										<cfif intJobPostingEmpID eq intAppCastLabsEmpID>
										<strong class="result-salary span2"><em>TBD</em></strong>
										<cfelse>
										<strong class="result-salary span2">$#salary[1].xmltext#,000 <em>min salary</em></strong>
										</cfif>
									</a>
								</li>

							</cfif>
						</cfloop>
					</ul>
					</cfoutput>
<!--- ---------------------------------------------- end results ---------------------------------------- --->

					<cfif results[1].XmlAttributes['numFound'] GT jobsPerPage>
						<cfparam name="startPage" default="1">
						<cfparam name="currentPage" default="1">
						<cfparam name="endPage" default="1">
						<cfparam name="pgNo" default="1">
						<cfparam name="noOfPages" default="1">
						<cfparam name="next" default="0">
						<cfparam name="prevPage" default="1">
						<cfparam name="nextPage" default="1">
						
						<cfoutput>
						<div class="pagination">
							<ul>
								<cfset noOfPages = ceiling(results[1].XmlAttributes['numFound']/jobsPerPage) />
								<cfif isDefined("url.pgNo") and url.pgNo neq "">
									<cfset pgNo=url.pgNo />
								</cfif>
								
								<cfif pgNo eq 1 or noOfPages eq 1>
									<li class="disabled"><a href="##">Previous</a></li>
								<cfelse>
									<cfset prevPage=pgNo-1 />
									<cfif prevPage is 1>
										<cfset next=0 />
									<cfelse>
										<cfset next=prevPage*jobsPerPage />
									</cfif>
									<li><a href="/jobs/?start1=#next#&pgNo=#prevPage#">Previous</a></li>
								</cfif>
								
								<cfif noOfPages GT 7>
									<cfif pgNo LTE 3>
										<cfset startPage = 1 />
										<cfset currentPage = pgNo />
										<cfset endPage = 7 />
									<cfelseif pgNo GT 3 and pgNo LT (noOfPages-5)>
										<cfset startPage = pgNo - 2 />
										<cfset currentPage = pgNo />
										<cfset endPage = pgNo+2 />
									<cfelse>
										<cfset startPage = noOfPages - 5 />
										<cfset currentPage = pgNo />
										<cfset endPage = noOfPages />
									</cfif>
								<cfelse>
									<cfset startPage = 1 />
									<cfset currentPage = pgNo />
									<cfset endPage = noOfPages />
								</cfif>
								
								<cfloop from="#startpage#" to="#endpage#" index="thisPage">
									<cfif thisPage is 1>
										<cfset next=0 />
									<cfelse>
										<cfset next=(thisPage-1)*jobsPerPage />
									</cfif>
									<cfif pgNo EQ thisPage>
										<li class="active"><a href="##">#thispage#</a></li>
										<cfset session.exec.backtoJobsLink = "" />
										<cfif isDefined("url.start")>
											<cfset session.exec.backtoJobsLink = session.exec.backtoJobsLink & "&start=#url.start#&pgNo=#currentpage#&jobtitlesearch=#request.jobtitlesearch#" />
										<cfelse>
											<cfset session.exec.backtoJobsLink = session.exec.backtoJobsLink & "&start=0&pgNo=#currentpage#&jobtitlesearch=#request.jobtitlesearch#" />
										</cfif>
									<cfelse>
										<li><a href="/jobs/?start1=#next#&pgNo=#thisPage#">#thispage#</a></li>
									</cfif>
								</cfloop>
								
								<cfif pgNo lt noOfPages>
									<cfset nextPage = pgNo+1 />
									<cfset next=(nextPage-1)*jobsPerPage />
									<li><a href="/jobs/?start1=#next#&pgNo=#nextPage#">Next</a></li>
								<cfelse>
									<li class="disabled"><a href="##">Next</a></li>
								</cfif>
							
							</ul>
							<div class="row-fluid">
								<p class="pagination-label span8 offset2">Page #pgNo# of #noOfPages#</p>
							</div>
						</div>
						</cfoutput>						
					</cfif>
					
				</div><!--/.results-list-->

				<div class="results-refine refine span4 visible-desktop" id="results-refine">
					<h3>Refine your search</h3>
					<cfoutput>#request.theSearchFilters#</cfoutput>
				</div><!--/.results-refine-->
				
			</div>
		</div>
	</div>
</div>
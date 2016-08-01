<cfparam name="request.theJoinFrm" default="">

<header class="hero-unit">
	
	<div class="container">
		
		<div class="row-fluid">
			
			<div class="span7">
				<!--- <h2>Search &amp; Apply to $100K+ Jobs</h2> --->
				<h2>$100K+ Jobs...<br>Search &amp; Apply for Free.</h2>
				<!--- <p class="lead2">Join an exclusive and private community of top-earning senior-level professionals &amp; executives. </p> --->
				<p class="lead2">Complete our form to join an exclusive and private community of top-earning senior-level professionals &amp; executives.</p>
				<div class="row-fluid">
					<ul class="has-gray-bullet span11">
						<li>Pre-screened $100K+ job opportunites across all industries.</li>
						<li>Exceptional Companies. Exceptional Talent.</li>
						<li>Where leading companies &amp; recruiters recruit top talent.</li>
						<li>No communication barriers (connect with recruiters faster).</li>
						
					</ul>
				</div>
				
			</div>
			
			<div class="span4 offset1 offset14 row-fluid">
				<cfoutput>#request.theJoinFrm#</cfoutput>
			</div>
			
		</div>
		
	</div>
	
</header><!--/.hero-unit-->


<div class="section featured" id="featured">
	<div class="container">
		<div class="row-fluid">
			<div class="span6">
				<h2>Featured company of the week</h2>
				<cfoutput>
				<p class="featured-company pull-left"><a href="/company/#request.company.getSeoStrCompany()#"><img src="#application.v1URL#/images/#request.company.getStrHomePgFeatureLogo()#" alt="#request.company.getStrHomePgFeatureLogoAltTag()#"></a></p>
				<p>#request.company.getStrSummary()#</p>
				<p class="featured-links"><a href="/company/#request.company.getSeoStrCompany()#">Learn more</a> <a href="/company/#request.company.getSeoStrCompany()#">View job openings</a></p>
				</cfoutput>
			</div>
			<div class="span6">
				<div class="row-fluid">
					<h2 class="span12 offset1">6FigureJobs stats</h2>
				</div>
				<ul class="bythenumbers">
					<li class="row-fluid keep-fluid">
						<strong class="span4">1999</strong>
						<span class="span8">year established</span>
					</li>
					<li class="row-fluid keep-fluid">
						<strong class="span4"><cfoutput>#NumberFormat( request.qry_activemembers, "," )#</cfoutput></strong>
						<span class="span8">active community members</span>
					</li>
					<li class="row-fluid keep-fluid">
						<strong class="span4"><cfoutput>$#NumberFormat(request.getAverageJobSalary)#K</cfoutput></strong>
						<span class="span8">average salary of current jobs</span>
					</li>
					<li class="row-fluid keep-fluid">
						<strong class="span4">53%</strong>
						<span class="span8">management positions <br><small>(manager, director, vp, svp, cxo)</small></span>
					</li>
				</ul>
				<div class="row-fluid">
					<p class="span12 offset1">And thousands of success stories!</p>
				</div>
				
			</div>
			
		</div>
	</div>
</div>

<div class="section well">
	
	<div class="container">
		<h1 class="page-title">$100K+ Jobs for Top Tier Talent</h1>
		<p class="lead">Exceptional Companies. Exceptional Talent.</p>
		<form class="form finder-form clearfix" action="search" method="get">
			<div class="input-group-jobtitle">
				<input type="text" placeholder="Find by title or skill&hellip;" name="strTitle" class="job-title input input-large">
				<div class="btn-group-jobtitle">
					<button class="btn btn-primary btn-small btn-dropdown-jobtitle" type="button" data-toggle="dropdown">
						By Title
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						<li><a href="#" class="searchByLnk" data-fldname="strTitle">By Title</a></li>
						<li><a href="#" class="searchByLnk" data-fldname="strSkills">By Skills</a></li>
					</ul>
				</div>
			</div>
			<input type="text" placeholder="Location (optional)" name="strLocation" id="job-location" class="job-location input input-large">
			<button class="btn btn-primary btn-large btn-search">Search jobs</button>
		</form>
		<p><strong>Some best-in-class companies hiring right now</strong></p>
		<p>
			<cfset request.cpages = ceiling(arrayLen(request.ary_companies)/4)-1 />
			
			<div id="bestInClassCarousel" class="carousel slide">
			
				<cfoutput>
				<div class="carousel-inner">
					<cfloop index="request.p" from="0" to="#request.cpages#">
						<div class="<cfif request.p EQ 0>active</cfif> item">
							<cfset request.p = request.p+1 />
							<cfset request.cstart = (request.p*4)-3 />
							<cfset request.cend = request.cstart+3 />
							<cfif request.cend GT arrayLen(request.ary_companies)>
								<cfset request.cend = arrayLen(request.ary_companies) />
							</cfif>
							<cfloop index="request.c" from="#request.cstart#" to="#request.cend#">
								<a href="/company/#request.ary_companies[request.c].getSeoStrCompany()#">
									<img src="#application.v1URL#/images/#request.ary_companies[request.c].getStrHomePgSliderLogo()#" alt="#request.ary_companies[request.c].getStrHomePgSliderLogoAltTag()#" class="image whiteLogo">
								</a>
							</cfloop>
						</div>
					</cfloop>
				</div>
				</cfoutput>

			</div>
			
		</p>
	</div><!--/.container-->
	
</div>
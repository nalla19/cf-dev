<div class="page-company">


	<header class="page-header">
		<div class="container">
			<a href="companies.html" class="back">Companies &raquo;</a>
			<a href="#"><img src="http://placehold.it/904x161/f6f6f3/cccccc" alt="Company image" class="image"></a>
			<div class="row-fluid">
				<a class="span2" href="#"><img src="http://placehold.it/114x62/f6f6f3/cccccc" alt="Company image" class="image"></a>
				<h1 class="span10 page-title">
					The Albrecht Group
					<em>Charlotte, North Carolina</em>
				</h1>
			</div>
			<p>Imagine no more job searches. Imagine this as the last job search you will ever make. Because, an inspiring combination of growth prospects, continuous innovation, fair play and a great work culture makes Wipro an exhilarating place to be in. Wipro is a place you'll want to come back to each morning for the rest of your life, with a sense of achievement and a smile of job satisfaction. Indeed, it is the smartest career move you could ever make, because Wipro careers are for life.</p>
			<div class="stayintouch">
				<a class="facebook" href="#"><img src="assets/img/stayintouch.png" alt="Facebook icon"></a>
				<a class="twitter"  href="#"><img src="assets/img/stayintouch.png" alt="Twitter  icon"></a>
				<a class="linkedin" href="#"><img src="assets/img/stayintouch.png" alt="Linkedin icon"></a>

	<cfoutput>
	<header class="page-header">
		<div class="container">
			<a href="/companies" class="back">Companies &raquo;</a>
			<cfif len(request.company.getStrProfilePgLogo())>
				<a href="##"><img src="#application.v1URL#/images/#request.company.getStrProfilePgLogo()#" alt="#request.company.getStrProfilePgLogoAltTag()#" class="image companyBanner"></a>
			</cfif>
			<div class="row-fluid">
				<cfif len(request.company.getStrMasterLogo())>
					<a class="span2" href="##">
						<img src="#application.v1URL#/images/#request.company.getStrMasterLogo()#" alt="#request.company.getStrMasterLogoAltTag()#" class="image">
					</a>
				</cfif>
				<cfif len(request.company.getStrProfilePgTrackURL())>
					#request.company.getStrProfilePgTrackURL()#
				</cfif>
				<h1 class="span10 page-title">
					#request.company.getStrCoName()#
					<em>#request.company.getStrCity()#, #request.company.getStrState()#</em>
				</h1>
			</div>
			<p>#request.company.getStrSummary()#</p>
			<div class="stayintouch">
				<cfif len(request.company.getStrFacebookLink())>
					<a class="facebook" href="#request.company.getStrFacebookLink()#"><img src="/img/stayintouch.png" alt="Facebook icon"></a>
				</cfif>
				<cfif len(request.company.getStrTwitterLink())>
					<a class="twitter"  href="#request.company.getStrTwitterLink()#"><img src="/img/stayintouch.png" alt="Twitter  icon"></a>
				</cfif>
				<cfif len(request.company.getStrLinkedInLink())>
					<a class="linkedin" href="#request.company.getStrLinkedInLink()#"><img src="/img/stayintouch.png" alt="Linkedin icon"></a>
				</cfif>
>>>>>>> c6c06d6dc3800a06e084ef03a407d8e9a398e7de
			</div>
		</div>
	</header>
	
	<article class="section opportunities well">
		<div class="container">
			<div class="row-fluid content">
				<div class="span6">
<<<<<<< HEAD
					<h2>Opportunities</h2>	
					<p>At Wipro we provide the best opportunity to build a flying career with ‘Wings Within', a transparent job posting system. It is a tool that gives flexibility to apply for the job of your choice and map your career. All open positions are visible to employees encouraging the eligible to look for a job change within Wipro.</p>
					<p>Wipro offers you career opportunities in core business divisions such as Enterprise Solutions, Finance Solutions, Product Engineering Solutions, and Technology Services. And, in Technology Services, there are stimulating jobs in E-Enabling, ES-eEnabling, Enterprise Application Services, Technology Infrastructure Services and Testing Services.</p>
					<h2>Benefits & Growth Prospects</h2>
					<p>Wipro offers challenging assignments, world-class working environment, professional management and ample opportunities to train, learn, and execute the most demanding projects, and in turn, get recognition in the form of exceptional rewards. As you scale newer peaks of achievements, we provide you with many benefits. At every step of success there is a special incentive awaiting you.</p>
					<p>Our responsibility towards new employees does not stop at salaries and compensation alone. We offer all possible help to facilitate their settling down. We provide interest-free loan mainly intended to cover housing deposits or the purchase of a two wheeler. We also provide contingency loans for marriage, illness, or death of a close family member.</p>
					<p>As a part of employee empowerment, we offer stock options to deserving employees. The Wipro Employee Stock Option Plan (WESOP) allows us to make employees share with us the rewards of success.</p>
				</div>
				<div class="span6">
					<p><a href="#" class="video"><img src="assets/img/videothumbnail.jpg" alt="Video"></a></p>
					<h2>Perks</h2>
					<p>Dummy settings which use other languages or even gibberish to approximate text have the inherent disadvantage that they distract attention.</p>
					<ul>
						<li>This is dummy text for the first perks</li>
						<li>This is the second perk listed</li>
						<li>This is for the third perk</li>
						<li>Listing for the fourth perk</li>
					</ul>
				</div>
			</div>
			<div class="results-list">
				<h2 class="results-list-title">Openings <em>(2)</em></h2>
				<ul>
					<li class="result row-fluid"><a href="listing.html" class="clearfix">
						<div class="span2">
							<img src="http://placehold.it/68x35/f6f6f3/cccccc" alt="Job image" class="image hidden-phone">
						</div>
						<div class="result-info span8">
							<h4 class="result-title">Design Engineer</h4>
							<p class="result-company">The Albrecht Group &ndash; CHARLOTTE, North Carolina</p>
						</div>
						<strong class="result-salary span2">$100,000 <em>min salary</em></strong>
					</a></li>
				</ul>
			</div>
		</div>
	</article>

					<cfif len(request.company.getStrOpportunities())>
						<h2>Opportunities</h2>
						<p>#REReplace(request.company.getStrOpportunities(), chr(10), "<br />", "all")#</p>
					</cfif>
					<cfif len(request.company.getStrBenfGrowthPros())>
						<h2>Our Culture</h2>
						<p>#REReplace(request.company.getStrBenfGrowthPros(), chr(10), "<br />", "all")#</p>
					</cfif>
				</div>
				<div class="span6">
					<!---><p><a href="##"><img src="http://placehold.it/442x206/f6f6f3/cccccc" alt="Video" class="image"></a></p>--->
					<cfif len(request.company.getStrCorporateVideo())>
						<p>#request.company.getStrCorporateVideo()#</p>
					</cfif>
					<cfif len(request.company.getStrPerks())>
						<h2>Perks</h2>
						<p>#request.company.getStrPerks()#</p>
					</cfif>
				</div>
			</div>
			
			<cfparam name="request.start" default="1">
			<cfset request.perPage = 8 />
			<cfset request.totalPages = Ceiling(arrayLen(request.ary_jobs)/request.perPage) />
			<cfset request.end = request.start+request.perPage-1>
			<cfif request.end GT arrayLen(request.ary_jobs)>
				<cfset request.end = arrayLen(request.ary_jobs) />
			</cfif>
			<cfset request.prevLink = request.start-request.perPage />
			<cfset request.nextLink = request.end+1 />
			
			<cfif request.start GT 1>
				<cfset request.pageStart = Ceiling(request.start/request.perPage) />
			<cfelse>
				<cfset request.pageStart = 1 />
			</cfif>
			
			<cfset request.pageEnd = request.pageStart + 5 />
			<cfif request.pageEnd GTE request.totalPages>
				<cfset request.pageEnd = request.totalPages />
			</cfif>

			<div class="results-list">
				<h2 class="results-list-title">Openings <em>(#arrayLen(request.ary_jobs)#)</em></h2>
				<ul>
					<cfloop index="request.j" from="#request.start#" to="#request.end#">
						<li class="result row-fluid">
							<a href="#request.ary_jobs[request.j].getSeoJobUrl()#" class="clearfix">
								<!---><div class="span2">
									<img src="http://placehold.it/68x35/f6f6f3/cccccc" alt="Job image" class="image hidden-phone">
									<img src="#application.v1URL#/images/featured/#request.company.getImgLogo()#" alt="Job image" class="image hidden-phone">
								</div>--->
								<div class="result-info span10">
									<h4 class="result-title">#request.ary_jobs[request.j].getTitle()#</h4>
									<p class="result-company">#request.ary_jobs[request.j].getJpname()# &ndash; #request.ary_jobs[request.j].getLocation()#, #request.ary_jobs[request.j].getState()#</p>
								</div>
								<strong class="result-salary span2">$#numberformat("#request.ary_jobs[request.j].getFltSalary_DesiredLow()#000",",")# <em>min salary</em></strong>
							</a>
						</li>
					</cfloop>
				</ul>
				
				<div class="pagination">
					<ul class="pagination-numeric hidden-phone hidden-tablet">
						<cfif request.start EQ 1>
							<li class="disabled"><span>Prev</span></li>
						<cfelse>
							<li><a href="?start=#request.prevLink#">Prev</a></li>
						</cfif>
						<cfloop index="request.p" from="#request.pageStart#" to="#request.pageEnd#">
							<cfset request.pageLink = request.p*request.perPage-request.perPage+1 />
							<li <cfif request.start EQ request.pageLink>class="active"</cfif>><a href="?start=#request.pageLink#">#request.p#</a></li>
						</cfloop>
						<cfif (request.start+request.perPage-1) GTE arrayLen(request.ary_jobs)>
							<li class="disabled"><span>Next</span></li>
						<cfelse>
							<li><a href="?start=#request.nextLink#">Next</a></li>
						</cfif>
					</ul>
					
					<ul class="pagination-dual hidden-desktop row-fluid">
						<cfif request.start EQ 1>
							<li class="disabled prev span4"><span>Previous Page</span></li>
						<cfelse>
							<li class="active prev span4"><a href="?start=#request.prevLink#">Previous Page</a></li>
						</cfif>
						
						<cfif (request.start+request.perPage-1) GTE arrayLen(request.ary_jobs)>
							<li class="disabled next span8"><span>Next Page</span></li>
						<cfelse>
							<li class="next span8"><a href="?start=#request.nextLink#">Next Page</a></li>
						</cfif>
					</ul>
					
					<div class="row-fluid">
						<p class="pagination-label span12 text-center">Page #request.pageStart# of #request.totalPages#</p>
					</div>
				</div>
				
				
			</div>
			
		</div>
	</article>
	</cfoutput>
	

</div>
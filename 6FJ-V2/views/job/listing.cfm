<cfparam name="request.strActionFile" default="home">
<cfparam name="request.jobpostempid" default="0">
<cfparam name="request.appcastempid" default="1">

<!---Set the Job Posting Employer ID--->
<cfset request.jobpostempid = request.job.getIntEmployerId()>

<!--- Set the AppCast ID--->
<cfquery name="request.appcastempid" datasource="#application.dsn#">
select intEmployerID from tblEmployers (nolock) where strcompany = 'StartDate Labs'
</cfquery>
<cfif len(request.appcastempid.intEmployerID)>
	<cfset request.appcastempid = request.appcastempid.intEmployerID>
</cfif>

<cfoutput>
<div class="page-listing" id="page-listing">

	<header class="page-header">
		<div class="container">
			<div class="row-fluid">
				<div class="span7">
					<a href="#request.strActionFile#" class="back">Search jobs &raquo;</a>
					<h1 class="page-title">
						#request.job.getTitle()#
						<em>&##64; 
                        <!--->Not Every Company is a featured company --->
						<cfif len(request.company.getSeoStrCompany())>
                        <a href="/company/#request.company.getSeoStrCompany()#">#request.company.getStrCoName()#</a>
                        <cfelse>
                        #request.job.getJpname()#
                        </cfif>
                        </em>
						
						<cfif len(request.company.getStrJobDetPgTrackURL())>
						#request.company.getStrJobDetPgTrackURL()#
						</cfif>
					</h1>
					<dl class="categories clearfix">
						<dt>Industries:</dt>
							<dd>
								<cfset request.qry_jobIndustries = request.job.getJobIndustries() />
								#valueList(request.qry_jobIndustries.strIndName,", ")#
							</dd>
						<dt>Functions:</dt>
							<dd>
								<cfset request.qry_jobFunctions = request.job.getJobFunctions() />
								#valueList(request.qry_jobFunctions.strFunctionName,", ")#
							</dd>
						<dt>Type:</dt>
							<dd>#request.job.getStrOpportunity()#</dd>
						<dt>Location:</dt>
							<dd>#request.job.getLocation()#, #request.job.getState()#</dd>
					</dl>
				</div>
				<div class="span5">
					<!--- Show the salary information only if the Job is not posted by StartDate Labs / AppCast --->
					<cfif request.jobpostempid neq request.appcastempid>
						<strong class="result-salary">$#numberformat("#request.job.getFltSalary_DesiredLow()#000",",")# <em>minimum salary</em></strong>
					<cfelse>
						<strong class="result-salary"></strong>
					</cfif>
					
					<ul class="share">
						<li class="facebook">
							<a name="fb_share" type="button" share_url="" href="http://www.facebook.com/sharer.php?u=#request.job.getSeoJobUrl()#&amp;src=sp">Share</a>
						</li>
						<li class="twitter">
							<a href="https://twitter.com/share" class="twitter-share-button" data-via="6FigureJobs" data-related="6FigureJobs" data-count="none">Tweet</a> 
						</li>
						<li class="googleplus">
							<div class="g-plus" data-action="share" data-annotation="none"></div>
						</li>
						<li class="linkedin">
							<script type="IN/Share"></script>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</header>
	
	<article class="section opportunity well">
		<div class="container">
		
			<div class="row-fluid">
			
				<div class="span8 content">
					<h2>Opportunity Detail</h2>
					<!---><div>#paragraphFormat(request.job.getDescription())#</div> --->
                    
                    <cfset jobDescription=REReplace(request.job.getDescription(), chr(10), "<br>", "ALL")>
                    <cfset jobDescription=REReplace(jobDescription, "<SPAN(?=[^>]+?STYLE).+?>", "", "ALL")>
                    <cfset jobDescription=REReplace(jobDescription, "<span(?=[^>]+?style).+?>", "", "ALL")>
                    <div>#paragraphFormat(jobDescription)#</div>
					
						
						<cfif isdefined("session.exec.blnValidLogin") and session.exec.blnValidLogin eq 1>
							<a class="btn btn-primary btn-medium" role="button" href="/job-apply?#application.strAppAddToken#&intJobID=#request.intJobId#">Apply for this job</a>				
						<cfelse>
						<div class="apply well">
							<h3>How to apply</h3>
							<p>In order to view the contact details for this job, you need to be a member. Membership is FREE! It takes less than a minute.</p>
								<a class="btn btn-primary btn-medium" role="button" data-toggle="popover" data-content="##subscribe-popover" data-container="##results-subscribe" data-title="You need to be a member to apply">Apply for this job</a>
							<div class="hide" id="subscribe-popover">
								<strong><a href="/join?Pf9ZL4URh=#request.intJobId#">Join Free</a></strong>
								<a href="##signin" data-toggle="modal" class="signin-link" >Sign in</a>
							</div>
							<div class="subscribe subscribe-popover" id="results-subscribe"></div>
							
						
						</div>
						</cfif>
					
										
					<aside class="share">
						<h3>Not the perfect job for you? Share it with a friend.</h3>
						<ul>
							<li class="facebook">
								<a name="fb_share" type="button" share_url="" href="http://www.facebook.com/sharer.php?u={INSERTENCODEDURLHERE}&amp;src=sp">Share</a>
							</li>
							<li class="twitter">
								<a href="https://twitter.com/share" class="twitter-share-button" data-via="6FigureJobs" data-related="6FigureJobs" data-count="none">Tweet</a> 
							</li>
							<li class="googleplus">
								<div class="g-plus" data-action="share" data-annotation="none"></div>
							</li>
							<li class="linkedin">
								<script type="IN/Share"></script>
							</li>
						</ul>
					</aside>
					
					<!--->
					<div class="results-list">
						<h3 class="results-list-title">Similar jobs</h3>
						<ul>
							<li class="result row-fluid"><a href="listing" class="clearfix">
								<img src="http://placehold.it/68x35/f6f6f3/cccccc" alt="Job image" class="image hidden-phone span2">
								<div class="result-info span8">
									<h4 class="result-title">Design Engineer</h4>
									<p class="result-company">The Albrecht Group &ndash; CHARLOTTE, North Carolina</p>
								</div>
								<strong class="result-salary span2">$100,000 <em>min salary</em></strong>
							</a></li>
						</ul>
					</div>
					--->
					
				</div>
				
				<div class="span4 sidebar">
					<!--->
					<h3>About <a href="/company/#request.company.getSeoStrCompany()#">#request.company.getStrCoName()#</a></h3>
					<cfif len(request.company.getStrCorporateVideo())>
						<p>#request.company.getStrCorporateVideoSmall()#</p>
					</cfif>
					<p>#request.company.getStrOpportunities()#</p>
					<p><a href="/company/#request.company.getSeoStrCompany()#">Read more</a></p>
					--->
					
					<cfif len(#request.job.getStrMasterLogo()#)>
						<img src="#application.v1URL#/images/#request.job.getStrMasterLogo()#" alt="#request.job.getStrMasterLogoAltTag()#" class="image">
					</cfif>
					
					<cfif len(#request.job.getStrAboutCompany()#)>
						<h3>About Company</h3>
						<p>#request.job.getStrAboutCompany()#</p>
					</cfif>
					
					<cfif len(#request.job.getStrCompanyPerks()#)>
						<h3>Perks</h3>
						<p>#request.job.getStrCompanyPerks()#</p>
					</cfif>
				</div>
				
			</div>
			
		</div>
	</article>
	
</div><!--/.wrap-->

</cfoutput>

<!-- update job detail counter -->
<cfstoredproc procedure="sp_UpdtJobDetCnt" datasource="#application.dsn#" returncode="No">
	<cfprocparam type="IN" dbvarname="@intJobID" value="#val(request.intJobId)#" cfsqltype="CF_SQL_INTEGER">
</cfstoredproc>

<!-- Facebook button -->
<script src="http://static.ak.fbcdn.net/connect.php/js/FB.Share" type="text/javascript"></script>
<!-- Twitter button -->
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
<!-- Google+ button -->
<script type="text/javascript">
(function() {
	var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
	po.src = 'https://apis.google.com/js/plusone.js';
	var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
})();
</script>
<!-- LinkedIn button -->
<script src="//platform.linkedin.com/in.js" type="text/javascript">lang: en_US</script>
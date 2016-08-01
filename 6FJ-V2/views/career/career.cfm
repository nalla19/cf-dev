<cfparam name="request.theJoinFrm" default="">

<div class="page-career">
	<header class="page-header">
		<div class="container">
			<h1 class="page-title">Career</h1>
			<p class="page-subtitle">Resources and opportunities to support your professional development.</p>
		</div>
	</header>
	
	<div class="section careerlinks">
		<div class="container">
			<div class="row-fluid">
				<div class="span4 careerlink">
					<h2>Entrepreneur Opportunities</h2>
					<p>Tired of climbing the corporate ladder? Looking for an alternative career path that is lucrative? Visit our Entrepreneur channel regularly and request free information for the following opportunities.</p>
					<a class="btn btn-primary btn-small" href="entrepreneur">View opportunities</a>
				</div>
				<div class="span4 careerlink">
					<h2>Continuing Education</h2>
					<p>Now may be a good time to pursue that six-sigma or project management certificate you’ve been contemplating. Check our education channel often to learn about continuing education programs.</p>
					<a class="btn btn-primary btn-small" href="education">View resources</a>
				</div>
				<div class="span4">
					<!--->
					<h2>Subscribe to the newsletter</h2>
					<p>Our FREE Weekly Newsletter is a mashup that provides insightful career advice, spotlight job opportunities, and featured hiring companies.</p>
					<div class="subscribe">
						<div class="input-append">
							<input type="text" class="input input-small input-block" placeholder="Your e-mail">
							<button class="btn btn-primary btn-small">OK</button>
						</div>
					</div>--->
					<div class="careerlink">
						<h2>Visit our blog</h2>
						<p>Get expert career advice from executive career advisors on topics like: dealing with age discrimination, resume writing, salary negotiation, professional networking, interview strategies, and personal branding.</p>
						<a class="btn btn-primary btn-small" href="http://blog.6figurejobs.com">View blog</a>
					</div>
				</div>
			</div>
		</div>
	</div><!--/.links-->
	<cfif not isdefined("session.exec.blnValidLogin")>
	<div class="section well join" id="join">
		<div class="container">
			<div class="row-fluid">
				<div class="span7">
					<h2>Search & Apply for Jobs for FREE</h2>
					<p class="lead">Join an exclusive and private community of top-earning senior-level professionals & executives. </p>
					<div class="row-fluid">
						<ul class="has-gray-bullet span11">
							<li>Pre-screened $100K+ job opportunities across all industries.</li>
							<li>No communication barriers (connect with recruiters faster).</li>
							<li>Leading companies and recruiters use 6FigureJobs to recruit top talent.</li>
						</ul>
					</div>
					<p><a href="/join">Learn more</a></p>
				</div>
				
					<div class="span4 offset1 row-fluid">
						<cfoutput>#request.theJoinFrm#</cfoutput>
					</div>
				
			</div>
		</div>
	</div><!--/.join-->
	</cfif>
</div>
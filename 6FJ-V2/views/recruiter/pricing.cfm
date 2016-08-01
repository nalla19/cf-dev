<<<<<<< HEAD
<div class="page-pricing">

	<article class="section packages">
		<div class="container">
			<h1 class="page-title">Select the package that best fits your needs</h1>
			<p class="page-subtitle lead">Start your package today and get a direct line of communication with over 750k+ professionals looking</p>
			
			<div class="row-fluid pricing-table">
				<div class="package left-side"><div class="package-wrap">
					<h2>Starter</h2>
					<ul class="features">
						<li>30 day membership</li>
						<li>1 job posting</li>
						<li>Job &amp; Candidate Management Tools</li>
						<li>Emailed Job Applications</li>
						<li>Optional search licence (+ $150)</li>
					</ul>
					<p class="price"><strong>$199</strong> / month</p>
					<button class="btn btn-primary btn-small btn-select">Select</button>
					<div class="upsell hide">
						<p>
							<strong class="want">Want to bundle a search license?</strong> 
							+ <strong>$150</strong> / month
						</p>
						<button class="btn btn-primary btn-small btn-yes">Yes</button> <button class="btn btn-primary btn-small btn-no">No</button>
					</div>
				</div></div>
				<div class="package left-side"><div class="package-wrap">
					<h2>Bronze</h2>
					<ul class="features">
						<li>30 day membership</li>
						<li>1 job posting</li>
						<li>Job &amp; Candidate Management Tools</li>
						<li>Emailed Job Applications</li>
						<li>Optional search licence (+ $150)</li>
					</ul>
					<p class="price"><strong>$299</strong> / month</p>
					<button class="btn btn-primary btn-small btn-select">Select</button>
					<div class="upsell hide">
						<p>
							<strong class="want">Want to bundle a search license?</strong> 
							+ <strong>$150</strong> / month
						</p>
						<button class="btn btn-primary btn-small btn-yes">Yes</button> <button class="btn btn-primary btn-small btn-no">No</button>
					</div>
				</div></div>
				<div class="package package-featured">
					<div class="package-wrap">
						<h2>Silver</h2>
						<ul class="features">
							<li>30 day membership</li>
							<li>1 job posting</li>
							<li>Job &amp; Candidate Management Tools</li>
							<li>Emailed Job Applications</li>
							<li>Optional search licence (+ $150)</li>
						</ul>
						<p class="price"><strong>$399</strong> / month</p>
						<button class="btn btn-primary btn-medium btn-select">Select</button>
						<div class="upsell hide">
							<p>
								<strong class="want">Want to bundle a search license?</strong> 
								+ <strong>$150</strong> / month
							</p>
							<button class="btn btn-primary btn-small btn-yes">Yes</button> <button class="btn btn-primary btn-small btn-no">No</button>
						</div>
					</div>
				</div>
				
				<div class="package right-side">
					<div class="package-wrap">
						<h2>Gold</h2>
						<ul class="features">
							<li>30 day membership</li>
							<li>1 job posting</li>
							<li>Job &amp; Candidate Management Tools</li>
							<li>Emailed Job Applications</li>
							<li>Optional search licence (+ $150)</li>
						</ul>
						<p class="price"><strong>$599</strong> / month</p>
						<button class="btn btn-primary btn-small btn-select">Select</button>
						<div class="upsell hide">
							<p>
								<strong class="want">Want to bundle a search license?</strong> 
								+ <strong>$150</strong> / month
							</p>
							<button class="btn btn-primary btn-small btn-yes">Yes</button> <button class="btn btn-primary btn-small btn-no">No</button>
						</div>
					</div>
				</div>
				
				<div class="package right-side">
					<div class="package-wrap">
						<h2>Search only</h2>
						<ul class="features">
							<li>30 day membership</li>
							<li>1 job posting</li>
							<li>Job &amp; Candidate Management Tools</li>
							<li>Emailed Job Applications</li>
							<li>Optional search licence (+ $150)</li>
						</ul>
						<p class="price"><strong>$299</strong> / month</p>
						<button class="btn btn-primary btn-small btn-select">Select</button>
						<div class="upsell hide">
							<p>
								<strong class="want">Want to bundle a search license?</strong> 
								+ <strong>$150</strong> / month
							</p>
							<button class="btn btn-primary btn-small btn-yes">Yes</button> <button class="btn btn-primary btn-small btn-no">No</button>
						</div>
					</div>
				</div>
				
			</div>
=======
<div class="page-pricing" id="recruiter-pricing">
	<article class="section packages">
		<div class="container">
			<h1 class="page-title">Best-in-class Hiring for Every Budget</h1>
			<p class="page-subtitle lead">Monthly self-service post & search plans that make sense - and won't break the bank. Interested in an annual membership? Contact us for custom-crafted pricing plans.</p>
			
			<div class="row-fluid pricing-table">
			
				<cfset request.featuredCnt = ceiling(request.qry_packages.recordcount/2)+1 />
			
				<cfoutput>
				<cfloop query="request.qry_packages" startrow="2">
					
					<div class="package <cfif request.qry_packages.currentrow LT request.featuredCnt>left-side<cfelseif request.qry_packages.currentrow EQ request.featuredCnt>package-featured<cfelse>right-side</cfif>">
						<div class="package-wrap">
							<h2>#request.qry_packages.packageheading#</h2>
							<ul class="features">
								<cfloop index="request.f" list="#request.qry_packages.packagetext#" delimiters=";">
									<li>#request.f#</li>
								</cfloop>
							</ul>
							<p class="price"><strong>$#request.qry_packages.price#</strong> / month</p>
							<cfif request.qry_packages.packageheading NEQ "Search Only">
								<button class="btn btn-primary btn-small btn-select">Select</button>
								<div class="upsell hide">
									<p>
										<strong class="want">Want to bundle a search license?</strong> 
										+ <strong>$150</strong> / month
									</p>
									<a class="btn btn-primary btn-small btn-yes" href="package?pid=#request.qry_packages.package#&s=1">Yes</a> <a class="btn btn-primary btn-small btn-no" href="package?pid=#request.qry_packages.package#&s=0">No</a>
								</div>
							<cfelse>
								<a class="btn btn-primary btn-small btn-select" href="package?pid=#request.qry_packages.package#&s=1">Select</a>
							</cfif>
						</div>
					</div>
					
				</cfloop>
				</cfoutput>
				
			</div>
			
>>>>>>> c6c06d6dc3800a06e084ef03a407d8e9a398e7de
			<p><img src="/img/payments.png" alt="Payment methods logos"></p>
			<p><h3 class="page-title">Need assistance? Please call 800.605.5154</h3></p>
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
			<p><h3 class="page-title">Hey Employers! Annual Memberships receive Employer Branding.</h3></p>
			<p><a href="/branding">Learn more about our Employer Branding Solution</a></p>
=======
>>>>>>> 878d6f70fbb11fe79be4a547609f8f91254fb22e
=======
>>>>>>> parent of cd025e4... Linked SignUp changes
=======
			<p><h3 class="page-title">Hey Employers! Annual Memberships receive Employer Branding.</h3></p>
			<p><a href="/branding">Learn more about our Employer Branding Solution</a></p>
>>>>>>> cd025e4... Linked SignUp changes
		</div>
		
	</article><!--/.packages-->
	
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
	<!--->
=======
<<<<<<< HEAD
=======
>>>>>>> 878d6f70fbb11fe79be4a547609f8f91254fb22e
=======
>>>>>>> parent of cd025e4... Linked SignUp changes
=======
	<!--->
>>>>>>> cd025e4... Linked SignUp changes
	<div class="section text-center">
		<h2><a href="autumnspecial">Autumn Special Package Details Here!</a></h2>
	</div>
	--->
	
	<div class="section text-center">
		<h2><a href="winterspecial">Winter Special Package Details Here!</a></h2>
	</div>

	
>>>>>>> c6c06d6dc3800a06e084ef03a407d8e9a398e7de
	<article class="section faq well">
		<div class="container">
			<div class="row-fluid">
				<div class="span4">
<<<<<<< HEAD
					<h2>Can I cancel my membership anytime?</h2>
					<p>Our membership committee pre-screens (by hand) each job seeker that registers for our community. This includes a required profile, valid resume, contact information, and $100K+ salary history.</p>
				</div>
				<div class="span4">
					<h2>Do you have annual membership packages?</h2>
					<p>Our membership committee pre-screens (by hand) each job seeker that registers for our community. This includes a required profile, v0K+ salary history.</p>
				</div>
				<div class="span4">
					<h2>What's the duration of the job postings?</h2>
					<p>Our membership committee pre-screens (by hand) each job seeker that registers for our community.</p>
				</div>
			</div>
		</div>
	</article><!--/.faq-->
	
</div>
</div><!--/.wrap-->

<div class="modal modal-large hide fade in" id="modal-setupaccount">

	<div class="modal-header">
		<div class="row-fluid">
			<h1 class="span6">Setup your account</h1>
			<ol class="span6 pull-right steps">
				<li class="pull-left step step-1 step-active"><span class="step-label">1</span> Your information <span class="sep">&mdash;</span></li>
				<li class="pull-right step step-2"><span class="step-label">2</span> Payment details</li>
			</ol>
		</div>
	</div>
	
	<div class="modal-body">
		<div class="row-fluid">
			<div class="span6">
				<div id="your-information">
					<h2>Account Information</h2>
					<div class="row-fluid">
						<div class="span6">
							<label for="fn">First name</label>
							<input type="text" class="input span12" id="fn">
						</div>
						<div class="span6">
							<label for="ln">Last name</label>
							<input type="text" class="input span12" id="ln">
						</div>
					</div>
					<div>
						<label for="email">E-mail</label>
						<input type="text" class="input span12" id="email">
					</div>
					<div>
						<label for="Password">Password</label>
						<input type="password" class="input span12" id="Password">
					</div>
					<h2>Company Information</h2>
					<div>
						<label for="co">Company Name</label>
						<input type="text" class="input span12" id="co">
					</div>
					<div>
						<label for="ad1">Address 1</label>
						<input type="text" class="input span12" id="ad1">
					</div>
					<div>
						<label for="ad2">Address 2</label>
						<input type="text" class="input span12" id="ad2">
					</div>
					<div>
						<label for="country">Country</label>
						<input type="text" class="input span12" id="ad2">
					</div>
					<div class="row-fluid">
						<div class="span4">
							<label for="city">City</label>
							<input type="text" class="input span12" id="city">
						</div>
						<div class="span4">
							<label for="zip">Zipcode</label>
							<input type="text" class="input span12" id="zip">
						</div>
						<div class="span4">
							<label for="state">State</label>
							<select id="state" class="span12">
								<option>A</option>
								<option>B</option>
								<option>C</option>
							</select>						
						</div>
					</div>	
					<div class="row-fluid">
						<div class="span6">
							<label for="tel">Phone</label>
							<input type="text" class="input span12" id="tel">
						</div>
						<div class="span6">
							<label for="fax">Fax</label>
							<input type="text" class="input span12" id="fax">
						</div>
					</div>
					<div>
						<label for="www">Website</label>
						<input type="text" class="input span12" id="www">
					</div>
					<div>
						<label for="billing" class="checkbox"><input type="checkbox" id="billing"> Billing information is the same as above</label>
					</div>
					<div>
						<label for="terms" class="checkbox"><input type="checkbox" id="terms"> I agree with 6FigureJobs <a href="#">Terms and Conditions</a></label>
					</div>
					<p class="form-submit">
						<button class="btn btn-primary">Continue &rarr;</button>
						Or <a href="#" class="btn-link" data-dismiss="modal" aria-hidden="true">Cancel</a>
					</p>
				</div><!--/#your-information-->
				<div id="payment-details" class="hide">
					<h2>Credit Card Information</h2>
					<div>
						<label for="cc">Credit Card Number</label>
						<input type="text" class="input span12" id="cc">
					</div>
					<div>
						<label for="exp-mo">Expiration date</label>
						<div class="row-fluid">
							<div class="span8">
								<input type="text" class="input span12" id="exp-mo" placeholder="Month">
							</div>
							<div class="span4">
								<input type="text" class="input span12" id="exp-yr" placeholder="Year">
							</div>
						</div>
					</div>
					<div>
						<label for="code">Security Code</label>
						<input type="text" class="input span6" id="code">
						<span class="btn-link btn-tooltip" title="Tooltip text">?</span>
					</div>
					<div>
						<label for="name">Name on card</label>
						<input type="text" class="input input-block" id="name">
					</div>
					<p class="help-block">We'll process the information through a SSL Secured Server.</p>
					<p class="form-submit">
						<button class="btn btn-primary">Make Payment</button>
						Or <a href="#" class="btn-link" data-dismiss="modal" aria-hidden="true">Cancel</a>
					</p>
				</div><!--/#payment-details-->
			</div>
			<div class="span6">
				<div class="details">
					<small>You Selected</small>
					<h3>Recurring Membership</h3>
					<p class="price"><strong>$499</strong> / month</p>
					<ul class="has-purple-bullet">
						<li>Post up to 5 job listings</li>
						<li>30 days listings duration</li>
						<li>Real-time email job applications</li>
						<li>Browse 750K+ members resumes</li>
						<li>Job & candidate management tools</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
=======
					<h2>Do you offer annual recruitment membership packages?</h2>
					<p>Yes! We offer attractive and customized annual recruitment packages with a few nice perks too! Contact us for details.</p>
				</div>
				<div class="span4">
					<h2>Can I source and reach out to candidates I like directly?</h2>
					<p>Absolutely! No communication barriers. Profiles have phone and email information so you can engage quickly and directly. Nice, huh?</p>
				</div>
				<div class="span4">
					<h2>Do you work with recruitment ad agencies?</h2>
					<p>Yes. We work very closely with agencies to deliver a strong pipeline of talent and support their clients’ recruitment brand strategies too.</p>
				</div>
			</div>
			<p class="btn-wrap"><a href="faq" class="btn btn-primary">More Frequently Asked Questions</a></p>
		</div>
	</article><!--/.faq-->
	
>>>>>>> c6c06d6dc3800a06e084ef03a407d8e9a398e7de
</div>
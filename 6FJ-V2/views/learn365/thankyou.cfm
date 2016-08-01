
<cfparam name="request.thePageTitle" default="Learn365 Membership Registration">
<cfparam name="request.thePageDescription" default="">
<cfparam name="request.thePageKeywords" default="">
<cfparam name="request.thePageGoogleVer" default="">
<cfparam name="request.thePageCSS" default="page-home.css">
<cfparam name="request.signinactivetab" default="">
<cfparam name="request.ldfxtrackingtag" default="true">
<cfparam name="request.theContent" default="">
<cfparam name="request.act" default="">

<cfscript>
	resObj 		= application.resume;
	qProfile 	= resObj.getResumeDetail(session.exec.intResID);	
	profileid =  application.executive.getProfileidByResumeid(session.exec.intResID).profileid;
	premiumObj 	= application.premium;
	qPackProfile 	= premiumObj.getPremiumPackageDetails(profileid); 	
</cfscript>



<cfif isdefined("url.hide6fj")>
	<cfset session.EXEC.hide6FJBtn = 1>
	<cfquery name="cfqUpdRecord" datasource="#application.dsn#">
		update tblResumes  set
		blnHide6FJBtn  = 1
		where intResid = <cfqueryparam value="#qProfile.intResID#" cfsqltype="cf_sql_integer" />
	</cfquery>
</cfif>

<cfoutput>	
	<div class="page-dashboard">
		<article class="section companies well">
			<div class="container">
				<div class="span12">
					<cfif isdefined("url.hide6fj")>
						<div class="row">
							<div class="alert alert-success" id="displaySave_account">
							<button type="button" class="close" data-dismiss="alert">&times;</button>
							<strong>Update Successful</strong>
							<p>We've hidden the SEEKER SITE button as you requested.</p>
							</div>
						</div>
					</cfif>
					<div class="row">
						<h1 class="page-title">Welcome #qProfile.fname#, and thank you!</h1>
						
						<p>You are now logged into your Learn365 dashboard, and can begin
						learning now!</p>

						<p>Learn365 strives to be your daily go-to for developing, 
						strengthening, or refreshing a skill to create new
						opportunities or open new doors for your career, or generally
						to inspire new ideas.</p>
						
						<p>To Get Started...</p>
							<cfinclude template="getStarted.cfm">

						<p>If you are not interested in becoming a 6FigureJobs member to search for
						senior-level and executive jobs, please <a href="/learn365-thankyou?hide6fj=Y">click here</a> and we'll hide the 
						SEEKER SITE tab at top.  You can always turn this back on later by going into
						your Learn365 Profile.</p>
						
						<p>Happy Learning,<br>
						Your Learn365 team</p>
					</div>
				</div>
			</div>
		</article>
	</div>
	
	

	<script type="text/javascript">
	//Google Analytics Code - 05/21/2013
	var _gaq = _gaq || [];
	_gaq.push(['_setAccount', 'UA-214963-1']);
	_gaq.push(['_trackPageview']);
	
	  _gaq.push(['_addTrans',
		'#qPackProfile.strTransactionid#',           // transaction ID - required
		'Learn365',  // affiliation or store name
		'#qPackProfile.intCost#',          // total - required
		'0',           // tax
		'0',              // shipping
		'#qProfile.city#',       // city
		'#qProfile.state#',     // state or province
		''             // country
	  ]);
	
	   // add item might be called for every item in the shopping cart
	   // where your ecommerce engine loops through each item in the cart and
	   // prints out _addItem for each
	  _gaq.push(['_addItem',
		'#qPackProfile.strTransactionid#',           // transaction ID - required
		'L365',           // SKU/code - required
		'Learn365 Membership',        // product name
		'',   // category or variation
		'#qPackProfile.intCost#',          // unit price - required
		'1'               // quantity - required
	  ]);
	  _gaq.push(['_trackTrans']); //submits transaction to the Analytics servers
	
	(function() {
		var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + '.google-analytics.com/ga.js';
		var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
	})();
	</script>
</cfoutput>




</body>
</html>
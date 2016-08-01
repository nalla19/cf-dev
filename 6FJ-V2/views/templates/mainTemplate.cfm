<cfparam name="request.thePageTitle" default="6FigureJobs">
<cfparam name="request.thePageDescription" default="">
<cfparam name="request.thePageKeywords" default="">
<cfparam name="request.thePageGoogleVer" default="">

<cfparam name="request.thePageCSS" default="">
<cfparam name="request.theContent" default="">
<cfparam name="memberName" default="">

<!DOCTYPE html>
<html>
<head>
	<cfoutput>
	<title>#request.thePageTitle#</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="#request.thePageDescription#" />
	<meta name="keywords" content="#request.thePageKeywords#" />
	<cfif len(request.thePageGoogleVer)>
		<meta name="google-site-verification" content="#request.thePageGoogleVer#" />
	</cfif>
	</cfoutput>
	
	<meta name="allow-search" content="yes">
	<meta name="robots" content="index,follow">
	<meta name="author" content="6FigureJobs.com">
	
	<!-- Bootstrap -->
	<link href="/css/bootstrap.min.css" rel="stylesheet" media="screen">
	<link href="/css/bootstrap-responsive.min.css" rel="stylesheet" media="screen">
	<link href="/css/custom-theme/jquery-ui-1.10.0.custom.css" rel="stylesheet" media="screen">
	<link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
	
	<!-- Stylesheet -->
	<link href="/css/custom.css<cfoutput>?#application.appVersionNumber#</cfoutput>" rel="stylesheet" media="screen">
	<cfif len(request.thePageCSS)>
		<!-- Page CSS -->
		<link href="/css/<cfoutput>#request.thePageCSS#?#application.appVersionNumber#</cfoutput>" rel="stylesheet" media="screen">
	</cfif>
	
	<!--[if lt IE 9]>
	<script src="/js/html5shiv.js"></script>
	<script src="/js/respond.min.js"></script>
	<![endif]-->
	<script src="/js/prefixfree.min.js"></script>
	<!---><link rel="shortcut icon" href="/favicon.ico">--->
	<link rel="shortcut icon" href="/images/favicon-092012.ico?v=09172012">

	<cfif application.machine NEQ "local">
		<script type="text/javascript" src="//use.typekit.net/qis2rct.js"></script>
		<script type="text/javascript">try{Typekit.load();}catch(e){}</script>
	</cfif>
	
<!-- Start Visual Website Optimizer Asynchronous Code -->
<script type='text/javascript'>
var _vwo_code=(function(){
var account_id=45132,
settings_tolerance=2000,
library_tolerance=2500,
use_existing_jquery=false,
// DO NOT EDIT BELOW THIS LINE
f=false,d=document;return{use_existing_jquery:function(){return use_existing_jquery;},library_tolerance:function(){return library_tolerance;},finish:function(){if(!f){f=true;var a=d.getElementById('_vis_opt_path_hides');if(a)a.parentNode.removeChild(a);}},finished:function(){return f;},load:function(a){var b=d.createElement('script');b.src=a;b.type='text/javascript';b.innerText;b.onerror=function(){_vwo_code.finish();};d.getElementsByTagName('head')[0].appendChild(b);},init:function(){settings_timer=setTimeout('_vwo_code.finish()',settings_tolerance);this.load('//dev.visualwebsiteoptimizer.com/j.php?a='+account_id+'&u='+encodeURIComponent(d.URL)+'&r='+Math.random());var a=d.createElement('style'),b='body{opacity:0 !important;filter:alpha(opacity=0) !important;background:none !important;}',h=d.getElementsByTagName('head')[0];a.setAttribute('id','_vis_opt_path_hides');a.setAttribute('type','text/css');if(a.styleSheet)a.styleSheet.cssText=b;else a.appendChild(d.createTextNode(b));h.appendChild(a);return settings_timer;}};}());_vwo_settings_timer=_vwo_code.init();
</script>
<!-- End Visual Website Optimizer Asynchronous Code -->
</head>

<body class="page-career">
	<div style="padding: 10px 0 15px 0; background-color: #1f0845;">
		<div class="container">
			<div class=" pull-left">
				
			</div>
			<div class=" pull-right">
			
			
			<!--- full go live code hide for 3.26--->
			<cfif isdefined("request.portalNav") and request.portalNav EQ "recruiter">
				<cfif isdefined("session.EXEC.blnValidLogin") and session.EXEC.blnValidLogin>
					<a href="/member-dashboard" role="button" class="btn btn-primary btn-small btn-small-portal" title="Seeker Site">Seeker Site</a>
				<cfelse>
					<a href="/home" role="button" class="btn btn-primary btn-small btn-small-portal" title="Seeker Site">Seeker Site</a>
				</cfif>
				<cfif isdefined("session.EXEC.blnLearn365") and session.EXEC.blnLearn365 EQ 1>
					<a href="/learn365-dashboard" role="button" class="btn btn-primary btn-small btn-small-portal" title="Learn365 Site" >Learn365 Site</a>
				<cfelse>
					<a href="/learn365" role="button" class="btn btn-primary btn-small btn-small-portal" title="Learn365 Site" >Learn365 Site</a>
				</cfif>
				<button class="btn btn-default btn-small btn-small-portal disabled disabled2" title="Employer Site">Employer Site</button>
			<cfelse>
					<button class="btn btn-default btn-small btn-small-portal disabled disabled2" title="Seeker Site">Seeker Site</button>
				
				<cfif isdefined("session.EXEC.blnLearn365") and session.EXEC.blnLearn365 EQ 1>
					<a href="/learn365-dashboard" role="button" class="btn btn-primary btn-small btn-small-portal" title="Learn365 Site" >Learn365 Site</a>
				<cfelse>
					<a href="/learn365" role="button" class="btn btn-primary btn-small btn-small-portal" title="Learn365 Site" >Learn365 Site</a>
				</cfif>
				<cfif (isdefined("session.EXEC.blnValidLogin") and session.EXEC.blnValidLogin) or (isdefined("session.EXEC.isLearn365Active") and session.EXEC.isLearn365Active)>
					
					<a href="/member-logout" class="signin-link btn btn-primary btn-small btn-small-portal">Logout</a>
					
				<cfelse>
					<a href="/recruiters" role="button" class="btn btn-primary btn-small btn-small-portal" title="Employer Site">Employer Site</a>
				</cfif>
			</cfif>
			<!--- full go live code --->
			</div>
		</div>
	</div>
<div id="wrap" class="wrap">

	<div class="navbar navbar-inverse">
	
		<div class="container">
			
			<div class="navbar-inner" id="searchnavbar">
				<!--- If user is logged in, Logo sends them to dashboard and not to "join us" marketing --->
				<cfif isdefined("session.EXEC.blnValidLogin")>
					<a href="/member-dashboard" id="brand" class="brand pull-left">
				<cfelse>
					<a href="<cfoutput>#application.url#</cfoutput>" id="brand" class="brand pull-left">
				</cfif>
					<img src="/img/6figurejobs.png" alt="6FigureJobs logo">
					<cfif isdefined("request.portalNav") and request.portalNav EQ "recruiter"><cfelse><strong class="search hidden-phone">Search $100K+ Jobs</strong></cfif>
				</a>
				
				<cfif request.act EQ "search">
					<button type="button" class="btn btn-navbar collapsed pull-right" data-toggle="collapse" data-target="#navRefineResults">
						Refine Search <span class="caret"></span>
					</button>
					
					<div class="nav-collapse collapse visible-tablet visible-phone" id="navRefineResults">
						<cfoutput>#request.theSearchFilters#</cfoutput>
					</div>
				</cfif>
				
				<button type="button" class="btn btn-navbar collapsed pull-right" data-toggle="collapse" data-target="#mainNavCollapse">
					Home <span class="caret"></span>
				</button>
				<!--- move for go live 3/26 --->
				<div class="nav-collapse collapse" id="mainNavCollapse">
					<ul class="nav pull-right">
						
						<cfif isdefined("request.portalNav") and request.portalNav EQ "recruiter">
							<li class="has-divider"><a href="#signin" data-toggle="modal" class="signin-link">Sign In</a></li>
						<cfelse>
							<cfif isdefined("session.EXEC.blnValidLogin")>
								<li class="btn-primary btn-small" style="padding:0;"><a href="/member-dashboard"><strong>Dashboard</strong></a></li>
							<cfelse>
								<li class="btn-primary btn-small" style="padding:0;"><a href="/join"><strong>Join Free</strong></a></li>
							</cfif>
							<li <cfif url.act EQ "companies" OR url.act EQ "company">class="active"</cfif> class=""><a href="/companies">Companies</a></li>
							<li class=""><a href="http://<cfif application.machine NEQ 'LIVE'>uat2.</cfif>blog.6figurejobs.com">Blog</a></li>
							<li <cfif url.act EQ "career">class="active"</cfif>><a href="/career">Career</a></li>
							
							<!--- if user is logged in, show them logout link. --->
							<cfif isdefined("session.EXEC.blnValidLogin")>
								
							<cfelse>
								<li class="has-divider"><a href="#signin" data-toggle="modal" class="signin-link">Sign In</a></li>
							</cfif>
						</cfif>
					</ul><!--/.nav-->
				</div><!--/.nav-collapse-->
				<!--- move for go live 3/26 --->
				<div class="signin modal hide" id="signin">
					<ul class="signin-nav row-fluid">
						<cfif request.portalNav EQ "recruiter">
						
						<li class="active"><a href="#recruiters" class="tab" data-toggle="tab">Recruiters</a></li>
						<cfelse>
						<li class="active"><a href="#members" class="tab" data-toggle="tab">Members</a></li>
						
						</cfif>
					</ul>
					<cfoutput>
					
					<div class="tab-content signin-members<cfif request.portalNav NEQ 'recruiter'> active</cfif>" id="members">
						
						<p class="submit-wrap">
							<a href="/member-login-linkedin?startli=1<cfif isDefined("request.intJobId") and len(request.intJobId)>&Pf9ZL4URh=#request.intJobId#&strCaller=execOneClickApply</cfif>"><img src="/images/signinlinkedin-button.png" alt="Sign in via LinkedIn" title="Sign in via LinkedIn." border="0" style="vertical-align:text-bottom;" /></a>
						</p>
						
						<div class="row-fluid">
							<p><img src="/images/reg-divider-2.png" /></p>	
						</div>
						
						
						<!---ISR 1/31/14 <form action="#application.v1SecureURL#/pg_Execloginprocess.cfm?#application.strAppAddToken#<cfif isDefined("request.intJobId") and len(request.intJobId)>&intJobID=#request.intJobId#</cfif>" method="post">--->
                        <form action="/member-login?#application.strAppAddToken#<cfif isDefined("request.intJobId") and len(request.intJobId)>&intJobID=#request.intJobId#</cfif>" method="post">
						<cfif isDefined("request.intJobId") and len(request.intJobId)>
							<input type="hidden" name="strCaller" value="execOneClickApply">
							</cfif>
							<div><input name="strUsername" type="text" class="input input-small" placeholder="Username"></div>
							<div><input name="strPassword" type="password" class="input input-small" placeholder="Password"></div>
							<p class="submit-wrap">
								<label class="checkbox inline" id="blnRememberMe"><input type="checkbox" name="blnRememberMe" id="blnRememberMe" value="1" checked> Keep me logged in</label>
							<br><br>
								<button type="submit" class="btn btn-primary btn-small btn-signin">Sign in</button>
								<a href="/member-password">Forgot your password?</a>
							</p>
							<input type="hidden" name="strloginLoc" value="6FJ">
						</form>
						<span class="arrow"></span>
					</div>
					
					<div class="tab-content signin-recruiters<cfif request.portalNav EQ 'recruiter'> active</cfif>" id="recruiters">
						<form action="#application.v1SecureURL#/pg_ERloginprocess.cfm?#application.strAppAddToken#" method="post">
							
							<div><input name="strUsername" type="text" class="input input-small" placeholder="Username"></div>
							<div><input name="strPassword" type="password" class="input input-small" placeholder="Password"></div>
							<p class="submit-wrap">
								<button type="submit" class="btn btn-primary btn-small btn-signin">Sign in</button>
								<a href="/recruiter-password">Forgot your password?</a>
							</p>
						</form>
						<div class="assistance">
							<h2 class="assistance-header">Need Assistance?</h2>
							<p>Contact your dedicated Account Manager or call 800.605.5154 for support.</p>
							<p>Or you can <a href="##">chat with us</a>. We&rsquo;re online.</p>
						</div>
						<span class="arrow"></span>
					</div>
					</cfoutput>
				</div><!-- /.signin -->
				
				<form class="form finder-form clearfix hide" action="/search" method="get">
					<div class="input-group-jobtitle">
						<input type="text" placeholder="Find by title or skills&hellip;" name="strTitle" class="job-title input input-small">
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
					<input type="text" placeholder="Location" name="strLocation" id="job-location" class="job-location input input-small">
					<button class="btn btn-primary btn-small btn-search" type="submit">Search jobs</button>
					<span class="cancel">or <button type="button" class="btn btn-link">Cancel</button></span>
				</form><!--/.finder-form-->
				
			</div><!--/.navbar-inner-->
			
		</div><!--/.container-->
		
	</div><!--/.navbar-inverse-->
	
	<cfoutput>#request.theContent#</cfoutput>
	
	
	<footer class="footer">
	
		<div class="container">
		
			<ul class="nav">
				<li><a href="/about">About 6FigureJobs</a></li>
				<li><a href="/contact">Contact Us</a></li>
				<li><a href="/faq">FAQ</a></li>
				<li><a href="/advertise">Advertise</a></li>
				<li><a href="/privacy">Privacy Policy</a></li>
				<li><a href="/terms">Terms of Use</a></li>
				<!---><li><a href="/sitemap">Site Map</a></li>--->
			</ul>
			
			<div class="row-fluid footer-widgets">
				<div class="span3 widget calliduscloud">
					<a href="http://www.calliduscloud.com"><img src="/img/calliduscloud.png" alt="Callidus Cloud logo"></a>
				</div>
				<div class="span5 widget stayintouch clearfix">
					<h3>Stay in touch</h3>
					<a class="facebook" href="http://www.facebook.com/pages/6FigureJobs/218497995001?ref=ts"><img src="/img/stayintouch.png" alt="Facebook icon"></a>
					<a class="twitter"  href="http://www.twitter.com/6FigureJobs"><img src="/img/stayintouch.png" alt="Twitter  icon"></a>
					<a class="linkedin" href="http://www.linkedin.com/groups?gid=21210"><img src="/img/stayintouch.png" alt="Linkedin icon"></a>
                    <a class="googleplus" href="https://plus.google.com/105332100153951435724/posts"><img src="/img/stayintouch.png" alt="Google+ icon"></a>
                    <a class="pinterest" href="http://www.pinterest.com/6figurejobs/"><img src="/img/stayintouch.png" alt="Pinterest icon"></a>
				</div>
				<div class="span4 widget subscribe">
					<h3>Subscribe to our newsletter(s)</h3>
					<form id="newsletterSubscribeFrm" action="newsletter.signup" method="post">
					<p>
						<label class="radio inline" for="subscribe-jobseekers">
							<input type="radio" name="newsType" id="subscribe-jobseekers" value="exec">
							Job Seeker
						</label>
						<label class="radio inline" for="subscribe-recuiters">
							<input type="radio" name="newsType" id="subscribe-recuiters" value="er">
							Recruiter
						</label>
						<label class="radio inline" for="subscribe-both">
							<input type="radio" name="newsType" id="subscribe-both" value="both">
							Both
						</label>
					</p>
					<div class="input-append">
						<input name="emailaddress" type="email" class="input input-small input-block requiredField" placeholder="Your e-mail">
						<button class="btn btn-primary btn-small" type="submit">OK</button>
					</div>
					</form>
				</div>
			</div>
			
			<p class="copyright">&copy; Copyright <cfoutput>#application.thisYear#</cfoutput> &bull; 6FigureJobs.com, Inc. (a CallidusCloud Company) &bull; All Rights Reserved</p>
		</div>
		
	</footer>	

</div><!--/.wrap-->

<!---
<cfoutput>
request.ldfxtrackingtag=#request.ldfxtrackingtag#<br>
request.seekertrackingtag=#request.seekertrackingtag#<br>
request.recruitertrackingtag=#request.recruitertrackingtag#<br>
</cfoutput>
--->


<script src="/js/jquery.min.js"></script>
<script src="/js/bootstrap.min.js"></script>
<script src="/js/jquery-ui-1.10.0.custom.min.js"></script>
<script src="/js/Placeholders.min.js"></script>
<script src="/js/script.js?<cfoutput>#application.appVersionNumber#</cfoutput>"></script>

<!-- begin LeadformixChat code -->
<script type="text/javascript">
 (function() {
   var se = document.createElement('script'); se.type = 'text/javascript'; se.async = true;
   se.src = '//commondatastorage.googleapis.com/leadformixchat/js/de7d75a2-b7e2-402f-af32-4b7e5e35dc28.js';
   var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(se, s);
 })();
</script>
<!-- end LeadformixChat code -->


<cfif request.seekertrackingtag>
	<!-- Start: Seeeker Tracking Tag --><!--- Analytics code for every page --->
	<script type="text/javascript">
	var _gaq = _gaq || [];
  	_gaq.push(['_setAccount', 'UA-214963-1']);
 	_gaq.push(['_trackPageview']);

  	(function() {
    	var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	    ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js';
	    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
	  })();
	</script>
	<!-- End: Seeeker Tracking Tag -->
</cfif>


<cfif request.recruitertrackingtag>
	<!-- Start: Recruiter Tracking Tag -->
	<script type="text/javascript">
	var _gaq = _gaq || [];
  	_gaq.push(['_setAccount', 'UA-214963-1']);
  	_gaq.push(['_trackPageview']);

  	(function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  	})();
	</script>
	<!-- End: Recruiter Tracking Tag -->
</cfif>

<!-- Start: Google Code for Remarketing Tag for Seeker and Recruiter Pages-->
<script type="text/javascript">
/* <![CDATA[ */
var google_conversion_id = 986961148;
var google_custom_params = window.google_tag_params;
var google_remarketing_only = true;
/* ]]> */
</script>
<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js"></script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="//googleads.g.doubleclick.net/pagead/viewthroughconversion/986961148/?value=0&amp;guid=ON&amp;script=0"/>
</div>
</noscript>
<!-- End: Google Code for Remarketing Tag for Seeker and Recruiter Pages-->

<cfif request.ldfxtrackingtag>
	<!-- LeadFormix -->
	<a href="https://www.leadformix.com" title="Marketing Automation" onclick="window.open(this.href);return(false);">
		<script type="text/javascript">
			var pkBaseURL = (("https:" == document.location.protocol) ? "https://vlog.leadformix.com/" : "https://vlog.leadformix.com/");
			<!--
			bf_action_name = '';
			bf_idsite = 7783;
			bf_url = pkBaseURL+'bf/bf.php';
			(function() {
				var lfh = document.createElement('script'); lfh.type = 'text/javascript'; lfh.async = true;
				lfh.src = pkBaseURL+'bf/lfx.js';
				var s = document.getElementsByTagName('head')[0]; s.appendChild(lfh);
			})();
			//-->
		</script>
		<noscript>
			<p>
				Market analytics
				<img src="https://vlog.leadformix.com/bf/bf.php" style="border:0" alt="bf"/>
			</p>
		</noscript>
	</a>
	<!-- /LeadFormix -->
</cfif>
</body>
</html>
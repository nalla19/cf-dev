<cfparam name="request.thePageTitle" default="Learn365">
<cfparam name="request.thePageDescription" default="">
<cfparam name="request.thePageKeywords" default="">
<cfparam name="request.thePageGoogleVer" default="">

<cfparam name="request.thePageCSS" default="">
<cfparam name="request.theContent" default="">
<cfparam name="memberName" default="">

<cfif isdefined("session.EXEC.strFirstName") and isdefined("session.EXEC.strLastName")>
	<cfset memberName = session.EXEC.strFirstName & " " & session.EXEC.strLastName>
</cfif>



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
	
<div id="wrap" class="wrap">
	<div style="padding: 10px 0 15px 0; background-color: #1f0845;">
		<div class="container">
			<div class=" pull-left">
				<img src="/img/6figurejobs.png" alt="6FigureJobs logo">
			</div>
			
		</div>
	</div>
	
	<cfoutput>#request.theContent#</cfoutput>
	
	
	<footer class="footer">
	
		<div class="container">
		
			
			
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
				
			</div>
			
			<p class="copyright">&copy; Copyright <cfoutput>#application.thisYear#</cfoutput> &bull; 6FigureJobs.com, Inc. (a CallidusCloud Company) &bull; All Rights Reserved</p>
		</div>
		
	</footer>	

</div><!--/.wrap-->



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
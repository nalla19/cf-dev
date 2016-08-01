<cfparam name="request.thePageTitle" default="6FigureJobs">
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

	<div class="navbar navbar-inverse">
	
		<div class="container">
		
			<div class="navbar-inner" id="searchnavbar">
				<div class="brand pull-left"><img src="/img/6figurejobs.png" alt="6FigureJobs logo"></div>			
				
				<div class="nav-collapse collapse" id="mainNavCollapse">
				</div>
				<!--/.nav-collapse-->

			</div>	
		</div><!--/.container-->
		
	</div>
	<!--/.navbar-inverse-->
	
	<cfoutput>#request.theContent#</cfoutput>
</div><!--/.wrap-->


<script src="/js/jquery.min.js"></script>
<script src="/js/bootstrap.min.js"></script>
<script src="/js/jquery-ui-1.10.0.custom.min.js"></script>
<script src="/js/Placeholders.min.js"></script>
<script src="/js/script.js?<cfoutput>#application.appVersionNumber#</cfoutput>"></script>


</body>
</html>
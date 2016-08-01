<cfquery name="getCourseCategories" datasource="#application.dsn#">
SELECT
[courseCategory_id]
,[courseCategory_name]
 FROM [EAGLE].[dbo].[tblLearn365CourseCategory]
 order by sortby

</cfquery>

<cfif isdefined("url.coursecat")>
<cfset courseCategory = url.coursecat>
<cfelse>
<cfset courseCategory = 1>
</cfif>

<cfparam name="request.thePageTitle" default="Learn365">
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
	<div class="stickyNav">
		<div style="padding: 10px 0 15px 0; background-color: #1f0845;">
			<div class="container">
				<div class=" pull-left">
				</div>
				<div class=" pull-right">
				
					<cfif isdefined("session.EXEC.blnValidLogin") and session.EXEC.blnValidLogin>
					
						<cfif isdefined("session.EXEC.hide6FJBtn") and session.EXEC.hide6FJBtn>
						
						<cfelse>
							<a href="/member-dashboard" role="button" class="btn btn-primary btn-small btn-small-portal" title="Seeker Site">Seeker Site</a>
						</cfif>
						<button class="btn btn-default btn-small btn-small-portal disabled disabled2" title="Learn365 Site">Learn365 Site</button>
						<cfif isdefined("session.EXEC.blnValidLogin") and session.EXEC.blnValidLogin>
							<a href="/member-logout" class="signin-link btn btn-primary btn-small btn-small-portal">Logout</a>
						<cfelse>
							<a href="/recruiters" role="button" class="btn btn-primary btn-small btn-small-portal" title="Employer Site">Employer Site</a>
						</cfif>
					<cfelse>
						<cfif isdefined("session.EXEC.hide6FJBtn") and session.EXEC.hide6FJBtn>
						
						<cfelse>
							<a href="/home" role="button" class="btn btn-primary btn-small btn-small-portal" title="Seeker Site">Seeker Site</a>
						</cfif>
						<button class="btn btn-default btn-small btn-small-portal disabled disabled2" title="Learn365 Site">Learn365 Site</button>
						<cfif isdefined("session.EXEC.blnValidLogin") and session.EXEC.blnValidLogin>
							<a href="/member-logout" class="signin-link btn btn-primary btn-small btn-small-portal">Logout</a>
						<cfelse>
							<a href="/recruiters" role="button" class="btn btn-primary btn-small btn-small-portal" title="Employer Site">Employer Site</a>
						</cfif>
					</cfif>
					
				</div>
			</div>
		</div>
	
	<cfif not isdefined("request.hideNav")>
		<div class="navbar navbar-inverse" >
			
			<div class="container">
				
				<div class="navbar-inner" id="searchnavbar">
					<!--- If user is logged in, Logo sends them to dashboard and not to "join us" marketing --->
					
					<!--- go live 3/26 --->
					<!--- 
						<a href="/learn365" id="brand" class="brand pull-left">
						<img src="images/learn365/Learn365-PoweredBy6FJ.png" alt="Learn365 logo">
					 --->
					
					<cfif isdefined("session.EXEC.blnValidLogin") and session.EXEC.blnValidLogin and isdefined("session.EXEC.isLearn365Active") and session.EXEC.isLearn365Active EQ 1>
						<a href="/learn365-dashboard" id="brand" class="brand pull-left">
						<img src="images/learn365/Learn365-SEL.png" alt="Learn365 logo">
					<cfelse>
						<a href="#" id="brand" class="brand pull-left" onClick="window.scrollTo(x-coord, y-coord);">
						<img src="images/learn365/Learn365-PoweredBy6FJ.png" alt="Learn365 logo"  >
					</cfif>
					</a>
					
					
					
					<button type="button" class="btn btn-navbar collapsed pull-right" data-toggle="collapse" data-target="#mainNavCollapse">
						Home <span class="caret"></span>
					</button>
					
					<div class="nav-collapse collapse" id="mainNavCollapse">
						<ul class="nav pull-right">
						
						<!--- go live 3/26 --->
						 <!---
							<li  style="padding:0;"><a href="#" role="button" class="btn btn-primary btn-small" data-target="#myModal7" type="button" data-toggle="modal" ><strong>Coming Soon!</strong></a></li>
							<li <cfif url.act EQ "career">class="active"</cfif>><a href="/learn365#courses">Courses</a></li>
							
						
						 --->
						
						
							<!--- --->
							<cfif request.profileNav>
								<li class="btn-primary btn-small" style="padding:0;"><a href="/learn365-dashboard"><strong>Dashboard</strong></a></li>
								<li><a href="/learn365-sso" target="_blank">Courses</a></li>
								<li <cfif url.act EQ "learn365-profile">class="active"</cfif>><a href="/learn365-profile">Profile</a></li>
								
								<!--- if user is logged in, show them logout link. --->
								<cfif isdefined("session.EXEC.blnValidLogin") and session.EXEC.blnValidLogin>
									
								<cfelse>
									<li class="has-divider"><a href="#signin" data-toggle="modal" class="signin-link">Sign In</a></li>
								</cfif>
							<cfelse>
								<li class="btn-primary btn-small" style="padding:0;"><a href="/learn365-signup"><strong>Start Learning</strong></a></li>
								<li><a href="/learn365#membership">Details</a></li>
								<li class="dropdown">
									<a href="/learn365#courses" class="dropdown-toggle" data-toggle="dropdown">Courses <b class="caret"></b></a>
									<ul class="dropdown-menu">
									<cfoutput query="getCourseCategories">
										<cfif reFindNoCase("(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino",CGI.HTTP_USER_AGENT) GT 0 OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0>
											<li><a href="/learn365##courses" onClick="$( '##sliderContent' ).load( 'api/courseSliderMobile.cfm?category=#coursecategory_id#' );" >#coursecategory_name#</a></li>
										<cfelse>
											<li><a href="/learn365##courses" onClick="$( '##sliderContent' ).load( 'api/courseSlider.cfm?category=#coursecategory_id#' );" >#coursecategory_name#</a></li>
										</cfif>
									</cfoutput>
										
									</ul>
								</li>
								<cfif isdefined("session.EXEC.blnValidLogin") and session.EXEC.blnValidLogin>
									
								<cfelse>
									 <li class="has-divider"><a href="#signin" data-toggle="modal" class="signin-link">Sign In</a></li> 
								</cfif>
							</cfif> 					</ul><!--/.nav-->
					</div><!--/.nav-collapse-->
					
					<div class="signin modal hide" id="signin">
						<ul class="signin-nav row-fluid">
							<li class="active"><nobr><a href="#members" class="tab" data-toggle="tab">Learn365 Members</a></nobr></li>
						</ul>
						<cfoutput>
						<div class="tab-content signin-members<cfif request.signinactivetab EQ 'member'> active</cfif>" id="members">
							
							<form action="/member-login?#application.strAppAddToken#&loginType=learn<cfif isDefined("request.intJobId") and len(request.intJobId)>&intJobID=#request.intJobId#</cfif>" method="post">
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
								
								<p class="submit-wrap" style="margin-top:25px;">
									<a href="/home">Click here to sign in with 6FigureJobs.</a>
								</p>
								<input type="hidden" name="strloginLoc" value="L365">
							</form>
							<span class="arrow"></span>
						</div>
						</cfoutput>
					</div><!-- /.signin -->
					
				</div><!--/.navbar-inner-->
				
			</div><!--/.container-->
			
		</div><!--/.navbar-inverse-->
	</cfif>
	</div>
	<div <cfif isdefined("request.hideNav")>class="hideNav"<cfelse>class="stickyNavMargin"</cfif>>
	<cfoutput>#request.theContent#</cfoutput>
	</div>
	
	<footer class="footer">
	
		<div class="container">
		
			<ul class="nav">
				<li><a href="/about">About 6FigureJobs</a></li>
				<li><a href="/contact">Contact Us</a></li>
				<li><a href="/faq">FAQ</a></li>
				<li><a href="/advertise">Advertise</a></li>
				<li><a href="/privacy">Privacy Policy</a></li>
				<li><a href="/terms">Terms of Use</a></li>
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
 
 $(function(){
    $('#myCarousel').carousel({
      interval: 5000
    });
	
	
});
</script>
<!-- end LeadformixChat code -->

<script type="text/javascript">
	//Google Analytics Code - 05/21/2013
	var _gaq = _gaq || [];
	_gaq.push(['_setAccount', 'UA-214963-1']);
	_gaq.push(['_trackPageview']);
	
	 
	
	(function() {
		var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js';
		var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
	})();
</script>

<!-- Google Code for Remarketing Tag -->
<!--------------------------------------------------
Remarketing tags may not be associated with personally identifiable information or placed on pages related to sensitive categories. See more information and instructions on how to setup the tag on: http://google.com/ads/remarketingsetup
--------------------------------------------------->
<script type="text/javascript">
/* <![CDATA[ */
var google_conversion_id = 970504757;
var google_custom_params = window.google_tag_params;
var google_remarketing_only = true;
/* ]]> */
</script>
<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
</script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="//googleads.g.doubleclick.net/pagead/viewthroughconversion/970504757/?value=0&amp;guid=ON&amp;script=0"/>
</div>
</noscript>
<!-- End: Google Code for Remarketing Tag for Seeker and Recruiter Pages-->

<!-- Google Tag Manager -->
<noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-NCXGSG"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-NCXGSG');</script>
<!-- End Google Tag Manager -->

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

<cfoutput>
	<cfif reFindNoCase("(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino",CGI.HTTP_USER_AGENT) GT 0 OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0>
		<script>$( "##sliderContent" ).load( "api/courseSliderMobile.cfm?category=#courseCategory#" );</script>
	<cfelse>
		<script>$( "##sliderContent" ).load( "api/courseSlider.cfm?category=#courseCategory#" );</script>
	</cfif>
	
</cfoutput>
</body>
</html>
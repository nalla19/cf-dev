<cfsetting showdebugoutput="no">
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
	

</head>

<body class="page-career">
	
<div id="wrap" class="wrap">
	<div class="navbar navbar-inverse" >
			
			<div class="container">
				
				<div class="navbar-inner" id="searchnavbar">
					<!--- If user is logged in, Logo sends them to dashboard and not to "join us" marketing --->
					
					<!--- go live 3/26 --->
					<!--- 
						<a href="/learn365" id="brand" class="brand pull-left">
						<img src="images/learn365/Learn365-PoweredBy6FJ.png" alt="Learn365 logo">
					 --->
					
					<div style="padding-top:20px;width:50%;float:left;">
						<img src="images/learn365/Learn365-SEL.png" alt="Learn365 logo">
					
					</div>
					
						
					
					<div style="padding-top:20px;width:50%;float:right;text-align:right">
						<a href="javascript: window.opener.location.href = '/learn365-signup';window.close();" role="button" class="btn btn-primary btn-small">Start Learning</a> &nbsp;&nbsp;
						<a href="javascript:$('#myModalGoodbye').modal('show');closeWindowMsg();" role="button" class="btn btn-primary btn-small">Exit</a>
					</div>

					
					
					
					<!--/.nav-collapse-->
					
					
					
				</div><!--/.navbar-inner-->
				
			</div><!--/.container-->
			
		</div><!--/.navbar-inverse-->
	
	
	
	<cfoutput>#request.theContent#</cfoutput>
	
	
	

</div><!--/.wrap-->
<div id="myModalGoodbye" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabelGoodbye" aria-hidden="true" >
  <div class="modal-header">
   
    <h3 id="myModalLabelGoodbye">Learn365:  Simply. Everyday. Learning.</h3>
  </div>
  <div class="modal-body" >
  	Please wait for the course to close...
  </div>
  
</div>

<script src="/js/jquery.min.js"></script>
<script src="/js/bootstrap.min.js"></script>
<script src="/js/jquery-ui-1.10.0.custom.min.js"></script>
<script src="/js/Placeholders.min.js"></script>
<script src="/js/script.js?<cfoutput>#application.appVersionNumber#</cfoutput>"></script>

<script>
function closeWindowMsg(){


window.close();
}

</script>

</body>
</html>
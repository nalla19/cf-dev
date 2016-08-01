<cfparam name="request.thePageHTML" default="">

<div class="page-opportunities">

	<header class="page-header">
		<div class="container">
			<a href="career" class="back">Career &raquo;</a>
			<h1 class="page-title">Entrepreneur Opportunities</h1>
			<p class="page-subtitle">Resources and opportunities for your professional growth.</p>
		</div>
	</header>
	
	<article class="section opportunities">
	<cfoutput>#request.thePageHTML#</cfoutput> 
		<!---<cfoutput>#replacenocase(request.thePageHTML,"CPartner.cfm?","#application.v1URL#/CPartner.cfm?rd2=1&","all")#</cfoutput> --->
		<!--- <cfoutput>#replacenocase(request.thePageHTML,"CPartner.cfm?","/entrepreneur-info?rd2=1&","all")#</cfoutput> --->
	</article>
	
</div>
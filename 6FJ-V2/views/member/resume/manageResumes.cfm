<cfparam name="activeTab" default="resume">

<cfif isdefined("url.activeTab")>
	<cfset activeTab=url.activeTab>
</cfif>

<div class="page-companies">
	<article class="section companies well">
		<div class="container">
		<h1 class="page-title">Resume Management</h1>
					<div class="page-spacer"></div>
			<div class="row">
				<div class="span12">
				
					
					<ul class="nav nav-tabs" id="myTab">
					  <li <cfif activeTab EQ "resume">class="active"</cfif>><a href="#resume" data-toggle="tab"><strong>My Resumes</strong></a></li>
					<!---   <li <cfif activeTab EQ "summary">class="active"</cfif>><a href="#summary" data-toggle="tab"><strong>My Executive Summary</strong></a></li> --->
					  <li <cfif activeTab EQ "letters">class="active"</cfif>><a href="#letters" data-toggle="tab"><strong>My Cover Letters</strong></a></li>
					</ul>
					
					<div class="tab-content">
					  <div <cfif activeTab EQ "resume">class="tab-pane active"<cfelse>class="tab-pane"</cfif> id="resume"><cfinclude template="resumeList.cfm"></div>
					<!---   <div <cfif activeTab EQ "summary">class="tab-pane active"<cfelse>class="tab-pane"</cfif> id="summary"><cfinclude template="execSummaryResume.cfm"></div> --->
					  <div <cfif activeTab EQ "letters">class="tab-pane active"<cfelse>class="tab-pane"</cfif> id="letters"><cfinclude template="coverLetter.cfm"></div>
					</div>
				</div>
			</div>
		</div>
	</article>
</div>

<script>
  $(function () {
    $('#myTab a:last').tab('show')
  })
</script>
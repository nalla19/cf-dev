<cfoutput>

<cfparam name="action" default="ques">
<cfparam name="intRestList" default="0">
<cfparam name="intRestDetail" default="0">

<cfswitch expression="#action#">

<cfcase value="cancel">
 <cflocation url="/member-dashboard?#application.strAppAddToken#" addtoken="No">
 <!--- <script lanaguage="javascript">location.href="ExecMyAccount.cfm?#strAppAddToken#";</script> --->
</cfcase>

<cfcase value="reset">
 <cfif (intRestList eq 0) AND (intRestDetail eq 0)>
  <cflocation url="/member-dashboard?#application.strAppAddToken#" addtoken="No">
  <!--- <script lanaguage="javascript">location.href="ExecMyAccount.cfm?#strAppAddToken#";</script> --->
 <cfelseif (intRestList eq 1) AND (intRestDetail eq 1)>
  <cfquery name="cfqUpdCntr" datasource="#application.dsn#">
   update tblResumes set intDetailViews=0, intListViews=0 where intresid=#session.exec.intResID#
  </cfquery>
 <cfelse>
   <cfif (intRestList eq 1)>
    <cfquery name="cfqUpdCntr" datasource="#application.dsn#">
     update tblResumes set intListViews=0 where intresid=#session.exec.intResID#
    </cfquery>
   </cfif>
   <cfif (intRestDetail eq 1)>
    <cfquery name="cfqUpdCntr" datasource="#application.dsn#">
     update tblResumes set intDetailViews=0 where intresid=#session.exec.intResID#
    </cfquery>
   </cfif>
 </cfif>
 <cflock scope="session" timeout="10" type="Exclusive">
  <cfif (intRestList eq 1)>
   <cfset session.EXEC.intListViews=0>
  </cfif>
  <cfif (intRestDetail eq 1)>
   <cfset session.EXEC.intDetailViews=0>
  </cfif>  
 </cflock>
 
<div class="page-companies">
	<article class="section companies well">
		<div class="container">
			<h1>Reset Stats </h1>
			<div class="alert alert-info" id="successMessage">Your resume stat counters have been reset to zero.</div>
		</div>
	</article>
</div>
   
</cfcase>

<cfcase value="ques">
<div class="page-companies">
	<article class="section">
		<div class="container">
				<!--- <div class="row">
					<div class="span12"> --->
						<h1>Reset Stats </h1>
							<form name="frmResetCntes" id="frmResetCntes" action="/member-stats?#application.strAppAddToken#" method="post" role="form" class="form-horizontal">
							<div>Which counter(s) do you wish to reset?</div>
							<div class="page-spacer"></div>
							<div>
							<label class="radio inline">Number of Resume <a href="javascript://" onclick='addwindow=window.open("t_tipsResumeViews.html","popResViews","scrollbars=yes,width=300,height=350,resizable"); return false;'>List Views</a>:</label>
							<label class="radio inline"><input type="radio" name="intRestList" id="" value=0 <cfif intRestList eq 0>checked</cfif>>No</label>
							<label class="radio inline"><input type="radio" name="intRestList" value=1 <cfif intRestList eq 1>checked</cfif>>Yes</label>
								</div>
							<div class="page-spacer"></div>
							<div>
								<label class="radio inline">Number of Resume <a href="javascript://" onclick='addwindow=window.open("t_tipsResumeViews.html","popResViews","scrollbars=yes,width=300,height=350,resizable"); return false;'>Detail Views</a>:</label>
								<label class="radio inline"><input type="radio" name="intRestDetail" value=0 <cfif intRestDetail eq 0>checked</cfif>>No&nbsp;</label>
								<label class="radio inline"><input type="radio" name="intRestDetail" value=1 <cfif intRestDetail eq 1>checked</cfif>>Yes&nbsp;</label>
							</div>
							<div class="page-spacer"></div>
							<div>
							<input class="btn btn-primary btn-large" type="submit" name="action" value="Cancel"> 
							<input class="btn btn-primary btn-large" type="submit" name="action" value="Reset">
							</div>
							</form>
						<!--- </div>
					</div> 
				</div>--->
		</div>
	</article>
</div>
</cfcase>

</cfswitch>


</cfoutput>

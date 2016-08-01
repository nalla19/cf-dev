<!--- check if they are check if they already saw this pop up --->
<cfquery name="qCheckIfSeen" datasource="#application.dsn#">
	select ISNULL(blnLearn365Modal,0) as blnLearn365Modal, fname
	from tblResumes
	where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />
</cfquery>

<!--- check if they are Learn365 --->
<cfif session.EXEC.blnLearn365 EQ 0 AND qCheckIfSeen.blnLearn365Modal EQ 0>

	<div id="myModalL365PopUp" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  <div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="myModalLabel"> Learn365 - Simple. Everyday. Learning.</h3>
	  </div>
	  <div class="modal-body">
		<cfoutput><h2>#qCheckIfSeen.fname#,</h2></cfoutput>
		<p><em>Could your interviewing skills use a polish? Do you feel your negotiation abilities 
are strong enough to get the compensation package you deserve?</em></p>
<p>
6FigureJobs is excited to announce a new premium offering with the launch of Learn365, 
the eLearning solution for business professionals that are career focused like you.
</p>
<p>
Learn365 is the all-you-can consume, self-paced learning video resource that will 
allow you to develop, strengthen, or refresh your interview, negotiation, 
and presentation skills while providing pointers to strengthen your 
brand and develop the career path of your choice!
</p>
<p>
Launching with more than 600 courses, with more to be added each month, you will 
have unlimited access to learn what, where, and when you want.
</p>

		<p><a href="/learn365" onClick="$('#myModalL365PopUp').modal('hide');">Click here</a> to learn more and join today.</p>
		
		<p><a href="" data-dismiss="modal">No Thanks</a></p>
		</p>
		
	  </div>
	  <div class="modal-footer">
		<button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Close</button>
	  </div>
	</div>
	
	<script> 
	$( document ).ready(function() {
	$('#myModalL365PopUp').modal('show');
	});
	</script> 
	
	<cfquery name="qUpdateSeen" datasource="#application.dsn#">
	UPDATE tblResumes
	SET blnLearn365Modal = 1
	where intResID = <cfqueryparam cfsqltype="cf_sql_integer" value="#intResid#" />
</cfquery>
	
</cfif>
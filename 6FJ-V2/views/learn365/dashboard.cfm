<cfif not session.exec.isLearn365Active>
	<cflocation url="/learn365-activate?expireDt=#dateformat(now(),'mm/dd/yyyy')#">
</cfif>

<cfinclude template="api/userCourses.cfm">

<cfquery name="getInProgress" dbtype="query">
 select * from courseQuery
 where course_startdt <> '' and course_complete = 'false'
 order by course_name
</cfquery>
<cfquery name="getComplete" dbtype="query">
 select * from courseQuery
 where course_complete = 'true'
 order by course_name
</cfquery>
<cfquery name="getNew" dbtype="query">
 select * from courseQuery
 where course_complete = 'false'
 order by course_name
</cfquery>

<cfoutput>
	<article class="section companies well">
	<div class="container">
	<h1>Welcome, #session.EXEC.strFirstName#! &nbsp;&nbsp;<a href="" class="btn btn-primary btn-small" data-target="##myModalGetStarted" data-toggle="modal">Get Started</a></h1>
		<div class="page-spacer"></div>
		<div class="row">
			<div class="span12">
				<h3>In Progress Courses</h3>
				<div class="row" >
					<div class="span12" style="max-height:200px;width:90%;overflow-x:hidden;overflow-y:scroll;border:1px solid gray;padding:10px 0px 10px 10px">
						<cfif getInProgress.recordcount EQ 0>
							You have not started any courses! <a href="/learn365-sso" target="_blank">Begin today!</a>
						<cfelse>
							<cfloop query="getInProgress">					
								#course_name# - Started: #dateformat(left(course_startdt,10),"mm/dd/yyyy")#<br><!---  - %Complete: #course_percentage# --->
							</cfloop>
						
						</cfif>
					</div>
				</div>
				
			</div>
		</div>
		<div class="page-spacer"></div>
		<div class="row">
			<div class="span12">
				<h3>Completed Courses</h3>
				<div class="row" >
					<div class="span12" style="max-height:200px;width:90%;overflow-x:hidden;overflow-y:scroll;border:1px solid gray;padding:10px 0px 10px 10px">
						<cfif getComplete.recordcount EQ 0>
							You have not completed any courses! <a href="/learn365-sso" target="_blank">Finish today!</a>
						<cfelse>
							<cfloop query="getComplete">					
							#course_name# - Completed: #dateformat(left(course_completeDt,10),"mm/dd/yyyy")#
						</cfloop>
						
						</cfif>
					</div>
				</div>
			</div>
		</div>
		<div class="page-spacer"></div>
		<div class="row">
			<div class="span12">
				<h3>New Offerings</h3>
				<div class="row" >
					<div class="span12" style="max-height:200px;width:90%;overflow-x:hidden;overflow-y:scroll;border:1px solid gray;padding:10px 0px 10px 10px">
					<cfif getNew.recordcount EQ 0>
						No new offerings.
					<cfelse>
						<cfloop query="getNew">					
						#course_name#<br>
					</cfloop>
					
					</cfif>
					
					</div>
				</div>
			</div>
		</div>
	</div>
	</article>
</cfoutput>

<div id="myModalGetStarted" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">To Get Started...</h3>
  </div>
  <div class="modal-body">
    <cfinclude template="getStarted.cfm">
  </div>
  <div class="modal-footer">
    <button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Close</button>
  </div>
</div>
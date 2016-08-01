<cfsetting showdebugoutput="no">
<cfquery name="getCourse" datasource="#application.dsn#">
SELECT
top 1 
 [courseID]
      ,[courseTitle]
      ,[courseCategory]
      ,[courseSubject]
      ,[blnMobileFriendly]
      ,[courseDesc]
      ,[courseImage]
      ,[courseLanguage]
      ,[blnActive]
      ,[dteActive]
      ,[blnFeatured]
      ,[orderCourseBy]
      ,[blnPremium]
	  ,[coursePreview]
  FROM [EAGLE].[dbo].[tblLearn365Courses]
  where courseID = '#trim(url.course)#'

</cfquery>
<cfoutput query="getCourse">

  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3 id="myModalLabel2">#courseTitle#</h3>
      </div>
      <div class="modal-body" id="myModalBody">
	  	#courseDesc#
		<br><br>
		 <p style="text-align:center "><a href="#coursePreview#" target="_new" class="btn btn-primary btn-small">Launch Course</a></p>
	  </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->

</cfoutput>
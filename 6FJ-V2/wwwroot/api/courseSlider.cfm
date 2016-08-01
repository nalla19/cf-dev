<cfsetting showdebugoutput="no">

<cfquery name="getCourses" datasource="#application.dsn#">
SELECT  [courseID]
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
  FROM [EAGLE].[dbo].[tblLearn365Courses]
  <cfif isdefined("url.category")>
  where courseCategory = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.category#">
  <cfelse>
  	<cfif isdefined("popUpCategory")>
		where courseCategory =#popUpCategory#
	<cfelse>
		where courseCategory =1
	</cfif>
  	
  </cfif>
  and blnActive = 1
order by orderCourseBy
</cfquery>

<cfquery name="getCourseCat" datasource="#application.dsn#">
SELECT [courseCategory_id]
      ,[courseCategory_name]
  FROM [EAGLE].[dbo].[tblLearn365CourseCategory]
  <cfif isdefined("url.category")>
  where courseCategory_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.category#">
  <cfelse>
  	<cfif isdefined("popUpCategory")>
		where courseCategory_id =#popUpCategory#
	<cfelse>
  		where courseCategory_id =1
	</cfif>
  </cfif>
</cfquery>

<cfset tileStart = 0>
<cfset tileCount = 6>
<cfset itemActive = "active">

<cfset rowEnded = 0>
<cfset rowEnded2 = 0>
<cfoutput>
	
	<div class="container">
		<h3>#getCourseCat.courseCategory_name# (#getCourses.recordcount# Courses)</h3>
	</div>
	<!--- start container --->
	<div class="container well2" style="border:1px solid silver; margin: 0 auto;">
	
		<!--- start carousel --->
		<div id="myCarousel2" class="carousel slide" data-pause="onClick" style="margin-top:15px;margin-bottom:15px">
							
			<!--- indicators
			<ol class="carousel-indicators">
				<li data-target="##myCarousel2" data-slide-to="0" class="active"></li>
				<li data-target="##myCarousel2" data-slide-to="1"></li>
				<li data-target="##myCarousel2" data-slide-to="2"></li>
			</ol>
			 --->
			<!--- start inner --->
			<div class="carousel-inner" >
			
				<cfloop query="getCourses">
				
				<cfif rowEnded eq 1>
					<cfset rowEnded = 0>
				
				</cfif>
				<cfif rowEnded2 eq 1>
					<cfset rowEnded2 = 0>
				
				</cfif>
					
					<cfset tileStart = tileStart+1>
					
					<cfif tileStart EQ 1>
					
					<div class="#itemActive# item" >
						<cfset itemActive = "">
					</cfif>
									
					<cfif tileStart EQ 1 or tileStart EQ 4>
						<div class="page-spacer span12"></div>
						<div class="row" style="float:left;margin-left:10px; ">
					</cfif>
							<div class="span4" style="border:1px solid ##cccccc; text-align:center;max-width:255px; background-color:##FFF;">
								<div style="padding-top:10px">
									<img src="#courseImage#" style="height:119px; width:auto;">
								</div>
								<div>
									<h5 style="text-align:center">
									<cfset courseTitle2 = REReplaceNoCase(courseTitle,"Career Development:","","all")>
									<cfset courseTitle2 = REReplaceNoCase(courseTitle2,"Competency Development:","","all")>
									<cfset courseTitle2 = REReplaceNoCase(courseTitle2,"Onboarding:","","all")>
									<cfset courseTitle2 = REReplaceNoCase(courseTitle2,"Project Management:","","all")>
									<cfset courseTitle2 = REReplaceNoCase(courseTitle2,"Writing to Get Things Done:","","all")>
									<cfset courseTitle2 = REReplaceNoCase(courseTitle2,"Engagement and Retention:","","all")>
									
									<cfif len(trim(courseTitle2)) GT 30>
										#left(trim(courseTitle2),30)#...
									<cfelse>
										#trim(courseTitle2)#
									</cfif>
									
									
									</h5>
								</div>
								<div>
									
									<cfif isdefined("popUpCategory")>
										<p style="text-align:center "><a href="#application.url#/learn365-course?courseid=#courseID#" class="btn btn-primary btn-small" role="button" >Preview</a></p>
									<cfelse>
										<p style="text-align:center "><a href="#application.url#/learn365-course?courseid=#courseID#" target="_blank" class="btn btn-primary btn-small" role="button" >Preview</a></p>
									</cfif>
								</div>
							</div>
					
					<cfif tileStart EQ 3 or tileStart EQ 6>
						
						</div>
						
						<div class="page-spacer span12"></div>
						<cfset rowEnded =1>
					</cfif>
					
					
					<cfif tileStart EQ 6>
						
						</div>
						<cfset tileStart = 0>
						<cfset rowEnded2 =1>
					</cfif>
					
				</cfloop>
				
				<!--- cfif courses are not even, close out anything that was left open --->						
				<cfif rowEnded EQ 0>
					</div>
					
					</div>
					
					<cfset rowEnded2 = 1>
				</cfif>
				<cfif rowEnded2 EQ 0>
					</div>
					
				</cfif>
			<!--- end inner --->
			</div>  
			<!-- END Carousel items -->
			<!-- Carousel nav -->
			<a class="carousel-control left" href="##myCarousel2" data-slide="prev" style="margin-top:25px;margin-left:-15px">&lsaquo;</a>
			<a class="carousel-control right" href="##myCarousel2" data-slide="next" style="margin-top:25px;margin-right:-15px">&rsaquo;</a>
			
				
		<!--- end carousel --->
		</div>
			
	<!--- end container --->
	
	</div>
	<cfif not isdefined("popUpCategory")>
		<div class="container">
			<div class="page-spacer span12"></div>
			<div class="row>
				<div class="span12" style="text-align:center">
					<a href="/learn365-signup" role="button" class="btn btn-primary btn-small" style="margin:0 auto">Join Learn365 Today</a>
				</div>
			</div>
		</div>
	</cfif>
</cfoutput>

<script language="javascript" type="text/javascript">
<!--
function popitup(url) {
	newwindow=window.open(url,'name','height=800,width=800,scrollbars=1');
	if (window.focus) {newwindow.focus()}
	return false;
}

// -->
</script>

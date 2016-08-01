<cfquery name="getCourses" datasource="#application.dsn#">
SELECT
top 30
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
      ,[orderBy]
      ,[blnPremium]
  FROM [EAGLE].[dbo].[tblLearn365Courses]

</cfquery>

<cfset tileStart = 0>
<cfset tileCount = 6>
<cfset itemActive = "active">

<cfoutput>
<article class="section quotes well">
	<div class="container" style="border:1px solid silver;">
		<div class="row" >
			<div class="span12">
				<div id="myCarousel2" class="carousel slide" style="border:0px solid yellow;">
					<ol class="carousel-indicators">
						<li data-target="##myCarousel2" data-slide-to="0" class="active"></li>
						<li data-target="##myCarousel2" data-slide-to="1"></li>
						<li data-target="##myCarousel2" data-slide-to="2"></li>
					</ol>
					<!-- Carousel items -->
					<div class="carousel-inner" >
						<cfloop query="getCourses">
							<cfset tileStart = tileStart+1>
							<cfif tileStart EQ 1>
								<div class="#itemActive# item" >
								<cfset itemActive = "">
							</cfif>
											
							<cfif tileStart EQ 1 or tileStart EQ 4>
								<div class="page-spacer span12"></div>
								<div class="row">
							</cfif>
									<div class="span4" style="border:0px solid yellow; text-align:center">
									
											  <img src="#courseImage#">
											 <h5 style="text-align:center">#courseTitle#</h5>
											   <cfif request.showButtons>
											  <p style="text-align:center "><button data-target="##myModal3" type="button" class="btn  btn-primary btn-small" data-toggle="modal">Learn More</button></p>
											  </cfif>
											
									</div>
							
							<cfif tileStart EQ 3 or tileStart EQ 6>
								</div>
								
								<div class="page-spacer span12"></div>
							</cfif>
							<cfif tileStart EQ 6>
								</div>
								<cfset tileStart = 0>
							</cfif>
						</cfloop>
						
					</div>  
					<!-- END Carousel items -->
					<!-- Carousel nav -->
					<a class="carousel-control left" href="##myCarousel2" data-slide="prev">&lsaquo;</a>
					<a class="carousel-control right" href="##myCarousel2" data-slide="next">&rsaquo;</a>
				</div>
			</div>
		</div>
	</div>
</article>
</cfoutput>

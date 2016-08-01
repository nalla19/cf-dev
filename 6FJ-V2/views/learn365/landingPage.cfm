<cfif isdefined("url.apitest")>
<cfinclude template="apiTesting.cfm">
<cfabort>
</cfif>
<cfoutput>

<section style="overflow:hidden;height:526px;background-size:cover;border-bottom:10px solid ##E1E1E1;">
	<div  style="border-bottom: 3px solid rgb(201, 201, 201); position:relative">						
		<div id="myCarousel" class="carousel carousel2 slide" style="border:0px solid yellow;">
			<ol class="carousel-indicators">
				<li data-target="##myCarousel" data-slide-to="0" class="active"></li>
				<li data-target="##myCarousel" data-slide-to="1"></li>
				<li data-target="##myCarousel" data-slide-to="2"></li>
			</ol>
			<!-- Carousel items -->
			<div class="carousel-inner">
				<!--- item1 --->
				<div class="active item">
					<div class="fill" style="background-image:url('images/learn365/learn365-slider3.png');">					  										
						<div class="container" style="height:100%;position:relative;">
							<div class="slider2b" style="float:left;max-width:425px">
								Simple Everyday Learning.<br>
								<span style="font-size:20px">Everday learning for Business Professionals</span>
								<div class="page-spacer"></div>
								<div class="page-spacer"></div>
								<div style="text-align:center">
									<a href="/learn365-signup" role="button" class="btn btn-primary btn-medium" title="Join Learn365 Today">Join Learn365 Today</a>
									<!--- <button data-target="##myModal7" type="button" class="btn  btn-primary" data-toggle="modal">Coming Soon!</button> --->
								</div>
							</div>
						</div>
					</div>
				</div>
				<!--- item2 --->
				<div class="item">
					<div class="fill" style="background-image:url('images/learn365/learn365-slider2.png');">					  										
						<div class="container" style="height:100%;position:relative;">
							<div class="slider2b" style="float:left;max-width:425px">
								Be Inspired!
								<br>
								<span style="font-size:20px">Learn from thought leaders with business world experience</span>
								<div class="page-spacer"></div>
								<div class="page-spacer"></div>
								<div style="text-align:center">
									<a href="/learn365-signup" role="button" class="btn btn-primary btn-medium" title="Join Learn365 Today">Join Learn365 Today</a>
									<!--- <button data-target="##myModal7" type="button" class="btn  btn-primary" data-toggle="modal">Coming Soon!</button> --->
								</div>
							</div>
						</div>
					</div>
				</div>
				<!--- item3 --->
				<div class="item">
					<div class="fill" style="background-image:url('images/learn365/learn365-slider1.png');">					  										
						<div class="container" style="height:100%;position:relative;">
							<div class="slider2b" style="float:left;max-width:425px">
								Learn a new skill or take a skill to the next level.
								<br><span style="font-size:20px">Open new doors for your career</span>
								<div class="page-spacer"></div>
								<div class="page-spacer"></div>
								<div style="text-align:center">
									<a href="/learn365-signup" role="button" class="btn btn-primary btn-medium" title="Join Learn365 Today">Join Learn365 Today</a>
									<!--- <button data-target="##myModal7" type="button" class="btn  btn-primary" data-toggle="modal">Coming Soon!</button> --->
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>  
			<!-- END Carousel items -->
			<!-- Carousel nav -->
			<a class="carousel-control left" href="##myCarousel" data-slide="prev">&lsaquo;</a>
			<a class="carousel-control right" href="##myCarousel" data-slide="next">&rsaquo;</a>
		</div>
		
		<div class="container" style="height:100%;position:relative;">
			<div style="position:absolute;bottom:0;right:0;">
				<img src="images/learn365/learn365-tablet.png" alt="Learn365 on the go" align="right" style="width:80%;vertical-align:middle">
			</div> 
		</div>
	</div>
</section>	
</cfoutput>
<cfinclude template="membershipDetails.cfm">

<!--- course slider start --->
<a name="courses" class="anchorFix"></a>
<article class="section quotes well" id="sliderContent">
	
	
</article>

<!--- course slider modal --->
<div id="myModalCourse" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2" aria-hidden="true">
		
</div>



<!--- course slider end --->




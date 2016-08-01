
<cfif isdefined("session.EXEC.blnLearn365") and session.EXEC.blnLearn365>
							
		<input type="hidden" name="blnLearn365" value="0">
<cfelse>
		<cfoutput>
		<div class="page-spacer"><!--//--></div> 
		<div class="well3">
			<div class="row-fluid">
				<div class="span12" style="text-align:center ">
				<h2>eLearning solution for business professionals that are career focused like you</h2>
				</div>
			</div>
			<div class="page-spacer"><!--//--></div> 
			<div class="row-fluid">
				<div class="span6" style="padding-left:10px; text-align:center">
					
						<div style="text-align:center; background-color:##1f0845;max-width:275px;height:220px;margin:0 auto;padding:10px 10px 10px 10px;">
						  <div style="vertical-align:middle;margin-top:55px">
						  <img src="/images/learn365/Learn365-SEL.png">
						  <h2 style="color:##FFFFFF;">$19.95</h2>
						  <p style="color:##FFFFFF; line-height:5px">PER MONTH</p>
						   <p style="color:##FFFFFF; margin-top:-15px;font-size:12px">Cancel anytime</p>
						  </div>
						</div>
						<div class="page-spacer"><!--//--></div> 
						<div style="text-align:center;">
							<a href="##" data-target="##myModal22" data-toggle="modal" class="btn btn-primary btn-small" role="button">Learn More</a>
						</div>
				
				</div>
				
				<div class="span6 membershiprightdetails" style="padding-right:10px">
					<ul class="styled" style="list-style:circle;margin-left:0px">
						<li><b>25 Career focused courses</b>, with focus on interview skills, negotiations, your brand, career path, and more!</li>
						<li><b>600+ additional</b> business focused courses, with new courses added monthly</li>
						<li><b>Unlimited access</b> to learn what, where, and when you want</li>
						<li><b>Learn from experts</b>, thought leaders, researchers, certified trainers</li>
						<li><b>6FigureJobs Profile Highlight</b> skills and learning accomplishments to recruiters</li>
					</ul>
					<label class="radio inline" style="font-size:20px"><input tabindex="23" type="radio" name="blnLearn365" id="blnLearn365" value="1" onClick="document.getElementById('blnLearn365ErrTxt').style.color = '';" <cfif isDefined('blnLearn365')>checked</cfif>><strong><u>Sign me up!</u></strong>&nbsp;</label>
					<label class="radio inline" style="font-size:20px"><input tabindex="24" type="radio" name="blnLearn365" id="blnLearn365" value="0" onClick="document.getElementById('blnLearn365ErrTxt').style.color = '';"><strong>No thanks.</strong></label>
							
				</div>
			</div>
			<div class="page-spacer"><!--//--></div>
			
		</div>
		
		
		
		<div class="page-spacer"><!--//--></div>
		</cfoutput>
<div id="myModal22" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" >
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Learn365:  Simply. Everyday. Learning.</h3>
  </div>
  <div class="modal-body" >
  	<p>Learn365 is the all-you-can consume learning video resource that will allow you 
	to develop, strengthen, or refresh your interview, negotiation, and presentation skills
	while providing pointers to strengthen your brand and develop the career path of your choice!
	Create new opportunities. Open new doors for your career. </p>
	
	<p>Learn a new design or technical skill every day.  Take a leadership, strategy, or selling skill to the next level. 
	Be Inspired!  </p>
	
	<p>Unlimited Access to our entire library, with new courses added each month. If you're not satisfied, cancel at any time.</p>
	
	<p>Learn365 - Simple. Everyday. Learning.</p>
	<h4>2 of 25 Career Focused Videos</h4>
	<div style="width:100%"> 
		<div style="border:1px solid #cccccc; text-align:center;width:49%; background-color:#FFF;float:left">
			<div style="padding-top:10px">
				<img src="https://www.opensesame.com/courseimage/5101c3ac-0c22-3510-1c3a-c0c22a070050" style="height:119px; width:auto;">
			</div>
			<div>
				<h5 style="text-align:center">Interviewing Skills 101</h5>
			</div>
		</div>
		<div style="border:1px solid #cccccc; text-align:center;width:49%; background-color:#FFF;float:right;">
			<div style="padding-top:10px">
				<img src="https://www.opensesame.com/courseimage/4ef3a853-0482-54ef-3a85-30482b962002" style="height:119px; width:auto;">
			</div>
			<div>
				<h5 style="text-align:center">Negotiating and Starting Right</h5>
			</div>
		</div>
	</div> 
 	<div style="width:100%;"> 
  		<button class="btn btn-primary" data-dismiss="modal" aria-hidden="true" style="float:right;margin-top:10px;margin-bottom:10px;">Close</button>
	</div>
	
  </div>
</div>

</cfif>

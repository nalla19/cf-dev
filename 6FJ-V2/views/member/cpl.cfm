<!--- <cfabort> --->
<cfparam name="request.thePageTitle" default="6FigureJobs Professional Registration">
<cfparam name="request.thePageDescription" default="">
<cfparam name="request.thePageKeywords" default="">
<cfparam name="request.thePageGoogleVer" default="">
<cfparam name="request.thePageCSS" default="page-home.css">
<cfparam name="request.signinactivetab" default="">
<cfparam name="request.ldfxtrackingtag" default="true">
<cfparam name="request.theContent" default="">
<cfparam name="request.act" default="">
<cfparam name="request.showstep3" default="1">
<cfparam name="url.act" default="">

<!--- Default is false for LinkedIn user --->
<cfparam name="url.liuser" default="false">

<cfscript>
//Get the decrypted intResID
intResID = session.exec.intresid;
resDetails = application.registration.cfqGetFullResDetails(intResID);
</cfscript>

<cfinclude template="cplVariables.cfm">

<cfif isdefined("form.fieldnames")>
    <cfinclude template="processcpl.cfm">
</cfif>

<script language="javascript">
function disableCPLRow(el){
	alert(el);	
}
</script>

<cfoutput>	

<form name="execCPLs" id="execCPLs" method="post" enctype="multipart/form-data" action="/member-cpl" onSubmit="return checkform4();">
<div class="page-dashboard">
	<article class="section companies well">
		<div class="container">
			<div class="span12">
				<div class="row">
					<h1 class="page-title">Welcome #session.EXEC.strFirstName#!</h1>
					<h2 class="page-subtitle">
					Before we take you to your Account Dashboard, please take a moment to review some opportunities we thought may be of interest to you.
					<div class="page-spacer"><!--//--></div>
					<div class="page-spacer"><!--//--></div>
					</h2>
					
					<section>
						<div class="row-fluid">	
							<div class="span12 alert alert-error" id="errorDiv" style="color:##F00; display:none;">
			                	<strong>Warning!</strong> Please complete the fields below highlighted in red.
							</div>
						</div>
						
					
						<!---Executive Resume Critique--->
						<div class="row-fluid">
							<div class="span8">
								<h2>Free Executive Resume Critique</h2>
							</div>
						</div>
						
						<cfif application.sourceApp NEQ "SalesStars">
							<div class="row-fluid">
							
								<div class="span9">
									<!--- Would you like a Free executive resume critique to help you stand out to recruiters? --->
									<div id="blnResCritiqueErrTxt">Need help writing a strong, executive-styled resume? Or want a free, professional resume critique from our resume writing partner?</div>
								</div>
							
							
								<div class="span3 text-center">
									<label class="radio inline"><input name="freeResumeCritique" type="radio" id="freeResumeCritiqueYes" value="1" >Yes</label> &nbsp;
					               	<label class="radio inline"><input name="freeResumeCritique" type="radio" id="freeResumeCritiqueNo"value="0" >No</label>
								</div>
							
								<div style="clear:both;"></div>
		                        <div class="divider">&nbsp;</div>
							
							</div>
													
							<div class="page-spacer"><!--//--></div>
						</cfif>						
							
						
						<div class="row-fluid">
							<div class="span8">
								<h2>Entrepreneur Opportunites</h2>
							</div>
							
							<div id="showNonEduToggle" style="display:none;">
                   				<div class="span11" style="text-align:right;">
		                	    	<a href="javascript:void;" id="showNonEduCPLs">Show Hidden</a>
		             	       	</div>
			                </div>
						</div>
							
						<!--- Entrepreneur Slot Begin --->
						<cfloop query="cfqGetNonEduCPLs">
               				<!---START: #intMemberID#--->
			         		<div class="row-fluid" id="#intMemberID#Row">
			                	<div class="span2" style="text-align:center; padding-top:20px;">
		    	                   <!--- Logo --->
		        	               <img src="/images/cpls/#cfqGetNonEduCPLs.strImageName#">
			                    </div>  
                   				
								<div class="span7">
			                        <!--- Header --->
			                        <h4>#cfqGetNonEduCPLs.strTitle#</h4>
				                    <!--- Description --->
			                        #cfqGetNonEduCPLs.strHTMLTxt#
			                   	</div>
               					
								<div class="span3 text-center">
                       				<div id="bln#intMemberID#ErrTxt">Request More Info</div>
		                       		<cfset variableName="bln#intMemberID#">
		                           	<cfif listFind(intCPLCustomQuestionList,intMemberID)>
			                      		<label class="radio inline"><input name="#variableName#" onClick="customcpl('#intMemberID#','#intMemberID#'); document.getElementById('bln#intMemberID#ErrTxt').style.color=''; <cfif len(strDisclaimerTxt)>document.getElementById('disclaimer#intMemberID#').style.display='block';</cfif>" type="radio"  id="#variableName#Yes" value="1" <cfif #variableName# eq 1> checked </cfif>>Yes</label> &nbsp;
			                            <label class="radio inline"><input name="#variableName#" type="radio" id="#variableName#No" onclick="document.getElementById('bln#intMemberID#ErrTxt').style.color=''; <cfif len(strDisclaimerTxt)>document.getElementById('disclaimer#intMemberID#').style.display='none';</cfif>" value="0" <cfif #variableName# eq 0> checked </cfif>>No</label>
		                            <cfelse>
			                            <label class="radio inline"><input name="#variableName#" type="radio" id="#variableName#Yes" onclick="document.getElementById('bln#intMemberID#ErrTxt').style.color=''; <cfif len(strDisclaimerTxt)>document.getElementById('disclaimer#intMemberID#').style.display='block';</cfif>" value="1" <cfif #variableName# eq 1> checked </cfif>>Yes</label>&nbsp;
			                            <label class="radio inline"><input name="#variableName#" type="radio" id="#variableName#No" onclick="document.getElementById('bln#intMemberID#ErrTxt').style.color=''; <cfif len(strDisclaimerTxt)>document.getElementById('disclaimer#intMemberID#').style.display='none';</cfif>" value="0" <cfif #variableName# eq 0> checked </cfif>>No</label>
		                            </cfif>
									<br>
			
									<cfif len(strDisclaimerTxt)>
										<br />
										<span id="disclaimer#intMemberID#" style="text-align:left; display:none; font-size:12px;">#strDisclaimerTxt#</span>
									</cfif>
                   				</div>
			                    <div style="clear:both;"></div>
			                    <div class="divider">&nbsp;</div>
				                <input type="hidden" name="#intMemberID#" value="1"> 
			                </div>
			                <!--- END: #intMemberID#--->
               			</cfloop>
						<!--- Entrepreneur Slot End --->
						<div class="page-spacer"><!--//--></div>
						
						<!--- Continuing Education Opportunities Start--->
						<cfif cfqGetEduCPLs.recordcount gt 0>
							<div class="row-fluid">
								<div class="span8">
									<h2>Continuing Education Opportunities</h2>
								</div>
							
								<div class="row" id="showEduToggle" style="display:none;">
                       				<div class="span11" style="text-align:right;">
                           				<a href="javascript:void;" id="showEduCPLs">Show Hidden</a>
                       				</div>
                   				</div>
							</div>
							
							 <!--- Education Slot Begim --->
                   			<cfloop query="cfqGetEduCPLs">
                   				<!---START: #intMemberID# --->
			                    <div class="row-fluid" id="#intMemberID#Row">
               				        <div class="span2" style="text-align:center;">
			                           <!--- Logo --->
			                           <img src="/images/Education/#cfqGetEduCPLs.strImageName#">
			                        </div>  
               				
							        <div class="span7">
                           				<!--- Header --->
			                            <h4>#cfqGetEduCPLs.strTitle#</h4>
			                            <!--- Description --->
			                            #cfqGetEduCPLs.strHTMLTxt#
               				        </div>
                       				
									<div class="span3 text-center">
                           				
			                            <div id="bln#intMemberID#ErrTxt">Request More Info</div>
			                            <cfset variableName="bln#intMemberID#">
			                            <cfif listFind(intCPLCustomQuestionList,intMemberID)>
				                        	<label class="radio inline"><input name="#variableName#" onClick="customcpl('#intMemberID#','#intMemberID#');  document.getElementById('bln#intMemberID#ErrTxt').style.color=''; <cfif len(strDisclaimerTxt)>document.getElementById('disclaimer#intMemberID#').style.display='block';</cfif>"  type="radio" id="#variableName#Yes" value="1" <cfif #variableName# eq 1> checked </cfif>>Yes</label> &nbsp;
				                            <label class="radio inline"><input name="#variableName#" type="radio" id="#variableName#No" onclick="document.getElementById('bln#intMemberID#ErrTxt').style.color=''; <cfif len(strDisclaimerTxt)>document.getElementById('disclaimer#intMemberID#').style.display='none';</cfif>" value="0" <cfif #variableName# eq 0> checked </cfif>>No</label>
			                           	<cfelse>
				                        	<label class="radio inline"><input name="#variableName#" type="radio" id="#variableName#Yes" onclick="document.getElementById('bln#intMemberID#ErrTxt').style.color=''; <cfif len(strDisclaimerTxt)>document.getElementById('disclaimer#intMemberID#').style.display='block';</cfif>" value="1" <cfif #variableName# eq 1> checked </cfif>>Yes</label> &nbsp;
				                            <label class="radio inline"><input name="#variableName#" type="radio" id="#variableName#No" onclick="document.getElementById('bln#intMemberID#ErrTxt').style.color=''; <cfif len(strDisclaimerTxt)>document.getElementById('disclaimer#intMemberID#').style.display='none';</cfif>" value="0" <cfif #variableName# eq 0> checked </cfif>>No</label>
			                            </cfif>                 
			                            
										<cfif len(strDisclaimerTxt)>
											<br />
											<span id="disclaimer#intMemberID#" style="text-align:left; display:none; font-size:12px;">#strDisclaimerTxt#</span>
										</cfif>
			                        </div>
			                        <div style="clear:both;"></div>
			                        <div class="divider">&nbsp;</div>
			                        <input type="hidden" name="#intMemberID#" id="#intMemberID#" value="1">
			                    </div>
			                    <!---END: #intMemberID# --->
                   			</cfloop>
						</cfif>
						<!--- Continuing Education Opportunities End--->
						
						<div class="page-spacer"><!--//--></div>
               			
						<div class="row-fluid">
							<div class="span12">
								<div  style="text-align:left ">
    			           			<input class="btn btn-primary btn-large" type="submit" name="validate" id="submitBtn" value="CONTINUE"></div>
								</div>
								<div class="page-spacer"><!--//--></div>
			               	</div>
						<div class="page-spacer"><!--//--></div>
						<div class="page-spacer"><!--//--></div>
																				
					</section>
				</div>
			</div>
		</div>
	</article>
</div>	
</form>	
	
<script>
var hiddenNonEduCPLs = 0;
var hiddenEduCPLs = 0;
</script>

</cfoutput>

<script type="text/javascript">
//Google Analytics Code - 05/21/2013
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-214963-1']);
_gaq.push(['_trackPageview']);

(function() {
	var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
</script>

<cfparam name="request.thePageTitle" default="6FigureJobs Professional Registration">
<cfparam name="request.thePageDescription" default="">
<cfparam name="request.thePageKeywords" default="">
<cfparam name="request.thePageGoogleVer" default="">
<cfparam name="request.thePageCSS" default="page-home.css">
<cfparam name="request.signinactivetab" default="">
<cfparam name="request.ldfxtrackingtag" default="true">
<cfparam name="request.theContent" default="">
<cfparam name="request.act" default="">
<cfparam name="request.resumeuploaded" default="false">
<cfparam name="url.message" default="">
<cfparam name="url.messagecode" default="">
<cfparam name="url.act" default="">

<!---Name of the tracking source --->
<cfparam name="request.strTrackingName" default="">

<!--- Default is false for LinkedIn user --->
<cfparam name="url.liuser" default="false">


<script language="javascript1.2">
function salesStarsBtn(){
	if (document.forms[0].salesStarsChkBox.checked){
        document.getElementById("salestarsBtn").disabled = false;
    }else if (!document.forms[0].salesStarsChkBox.checked){
		document.getElementById("salestarsBtn").disabled = true;
    }   
}

function createSSAccount(resId){
	var fbURL="createSalesStarsAccount.cfm?Fy4ZT9ZUv="+resId;
	$.ajax({
    	url: fbURL+"&callback=?",
	    data: "message=",
	    type: 'POST',
	    success: function (resp) {
	   		//alert(resp);
			document.getElementById('salesStarsInvite').style.display = 'none';
			document.getElementById('salesStarsInviteConf').style.display = 'block';
	    },
	    error: function(e) {
	        //alert('Error: '+e);
	    }  
	});
}

function checkResumeUpload(){
	var errormsg = '';
 	var errNum=0;
		
	if (document.getElementById('resumeFile').value == ''){
		document.getElementById('resumeUploadDiv').style.display = "block";
		errNum+=1;
		return false;
	} else{
		document.getElementById('resumeUploadDiv').style.display = "none";
	}
		
		
	if (errNum > 0){
  		return false ;
 	}else{
		document.getElementById('resUploadSubmitBtn').disabled=true;
		return true ;
  	}
}
</script>



<cfscript>
//Get the decrypted intResID
intResID = application.registration.getDecryptedResID(url.Fy4ZT9ZUv);
resDetails = application.registration.cfqGetFullResDetails(intResID);
resUploadCnt = application.registration.cfqGetResUploadCnt(intResID);
</cfscript>

<cfif resUploadCnt is 1>
	<cfset request.resumeuploaded = true>
</cfif>

<cfoutput>
<cfif reFindNoCase("android.+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od|ad)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino",CGI.HTTP_USER_AGENT) GT 0 OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0>
	<cfset mobile = true>
<cfelse>
	<cfset mobile = false>
</cfif>

<cfif isDefined("cookie.sixFJResTracker") and cookie.sixFJResTracker neq "">
	<!---Get the Tracking code details--->
	<cfquery name="request.tracking" datasource="#application.dsn#">
	select intTrackingID, strTrackCode, strName from tblHowFindTracking (nolock) where strTrackCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cookie.sixFJResTracker#">
	</cfquery>
	<cfif len(request.tracking.strName)>
		<cfset request.strTrackingName = request.tracking.strName>
	</cfif>
</cfif>

<!---Put the ZipRecruiter Conversion Tracking Pixel--->
<cfif request.strTrackingName is "ZipRecruiter">
	<img src="https://track.ziprecruiter.com/conversion?board=6figurejobs_cpc" width="1" height="1"/>
</cfif>


<cfif isDefined("form.fieldnames")>
	<cfif isDefined("form.section") and form.section is "resumeUpload">
		<cfinclude template="resumeUpload.cfm">
	</cfif>
</cfif>
	
	<div class="page-dashboard">
		<article class="section companies well">
			<div class="container">
				<div class="span12">
					
					<div class="row">
						<h1 class="page-title">Thank you for registering!</h1>
						<h2 class="page-subtitle">Your 6FigureJobs Membership is now pending approval.</h2>
						
						<cfif mobile>
							
							<!--- Conformation Message --->                
		         			<div class="row-fluid">
							
		               			<div class="span12">		
									<cfif application.sourceApp NEQ "SalesStars">
			                   		<span class="label label-info">PLEASE NOTE</span> We pre-screen all registrations to ensure professionals meet the work experience & compensation requirements employers expect to see when using #application.sourceApp# to source candidates.<br><br>
			                    	We will contact you by email within 1 business day. Once you are approved, you will be able to log into your account with full access.<br><br>
									</cfif>
		                    		<span class="label label-important">IMPORTANT</span> Be sure to check your inbox or junk folder for our confirmation emails.
									
		                    	</div>
								
		                	</div>
							<cfif isdefined("url.learn365")>
								<div class="row-fluid">
								
									<div class="span12 well3">		
									Thank you for joining Learn365.
									<p>Learn365 strives to be your daily go-to for developing, strengthening, or refreshing a skill to create 
									new opportunities or open new doors for your career, or generally to inspire new ideas.
									</p>
									<p>
									While you wait on your 6FigureJobs membership, please <a href="/learn365-dashboard">click here</a> to begin taking advantage of Learn365.
									</p>
									</div>
									
								</div>
							<cfelse>
								<div class="well3 relocation span12" style="background:##E4DFE6;">		
									<div class="span3">
										<div style="text-align:center; background-color:##1f0845;width:200px;height:200px;margin:0 auto;margin-top:10px;padding:10px 10px 10px 10px;">
										  <div style="vertical-align:middle;margin-top:45px">
										  <img src="/images/learn365/Learn365-SEL.png">
										  <h3 style="color:##FFFFFF;">$19.95</h3>
										  <p style="color:##FFFFFF; line-height:5px">PER MONTH</p>
										   <p style="color:##FFFFFF; margin-top:-15px;font-size:12px">Cancel anytime</p>
										  </div>
										</div>
									</div>
									<div class="span9">
										<h4>Are you prepared to begin interviewing? Could you use a few pointers or suggestions to try?</h4>
										<p>
										Do you feel your negotiation abilities are strong enough to get the compensation package you deserve?</p>
										<p style="margin-top:-15px">
										6FigureJobs is your go-to career resource. 
										We're excited to announce <b>Learn365, the new eLearning solution 
										for business professionals that are career focused like you!</b></p>
										<p style="margin-top:-15px">
										<b>Learn at your own pace through self-guided courses</b> taught by experts, thought leaders, researchers, and certified 
										trainers covering topics such as career, leadership, strategy, selling, as well as design and technical skills.
										</p>
										<p>
										 <a href="/learn365-dashboard" target="_blank">Click here</a> to learn more and preview our growing course catalog!
										</p>
									</div>
								</div>
							</cfif>
						
						<cfelse>
												
							<!--- Conformation Message --->                
		         			<div class="row-fluid">
								
								<div class="relocation span5">
									<h3>Have Your R&eacute;sum&eacute; Handy?</h3>
									<cfif resDetails.blnsearchable is 1>
										You can upload it now to make your profile complete. And so you can apply to jobs and be searched by recruiters.
									<cfelse>
										You can upload it now to make your profile complete. And so you can easily apply to jobs.
									</cfif>
									
									<cfif request.resumeuploaded>
										<div class="spacer"></div>
										<h4 style="color:##3c763d;">Resume Uploaded Successfully!!!</h4>
										<div class="push"><!--//--></div>
									<cfelse>
										<cfif url.messagecode is 1>
											<div class="alert alert-error">
											#URL.message#
											</div>
										<cfelseif url.messagecode is 0>
											<div class="alert alert-error">We could not process the information submitted. Please try again.</div>
										</cfif>
								
										<h6>Microsoft Word or PDF files only.</h6>
										<div class="spacer"></div>
										<form name="myAccountResumeUpload" id="myAccountResumeUpload"  action="/join-thank-you?Fy4ZT9ZUv=#urlencodedformat(Fy4ZT9ZUv)#" method="post" enctype="multipart/form-data" onSubmit="return checkResumeUpload();">
										<input type="hidden" name="section" value="resumeUpload" />
										<input name="resumeFile" value="" type="file" size="35" id="resumeFile"  />
										<h5><div id="resumeUploadDiv" style="color:##F00; display:none;"><strong>Please select a resume to upload to continue.</strong></div></h5>
										<div style="padding-bottom:10px;"><!--//--></div>
										<input class="btn btn-primary" type="submit" name="validate" id="resUploadSubmitBtn" value="Upload Resume">
										</form>										
									</cfif>
								</div>
								<div class="span7" style="margin-top: 20px;margin-right: -15px;">		
									<cfif application.sourceApp NEQ "SalesStars">
									<div class="push"><!--//--></div>
									<span class="label label-info">PLEASE NOTE</span> We pre-screen all registrations to ensure professionals meet the work experience & compensation requirements employers expect to see when using #application.sourceApp# to source candidates.<br><br>
									We will contact you by email within 1 business day. Once you are approved, you will be able to log into your account with full access.<br><br>
									</cfif>
									<span class="label label-important">IMPORTANT</span> Check your inbox or junk folder for our confirmation emails.
									<br><br>
									<cfif isDefined("session.exec.jaQintJobID") and session.exec.jaQintJobID neq "">
										<cfquery name="cfqGetJobDet" datasource="#application.dsn#">
										select title, jpname 
										from tblJobs (nolock) 
										where intJobID = #session.exec.jaQintJobID#
										</cfquery>
										<cfset jobTitle = cfqGetJobDet.title>
							   
										<form action="/member-login?100k=1&start1=0&pgNo=1&intJobID=#session.exec.jaQintJobID#&blnVisit=1&sort=date_submitted&sortorder=desc" method="post" name="ExecmainLogin">
										<input type="hidden" name="strCaller" value="execOneClickApply">
										<input type="hidden" name="strUsername" size="35" value="#trim(resDetails.username)#">
										<input type="hidden" name="strPassword" size="35" value="#trim(resDetails.password)#">
										</form>                          
										<h4><a href="##"  onclick="document.ExecmainLogin.submit();"><div class="btn btn-primary">Apply to the Job</div>&nbsp;&nbsp;#jobTitle#</a></h4>                    
									<cfelse>
										<h4><a href="/member-login?strUsername=#trim(resDetails.username)#&strPassword=#trim(resDetails.password)#"><u>Search $100K+ Jobs</u></a></h4>
									</cfif>
								</div>
								
							</div>
							<div class="row-fluid">
							<cfif isdefined("url.learn365")>
								
								<div class="well3 relocation span12" style="background:##E4DFE6;">
									<!--- thank you for joing 6FJ & L365 --->
									<div class="span3">
										<div style="text-align:center; background-color:##1f0845;width:200px;height:150px;margin:0 auto;margin-top:10px;padding:10px 10px 10px 10px;">
										  <div style="vertical-align:middle;margin-top:50px">
										  <img src="/images/learn365/Learn365-SEL.png">
										 
										  </div>
										</div>
									</div>
									<div class="span9">	
										<h3>Thank you for joining Learn365.</h3>
										<p>Learn365 strives to be your daily go-to for developing, strengthening, or refreshing a skill to create 
										new opportunities or open new doors for your career, or generally to inspire new ideas.
										</p>
										<p>
										While you wait on your 6FigureJobs membership, please <a href="/learn365-dashboard" target="_blank">click here</a> to begin taking advantage of Learn365.
										</p>
									</div>
								</div>
							<cfelse>
		               			<!--- thank you for joing 6FJ--->
								<div class="well3 relocation span12" style="background:##E4DFE6;">		
									<div class="span3">
										<div style="text-align:center; background-color:##1f0845;width:200px;height:200px;margin:0 auto;margin-top:10px;padding:10px 10px 10px 10px;">
										  <div style="vertical-align:middle;margin-top:45px">
										  <img src="/images/learn365/Learn365-SEL.png">
										  <h3 style="color:##FFFFFF;">$19.95</h3>
										  <p style="color:##FFFFFF; line-height:5px">PER MONTH</p>
										   <p style="color:##FFFFFF; margin-top:-15px;font-size:12px">Cancel anytime</p>
										  </div>
										</div>
									</div>
									<div class="span9">
										<h4>Are you prepared to begin interviewing? Could you use a few pointers or suggestions to try?</h4>
										<p>
										Do you feel your negotiation abilities are strong enough to get the compensation package you deserve?</p>
										<p style="margin-top:-15px">
										6FigureJobs is your go-to career resource. 
										We're excited to announce <b>Learn365, the new eLearning solution 
										for business professionals that are career focused like you!</b></p>
										<p style="margin-top:-15px">
										<b>Learn at your own pace through self-guided courses</b> taught by experts, thought leaders, researchers, and certified 
										trainers covering topics such as career, leadership, strategy, selling, as well as design and technical skills.
										</p>
										<p>
										 <a href="/learn365-dashboard" target="_blank">Click here</a> to learn more and preview our growing course catalog!
										</p>
									</div>
								</div>
							</cfif>
		                	</div>
							<!--- <cfif isdefined("url.learn365")> --->
								<!--- <div class="row-fluid">
									<div class="span12">		
										<cfif application.sourceApp NEQ "SalesStars">
										<div class="push"><!--//--></div>
										<span class="label label-info">PLEASE NOTE</span> We pre-screen all registrations to ensure professionals meet the work experience & compensation requirements employers expect to see when using #application.sourceApp# to source candidates.<br><br>
										We will contact you by email within 1 business day. Once you are approved, you will be able to log into your account with full access.<br><br>
										</cfif>
										<span class="label label-important">IMPORTANT</span> Check your inbox or junk folder for our confirmation emails.
										
									</div>
								</div> --->
							<!--- </cfif> --->
						</cfif>
						<div class="push"><!--//--></div>
						
						<!--- 
						06/17/2013 Do not show the SalesStars offer for now
						<cfif application.applicationname eq "6FigureJobs" and (resDetails.strfuncs contains "Sales" or resDetails.strexecJobtitle_1 contains "sales" or resDetails.strexecJobtitle_2 contains "sales")>
						--->
				
                		<cfif application.sourceApp eq "6FigureJobs" and (resDetails.strfuncs contains "Sales222")>
							<!--- Track that the SalesStars Registration has been offered to this candidate --->
                    		<cfquery name="cfqInsSSRegOffer" datasource="#application.strsixfigdata#">
                    		insert into tblSSRegistrationOffer (intResID, intOfferedPage) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#intresid#">, <cfqueryparam cfsqltype="cf_sql_integer" value="1">)
                   	 		</cfquery>
                    
							<!--- Invitation --->
                    		<div id="salesStarsInvite" style="display:block;">
                        		<div class="salesstar-reg-invite-title" >We also have a special invitation for you!</div><br>
                            	<div class="span9" style="background-color: ##f9f9f9; margin-left:0; padding:20px; border: 1px solid ##e6e6e6;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px;">
                            		<img src="#request.url#/_includes/templates/assets/img/salesstars-logo-black.png"><br><br>
                            
                            		First #resDetails.fname#,<br>
	                            	Based on your background, we are excited to invite you to join our FREE sister community, <a href="http://www.salesstars.com">SalesStars.com</a><br><br>
	                            	Have you ever been asked at an interview or business function, <strong><i>"First name, how would you best describe your selling style?"</i></strong> Or have you always felt you were a Hunter (a sales pro who is proactive with strong drive), but never had a chance to prove it? As a member of SalesStars, you have the opportunity to take a <strong>FREE</strong> Sales Temperament Assessment and showcase it on your professional profile.<br><br>
	                            	<strong>Additionally, with your FREE SalesStars membership:</strong><br><br>
	                            
                            		<ul style="list-style:circle;">
	                            	<li> Be a part of a new and growing community that is geared ONLY for sales professionals at all levels.</li>
	                            	<li> Search and apply for sales jobs.</li>
	                            	<li> Stand out to sales recruiters and the "sales org" decision makers at companies.</li>
	                            	<li> Build a rich, sales-centric profile that engages and markets your sales strengths.</li>
	                            	<li> Stay on top of important happenings in the sales arena.</li>
	                            	</ul>
	                            	<br>
    	                        	For your convenience, we can quickly create your SalesStars profile now by using the information you just provided for 6FigureJobs.
	                            	Once your account is created, you will receive a "Welcome to SalesStars" email so that you can login and manage your account.<br><br>
	                            	<strong>Do you want us to create a SalesStars profile for you?</strong><br><br>
                            
	                            	<!---If the Non member candidate is registering to apply to a job --->
	                            	<cfif isDefined("session.exec.jaQintJobID") and session.exec.jaQintJobID neq "">
	                                	<cfquery name="cfqGetJobDet" datasource="#strsixfigdata#">
                                    select title, jpname 
                                    from tblJobs (nolock) 
                                    where intJobID = #session.exec.jaQintJobID#
                                	</cfquery>
                                	<cfset jobTitle = cfqGetJobDet.title>
                               
                                	<form action="#request.url#/pg_execLoginProcess.cfm?100k=1&start1=0&pgNo=1&intJobID=#session.exec.jaQintJobID#&blnVisit=1&sort=date_submitted&sortorder=desc" method="post" name="ExecmainLogin">
                                	<label class="checkbox">
                                	<input type="checkbox" onClick="salesStarsBtn();" id="salesStarsChkBox" name="salesStarsChkBox"> &nbsp;<strong>Yes!</strong> Please create my SalesStars account for me!<br>
                                	<div style="padding-bottom:10px;"></div>
                                	<input type="hidden" name="strCaller" value="execOneClickApply">
                                	<input type="hidden" name="strUsername" size="35" value="#trim(resDetails.username)#">
                                	<input type="hidden" name="strPassword" size="35" value="#trim(resDetails.password)#">
                                	<a href="##"  onclick="document.ExecmainLogin.submit();">Apply to the Job: #jobTitle#</a>
                                	<div style="padding-bottom:10px;"></div>
                                	</label>
                                	<a href="javascript:createSSAccount('#url.Fy4ZT9ZUv#');"><button class="btn btn-large btn-primary" type="button" name="salestarsBtn" id="salestarsBtn" disabled>Create SalesStars Account</button></a>
                                	</form> 
	                            	<cfelse>
	                                	<form>
                                	<label class="checkbox">
                                	<input type="checkbox" onClick="salesStarsBtn();" id="salesStarsChkBox" name="salesStarsChkBox"> &nbsp;<strong>Yes!</strong> Please create my SalesStars account for me!<br>
                                	<div style="padding-bottom:10px;"></div>
                                	<input type="hidden" name="strCaller" value="execOneClickApply">
                                	<input type="hidden" name="strUsername" size="35" value="#trim(resDetails.username)#">
                                	<input type="hidden" name="strPassword" size="35" value="#trim(resDetails.password)#">
                                	<a href="#request.url#/pg_ExecLoginProcess.cfm?strUsername=#trim(resDetails.username)#&strPassword=#trim(resDetails.password)#">No Thanks! I'm not interested right now.</a>
                                	<div style="padding-bottom:10px;"></div>
                                	</label>
                                	<a href="javascript:createSSAccount('#url.Fy4ZT9ZUv#');"><button class="btn btn-large btn-primary" type="button" name="salestarsBtn" id="salestarsBtn" disabled>Create SalesStars Account</button></a>
                                	</form>   
	                            	</cfif>   
    	                    	</div>
	                   		</div>
                    
    		               	<!---Confirmation Page--->
            	        	<div id="salesStarsInviteConf" style="display:none;">
                	        	<div class="salesstar-reg-invite-title" >We also have a special invitation for you!</div><br>
                    	    	<div class="span9" style="background-color: ##f9f9f9; margin-left:0; padding:20px; border: 1px solid ##e6e6e6;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px;">
		                	        <img src="#request.url#/_includes/templates/assets/img/salesstars-logo-black.png"><br><br>
    	                    	    Thank you! Your request has been processed<br><br>
        	                    
            	                	<!---If the Non member candidate is registering to apply to a job --->
									<cfif isDefined("session.exec.jaQintJobID") and session.exec.jaQintJobID neq "">
                    	            	<cfquery name="cfqGetJobDet" datasource="#strsixfigdata#">
                        	        	select title, jpname 
                            	    	from tblJobs (nolock) 
                                		where intJobID = #session.exec.jaQintJobID#
                                		</cfquery>
                                		<cfset jobTitle = cfqGetJobDet.title>
                               
                                		<form action="#request.url#/pg_execLoginProcess.cfm?100k=1&start1=0&pgNo=1&intJobID=#session.exec.jaQintJobID#&blnVisit=1&sort=date_submitted&sortorder=desc" method="post" name="ExecmainLogin">
                                		<input type="hidden" name="strCaller" value="execOneClickApply">
                                		<input type="hidden" name="strUsername" size="35" value="#trim(resDetails.username)#">
                                		<input type="hidden" name="strPassword" size="35" value="#trim(resDetails.password)#">
                                		</form>                          
                                		<h4><a href="##"  onclick="document.ExecmainLogin.submit();">Apply to the Job: #jobTitle#</a></h4>                    
                            		<cfelse>
                                		<h4><a href="#request.url#/pg_ExecLoginProcess.cfm?strUsername=#trim(resDetails.username)#&strPassword=#trim(resDetails.password)#">Search & Apply to Jobs</a></h4>
                            		</cfif>
								</div>
                   			</div>
                    
                		<cfelse>
                		
							<!---If the Non member candidate is registering to apply to a job --->
							<!--- <cfif isDefined("session.exec.jaQintJobID") and session.exec.jaQintJobID neq "">
                        		<cfquery name="cfqGetJobDet" datasource="#application.dsn#">
                            	select title, jpname 
                            	from tblJobs (nolock) 
                            	where intJobID = #session.exec.jaQintJobID#
                        		</cfquery>
                        		<cfset jobTitle = cfqGetJobDet.title>
                       
                     		   	<form action="/member-login?100k=1&start1=0&pgNo=1&intJobID=#session.exec.jaQintJobID#&blnVisit=1&sort=date_submitted&sortorder=desc" method="post" name="ExecmainLogin">
                        		<input type="hidden" name="strCaller" value="execOneClickApply">
                        		<input type="hidden" name="strUsername" size="35" value="#trim(resDetails.username)#">
                        		<input type="hidden" name="strPassword" size="35" value="#trim(resDetails.password)#">
                        		</form>                          
                        		<h4><a href="##"  onclick="document.ExecmainLogin.submit();"><div class="btn btn-primary">Apply to the Job</div>&nbsp;&nbsp;#jobTitle#</a></h4>                    
                    		<cfelse>
                        		<h4><a href="/member-login?strUsername=#trim(resDetails.username)#&strPassword=#trim(resDetails.password)#"><u>Search $100K+ Jobs</u></a></h4>
                    		</cfif> --->
						</cfif>                
                
                		<div style="clear:both;"></div>
            			<div class="push"><!--//--></div>
                		
					</div>
				</div>
			</div>
		</article>
	</div>
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

<!-- Google Code for Confirmation Page (www.6figurejobs.com)2 Conversion Page -->
<script type="text/javascript">
/* <![CDATA[ */
var google_conversion_id = 986961148;
var google_conversion_language = "en";
var google_conversion_format = "2";
var google_conversion_color = "ffffff";
var google_conversion_label = "9kasCOSB_AQQ_KnP1gM";
var google_conversion_value = 0;
/* ]]> */
</script>
<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
</script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="//www.googleadservices.com/pagead/conversion/986961148/?value=0&amp;label=9kasCOSB_AQQ_KnP1gM&amp;guid=ON&amp;script=0"/>
</div>
</noscript>

<!-- Begin INDEED conversion code -->
<script type="text/javascript">
/* <![CDATA[ */
var indeed_conversion_id = '9734553365720952';
var indeed_conversion_label = 'Thank_You';
/* ]]> */
</script>
<script type="text/javascript" src="//conv.indeed.com/pagead/conversion.js">
</script>
<noscript>
<img height=1 width=1 border=0 src="//conv.indeed.com/pagead/conv/9734553365720952/?script=0">
</noscript>
<!-- End INDEED conversion code -->

</body>
</html>
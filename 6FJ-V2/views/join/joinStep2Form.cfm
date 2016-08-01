<cfoutput>


<!--- Get International Countries --->
<cfquery name="cfqgetCountries" datasource="#application.dsn#">
select intOldID, strName, strCountry, intDisplayOrder From tblStates (nolock) where strcountry not in ('US', 'CA') and intDisplayOrder IS NOT NULL order by intDisplayOrder
</cfquery>

<form name="ExecProfile" id="ExecProfile" method="post" enctype="multipart/form-data" action="/join-step2?Fy4ZT9ZUv=#urlencodedformat(url.Fy4ZT9ZUv)#<cfif isDefined('url.liuser') and url.liuser is "true">&liuser=true</cfif>" onSubmit="return checkform2();">
	<input type="hidden" name="USCAIntToggle" id="USCAIntToggle" value="1" />
	<div class="page-dashboard">
		<article class="section companies well">
			<div class="container">
				<div class="row">
					<div class="span12">
						<h1>6FigureJobs Professional Registration</h1>
						<h4>
						Hi #strFName#!
						<br>
						We just need a few more pieces of profile information to get you started.
						<br>
						Please complete the following
						</h4>
				
						<!--- <section> --->
							<div class="row-fluid">
								
								<div class="span12 alert alert-error" id="errorDiv" style="color:##F00; display:none;">
				                	<strong>Warning!</strong> Please complete the fields below highlighted in red.
								</div>
								<cfif isDefined("url.creditErrMsg")>
									<cfset blnLearn365 = 1>
									<div class="span12 alert alert-error" id="errorDiv" style="color:##F00;">
				                		<strong>Warning!</strong>
										<br>
										#url.creditErrMsg#
										
									</div>
								</cfif>
							</div>
							
								<div class="page-spacer"><!--//--></div>
							<div class="row-fluid">
								<div class="span4">
									<h2>Contact Information</h2>
								</div>	
							</div>
							
							<div class="row-fluid" id="USCanadaZipCode" style="display:block;">
								<div class="span4">
									<input tabindex="1" id="strUSCAZipCode" name="strUSCAZipCode" type="text" class="input input-small span12 requiredField" maxlength="7" placeholder="U.S or Canadian Zip/Postal Code" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 1, this);" value="#execLocation#">
								</div>
							
								<div class="span2">
									<a href="##" onClick="javascript:document.getElementById('USCanadaZipCode').style.display='none'; document.getElementById('intnlZipCode').style.display='block'; document.getElementById('USCAIntToggle').value=2;"><span id="uscaIntZipCodeToggle">International?</span></a>
								</div>
							</div>
							
							<div class="row-fluid" id="intnlZipCode" style="display:none;">
								<div class="span5">
									<input tabindex="2" id="strIntntlCity" name="strIntntlCity" type="text" class="input input-small span12 requiredField" maxlength="50" placeholder="City" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 2, this);">
								</div>
				
								<div class="span4">
									<select tabindex="3" name="strCountry" id="strCountry" class="input input-small span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 3, this);">
			                       	    <option value="">Country</option>
										<cfloop query="cfqgetCountries">	
			                           	<option value="#cfqgetCountries.strname#" <cfif strCountry eq cfqgetCountries.strname>selected</cfif>>#cfqgetCountries.strname#</option>
										</cfloop>
		                           	</select>
								</div>
				
								<div class="span2">
									<a href="##" onClick="javascript:document.getElementById('intnlZipCode').style.display='none'; document.getElementById('USCanadaZipCode').style.display='block'; document.getElementById('USCAIntToggle').value=1;"><span id="uscaIntZipCodeToggle">U.S or Canadian?</span></a>
								</div>
							</div>
							
							
							<div class="row-fluid">
								<div class="span4">
									<input tabindex="4" id="strPhoneNumber" name="strPhoneNumber" type="text" class="input input-small span12 requiredField" maxlength="19" placeholder="Phone Number" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 4, this);" value="#strHomePhone#">
								</div>
							</div>
							<div class="page-spacer"><!--//--></div>
							
																	
							<div class="row-fluid">
								<div class="span4">
									<h2>Privacy Setting</h2>
								</div>
							</div>
							
							<div class="row-fluid">
								<div class="span5">
		                        	<h5>Make My Profile &amp; resume...</h5>
		                            <select tabindex="5" name="intPrivacySetting" id="intPrivacySetting" class="input input-small span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 5, this);" >
		                            <option value="">Choose one:</option>
									<option value="1" <cfif intPrivacySetting neq "4">selected</cfif>>Searchable</option>
									<option value="4" <cfif intPrivacySetting eq "4">selected</cfif>>Private</option>
		                           <!---  <option value="1" <cfif intPrivacySetting eq 1>selected</cfif>>Searchable by Employers & Recruiters</option>
		                            <!--- <option value="2" <cfif intPrivacySetting eq 2>selected</cfif>>Searchable by Employers Only</option>
		                            <option value="3" <cfif intPrivacySetting eq 3>selected</cfif>>Searchable by Recruiters Only</option> --->
		                            <option value="4" <cfif intPrivacySetting eq 4>selected</cfif>>Private</option> --->
		                            </select>                    
                    			</div>
							</div>
							<div class="page-spacer"><!--//--></div>
							
														
							<!--- Recent Positions --->
							<div class="row-fluid">
								<div class="span12">
									<h2>What are your 2 most recent positions held?</h2>
								</div>
							</div>
			               
								<div class="span12">
									
									<div class="row form-inline">
									
									1 &nbsp;&nbsp; <input tabindex="6" class="span4" type="text"  name="strExecJobTitle_1" value="#strExecJobTitle_1#" id="strExecJobTitle_1" placeholder="Most Recent Job Title" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 6, this);"  maxlength="48">
									
									&nbsp;&nbsp; @ &nbsp;&nbsp; <input tabindex="7" class="span4" type="text"  name="strExecJOBCompany_1" value="#strExecJOBCompany_1#" id="strExecJOBCompany_1" placeholder="Most Recent Company" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 7, this);"  maxlength="48">
									
									</div>
									<div class="page-spacer"><!--//--></div>
								</div>
	                		
							
							
								<div class="span12">
									<div class="row form-inline">
									2 &nbsp;&nbsp;    <input tabindex="8" class="span4" type="text"  name="strExecJobTitle_2" value="#strExecJobTitle_2#" id="strExecJobTitle_2" placeholder="Second Most Recent Job Title" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 8, this);"  maxlength="48">
									
										&nbsp;&nbsp; @ &nbsp;&nbsp; <input tabindex="9" class="span4" type="text"  name="strExecJOBCompany_2" value="#strExecJOBCompany_2#" id="strExecJOBCompany_2" placeholder="Second Most Recent Company" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 9, this);"  maxlength="48">
									</div> 
								<div class="page-spacer"><!--//--></div>	
								<div class="page-spacer"><!--//--></div>	
								</div>
							
							
							
							
							<cfif application.sourceApp NEQ "SalesStars">
								<div class="row-fluid">
									<div class="span4">
										<h2>Compensation History&nbsp;&nbsp;<a href="##myModal" data-toggle="modal"><i class="icon-info-sign"></i></a></h2>
									</div>
								</div>
								
								<!-- List View Modal Begin -->
		                		<div class="modal hide fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
						        	<!---
									<div class="modal-header">
					                	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
										<!--- 	<h4 id="myModalLabel">Example: How you will show up in search results.</h4> --->
					            	</div>
									--->
    	              				<div class="modal-body">
										<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
										<br />
										(a) This info is used for administrative pre-screening purposes for community inclusion.
										<br>
										(b) This info is displayed on your #application.sourceApp# profile to recruiters.
										<br>
										(c) Other job seekers will NOT see this information.
	                  				</div>
	                			</div>
								<!-- List View Modal End -->
								
								<div class="row-fluid">                
									<div class="span4">
										<div id="fltCompPackageErrTxt">What was your highest salary (total compensation) earned?</div>
									</div>
									
									<div class="span4">
										<select tabindex="10"  name="fltCompensation_package" id="fltCompensation_package" class="input input-small span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 10, this);" >
											<option value="">Highest salary earned:</option>
											<option value="69" <cfif fltCompensation_package is "69">selected</cfif>>Less than $70K</option>
											<option value="70" <cfif fltCompensation_package is "70">selected</cfif>>$70K - $99K</option>
											<cfloop index="LoopCnt" from="100" to="250" step="10">
											<option value="#LoopCnt#" <cfif LoopCnt eq fltCompensation_package>selected</cfif>>$#LoopCnt#K+</option>
											</cfloop>
											<cfloop index="LoopCnt" from="300" to="500" step="50">
											<option value="#LoopCnt#" <cfif LoopCnt eq fltCompensation_package>selected</cfif>>$#LoopCnt#K+</option>
											</cfloop>
										</select>
									</div>
								</div>
								<div class="page-spacer"><!--//--></div>	
								
								<div class="row-fluid">
									<div class="span4">
										<div><span class="label label-info">Optional</span> Use the box to share salary details or your current situation.
										Sharing your current compensation situation or requirements helps recruiters better match jobs that may be of interest to you.
										</div>
									</div>
								
									<div class="span4">
										<textarea tabindex="11" name="memoSalary_requirement" rows="5" cols="100" wrap="virtual"  style="width:385px; max-width:385px; height:100px; max-height:100px; resize:none; font-size:12px; font-style:italic;" onFocus="if(this.value==this.defaultValue){this.value='';}this.style.color='##333333';" onBlur="if(this.value==''){this.value=this.defaultValue;this.style.color='##333333';}; updateRegistrationStep(#session.exec.intresid#, 2, 11, this);">#memoSalary_requirement#</textarea>
									</div>
								</div>
								 <div class="page-spacer"><!--//--></div>						
							</cfif>
							
							<div class="page-spacer"><!--//--></div>
							<div class="row-fluid">
			                    <div class="span4">
                        			<h4>What is your desired job title?</h4>
								</div>
								
								<div class="span5">
									<input tabindex="12" type="text"  name="strDesiredJobTitle" value="#strDesiredJobTitle#" id="strDesiredJobTitle" placeholder="Ex. Director of Operations" class="input input-small span12 requiredField" maxlength="70" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 12, this);">
								</div>
				              	
				         	</div>
				            <div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
							
							<div class="row-fluid">
                    			<div class="span4">
									<h4>## of Years Work Experience</h4>
			                   	</div>
							
                        		<div class="span5">
		                            <select tabindex="13" name="intYrsExp" id="intYrsExp" class="input input-small span12 requiredField" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}; updateRegistrationStep(#session.exec.intresid#, 2, 13, this);" >
			                        	<option value="" >Choose One:</option>
			                            <cfloop index="LoopCnt" from="0" to="49" step="1">
			                            <option value="#LoopCnt#" <cfif LoopCnt eq intYrsExp>selected</cfif>>#LoopCnt#</option>
			                            </cfloop>
			                            <option value="50" <cfif intYrsExp eq 50>selected</cfif>>50+</option>
		                        	</select>
		                        </div>
        		            </div>
 							<div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
							
							<!--- Industry & Function Experience --->
            	   			<div class="row-fluid">
        			            <div class="span5">
		            	       		<h4><div id="intsIndIDsErrTxt">Industry Experience (Max. 5)</div></h4>
                        
									<cfset request.qry_industries = application.industryManager.getIndustries() />
									<div style="height: 175px; width:335px; overflow:auto; border: 1px solid ##CCCCCC; padding:5px 5px 5px 5px; background: ##ffffff;">
						    		
										<cfloop query="request.qry_industries">
											<div class="item">
												<input name="intsIndIDs" id="intsIndIDs#request.qry_industries.intOldIndID#" value="#request.qry_industries.intOldIndID#" onClick="checkUncheckAll('industry'); updateRegistrationStep(#session.exec.intresid#, 2, 14, this);" type="checkbox" <cfif listfind(intsIndIDs, request.qry_industries.intOldIndID)>checked="checked"</cfif> >
												<label class="checkbox inline" for="intsIndIDs#request.qry_industries.intOldIndID#">#request.qry_industries.strIndName#</label>
											</div>
										</cfloop>
									</div>
		                    	</div>
                    
                	    		<div class="span4">
                   					<h4><div id="intsFuncIDsErrTxt">Job Function Experience (Max. 5)</div></h4>
						
									<cfset request.qry_functions = application.functionManager.getFunctions() />
									<div style="height: 175px; width:335px; overflow:auto; border: 1px solid ##CCCCCC; padding:5px 5px 5px 5px; background: ##ffffff;">
					
									    <cfloop query="request.qry_functions">
										    <div class="item">
											    <input name="intsFuncIDs" id="intsFuncIDs#request.qry_functions.intOldFunctionID#" value="#request.qry_functions.intOldFunctionID#"  onclick="checkUncheckAll('function'); updateRegistrationStep(#session.exec.intresid#, 2, 15, this);" type="checkbox" <cfif listfind(intsFuncIDs, request.qry_functions.intOldFunctionID)>checked="checked"</cfif> >
												<label class="checkbox inline" for="intsFuncIDs#request.qry_functions.intOldFunctionID#">#request.qry_functions.strFunctionName#</label>
											</div>
										</cfloop>
									</div>
	                    		</div>
    	           			</div>
							
							
							
							<!--- Education --->
							<div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
							<div class="row-fluid">
								
								<div class="span6">
				           			<h2>Education</h2>
								</div>
							</div>

    	            		<cfloop index="i" from="1" to="5">
					        	<cfset strHighestDegree = "strHighestDegree#i#">
					            <div class="row-fluid" id="addEducationSchool#i#" <cfif i lte 1 or  #evaluate(strHighestDegree)# neq "">style="display:block;"<cfelse>style="display:none;"</cfif>>
					            	<div class="span4">
					                	<h5>Degree Earned:</h5>
					                    <select tabindex="16" name="strHighestDegree#i#" id="strHighestDegree#i#" onChange="disableSchool(#i#, this.selectedIndex);" onFocus="this.style.borderColor = '';" onBlur="if(this.selectedIndex==0){this.style.borderColor= '##F00';}; <cfif i is 1>updateRegistrationStep(#session.exec.intresid#, 2, 16, this);</cfif>">
					                    <option value="">Choose One:</option>
					                    <option value="High School/GED" <cfif #evaluate(strHighestDegree)# eq "High School/GED">selected</cfif>>High School/GED</option>
					                    <option value="Some College" <cfif #evaluate(strHighestDegree)# eq "Some College">selected</cfif>>Some College</option>
					                    <option value="Associates Degree" <cfif #evaluate(strHighestDegree)# eq "Associates Degree">selected</cfif>>Associates Degree</option>
					                    <option value="BS/BA" <cfif #evaluate(strHighestDegree)# eq "BS/BA">selected</cfif>>BS/BA</option>
					                    <option value="Masters" <cfif #evaluate(strHighestDegree)# eq "Masters">selected</cfif>>Masters</option>
					                    <option value="Doctorate" <cfif #evaluate(strHighestDegree)# eq "Doctorate">selected</cfif>>Doctorate</option>
					                    <option value="Juris Doctorate" <cfif #evaluate(strHighestDegree)# eq "Juris Doctorate">selected</cfif>>Juris Doctorate</option>
					                    </select>
					              	</div>
					                <cfset strSchool = "strSchool#i#">                    
				
					                <div class="span6">
	                					<h5>School:</h5>
					                    <span class="school_searchform"><input tabindex="25" style="width:400px;" name="strSchool#i#" id="strSchool#i#" type="text" value="#evaluate(strSchool)#" autocomplete="off" onKeyUp="javascript:execSchoolAutoSuggest(event, 'strSchool#i#', #i#);" onFocus="document.getElementById('submitBtn').disabled=true;" onBlur="document.getElementById('submitBtn').disabled=false;"  maxlength="75"></span>                        
					                    <!---<div id="listselection_school" style="margin-left:60px; position:absolute;"><select size="5" style="display:none; width:415px;" onChange="fillSchool(this); return false;" multiple="" name="execSchoolresults#i#" id="execSchoolresults#i#"></select></div><cfif i gt 1><span id="removeDegEduText#i#" <cfif i lte 1>style="display:none;"</cfif>><a href="javascript:removeDegreeEduction(#i#)"><i class="icon-remove-circle"></i></a></span></cfif>--->
						                <div id="listselection_school" style="margin-left:60px; position:absolute;"><select size="5" style="display:none; width:415px;" onChange="fillSchool(this); return false;" name="execSchoolresults#i#" id="execSchoolresults#i#"></select></div><cfif i gt 1><span id="removeDegEduText#i#" <cfif i lte 1>style="display:none;"</cfif>><a href="javascript:void"><i class="icon-remove-circle"></i></a></span></cfif>
					               	</div>    	                           
				               	</div>
	                		</cfloop>
                
	                		<div class="page-spacer"><!--//--></div>
	                			
							<div class="row-fluid" id="addDegreeSchool">
				            	<div class="span5">
					            	<a href="javascript:addDegreeEduction();"><i class="icon-plus-sign"></i>&nbsp;List Another Degree &amp; School</a>       		
				               	</div>
				          	</div>
 	               
							<div class="page-spacer"><!--//--></div>
							<!--- Learn365 Membership Start --->
							<cfinclude template="learn365Form.cfm">
							<!--- Learn365 Membership End --->
							<div class="page-spacer"><!--//--></div>
							
							<!---Member Email Subscriptions--->				
							<div class="row-fluid">
			                    <div class="span12">
                        			<h2>Member Email Subscriptions</h2>
									<h5>Please Note: We respect your privacy. Your email address will not be sold to any 3rd party. You may optout of these subscriptions at any time</h5>
								</div>
				         	</div>
							
							<div class="row-fluid">
                				<div class="span10">
				                    <div id="blnInHouseEmailErrTxt">Occasional updates about site improvements from our Community Manager (Recommended)</div>
			                    </div>
								<div class="span2">               
									<label class="radio inline"><input tabindex="17" type="radio" name="blnInHouseEmail" id="blnInHouseEmail" value="1" onClick="document.getElementById('blnInHouseEmailErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 17, this);" <cfif blnInHouseEmail is 1>checked</cfif> >Yes&nbsp;</label>
					                <label class="radio inline"><input tabindex="18" type="radio" name="blnInHouseEmail" id="blnInHouseEmail" value="0" onClick="document.getElementById('blnInHouseEmailErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 17, this);" <cfif blnInHouseEmail is 0>checked</cfif> >No</label>
			                  	</div>
							</div>
							<div class="page-spacer"><!--//--></div>
							
							
							<div class="row-fluid">
                				<div class="span10">
				                    <span id="blnNewsLetterErrTxt">Weekly 6FigureJobs Executive Newsletter (Recommended)</span>
			                    </div>
								<div class="span2">               
									<label class="radio inline"><input tabindex="19" type="radio" name="blnNewsLetter" id="blnNewsLetter" value="1" onClick="document.getElementById('blnNewsLetterErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 18, this);" <cfif blnNewsLetter is 1>checked</cfif> >Yes&nbsp;</label>
					                <label class="radio inline"><input tabindex="20" type="radio" name="blnNewsLetter" id="blnNewsLetter" value="0" onClick="document.getElementById('blnNewsLetterErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 18, this);" <cfif blnNewsLetter is 0>checked</cfif> >No</label>
			                  	</div>
							</div>            	
							<div class="page-spacer"><!--//--></div>
							
							<div class="row-fluid">
                				<div class="span10">
				                    <div id="blnEmailErrTxt">Matching Job Alerts and New Hiring Company Announcements (Recommended)</div>
			                    </div>
								<div class="span2">               
									<label class="radio inline"><input tabindex="21" type="radio" name="blnEmail" id="blnEmail" value="1" onClick="document.getElementById('blnEmailErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 19, this);" <cfif blnEmail is 1>checked</cfif> >Yes&nbsp;</label>
					                <label class="radio inline"><input tabindex="22" type="radio" name="blnEmail" id="blnEmail" value="0" onClick="document.getElementById('blnEmailErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 19, this);" <cfif blnEmail is 0>checked</cfif> >No</label>
			                  	</div>
							</div>            	
							<div class="page-spacer"><!--//--></div>
							
							
							<div class="row-fluid">
                				<div class="span10">
				                    <div id="blnSpecialOfferErrTxt">Special Offers from Career Sponsors &amp; Partners</div>
			                    </div>
								<div class="span2">               
									<label class="radio inline"><input tabindex="23" type="radio" name="blnSpecialOffer" id="blnSpecialOffer" value="1" onClick="document.getElementById('blnSpecialOfferErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 20, this);" <cfif blnSpecialOffer is 1>checked</cfif> >Yes&nbsp;</label>
					                <label class="radio inline"><input tabindex="24" type="radio" name="blnSpecialOffer" id="blnSpecialOffer" value="0" onClick="document.getElementById('blnSpecialOfferErrTxt').style.color = ''; updateRegistrationStep(#session.exec.intresid#, 2, 20, this);" <cfif blnSpecialOffer is 0>checked</cfif> >No</label>
			                  	</div>
							</div>            	
							<div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
							
							<div class="row-fluid">
								<div class="span12">
									<div  style="text-align:left ">
									<input tabindex="25" class="btn btn-primary btn-large" type="submit" name="validate" id="submitBtn" value="SAVE &amp; CONTINUE">
									</div>
								</div>
								<div class="page-spacer"><!--//--></div>
			                </div>
		                </div>
						
						
						<!--- </section> --->
				
						<div class="page-spacer"><!--//--></div>	
		
					</div>
				</div>
			</div>
		</article>
	</div>
</form>
</cfoutput>


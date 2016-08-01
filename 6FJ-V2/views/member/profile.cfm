
<cfoutput>

<!--- (if logged in and a "new" member)  OR (a 6FigureOnTrack Member awaiting reapproval) --->
<!---ISR <cfif not isdefined("session.exec.intResAdmcode")>
	<cflocation url="/index.cfm" addtoken="no">
<cfelseif (session.exec.intResAdmCode eq 2) OR (session.exec.intResAdmCode eq 4) AND (session.exec.intResStatusCode eq 2)>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr><td><cfinclude template="/6fj/t_PagePasswordText.cfm"></td></tr>
    </table>
<cfelse> --->
	    
	<cfif isDefined("form.fieldnames")>
	    <cfinclude template="profileSave.cfm"> 
       <div class="page-dashboard">
		<article class="section companies well">
			<div class="container">
                <div class="row">
                    <div class="span12">
                        <h1>Manage Account Profile </h1>
                        
                        <div class="alert alert-info" style="display:block;" id="successMessage">
                        Your changes are saved successfully, please go back to the <a href="/member-dashboard">Dashboard</a>.
                        </div>
					</div>
               	</div>
           	</div>
		</article>
       	</div>
   	<cfelse>
    	<cfinclude template="profileVariables.cfm"> 
        
        
        <form name="ExecProfile" id="ExecProfile" method="post" enctype="multipart/form-data" action="/member-profile" onSubmit="return checkform2();" >
        
		<div class="page-dashboard">
			<article class="section companies well">
				<div class="container">
                	<div class="row">
						<div class="span10">
							<div class="controls" style="text-align:right;">               
								<div style="padding-top:4px;">
									
									<cfif session.EXEC.blnArchived NEQ 0>
									<a href="/member-cancel" style="font-size:13px;color:##7C4495; font-weight:bold;">
									Reactivate Membership</a>
									</cfif>
									
								</div>
							</div>
						</div>
                     </div>
					
                     
                    <div class="row">
                    	
                        <div class="span12">
                            <div class="regheader"><h1>Manage Account Profile </h1></div>
                            
							<cfif application.sourceApp NEQ "SalesStars">
	                            <div class="alert alert-info" style="display:block;" id="successMessage">
	                            NOTE: Looking to manage your <a href="/member-resume">Resume</a> or <a href="/member-job-alerts">Job Search Alerts</a>?
	                            </div>
							</cfif>
                        
                            <div class="alert alert-error" id="errorDiv" style="max-width:600px;color:##F00; display:none;">
                            <strong>Warning!</strong> Please complete the fields below highlighted in red.</div>
                            <br>
                            
                            <!--- CONTACT INFORMATION --->
                            <div class="regsubheader"><h2>Contact Information</h2></div>
                            <div class="row">
                                <div class="span3">
                                    <div class="controls"><input tabindex="1" type="text" name="strFName" value="#strFName#" id="strFName" placeholder="First Name" onfocus="this.style.borderColor = ''; document.getElementById('submitBtn').disabled=true;" onblur="if(this.value==''){this.style.borderColor= '##F00'};  document.getElementById('submitBtn').disabled=false;"></div>
                                    <div class="controls"><input tabindex="2" type="text" name="strLName" value="#strLName#" id="strLName" placeholder="Last Name" onfocus="this.style.borderColor = ''; document.getElementById('submitBtn').disabled=true;" onblur="if(this.value==''){this.style.borderColor= '##F00'};  document.getElementById('submitBtn').disabled=false;"></div>
                                    <div class="controls">
                                        <span class="city_searchform"><input tabindex="3" type="text" name="execLocation"  id="execLocation" type="text" value="#execLocation#" autocomplete="off" onkeypress="parseCityState();" onkeyup="javascript:execLocAutoSuggest(event, 'execLocation'); parseCityState();" placeholder="Zip/Postal Code" onfocus="this.style.borderColor = ''; document.getElementById('submitBtn').disabled=true;" onblur="if(this.value==''){this.style.borderColor= '##F00'};  document.getElementById('submitBtn').disabled=false;" maxlength="18"></span>
                                        <div id="listselection_city" style="position:absolute;z-index:2;"><select size="5" style="display:none;" onChange="fillCityState(this);" onBlur="parseCityState();" multiple="" name="execLocresults" id="execLocresults"></select></div>
                                    </div>
                                    
                                    <div class="controls"><input tabindex="4" type="text" id="strCity" name="strCity" value="#strCity#" placeholder="City" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';} " maxlength="50"></div>
            
                                    <div class="controls">
                                        <cfinclude template="/v16fj/professional/profile/_includes/states_list.cfm">
                                    </div>
									
                                </div>
            
                                <div class="span4 offset1">
                                  <!---<div class="controls"> --->
                                    	<div class="input-prepend"> 
    	                                    <span class="add-on">E</span>
	                                        <input class="input-small span4" tabindex="6" type="text"  name="strEmail" value="#strEmail#" id="strEmail" placeholder="Email Address" maxlength="75">
                                         </div>
                                       <div id="strEmailErr" style="visibility:visible;  color:##F00;"></div>
                                    <!---</div>  --->
                                    <div class="controls">
                                       <div class="input-prepend"> 
    	                                    <span class="add-on">T</span>
                                          <input class="input-small span4" tabindex="7" type="text" name="strHomePhone" value="#strHomePhone#" id="strHomePhone"  placeholder="Home Phone" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}" maxlength="18">
                                        </div>
                                    </div>
                                    <div class="controls">
                                        <div class="input-prepend"> 
    	                                    <span class="add-on">M</span>
                                          <input class="input-small span4" tabindex="8" type="text" name="strMobilePhone" value="#strMobilePhone#" id="strMobilePhone"  placeholder="Mobile Phone" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}" maxlength="18">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="page-spacer"><!--//--></div>   
                        	<div class="page-spacer"><!--//--></div> 
							<div class="page-spacer"><!--//--></div> 
                            
                            
                            <!--- LOGIN INFORMATION --->
                            <div class="regsubheader"><h2>Login Information</h2></div>
                            <div class="row">
                                <div class="span3">
                                    <div class="controls"><input tabindex="9" type="text" name="strUserName" value="#strUserName#" id="strUserName" placeholder="User Name" maxlength="75"></div>
                                    <div class="controls"><input tabindex="10" type="password" name="strPasswd" value="#strPasswd#" id="strPasswd" placeholder="Password" maxlength="20"></div>
                                </div>    
                            </div>
                             <div class="page-spacer"><!--//--></div>   
                        	<div class="page-spacer"><!--//--></div> 
							<div class="page-spacer"><!--//--></div>  
                            
                            
                            <!--- RELOCATION --->
                            <div class="regsubheader">
                                <h2>Relocation Preferences</h2>
                            </div>
            
                            <div class="row">
                                <div class="span4">
                                    <div class="controls">               
                                        <div style="padding-top:4px; font-weight:bold;" id="relocateOption">Are you willing to relocate?</div>
                                    </div>
                                </div>
                                <div class="span3">
                                    <div class="controls">  
                                        <label class="radio inline"><input tabindex="11" type="radio" name="blnrelocate" value="1" id="blnrelocateYes" onclick="document.getElementById('relocateOption').style.color='##000';" <cfif blnRelocate is 1>checked</cfif>>Yes&nbsp;</label>
                                        <label class="radio inline"><input tabindex="12" type="radio" name="blnrelocate" value="0" id="blnrelocateNo"  onclick="document.getElementById('relocateOption').style.color='##000';" <cfif blnRelocate is 0>checked</cfif>>No</label>
                                    </div>
                                </div> 
                            </div>
                            <div style="padding-bottom:20px;"></div>
                            <div class="row" id="relocateprefs" <cfif blnrelocate is 0>style="display:none;"<cfelse>style="display:block;"</cfif> >
								<div class="span4">
                                    <div class="controls">               
                                        <div style="padding-top:4px; font-weight:bold;" id="relocationText">Where would you relocate?</div>
                                    </div>
                                </div>
                                <div class="span5">
                                    <div class="controls"> 
										<span id="relocationDiv" style="display:none;"><strong>Please select upto only 10 locations where you would like to relocate to</strong></span> 
                                        <cfinclude template="relocation_list.cfm">
                                    </div>
                                </div> 
                            </div>
                             <div class="page-spacer"><!--//--></div>   
                        	<div class="page-spacer"><!--//--></div> 
							<div class="page-spacer"><!--//--></div> 
							
							
                            <a name="privacy" id="privacy"></a>          
                            <!--- PRIVACY SETTING --->
                            <div class="regsubheader"><h2>Privacy Setting</h2></div>
							
                            <div class="row">
                                <div class="span9">
                                    <div class="controls">
                                        <span id="intPrivacySettingErrTxt"><strong>Make My Profile &amp; Resume:</strong></span>&nbsp;&nbsp;
                                        <select tabindex="13" name="intPrivacySetting" id="intPrivacySetting" onFocus="this.style.borderColor = '';" onBlur="if(this.selectedIndex==0){this.style.borderColor= '##F00';}" style="width:auto;">
                                        <option value="">Choose one:</option>
                                        <!--- <option value="1" <cfif intPrivacySetting eq 1>selected</cfif>>Searchable by Employers & Recruiters</option>
                                        <option value="2" <cfif intPrivacySetting eq 2>selected</cfif>>Searchable by Employers Only</option>
                                        <option value="3" <cfif intPrivacySetting eq 3>selected</cfif>>Searchable by Recruiters Only</option>
                                        <option value="4" <cfif intPrivacySetting eq 4>selected</cfif>>Private to Employers & Recruiters</option>
                                         --->
										 <option value="1" <cfif intPrivacySetting neq "4">selected</cfif>>Searchable</option>
										 <option value="4" <cfif intPrivacySetting eq "4">selected</cfif>>Private</option>
										 </select>
            
                                    </div>
                                </div>
                            </div>
							<div class="pull-left">
								<cfif session.EXEC.blnArchived EQ 0>
								<a href="/member-cancel" style="font-size:13px;color:##7C4495; font-weight:bold;">Cancel Membership</a>									
								</cfif>
							</div>
                             <div class="page-spacer"><!--//--></div>   
                        	<div class="page-spacer"><!--//--></div> 
							<div class="page-spacer"><!--//--></div> 
                            
                            <!--- EXECUTIVE SUMMARY --->
                            <div class="regsubheader"><h2><cfif application.sourceApp EQ "SalesStars">Professional<cfelse>Executive</cfif> Summary</h2></div>
                            <div class="row">
                                <div class="span10">
                                    <div class="controls">
                                        <div style="padding-bottom:15px;"><strong>What are your 2 most recent positions held?</strong></div>
                                        <div style="padding-bottom:15px;">If you marked your privacy settings as searchable, this info will be displayed on recruiters' search results. <a href="##myModal" data-toggle="modal">See example</a></div>
                                    </div>
                                </div>
                            </div>
                            <!-- List View Modal Begin -->
                            <div class="modal hide fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                              <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                                <h4 id="myModalLabel">Example: How you will show up in search results.</h4>
                              </div>
                              <div class="modal-body">
                                <img src="/img/searchresults_example.png">
                              </div>
                            </div>
                            <!-- List View Modal End -->
                            <div class="row">
                                <div class="span3">
                                    <div class="controls">
                                        <input tabindex="14" class="span" type="text"  name="strExecJobTitle_1" value="#strExecJobTitle_1#" id="strExecJobTitle_1" placeholder="Most Recent Job Title" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}"  maxlength="45">
                                    </div>
                                    <div class="controls">
                                        <input tabindex="16" class="span" type="text"  name="strExecJobTitle_2" value="#strExecJobTitle_2#" id="strExecJobTitle_2" placeholder="Second Most Recent Job Title" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}" maxlength="45">
                                    </div>
                                </div>
                                
                                <div class="span3">
                                    <div class="controls">
                                        <input tabindex="15" class="span" type="text"  name="strExecJOBCompany_1" value="#strExecJOBCompany_1#" id="strExecJOBCompany_1" placeholder="Most Recent Company" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}" maxlength="45">
                                    </div>
                                    <div class="controls">
                                        <input tabindex="17" class="span" type="text"  name="strExecJOBCompany_2" value="#strExecJOBCompany_2#" id="strExecJOBCompany_2" placeholder="Second Most Recent Company" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}" maxlength="45">
                                    </div>
                                </div> 
                            </div>
                            
                            <div class="row">
                                <div class="span9">
                                    <div class="controls">
                                        <br>
                                        <div style="padding-bottom:15px;"><strong>What is your desired job title?</strong></div>
                                        <input tabindex="18" class="span" type="text"  name="strDesiredJobTitle" value="#strDesiredJobTitle#" id="strDesiredJobTitle" placeholder="Desired Job Title" onFocus="this.style.borderColor = '';" onBlur="if(this.value==''){this.style.borderColor= '##F00';}" maxlength="70">&nbsp;&nbsp;e.g. <cfif application.sourceApp EQ "SalesStars">Account Executive<cfelse>Director of Operations</cfif>
                                    </div>
                                </div>
                            </div>
                            <div class="page-spacer"><!--//--></div>   
                        	<div class="page-spacer"><!--//--></div> 
							<div class="page-spacer"><!--//--></div> 
                            
            
                            <!--- COMPENSATION --->
                            <cfif application.sourceApp NEQ "SalesStars">
                                <div class="regsubheader"><h2>Compensation</h2></div>
                                <div class="row">                
                                    <div class="span5">
                                        <div class="controls">
                                            <div style="padding-bottom:25px;" id="fltCompPackageErrTxt"><strong>Current (most recent) total compensation package:</strong></div>
                                        </div>
                                    </div>              
                                    <div class="span4">
                                        <div class="controls">
                                            <select tabindex="19"  name="fltCompensation_package" id="fltCompensation_package" onFocus="this.style.borderColor = '';" onBlur="if(this.selectedIndex==0){this.style.borderColor= '##F00';}">
                                                <option>Select Most Recent Salary:</option>
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
                                </div>
                                
                                <div class="row">
                                    <div class="span5">
                                        <div class="controls">
                                            <div style="padding-bottom:10px;"><strong><span class="label label-info">Optional</span> Use the box to share salary details.</strong></div>
                                            Sharing your current compensation situation or requirements helps recruiters better match jobs that may be of interest to you.
                                        </div>
                                    </div>
                                    
                                    <div class="span4">
                                        <div class="controls">
                                            <textarea tabindex="20" name="memoSalary_requirement" rows="5" cols="100" wrap="virtual"  style="width:355px; max-width:355px; height:100px; max-height:100px; resize:none; font-size:12px; font-style:italic;" onFocus="if(this.value==this.defaultValue){this.value='';}this.style.color='##333333';" onBlur="if(this.value==''){this.value=this.defaultValue;this.style.color='##333333';}">#memoSalary_requirement#</textarea>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="page-spacer"><!--//--></div>
								<div class="page-spacer"><!--//--></div>
								<div class="page-spacer"><!--//--></div>
                            </cfif>
                            
                            <!--- INDUSTRY & FUNCTION EXPERIENCE --->
                            <div class="regsubheader"><h2>Industry &amp; Function Experience</h2></div>
                            <div class="row">
                                <div class="span4">
                                    <div style="padding-bottom:10px;" id="intsIndIDsErrTxt"><strong>Industry Experience (Max. 5)</strong></div>
                                    									
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
                                
                                <div class="span4 offset1">
                                    <div style="padding-bottom:10px;" id="intsFuncIDsErrTxt"><strong>Job Function Experience (Max. 5)</strong></div>
                                    
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
                            
							<div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
                            
							<div class="row">
                                <div class="span8">
                                    <div class="controls">
                                        <strong>Number of Years Work Experience</strong>&nbsp;&nbsp;
                                        <select tabindex="23" name="intYrsExp" id="intYrsExp" onFocus="this.style.borderColor = '';" onBlur="if(this.selectedIndex==0){this.style.borderColor= '##F00';}">
                                        <option value="">Choose One:</option>
                                        <cfloop index="LoopCnt" from="0" to="49" step="1">
                                        <option value="#LoopCnt#" <cfif LoopCnt eq intYrsExp>selected</cfif>>#LoopCnt#</option>
                                        </cfloop>
                                        <option value="50" <cfif intYrsExp eq 50>selected</cfif>>50+</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
                            
                            
                            <!--- EDUCATION --->
                            <div class="regsubheader"><h2>Education</h2></div>
                            <input type="hidden" name="resDegreeCount" value="#resDegreeCount#" id="resDegreeCount" />
                            <cfloop index="i" from="1" to="5">
                            <cfset strHighestDegree = "strHighestDegree#i#">
                            <div class="row" id="addEducationSchool#i#" <cfif i lte 1 or #evaluate(strHighestDegree)# neq "">style="display:block;"<cfelse>style="display:none;"</cfif>>
                                <div class="span4">
                                    <strong>Degree Earned:</strong>&nbsp;&nbsp;
                                    <select tabindex="24" name="strHighestDegree#i#" id="strHighestDegree#i#" onChange="disableSchool(#i#, this.selectedIndex);" onFocus="this.style.borderColor = '';" onBlur="if(this.selectedIndex==0){this.style.borderColor= '##F00';}">
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
                                    <strong>School:</strong>&nbsp;&nbsp;
                                    <!---<span class="school_searchform"><input tabindex="25" style="width:400px;" name="strSchool#i#" id="strSchool#i#" type="text" value="#evaluate(strSchool)#" autocomplete="off" onKeyUp="javascript:execSchoolAutoSuggest(event, 'strSchool#i#', #i#);" onFocus="document.getElementById('submitBtn').disabled=true;" onBlur="document.getElementById('submitBtn').disabled=false;"></span>--->
                                    <span class="school_searchform"><input tabindex="25" style="width:400px;" name="strSchool#i#" id="strSchool#i#" type="text" value="#evaluate(strSchool)#" autocomplete="off" onKeyUp="javascript:execSchoolAutoSuggest(event, 'strSchool#i#', #i#);" maxlength="250"></span>
                                    <div id="listselection_school" style="margin-left:60px; position:absolute;"><select size="5" style="display:none; width:415px;" onChange="fillSchool(this); return false;" multiple="" name="execSchoolresults#i#" id="execSchoolresults#i#" ></select></div>
                                    
                                    <cfif i gt 1>
                                        <span id="removeDegEduText#i#" <cfif i lt resDegreeCount>style="display:none;"</cfif>><a href="javascript:void"><i class="icon-remove-circle"></i></a></span>
                                    </cfif>
                                </div>    	                           
                            </div>
                            </cfloop>
                            <div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
							
                            
                            
                            <div class="row" id="addDegreeSchool" <cfif resDegreeCount is 5>style="display:none;"</cfif>>
                                <div class="span10">
                                <a href="javascript:addDegreeEduction();"><div style="padding:4px 0 0 20px;"><i class="icon-plus-sign"></i> &nbsp;List Another Degree & School</div></a>       		
                                </div>
                            </div>
                            <div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
							
                            
                            <!--- WEBSITES & ONLINE PROFILES --->   
                            <div class="regsubheader"><h2>My Websites & Online Profiles</h2></div>  
                            <div class="row">
                                <div class="span12">
                                    <div style="padding-bottom:15px;">Share your other social media or online profiles to keep recruiters engaged.</div>
                                    <input type="hidden" tabindex="25" name="websiteProfileCount" value="#webSiteProfilesCount#" id="webSiteProfilesCount"/>
                                    <cfloop index="i" from="1" to="5">
                                    <cfset webSiteCategory = "resumeWebSitesCategory#i#">
                                    <div class="row" id="myWebSitesID#i#" <cfif i lte 1 or #evaluate(websiteCategory)# neq "">style="display:block;"<cfelse>style="display:none;"</cfif>>
                                        <div class="span3">
                                            <cfset webSiteName = "resumeWebSiteName#i#">
                                            <cfset webSiteURL = "resumeWebSiteURL#i#">
                                            <select name="resumeWebSitesCategory#i#" tabindex="26" id="resWebSiteCategory#i#" onchange="validateNameURL(#i#)">
                                            <option value="">Choose Type:</option>
                                            <cfloop query="cfqGetWebSiteCategories">
                                            <option value="#cfqGetWebSiteCategories.intWebSiteCategoryID#" <cfif #evaluate(webSiteCategory)# is cfqGetWebSiteCategories.intWebSiteCategoryID>selected</cfif>>#cfqGetWebSiteCategories.strWebSiteCategoryName#</option>
                                            </cfloop>
                                            </select>
                                        </div>
                                        <div class="span3">
                                            <input type="text" class="span" tabindex="27" id="resWebSiteName#i#" name="resumeWebSiteName#i#" value="#evaluate(webSiteName)#" onkeyup="validateWebSiteName(#i#)" onkeydown="validateWebSiteName(#i#)" placeholder="Website Title" maxlength="175" />
                                        </div>
                                        <div class="span6 form-inline">
                                            <input type="text" class="span4" tabindex="28" id="resWebSiteURL#i#" name="resumeWebSiteURL#i#" value="#evaluate(webSiteURL)#" onkeyup="validateWebSiteURL(#i#)" onkeydown="validateWebSiteURL(#i#)"  placeholder="URL (ex: http://www.mysite.com)" maxlength="175" />
                                            <cfif i gt 1>
                                                <span id="removeWebSiteText#i#" <cfif i lt webSiteProfilesCount>style="display:none;"</cfif>><a href="javascript:void"><i class="icon-remove-circle"></i></a></span>
                                            </cfif>
                                        </div>
                                    </div>
                                    </cfloop>
                                    <div style="clear:left;padding-bottom:25px;"></div>						
                                    <div class="row" id="addWebSiteText" <cfif webSiteProfilesCount is 5>style="display:none;"</cfif>>
                                        <div class="span10"><a href="javascript:addWebsite();"><div style="padding:4px 0 0 20px;"><i class="icon-plus-sign"></i> &nbsp; Add Another Website</div></a></div>
                                    </div>		
                                </div>
                            </div>
                            <div class="page-spacer"><!--//--></div>		
							<div class="page-spacer"><!--//--></div>
							<div class="page-spacer"><!--//--></div>
							
                            <a name="eSubscriptions" id="esubscriptions"></a>
                            <!--- MEMBER EMAIL SUBSCRIPTIONS --->
                            <div class="regsubheader"><h2>Member Email Subscriptions</h2></div>
							<div class="row">
                                <div class="span9">
                                   <div class="controls" style="padding-bottom:25px;">Occasional updates about site improvements from our Community Manager (Recommended)</strong></div>
                                </div>
                        
                                <div class="span3">
                                    <div class="controls">
                                        <label class="radio inline"><input tabindex="29" type="radio" name="blnInHouseEmail" id="blnInHouseEmail" value="1" <cfif blnInHouseEmail eq 1> checked </cfif>>Yes&nbsp;</label>
                                        <label class="radio inline"><input tabindex="30" type="radio" name="blnInHouseEmail" id="blnInHouseEmail" value="0" <cfif blnInHouseEmail eq 0> checked </cfif>>No</label>
                                    </div>
                                </div>
                            </div>
							
                            <div class="row">
                                <div class="span9">
                                   <div class="controls" style="padding-bottom:25px;">Weekly #application.sourceApp# Executive Newsletter (Recommended)</strong></div>
                                </div>
                        
                                <div class="span3">
                                    <div class="controls">
                                        <label class="radio inline"><input tabindex="31" type="radio" name="blnNewsLetter" id="blnNewsLetter" value="1" <cfif blnNewsLetter eq 1> checked </cfif>>Yes&nbsp;</label>
                                        <label class="radio inline"><input tabindex="32" type="radio" name="blnNewsLetter" id="blnNewsLetter" value="0" <cfif blnNewsLetter eq 0> checked </cfif>>No</label>
                                    </div>
                                </div>
                            </div>
                            
							<div class="row">
                                <div class="span9">
                                   <div class="controls" style="padding-bottom:25px;" id="blnEmailErrTxt">Matching Job Alerts and New Hiring Company Announcements (Recommended)</div>
                                </div>
                        
                                <div class="span3">
                                    <div class="controls">
                                        <label class="radio inline"><input tabindex="33" type="radio" name="blnEmail" id="blnEmail" value="1" onClick="document.getElementById('blnEmailErrTxt').style.color = '';" <cfif blnEmail eq 1> checked </cfif>>Yes&nbsp;</label>
                                        <label class="radio inline"><input tabindex="34" type="radio" name="blnEmail" id="blnEmail" value="0" onClick="document.getElementById('blnEmailErrTxt').style.color = '';" <cfif blnEmail eq 0> checked </cfif>>No</label>
                                    </div>
                                </div>
                            </div>
							
                            <div class="row">
                                <div class="span9">
                                   <div class="controls" style="padding-bottom:25px;" id="blnSpecialOfferErrTxt">Special Offers from Career Sponsors &amp Partners</strong></div>
                                </div>
                        
                                <div class="span3">
                                    <div class="controls">
                                        <label class="radio inline"><input tabindex="35" type="radio" name="blnSpecialOffer" id="blnSpecialOffer" value="1" onClick="document.getElementById('blnSpecialOfferErrTxt').style.color = '';" <cfif blnSpecialOffer eq 1> checked </cfif>>Yes&nbsp;</label>
                                        <label class="radio inline"><input tabindex="36" type="radio" name="blnSpecialOffer" id="blnSpecialOffer" value="0" onClick="document.getElementById('blnSpecialOfferErrTxt').style.color = '';" <cfif blnSpecialOffer eq 0> checked </cfif>>No</label>
                                    </div>
                                </div>
                            </div>
                            
                            
                           <div class="row">
						   <div class="span12">
                            <input tabindex="37" class="btn btn-primary btn-large" type="submit" name="validate" id="submitBtn" value="SAVE &amp; CONTINUE" onclick="return checkform2();">
                            </div>
							</div>
                            <div class="page-spacer"><!--//--></div>
                            <div class="page-spacer"><!--//--></div>
                            <div class="page-spacer"><!--//--></div>
                            
                        </div>
                    </div> <!-- /row -->
                </div> <!-- /container -->
				</article>
            </div> <!-- //Wrapper -->
       	
        </form>
        <div class="page-spacer"><!--//--></div>
        

</cfif>
</cfoutput>
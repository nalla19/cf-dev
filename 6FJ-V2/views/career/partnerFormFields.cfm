<!--- BYOB CPL Form Popup --->
<cfif ((isdefined('CPLMEMBERIDLIST') and listlen(CPLMEMBERIDLIST) eq 1))>
	<!--- load the member --->
 	<cfstoredproc procedure="sp_cpl_check_for_member" datasource="#application.dsn#" returncode="Yes">
  		<cfprocparam type="IN" dbvarname="@intMemberID" value="#val(CPLMEMBERIDLIST)#" cfsqltype="CF_SQL_INTEGER">
	  	<cfprocresult resultset="1" name="qCPLMemberinfo">
 	</cfstoredproc>
</cfif>

<cflock timeout="10" throwontimeout="No" name="checkResID" type="READONLY">
	<cfscript>
	//Variables
	ValidateQuesMemberID="";
	if (isdefined('CPLMEMBERID') and len(CPLMEMBERID)){
		ValidateQuesMemberID=CPLMEMBERID;
	}else if (isdefined('CPLMEMBERIDLIST') and listlen(CPLMEMBERIDLIST) eq 1){
		ValidateQuesMemberID=CPLMEMBERIDLIST;
	}
	//Is The Exec Logged In
	/*
	if (isdefined("session.exec.intResID") ){		
		if (isdefined("form.fieldnames")){
			blnLoggedIn = 0;
		}
		else{
			blnLoggedIn = 1;
		}
	}else{
		blnLoggedIn = 0;
	}*/
	</cfscript>
</cflock> 

<cfoutput>


<!--- Table Information --->

	<!--- Session Vars Is Defined --->
	<!-- Hidden Vars --->

<div class="row">
	<div class="span4">
	<input tabindex="1" type="text" name="CPLFname" id="CPLFname" value="#CPLFname#" placeholder="First Name" class="input input-small span4 requiredField" required>
	</div>
	<div class="span4 offset1">
	<input tabindex="6" type="text" name="CPLAddr" id="CPLAddr" value="#CPLAddr#" placeholder="Address" class="input input-small span4 requiredField" required>
	</div>
</div>
<div class="row">
	<div class="span4">
	<input input tabindex="2" type="text" name="CPLLname" id="CPLLname" value="#CPLLname#" placeholder="Last Name" class="input input-small span4 requiredField" required>
	</div>
	<div class="span4 offset1">
	<input type="text" name="CPLAddr2" id="CPLAddr2" value="#CPLAddr2#" tabindex="7" placeholder="Address Con't" class="input input-small span4" >
	</div>
</div>
<div class="row">
	<div class="span4">
	<input type="text" name="CPLEmail" id="CPLEmail" value="#CPLEmail#" tabindex="3" placeholder="Email" class="input input-small span4 requiredField" required>
	</div>
	<div class="span4 offset1">
	<input type="text" name="CPLCity" id="CPLCity" value="#CPLCity#" tabindex="8" placeholder="City" class="input input-small span4 requiredField" required>
	</div>
</div>
<div class="row">
	<div class="span4">
	<input type="text" name="CPLDPhone" id="CPLDPhone" value="#CPLDPhone#" tabindex="4" placeholder="Day Phone" class="input input-small span4 requiredField" required>
	</div>
	<div class="span4 offset1">
	<cfinclude template="../member/alerts/alertAttributes.cfm">
				<cfset strForm="CPL">
				<cfset strName="CPLCntry">
				<cfset strType="state">
				<cfset intMulti=0>
				<cfset intsValue=#CPLCntry#>
				<cfset TabIndex=9>
				<cfset Class="">
				<cfset intStart=2>
				
				<!--- <cf_ct_BuildSelector strPassForm="CPL" strSelectorName="CPLCntry" strSelectorType="state" intSelectorMulti="0" intsSelectorValue="#CPLCntry#" TabIndex="9"> --->
				<select name="#strName#" id="#strName#" <cfif intMulti neq "0">multiple size=6</cfif> tabindex="#tabindex#" class="input input-small span4 requiredField" placeholder="State" required>
				<cfif isnumeric(CPLCntry) neq "1">
                    <cfquery datasource="#application.dsn#" name="getStateID">
                    select intoldid from tblstates where (strname='#CPLCntry#' or strshortname='#CPLCntry#')
                    </cfquery>
					<cfif getStateID.recordcount eq "1">
	                    <cfset CPLCntry=getStateID.intoldid>
                    </cfif>
    	            <cfif left(CPLCntry,3) eq "305">
        		        <cfset CPLCntry="305">
                	</cfif>
                </cfif>
				<cfset blnShowOption=1>
	   				<cfset intArray=1>
       				<cfset intsExcludeStates="305">
					<cfif blnShowOption eq "1">
						<option value="" <cfif intsValue eq "">selected</cfif>>
						<cfif (strName eq "intsStateIDs")>All Locations<cfelse>Choose State</cfif></option>
						<!--- <option value="" <cfif intsValue eq "">selected</cfif>><cfif (strName eq "intsStateIDs") or (strName eq "location_preference")>All Locations<cfelse>Choose One</cfif></option> --->
						</cfif>
						<cfparam name="Attributes" default="ER">
						<cfloop index="intIndexNo" from="#intStart#" to="#intStatesArrLen#">
							<cfif ListFind(intsExcludeStates, arrStates[intIndexNo][1]) eq 0>
								<cfif cgi.script_name contains "concierge">
									<cfif #arrStates[intIndexNo][2]# neq "Confidential">
										<option value="#arrStates[intIndexNo][intArray]#" <cfif ListFind(intsValue, arrStates[intIndexNo][intArray]) is not 0> selected</cfif> > 
										<cfif attributes eq "Exec">
											#arrStates[intIndexNo][5]#
										<cfelse>
											<cfif arrStates[intIndexNo][3] neq "">
												#arrStates[intIndexNo][3]#
											<cfelse>
												#arrStates[intIndexNo][2]#
											</cfif>
										</cfif>
										</option>
									</cfif>
								<cfelse>
									<option value="#arrStates[intIndexNo][intArray]#" <cfif ListFind(intsValue, arrStates[intIndexNo][intArray]) is not 0> selected</cfif> >
									<cfif attributes eq "Exec">
										#arrStates[intIndexNo][5]#
									<cfelse>
										<cfif arrStates[intIndexNo][3] neq "">
											#arrStates[intIndexNo][3]#
										<cfelse>
											#arrStates[intIndexNo][2]#
										</cfif>
									</cfif>
									</option> 
								</cfif>
							</cfif>
						</cfloop>
						</select>
	 			<!--- <cf_ct_BuildSelector strPassForm="CPL" strSelectorName="CPLCntry" strSelectorType="state" intSelectorMulti="0" intsSelectorValue="#CPLCntry#" TabIndex="9"> --->
	 			<cfset CPLCntry=intsValue>
	</div>
</div>
<div class="row">
	<div class="span4">
	<input type="text" name="CPLEPhone" id="CPLEPhone" value="#CPLEPhone#" tabindex="5" placeholder="Evening Phone" class="input input-small span4 requiredField" required>
	</div>
	<div class="span4 offset1">
	<input type="text" name="CPLZip" id="CPLZip" value="#CPLZip#" tabindex="10" placeholder="Zip" class="input input-small span4 requiredField" required>
	</div>
</div>
<div class="row">
<div class="span4">
	<input type="submit" class="btn btn-primary btn-large" value="Submit Your Request" name="formfields" id="submitBtn" onclick="return checkform2();">
	</div>
</div>	
	<!--- </cfif> --->

	
	<!--- Carry TabIndex through dynamic fields below... --->
	<cfset TabIndex="11">
	
	<!--- <cfif blnAddtLoggedInFields> 
		<!--- <cfif application.machine EQ "LOCAL" OR application.machine EQ "DEV"> --->
		<cfif strAddtComments eq "" and ValidateQuesMemberID neq "">
			<cfset blnPassAddtComments="0">
			<cfquery datasource="#application.dsn#" name="getAddCommentsQues">
			select strAddCommentsQues from tblCPLMember
			where intmemberid=<cfqueryparam cfsqltype="cf_sql_integer" value="#ValidateQuesMemberID#" />
			</cfquery>
			
			<cfif getAddCommentsQues.recordcount gt 0>
				<cfset strAddCommentsQues=getAddCommentsQues.strAddCommentsQues>
				<cfset strAddtComments=getAddCommentsQues.strAddCommentsQues>
			</cfif>
		</cfif>

		<cfif isdefined('strAddCommentsQues')>
			<script language="JavaScript">
			<!-- 
			function clearfield(){
				if(document.getCPLInfo.strAddtComments.value == '#strAddCommentsQues#'){
					document.getCPLInfo.strAddtComments.value = '';
				}
			}
		 	//-->
			</script>
		</cfif>
	 	<tr><td colspan="3">&nbsp;</td></tr>
	 	<tr>
	  		<td class="bold" valign="top" align="left" colspan="5">
	  			<table>
					<tr>
						<td valign="top" align="right"> 
				 			<input type="hidden" name="strAddCommentsQues" value="#strAddCommentsQues#">
							<cfif blnPassAddtComments neq 1>#in_error0#</cfif>
                            <cfif strAddCommentsQues neq"">*</cfif><b>Additional Comments:&nbsp;</b>
                            <cfif blnPassAddtComments neq 1>#in_error1#</cfif>
                      	</td>
						<td width="5">&nbsp;</td>
						<td><textarea name="strAddtComments" cols="55" rows="3" tabindex="#TabIndex#" onfocus="clearfield();">#strAddtComments#</textarea></td>
						<cfset TabIndex=TabIndex+1>
					</tr>
				</table>
			</td>
	 	</tr>
	</cfif> --->
	
	<!--- ADDITIONAL INFORMATION FIELDS, these are the fields to display if you are not logged in --->
	<!--- <cfif blnAddtFields neq 0>
		<cfif listFind(intFieldList, 1) gt 0>
	 		<tr><td colspan="5">&nbsp;</td></tr> 
	 		<tr>  
                <td class="bold" align="right" nowrap="nowrap">
					<cfif blnPassEdu neq 1>#in_error0#</cfif>
                    *Highest Degree Earned:&nbsp;
                    <cfif blnPassEdu neq 1>#in_error1#</cfif>
                </td>

                <td>
                    <select name="strEducationLevel" tabindex="#TabIndex#">
                    <option value="">Please choose one
                    <option value="High School/GED" <cfif strEducationLevel eq "High School/GED">selected</cfif>>High School/GED
                    <option value="Some College" <cfif strEducationLevel eq "Some College">selected</cfif>>Some College
                    <option value="Associates Degree" <cfif strEducationLevel eq "Associates Degree">selected</cfif>>Associates Degree
                    <option value="BS/BA" <cfif strEducationLevel eq "BS/BA">selected</cfif>>BS/BA
                    <option value="Masters" <cfif strEducationLevel eq "Masters">selected</cfif>>Masters
                    <option value="Doctorate" <cfif strEducationLevel eq "Doctorate">selected</cfif>>Doctorate
                    <option value="Juris Doctorate" <cfif strEducationLevel eq "Juris Doctorate">selected</cfif>>Juris Doctorate
                    </select>
                </td>
			  	
				<cfset TabIndex=TabIndex+1>
	  			
                <td colspan="3">&nbsp;</td>  
	 		</tr>
	 	</cfif> 
	<cfelse>
		<cfif isdefined('blnHighestDegreeRequired') and blnHighestDegreeRequired eq "1">
			<cfif trim(STREDUCATIONLEVEL) eq "">
				<tr><td colspan="5">&nbsp;</td></tr> 
				<tr>  
					<td class="bold" align="right" nowrap="nowrap">
						<cfif blnPassEdu neq 1>#in_error0#</cfif>
                        *Highest Degree Earned:&nbsp;
                        <cfif blnPassEdu neq 1>#in_error1#</cfif>
		          	</td>
                    <td>
                        <select name="strEducationLevel" tabindex="#TabIndex#">
                        <option value="">Please choose one
                        <option value="High School/GED" <cfif strEducationLevel eq "High School/GED">selected</cfif>>High School/GED
                        <option value="Some College" <cfif strEducationLevel eq "Some College">selected</cfif>>Some College
                        <option value="Associates Degree" <cfif strEducationLevel eq "Associates Degree">selected</cfif>>Associates Degree
                        <option value="BS/BA" <cfif strEducationLevel eq "BS/BA">selected</cfif>>BS/BA
                        <option value="Masters" <cfif strEducationLevel eq "Masters">selected</cfif>>Masters
                        <option value="Doctorate" <cfif strEducationLevel eq "Doctorate">selected</cfif>>Doctorate
                        <option value="Juris Doctorate" <cfif strEducationLevel eq "Juris Doctorate">selected</cfif>>Juris Doctorate
                        </select>
                    </td>
				  	<cfset TabIndex=TabIndex+1>
				  	<td colspan="3">&nbsp;</td>  
				 </tr>
			</cfif>
		</cfif>
	</cfif> --->
	
   <!---  <tr><td colspan="5"><img src="images/spacer.gif" width="1" height="15"></td></tr>
	
	<cfif len(ValidateQuesMemberID)>
		<cfquery datasource="#application.dsn#" name="getquestions">
		select intQuestionID,strQuestion,strFormFieldName,intFormFieldType,blnRequired
		from tblCplQuestions
		where intmemberid=<cfqueryparam cfsqltype="cf_sql_integer" value="#ValidateQuesMemberID#" />
		and blnActive=1
		and blnInProgress=0
		order by intorder
		</cfquery>
		
		<cfset strListAdditionalQuestions="#ValueList(getquestions.intQuestionID)#">
		
		<cfif getquestions.recordcount gt 0>
			<tr>
				<td>&nbsp;</td>
				<td colspan="4">
					<table cellpadding="0" cellspacing="0" border="0" width="400">
						<cfloop query="getquestions">
							<cfset thisQuestValidation="blnPass" & strFormFieldName>
							<cfparam name="#thisQuestValidation#" default="1">
							<cfparam name="#strFormFieldName#" default="">
							
							<cfif intFormFieldType gt 2>
								<cfquery datasource="#application.dsn#" name="getOptions">
								select intOptionID,strDisplayText
								from tblCplQuestionOptions
								where intQuestionid=<cfqueryparam cfsqltype="cf_sql_integer" value="#intQuestionID#" />
								and blnActive=1
								</cfquery>
								
                                <cfswitch expression="#intFormFieldType#">
                                    <cfcase value="7">
                                    <input type="hidden" name="#strFormFieldName#" value="#getOptions.strDisplayText#">
                                    </cfcase>

                                    <cfcase value="3">
                                        <!--- select --->
                                        <tr>
                                            <td valign="top"><cfif evaluate(thisQuestValidation) eq "0">#in_error0#</cfif><strong><cfif blnrequired eq "1">*</cfif>#strQuestion#</strong><cfif evaluate(thisQuestValidation) eq "0">#in_error1#</cfif><br>
                                                <select name="#strFormFieldName#" tabindex="#TabIndex#">
                                                    <option value="">- Select an Option -</option>
                                                    <cfloop from="1" to="#getOptions.recordcount#" index="x"><option value="#getOptions.intOptionID[x]#"<cfif evaluate(strFormFieldName) eq getOptions.intOptionID[x]> selected</cfif>>#getOptions.strDisplayText[x]#</option></cfloop>
                                                </select>
                                                <cfset TabIndex=TabIndex+1>
                                            </td>
                                        </tr>
                                        <tr><td><img src="images/spacer.gif" width="1" height="15" border="0"></td></tr>
                                    </cfcase>
									
                                    <cfcase value="4">
										<!--- multi-select --->
										<tr>
											<td valign="top"><cfif evaluate(thisQuestValidation) eq "0">#in_error0#</cfif><strong><cfif blnrequired eq "1">*</cfif>#strQuestion#</strong><cfif evaluate(thisQuestValidation) eq "0">#in_error1#</cfif><br>
												<select name="#strFormFieldName#" multiple tabindex="#TabIndex#" style="width: 250px;">
												<cfloop from="1" to="#getOptions.recordcount#" index="x"><option value="#getOptions.intOptionID[x]#"<cfif listFind(evaluate(strFormFieldName),getOptions.intOptionID[x]) neq "0"> selected</cfif>>#getOptions.strDisplayText[x]#</option></cfloop><!---  --->
												</select>
											 	<cfset TabIndex=TabIndex+1>
											</td>
										</tr>
										<tr><td><img src="images/spacer.gif" width="1" height="15" border="0"></td></tr>
									</cfcase>
                                    
									<cfcase value="5">
										<!--- checkbox --->
										<tr>
											<td valign="middle"><cfif evaluate(thisQuestValidation) eq "0">#in_error0#</cfif><strong><cfif blnrequired eq "1">*</cfif>#strQuestion#</strong><cfif evaluate(thisQuestValidation) eq "0">#in_error1#</cfif><br>
												<!--- don't need a loop, but can't hurt... --->
												<cfloop from="1" to="#getOptions.recordcount#" index="x">
												<input name="#strFormFieldName#" tabindex="#TabIndex#" type="checkbox" value="#getOptions.intOptionID[x]#"<cfif evaluate(strFormFieldName) eq getOptions.intOptionID[x]> checked</cfif>>&nbsp;#getOptions.strDisplayText[x]#<br>
												</cfloop>
												<cfset TabIndex=TabIndex+1>
											</td>
										</tr>
										<tr><td><img src="images/spacer.gif" width="1" height="15" border="0"></td></tr>
									</cfcase>
									
                                    <cfcase value="6">
										<!--- radio button --->
										<tr>
											<td valign="top"><cfif evaluate(thisQuestValidation) eq "0">#in_error0#</cfif><strong><cfif blnrequired eq "1">*</cfif>#strQuestion#</strong><cfif evaluate(thisQuestValidation) eq "0">#in_error1#</cfif><br>
												<cfloop from="1" to="#getOptions.recordcount#" index="x">
												<cfif x gt 1>
												<BR />
												</cfif>
												<input name="#strFormFieldName#" tabindex="#TabIndex#" type="radio" value="#getOptions.intOptionID[x]#"<cfif evaluate(strFormFieldName) eq getOptions.intOptionID[x]> checked</cfif>>&nbsp;#getOptions.strDisplayText[x]#
												</cfloop>
												<cfset TabIndex=TabIndex+1>
											</td>
										</tr>
										<tr>
											<td><img src="images/spacer.gif" width="1" height="15" border="0"></td>
										</tr>
									</cfcase>
								</cfswitch>
							<cfelse>
								<cfswitch expression="#intFormFieldType#">
                                	<cfcase value="7">
									<input type="hidden" name="#strFormFieldName#" value="#getOptions.strDisplayText#">
									</cfcase>
									
                                    <cfcase value="1">
										<!--- text --->
										<tr>
											<td valign="top"><cfif evaluate(thisQuestValidation) eq "0">#in_error0#</cfif><strong><cfif blnrequired eq "1">*</cfif>#strQuestion#</strong><cfif evaluate(thisQuestValidation) eq "0">#in_error1#</cfif><br>
											<input type="text" name="#strFormFieldName#" tabindex="#TabIndex#" value="#evaluate(strFormFieldName)#" size="25">
											<cfset TabIndex=TabIndex+1></td>
										</tr>
										<tr><td><img src="images/spacer.gif" width="1" height="15" border="0"></td></tr>
									</cfcase>
                                    
									<cfcase value="2">
										<!--- text area--->
										<tr>
											<td valign="top"><cfif evaluate(thisQuestValidation) eq "0">#in_error0#</cfif><strong><cfif blnrequired eq "1">*</cfif>#strQuestion#</strong><cfif evaluate(thisQuestValidation) eq "0">#in_error1#</cfif><br>
											<textarea cols="46" rows="5" name="#strFormFieldName#" tabindex="#TabIndex#">#evaluate(strFormFieldName)#</textarea>
											<cfset TabIndex=TabIndex+1></td>
										</tr>
										<tr><td><img src="images/spacer.gif" width="1" height="15" border="0"></td></tr>
									</cfcase>
								</cfswitch>
							</cfif>
						</cfloop>
						<tr><td><input type="hidden" name="strListAdditionalQuestions" value="#strListAdditionalQuestions#"></td></tr>
					</table>
				</td>
			</tr>
		</cfif> 
	</cfif>--->
	
<!--- 	<tr><td colspan="5" align="center">
	<a class="btn btn-primary btn-large" href="">Submit Your Request</a>
	<!--- <input type="image" src="/images/buttons/Step2_ConfirmButton.gif" tabindex="#tabindex#"> --->
	</td></tr>
</table> --->

</cfoutput>
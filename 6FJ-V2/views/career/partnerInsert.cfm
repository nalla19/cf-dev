<cfscript>
//If CPL Directory Does Not Exists
cplDir = application.sixfj.paths.webroot & "\exports\cpls";
cplTime = dateformat(now(),"mm_dd_yy") & "_" & TimeFormat(now(),'HH_mm');
</cfscript>

<cfif not(directoryExists(cplDir))>
	<cfdirectory directory="#cplDir#" action="create" />
</cfif>

<cfparam name="blnPassVerification" default="1" />
<!--- <cftry> --->
<cflock scope="session" timeout="10" type="Exclusive">
    <cfparam name="session.EXEC.intResID" default="">
	<cfset lcl_intResID=session.EXEC.intResID>
</cflock>


<cfparam name="CPLTargetID" default="0">
<cfparam name="CPLMemberIDList" default="">
<cfparam name="returnLink" default="">
<cfparam name="intFormID" default="0">
<cfparam name="blnResPage" default="0">
<cfparam name="intTargetID" default="0">
<cfparam name="TargetLocation" default="0">
<cfparam name="TargetLocation" default="0">
<cfparam name="TargetLocation" default="0">

<cfparam name="lcl_state_id" default="">
<cfparam name="lcl_state" default="N/A">
<cfparam name="lcl_cntry" default="N/A">
<cfparam name="blnCPLoggedIn" default="0">
<cfparam name="strMemberNameList" default="">
<cfparam name="intPID" default="">
	   
<cfif blnResPage neq 0>
	<cfset lcl_intResID=new_resID>
</cfif>

<cfif (lcl_intResID is "")>
 	<cfset lcl_intResID=0>
</cfif>

<cfset blnFoundDup=0>

<!--- additional field names --->
<cfparam name="strEducationLevel" default="">
<cfparam name="strAddtComments" default="">

<!--- Function That Returns The Answer For The Custom CPLs --->
<cffunction name="getCPLQuestionTextConfirmPop" hint="Function That Returns The Answer For The Custom CPLs">
	<cfargument name="questionNumber" type="numeric" required="yes" />    
   
   	<cfquery name="qgetQuestion" datasource="#application.dsn#">
   	select strDisplaytext 
   	from tblCPLQuestionOptions 
   	where intOptionID= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.questionNumber#" />
   	</cfquery>    
	<cfreturn trim(qgetQuestion.strDisplaytext)>
</cffunction>

<cffunction name="getStateAbbr" hint="Function That Returns The State Abbreviation ">
   	<cfargument name="statename" type="string" required="Yes" />      
   	
    <cfquery name="q" datasource="#application.dsn#">
 	select strabbrev 	
	from tblstates where (strShortName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.statename#" /> or strname=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.statename#" />)
	</cfquery>  
	<cfreturn trim(q.strabbrev)>
</cffunction>


<cfif (listLen(CPLMemberIDList) gt 0)> <!--- are there any CPLs to send info 2??? --->
	<cfinclude template="../member/alerts/alertAttributes.cfm">
  
  	<!--- check for dup first --->
  	<cfloop list="#CPLMemberIDList#" index="MemberID">
 		<cfset blnSkip="0">
	
		<cfif isdefined('form.intCPLCustomQuestionList')>
			<cfif ListFind(form.intCPLCustomQuestionList,MemberID) neq "0">
				<cfset blnSkip="1">
			</cfif>
		</cfif>
    	
       
		<cfparam name="cplDeleteList" default="" />

		 <cfscript>
        objip2Location = createObject("component","v26fj.model.ip2location").init(
												dsn=application.dsn,
												machine=application.machine,
												sourceApp=application.sourceApp);
        objCPLInfo = createObject("component","v26fj.model.cpl");
       statename = objip2Location.getStateNamebyID(form.CPLCNTRY);
	   //statename = objip2Location.getStateNamebyID('US');
        isStateVerified = objCPLInfo.isCPLValidByIP(memberid,statename);
        
        if(not(isStateVerified)){
	        cplDeleteList = listappend(cplDeleteList,memberid);
        }
        </cfscript>
		
		
		<!--- CPL Repost --->                 
		<!--- Used to Remove the CPLs by States but only Internation IP Addresses --->
		<cfif isdefined("CPLMemberIDList") and CPLMemberIDList neq "9999999" and not(objip2Location.isDomesticIp())>
			<cfloop list="#CPLMemberIDList#" index="memberid">
				<cfscript>
				blnPassVerification = objip2Location.isCPLVerified(memberid);
				//writeoutput(blnPassVerification);
				tempPos = ListFindNoCase(CPLMemberIDList,memberid);
	
				//CPL Should Be Deleted
				if (not(blnPassVerification) and tempPos gt 0){	
					CPLMemberIDList = ListDeleteAt(CPLMemberIDList,tempPos);
					cplDeleteList = listappend(cplDeleteList,memberid);
				}
				</cfscript>  
			</cfloop>
		</cfif>

		<!--- People Who Opt --->
		<cfif isdefined("cplDeleteList") and listlen(cplDeleteList)>
			<cfset cpl_LoggedInFieldsList="">
			<cfset blnInternationalLead=0>
			<cfset BLNDELETE=1>

			<!--- Use Delete List --->
			<cfloop list="#cplDeleteList#" index="MemberID">
				<cfstoredproc procedure="sp_cpl_check_for_dup" datasource="#application.dsn#" returncode="Yes">
					<cfprocparam type="IN" dbvarname="@intMemberID" value="#val(MemberID)#" cfsqltype="CF_SQL_INTEGER">
					<cfprocparam type="IN" dbvarname="@strEmail" value="#CPLEmail#" cfsqltype="CF_SQL_VARCHAR">
					<cfprocresult resultset="1" name="cfqCheckCPLDup">
				</cfstoredproc>
		
				<cfif not(cfqCheckCPLDup.RecordCount)>	
					<cfstoredproc procedure="sp_cpl_get_cpl_email" datasource="#application.dsn#" returncode="Yes">
                        <cfprocparam type="IN" dbvarname="@intMemberID" value="#val(MemberID)#" cfsqltype="CF_SQL_INTEGER">
                        <cfprocresult resultset="1" name="cfqGetCPLEmail">
                        <cfprocresult resultset="2" name="cfqGetCPLGeoAtts">
                   	</cfstoredproc>			
            
					<cfset cpl_revshare=cfqGetCPLEmail.fltrevshare>
			        
					<!--- Insert Deleted Lead --->	
                    <cftry>	
                        <cfstoredproc procedure="sp_cpl_insert_lead" datasource="#application.dsn#" returncode="Yes">
                            <cfprocparam type="IN" dbvarname="@intMemberID" value="#val(MemberID)#" cfsqltype="CF_SQL_INTEGER">
                            <cfprocparam type="IN" dbvarname="@intResID" value="#val(lcl_intResID)#" cfsqltype="CF_SQL_INTEGER">
                            <cfprocparam type="IN" dbvarname="@intTargetID" value="#val(intTargetID)#" cfsqltype="CF_SQL_INTEGER">	 
                            <cfprocparam type="IN" dbvarname="@strEmail" value="#CPLEmail#" cfsqltype="CF_SQL_VARCHAR">
                            <cfprocparam type="IN" dbvarname="@strFname" value="#CPLFname#" cfsqltype="CF_SQL_VARCHAR">
                            <cfprocparam type="IN" dbvarname="@strLname" value="#CPLLname#" cfsqltype="CF_SQL_VARCHAR">
                            <cfprocparam type="IN" dbvarname="@strAddress" value="#CPLAddr#" cfsqltype="CF_SQL_VARCHAR">
                            <cfprocparam type="IN" dbvarname="@strAddress2" value="#CPLAddr2#" cfsqltype="CF_SQL_VARCHAR" null=#iif(CPLAddr2 is "", 1,0)#>
                            <cfprocparam type="IN" dbvarname="@strCity" value="#CPLCity#" cfsqltype="CF_SQL_VARCHAR">	 
                            <cfprocparam type="IN" dbvarname="@strState" value="#lcl_state#" cfsqltype="CF_SQL_VARCHAR">
                            <cfprocparam type="IN" dbvarname="@strCntry" value="#lcl_cntry#" cfsqltype="CF_SQL_VARCHAR">
                            <cfprocparam type="IN" dbvarname="@strZip" value="#CPLZip#" cfsqltype="CF_SQL_VARCHAR">
                            <cfprocparam type="IN" dbvarname="@strDPhone" value="#CPLDPhone#" cfsqltype="CF_SQL_VARCHAR">
                            <cfprocparam type="IN" dbvarname="@strEPhone" value="#CPLEPhone#" cfsqltype="CF_SQL_VARCHAR">
                            <cfprocparam type="IN" dbvarname="@blnInternational" value="#val(blnInternationalLead)#" cfsqltype="CF_SQL_INTEGER">
                            <cfprocparam type="IN" dbvarname="@blnDelete" value="#val(blnDelete)#" cfsqltype="CF_SQL_INTEGER">
                            
                            <cfif len(strEducationLevel)>
                                <cfprocparam type="IN" dbvarname="@strEducationLevel" value="#strEducationLevel#" cfsqltype="CF_SQL_VARCHAR">
                            <cfelse>
                                <cfprocparam type="IN" dbvarname="@strEducationLevel" value="1" cfsqltype="CF_SQL_VARCHAR">
                            </cfif>
                            
                            <cfif ListFind(cpl_LoggedInFieldsList, 1) gt 0>
                                <cfif len(strAddtComments)>
                                    <cfprocparam type="IN" dbvarname="@strAddtComment" value="#strAddtComments#" cfsqltype="CF_SQL_VARCHAR">
                                <cfelse>
                                    <cfprocparam type="IN" dbvarname="@strAddtComment" value="[answer withheld by client]" cfsqltype="CF_SQL_VARCHAR">
                                </cfif>	 
                            <cfelse>
                                <cfprocparam type="IN" dbvarname="@strAddtComment" cfsqltype="CF_SQL_VARCHAR" null="1">
                            </cfif>
                            
                            <cfprocparam type="IN" dbvarname="@intTargetLocation" value="#TargetLocation#" cfsqltype="CF_SQL_VARCHAR">
                            
                            <cfif len(intLeadTrackingID)>
                                <cfprocparam type="IN" dbvarname="@intLeadTrackingID" value="#intLeadTrackingID#" cfsqltype="CF_SQL_INTEGER">
                            <cfelse>
                                <cfprocparam type="IN" dbvarname="@intLeadTrackingID" value="0" cfsqltype="CF_SQL_INTEGER">
                            </cfif>
                            
                            <cfif len(intPID)>
                                <cfprocparam type="IN" dbvarname="@intPID" value="#intPID#" cfsqltype="CF_SQL_INTEGER">
                            <cfelse>
                                <cfprocparam type="IN" dbvarname="@intPID" value="0" cfsqltype="CF_SQL_INTEGER">
                            </cfif>
                            
                            <cfprocparam type="IN" dbvarname="@fltRevShare" value="#cpl_revshare#" cfsqltype="CF_SQL_INTEGER">
                            <cfprocparam type="IN" dbvarname="@ipaddress" value="#cgi.REMOTE_ADDR#" cfsqltype="cf_sql_varchar">
                            
                            <cfprocresult resultset="1" name="qcpl" />
                            <cfprocresult resultset="2" name="cfqGetCPLEmail" />       
                        </cfstoredproc>           
                       	
                        <cfcatch  type="any">
                        	
                        </cfcatch>
                  	</cftry>
				</cfif>
			</cfloop>	
		</cfif>
    
   		<cfset blnInternationalLead=0>
   		<cfstoredproc procedure="sp_cpl_check_for_dup" datasource="#application.dsn#" returncode="Yes">
            <cfprocparam type="IN" dbvarname="@intMemberID" value="#val(MemberID)#" cfsqltype="CF_SQL_INTEGER">
            <cfprocparam type="IN" dbvarname="@strEmail" value="#CPLEmail#" cfsqltype="CF_SQL_VARCHAR">
            <cfprocresult resultset="1" name="cfqCheckCPLDup">
   		</cfstoredproc>      
  
   		<cfif cfqCheckCPLDup.RecordCount eq 0 and blnPassVerification eq "1" and blnSkip eq "0"> <!--- if not a dup, bad IP or popup custom form -  insert, otherwise ignore the entry --->   
			<!--- get the email info --->	
            <cfstoredproc procedure="sp_cpl_get_cpl_email" datasource="#application.dsn#" returncode="Yes">
	            <cfprocparam type="IN" dbvarname="@intMemberID" value="#val(MemberID)#" cfsqltype="CF_SQL_INTEGER">
    	        <cfprocresult resultset="1" name="cfqGetCPLEmail">
        	    <cfprocresult resultset="2" name="cfqGetCPLGeoAtts">
            </cfstoredproc>
    
			<cfif (cfqGetCPLEmail.RecordCount eq 1)>
				<cfset cpl_want_RTL_email=cfqGetCPLEmail.blnSendEmail>
                <cfset toEmail=cfqGetCPLEmail.strRealTimeEmail>
                <cfset toEmailBCC=cfqGetCPLEmail.strRealTimeEmailBCC> 
                <cfset fromEmail=cfqGetCPLEmail.strRealTimeFrom>
                <cfset subject=cfqGetCPLEmail.strRealTimeSubject>
                <cfset cpl_international=cfqGetCPLEmail.blnInternational>
                <cfset cpl_AddFieldsList=cfqGetCPLEmail.intAddFieldList>
                <cfset cpl_LoggedInFieldsList=cfqGetCPLEmail.intLoggedInFieldsList>
                <cfset cpl_name=cfqGetCPLEmail.strDisplayName>
                <cfset strMemberNameList=listAppend(strMemberNameList, cfqGetCPLEmail.strDisplayName, ";")>
                <cfset cpl_confirmation_mail_body=cfqGetCPLEmail.strCEmailBody>
                <cfset cpl_confirmation_HTML_mail_body=cfqGetCPLEmail.strCHTMLEmailBody>
                
                <!--- CPL Lead Cap --->
                <cfset cpl_leadcap=cfqGetCPLEmail.intleadcap>
                <cfset cpl_leadcapstartdate=cfqGetCPLEmail.dteleadcapstart>
                
                <cfset cpl_geo_list=valueList(cfqGetCPLGeoAtts.intAttID)>
                <cfset cpl_revshare=cfqGetCPLEmail.fltrevshare>
          	<cfelse>
                <cfset cpl_want_RTL_email=1>
                <cfset toEmail="webmaster@6figurejobs.com">
                <cfset toEmailBCC="webmaster@6figurejobs.com">
                <cfset fromEmail="RealTimeCPLEmail@6FigureJobs.com">
                <cfset subject="6FigureJobs Lead - Failed getting CPL info for R.T.L.">
                <cfset cpl_international=0>
                <cfset cpl_AddFieldsList="">
                <cfset cpl_LoggedInFieldsList="">
                <cfset cpl_name="">
                <cfset cpl_confirmation_mail_body="">
                <cfset cpl_confirmation_HTML_mail_body="">
                <cfset cpl_geo_list="">
                <cfset cpl_revshare="0">
            </cfif>
    	
			<cfset blnDelete=1> <!--- archive the lead ? --->
			<cfset blnSendRTEmail=cpl_want_RTL_email> <!--- send RT email to CPL --->
			<cfset int_client_email=2> <!--- send email to client. 1: confirm email, 2: reject email b/c of geo location --->
	
			<cfset lcl_cntry="N/A">
	
			<!--- 02/14/2007: Fix added to submit Northern & southern California as California --->
            <cfif not isdefined('CPLCntryOrig')>
                <cfset CPLCntryOrig=CPLCntry>
            </cfif>

			<cfif memberID eq "1">
            	<cfif (blnCPLoggedIn eq 1)>
                	<cfif CPLCntry contains "California">
                        <cfset CPLCntry = "California">
                    </cfif>
                <cfelse>
                    <cfif left(CPLCntry,3) eq "305">
                        <cfset CPLCntry = "305">
                    </cfif>
                </cfif>
            <cfelse>
                <cfset CPLCntry = CPLCntryOrig>
            </cfif>
		
			<cfif (blnCPLoggedIn eq 1)>
    	        <cfloop index="i" from="2" to="#intStatesArrLen#">
        		    <cfif CPLCntry eq arrStates[i][2]>
					
			            <cfset lcl_state_id=arrStates[i][1]>
			            <cfset lcl_state_abbrv=arrStates[i][3]>
			            <cfset lcl_state=arrStates[i][2]>
			            <cfset lcl_cntry=arrStates[i][4]>	   
			            <cfif arrStates[i][1] gt 351> <!--- 301-351 is US states only; anything higher is international --->
				            <cfif arrStates[i][1] neq 3050 and arrStates[i][1] neq 3051><!--- 3051-3050 are California. These were forgotten about above... --->
					            <cfset blnInternationalLead=1>
				            </cfif>
			            </cfif>
			            <cfbreak>
					<!--- If additional question were required, state was passed as ID instead of name--->
      				<cfelseif CPLCntry eq arrStates[i][1]>
						<cfset lcl_state_id=arrStates[i][1]>
						<cfset lcl_state_abbrv=arrStates[i][3]>
                        <cfset lcl_state=arrStates[i][2]>
                        <cfset lcl_cntry=arrStates[i][4]>	   
                        <cfif arrStates[i][1] gt 351> <!--- 301-351 is US states only; anything higher is international --->
                        	<cfif arrStates[i][1] neq 3050 and arrStates[i][1] neq 3051><!--- 3051-3050 are California. These were forgotten about above... --->
                        		<cfset blnInternationalLead=1>
                        	</cfif>
                        </cfif>
						<cfbreak>
	  				</cfif>
     			</cfloop>
			<cfelse>
                <cfloop index="i" from="2" to="#intStatesArrLen#">
	               <cfif CPLCntry eq arrStates[i][2]>
					
			            <cfset lcl_state_id=arrStates[i][1]>
			            <cfset lcl_state_abbrv=arrStates[i][3]>
			            <cfset lcl_state=arrStates[i][2]>
			            <cfset lcl_cntry=arrStates[i][4]>	   
			            <cfif arrStates[i][1] gt 351> <!--- 301-351 is US states only; anything higher is international --->
				            <cfif arrStates[i][1] neq 3050 and arrStates[i][1] neq 3051><!--- 3051-3050 are California. These were forgotten about above... --->
					            <cfset blnInternationalLead=1>
				            </cfif>
			            </cfif>
			            <cfbreak>
					<!--- If additional question were required, state was passed as ID instead of name--->
      				<cfelseif CPLCntry eq arrStates[i][1]>
    		            <cfset lcl_state_id=arrStates[i][1]>
            		    <cfset lcl_state_abbrv=arrStates[i][3]>
		                <cfset lcl_state=arrStates[i][2]>
		                <cfset lcl_cntry=arrStates[i][4]>
		                <cfif arrStates[i][1] gt 351> <!--- 301-351 is US states only; anything higher is international --->
			                <cfif arrStates[i][1] neq 3050 and arrStates[i][1] neq 3051><!--- 3051-3050 are California. These were forgotten about above... --->
			        	        <cfset blnInternationalLead=1>
		                	</cfif>
	                	</cfif>
		                <cfbreak>
                	</cfif>
                </cfloop>	
			</cfif>
	
			<cfif (cpl_international eq 0)> <!--- only US locations --->
				<cfif (blnInternationalLead eq 0)> <!--- and the lead IS NOT international --->
					<cfif (listFind(cpl_geo_list, "300") gt 0)>
						<cfset blnDelete=0>
                        <cfset int_client_email=1>
                    <cfelseif (listFind(cpl_geo_list, lcl_state_id) gt 0)> <!--- if not Int', then go looking for the specific location --->
                        <cfset blnDelete=0>
                        <cfset int_client_email=1>
                    </cfif>
               	</cfif>
          	<cfelse> <!--- YES to international, then check the list --->
				<cfif (listFind(cpl_geo_list, "300") gt 0)>
                	<cfset blnDelete=0>
               		<cfset int_client_email=1>
                <cfelseif (listFind(cpl_geo_list, lcl_state_id) gt 0)> <!--- if not Int', then go looking for the specific location --->
                	<cfset blnDelete=0>
                	<cfset int_client_email=1>
                </cfif>
           	</cfif>
	
			<cfif not isdefined('strHighestDegree')>
				<cfset strHighestDegree=strEducationLevel>
			</cfif>
							
			<cfif (int_client_email eq 1)> <!--- if not in the geo targeting, do NOT insert the lead (in case profile changes) --->           
    	        <cfif (MemberID eq 23)> <!--- insert the lead for AMX --->	      
                    <cfquery name="cfqInsertAMXLead" datasource="#application.dsn#">
                    insert into tblAMXRpt
                    (intResID, intPartnerSite, FName, LName, Addr1, City, State, Zip, PrimaryPhone, SecondaryPhone, Email)
                    values 
                    (#lcl_intResID#, 'sixfigure', '#CPLFname#', '#CPLLname#', '#CPLAddr#', '#CPLCity#', '#lcl_state_abbrv#', '#CPLZip#', '#CPLDPhone#', '#CPLEPhone#', '#CPLEmail#')
                    </cfquery>	  
              	</cfif>

				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 50------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->                	 	 		        
				<cfif application.machine EQ "LIVE">
					<cfif (MemberID eq "50")>
                        <cfhttp url="http:info.bisk.com/PostLead.asp?Source=190983zt1&FormID=9601" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                            <cfhttpparam type="FORMFIELD" name="Element2" value="Test"><!--- #CPLFname# --->
                            <cfhttpparam type="FORMFIELD" name="Element6" value="Test"><!--- #CPLLname# --->
                            <cfhttpparam type="FORMFIELD" name="Element8" value="test@6figurejobs.com">
                            <cfhttpparam type="FORMFIELD" name="Element12" value="#CPLCity#">
                            <cfhttpparam type="FORMFIELD" name="Element13" value="#lcl_state#">
                            <cfhttpparam type="FORMFIELD" name="Element14" value="#CPLZip#">
                            <cfhttpparam type="FORMFIELD" name="Element15" value="#CPLDPhone#">
                            <cfhttpparam type="FORMFIELD" name="Element17" value="#CPLEPhone#">
                            <cfhttpparam type="FORMFIELD" name="Element34" value="#lcl_cntry#">
                            <cfif len(CPLAddr2)>
                                <cfset Addr=CPLAddr & ", " & CPLAddr2>
                            <cfelse>
                                <cfset Addr=CPLAddr>
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="Element90" value="#Addr#">
                            <cfif isdefined('strHighestDegree') and strHighestDegree neq "">
                                <cfset EdLevel="#strHighestDegree#">
                            <cfelse>
                                <cfset EdLevel="">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="Element129" value="#EdLevel#">
                        </cfhttp>
                    <cfelseif (MemberID eq "51")>
                            <!--- Add Univ of Phoenix tracking --->
                    </cfif>
 		    	</cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 50-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->                
                
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 51------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->                	 	 
				<cfif (MemberID eq "51")>
	                <cfset AcceptableLeads="BS/BA,Masters,Doctorate">
    	            <cfset blnPassPhoenixValidation="0">
        	        <cfif ListContains(AcceptableLeads,strHighestDegree,",") gt 0>
            		    <cfset blnPassPhoenixValidation="1">
	                <cfelse>
		                <cfset blnDelete=1>
		                <cfset blnSendRTEmail=0>
		                <cfif int_client_email eq "1">
			                <cfset int_client_email="0">
		                </cfif>
	                </cfif>
					
					<cfif blnPassPhoenixValidation eq "1">
						<!--- Add Univ of Phoenix tracking http://www.ithinkbig.com/schools/uphoenix/form/handleform.php --->
                        <cfhttp   url="http://www.ithinkbig.com/schools/uphoenix/form/handleform.php" method="POST" timeout="10" redirect="No" resolveurl="Yes">

                            <cfhttpparam type="FORMFIELD" name="MHID" value="1011">
                            <cfif application.machine NEQ "LIVE">
                                <cfhttpparam type="FORMFIELD" name="mode" value="1"><!--- Test mode, but change url to test url anyway above --->
                            <cfelse>
                                <cfhttpparam type="FORMFIELD" name="mode" value="0">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="date" value="#DateFormat(now(),'mm/dd/yyyy')#">
                            <cfhttpparam type="FORMFIELD" name="time" value="#timeFormat(now(),'HH:mm')#">
                            
                            <cfhttpparam type="FORMFIELD" name="ipaddress" value="#CGI.REMOTE_ADDR#">
                            
                            <cfhttpparam type="FORMFIELD" name="firstname" value="#CPLFname#">
                            <cfhttpparam type="FORMFIELD" name="lastname" value="#CPLLname#">
                            <cfhttpparam type="FORMFIELD" name="address" value="#CPLAddr#">
                            <cfif len(CPLAddr2)>
                                <cfhttpparam type="FORMFIELD" name="address2" value="#CPLAddr2#">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="city" value="#CPLCity#">
                            
                            
                            <cfparam name="PhoenixState" default="0">
                            <cfif lcl_state contains "California">
                                <cfset PhoenixState="5">
                            <cfelse>
                                <cfquery name="cfqMapStates" datasource="#application.dsn#">
                                    select strname from tblstates where strCountry ='US' and intoldid not in (3051,3050)
                                    order by strname
                                </cfquery>
                                <cfset arrStatePhoenix=ArrayNew(2)>
                                <cfloop from="1" to="#cfqMapStates.RecordCount#" index="p">
                                    <cfset arrStatePhoenix[p][1] = p>
                                    <cfset arrStatePhoenix[p][2] = cfqMapStates.strName[p]>
                                </cfloop>
                                <cfloop from="1" to="#Arraylen(arrStatePhoenix)#" index="ps">
                                    <cfif #arrStatePhoenix[ps][2]# eq  lcl_state>
                                        <cfset PhoenixState=arrStatePhoenix[ps][1]>
                                    </cfif>
                                </cfloop>
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="state" value="#PhoenixState#">
                            
                            <cfhttpparam type="FORMFIELD" name="zip" value="#CPLZip#">
                            <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                            <cfif lcl_cntry eq "US">
                                <cfset PostCountry="1">
                            <cfelse>
                                <cfset PostCountry="0"><!--- lcl_cntry --->
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="country" value="#PostCountry#">
                            
                            <cfset tempphone=replace(CPLEPhone,"(","","all")>
                            <cfset tempphone=replace(tempphone,")","","all")>
                            <cfset tempphone=replace(tempphone,".","","all")>
                            <cfset tempphone=replace(tempphone,"-","","all")>
                            <cfloop condition="#tempphone# contains ' '">
                                <cfset tempphone=replace(tempphone," ","","all")>
                            </cfloop>
                            
                            
                            <cfset tempphone=right(tempphone,10)>
                            <cfset phonearea=left(tempphone,3)>
                            <cfset phonecity=mid(tempphone,4,3)>
                            <cfset phone=right(tempphone,4)>
                            
                            <cfhttpparam type="FORMFIELD" name="phonearea" value="#phonearea#">
                            <cfhttpparam type="FORMFIELD" name="phonecity" value="#phonecity#">
                            <cfhttpparam type="FORMFIELD" name="phone" value="#phone#">
                            
                            <cfhttpparam type="FORMFIELD" name="phone2area" value="#phonearea#">
                            <cfhttpparam type="FORMFIELD" name="phone2city" value="#phonecity#">
                            <cfhttpparam type="FORMFIELD" name="phone2" value="#phone#">
                            
                            <cfhttpparam type="FORMFIELD" name="email" value="#CPLEmail#">
                            <cfhttpparam type="FORMFIELD" name="program" value="23">
                            
                            <cfif PostCountry eq "1">
                                <cfhttpparam type="FORMFIELD" name="uscitizen" value="1">
                            <cfelse>
                                <cfhttpparam type="FORMFIELD" name="uscitizen" value="0">
                            </cfif>
                            
                            <cfhttpparam type="FORMFIELD" name="contact" value="1">		 
                            <cfparam name="edlevel" default="">
                            <cfswitch expression="#strHighestDegree#">
                               
                                <cfcase value="BS/BA">
                                    <cfset edlevel="9">
                                </cfcase>
                                <cfcase value="Masters">
                                    <cfset edlevel="10">
                                </cfcase>
                                <cfcase value="Doctorate">
                                    <cfset edlevel="10">
                                </cfcase>
                                <cfdefaultcase>
                                    <cfset edlevel="5">
                                </cfdefaultcase>
                            </cfswitch>
                            <cfhttpparam type="FORMFIELD" name="educationlevel" value="#edlevel#">
						</cfhttp>	
					<cfelse>
						<!--- Send rejection email 
						<cfinclude template="/email/CPL/cplOptinRejEmail51.cfm">--->
                    </cfif>         
				</cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 51-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->
                
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 52------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->                	 	                 
				<cfif MemberID eq "52">
                    <cfset AcceptableLeads="BS/BA,Masters,Doctorate">
                    <cfset blnPassCapellaValidation="0">
                    <cfif ListContains(AcceptableLeads,strHighestDegree,",") gt 0>
                        <cfset blnPassCapellaValidation="1">
                    <cfelse>
                        <cfset blnDelete=1>
                        <cfset blnSendRTEmail=0>
                        <cfif int_client_email eq "1">
                            <cfset int_client_email="0">
                        </cfif>
                    </cfif>
                    
                    <cfif blnPassCapellaValidation eq "1">
                    	<cfhttp   url="http://www.ithinkbig.com/schools/capellau/form/handleform.php" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                            <cfhttpparam type="FORMFIELD" name="MHID" value="1011"><!--- 1011 (Phoenix) --->
                            
                           <cfif application.machine NEQ "LIVE">
                                <cfhttpparam type="FORMFIELD" name="mode" value="1"><!--- Test mode, but change url to test url anyway above --->
                            <cfelse>
                                <cfhttpparam type="FORMFIELD" name="mode" value="0">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="date" value="#DateFormat(now(),'mm/dd/yyyy')#">
                            <cfhttpparam type="FORMFIELD" name="time" value="#timeFormat(now(),'HH:mm')#">
                            
                            
                            <cfhttpparam type="FORMFIELD" name="firstname" value="#CPLFname#">
                            <cfhttpparam type="FORMFIELD" name="lastname" value="#CPLLname#">
                            <cfhttpparam type="FORMFIELD" name="address" value="#CPLAddr#">
                            <cfif len(CPLAddr2)>
                                <cfhttpparam type="FORMFIELD" name="address2" value="#CPLAddr2#">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="city" value="#CPLCity#">
                            
                            <!--- Need to map state abbrev below --->
                            
                            <cfparam name="CapellaState" default="0">
                            <cfloop from="1" to="#Arraylen(arrStates)#" index="cp">
                                <cfif #arrStates[cp][2]# eq  lcl_state>
                                    <cfset CapellasState=arrStates[cp][3]>
                                </cfif>
                            </cfloop>
                            <cfif CapellasState eq "PQ">
                                <cfset CapellasState="QC">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="state" value="#CapellasState#">
                            
                            <cfhttpparam type="FORMFIELD" name="zip" value="#CPLZip#">
                            <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                            <cfif lcl_cntry eq "US">
                                <cfset PostCountry="2">
                            <cfelse>
                                <cfset PostCountry="0"><!--- lcl_cntry --->
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="country" value="#PostCountry#">
                            
                            <cfset tempphone=replace(CPLEPhone,"(","","all")>
                            <cfset tempphone=replace(tempphone,")","","all")>
                            <cfset tempphone=replace(tempphone,".","","all")>
                            <cfset tempphone=replace(tempphone,"-","","all")>
                            <cfloop condition="#tempphone# contains ' '">
                                <cfset tempphone=replace(tempphone," ","","all")>
                            </cfloop>
                            <cfset tempphone=right(tempphone,10)>
                            <cfhttpparam type="FORMFIELD" name="phone" value="#tempphone#">
                            <cfhttpparam type="FORMFIELD" name="phone2" value="#tempphone#">
                            <cfhttpparam type="FORMFIELD" name="email" value="#CPLEmail#">
                            
                            <!--- Default Values set by Capella --->
                            <cfhttpparam type="FORMFIELD" name="school" value="1">
                            <cfhttpparam type="FORMFIELD" name="degree" value="2">
                            <cfhttpparam type="FORMFIELD" name="program" value="10">
                            <cfhttpparam type="FORMFIELD" name="age" value="4">
                            
                            <cfparam name="edlevel" default="">
                            <cfswitch expression="#strHighestDegree#">
                               
                                <cfcase value="BS/BA">
                                    <cfset edlevel="10">
                                </cfcase>
                                <cfcase value="Masters">
                                    <cfset edlevel="13">
                                </cfcase>
                                <cfcase value="Doctorate">
                                    <cfset edlevel="16">
                                </cfcase>
                                <cfdefaultcase>
                                    <cfset edlevel="10">
                                </cfdefaultcase>
                            </cfswitch>
                            <cfhttpparam type="FORMFIELD" name="educationlevel" value="#edlevel#">
                            <cfset PlannedStartDate=DateAdd('m',3,now())>
                            <cfset PlannedStartDate=DateAdd('m',3,now())>
                            <cfset startdatemonth=DateFormat(PlannedStartDate,'m')>	
                            <cfset startdateyear=DateFormat(PlannedStartDate,'yyyy')>
                            <cfhttpparam type="FORMFIELD" name="startdatemonth" value="#startdatemonth#">
                            <cfhttpparam type="FORMFIELD" name="startdateyear" value="#startdateyear#">
                        </cfhttp>
                        <!--- <cfoutput>#cfhttp.filecontent#</cfoutput><cfabort>  --->
                    <cfelse>    
						<!--- Send rejection email 
						<cfinclude template="/email/CPL/cplOptinRejEmail52.cfm">--->
                    </cfif>
            	</cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 52-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->  	
                     
                     
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 74------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->                	 	                 	 
				<cfif MemberID eq "74">
                  	<cfset AcceptableLeads="BS/BA,Masters,Doctorate">
					<cfset blnPassNortheasternValidation="0">
                    <!--- Disable the confirmation/standard rejection email - custom reject will be sent only - no confirmation email --->
                    <cfset int_client_email="0">
                    
					<cfif ListContains(AcceptableLeads,strHighestDegree,",") gt 0>
                        <cfset blnPassNortheasternValidation="1">
                    <cfelse>
                        <cfset blnDelete=1>
                        <cfset blnSendRTEmail=0>
                        <cfif int_client_email eq "1">
                            <cfset int_client_email="0">
                        </cfif>
                    </cfif>
                    
                    <cfif blnPassNortheasternValidation eq "1">
                    	<cfif application.machine NEQ "LIVE">
                            <!--- Dev Test page which will email submitted form values --->
                            <cfset NUURL="#request.url#/jim_northeastern_testing.cfm?cpltest=1">
                            <!--- Staging URL below does Not work... Submit test leads to production (http://www.leadpost.net/coreg/controller) using FName: test, Lname: test, email: testlead@quinstreet.com --->
                            <!--- <cfset NUURL="http://leadform.quinstage.com/coreg/controller"> --->
                            <!--- Production URL (see testing instructions in staging comment above) --->
                            <!--- <cfset NUURL="http://www.leadpost.net/coreg/controller"> --->
                        <cfelse>
                            <cfset NUURL="http://www.leadpost.net/coreg/controller">
                        </cfif>
                        
                        <cfhttp url="#NUURL#" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                            <cfhttpparam type="FORMFIELD" name="headerKey" value="1293">
                            <cfhttpparam type="FORMFIELD" name="identifierKey" value="20268355">
                            <cfhttpparam type="FORMFIELD" name="url" value="http://b.boguys.com/cgi/r?;n=203;c=266578;s=5664;x=7936;f=200703141053290;u=j;z=TIMESTAMP;">
                            <cfhttpparam type="FORMFIELD" name="FN" value="#CPLFname#">
                            <cfhttpparam type="FORMFIELD" name="LN" value="#CPLLname#">
                            <cfhttpparam type="FORMFIELD" name="EM" value="#CPLEmail#">
                            <cfhttpparam type="FORMFIELD" name="S1" value="#CPLAddr#">
                            <cfif len(CPLAddr2)>
                                <cfhttpparam type="FORMFIELD" name="S2" value="#CPLAddr2#">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="CT" value="#CPLCity#">
                            <cfquery name="cfqGetNUState" datasource="#application.dsn#">
                                select strabbrev from tblstates where (strShortName='#lcl_state#' or strname='#lcl_state#')
                            </cfquery>
                            <cfif cfqGetNUState.recordcount gt 0>
                                <cfset NUState=cfqGetNUState.strabbrev>
                            <cfelse>
                                <cfset NUState="NA">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="SP" value="#NUState#">
                            <cfhttpparam type="FORMFIELD" name="PC" value="#CPLZip#">
                            <cfhttpparam type="FORMFIELD" name="CN" value="#lcl_cntry#">
                            
                            <cfset tempphone=replace(CPLEPhone,"(","","all")>
                            <cfset tempphone=replace(tempphone,")","","all")>
                            <cfset tempphone=replace(tempphone,".","","all")>
                            <cfset tempphone=replace(tempphone,"-","","all")>
                            <cfloop condition="#tempphone# contains ' '">
                                <cfset tempphone=replace(tempphone," ","","all")>
                            </cfloop>
                            <cfset hphone=right(tempphone,10)>
                            <cfhttpparam type="FORMFIELD" name="HP" value="#hphone#">
                            
                            <cfset tempphone=replace(CPLDPhone,"(","","all")>
                            <cfset tempphone=replace(tempphone,")","","all")>
                            <cfset tempphone=replace(tempphone,".","","all")>
                            <cfset tempphone=replace(tempphone,"-","","all")>
                            <cfloop condition="#tempphone# contains ' '">
                                <cfset tempphone=replace(tempphone," ","","all")>
                            </cfloop>
                            <cfset wphone=right(tempphone,10)>
                            <cfhttpparam type="FORMFIELD" name="WP" value="#wphone#">
                            
                            <cfif strHighestDegree eq "BS/BA">
                                <cfset Degree="Bachelors">
                            <cfelse>
                                <cfset Degree="#strHighestDegree#">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="A1" value="#Degree#">
                            
                            <!--- Custom Form Questions --->
                            <!--- Must be hardcoded to the field name assigned in CPL admin --->
                            <cfif isdefined('form.ProgramOfInterest')>
                                <!--- Look up display text from Custom option ID --->
                                <cfquery datasource="#application.dsn#" name="getNUQ1Answer">
                                    select strDisplaytext from tblCPLQuestionOptions where intOptionID=#form.ProgramOfInterest#
                                </cfquery>
                                <cfif getNUQ1Answer.recordcount gt 0>
                                    <cfset NUProgramDesc=getNUQ1Answer.strDisplaytext>
                                <cfelse>
                                    <cfset NUProgramDesc="">
                                </cfif>
                            <cfelse>
                                <cfset NUProgramDesc="">
                            </cfif>	
                            <cfset NUProgramValue="">
                            <!--- /Custom Form Question --->
                            <cfswitch expression="#trim(NUProgramDesc)#">
                                <cfcase value="MBA - Finance">
                                    <cfset NUProgramValue="NEUMBAF">
                                </cfcase>
                                <cfcase value="MBA - High Technology">
                                    <cfset NUProgramValue="NEUMBAHT">
                                </cfcase>
                                <cfcase value="MBA - Innovation Entrepreneurship">
                                    <cfset NUProgramValue="NEUMBAIE">
                                </cfcase>
                                <cfcase value="MBA - International Management">
                                    <cfset NUProgramValue="NEUMBAIM">
                                </cfcase>
                                <cfcase value="MBA - Marketing">
                                    <cfset NUProgramValue="NEUMBAM">
                                </cfcase>
                                <cfcase value="MBA - Supply Chain Management">
                                    <cfset NUProgramValue="NEUMBASCM">
                                </cfcase>
                                <cfdefaultcase>
                                    <cfset NUProgramValue="[Not Entered]">
                                </cfdefaultcase>
                            </cfswitch>
                            <cfhttpparam type="FORMFIELD" name="A2" value="#NUProgramValue#">
                            
                            <cfif isdefined('form.CurrentJobTitle')>
                                <cfhttpparam type="FORMFIELD" name="A6" value="#form.CurrentJobTitle#">
                            <cfelse>
                                <cfhttpparam type="FORMFIELD" name="A6" value="[Not Entered]">
                            </cfif>
                            
                            <cfif isdefined('form.CurrentEmployer')>
                                <cfhttpparam type="FORMFIELD" name="A7" value="#form.CurrentEmployer#">
                            <cfelse>
                                <cfhttpparam type="FORMFIELD" name="A7" value="[Not Entered]">
                            </cfif>
                            
                            <cfif isdefined('form.TuitionReimbursement')>
                                <!--- Look up display text from Custom option ID --->
                                <cfquery datasource="#application.dsn#" name="getNUQ2Answer">
                                    select strDisplaytext from tblCPLQuestionOptions where intOptionID=#form.TuitionReimbursement#
                                </cfquery>
                                <cfif getNUQ2Answer.recordcount gt 0>
                                    <cfhttpparam type="FORMFIELD" name="A8" value="#getNUQ2Answer.strDisplaytext#">
                                <cfelse>
                                    <cfhttpparam type="FORMFIELD" name="A8" value="[Not Entered]">
                                </cfif>
                            <cfelse>
                                <cfhttpparam type="FORMFIELD" name="A8" value="[Not Entered]">
                            </cfif>
                        </cfhttp>
                        <!--- <cfoutput>#cfhttp.filecontent#</cfoutput><cfabort>  --->
					<cfelse>
                    	<!--- Send rejection email 
						<cfinclude template="/email/CPL/cplOptinRejEmail74.cfm">--->
                    </cfif>
            	</cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 74-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->  	             
                     
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 75------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->                	 	                 	 
				<cfif MemberID eq "75">
                    <cfset AcceptableLeads="BS/BA,Masters,Doctorate">
                    <cfset blnPassNorwichValidation="0">
                    <!--- Disable the confirmation/standard rejection email - custom reject will be sent only - no confirmation email --->
                    <cfset int_client_email="0">
                    <cfif ListContains(AcceptableLeads,strHighestDegree,",") gt 0>
                        <cfset blnPassNorwichValidation="1">
                    <cfelse>
                        <cfset blnDelete=1>
                        <cfset blnSendRTEmail=0>
                    </cfif>
                    
                    <cfif blnPassNorwichValidation eq "1">
                        <cfif application.machine NEQ "LIVE">
                            <!--- Dev Test page which will email submitted form values --->
                            <cfset NorwichURL="#request.url#/jim_Norwich_testing.cfm?cpltest=1">
                            <!--- Staging URL below does Not work... Submit test leads to production (http://www.leadpost.net/coreg/controller) using FName: test, Lname: test, email: testlead@quinstreet.com --->
                            <!--- <cfset NorwichURL="http://leadform.quinstage.com/coreg/controller"> --->
                            <!--- Production URL (see testing instructions in staging comment above) --->
                            <!--- <cfset NorwichURL="http://www.leadpost.net/coreg/controller"> --->
                        <cfelse>
                            <!--- Production URL --->
                            <cfset NorwichURL="http://www.leadpost.net/coreg/controller">
                        </cfif>
                        <cfhttp   url="#NorwichURL#" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                            <cfhttpparam type="FORMFIELD" name="headerKey" value="1293">
                            <cfhttpparam type="FORMFIELD" name="identifierKey" value="20268355">
                            <cfhttpparam type="FORMFIELD" name="url" value="http://b.boguys.com/cgi/r?;n=203;c=266578;s=5664;x=7936;f=200703141053290;u=j;z=TIMESTAMP;">
                            <cfhttpparam type="FORMFIELD" name="FN" value="#CPLFname#">
                            <cfhttpparam type="FORMFIELD" name="LN" value="#CPLLname#">
                            <cfhttpparam type="FORMFIELD" name="EM" value="#CPLEmail#">
                            <cfhttpparam type="FORMFIELD" name="S1" value="#CPLAddr#">
                            <cfif len(CPLAddr2)>
                                <cfhttpparam type="FORMFIELD" name="S2" value="#CPLAddr2#">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="CT" value="#CPLCity#">
                            <cfquery name="cfqGetNorwichState" datasource="#application.dsn#">
                                select strabbrev from tblstates where (strShortName='#lcl_state#' or strname='#lcl_state#')
                            </cfquery>
                            <cfif cfqGetNorwichState.recordcount gt 0>
                                <cfset NorwichState=cfqGetNorwichState.strabbrev>
                            <cfelse>
                                <cfset NorwichState="NA">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="SP" value="#NorwichState#">
                            <cfhttpparam type="FORMFIELD" name="PC" value="#CPLZip#">
                            <cfhttpparam type="FORMFIELD" name="CN" value="#lcl_cntry#">
                            
                            <cfset tempphone=replace(CPLEPhone,"(","","all")>
                            <cfset tempphone=replace(tempphone,")","","all")>
                            <cfset tempphone=replace(tempphone,".","","all")>
                            <cfset tempphone=replace(tempphone,"-","","all")>
                            <cfloop condition="#tempphone# contains ' '">
                                <cfset tempphone=replace(tempphone," ","","all")>
                            </cfloop>
                            <cfset hphone=right(tempphone,10)>
                            <cfhttpparam type="FORMFIELD" name="HP" value="#hphone#">
                            
                            <cfset tempphone=replace(CPLDPhone,"(","","all")>
                            <cfset tempphone=replace(tempphone,")","","all")>
                            <cfset tempphone=replace(tempphone,".","","all")>
                            <cfset tempphone=replace(tempphone,"-","","all")>
                            <cfloop condition="#tempphone# contains ' '">
                                <cfset tempphone=replace(tempphone," ","","all")>
                            </cfloop>
                            <cfset wphone=right(tempphone,10)>
                            <cfhttpparam type="FORMFIELD" name="WP" value="#wphone#">
                            
                            <cfif strHighestDegree eq "BS/BA">
                                <cfset Degree="Bachelors">
                            <cfelse>
                                <cfset Degree="#strHighestDegree#">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="A1" value="#Degree#">
                            
                            <!--- Custom Form Questions --->
                            <!--- Must be hardcoded to the field name assigned in CPL admin --->
                            <cfif isdefined('form.ProgramOfInterest')>
                                <!--- Look up display text from Custom option ID --->
                                <cfquery datasource="#application.dsn#" name="getNorwichQ1Answer">
                                    select strDisplaytext from tblCPLQuestionOptions where intOptionID=#form.ProgramOfInterest#
                                </cfquery>
                                <cfif getNorwichQ1Answer.recordcount gt 0>
                                    <cfset NorwichProgramDesc=getNorwichQ1Answer.strDisplaytext>
                                <cfelse>
                                    <cfset NorwichProgramDesc="">
                                </cfif>
                            <cfelse>
                                <cfset NorwichProgramDesc="">
                            </cfif>	
                            <cfset NorwichProgramValue="">
                            <!--- /Custom Form Question --->
                            <cfswitch expression="#trim(NorwichProgramDesc)#">
                                <cfcase value="MBA">
                                    <cfset NorwichProgramValue="NUMBA">
                                </cfcase>
                                <cfcase value="Masters in Diplomacy">
                                    <cfset NorwichProgramValue="NUMDY">
                                </cfcase>
                                <cfcase value="Masters in Education">
                                    <cfset NorwichProgramValue="NUMED">
                                </cfcase>
                                <cfcase value="Masters in Justice Administration">
                                    <cfset NorwichProgramValue="NUMJA">
                                </cfcase>
                                <cfcase value="Masters in Military History">
                                    <cfset NorwichProgramValue="NUMMH">
                                </cfcase>
                                <cfcase value="Masters in Public Administration">
                                    <cfset NorwichProgramValue="NUMPA">
                                </cfcase>
                                <cfcase value="Information Assurance">
                                    <cfset NorwichProgramValue="NUMSIA">
                                </cfcase>
                                <cfcase value="Masters in Organizational Leadership">
                                    <cfset NorwichProgramValue="NUMSOL">
                                </cfcase>
                                <cfdefaultcase>
                                    <cfset NorwichProgramValue="[Not Entered]">
                                </cfdefaultcase>
                            </cfswitch>
                            <cfhttpparam type="FORMFIELD" name="A2" value="#NorwichProgramValue#">
                        </cfhttp>
                        <!--- 
                        <cfoutput>#cfhttp.filecontent#</cfoutput>
                        <cfabort>  --->
                    <cfelse>
						<!--- Send rejection email
						<cfinclude template="/email/CPL/cplOptinRejEmail75.cfm">   --->                    
                    </cfif>
            	</cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 75-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->  	
                
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 1------------------------------------------------------------------------------------------------->
                <!--------------------------------------------------------------------------------------------------------------------------> 	 
				<cfif (MemberID eq "1")>
                    <cfhttp url="http://leads.franchoice.com/sixfigureJobs.html" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                        <cfif application.machine NEQ "LIVE">
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="test">
                        <cfelse>
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="production">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="FirstName" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="LastName" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="Address1" value="#CPLAddr#">
                        <cfif len(CPLAddr2)>
                            <cfhttpparam type="FORMFIELD" name="address2" value="#CPLAddr2#">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="city" value="#CPLCity#">
                        
                        <cfquery name="cfqGetTBState" datasource="#application.dsn#">
                            select strabbrev from tblstates 
                            where (strShortName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcl_state#" /> 
                                    or strname=<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcl_state#" />)
                        </cfquery>
                        <cfif cfqGetTBState.recordcount gt 0>
                            <cfset TBState=cfqGetTBState.strabbrev>
                        <cfelse>
                            <cfset TBState="NA">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="State" value="#TBState#">
                        <cfhttpparam type="FORMFIELD" name="zip" value="#CPLZip#">
                        <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                        <cfif lcl_cntry eq "US">
                            <cfset TBCountry="USA">
                        <cfelse>
                            <cfset TBCountry="0">
                        </cfif>
                        
                        <cfhttpparam type="FORMFIELD" name="Country" value="#TBCountry#">
                        <cfset tempphone=replace(CPLEPhone,"(","","all")>
                        <cfset tempphone=replace(tempphone,")","","all")>
                        <cfset tempphone=replace(tempphone,".","","all")>
                        <cfset tempphone=replace(tempphone,"-","","all")>
                        <cfloop condition="#tempphone# contains ' '">
                            <cfset tempphone=replace(tempphone," ","","all")>
                        </cfloop>
                        <cfset phone=right(tempphone,10)>
                        <cfhttpparam type="FORMFIELD" name="DayPhone" value="#phone#">
                        <cfhttpparam type="FORMFIELD" name="EveningPhone" value="#phone#">
                        <cfhttpparam type="FORMFIELD" name="Email" value="#CPLEmail#">	
                        <cfhttpparam type="FORMFIELD" name="HeardFrom" value="6FigureJobs"> 	                
                        <cfhttpparam type="FORMFIELD" name="PartnerID" value="50" />
                        <cfhttpparam type="FORMFIELD" name="IP" value="#CGI.REMOTE_ADDR#"> 
                    </cfhttp>
                </cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 1--------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->	 
                     
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 68------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->      
				<cfif (MemberID eq "68")>			
                    <!--- ****** remove cfabort at end of post ***** --->
                    <!--- http://www.letsfranchise.net/scripts/processleads.php --->
                    <cfhttp   url="http://www.letsfranchise.net/scripts/processleads.php" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                        <cfif application.machine NEQ "LIVE">
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="test">
                        <cfelse>
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="production">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="code" value="6FJ-">
                        <cfhttpparam type="FORMFIELD" name="offer" value="TAXBAC-018"><!--- Our code or theirs? --->
                       <cfif application.machine NEQ "LIVE">
                            <cfhttpparam type="FORMFIELD" name="copytoemail" value="inboundtests@ven.com">
                        </cfif>				
                        <cfhttpparam type="FORMFIELD" name="salute" value="">
                        <cfhttpparam type="FORMFIELD" name="fname" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="lname" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="address1" value="#CPLAddr#">
                        <cfif len(CPLAddr2)>
                            <cfhttpparam type="FORMFIELD" name="address2" value="#CPLAddr2#">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="city" value="#CPLCity#">
                        
                        <cfquery name="cfqGetTBState" datasource="#application.dsn#">
                            select strabbrev from tblstates 
                            where (strShortName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcl_state#" /> 
                                    or strname=<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcl_state#" />)
                        </cfquery>
                        <cfif cfqGetTBState.recordcount gt 0>
                            <cfset TBState=cfqGetTBState.strabbrev>
                        <cfelse>
                            <cfset TBState="NA">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="state" value="#TBState#">
                        <cfhttpparam type="FORMFIELD" name="zip" value="#CPLZip#">
                        <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                        <cfif lcl_cntry eq "US">
                            <cfset TBCountry="USA">
                        <cfelse>
                            <cfset TBCountry="0">
                        </cfif>
                        
                        <cfset tempphone=replace(CPLEPhone,"(","","all")>
                        <cfset tempphone=replace(tempphone,")","","all")>
                        <cfset tempphone=replace(tempphone,".","","all")>
                        <cfset tempphone=replace(tempphone,"-","","all")>
                        <cfloop condition="#tempphone# contains ' '">
                            <cfset tempphone=replace(tempphone," ","","all")>
                        </cfloop>
                        <cfset phone=right(tempphone,10)>
                        <cfhttpparam type="FORMFIELD" name="phone" value="#phone#">
                        <cfhttpparam type="FORMFIELD" name="email" value="#CPLEmail#">			
                        <cfhttpparam type="FORMFIELD" name="optin" value="1">		
                        <cfhttpparam type="FORMFIELD" name="quest1" value="letsfranchise">	 
                    </cfhttp>
                    <!--- <cfoutput>#cfhttp.filecontent#</cfoutput>
                    <cfabort> --->
                </cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 68-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->		
                
                
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 120------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->
				<cfif (MemberID eq "120")>
                    <cfhttp url="https://www.salesforce.com/servlet/servlet.WebToLead?encoding=UTF-8" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                        <cfhttpparam type="FORMFIELD" name="oid" value="00D60000000KNdp">
                       	<cfhttpparam type="FORMFIELD" name="retURL" value="http://www.livhomefranchise.com">
                        <cfhttpparam type="FORMFIELD" name="first_name" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="last_name" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="email" value="#CPLEmail#">		
                        
                        <cfset tempphone=replace(CPLEPhone,"(","","all")>
                        <cfset tempphone=replace(tempphone,")","","all")>
                        <cfset tempphone=replace(tempphone,".","","all")>
                        <cfset tempphone=replace(tempphone,"-","","all")>
                        <cfloop condition="#tempphone# contains ' '">
                            <cfset tempphone=replace(tempphone," ","","all")>
                        </cfloop>
                        <cfset phone=right(tempphone,10)>
                        <cfhttpparam type="FORMFIELD" name="phone" value="#phone#">
                        <cfhttpparam type="FORMFIELD" name="street" value="#CPLAddr#">
                        
                        <cfhttpparam type="FORMFIELD" name="city" value="#CPLCity#">
                        
                        <cfquery name="cfqGetTBState" datasource="#application.dsn#">
                            select strabbrev from tblstates where (strShortName='#lcl_state#' or strname='#lcl_state#')
                        </cfquery>
                        <cfif cfqGetTBState.recordcount gt 0>
                            <cfset TBState=cfqGetTBState.strabbrev>
                        <cfelse>
                            <cfset TBState="NA">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="state" value="#TBState#">
                        <cfhttpparam type="FORMFIELD" name="zip" value="#CPLZip#">
                    </cfhttp>
                </cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 120-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->	
                
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 71------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->      
	    		<!--- Padgett --->
				<cfif (MemberID eq "71")>
                    <!--- http://www.letsfranchise.net/scripts/processleads.php --->
                    <cfhttp path="#cplDir#" file="71_#cplTime#.txt" url="http://www.letsfranchise.net/scripts/processleads.php" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                        <cfif application.machine NEQ "LIVE">
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="test">
                            
                            <cfhttpparam type="FORMFIELD" name="copytoemail" value="inboundtests@ven.com">
                        <cfelse>
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="production">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="code" value="6FJ-">
                        <cfhttpparam type="FORMFIELD" name="offer" value="SMALLB-001">
                        <cfhttpparam type="FORMFIELD" name="salute" value="Mr.">
                        <cfhttpparam type="FORMFIELD" name="fname" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="lname" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="address1" value="#CPLAddr#">
                        <cfif len(CPLAddr2)>
                            <cfhttpparam type="FORMFIELD" name="address2" value="#CPLAddr2#">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="city" value="#CPLCity#">
                        <cfquery name="cfqGetSBState" datasource="#application.dsn#">
                            select strabbrev from tblstates where (strShortName='#lcl_state#' or strname='#lcl_state#')
                        </cfquery>
                        <cfif cfqGetSBState.recordcount gt 0>
                            <cfset SBState=cfqGetSBState.strabbrev>
                        <cfelse>
                            <cfset SBState="NA">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="state" value="#SBState#">
                        <cfhttpparam type="FORMFIELD" name="zip" value="#CPLZip#">
                        <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                        <cfif lcl_cntry eq "US">
                            <cfset SBCountry="USA">
                        <cfelse>
                            <cfset SBCountry="0">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="country" value="#SBCountry#">
                        <cfset tempphone=replace(CPLEPhone,"(","","all")>
                        <cfset tempphone=replace(tempphone,")","","all")>
                        <cfset tempphone=replace(tempphone,".","","all")>
                        <cfset tempphone=replace(tempphone,"-","","all")>
                        <cfloop condition="#tempphone# contains ' '">
                            <cfset tempphone=replace(tempphone," ","","all")>
                        </cfloop>
                        <cfset phone=right(tempphone,10)>
                        <cfhttpparam type="FORMFIELD" name="phone" value="#phone#">
                        <cfhttpparam type="FORMFIELD" name="email" value="#CPLEmail#">			
                        <cfhttpparam type="FORMFIELD" name="optin" value="1">	
                        <cfhttpparam type="FORMFIELD" name="ip" value="#cgi.REMOTE_ADDR#">	
                            <!--- Parse Quest Fields --->			
                    <cfloop list="#form.fieldnames#" index="fieldList">
                        <!--- Quest Element --->
                        <cfif fieldList contains "quest"  and len(fieldList) lte 10 and listlen(evaluate("form.#fieldList#"))>
                            <cfset tempQVal = trim(getCPLQuestionTextConfirmPop(evaluate('form.#fieldList#')))>
                            <cfhttpparam type="FORMFIELD" name="#lcase(fieldList)#" value="#tempQVal#">	
                        </cfif>
                    </cfloop>
                    
                    <cfhttpparam type="FORMFIELD" name="quest4" value="letsfranchise"></cfhttp>
                </cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 71-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->
                
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 77------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->      
				<cfif MemberID eq 77>
                    <cfhttp   url="http://www.letsfranchise.net/scripts/processleads.php" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                        <!--- Testing --->
                        <cfif application.machine NEQ "LIVE">
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="test">
                            <cfhttpparam type="FORMFIELD" name="copytoemail" value="inboundtests@ven.com">
                        <cfelse>
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="production">
                        </cfif>
                        
                        <cfhttpparam type="FORMFIELD" name="code" value="6FJ-CR">
                        <cfhttpparam type="FORMFIELD" name="offer" value="LIBTAX-016">	
                        <cfhttpparam type="FORMFIELD" name="salute" value=""> <!-- here -->
                        <cfhttpparam type="FORMFIELD" name="fname" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="lname" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="address1" value="#CPLAddr#">
                        <cfif len(CPLAddr2)>
                            <cfhttpparam type="FORMFIELD" name="address2" value="#CPLAddr2#">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="city" value="#CPLCity#">
                        <cfquery name="cfqGetSBState" datasource="#application.dsn#">
                            select strabbrev from tblstates where (strShortName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcl_state#" /> or strname=<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcl_state#" />)
                        </cfquery>
                        
                        
                        <cfif cfqGetSBState.recordcount gt 0>
                            <cfset SBState=cfqGetSBState.strabbrev>
                        <cfelse>
                            <cfset SBState="NA">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="state" value="#SBState#">
                        <cfhttpparam type="FORMFIELD" name="zip" value="#CPLZip#">
                        <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                        <cfif lcl_cntry eq "US">
                            <cfset SBCountry="USA">
                        <cfelse>
                            <cfset SBCountry="0">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="country" value="#SBCountry#">
                        <cfset tempphone=replace(CPLEPhone,"(","","all")>
                        <cfset tempphone=replace(tempphone,")","","all")>
                        <cfset tempphone=replace(tempphone,".","","all")>
                        <cfset tempphone=replace(tempphone,"-","","all")>
                        <cfloop condition="#tempphone# contains ' '">
                            <cfset tempphone=replace(tempphone," ","","all")>
                        </cfloop>
                        <cfset phone=right(tempphone,10)>
                        <cfhttpparam type="FORMFIELD" name="phone" value="#phone#">
                        <cfhttpparam type="FORMFIELD" name="email" value="#CPLEmail#">			
                        <cfhttpparam type="FORMFIELD" name="optin" value="1">       
                        
                        <!--- Parse Quest Fields 			
                        <cfloop list="#form.fieldnames#" index="fieldList">
                            <!--- Quest Element --->
                            <cfif fieldList contains "quest"  and len(fieldList) lte 10 and listlen(evaluate("form.#fieldList#"))>
                                <cfhttpparam type="FORMFIELD" name="#fieldList#" value="#(evaluate('form.#fieldList#'))#">	
                            </cfif>
                        </cfloop>
                       ---> 	
                        <!--- Hard Code Fields Here To Resolve Issues--->            
                        <cfhttpparam type="FORMFIELD" name="quest1" value="$30,000 - $49,999">
                        <cfhttpparam type="FORMFIELD" name="quest2" value="morning">			
                        <cfhttpparam type="FORMFIELD" name="quest3" value="0-6 months">				
                    </cfhttp>
                </cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 77-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->
                        
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 72------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->		
				<!--- CertaPro --->
                <cfif (MemberID eq "72")>
                    <!--- http://www.letsfranchise.net/scripts/processleads.php --->
                    
                    <cfhttp   url="http://www.letsfranchise.net/scripts/processleads.php" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                        <cfif application.machine NEQ "LIVE">
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="test">
                        <cfelse>
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="production">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="code" value="6FJ-">
                        <cfhttpparam type="FORMFIELD" name="offer" value="AVIATT-001">
                        <cfif application.machine NEQ "LIVE">
                            <cfhttpparam type="FORMFIELD" name="copytoemail" value="inboundtests@ven.com">
                        </cfif>		
                        <cfhttpparam type="FORMFIELD" name="salute" value="">
                        <cfhttpparam type="FORMFIELD" name="fname" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="lname" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="address1" value="#CPLAddr#">
                        <cfif len(CPLAddr2)>
                            <cfhttpparam type="FORMFIELD" name="address2" value="#CPLAddr2#">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="city" value="#CPLCity#">
                        <cfquery name="cfqGetCertaProState" datasource="#application.dsn#">
                            select strabbrev from tblstates where (strShortName='#lcl_state#' or strname='#lcl_state#')
                        </cfquery>
                        <cfif cfqGetCertaProState.recordcount gt 0>
                            <cfset CertaProState=cfqGetCertaProState.strabbrev>
                        <cfelse>
                            <cfset CertaProState="NA">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="state" value="#CertaProState#">
                        <cfhttpparam type="FORMFIELD" name="zip" value="#CPLZip#">
                        <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                        <cfif lcl_cntry eq "US">
                            <cfset CertaProCountry="USA">
                        <cfelse>
                            <cfset CertaProCountry="0">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="country" value="#CertaProCountry#">
                        <cfset tempphone=replace(CPLEPhone,"(","","all")>
                        <cfset tempphone=replace(tempphone,")","","all")>
                        <cfset tempphone=replace(tempphone,".","","all")>
                        <cfset tempphone=replace(tempphone,"-","","all")>
                        <cfloop condition="#tempphone# contains ' '">
                            <cfset tempphone=replace(tempphone," ","","all")>
                        </cfloop>
                        <cfset phone=right(tempphone,10)>
                        <cfhttpparam type="FORMFIELD" name="phone" value="#phone#">
                        <cfhttpparam type="FORMFIELD" name="email" value="#CPLEmail#">			
                        <cfhttpparam type="FORMFIELD" name="optin" value="1">
                        <!--- Custom Form Question --->
                        <!--- Must be hardcoded to the field name assigned in CPL admin --->
                        <cfif isdefined('form.LiquidCapital')>
                            <!--- Look up display text from Custom option ID --->
                            <cfquery datasource="#application.dsn#" name="getQ1Answer">
                                select strDisplaytext from tblCPLQuestionOptions where intOptionID=#form.LiquidCapital#
                            </cfquery>
                            <cfif getQ1Answer.recordcount gt 0>
                                <cfset CertaProQuest1=getQ1Answer.strDisplaytext>
                            <cfelse>
                                <cfset CertaProQuest1="">
                            </cfif>
                        <cfelse>
                            <cfset CertaProQuest1="">
                        </cfif>	
                        <!--- /Custom Form Question --->
                        <cfhttpparam type="FORMFIELD" name="quest1" value="#CertaProQuest1#"> 
                    </cfhttp>
                </cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 72-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->
                        
                    
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 73------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->	    	
				<!--- Countours --->
                <cfif (MemberID eq "73")>
                    <!--- http://www.letsfranchise.net/scripts/processleads.php --->
                    <cfhttp   url="http://www.letsfranchise.net/scripts/processleads.php" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                        
                        <cfhttpparam type="FORMFIELD" name="code" value="6FJ-">
                        <cfhttpparam type="FORMFIELD" name="offer" value="CONTOU-003">
                        
                        <cfif application.machine NEQ "LIVE">
                            <cfhttpparam type="FORMFIELD" name="copytoemail" value="inboundtests@ven.com">
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="test">
                        <cfelse>
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="production">
                        </cfif>		
                        <cfhttpparam type="FORMFIELD" name="salute" value="">
                        <cfhttpparam type="FORMFIELD" name="fname" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="lname" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="address1" value="#CPLAddr#">
                        <cfif len(CPLAddr2)>
                            <cfhttpparam type="FORMFIELD" name="address2" value="#CPLAddr2#">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="city" value="#CPLCity#">
                        <cfquery name="cfqGetCoutoursState" datasource="#application.dsn#">
                            select strabbrev from tblstates where (strShortName='#lcl_state#' or strname='#lcl_state#')
                        </cfquery>
                        <cfif cfqGetCoutoursState.recordcount gt 0>
                            <cfset CoutoursState=cfqGetCoutoursState.strabbrev>
                        <cfelse>
                            <cfset CoutoursState="NA">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="state" value="#CoutoursState#">
                        <cfhttpparam type="FORMFIELD" name="zip" value="#CPLZip#">
                        <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                        <cfif lcl_cntry eq "US">
                            <cfset CoutoursCountry="USA">
                        <cfelse>
                            <cfset CoutoursCountry="0">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="country" value="#CoutoursCountry#">
                        <cfset tempphone=replace(CPLEPhone,"(","","all")>
                        <cfset tempphone=replace(tempphone,")","","all")>
                        <cfset tempphone=replace(tempphone,".","","all")>
                        <cfset tempphone=replace(tempphone,"-","","all")>
                        <cfloop condition="#tempphone# contains ' '">
                            <cfset tempphone=replace(tempphone," ","","all")>
                        </cfloop>
                        <cfset phone=right(tempphone,10)>
                        <cfhttpparam type="FORMFIELD" name="phone" value="#phone#">
                        <cfhttpparam type="FORMFIELD" name="email" value="#CPLEmail#">			
                        <cfhttpparam type="FORMFIELD" name="optin" value="1">
                        <!--- Custom Form Question --->
                        <!--- Must be hardcoded to the field name assigned in CPL admin --->
                        <cfif isdefined('form.LiquidCapital')>
                            <!--- Look up display text from Custom option ID --->
                            <cfquery datasource="#application.dsn#" name="getQ1Answer">
                                select strDisplaytext from tblCPLQuestionOptions where intOptionID=#form.LiquidCapital#
                            </cfquery>
                            <cfif getQ1Answer.recordcount gt 0>
                                <cfset CoutoursQuest1=getQ1Answer.strDisplaytext>
                            <cfelse>
                                <cfset CoutoursQuest1="">
                            </cfif>
                        <cfelse>
                            <cfset CoutoursQuest1="">
                        </cfif>	
                        <!--- /Custom Form Question --->
                        <cfhttpparam type="FORMFIELD" name="quest1" value="#CoutoursQuest1#"> 
                    </cfhttp>
                </cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 73-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->
                        
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 70------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->	    		
				<!--- St Leo --->	
                <cfif MemberID eq "70">
                    <cfparam name="StLeoValidationError" default="">
                    <cfset AcceptableLeads="BS/BA,Masters,Doctorate">
                    <cfset blnPassStLeoValidation="0">
                    <cfif ListContains(AcceptableLeads,strHighestDegree,",") gt 0>
                        <cfset blnPassStLeoValidation="1">
                    <cfelse>
                        <cfset blnDelete=1>
                        <cfset blnSendRTEmail=0>
                        <cfset StLeoValidationError="Education">
                        <cfif int_client_email eq "1">
                            <cfset int_client_email="0">
                        </cfif>
                    </cfif>
                    <cfif blnPassStLeoValidation eq "1">
                       <cfset temp=replaceList(CPLEPhone,"(,),-,.,x,X,+, ","")>
                       <cfif (isNumeric(temp) AND (len(temp) gt 6))>
                        <cfset blnPassHphone=1>
                       </cfif>
                       <cfset tempphone=right(temp,10)>
                       <cfset tempphonearea=left(tempphone,3)>
                       <cfset tempphonemain=right(tempphone,7)>
                       <cfset InvalidAreaCodeList="000,111,123,222,333,444,555,666,777,999,911">
                       <cfset InvalidPhoneNumbers="4567890,1234567">
                       <cfloop from="1" to="#listlen(InvalidAreaCodeList)#" index="b">
                            <cfif tempphonearea eq listGetAt(InvalidAreaCodeList,b)>
                                <cfset blnPassStLeoValidation=0>
                                <cfset StLeoValidationError="Phone">
                                <cfset blnDelete=1>
                                <cfset blnSendRTEmail=0>
                                <cfbreak>
                            </cfif>
                       </cfloop>
                       <cfif blnPassHphone eq "1">
                            <cfloop from="1" to="#listlen(InvalidPhoneNumbers)#" index="p">
                                <cfif tempphonemain eq listGetAt(InvalidPhoneNumbers,p)>
                                    <cfset blnPassStLeoValidation=0>
                                    <cfset StLeoValidationError="Phone">
                                    <cfset blnDelete=1>
                                    <cfset blnSendRTEmail=0>
                                    <cfbreak>
                                </cfif>
                           </cfloop>
                       </cfif>
                       <cfif blnPassHphone eq "1">
                            <cfloop from="0" to="9" index="n">
                                <cfif trim(replace(tempphonemain,n,"","all")) eq "">
                                    <cfset blnPassStLeoValidation=0>
                                    <cfset StLeoValidationError="Phone">
                                    <cfset blnDelete=1>
                                    <cfset blnSendRTEmail=0>
                                    <cfbreak>
                                </cfif>
                           </cfloop>
                       </cfif>
                    </cfif>

                    <cfset stleoformposturl="http://www.ithinkbig.com/schools/stleo/form/handleform.php">
					
                    <cfif blnPassStLeoValidation eq "1">
                        <cfhttp   url="#stleoformposturl#" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                            <cfhttpparam type="FORMFIELD" name="MHID" value="1011">
                            
                            <cfif application.machine NEQ "LIVE">
                                <cfhttpparam type="FORMFIELD" name="mode" value="1"><!--- Test mode, but change url to test url anyway above --->
                            <cfelse>
                                <cfhttpparam type="FORMFIELD" name="mode" value="0">
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="date" value="#DateFormat(now(),'mm/dd/yyyy')#">
                            <cfhttpparam type="FORMFIELD" name="time" value="#timeFormat(now(),'HH:mm')#">
                            
                            
                            <cfhttpparam type="FORMFIELD" name="firstname" value="#CPLFname#">
                            <cfhttpparam type="FORMFIELD" name="lastname" value="#CPLLname#">
                            
                            
                            <cfhttpparam type="FORMFIELD" name="address" value="#CPLAddr#">
                            <cfhttpparam type="FORMFIELD" name="city" value="#CPLCity#">
                            
                            <!--- Need to map state abbrev below --->
                            <cfparam name="StLeoState" default="0">
                            <cfif lcl_state contains "California">
                                <cfset StLeoState="5">
                            <cfelse>
                                <cfquery name="cfqMapStates" datasource="#application.dsn#">
                                    select strname from tblstates where strCountry ='US' and intoldid not in (3051,3050)
                                    order by strname
                                </cfquery>
                                <cfset arrStateStLeo=ArrayNew(2)>
                                <cfloop from="1" to="#cfqMapStates.RecordCount#" index="p">
                                    <cfset arrStateStLeo[p][1] = p>
                                    <cfset arrStateStLeo[p][2] = cfqMapStates.strName[p]>
                                </cfloop>
                                <cfloop from="1" to="#Arraylen(arrStateStLeo)#" index="sls">
                                    <cfif #arrStateStLeo[sls][2]# eq  lcl_state>
                                        <cfset StLeoState=arrStateStLeo[sls][1]>
                                    </cfif>
                                </cfloop>
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="state" value="#StLeoState#">
                            
                            <cfhttpparam type="FORMFIELD" name="zip" value="#CPLZip#">
                            
                            <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                            <cfif lcl_cntry eq "US">
                                <cfset PostCountry="1">
                            <cfelse>
                                <cfset PostCountry="0"><!--- lcl_cntry --->
                            </cfif>
                            <cfhttpparam type="FORMFIELD" name="country" value="#PostCountry#">
                            
                            <cfset tempphone=replaceList(CPLEPhone,"(,),-,.,x,X,+, ","")>
                            <cfset tempphone=right(tempphone,10)>
                            <cfset phonearea=left(tempphone,3)>
                            <cfset phonecity=mid(tempphone,4,3)>
                            <cfset phone=right(tempphone,4)>
                            <cfhttpparam type="FORMFIELD" name="phonearea" value="#phonearea#">
                            <cfhttpparam type="FORMFIELD" name="phonecity" value="#phonecity#">
                            <cfhttpparam type="FORMFIELD" name="phone" value="#phone#">
                            
                            <cfhttpparam type="FORMFIELD" name="email" value="#CPLEmail#">
                            
                            <cfset edlevel="0">
                            <cfswitch expression="#strHighestDegree#">
                                <cfcase value="BS/BA">
                                    <cfset edlevel="6">
                                </cfcase>
                                <cfcase value="Masters">
                                    <cfset edlevel="7">
                                </cfcase>
                                <cfcase value="Doctorate">
                                    <cfset edlevel="8">
                                </cfcase>
                                <cfdefaultcase>
                                    <cfset edlevel="10">
                                </cfdefaultcase>
                            </cfswitch>
                            <cfhttpparam type="FORMFIELD" name="educationlevel" value="#edlevel#">
                            <!--- Default Values set by St. Leo --->
                            <cfhttpparam type="FORMFIELD" name="contacttime" value="2">
                            <cfhttpparam type="FORMFIELD" name="program" value="524">
                            <cfhttpparam type="FORMFIELD" name="workexperience" value="2">
                            <cfhttpparam type="FORMFIELD" name="military" value="1">
                            <cfhttpparam type="FORMFIELD" name="expectedstart" value="2">
                        </cfhttp>
                    <cfelse>
						<cfif StLeoValidationError eq "Education">
                            <!--- Send rejection email
                            <cfinclude template="/email/CPL/cplOptinRejEmailEdu70.cfm"> --->
                        <cfelseif StLeoValidationError eq "Phone">
                            <!--- Send rejection email 
                            <cfinclude template="/email/CPL/cplOptinRejEmailPhone70.cfm">--->
                        </cfif>
                    </cfif>
				</cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 70-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->
                    
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 84------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->	    		
	
				<!--- Real Time Posting For Franchise For Executives --->	
				<cfif MemberID eq "84">
                    <cfquery name="cfqGetNUState" datasource="#application.dsn#">
                    select strabbrev from tblstates where (strShortName='#lcl_state#' or strname='#lcl_state#')
                    </cfquery>
					
                    <!--- <cfhttp   url="http://leads.mercuryroadassociates.com/genericPostlead.php" method="POST" timeout="10" redirect="No" resolveurl="Yes"> --->
                    <cfhttp url="http://leads.theleadex.com/genericPostlead.php" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                        <cfhttpparam type="FORMFIELD" name="TYPE" value="10">
                        
                        <!--- Dev Server --->
                        <cfif application.machine NEQ "LIVE">
                        <cfhttpparam type="FORMFIELD" name="Test_Lead" value="1">
                        </cfif>
                        
                        
                        <cfhttpparam type="FORMFIELD" name="IP_Address" value="#cgi.REMOTE_ADDR#">
                        <cfhttpparam type="FORMFIELD" name="SRC" value="Exec Lead Advice 1">
                        <cfhttpparam type="FORMFIELD" name="Landing_Page" value="http://www.franchisingforexecutives.com">
                        <!--- Contact Information --->
                        <cfhttpparam type="FORMFIELD" name="First_Name" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="Last_Name" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="Email" value="#CPLEmail#">
                        <cfhttpparam type="FORMFIELD" name="Address_1" value="#CPLAddr#">
                        <cfif len(CPLAddr2)>
                        <cfhttpparam type="FORMFIELD" name="Address_2" value="#CPLAddr2#">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="City" value="#CPLCity#">
                        
                        <cfif cfqGetNUState.recordcount gt 0>
                        <cfset NUState=cfqGetNUState.strabbrev>
                        <cfelse>
                        <cfset NUState="NA">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="State" value="#NUState#">
                        <cfhttpparam type="FORMFIELD" name="Zip" value="#CPLZip#">
                        
                        
                        
                        <cfset tempphone=replace(CPLEPhone,"(","","all")>
                        <cfset tempphone=replace(tempphone,")","","all")>
                        <cfset tempphone=replace(tempphone,".","","all")>
                        <cfset tempphone=replace(tempphone,"-","","all")>
                        <cfloop condition="#tempphone# contains ' '">
                        <cfset tempphone=replace(tempphone," ","","all")>
                        </cfloop>
                        <cfset hphone=right(tempphone,10)>
                        <cfhttpparam type="FORMFIELD" name="Day_Phone" value="#hphone#">
                    </cfhttp>
                </cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 84-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->	

                <cfstoredproc procedure="sp_cpl_insert_lead" datasource="#application.dsn#" returncode="Yes">
                    <cfprocparam type="IN" dbvarname="@intMemberID" value="#val(MemberID)#" cfsqltype="CF_SQL_INTEGER">
                    <cfprocparam type="IN" dbvarname="@intResID" value="#val(lcl_intResID)#" cfsqltype="CF_SQL_INTEGER">
                    <cfprocparam type="IN" dbvarname="@intTargetID" value="#val(intTargetID)#" cfsqltype="CF_SQL_INTEGER">	 
                    <cfprocparam type="IN" dbvarname="@strEmail" value="#CPLEmail#" cfsqltype="CF_SQL_VARCHAR">
                    <cfprocparam type="IN" dbvarname="@strFname" value="#CPLFname#" cfsqltype="CF_SQL_VARCHAR">
                    <cfprocparam type="IN" dbvarname="@strLname" value="#CPLLname#" cfsqltype="CF_SQL_VARCHAR">
                    <cfprocparam type="IN" dbvarname="@strAddress" value="#CPLAddr#" cfsqltype="CF_SQL_VARCHAR">
                    <cfprocparam type="IN" dbvarname="@strAddress2" value="#CPLAddr2#" cfsqltype="CF_SQL_VARCHAR" null=#iif(CPLAddr2 is "", 1,0)#>
                    <cfprocparam type="IN" dbvarname="@strCity" value="#CPLCity#" cfsqltype="CF_SQL_VARCHAR">	 
                    <cfprocparam type="IN" dbvarname="@strState" value="#lcl_state#" cfsqltype="CF_SQL_VARCHAR">
                    <cfprocparam type="IN" dbvarname="@strCntry" value="#lcl_cntry#" cfsqltype="CF_SQL_VARCHAR">
                    <cfprocparam type="IN" dbvarname="@strZip" value="#CPLZip#" cfsqltype="CF_SQL_VARCHAR">
                    <cfprocparam type="IN" dbvarname="@strDPhone" value="#CPLDPhone#" cfsqltype="CF_SQL_VARCHAR">
                    <cfprocparam type="IN" dbvarname="@strEPhone" value="#CPLEPhone#" cfsqltype="CF_SQL_VARCHAR">
                    <cfprocparam type="IN" dbvarname="@blnInternational" value="#val(blnInternationalLead)#" cfsqltype="CF_SQL_INTEGER">
                    <cfprocparam type="IN" dbvarname="@blnDelete" value="#val(blnDelete)#" cfsqltype="CF_SQL_INTEGER">
                    <cfif strEducationLevel neq "">
                    <cfprocparam type="IN" dbvarname="@strEducationLevel" value="#strEducationLevel#" cfsqltype="CF_SQL_VARCHAR">
                    <cfelse>
                    <cfprocparam type="IN" dbvarname="@strEducationLevel" NULL="1" cfsqltype="CF_SQL_VARCHAR">
                    </cfif>
                    <!--- <cfprocparam type="IN" dbvarname="@strEducationLevel" value="#CPLCity#" cfsqltype="CF_SQL_VARCHAR" null=#iif(ListFind(cpl_AddFieldsList, 1) gt 0, 0, 1)#> --->
                    <cfif ListFind(cpl_LoggedInFieldsList, 1) gt 0>
                    <cfif strAddtComments neq "">
                    <cfprocparam type="IN" dbvarname="@strAddtComment" value="#strAddtComments#" cfsqltype="CF_SQL_VARCHAR">
                    <cfelse>
                    <cfprocparam type="IN" dbvarname="@strAddtComment" value="[answer withheld by client]" cfsqltype="CF_SQL_VARCHAR">
                    </cfif>	 
                    <cfelse>
                    <cfprocparam type="IN" dbvarname="@strAddtComment" cfsqltype="CF_SQL_VARCHAR" null="1">
                    </cfif>
                    <cfprocparam type="IN" dbvarname="@intTargetLocation" value="#TargetLocation#" cfsqltype="CF_SQL_VARCHAR">
                    
                    <cfif intLeadTrackingID neq "">
                    <cfprocparam type="IN" dbvarname="@intLeadTrackingID" value="#intLeadTrackingID#" cfsqltype="CF_SQL_INTEGER">
                    <cfelse>
                    <cfprocparam type="IN" dbvarname="@intLeadTrackingID" null="Yes" cfsqltype="CF_SQL_INTEGER">
                    </cfif>
                    <cfif intPID neq "">
                    <cfprocparam type="IN" dbvarname="@intPID" value="#intPID#" cfsqltype="CF_SQL_INTEGER">
                    <cfelse>
                    <cfprocparam type="IN" dbvarname="@intPID" null="Yes" cfsqltype="CF_SQL_INTEGER">
                    </cfif>
                    <cfprocparam type="IN" dbvarname="@fltRevShare" value="#cpl_revshare#" cfsqltype="CF_SQL_INTEGER">
                    <cfprocparam type="IN" dbvarname="@ipaddress" value="#cgi.REMOTE_ADDR#" cfsqltype="cf_sql_varchar">
                    <cfprocresult resultset="1" name="qcpl" />
                    <cfprocresult resultset="2" name="cfqGetCPLEmail" />       
                </cfstoredproc>
	  
				<!--- Custom Form Fields --->	  
                <cfquery datasource="#application.dsn#" name="getleadid">
                select intleadid from tblcplleadInfo (nolock)
                where intmemberid=#MemberID#
                and stremail='#CPLEmail#'
                and blnDelete=0
                and blnOptedOut=0
                </cfquery>

				<cfif getleadid.recordcount gt 0>
                	<cfset thisleadid=getleadid.intleadid>
                  	<cfif isdefined('form.strListAdditionalQuestions')>
                    	<cfset blnRunAddQuestInsert="0">
                        <cfquery datasource="#application.dsn#" name="getadditionalfields">
                        select intquestionid,intformfieldtype,strFormFieldName
                        from tblCplQuestions
                        where intmemberid=#MemberID#
                        and intquestionid in (#form.strListAdditionalQuestions#)
                        </cfquery>
                        <cfloop query="getadditionalfields">
                        	<cfset FormField="form." & strFormFieldName>
                            <cfif isdefined(evaluate(de(FormField))) and trim(evaluate(FormField)) neq "">
                                <cfif blnRunAddQuestInsert neq "1">
                                    <cfset blnRunAddQuestInsert="1">
                                </cfif>
                                <cfif not isdefined('additionalQuestionArr')>
                                    <cfset additionalQuestionArr=ArrayNew(2)>
                                </cfif>
                                <cfif not isdefined('ArrayRowCount')>
                                    <cfset ArrayRowCount="1">
                                </cfif>
                                <cfswitch expression="#intformfieldtype#">
                                    <!--- Hidden Fields --->
                                    <cfcase value="7">
                                        <cfset additionalQuestionArr[ArrayRowCount][1]=thisleadid>
                                        <cfset additionalQuestionArr[ArrayRowCount][2]=intquestionid>
                                        <cfset additionalQuestionArr[ArrayRowCount][3]=trim(evaluate(FormField))>
                                        <!--- <cfset additionalQuestionArr[ArrayRowCount][4]=""> --->
                                        <cfset ArrayRowCount=ArrayRowCount+1>
                                    </cfcase>
                                
                                    <!--- Text Input --->
                                    <cfcase value="1">
                                        <cfset additionalQuestionArr[ArrayRowCount][1]=thisleadid>
                                        <cfset additionalQuestionArr[ArrayRowCount][2]=intquestionid>
                                        <cfset additionalQuestionArr[ArrayRowCount][3]=trim(evaluate(FormField))>
                                        <!--- <cfset additionalQuestionArr[ArrayRowCount][4]=""> --->
                                        <cfset ArrayRowCount=ArrayRowCount+1>
                                    </cfcase>
                                    
                                    <!--- Text Area --->
                                    <cfcase value="2">
                                        <cfset additionalQuestionArr[ArrayRowCount][1]=thisleadid>
                                        <cfset additionalQuestionArr[ArrayRowCount][2]=intquestionid>
                                        <cfset additionalQuestionArr[ArrayRowCount][3]=trim(evaluate(FormField))>
                                        <!--- <cfset additionalQuestionArr[ArrayRowCount][4]=""> --->
                                        <cfset ArrayRowCount=ArrayRowCount+1>
                                    </cfcase>
                                    
                                    <!--- All others --->
                                    <cfdefaultcase>
                                        <cfquery datasource="#application.dsn#" name="getOptionValue">
                                            select strDisplayText
                                            from tblCplQuestionOptions
                                            where intquestionid=#intquestionid#
                                            <cfif listlen(trim(evaluate(FormField))) gt 1>
                                                and intoptionid in (#trim(evaluate(FormField))#)
                                            <cfelse>
                                                and intoptionid=#trim(evaluate(FormField))#
                                            </cfif>
                                            <!--- and blnSendValue=1 --->
                                        </cfquery>
                                        <cfif getOptionValue.recordcount gt 0>
                                            <cfset additionalQuestionArr[ArrayRowCount][1]=thisleadid>
                                            <cfset additionalQuestionArr[ArrayRowCount][2]=intquestionid>
                                            <cfif getOptionValue.recordcount eq "1">
                                                <cfset additionalQuestionArr[ArrayRowCount][3]=getOptionValue.strDisplayText>
                                            <cfelse>
                                                <cfset additionalQuestionArr[ArrayRowCount][3]=ValueList(getOptionValue.strDisplayText,"; ")>
                                            </cfif>
                                            <cfset ArrayRowCount=ArrayRowCount+1>
                                        </cfif>
                                    </cfdefaultcase>
                                </cfswitch>
                            </cfif> 
                        </cfloop>
                        
                        <cfif blnRunAddQuestInsert eq "1" and arraylen(additionalQuestionArr) gt 0>
                            <cfloop from="1" to="#arraylen(additionalQuestionArr)#" index="x">
                           		<cfquery datasource="#application.dsn#" name="insertAddtlQuestions">
                                insert into tblCPLQuestionAnswers (intLeadID,intQuestionID,strAnswer)
                                values (#additionalQuestionArr[x][1]#,#additionalQuestionArr[x][2]#,<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#additionalQuestionArr[x][3]#">)
                                </cfquery>
                            </cfloop>
                        </cfif>
                  	</cfif>
                </cfif>
	  
	  			<!--- CPL Lead Cap --->
				<cfif len(cpl_leadcap) and len(cpl_leadcapstartdate)>
                    <cfquery datasource="#application.dsn#" name="checkLeadCap">
                    select intLeadID from tblcplleadinfo  (nolock)
                    where intmemberid=#MemberID# 
                    and dtesubmitted>='#cpl_leadcapstartdate#' 
                    and blnDelete=0 
                    and blnOptedOut=0
                    </cfquery>

                    <cfif checkLeadCap.recordcount gte cpl_leadcap>
                        <cfquery datasource="#application.dsn#" name="DeactivateCPL">
                        update tblcplmember 
                        set blnActive=0
                        where intmemberid=#MemberID# 
                    	</cfquery>

						<cfif application.machine NEQ "LIVE">
                            <cfset LeadCapToEmail="webmaster@6figurejobs.com">
                        <cfelse>
                            <cfset LeadCapToEmail="webmaster@6figurejobs.com; alicia.sakal@workstreaminc.com">
                        </cfif>
						<!---Lead Cap Reached Email---->
						<!--- <cfinclude template="/email/CPL/cplLeadCapReached.cfm"> --->
						<cfmail to="#LeadCapToEmail#" from="#application.defaultEmail# (6FigureJobs.com)" subject="CPL Lead Cap Reached for #cpl_name#">
							The CPL Lead cap for #cpl_name# has been reached.
							=================== DETAILS ===================
							Lead Cap: #cpl_leadcap#
							Lead Cap Start Date: #DateFormat(cpl_leadcapstartdate,'mm/dd/yyyy')#
							Leads Recorded: #checkLeadCap.recordcount#
							
						</cfmail>
											</cfif>
                </cfif>
	  			<!--- /CPL Lead Cap --->

				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 85------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->					
				<!--- Notre Dame ---> 
				<cfif (MemberID eq "85")>
                    <cfhttp url="http://info.bisk.com/PostLead.asp?Source=196111zd1&FormID=14683" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                        <cfhttpparam type="FORMFIELD" name="Element2" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="Element6" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="Element8" value="#CPLEmail#">
                        <cfhttpparam type="FORMFIELD" name="Element12" value="#CPLCity#">
                        <cfhttpparam type="FORMFIELD" name="Element13" value="#lcl_state#">
                        <cfhttpparam type="FORMFIELD" name="Element14" value="#CPLZip#">
                        <cfhttpparam type="FORMFIELD" name="Element116" value="#CPLDPhone#">			
                        <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                        <cfif lcl_cntry eq "US">
                            <cfset PostCountry="USA">
                        <cfelse>
                            <cfset PostCountry="#lcl_cntry#">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="Element34" value="#PostCountry#">
                        <cfhttpparam type="FORMFIELD" name="Element90" value="#CPLAddr#">
                        <cfhttpparam type="FORMFIELD" name="Element11" value="#CPLAddr2#">
                        <cfhttpparam type="FORMFIELD" name="Element5264" value="Executive Cert Leadership & Mgt">     
                        
                        <cfif isdefined('strHighestDegree') and len(strHighestDegree)>
                            <cfset EdLevel="#strHighestDegree#">
                        <cfelse>
                            <cfset EdLevel="">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="Element129" value="#EdLevel#">                     
                    </cfhttp>
                </cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 85-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 79------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->					
				<!--- Padgett --->
                <cfif (MemberID eq "79")>
                    <!--- http://www.letsfranchise.net/scripts/processleads.php --->
                    <cfhttp   url="http://www.letsfranchise.net/scripts/processleads.php" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                    	<cfhttpparam type="FORMFIELD" name="code" value="6FJ-">
                        <cfhttpparam type="FORMFIELD" name="offer" value="SOLANA-011">
                                        
                       <cfif application.machine NEQ "LIVE">
                            <cfhttpparam type="FORMFIELD" name="copytoemail" value="inboundtests@ven.com">
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="test">
                        <cfelse>
                            <cfhttpparam type="FORMFIELD" name="leadtype" value="production">
                        </cfif>
                            
                        <cfhttpparam type="FORMFIELD" name="ip" value="#cgi.REMOTE_ADDR#">
                        <cfhttpparam type="FORMFIELD" name="salute" value="Mr.">
                        <cfhttpparam type="FORMFIELD" name="fname" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="lname" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="address1" value="#CPLAddr#">
                        <cfif len(CPLAddr2)>
                            <cfhttpparam type="FORMFIELD" name="address2" value="#CPLAddr2#">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="city" value="#CPLCity#">
                        <cfquery name="cfqGetSBState" datasource="#application.dsn#">
                            select strabbrev from tblstates where (strShortName='#lcl_state#' or strname='#lcl_state#')
                        </cfquery>
                        <cfif cfqGetSBState.recordcount gt 0>
                            <cfset SBState=cfqGetSBState.strabbrev>
                        <cfelse>
                            <cfset SBState="NA">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="state" value="#SBState#">
                        <cfhttpparam type="FORMFIELD" name="zip" value="#CPLZip#">
                        <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                        <cfif lcl_cntry eq "US">
                            <cfset SBCountry="USA">
                        <cfelse>
                            <cfset SBCountry="0">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="country" value="#SBCountry#">
                        <cfset tempphone=replace(CPLEPhone,"(","","all")>
                        <cfset tempphone=replace(tempphone,")","","all")>
                        <cfset tempphone=replace(tempphone,".","","all")>
                        <cfset tempphone=replace(tempphone,"-","","all")>
                        <cfloop condition="#tempphone# contains ' '">
                            <cfset tempphone=replace(tempphone," ","","all")>
                        </cfloop>
                        <cfset phone=right(tempphone,10)>
                        <cfhttpparam type="FORMFIELD" name="phone" value="#phone#">
                        <cfhttpparam type="FORMFIELD" name="email" value="#CPLEmail#">			
                        <cfhttpparam type="FORMFIELD" name="optin" value="1">	
                    
                    
                        <!--- Parse Quest Fields --->			
                        <cfloop list="#form.fieldnames#" index="fieldList">
                            <!--- Quest Element --->
                            <cfif fieldList contains "quest"  and len(fieldList) lte 10 and listlen(evaluate("form.#fieldList#"))>
                                <cfset tempQVal = trim(getCPLQuestionTextConfirmPop(evaluate('form.#fieldList#')))>
                                <cfhttpparam type="FORMFIELD" name="#lcase(fieldList)#" value="#tempQVal#">	
                            </cfif>
                        </cfloop>
                    </cfhttp>
                </cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 79-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->
                      
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 50------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->	  
                <cfif (MemberID eq "50")>
                    <cfhttp   url="http://info.bisk.com/PostLead.asp?Source=190983zt1&FormID=9601" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                        <cfhttpparam type="FORMFIELD" name="Element2" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="Element6" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="Element8" value="#CPLEmail#">
                        <cfhttpparam type="FORMFIELD" name="Element12" value="#CPLCity#">
                        <cfhttpparam type="FORMFIELD" name="Element13" value="#lcl_state#">
                        <cfhttpparam type="FORMFIELD" name="Element14" value="#CPLZip#">
                        <cfhttpparam type="FORMFIELD" name="Element15" value="#CPLDPhone#">
                        <cfhttpparam type="FORMFIELD" name="Element17" value="#CPLEPhone#">
                        <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                        <cfif lcl_cntry eq "US">
                            <cfset PostCountry="USA">
                        <cfelse>
                            <cfset PostCountry="#lcl_cntry#">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="Element34" value="#PostCountry#">
                        <cfif len(CPLAddr2)>
                            <cfset Addr=CPLAddr & ", " & CPLAddr2>
                        <cfelse>
                            <cfset Addr=CPLAddr>
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="Element90" value="#Addr#">
                        <cfif isdefined('strHighestDegree') and strHighestDegree neq "">
                            <cfset EdLevel="#strHighestDegree#">
                        <cfelse>
                            <cfset EdLevel="">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="Element129" value="#EdLevel#">
                    </cfhttp>
                 </cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 50-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->		 
                
                
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 91------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->		 

				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 91-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->


				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 53------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->	
				<cfif (MemberID eq "53")>
                    <cfif application.machine EQ "LOCAL" OR application.machine EQ "DEV">
                        <cfset VillanovaURL="#request.url#/jimtest3.cfm?cpltest=1">
                    <cfelse> 
                        <cfif DateCompare(DateFormat(now(),'mm/dd/yyyy'),'11/01/2006','d') gte 0>
                            <cfif DateCompare(DateFormat(now(),'mm/dd/yyyy'),'12/01/2006','d') gte 0>
                                <cfset VillanovaURL="http://info.bisk.com/PostLead.asp?Source=191373zvq1&FormID=9991">
                            <cfelse>
                                <cfset VillanovaURL="http://info.bisk.com/PostLead.asp?Source=192132zvm1&FormID=10751">
                            </cfif>
                        <cfelse>
                            <cfset VillanovaURL="http://info.bisk.com/PostLead.asp?Source=191373zvq1&FormID=9991">
                        </cfif>
                    </cfif>
                     
                    <cfhttp   url="#VillanovaURL#" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                        <cfhttpparam type="FORMFIELD" name="Element2" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="Element6" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="Element8" value="#CPLEmail#">
                        <cfhttpparam type="FORMFIELD" name="Element12" value="#CPLCity#">
                        <cfhttpparam type="FORMFIELD" name="Element13" value="#lcl_state#">
                        <cfhttpparam type="FORMFIELD" name="Element14" value="#CPLZip#">
                        <cfhttpparam type="FORMFIELD" name="Element15" value="#CPLDPhone#">
                        <cfhttpparam type="FORMFIELD" name="Element17" value="#CPLEPhone#">
                        <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                        <cfif lcl_cntry eq "US">
                            <cfset PostCountry="USA">
                        <cfelse>
                            <cfset PostCountry="#lcl_cntry#">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="Element34" value="#PostCountry#">
                        <cfif len(CPLAddr2)>
                            <cfset Addr=CPLAddr & ", " & CPLAddr2>
                        <cfelse>
                            <cfset Addr=CPLAddr>
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="Element90" value="#Addr#">
                        <cfif isdefined('strHighestDegree') and strHighestDegree neq "">
                            <cfset EdLevel="#strHighestDegree#">
                        <cfelse>
                            <cfset EdLevel="">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="Element129" value="#EdLevel#">
                    </cfhttp>
                    <!--- <cfoutput>#cfhttp.filecontent#</cfoutput> <cfabort> --->
               	</cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 53-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->
                 
	  			
                <!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------Start: memberID 92------------------------------------------------------------------------------------------------>
                <!-------------------------------------------------------------------------------------------------------------------------->                     
				<!--- Florida Tech --->
                <cfif (MemberID eq "92")><!--- LV Changes 7/19/06 --->
                    <cfset postURL="http://info.bisk.com/PostLead.asp?Source=194817zf1&FormID=13406">
                    <cfhttp url="#postURL#" method="POST" timeout="10" redirect="No" resolveurl="Yes">
                        <cfhttpparam type="FORMFIELD" name="Element2" value="#CPLFname#">
                        <cfhttpparam type="FORMFIELD" name="Element6" value="#CPLLname#">
                        <cfhttpparam type="FORMFIELD" name="Element8" value="#CPLEmail#">
                        <cfhttpparam type="FORMFIELD" name="Element12" value="#CPLCity#">
                        <cfhttpparam type="FORMFIELD" name="Element13" value="#lcl_state#">
                        <cfhttpparam type="FORMFIELD" name="Element14" value="#CPLZip#">
                        <cfhttpparam type="FORMFIELD" name="Element116" value="#CPLDPhone#">
                        
                        <!--- Should always be USA at this point, but use this for int'l leads if necc. --->
                        <cfif lcl_cntry eq "US">
                            <cfset PostCountry="USA">
                        <cfelse>
                            <cfset PostCountry="#lcl_cntry#">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="Element34" value="#PostCountry#">
                        <cfif len(CPLAddr2)>
                            <cfset Addr=CPLAddr & ", " & CPLAddr2>
                        <cfelse>
                            <cfset Addr=CPLAddr>
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="Element90" value="#Addr#">
                        <cfif isdefined('strHighestDegree') and len(strHighestDegree)>
                            <cfset EdLevel="#strHighestDegree#">
                        <cfelse>
                            <cfset EdLevel="">
                        </cfif>
                        <cfhttpparam type="FORMFIELD" name="Element129" value="#EdLevel#">           
                        <cfhttpparam type="FORMFIELD" name="Element5299" value="MBA Project Management">
                    </cfhttp>
                    <!--- #cfhttp.filecontent#<cfabort> --->
                </cfif>
				<!-------------------------------------------------------------------------------------------------------------------------->	  			
                <!--------End: memberID 92-------------------------------------------------------------------------------------------------->
                <!-------------------------------------------------------------------------------------------------------------------------->     
	  
	  			<cfif blnSendRTEmail neq 0> <!--- send the email ??? --->
	   				<cfif (toEmail neq "")> <!--- double check in the system --->
					
						
					
					
				   		<!--- Budget Blinds --->
				       	<cfif MemberId eq 90>
                            <cftry>
								<!--- Lead SOAP Username/Password Information --->
                                <cfsavecontent variable="budgetHeaderXML">
                                <AuthenHead xmlns="http://websrvcs.homefranchiseconcepts.com/">
                                <Username>6FigJo</Username>
                                <Password>!iLuvWS</Password>
                                </AuthenHead>
                                </cfsavecontent>
                                
                                <cfset tempphone=replace(CPLDPhone,"(","","all")>
                                <cfset tempphone=replace(tempphone,")","","all")>
                                <cfset tempphone=replace(tempphone,".","","all")>
                                <cfset tempphone=replace(tempphone,"-","","all")>
                                <cfloop condition="#tempphone# contains ' '">
                                <cfset tempphone=replace(tempphone," ","","all")>
                                </cfloop>		
                                <cfset tempphone=right(tempphone,10)>
                                <cfset CPLDPhone = tempphone/>
                                
                                <cfscript>
                                budgetWS = createobject("webservice","http://websrvcs.homefranchiseconcepts.com/HFCFranLeadImport.asmx?wsdl" );
                                xml_obj = xmlparse(budgetHeaderXML);
                                addSOAPRequestHeader(budgetWS, "http://websrvcs.homefranchiseconcepts.com/", "AuthenHead", xml_obj);
                                
                                //Build Data Off Of Structure
                                stArgs = structNew();
                                stArgs.FName = CPLFname;
                                if(application.machine NEQ "LIVE"){
                                stArgs.LName ="TEST";
                                }
                                else{
                                stArgs.LName=CPLLname;
                                }
                                stArgs.Email    = CPLEmail;
                                stArgs.Address  = CPLAddr;
                                stArgs.Address2 = CPLAddr2;
                                stArgs.Country  = lcl_cntry;
                                stArgs.City     = CPLCity;
                                stArgs.State    = getStateAbbr(lcl_state);
                                stArgs.ZipCode  = CPLZip;
                                stArgs.Phone    = CPLDPhone;
                                stArgs.Concept  = "Budget Blinds";
                                stArgs.Capital  = "";
   
								//Call Actual Web Service
								returnObj = budgetWS._import(stArgs);
								</cfscript>

								<cfcatch type="any">
								</cfcatch>
							</cftry>

							<!--- Send Opt-in Welcome email --->
							<cfinclude template="cplEmail/cplOptinEmail90.cfm">
	   					<!--- WSI --->
					   	<cfelseif MemberId eq 28>   
							<!--- Send Opt-in Welcome email 
							<cfinclude template="/email/CPL/cplOptinEmail28.cfm">--->				   
	   					<cfelseif MemberID eq "44">
							<!--- Send Opt-in Welcome email 
							<cfinclude template="/email/CPL/cplOptinEmail44.cfm">--->
						<cfelseif listfindnocase("1",memberid)>
    						<!--- Send Opt-in Welcome email --->
							<cfinclude template="cplEmail/cplOptinEmail1.cfm">
						<cfelse>
	   						<cfif MemberID neq "50" AND  MemberID neq "91" AND  MemberID neq "56" AND  MemberID neq "117" ><!--- Do not send leads to These members --->
                                <!--- Send Opt-in Welcome email --->
								<cfinclude template="cplEmail/cplOptinEmailPopUp.cfm">
							</cfif>
						</cfif>
	   				</cfif>
	  			</cfif>
    		<cfelse>
     			<cfset blnFoundDup=1>
				
    		</cfif>    
	 
	 		<!--- send the client's confirmation email --->
     		<cfif (cpl_name neq "")>
	  			<cfset strSubject="6FigureJobs Opt-In Program: " & cpl_name>
	 		<cfelse>
	  			<cfset strSubject="6FigureJobs Opt-In Program">
	 		</cfif>
	 		
			<cfif (int_client_email eq 1)>
				<cfset strBody="">
                <cfif (cpl_confirmation_mail_body neq "")>
                	<cfset strTempBody=cpl_confirmation_mail_body>
                	<cfset strTempBody=Replace(strTempBody, "$$DQ$$", chr(34), "ALL")>
                	<cfset strTempBody=Replace(strTempBody, "$$SQ$$", chr(39), "ALL")>
                	<cfset strTempBody=replace(strTempBody, "<b>", "", "ALL")>
                	<cfset strTempBody=replace(strTempBody, "</b>", "", "ALL")>
                	<cfset strBody=strTempBody>
                </cfif>
	  
	  			<cfset strHTMLBody="">
	  			<cfif (cpl_confirmation_HTML_mail_body neq "")>
					<cfset strTempHTMLBody=cpl_confirmation_HTML_mail_body>
                    <cfset strTempHTMLBody=Replace(strTempHTMLBody, "$$DQ$$", chr(34), "ALL")>
                    <cfset strTempHTMLBody=Replace(strTempHTMLBody, "$$SQ$$", chr(39), "ALL")>
                    <cfset strHTMLBody=strTempHTMLBody>
	  			</cfif>
	 		</cfif>
            
	 		<cfset strTempName=CPLFname>
	 		<cfif (findNoCase("<b>", strTempName, 1))>
	  			<cfset strTempName=replace(strTempName, "<b>", "", "ALL")>
	  			<cfset strTempName=replace(strTempName, "</b>", "", "ALL")>
	 		</cfif>
			
            <cfquery datasource="#application.dsn#" name="cfqGetLead">
            select intLeadID
            from tblCPLLeadInfo (nolock)
            where intmemberID=<cfqueryparam cfsqltype="cf_sql_integer" value="#MemberID#" null="no" />
            and intresid=<cfqueryparam cfsqltype="cf_sql_integer" value="#lcl_intResID#" />
            and intTargetID=<cfqueryparam cfsqltype="cf_sql_integer" value="#intTargetID#" null="no" />
            and strEmail=<cfqueryparam cfsqltype="cf_sql_varchar" value="#CPLEmail#" null="no" />
			</cfquery>
           
			<cfif cfqGetLead.recordcount gt 0>
                <cfset LeadID=cfqGetLead.intLeadID>
            <cfelse>
                <cfset LeadID="0">
            </cfif>
            
           
	 		<cfif (int_client_email eq 1)>
				<!--- If it's Hoover's, track with doubleclick and send customized email... ---> 
				<cfif MemberID eq "44">
					<!--- Send Opt-in Welcome email 
					<cfinclude template="/email/CPL/cplOptinEmail44Two.cfm">--->
				<!--- If it's NOT Hoover's, no special treatment... ---> 
				<cfelse><!--- Hoovers --->
					<!--- Garrison Philips --->
                   <cfif MemberId eq 89>           
						<!--- Send Opt-in Welcome email
                        <cfinclude template="/email/CPL/cplOptinEmail89.cfm"> --->
                    <!--- WSI Specialized Email --->
                    <cfelseif memberid eq 28>
						<!--- Send Opt-in Welcome email 
                        <cfinclude template="/email/CPL/cplOptinEmail28Two.cfm">--->
                    <cfelseif len(strHTMLBody)><!--- HTML CHECK --->
                        <!--- Send Opt-in Welcome email 
						<cfinclude template="/email/CPL/cplOptinHTMLTextEmail.cfm">--->
                    <cfelse><!--- HTML CHECK --->
						<!--- Send Opt-in Welcome email 
						<cfinclude template="/email/CPL/cplOptinHTMLTextEmail.cfm">--->
                    </cfif><!--- /HTML CHECK --->  
                </cfif><!--- Hoovers --->
            <!--- please 'REPLY' to this message with the word REMOVE in the body of the email. Please leave the subject line intact. --->
            <cfelseif (int_client_email eq 2)> <!--- send the rejection email --->
                <cfset strGeoStateList="">
                <cfset strGeoProvinceList="">
                <cfset strGeoCntryList="">
                <cfloop list="#cpl_geo_list#" index="geoID">
                    <cfloop index="j" from="2" to="#intStatesArrLen#">
                        <cfif (geoID eq "300")>
                            <cfset strGeoStateList="All US Locations">
                        <cfelseif (geoID eq arrStates[j][1])>
                            <cfif (geoID lt 352) OR (geoID eq 3050 or geoID eq 3051)>
                                <cfset strGeoStateList=ListAppend(strGeoStateList, arrStates[j][2])>
                            <cfelseif (geoID lt 413)>
                                <cfset strGeoProvinceList=ListAppend(strGeoProvinceList, arrStates[j][2])>
                            <cfelseif (geoID lt 460)>
                                <cfset strGeoCntryList=ListAppend(strGeoCntryList, arrStates[j][2])> 
                            <cfelse>
                                <cfset strGeoStateList=ListAppend(strGeoStateList, arrStates[j][2])> 
                            </cfif>
                            <cfbreak>
                        </cfif>		
                    </cfloop>
                </cfloop>
                
                <cfoutput>
                <cfset strLocMsg="">
                <cfif listLen(strGeoStateList) gt 0>
                    <cfset strLocMsg=strLocMsg & "U.S. States" & chr(10)>
                    <cfset strLocMsg=strLocMsg & "-------------------" & chr(10)>
                    <cfset strLocMsg=strLocMsg & #strGeoStateList#>
                    <cfset strLocMsg=strLocMsg & chr(10) & chr(13) & chr(13)>
                </cfif>
                <cfif listLen(strGeoProvinceList) gt 0>
                    <cfset strLocMsg=strLocMsg & "Canadian Provinces" & chr(10)>
                    <cfset strLocMsg=strLocMsg & "-------------------" & chr(10)>
                    <cfset strLocMsg=strLocMsg & #strGeoProvinceList#>
                    <cfset strLocMsg=strLocMsg & chr(10) & chr(13) & chr(13)>
                </cfif>
                <cfif listLen(strGeoCntryList) gt 0>
                    <cfset strLocMsg=strLocMsg & "Other Countries" & chr(10)>
                    <cfset strLocMsg=strLocMsg & "-------------------" & chr(10)>
                    <cfset strLocMsg=strLocMsg & #strGeoCntryList#>
                </cfif>
                <cfset list_2_display=replace(strLocMsg, ",", ", ", "ALL")>
                </cfoutput>
 
                <!--- Not The Abandoned Ones --->	 
                <cfif MemberID neq 9999999>
					<!--- Send Opt-in Rejection email
					<cfinclude template="/email/CPL/cplOptinRejectionEmail.cfm">	 --->
                </cfif>
            </cfif>
        <cfelse>
            <cfset strMemberNameList=listAppend(strMemberNameList, cfqCheckCPLDup.strDisplayName, ";")>
        </cfif>
    </cfloop> 
</cfif> 

<!--- Record No From Registration Page --->
<cfif isdefined("session.exec.intresid") and not(blnPassVerification)>
	<cftry>
		<cfset MemberID = memberid/>
		<cfset cplDeleteList = memberid/>
        will get in to t_cpartnerconfirm.cfm page <br />
		<cfinclude template="/6fj/t_cpartnerconfirm.cfm" />
  		<cfcatch type="any"> </cfcatch>
  	</cftry>
</cfif>

<cfif blnResPage neq 1> <!--- if not coming from the res submit form --->
	<cfif intpid neq "">
	here1<cfabort>
		<cfquery datasource="#application.dsn#" name="checkLocation">
		select strplacementname from tblCPLPlacementLookup
		where intPlacementID=#intPID#
		</cfquery>
		
		<cfif checkLocation.strplacementname contains "JSA">
			<cfoutput>
			<script language="Javascript">
			if ((window.opener != null) && (! window.opener.closed)) {
				if ((window.opener.parent != null) && (! window.opener.parent.closed)) {
					retlink=window.opener.parent.location + '&submitted=1&cplstatus=#blnPassVerification#';
					window.location=retlink;
				}else {
					 retlink=window.opener.location + '&submitted=1&cplstatus=#blnPassVerification#';
					 window.location=retlink;
				}
			}else {
				window.location="#request.url#/index.cfm?#strappaddtoken#&submitted=1&cplstatus=#blnPassVerification#&jrl=1";
			}
			</script>
			</cfoutput>
		<cfelse>
			<!--- <cfset ReturnLink = ReturnLink & ""> --->
			<cfset ReturnLink = ReturnLink & "&submitted=1&cplstatus=#blnPassVerification#">
			<cflocation url="#ReturnLink#" addtoken="No">
		</cfif>
	<cfelse>
		<cflocation url="/partner?showform=N&showConfirm=Y" addtoken="No">
	</cfif>
</cfif>
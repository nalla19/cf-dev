<cfparam name="intCPLListNeedAnswering" default="">
<cfoutput>
<cftry>
	<cfif not isdefined("qgetEmailOptions")>
    	<cfstoredproc procedure="sp_exec_emailoptions" datasource="#application.dsn#" returncode="Yes">
        <cfprocparam type="IN" variable="@intProcType" value="1" cfsqltype="CF_SQL_INTEGER">
        <cfprocparam type="IN" variable="@intResID" value="#intResID#" cfsqltype="CF_SQL_INTEGER">
        <cfprocresult resultset="1" name="qgetEmailOptions">
        </cfstoredproc>
    </cfif>

    <cfquery datasource="#application.dsn#" name="getStateID">
    select intOldID from tblStates (nolock) where 1=1 and strName=(select state from tblresumes  (nolock) where intresid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#intResID#" />)
    </cfquery>

    <cfscript>
    email = qgetEmailOptions.email;
    listCompletedSteps = qgetEmailOptions.listCompletedSteps;
    stateID = val(getStateID.intOldID);
    </cfscript>

    <cfstoredproc procedure="sp_exec_stepfive_CPL" datasource="#application.dsn#" returncode="Yes">
        <cfprocparam type="IN" variable="@intGroupID" value="54" cfsqltype="CF_SQL_INTEGER">
        <cfprocparam type="IN" variable="@strCPLEmail" value="#email#" cfsqltype="CF_SQL_VARCHAR">
        <cfprocresult resultset="1" name="cplInfo">
    </cfstoredproc>

    <cfscript>
    if (cplInfo.recordCount){
        intCPLListNeedAnswering=valueList(cplInfo.intMemberID);
        intCPLListisEducation=valueList(cplInfo.blnEducation);
    }else{
        intCPLListNeedAnswering="";
        intCPLListNeedAnswering="";
    }

    // Testing New IP Location Database - hide 'US Only' CPLs if IP is outside of US
    blnShowUSCPLs="1";
    if (len(cgi.remote_addr)){
        ThisIP=cgi.remote_addr;
        ThisIP="204.118.132.81";		//Confirm IP Address. Remove This For All Others
        IPsegment1=ListGetAt(ThisIP,1,".");
        IPsegment2=ListGetAt(ThisIP,2,".");
        IPsegment3=ListGetAt(ThisIP,3,".");
        IPsegment4=ListGetAt(ThisIP,4,".");
        numip=(IPsegment1 * 16777216) + (IPsegment2 * 65536) + (IPsegment3 * 256) + IPsegment4;
    }
    </cfscript>
	 
    <cfif ThisIP neq "204.118.132.81">
        <!--- Get Country By IP Address --->
        <cfstoredproc procedure="spS_getCCbyIP" datasource="#application.dsn#" returncode="Yes">
            <cfprocparam type="IN" variable="@ipNum" value="#val(numip)#" cfsqltype="CF_SQL_INTEGER">
            <cfprocresult resultset="1" name="checkIP">
        </cfstoredproc>

        <cfif checkIP.recordcount gt 0 and checkIP.country_code neq "USA">
            <cfset blnShowUSCPLs=0>
        </cfif>
    </cfif>

    <cfif blnShowUSCPLs eq "0">
        <cfset intCPLListNeedAnsweringtemp=intCPLListNeedAnswering>
        <cfif listlen(intCPLListNeedAnswering) gt 0>
            <cfloop from="1" to="#listlen(intCPLListNeedAnswering)#" index="cplid">
                <cfquery datasource="#application.dsn#" name="checkIntlLeads">
                select blnInternational from tblcplmember (nolock)
                 where intmemberid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#listGetAt(intCPLListNeedAnswering,cplid)#" />
                </cfquery>

                <cfif checkIntlLeads.recordcount gt 0 and checkIntlLeads.blnInternational eq "0">
                    <cfset intCPLListNeedAnsweringtemp=ListDeleteAt(intCPLListNeedAnsweringtemp,ListFindNoCase(intCPLListNeedAnsweringtemp,listGetAt(intCPLListNeedAnswering,cplid)))>
                </cfif>
            </cfloop>
        </cfif>
        <cfset intCPLListNeedAnswering=intCPLListNeedAnsweringtemp>
    </cfif>

    <cfparam name="intCPLCustomQuestionList" default="">
    <cfif len(intCPLListNeedAnswering)>
        <cfquery datasource="#application.dsn#" name="getCustomquestions">
        select distinct(intmemberid) as memberid
        from tblCplQuestions (nolock)
        where intmemberid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#intCPLListNeedAnswering#" list="yes" />)
        and blnActive=1
        and blnInProgress=0
        </cfquery>

        <cfif getCustomquestions.recordcount gt 0>
            <cfset intCPLCustomQuestionList=ValueList(getCustomquestions.memberid)>
        </cfif>
    </cfif>

	<cfcatch type="Database">
		<!---ISR <cf_ct_displayErrorMsg errorID=2>
    	<cf_ct_emailWebMaster catchObj="#cfcatch#" clientID="#session.exec.intresid#"  msg="Error retrieving info for step 5." browser="#cgi.HTTP_USER_AGENT#"> --->

		<cfquery datasource="#application.dsn#" name="deleteDuplicate">
		delete from tblCPLTracking where intResID=#session.exec.intresid#
		</cfquery>
  </cfcatch>
</cftry>

<cfinclude template="joinStep3ExcludeCPL.cfm">

<cfif not len(intCPLListNeedAnswering)>
	<cflocation url="thankyou.cfm?Fy4ZT9ZUv=#URLEncodedFormat(url.Fy4ZT9ZUv)#" addtoken="no">
</cfif>

<!---Non-Educational CPL's that need answering--->
<cfquery name="cfqGetNonEduCPLs" datasource="#application.dsn#">
select m.intMemberID,m.blnEducation,m.strTitle, m.strImageName, m.strHTMLTxt, m.strMemberName, m.strDisclaimerTxt
  from tblCPLGroup g (nolock)
 inner join tblCPLMemberLokUp lok (nolock) 
    on lok.intGroupID=g.intGroupID
 inner join tblCPLMember m (nolock) 
    on m.intMemberID=lok.intMemberID
	and m.blnActive=1		
  where 1=1
    and g.intGroupID=54
    and m.intMemberID in (#intCPLListNeedAnswering#)
    and m.blnEducation = 0
  order by m.intDisplayOrder asc	
</cfquery>
<cfset intCPLListNeedAnsweringNonEdu = valueList(cfqGetNonEduCPLs.intMemberID)>

<!---Educational CPL's that need answering--->
<cfquery name="cfqGetEduCPLs" datasource="#application.dsn#">
select m.intMemberID,m.blnEducation,m.strTitle, m.strImageName, m.strHTMLTxt, m.strMemberName, m.strDisclaimerTxt
  from tblCPLGroup g (nolock)
 inner join tblCPLMemberLokUp lok (nolock) 
    on lok.intGroupID=g.intGroupID
 inner join tblCPLMember m (nolock) 
    on m.intMemberID=lok.intMemberID
	and m.blnActive=1		
  where 1=1
    and g.intGroupID=54
    and m.intMemberID in (#intCPLListNeedAnswering#)
    and m.blnEducation = 1
	order by m.intDisplayOrder asc	
</cfquery>

<cfset intCPLListNeedAnsweringEdu = valueList(cfqGetEduCPLs.intMemberID)>

<script language="JavaScript">
function customclick(leadid,winname){
	<!--- Use CustL instead of L in url so it will not get tracked in the application file --->
	window.open('/click_custom.cfm?id=#intresid#&CustL=' + leadid + '','' + winname + '','address=no,screenX=150,screenY=50,left=150,top=50,width=805,height=425,scrollbars=yes,resizable=yes');
}

function customcpl(intmemberid,winname){
	newwindow=window.open('/CoReg_CustForm.cfm?#application.strAppAddToken#&intPID=5&id=' + intmemberid + '','' + winname + '','address=no,screenX=150,screenY=50,left=150,top=50,width=555,height=425,scrollbars=yes,resizable=no');
	if(! newwindow){
		alert('You must disable any pop-up blockers to fill out the required information for this request.');
	}
}
//Custom Div For Hiding and Showing Custom Forms For Processing...
<cfloop index="cplList" list="#intCPLCustomQuestionList#">
function customCPL#cplList#(showdiv){
	var customCPL#cplList# = document.getElementById('customCPL#cplList#')

	if (showdiv == 0){
		customCPL#cplList#.style.display = 'none'; //Hide Display
	}else{
		customCPL#cplList#.style.display = 'block'; //Show Display
	}
}
</cfloop>
</script>

<script language="javascript">
function checkform4(){
	
	var errLen = 0;
	var elLength = document.execCPLs.elements.length;
	
	//Resume Critique
	var blnResumeCritique = document.getElementsByName('freeResumeCritique');
	var ischecked = false;
	for ( var i = 0; i < blnResumeCritique.length; i++) {
		if(blnResumeCritique[i].checked) {
			ischecked = true;
		}
	}
	if(!ischecked){ //Resume Critique is not checked
		document.getElementById('blnResCritiqueErrTxt').style.color = '##F00';
		errLen+=1;
	}else{
		document.getElementById('blnResCritiqueErrTxt').style.color = '';
	}
	
	
	for (i=0; i<elLength; i++){
		var type = execCPLs.elements[i].type;
		if (type=="hidden"){
			var cplVariable = 'bln'+execCPLs.elements[i].name;
			var cplYesRadioBox = 'bln'+execCPLs.elements[i].name + 'Yes';
			var cplNoRadioBox = 'bln'+execCPLs.elements[i].name + 'No';
			var cplErrTxt = 'bln'+execCPLs.elements[i].name + 'ErrTxt';
			
			if (!document.getElementById(cplYesRadioBox).checked && !document.getElementById(cplNoRadioBox).checked){
				document.getElementById(cplErrTxt).style.color = '##F00';
				errLen+=1;
			}else{
				document.getElementById(cplErrTxt).style.color = '';	
			}
		}
	}
	
	//Errors
	if (errLen > 0){
		//document.getElementById('successMessage').style.display = "none";
		document.getElementById('errorDiv').style.display = "block";
		//Scroll to the top		
		$("html, body").animate({ scrollTop: 0 }, "fast");
		return false ;
	}else{
		$("##submitBtn").attr("disabled", "disabled");
		document.getElementById('errorDiv').style.display = "none";
		return true ;
	}
}

</script>
</cfoutput>
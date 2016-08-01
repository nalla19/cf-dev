<cfparam name="expid" default="0">
<cfparam name="sa_attr" default="">
<cfparam name="sa_form_q_fsd" default="">
<cfparam name="sa_form_q_nl" default="">
<cfparam name="sa_form_q_nsc" default="">
<cfparam name="sa_form_q_nsf" default="">
<cfparam name="sa_form_q_nst" default="">
<cfparam name="sa_jobTitleSearch" default="0">
<cfparam name="sa_strKeyWords" default="">
<cfparam name="sa_strSkills" default="">
<cfparam name="sa_strTitle" default="">

<cfparam name="srchTitle1" default="Any Job Title">
<cfparam name="srchSkills1" default="Any Skills">
<cfparam name="srchLocation1" default="Any Location">
<cfparam name="srchSkills2" default="Any Skills">
<cfparam name="srchLocation2" default="Any Location">

<cfif isdefined("url.strSkills")>
	<cfset srchSkills2 = url.strSkills>
</cfif>
<cfif isdefined("url.strTitle")>
	<cfset srchTitle1 = url.strTitle>
	<cfset sa_jobTitleSearch ="1">
</cfif>
<cfif isdefined("url.strLocation")>
	<cfset srchLocation1 = url.strLocation>
	<cfset srchLocation2 = url.strLocation>
</cfif>

<!--- If the page is a redirect from a keyword or atts error, there is no need to call the page which sets the variables. They will all be set from the url. --->
<cfif not isdefined('url.bnlattserror') and not isdefined('url.keyworderror')>
	<cfif expid neq 1>
		<!--- INCLUDE FILE: alertGet.cfm --->
		<cfinclude template="alertGet.cfm">
		
        <cfset sa_attr = cfqAgent.strAtts>  
            
		<cfif len(sa_attr) gt 0>
        	<cfset sa_attr = replace(sa_attr, ",,", ",", "ALL")>
			<cfset sa_attr = replace(sa_attr, ", ,", ", ", "ALL")>
            
            <cfquery name="cfqGetIndustries" datasource="#application.dsn#">
            select  strIndName from tblIndustries (nolock) where intOldIndID in (#sa_attr#)
            </cfquery>
            <cfif cfqGetIndustries.recordcount gt 0>
                <cfset sa_form_q_nsc = valuelist(cfqGetIndustries.strIndName)>
            </cfif>
            
            <cfquery name="cfqGetFunctions" datasource="#application.dsn#">
            select  strFunctionName from tblFunctions (nolock) where intOldFunctionID in (#sa_attr#)
            </cfquery>
            <cfif cfqGetFunctions.recordcount gt 0>
                <cfset sa_form_q_nsf = valuelist(cfqGetFunctions.strFunctionName)>
            </cfif>
            
            <cfquery name="cfqGetStates" datasource="#application.dsn#">
            select strName from tblStates (nolock) where intOldID in (#sa_attr#)
            </cfquery>
            <cfif cfqGetStates.recordcount gt 0>
                <cfset sa_form_q_nst = valuelist(cfqGetStates.strName)>
            </cfif>			                
        </cfif>
 
        <cfset sa_form_q_fsd = cfqAgent.strSalary>
        <!--- <cfif listlen(sa_form_q_fsd)  is 1>
        	<cfset sa_form_q_fsd = '"#sa_form_q_fsd#"' >
       	<cfelseif listlen(sa_form_q_fsd) gt 1>
        	<cfset sa_form_q_fsd = replace(sa_form_q_fsd, ',' , '","', "ALL")>
            <cfset sa_form_q_fsd = '"' & sa_form_q_fsd & '"'>
        </cfif> --->
        
		
        <cfset sa_form_q_nl = cfqAgent.strLocation>
        <cfset sa_jobTitleSearch = cfqAgent.intJobTitleSearch>
        <cfset sa_strKeyWords = cfqAgent.strKeyWords>
        <cfset sa_strSkills = cfqAgent.strSkills>
        <cfset sa_strTitle = cfqAgent.strJobTitle>
        
        <cfif isDefined("sa_jobTitleSearch") and sa_jobTitleSearch is 1>
			<cfif isDefined("sa_strTitle") and sa_strTitle neq "">
                <cfset srchTitle1 = sa_strTitle>
            </cfif>
            
            <cfif isDefined("sa_strSkills") and sa_strSkills neq "">
                <cfset srchSkills1 = sa_strSkills>
            </cfif>
            
            <cfif isDefined("sa_form_q_nl") and sa_form_q_nl neq "">
                <cfset srchLocation1 = sa_form_q_nl>
            </cfif>
        <cfelseif isDefined("sa_jobTitleSearch") and sa_jobTitleSearch is 0>    
            <cfif isDefined("sa_strSkills") and sa_strSkills neq "">
                <cfset srchSkills2 = sa_strSkills>
            </cfif>
            
            <cfif isDefined("sa_form_q_nl") and sa_form_q_nl neq "">
                <cfset srchLocation2 = sa_form_q_nl>
            </cfif>
        <cfelseif isDefined("sa_jobTitleSearch") and sa_jobTitleSearch is "">
        	<cfset sa_jobTitleSearch = 0>
           <!---  <cf_ct_removeQuotes strStrip="#sa_strKeyWords#" blnRemove="0"> --->
		   <cfif isDefined("sa_strKeyWords") and sa_strKeyWords neq "">
			   <cfset strstrip = application.util.getRemoveQuotes(strStrip="#sa_strKeyWords#",  blnRemove="0")>
				<cfset srchSkills2 = strStrip>
			</cfif>
			<cfif isDefined("sa_form_q_nl") and sa_form_q_nl neq "">
            	<cfset srchLocation2 = sa_form_q_nl>
			</cfif>
		</cfif>
    	
        <cfif isDefined("blnEmailAgent")>
	        <cfif blnEmailAgent eq 1> 
				<cfif blnWeekly eq 0>
	                <cfset strEmailAgentFreq = "d">
	             <cfelse>
	                <cfset strEmailAgentFreq = "w">
	             </cfif>
	        <cfelse>
	            <cfset strEmailAgentFreq = "n">
	        </cfif>     
       	</cfif>
	</cfif>
    
	<cfif isdefined('url.titleerror')>
		<cfset strTitleOrg=urldecode(url.strTitleOrg)>
	<cfelse>
		<cfset strTitleOrg=strTitle>
	</cfif>
<cfelse>
	in ehrere<br />
	<!--- If the page is a redirect from a keyword or too many atts error, we will still need the original title and date created. --->
	<cfif strMode eq "edit">
		<cfquery name="cfqAgent" datasource="#application.dsn#">
		select *
		from tblSearchAgent (NOLOCK)
		where intresid=#intResID# and strTitle='#strTitle#'
		</cfquery>
		
		<cfif cfqAgent.RecordCount gt 0>
			<cfset strTitleOrg=cfqAgent.strTitle>
			<cfset dteCrt=cfqAgent.dteCreated>
            <cfset blnEmailAgent = cfqAgent.blnEmailAgent>
			<cfset blnWeekly = cfqAgent.blnWeekly>
            
            blnEmailAgent=#blnEmailAgent#<br />
            blnWeekly=#blnWeekly#<br />
			<cfif blnEmailAgent eq 1> 
				<cfif blnWeekly eq 0>
                	<cfset strEmailAgentFreq = "d">
                 <cfelse>
                    <cfset strEmailAgentFreq = "w">
                 </cfif>
            <cfelse>
                <cfset strEmailAgentFreq = "n">
            </cfif>         

		<cfelse>
			<cfset strTitleOrg="">
			<cfset dteCrt="">
		</cfif>
	<cfelse>
		<cfset strTitleOrg="">
		<cfset dteCrt="">
	</cfif>
</cfif>

<cfoutput>

<cfif strMode eq "edit">
 	<cfset blnNewRcrd=0>
<cfelse>
 	<cfset blnNewRcrd=1>
</cfif>

<cfparam name="TitleMessage" default="">

<cfif isdefined('url.titleerror')>
	<cfswitch expression="#url.titleerror#">
		<cfcase value="wild">
			<cfset TitleMessage = "<span class='error_red'>Your title contains invalid characters</span>">
		</cfcase>
	</cfswitch>
</cfif>
<!--- 
<link type="text/css" href="/css/ui-lightness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />

<cfif application.applicationname EQ "6FigureJobs">
	<link type="text/css" href="/css/6fjauto.css" rel="stylesheet" />
</cfif>

<script type="text/javascript" src="/js/jquery-ui-1.8.16.custom.min.js"></script>
--->
<script type="text/javascript">
	
function toggleDiv(show){
	if (show == 1){
		document.getElementById('searchform_inner2').style.display = "none";
		document.getElementById('searchform_inner').style.display = "block";
		document.getElementById("sa_jobTitleSearch").value=1
	}else{
		document.getElementById('searchform_inner2').style.display = "block";
		document.getElementById('searchform_inner').style.display = "none";
		document.getElementById("sa_jobTitleSearch").value=0;
	}
}

function checkUncheckAll(fieldName){				
	if (fieldName == 'industry'){
		var indChecked = 0;
		for (i=0; i<document.Agent.form_q_nsc.length; i++){if (document.Agent.form_q_nsc[i].checked==true){indChecked++;}}													
		if (indChecked == 0){document.Agent.allIndustries.checked=true;}else{document.Agent.allIndustries.checked=false;}	
	}else if (fieldName == 'function'){
		var funcChecked = 0;
		for (i=0; i<document.Agent.form_q_nsf.length; i++){if (document.Agent.form_q_nsf[i].checked==true){funcChecked++;}}													
		if (funcChecked == 0){document.Agent.allFunctions.checked=true;}else{document.Agent.allFunctions.checked=false;}	
	}else if (fieldName == 'state'){
		var stateChecked = 0;
		for (i=0; i<document.Agent.form_q_nst.length; i++){if (document.Agent.form_q_nst[i].checked==true){stateChecked++;}}													
		if (stateChecked == 0){document.Agent.allState.checked=true;}else{document.Agent.allState.checked=false;}	
	}else if (fieldName == 'salary'){
		var salaryChecked = 0;
		for (i=0; i<document.Agent.form_q_fsd.length; i++){if (document.Agent.form_q_fsd[i].checked==true){salaryChecked++;}}													
		if (salaryChecked == 0){document.Agent.allSalaries.checked=true;}else{document.Agent.allSalaries.checked=false;}	
	}
}

function checkDefault(fieldName){				
	if (fieldName == 'industry'){
		for (i=0; i<document.Agent.form_q_nsc.length; i++){ if (document.Agent.form_q_nsc[i].checked==true) document.Agent.form_q_nsc[i].checked=false;}
		document.Agent.allIndustries.checked=true;
	}else if (fieldName == 'function'){
		for (i=0; i<document.Agent.form_q_nsf.length; i++){ if (document.Agent.form_q_nsf[i].checked==true) document.Agent.form_q_nsf[i].checked=false;}
		document.Agent.allFunctions.checked=true;
	}else if (fieldName == 'state'){
		for (i=0; i<document.Agent.form_q_nst.length; i++){ if (document.Agent.form_q_nst[i].checked==true) document.Agent.form_q_nst[i].checked=false;}
		document.Agent.allState.checked=true;
	}else if (fieldName == 'salary'){
		for (i=0; i<document.Agent.form_q_fsd.length; i++){ if (document.Agent.form_q_fsd[i].checked==true) document.Agent.form_q_fsd[i].checked=false;}
		document.Agent.allSalaries.checked=true;							
	}
}

$(function() {
	
	function search(term, cb, extras) {
		 data = {q: term,'q.op': 'AND', rows: 10, wt: 'json', fl: '*,score', group: true, 'group.field': 'type', 'group.limit': 5 };
		$.ajax({url: 'http://#application.SOLRjobServer#:8080/solr/select', dataType: 'jsonp', jsonp: 'json.wrf', data: extras ? $.extend(data, extras) : data, success: cb});
	}
	
	$.widget('custom.catcomplete', $.ui.autocomplete,{
		_renderMenu: function(ul, items){
			var self = this;
			$.each(items, function(index, item) {if (! $.isEmptyObject(item.data)) {self._renderItem(ul, item);} else {ul.append('<li class="ui-autocomplete-header ui-menu-item ui-widget-header">' + item.value + '</li>');}
			});
		}
	});


	$( "##a_title" ).catcomplete({
		source: function (req, res) {        
			// for autocomplete
			search(req.term, function (data) {
				var groups = data.grouped.type.groups;
				var recommend = [];
				var results = [];
				for (var i = 0, len = groups.length; i < len; i++) {
					var group = groups[i];
					
					//results.push({value:group.groupValue, data:{}});
					if (group.groupValue == "Job Title") {
						results.push({value:'Matching Job Titles', data:{}});
					} else if (group.groupValue == 'Job Type'){
						//results.push({value:'Suggested Job Titles', data:{}});
					} else {
						results.push({value:group.groupValue, data:{}});
					}

					var docs = group.doclist.docs;
					for (var j = 0, jlen = docs.length; j < jlen; j++) {
						var doc = docs[j];
						results.push({value:doc.suggestion, data:doc});
						if (doc.recommended) {
							if (recommend.length === 0) {recommend.push({value:'Other Recommended Titles', data:{}});}
							for (var k = 0, klen = doc.recommended.length; k < klen; k++) {recommend.push({value:doc.recommended[k], data:doc});}
						}
					}
				}
	
				if (recommend) {results = results.concat(recommend);}
				res(results);
			});
		}
	});
	
	$( "##b_skills" ).catcomplete({
		source: function (req, res) {        
			// for autocomplete
			search(req.term, function (data) {
				var groups = data.grouped.type.groups;
				var recommend = [];
				var results = [];
				for (var i = 0, len = groups.length; i < len; i++) {
					var group = groups[i];
					
					//results.push({value:group.groupValue, data:{}});
					if (group.groupValue == "Job Title") {
						results.push({value:'Matching Job Titles', data:{}});
					} else if (group.groupValue == 'Job Type'){
						//results.push({value:'Suggested Job Titles', data:{}});
					} else {
						results.push({value:group.groupValue, data:{}});
					}
					var docs = group.doclist.docs;
					for (var j = 0, jlen = docs.length; j < jlen; j++) {
						var doc = docs[j];
						results.push({value:doc.suggestion, data:doc});
						if (doc.recommended) {
							if (recommend.length === 0) {recommend.push({value:'Other Recommended Titles', data:{}});}
							for (var k = 0, klen = doc.recommended.length; k < klen; k++) {recommend.push({value:doc.recommended[k], data:doc});}
						}
					}
				}
	
				if (recommend) {results = results.concat(recommend);}
				res(results);
			});
		}
	});

});
</script> 
<!---------------------------End: Auto Complete -------------------------->

<form name="Agent" action="/member-job-alerts?#strAppAddToken#&am=#am#&tm=#tm#" method="post" role="form">
<input type="hidden" name="expid" value="#expid#">
<input type="hidden" name="strMode" value="save">
<input type="hidden" name="blnNewRcrd" value="#blnNewRcrd#">
<input type="hidden" name="strTitleOrg" value="#strTitleOrg#">
<input type="hidden" name="dteCrt" value="#dteCrt#">
<input type="hidden" name="sa_jobTitleSearch" id="sa_jobTitleSearch" value="#sa_jobTitleSearch#">
<input type="hidden" name="searchform" value="6FJ">
<input type="hidden" name="resJS" value="1">

<cflock scope="SESSION" type="EXCLUSIVE" timeout="10">
	<cfset session.exec.SHKeywordString="">
	<cfset session.Searchjobs.SHstrTitle="">
	<cfset session.Searchjobs.SHlocation="">
	<cfset session.Searchjobs.SHstrKeywordExactPhrase="">
	<cfset session.Searchjobs.SHstrKeywordNotPhrase="">
	<cfset session.Searchjobs.SHintDatescope="">
	<cfset session.Searchjobs.SHintMiles="">
	<cfset session.Searchjobs.SHJobType="">
	<cfset session.Searchjobs.SHSearchForm="">
	<cfset session.Searchjobs.SHIsSearchAgent="">
</cflock>

<cfif cgi.script_name does not contain "agent">
	<cflock scope="SESSION" type="readonly" timeout="10">
		<cfif isdefined('session.searchjobs.strkeywords')>
			<cfset strkeywords=session.searchjobs.strkeywords>
		<cfelseif isdefined('form.strkeywords')>
			<cfset strkeywords=form.strkeywords>
		</cfif>
	</cflock>
</cfif>

<cfparam name="blnEmailAgent" default="">
<cfparam name="in_error0" default="">
<cfparam name="in_error1" default="">
<cfparam name="KeyWordMessage" default="">

<cflock scope="session" timeout="10" type="Exclusive">
	<cfset session.SearchJobs.searchfeatured="0">
</cflock>

<cfif isdefined('url.keyworderror')>
	<cfswitch expression="#url.keyworderror#">
		<cfcase value="blank">
			<cfset KeyWordMessage = ": <span class='error_red_bld'>You must enter a keyword</span>">
			<!--- <cfset in_error0="">
			<cfset in_error1=""> --->
			<cfset strkeywords="">
		</cfcase>
		<cfcase value="wild">
			<cfset KeyWordMessage = ": <span class='error_red_bld'>Your keywords contain invalid characters</span>">
			<!--- <cfset in_error0="">
			<cfset in_error1=""> --->
			<cfif isdefined('url.strkeywords')>
				<cfset strkeywords=url.strkeywords>
			</cfif>
		</cfcase>
	</cfswitch>
</cfif>

<cfparam name="blnFulltime" default="0">
<cfparam name="blnContract" default="0">
<cfparam name="blnStartup" default="0">
<cfparam name="strSearchType" default="broad">

<cfif strSearchType eq "">
	<cfset strSearchType="broad">
</cfif>

<!--- If the page is a redirect from a keyword or atts error, set variables form url --->
<cftry>
	<cfif strkeywords eq "" and isdefined('url.strkeywords')>
		<cfset strkeywords=url.strkeywords>
	</cfif>
	<cfif intsIndIDs eq "" and isdefined('url.intsIndIDs')>
		<cfset intsIndIDs=url.intsIndIDs>
	</cfif>
	<cfif intsFuncIDs eq "" and isdefined('url.intsFuncIDs')>
		<cfset intsFuncIDs=url.intsFuncIDs>
	</cfif>
	<cfif isdefined('url.listStateIDs') and (listStateIDs eq "" or listStateIDs eq "300")>
		<cfset listStateIDs=url.listStateIDs>
	</cfif>
	<cfif blncontract eq "0" and isdefined('url.blncontract')>
		<cfset blncontract=url.blncontract>
	</cfif>
	<cfif blnFulltime eq "0" and isdefined('url.blnFulltime')>
		<cfset blnFulltime=url.blnFulltime>
	</cfif>
	<cfif blnStartup eq "0" and isdefined('url.blnStartup')>
		<cfset blnStartup=url.blnStartup>
	</cfif>
	<cfif blnEmailAgent eq "" and isdefined('url.blnEmailAgent')>
		<cfset blnEmailAgent=url.blnEmailAgent>
	</cfif>
	<cfif isdefined('url.strsearchtype')>
		<cfset strsearchtype=url.strsearchtype>
	</cfif>
	<cfcatch type="Any">
	</cfcatch>
</cftry>
<!--- /END - If the page is a redirect from a keyword or atts error, set variables form url --->

<cfif listStateIDs eq "">
	<cfset listStateIDs="300">
	<cfset intStateIds = "300">
</cfif>

<cfparam name="errormessage" default="">
	
<cfif isdefined('url.bnlattserror')>
	<cfset errormessage="<br><br><span class='error_red'><b>Please reduce the amount of criteria you have selected from the pulldown menus below</b></span><br><br>">
</cfif>


			<h1 class="page-title">Job Search Alerts</h1>
			<div class="row">
				<div class="span12">
					<div class="page-spacer"></div>
					<div>
						<cfif #strMode# eq "new">
							Use this form to create and save a Job Search Alert.
						<cfelse>
							Use this form to edit your Job Search Alert.
						</cfif>
					</div>
					<div class="page-spacer"></div>
					<div class="form-group">
						<label for="strTitle"><h5>Give Your Search Alert a Name:</h5></label>
            			<input type="text" style="width:250px;" class="" name="strTitle" size="50" maxlength="50" tabindex="1" value="#strTitle#"/>&nbsp;#TitleMessage#
					</div>
					<div class="page-spacer"></div>
					<div>
						<div><h5>Select Your Email Delivery Preference:</h5></div>
					
						<cfparam name="strEmailAgentFreq" default="w">
						<cfif strEmailAgentFreq eq "n">
							<cfif blnEmailAgent eq 1> 
								 <cfif blnWeekly eq 0>
									<cfset strEmailAgentFreq = "d">
								 <cfelse>
									<cfset strEmailAgentFreq = "w">
								 </cfif>
							<cfelse>
								<cfset strEmailAgentFreq = "n">
							</cfif>
						</cfif>
						
						<input tabindex="9" type="radio" name="strEmailAgentFreq" value="w" <cfif strEmailAgentFreq eq 'w'> checked</cfif> > Receive Weekly (Strongly Recommended)<br>
						<input tabindex="9" type="radio" name="strEmailAgentFreq" value="d" <cfif strEmailAgentFreq eq 'd'> checked</cfif> > Receive Daily<br>
						<input tabindex="9" type="radio" name="strEmailAgentFreq" value="n" <cfif strEmailAgentFreq eq 'n'> checked</cfif> > Do not receive via email
					</div>
					<div class="page-spacer"></div>
					<div>
					<a href="##" id="SaveSearchAlertbutton" style="margin-right:20px;" onclick="document.Agent.SubmitAction.value='Save Search Alert'; document.Agent.submit();"><input class="btn btn-primary" type="button" name="validate" id="submitBtn" value="&nbsp;Save Alert&nbsp;"></a>
						
					</div>
					<div class="page-spacer"></div>
					<div>
						<cfif not isdefined("url.strmode")>
							<tr>
								<td align="center" valign="top">
									<input type="hidden" name="SubmitAction" value="" />
									<a href="##" id="SaveSearchAlertbutton" onclick="document.Agent.SubmitAction.value='Save Search Alert'; document.Agent.submit();"></a>
									<cfif strMode eq "edit">
									<!--- <input name="SubmitAction" class="exec_submit" type="Submit" value="Delete Search Alert"> --->
									<a href="##" class="executive_button" onclick="document.Agent.SubmitAction.value='Delete Search Alert'; document.Agent.submit();"><span>DELETE SEARCH ALERT</span></a>
									</cfif>
								</td>
							</tr>
						</cfif>
					</div>
					<div class="page-spacer"></div>
					<div style="border-bottom:1px dotted ##B1B1B1;"></div>
					<div class="page-spacer"></div>
					<div>
						<div class="main_searchform_advancedheader"><h5>Your Job Search Alert Criteria:</h5></div>
						<div style="clear:both; padding-bottom:20px;"></div>
						<cfif len(srchTitle1)>
							
							<cfset sa_jobTitleSearch ="1">
						</cfif>
						<div class="main_searchform_top">
							<div id="searchform_inner2" <cfif sa_jobTitleSearch is 1>style="display:none; padding-left:0;"<cfelse>style="display:block; padding-left:0;"</cfif>>
								<div class="main_searchselect_options"> 
									<span class="main_search_select">Standard Keyword Search</span> &nbsp;&nbsp;|&nbsp;&nbsp; <a href="##" onClick="toggleDiv(1);">Switch to Job Title Search</a>
								</div>
						  
								<div class="main_searchform_row"> 
									<span class="main_searchform"><input type="text" style="width:545px;" class="" name="strSkills2" id="b_skills" size="50" maxlength="200" tabindex="1" value="#srchSkills2#" onFocus="if(this.value==this.defaultValue){this.value='';}this.style.color='##333333';" onBlur="if(this.value==''){this.value=this.defaultValue;this.style.color='##333333';}" /></span>
									<span class="main_searchform">
										<input type="text" class="" name="strLocation2" id="b_location" size="50" maxlength="100" tabindex="2" value="#srchLocation2#" onFocus="if(this.value==this.defaultValue){this.value='';}this.style.color='##333333';" onBlur="if(this.value==''){this.value=this.defaultValue;this.style.color='##333333';}" />
									</span> 
									<br class="clearthis" />
								</div>
							</div>

							<div id="searchform_inner" <cfif sa_jobTitleSearch is 1>style="display:block; padding-left:0;"<cfelse>style="display:none; padding-left:0;"</cfif>>
								<div class="main_searchselect_options"><a href="##" onClick="toggleDiv(0);">Switch to Standard Keyword Search</a> &nbsp;&nbsp;|&nbsp;&nbsp; <span class="main_search_select">Job Title Search</span></div>
						  
								<div class="main_searchform_row"> 
									<span class="main_searchform"><input type="text" class="" name="strTitle1" id="a_title" size="50" maxlength="100" tabindex="1" value="#srchTitle1#" onFocus="if(this.value==this.defaultValue){this.value='';}this.style.color='##333333';" onBlur="if(this.value==''){this.value=this.defaultValue;this.style.color='##333333';}" /></span>							
									<br class="clearthis" />
									<span class="main_searchform"><input type="text" class="" name="strSkills1" id="a_skills" size="50" maxlength="100" tabindex="2" value="#srchSkills1#" onFocus="if(this.value==this.defaultValue){this.value='';}this.style.color='##333333';" onBlur="if(this.value==''){this.value=this.defaultValue;this.style.color='##333333';}" /></span>							
									<br class="clearthis" />							
									<span class="main_searchform">
										<input type="text" class="" name="strLocation1" id="a_location" size="50" maxlength="100" tabindex="3" value="#srchLocation1#" onFocus="if(this.value==this.defaultValue){this.value='';}this.style.color='##333333';" onBlur="if(this.value==''){this.value=this.defaultValue;this.style.color='##333333';}" />
										<input id="advancedSearch" name="advancedSearch" type="hidden" value="1"/>
									</span>
									<br class="clearthis" />							 
								</div>
								
							</div>
							<div class="page-spacer"></div>
							<div class="page-spacer"></div>
							<div class="regsubheader"><h5>Advanced Search Options</h5></div>
							
							<div><h5>Industries</h5></div>
								<cfset request.qry_industries = application.industryManager.getIndustries() />
								<div style="height: 175px; width:335px; overflow:auto; border: 1px solid ##CCCCCC; padding:5px 5px 5px 5px; background: ##ffffff;">
								
									 <div class="item"><input name="allIndustries" type="checkbox" value="allIndustries" class="exclude"  id="allIndustries" onclick="checkDefault('industry');" <cfif listfind(sa_form_q_nsc, "&quot;All Industries&quot;") or sa_form_q_nsc is "">checked="checked"</cfif>  /><label class="checkbox inline" for="">All Industries</label></div> 
									<cfloop query="request.qry_industries">
										<div class="item">
											<input name="form_q_nsc" id="form_q_nsc" value="#request.qry_industries.strIndName#" onClick="checkUncheckAll('industry'); updateRegistrationStep(#session.exec.intresid#, 2, 14, this);" type="checkbox" <cfif listfind(sa_form_q_nsc, request.qry_industries.strIndName)>checked="checked"</cfif> >
											<label class="checkbox inline" for="">#request.qry_industries.strIndName#</label>
										</div>
									</cfloop>
								</div>
								<div class="page-spacer"></div>
								<div><h5>Functions</h5></div>
								<cfset request.qry_functions = application.functionManager.getFunctions() />
								<div style="height: 175px; width:335px; overflow:auto; border: 1px solid ##CCCCCC; padding:5px 5px 5px 5px; background: ##ffffff;">
									<div class="item">
									<input name="allFunctions" type="checkbox" value="allFunctions" class="exclude"  id="allFunctions"  onclick="checkDefault('function');"  <cfif listfind(sa_form_q_nsf, "&quot;All Functions&quot;") or sa_form_q_nsf is "">checked="checked"</cfif>    />
									<label class="checkbox inline" for="">All Functions</label></div>
									<cfloop query="request.qry_functions">
										<div class="item">
											<input name="form_q_nsf" id="form_q_nsf" value="#request.qry_functions.strFunctionName#"  onclick="checkUncheckAll('function');" type="checkbox" <cfif listfind(sa_form_q_nsf, request.qry_functions.strFunctionName)>checked="checked"</cfif> >
											<label class="checkbox inline" for="intsFuncIDs#request.qry_functions.intOldFunctionID#">#request.qry_functions.strFunctionName#</label>
										</div>
									</cfloop>
								</div>
								
								<div class="page-spacer"></div>
								<div><h5>Locations</h5></div>
								<cfset request.qry_locations_us = application.alertsManager.getLocations(country="US") />
								<cfset request.qry_locations_ca = application.alertsManager.getLocations(country="CA") />
								<cfset request.qry_locations_int = application.alertsManager.getLocations(country="INT") />
								<div style="height: 175px; width:335px; overflow:auto; border: 1px solid ##CCCCCC; padding:5px 5px 5px 5px; background: ##ffffff;">
									<div class="item"><input name="allState" type="checkbox" value="allState" class="exclude"  id="allState" onclick="checkDefault('state');" <cfif listfind(sa_form_q_nst, request.qry_locations_us.strName) or sa_form_q_nst is "">checked="checked"</cfif>  />
								<label class="checkbox inline" for="">All States</label></div>
									<div>United States</div>
									<cfloop query="request.qry_locations_us">
										<div class="item">
											<input name="form_q_nst" id="form_q_nst"  type="checkbox" value="#request.qry_locations_us.strName#"  onclick="checkUncheckAll('state');" <cfif listfind(sa_form_q_nst, request.qry_locations_us.strName)>checked="checked"</cfif> >
											<label class="checkbox inline" for="">#request.qry_locations_us.strName#</label>
										</div>
									</cfloop>
									<div>Canada</div>
									<cfloop query="request.qry_locations_ca">
										<div class="item">
											<input name="form_q_nst" id="form_q_nst" value="#request.qry_locations_ca.strName#"  onclick="checkUncheckAll('state');" type="checkbox" <cfif listfind(sa_form_q_nst, request.qry_locations_ca.strName)>checked="checked"</cfif> >
											<label class="checkbox inline" for="">#request.qry_locations_ca.strName#</label>
										</div>
									</cfloop>
									<div>International</div>
									<cfloop query="request.qry_locations_int">
										<div class="item">
											<input name="form_q_nst" id="form_q_nst" value="#request.qry_locations_int.strName#"  onclick="checkUncheckAll('state');" type="checkbox" <cfif listfind(sa_form_q_nst, request.qry_locations_int.strName)>checked="checked"</cfif> >
											<label class="checkbox inline" for="">#request.qry_locations_int.strName#</label>
										</div>
									</cfloop>
								</div>
								
								<div class="page-spacer"></div>
								<div><h5>Salary</h5></div>
								<cfset request.qry_salaries = application.alertsManager.getSalaries() />
								<div style="height: 175px; width:335px; overflow:auto; border: 1px solid ##CCCCCC; padding:5px 5px 5px 5px; background: ##ffffff;">
									<div class="item">
										<input name="allSalaries" type="checkbox" value="allSalaries" class="exclude"  id="allSalaries" onclick="checkDefault('salary');" <cfif sa_form_q_fsd eq "">checked="checked"</cfif>  />
										<label class="checkbox inline" for="">All Salaries</label></div>
									<cfloop query="request.qry_salaries">
										<div class="item">
											<input name="form_q_fsd" id="form_q_fsd" value="#request.qry_salaries.salaryDesc#" onclick="checkUncheckAll('salary');" type="checkbox" <cfif listfind(sa_form_q_fsd, request.qry_salaries.salaryDesc)>checked="checked"</cfif> >
											<label class="checkbox inline" for="">$#request.qry_salaries.salaryDesc#K+</label>
										</div>
									</cfloop>
								</div>
								
								<br class="clearthis" />
							</div>
						</div>
						<div class="page-spacer"></div>
					<div>
						<input type="hidden" name="SubmitAction" value="" />
						<a href="##" id="SaveSearchAlertbutton" style="margin-right:20px;" onclick="document.Agent.SubmitAction.value='Save Search Alert'; document.Agent.submit();"><input class="btn btn-primary" type="button" name="validate" id="submitBtn" value="&nbsp;Save Alert&nbsp;"></a>
						<cfif strMode eq "edit">
						<!--- <input name="SubmitAction" class="exec_submit" type="Submit" value="Delete Search Alert"> --->
						<a href="##" id="DeleteSearchAlertbutton" style="msrgin-left:20px;" onclick="document.Agent.SubmitAction.value='Delete Search Alert'; document.Agent.submit();"><input class="btn btn-primary" type="button" name="validate" id="submitBtn" value="&nbsp;Delete Alert&nbsp;"></a>
						</cfif>
					</div>
					</div>
					
					
					
					
					
				</div>
			</div>


</cfoutput>
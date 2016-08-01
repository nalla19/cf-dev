<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7 ng-app:sfj" lang="en" id="ng-app"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8 ng-app:sfj" lang="en" id="ng-app"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en" ng-app="sfj"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en" ng-app="sfj"> <!--<![endif]-->
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="description" content="6FJ Candidate Job Search App">
<meta name="viewport" content="width=device-width">

<title>Candidate Search</title>

<!-- Place favicon.ico and apple-touch-icon.png in the root directory -->
<link rel="stylesheet" href="/recruitment/search/css/bootstrap.css">
<link rel="stylesheet" href="/recruitment/search/css/normalize.css">
<link rel="stylesheet" href="/recruitment/search/css/main.css">
<link rel="stylesheet" href="/recruitment/search/css/bootstrap-responsive.min.css">

<link rel="stylesheet" href="/recruitment/search/css/site.css">
<link rel="stylesheet" href="/recruitment/search/css/jquery-ui-1.8.24.custom.css">

<script src="/recruitment/search/js/vendor/modernizr-2.6.1.min.js"></script>
<script src="/recruitment/search/js/vendor/jquery.min.js"></script>
<script src="/recruitment/search/js/vendor/jquery-ui.min.js"></script>
<script src="/recruitment/search/js/vendor/angular.min.js"></script>
<script src="/recruitment/search/js/vendor/angular-resource-1.0.1.min.js"></script>

<!-- Load scripts -->
<script src="/recruitment/search/js/plugins.js"></script>
<script src="/recruitment/search/js/vendor/bootstrap.min.js"></script>
<script src="/recruitment/search/js/vendor/json2.js"></script>
<script src="/recruitment/search/js/vendor/underscore.min.js"></script>
<script src="/recruitment/search/js/vendor/bootstrap-popover.js"></script>
<script src="/recruitment/search/js/vendor/angular-cookies-1.0.0rc10.js"></script>
  

<!-- Application scripts -->
<script src="/recruitment/search/js/app.js"></script>
<script src="/recruitment/search/js/services.js"></script>
<script src="/recruitment/search/js/directives.js"></script>
<script src="/recruitment/search/js/controllers.js"></script>


<!--[if IE]>
<link href="/join/assets/js/bubbletip/bubbletip-IE.css" rel="stylesheet" type="text/css" />
<![endif]-->

<!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
<!--[if IE]>
<script src="/recruitment/search/js/vendor/html5.js"></script>
<script src="/recruitment/search/js/vendor/jquery.placeholder.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $('.form-inline input').placeholder();
    });
</script>
<![endif]-->

</head>
<body lang="en" ng-controller="SearchCtrl">

<cfif not isDefined("session.er.intEmployerID") or ( isDefined("session.er.intEmployerID") and session.er.intEmployerID is "")>
	<cflocation url="/recruitment/" addtoken="no">
</cfif>

<!---Redirect the user to the old search page, indicating that the feature is not available--->
<cfif isDefined("session.er.blnSearch") and session.er.blnsearch is 0>
	<cflocation url="/EmpRecSearchExecs.cfm" addtoken="no">
</cfif>


<!--[if lt IE 7]>
<p class="chromeframe">You are using an outdated browser. <a href="http://browsehappy.com/">Upgrade your browser today</a> or <a href="http://www.google.com/chromeframe/?redirect=true">install Google Chrome Frame</a> to better experience this site.</p>
<![endif]-->
<cfinclude template="/6fj/_includes/templates/headers/recruitment_private_header.cfm">


<!---Redirect the user to an expired account page--->
<cfif isDefined("er_account_status") and er_account_status neq 5>
	<cfinclude template="t_EmpRecPagePasswordText.cfm">
</cfif>

<!---Uncomment if a maintenance page for just the search needs to be put up --->
<!--- <cfinclude template="maintenancePage.cfm"> --->


<div class="container-fluid">
	<div class="row-fluid">
	    <div ng-show="isHomePage()" class="span3 sfj-init-title" style="padding-bottom:8px;">Search Top Talent</div>
		<div ng-hide="isHomePage()" class="span3 sfj-result-count" style="padding-bottom:8px;" ng-switch on="results.response.numFound">
		    <div ng-switch-when="0" style="padding-bottom:4px;">Sorry, we found no matches. <span style="padding-left:6px;"><a href="/recruitment/search" class="sfj-reset btn btn-small" style="font-weight:normal;" type="button"><i class="icon-refresh"></i> Start New Search</a></span></div>
            <div ng-switch-default style="padding-bottom:4px;">We found {{results.response.numFound}} matches! <span style="padding-left:6px;"><a href="/recruitment/search" class="sfj-reset btn btn-small" style="font-weight:normal;" type="button"><i class="icon-refresh"></i> Start New Search</a></span></div>
		</div>
        <div>
            <form class="form-inline" ng-submit="search()">
                <div class="sfj-help sfj-font-medium" style="margin-bottom: 6px;">You can define your search across any/all fields.  Hit ENTER key or click search icon to run.&nbsp;<span class="tip">TIP:</span>&nbsp;Use a comma when searching for multiple items.</div>
                <div class="controls">
                    <div class="input-append span3">
                        <input class="span11" type="text" placeholder="Search for Job Title" facet-model="qryJobTitles" facet-cat="Job Titles" facet-suggest="/rest/candidates/suggest">
                        <span class="btn" ng-click="search()"><i class="icon-search"></i></span>
                    </div>
                    <div class="input-append span3">
                        <input class="span11" type="text" placeholder="Search for Company" facet-model="qryCompanies" facet-cat="Companies" facet-suggest="/rest/candidates/suggest">
                        <span class="btn" ng-click="search()"><i class="icon-search"></i></span>
                    </div>
                    <div class="input-append span3">
                        <input class="span11" type="text" placeholder="Search for Keyword" facet-model="qryKeywords" facet-cat="Skills" facet-suggest="/rest/candidates/suggest">
                        <span class="btn" ng-click="search()"><i class="icon-search"></i></span>
                    </div>
                </div>
			</form>
		</div>
	</div>
        
	<div class="row-fluid" ng-show="hasQueryTerms()">
		<div class="row-fluid" style="margin-bottom:5px;margin-left:15px;">
			<i class="icon-search"></i>&nbsp;<span class="sfj-font-small">Active search terms:</span>
        </div>
        
		<div class="row-fluid selected-terms">
			<ul style="margin:0 1px">
				<li class="term green" ng-show="terms.titles.length" ng-repeat="term in terms.titles">
				    Job Title: {{term}}
				    &nbsp;<i class="icon-remove-sign" style="cursor:pointer" ng-click="removeTerm(qryJobTitles, term)"></i>
                </li>
            </ul>
        </div>
        <div class="row-fluid selected-terms">
            <ul style="margin:0 1px">
                <li class="term blue" ng-show="terms.companies.length" ng-repeat="term in terms.companies">
				    Company: {{term}}
				    &nbsp;<i class="icon-remove-sign" style="cursor:pointer" ng-click="removeTerm(qryCompanies, term)"></i>
                </li>
            </ul>
        </div>
        <div class="row-fluid selected-terms">
            <ul style="margin:0 1px">
                <li class="term" ng-show="terms.keywords.length" ng-repeat="term in terms.keywords">
				    Keyword: {{term}}
				    &nbsp;<i class="icon-remove-sign" style="cursor:pointer" ng-click="removeTerm(qryKeywords, term)"></i>
                </li>
			</ul>
        </div>
    </div>
		
    <br>
	
    <div class="row-fluid" style="margin-bottom:5px;margin-left:15px;" ng-show="breadCrumbs.length">
		<i class="icon-filter"></i>&nbsp;<span class="sfj-font-small">Active search filters:</span>
    </div>
    
    <div class="row-fluid" style="margin-bottom:15px;margin-left:35px;font-size:13px;">
		<span ng-repeat="crumb in breadCrumbs">
        {{crumb.field}} is {{crumb.value}} <i class="icon-remove-sign" style="cursor:pointer" ng-click="filterSearch(crumb.field, crumb.value)"></i>&nbsp;&nbsp;&nbsp;&nbsp;
        </span>
    </div>
        
	<div class="row-fluid">
    	
		<div class="span3">
			<div ng-show="isHomePage()" class="sidebar-nav sfj-facet-sidebar" style="height:350px;">
            	<div>
	              	<h4><strong>Saved Searches</strong></h4>
					<div ng-repeat="search in savedSearches">
						<a ng-click="fetchSavedSearch(search.pk_agentid)" ng-show="search.solrSrchString">{{search.strTitle}}</a>
					</div>
				</div>
			</div>

            <div ng-hide="isHomePage()" class="sidebar-nav sfj-facet-sidebar">
                <ul class="nav nav-list">
					<li class="nav-header">Results Per Page</li>
                    <li>
                        <span class="sfj-font-small">
                            <select class="span3 sfj-font-medium" ng-model="recordsperpage" ng-change="updateRecordsPerPage()">
                                <option value="10">10</option>
                                <option value="20">20</option>
                                <option value="30">30</option>
                                <option value="40">40</option>
								<option value="50">50</option>
                            </select>
                        </span>
                    </li>
				
                    <li class="nav-header">City Search</li>
                    <li>
                        <div class="span12">
                        <input class="span11" size="14" type="text" ng-model="locationText" placeholder="City Name" suggest="/rest/candidates/locations" select="geoFilter">
                        </div>
                        <span class="sfj-font-small">within &nbsp;
                            <select class="span4 sfj-font-medium" ng-model="geoLocation.radius" ng-change="geoFilter()">
                                <option value="100">100 miles</option>
                                <option value="75">75 miles</option>
                                <option value="50">50 miles</option>
                                <option value="35">35 miles</option>
                            </select>
                        </span>
                    </li>

                    <li class="nav-header" ng-show="results.facet_counts.facet_fields.country.length">Country</li>
                    <li ng-repeat="country in results.facet_counts.facet_fields.country" ng-show="$index % 2 == 0">
                        <label class="checkbox sfj-font-medium" ng-hide="$index >= maxCountries">
                            <input type="checkbox" ng-checked="isApplied('country', country)" ng-click="filterSearch('country', country)"> {{country}} <span class="counts muted">({{results.facet_counts.facet_fields.country[$index+1]}})</span>
                        </label>
                    </li>
                    <a class="sfj-more-link" ng-click="toggleFacetCount('maxCountries')" ng-show="results.facet_counts.facet_fields.country.length > 5">{{facetText('maxCountries')}}</a>

                    <li class="nav-header" ng-show="results.facet_counts.facet_fields.state.length">State</li>
                    <li ng-repeat="state in results.facet_counts.facet_fields.state" ng-show="$index % 2 == 0">
                        <label class="checkbox sfj-font-medium" ng-hide="$index >= maxStates">
                            <input type="checkbox" ng-checked="isApplied('state', state)" ng-click="filterSearch('state', state)"> {{state}} <span class="counts muted">({{results.facet_counts.facet_fields.state[$index+1]}})</span>
                        </label>
                    </li>
                    <a class="sfj-more-link" ng-click="toggleFacetCount('maxStates')" ng-show="results.facet_counts.facet_fields.state.length > 5">{{facetText('maxStates')}}</a>

                    <li class="nav-header" ng-show="results.facet_counts.facet_fields.primarysalestype.length">Sales Type</li>
                    <a href="##sellingStyle" data-toggle="modal" ng-show="results.facet_counts.facet_fields.primarysalestype.length" style="font-size:12px;">What is this?</a>
                    <li ng-repeat="salestype in results.facet_counts.facet_fields.primarysalestype" ng-show="$index % 2 == 0">
                    	
                        <label class="checkbox sfj-font-medium" ng-hide="$index >= maxSalesType">
                            <input type="checkbox" ng-checked="isApplied('primarysalestype', salestype)" ng-click="filterSearch('primarysalestype', salestype)"> {{salestype}} <span class="counts muted">({{results.facet_counts.facet_fields.primarysalestype[$index+1]}})</span>
                        </label>
                    </li>
                    <a class="sfj-more-link" ng-click="toggleFacetCount('maxSalesType')" ng-show="results.facet_counts.facet_fields.primarysalestype.length > 5">{{facetText('maxSalesType')}}</a>
                    
                    <li class="nav-header" ng-show="results.facet_counts.facet_fields.company.length">Company</li>
                    <li ng-repeat="org in results.facet_counts.facet_fields.company" ng-show="$index % 2 == 0">
                        <label class="checkbox sfj-font-medium" ng-hide="$index >= maxCompanies">
                            <input type="checkbox" ng-checked="isApplied('company', org)" ng-click="filterSearch('company', org)"> {{org}} <span class="counts muted">({{results.facet_counts.facet_fields.company[$index+1]}})</span>
                        </label>
                    </li>
                    <a class="sfj-more-link" ng-click="toggleFacetCount('maxCompanies')" ng-show="results.facet_counts.facet_fields.company.length > 5">{{facetText('maxCompanies')}}</a>

                    <li class="nav-header" ng-show="results.facet_counts.facet_fields.education.length">Education (Type)</li>
                        <li ng-repeat="type in results.facet_counts.facet_fields.education">
                        <label class="checkbox sfj-font-medium" ng-show="$index % 2 == 0">
                        <input type="checkbox" ng-checked="isApplied('education', type)" ng-click="filterSearch('education', type)"> {{type}} <span class="counts muted">({{results.facet_counts.facet_fields.education[$index+1]}})</span>
                        </label>
                    </li>

                    <li class="nav-header" ng-show="results.facet_counts.facet_fields.school.length">Education (Schools)</li>
                        <li ng-repeat="school in results.facet_counts.facet_fields.school" ng-show="$index % 2 == 0">
                        <label class="checkbox sfj-font-medium" ng-hide="$index >= maxSchools">
                        <input type="checkbox" ng-checked="isApplied('school', school)" ng-click="filterSearch('school', school)"> {{school}} <span class="counts muted">({{results.facet_counts.facet_fields.school[$index+1]}})</span>
                        </label>
                    </li>
            
                    <a class="sfj-more-link" ng-click="toggleFacetCount('maxSchools')" ng-show="results.facet_counts.facet_fields.school.length > 5">{{facetText('maxSchools')}}</a>
                    <li class="nav-header" ng-show="results.facet_counts.facet_fields.degree.length">Education (Degrees)</li>
                    <li ng-repeat="degree in results.facet_counts.facet_fields.degree">
                    <label class="checkbox sfj-font-medium" ng-show="$index % 2 == 0">
                        <input type="checkbox" ng-checked="isApplied('degree', degree)" ng-click="filterSearch('degree', degree)"> {{degree}} <span class="counts muted">({{results.facet_counts.facet_fields.degree[$index+1]}})</span>
                    </label>
                	</li>
					
					<cfif application.applicationName NEQ "SalesStars">
                	<li class="nav-header">Salary Range</li>
                    <div style="width:60%" range-slider="salaryFilter" min="70" max="500" step="5" start="100"></div>
                    <span class="range">${{minSalary}}K - ${{maxSalary}}K</span><span ng-show="maxSalary >= 500">+</span>
                    </cfif>

                    <li class="nav-header" ng-show="results.facet_counts.facet_fields.industry.length">Industry</li>
                    <li ng-repeat="industry in results.facet_counts.facet_fields.industry" ng-show="$index % 2 == 0">
                        <label class="checkbox sfj-font-medium" ng-hide="$index >= maxIndustries">
                        <input type="checkbox" ng-checked="isApplied('industry', industry)" ng-click="filterSearch('industry', industry)"> {{industry}} <span class="counts muted">({{results.facet_counts.facet_fields.industry[$index+1]}})</span>
                        </label>
                    </li>
                    <a class="sfj-more-link" ng-click="toggleFacetCount('maxIndustries')" ng-show="results.facet_counts.facet_fields.industry.length > 5">{{facetText('maxIndustries')}}</a>

                    <cfif application.applicationName NEQ "SalesStars">
                    <li class="nav-header" ng-show="results.facet_counts.facet_fields.function">Function</li>
                    <li ng-repeat="func in results.facet_counts.facet_fields.function" ng-show="$index % 2 == 0">
                        <label class="checkbox sfj-font-medium" ng-hide="$index >= maxFunctions">
                        <input type="checkbox" ng-checked="isApplied('function', func)" ng-click="filterSearch('function', func)"> {{func}} <span class="counts muted">({{results.facet_counts.facet_fields.function[$index+1]}})</span>
                        </label>
                    </li>
                    <a class="sfj-more-link" ng-click="toggleFacetCount('maxFunctions')" ng-show="results.facet_counts.facet_fields.function.length > 5">{{facetText('maxFunctions')}}</a>
                    </cfif>
                    
                    <li class="nav-header">Freshness by Date</li>
                    <li>
                        <div class="span12">
                            <select class="span11 sfj-font-medium" ng-model="freshness" ng-change="updateFreshness()">
                                <option value="UNDEFINED">Any time</option>
                                <option value="Last 24 Hours">Last 24 hours</option>
                                <option value="Last 2 Days">Last 2 days</option>
                                <option value="Last 7 Days">Last 7 days</option>
                                <option value="Last 14 Days">Last 14 days</option>
                                <option value="Last 30 Days">Last 30 days</option>
                                <option value="Last 60 Days">Last 60 days</option>
                                <option value="Last 90 Days">Last 90 days</option>
                                <option value="Last 120 Days">Last 120 days</option>
                                <option value="Last 365 Days">Last 365 days</option>
                            </select>
                            <br><br>
                        </div>
                    </li>

                    <li class="nav-header">Relocation Preference</li>
                    <li>
                        <label class="checkbox">
                            <input type="checkbox" ng-model="relocate" ng-click="updateRelocateStatus()">
                             <span class="sfj-font-small">Only show professionals who are willing to relocate.</span>
                        </label>
                    </li>

                    <li class="nav-header">Military/Veteran</li>
                    <li>
                        <label class="checkbox">
                            <input type="checkbox" ng-model="veteran" ng-click="updateVeteranStatus()">
                            <span class="sfj-font-small">Only show professionals who have served in the U.S. Armed Forces.</span>
                        </label>
                    </li>
				</ul>
			</div>
      	</div>
		
        
        <div class="span9">
        	<div class="row-fluid">
            	<div class="span11" ng-view></div>
           	</div>
       	</div>
  	</div>


	<hr>
  	<div class="push"><!--//--></div>   
  	<div class="push"><!--//--></div>   
   	<div class="push"><!--//--></div>   
</div><!--/.fluid-container-->
  
<!--- FOOTER BEGIN --->
<cfinclude template = "/6fj/_includes/templates/footers/footer.cfm">
<!--- FOOTER END --->


<!-- Google Analytics: change UA-XXXXX-X to be your site's ID. -->
<script>
var _gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview']];
(function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
s.parentNode.insertBefore(g,s)}(document,'script'));
</script>


<!--- List View Modal Begin --->
<div class="modal hide fade" id="sellingStyle" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="width:750px; padding-left:10px;">
	<div class="modal-header">
    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
        <h4 id="myModalLabel" style="font-size: 25px;">SELLING STYLE</h4>
    </div>

    <div class="modal-body" style="max-height:600px;">
		<div class="entry-content" style="width:700px;">
        	<div style="font-size: 20px; line-height: 30px;">18 SELLING STYLE CHART<br>PRIMARY V. SECONDARY SALES TYPES</div>
            <br/>
            <div style="width:700px;">
                <table width="100%" border="1" cellspacing="1" cellpadding="10" class="pricingTable">
                    <tbody>
                    <tr valign="top">
                    <td style="background-color: #eeeeee;"></td>
                    <td style="background-color: #eeeeee;"><strong>SELLING STYLE</strong></td>
                    <td style="background-color: #eeeeee;" align="center"><strong>PRIMARY</strong></td>
                    <td style="background-color: #eeeeee;" align="center"><strong>SECONDARY</strong></td>
                    </tr>
                    <tr valign="top">
                    <td>1</td>
                    <td class="row"><b>RELATIONSHIP OR CONSULTATIVE</b><br/>Generally considered one of the more acceptable and successful types, adjusts well to most selling situations</td>
                    <td align="center">FARMER</td>
                    <td align="center">NONE</td>
                    </tr>
                    <tr valign="top">
                    <td>2</td>
                    <td class="row"><b>VERSATILE, RELATIONSHIP OR CONSULTATIVE</b><br/>Exhibits the ability to adjust between the Relationship or Consultative style (1) and Proactive selling style (3), with a preference for the Relationship or Consultative style</td>
                    <td align="center">FARMER</td>
                    <td align="center">HUNTER</td>
                    </tr>
                    <tr valign="top">
                    <td>3</td>
                    <td class="row"><b>PROACTIVE</b><br/> Most associated with entrepreneurs and others who exhibit strong drive, often quite competitive. The best will be able to adjust between this style and the Relationship/Consultative styles</td>
                    <td align="center">HUNTER</td>
                    <td align="center">NONE</td>
                    </tr>
                    <tr valign="top">
                    <td>4</td>
                    <td class="row"><b>VERSATILE PROACTIVE</b><br/>  Exhibits the ability to adjust between the Proactive Style (3) and the Relationship/Consulatative selling style (1) with a preference for the Proactive style</td>
                    <td align="center">HUNTER</td>
                    <td align="center">NONE</td>
                    </tr>
                    <tr valign="top">
                    <td>5</td>
                    <td class="row"><b>VERY PROACTIVE</b><br/> Strong competitive drive that is tempered by an outgoing personality</td>
                    <td align="center">HUNTER</td>
                    <td align="center">NONE</td>
                    </tr>
                    <tr valign="top">
                    <td>6</td>
                    <td class="row"><b>HIGHLY PROACTIVE</b><br/> Strong competitive drive that is tempered by an outgoing personality</td>
                    <td align="center">HUNTER</td>
                    <td align="center">NONE</td>
                    </tr>
                    <tr valign="top">
                    <td>7</td>
                    <td class="row"><b>CLOSING</b><br/>
                    More comfortable with the one-call sale than with developing long-term relationships. Often very competitive and work better on their own rather than with a team. Ideal for seeking out new business and pioneering new product/concept ideas</td>
                    <td align="center">LONE HUNTER</td>
                    <td align="center">HUNTER</td>
                    </tr>
                    <tr valign="top">
                    <td>8</td>
                    <td class="row"><b>AGGRESSIVE</b><br/>
                    Highly-focused, hard-driving selling style best suited for the one-call sale where, if the prospect walks, the sale is lost. Works better on their own than as part of a team</td> 
                    <td align="center">LONE HUNTER</td>
                    <td align="center">HUNTER</td>
                    </tr>
                    <tr valign="top">
                    <td>9</td>
                    <td class="row"><b>PASSIVE RETAIL</b><br/>
                    Best suited for retail sales, inbound tele-marketing, customer support, inside sales, etc. where the salesperson takes a minimal or passive role in the buying/selling decision
                    </td>
                    <td align="center">SHOPKEEPER</td>
                    <td align="center">REPAIRMAN</td>
                    </tr>
                    <tr valign="top">
                    <td>10</td>
                    <td class="row"><b>PROACTIVE RETAIL</b><br/>
                    Best suited for retail sales, inbound tele-marketing, customer support, inside sales, etc. where the salesperson takes an active role in the buying/selling decision
                    </td>
                    <td align="center">SHOPKEEPER</td>
                    <td align="center">REPAIRMAN</td>
                    </tr>
                    <tr valign="top">
                    <td>11</td>
                    <td class="row"><b>RELAXED</b><br/>
                    Competitive but exhibits a somewhat laid-back approach to selling, most successful when working under competent sales management direction, usually prefer to handle sales with a short buying cycle
                    </td>
                    <td align="center">RELAXED HUNTER</td>
                    <td align="center">HUNTER</td>
                    </tr>
                    <tr valign="top">
                    <td>12</td>
                    <td class="row"><b>EASYGOING</b><br/>
                    Competitive but does not exhibit a sense of urgency, most successful when working under competent sales management direction, usually prefer to handle sales with a short buying cycle
                    </td>
                    <td align="center">EASY-GOING HUNTER</td>
                    <td align="center">HUNTER</td>
                    </tr>
                    <tr valign="top">
                    <td>13</td>
                    <td class="row"><b>SOCIAL</b><br/>
                    Generally very well-liked, best suited for maintaining existing business, need to be cautious about spending too much time socializing with clients.
                    </td>
                    <td align="center">SOCIAL FARMER</td>
                    <td align="center">FARMER</td>
                    </tr>
                    <tr valign="top">
                    <td>14</td>
                    <td class="row"><b>VERY SOCIAL</b><br/>
                    Generally very well-liked, best suited for maintaining existing business, likely to spend too much time socializing with clients
                    </td> 
                    <td align="center">SOCIAL FARMER</td>
                    <td align="center">FARMER</td>
                    </tr>
                    <tr valign="top">
                    <td>15</td>
                    <td class="row"><b>HIGHLY SOCIAL</b><br/>
                    Generally very well-liked, spend far too much time socializing with clients
                    </td>
                    <td align="center">SOCIAL SHOPKEEPER</td>
                    <td align="center">REPAIRMAN</td>
                    </tr>
                    <tr valign="top">
                    <td>16</td>
                    <td class="row"><b>EXTREMELY SOCIAL</b><br/>
                    Generally very well-liked but are highly-inclined to waste people’s time with excessive socializing
                    </td>
                    <td align="center">SOCIAL SHOPKEEPER</td>
                    <td align="center">REPAIRMAN</td>
                    </tr>
                    <tr valign="top">
                    <td>17</td>
                    <td class="row"><b>CONGENIAL</b><br/>
                    Generally very pleasant and well-liked but are not suited for sales because of their desire to be liked, have difficulty handling objections and closing sales
                    </td>
                    <td align="center">REPAIRMAN</td>
                    <td align="center">NONE</td>
                    </tr>
                    <tr valign="top">
                    <td>18</td>
                    <td class="row"><b>NON-SALES</b><br/>
                    Not well-suited for sales and only succeed through a great deal of personal drive and desire.
                    </td>
                    <td align="center">HANDYMAN</td>
                    <td align="center">NONE</td>
                    </tr>
                </table>
            </div>
            <div style="margin-top: 20px; margin-bottom: 30px;"></div>
        </div>
	</div>
</div>
<!--- List View Modal End --->


<!--- List View Modal Begin --->
<div class="modal hide fade" id="monthlyCap" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="width:750px; padding-left:10px;">
	<div class="modal-header">
    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
        <h4 id="myModalLabel" style="font-size: 25px;">Monthly Limit Reached</h4>
    </div>

    <div class="modal-body" style="max-height:600px;">
		<div class="entry-content" style="width:700px;">
            <div style="width:700px;">                
				It looks like you have reached your Monthly Limit of Detail Views (3000 detail views).
				<div style="margin-top: 10px; margin-bottom: 10px;"></div>
				Please log back in tomorrow  or contact your account manager to learn about gaining unlimited search access with an Annual membership.
				<div style="margin-top: 10px; margin-bottom: 10px;"></div>	
            </div>
            <div style="margin-top: 20px; margin-bottom: 30px;"></div>
        </div>
	</div>
</div>
<!--- List View Modal End --->

<!--- List View Modal Begin --->
<div class="modal hide fade" id="dailyCap" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="width:750px; padding-left:10px;">
	<div class="modal-header">
    	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
        <h4 id="myModalLabel" style="font-size: 20px;">Daily Limit Reached</h4>
    </div>

    <div class="modal-body" style="max-height:600px;">
		<div class="entry-content" style="width:700px;">
            <div style="width:700px;">
            It looks like you have reached your Daily Limit of Detail Views (100 detail views). 
			<div style="margin-top: 10px; margin-bottom: 10px;"></div>
			Please log back in tomorrow  or contact your account manager to learn about gaining unlimited search access with an Annual membership.
			<div style="margin-top: 10px; margin-bottom: 10px;"></div>
			</div>
        </div>
	</div>
</div>
<!--- List View Modal End --->

</body>
</html>
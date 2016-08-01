"use strict";

angular.module('sfj.controllers', [])
    .controller('UserDetailsCtrl', function($scope, $location, $cookies, $routeParams, UserDetailsService,WebsiteProfilesService, EducationService) {
        
        $scope.intEmployerID = "";
        $scope.intERPwdID = "";
        for (var p in $cookies) {
            if (p == 'ER.INTEMPLOYERID')
                $scope.intEmployerID = $cookies[p];
            
            if (p == 'ER.INTERPWDID')
                $scope.intERPwdID = $cookies[p];
        }        
        $scope.user = $scope.results.response.docs[$routeParams.idx];
        $scope.user.docID = $routeParams.idx;

        $scope.user.details = UserDetailsService.details.get({
            //id:$scope.user.intresid
            id:$scope.user.intresid, intEmployerID:$scope.intEmployerID, intERPasswdID:$scope.intERPwdID
        });


        var educationResults = [];
        $scope.getEducation = function() {
            educationResults = EducationService.education.fetch({
                intResID: $scope.user.intresid
                }, {}, function() {
                    $scope.education = educationResults;
                }
            )
        };

        var websiteProfileResults = [];
        $scope.getWebsiteProfiles = function() {
            websiteProfileResults = WebsiteProfilesService.profiles.fetch({
                intResID: $scope.user.intresid
                }, {}, function() {
                    $scope.websiteProfiles = websiteProfileResults;
                }
            )
        };
            
        var locPath = "/details/" + $routeParams.idx;
        if ($location.path() === locPath) {
            $scope.getWebsiteProfiles();
            $scope.getEducation();
        }
    })

    .controller('SearchCtrl', function($scope, $location, $cookies, solr, SavedSearchService,SavedSearchesService, updateListViewsService, updateERListViewsService,DetailViewsService) {
        //console.log(location.host);
        
        $scope.intEmployerID = "";
        $scope.intERPwdID = "";
        $scope.searchAgent = "";
        $scope.savedConfirmation = "";
        $scope.savedSearches = "";

        for (var p in $cookies) {
            if (p == 'ER.INTEMPLOYERID')
                $scope.intEmployerID = $cookies[p];

            if (p == 'ER.INTERPWDID')
                $scope.intERPwdID = $cookies[p];
				
			if (p == 'ER.APPLICATIONNAME')
				$scope.applicationname = $cookies[p];
        }
		
		//for (var p in $cookies) {
		//	console.log(p)
		//	console.log($cookies[p])
		//}
		
        var SolrQuery = solr.Query();
        var resultPager = solr.ResultPager(SolrQuery, 0);
        var pageMin = 5;
        var pageMax = 7;
        var lastViewed = -1;
        var salaryFilter = "";
        var loadedSearch = "";
        var savedSearchResults = [];
		var detailviewResults = [];
		
        var dateRange = {
            "Last 24 Hours":"[NOW/HOUR-24HOURS TO NOW/HOUR+1HOUR]",
            "Last 2 Days":  "[NOW/DAY-2DAYS TO NOW/DAY+1DAY]",
            "Last 7 Days":  "[NOW/DAY-7DAYS TO NOW/DAY+1DAY]",
            "Last 14 Days": "[NOW/DAY-14DAYS TO NOW/DAY+1DAY]",
            "Last 30 Days": "[NOW/DAY-1MONTH TO NOW/DAY+1DAY]",
            "Last 60 Days": "[NOW/DAY-2MONTH TO NOW/DAY+1DAY]",
            "Last 90 Days": "[NOW/DAY-3MONTH TO NOW/DAY+1DAY]",
            "Last 120 Days":"[NOW/DAY-4MONTH TO NOW/DAY+1DAY]",
            "Last 365 Days":"[NOW/DAY-1YEAR TO NOW/DAY+1DAY]"
        };

        $scope.qryJobTitles = [];
        $scope.qryCompanies = [];
        $scope.qryKeywords = [];
        $scope.terms = {
            titles: [],
            companies: [],
            keywords: []
        };
        $scope.breadCrumbs = [];
        
		$scope.savedSearches = [];
		$scope.detailviews = [];
		
        $scope.relocate = false;
        $scope.veteran = false;
        $scope.minSalary = 100;
        $scope.maxSalary = 500;
        
        $scope.maxCountries = 10;
        $scope.maxStates = 10;
        $scope.maxCompanies = 10;
        $scope.maxSchools = 10;
        $scope.maxIndustries = 10;
        $scope.maxFunctions = 10;
        
        $scope.freshness = "UNDEFINED";
		
		$scope.recordsperpage = "10";
		
        $scope.geoLocation = {
            lat:0.0,
            lon:0.0,
            radius:100
        };
			
        SolrQuery.addFacet(solr.Facet('education').min(1).limit(10))
            .addFacet(solr.Facet('school').min(1).limit(10))
            .addFacet(solr.Facet('degree').min(1).limit(5))
            .addFacet(solr.Facet('industry').min(1).limit(10))
            .addFacet(solr.Facet('function').min(1).limit(10))
            .addFacet(solr.Facet('state').min(1).limit(50).tag('st'))
            .addFacet(solr.Facet('country').min(1).limit(40))
            .addFacet(solr.Facet('company').min(1).limit(10)
        );
        
        $scope.setLastViewed = function(intresid) {
          lastViewed = intresid;
        };
        
        $scope.lastViewedStyle = function(intresid) {
          var styles = {};
          if (intresid === lastViewed) {
            styles['background-color'] = '#FBEDF8';
          }
          
          return styles;
        };
        
        // updates the terms object with all the query terms in the search
        // box.  This triggers the breadcrumbs to be updated.
        var populateTerms = function () {
            $scope.terms.titles = $scope.qryJobTitles;
            $scope.terms.companies = $scope.qryCompanies;
            $scope.terms.keywords = $scope.qryKeywords;
        };
        
        var removeBreadCrumb = function(fieldName, filterValue) {
            fieldName = fieldName.charAt(0).toUpperCase() + fieldName.slice(1);
            for (var i = 0; i < $scope.breadCrumbs.length; i++) {
                if ($scope.breadCrumbs[i].field === fieldName &&
                    $scope.breadCrumbs[i].value === filterValue)
                {
                    $scope.breadCrumbs.splice(i, 1);
                    break;
                }
            }
        };

        var addBreadCrumb = function(fieldName, filterValue) {
            fieldName = fieldName.charAt(0).toUpperCase() + fieldName.slice(1);
            $scope.breadCrumbs.push({field:fieldName, value:filterValue});
        };

        //var intresid = "";
        var postProcess = function(results) {
            resultPager = solr.ResultPager(SolrQuery, results.response.numFound);
            var intresid="";
            for (var i = 0 ; i < results.response.docs.length; i++){
                //perform the db operation
                if (i < results.response.docs.length - 1)
                    intresid += results.response.docs[i].intresid + ",";
                else
                    intresid += results.response.docs[i].intresid;
            }
            //console.log(intresid);
            updateListViewsService.update.save({id:intresid}, {});
            intresid="";
        };

        /** Start: Load Saved Search **/
        var loadSavedSearch = function() {
            $scope.breadCrumbs = loadedSearch.breadcrumbs;
            $scope.qryJobTitles = loadedSearch.qryJobTitles;
            $scope.qryCompanies = loadedSearch.qryCompanies;
            $scope.qryKeywords = loadedSearch.qryKeywords;
            $scope.relocate = loadedSearch.relocate;
            $scope.veteran = loadedSearch.veteran;
            $scope.minSalary = loadedSearch.minSalary;
            $scope.maxSalary = loadedSearch.maxSalary;
            $scope.freshness = loadedSearch.freshness;
            SolrQuery.set(loadedSearch.params);
            SolrQuery.setFilters(loadedSearch.filters);
            $scope.search();
        };
        
        //Get a saved search
        $scope.fetchSavedSearch = function(idx){
            loadedSearch = SavedSearchService.searches.fetch( {id:idx}, {}, loadSavedSearch);
        };
        /** End: Saved Search **/

        /** Start: Save a Search **/
        $scope.saveSearch = function() {
            if ($scope.searchAgent){
                SavedSearchService.searches.save({intEmployerID: $scope.intEmployerID, intERPwdID: $scope.intERPwdID, agentName:  $scope.searchAgent, sourceApp: $scope.applicationname},{
                    breadcrumbs: $scope.breadCrumbs,
                    qryJobTitles: $scope.qryJobTitles,
                    qryCompanies: $scope.qryCompanies,
                    qryKeywords: $scope.qryKeywords,
                    relocate: $scope.relocate,
                    veteran: $scope.veteran,
                    minSalary: $scope.minSalary,
                    maxSalary: $scope.maxSalary,
                    freshness: $scope.freshness,
                    filters: SolrQuery.getFilters(),
                    params: SolrQuery.getParams(),
                    query: SolrQuery.serialize()
                });

                $scope.searchAgent = "";
                document.getElementById("searchInputFields").style.display = "none";
                document.getElementById("saveConfirmMessage").style.display = "block";
            }
        };
        /** End: Save a Search **/  

        /** Start: Get all Saved Searches **/
        $scope.getSavedSearches = function() {
            savedSearchResults = SavedSearchesService.searches.fetch({
                intEmployerID: $scope.intEmployerID, 
                intERPwdID: $scope.intERPwdID,
				sourceApp: $scope.applicationname
                }, {}, function() {
                    $scope.savedSearches = savedSearchResults;
                }
            )
        };
        /** End: Get all Saved Searches **/
		
		//$scope.detailviews= DetailViewsService.detailviews.fetch({intERPwdID:$scope.intERPwdID});
		//$scope.detailviews = angular.fromJson(DetailViewsService.detailviews.fetch({intERPwdID:$scope.intERPwdID}));
		//console.log($scope.detailviews);
				
	
       /** Start: Get Detail Views **/
	   $scope.getDetailViews = function() {
       		detailviewResults = DetailViewsService.detailviews.fetch({
                intERPwdID: $scope.intERPwdID
                }, {}, function() {
                    $scope.detailviews = detailviewResults;
                }
            )
       };
	   /** End: Get Detail Views **/
	   		
        $scope.toggleFacetCount = function(facet) {
            $scope[facet] = $scope[facet] == 10 ? 100 : 10;
        };

        $scope.facetText = function(facet) {
            return $scope[facet] == 10 ? "Show More" : "Show Less";
        };

        $scope.isHomePage = function() {
            return $location.path() === "/";
        };
		
        $scope.hasQueryTerms = function () {
            return ($scope.terms.titles.length > 0 ||
                    $scope.terms.companies.length > 0 ||
                    $scope.terms.keywords.length > 0);
        };
        
        $scope.removeTerm = function(list, term) {
            var idx = _.indexOf(list, term);
            if (idx !== -1) {
                list.splice(idx, 1);
                $scope.search();
            }
        }

        $scope.removeFreshnessCrumb = function() {
            for (var i = 0; i < $scope.breadCrumbs.length; i++) {
                if ($scope.breadCrumbs[i].field === 'Freshness') {
                    $scope.breadCrumbs.splice(i, 1);
                    break;
                }
            }
        }

        $scope.updateFreshness = function() {
            if ($scope.freshness === "UNDEFINED") {
                $scope.removeFreshnessCrumb();
                SolrQuery.removeFilter('freshness');
            } else {
                $scope.removeFreshnessCrumb();
                addBreadCrumb('Freshness', $scope.freshness);
                SolrQuery.addFilter('freshness', "dteedited:" + dateRange[$scope.freshness]);
            }
            $scope.search();
        };
		
		$scope.updateRecordsPerPage = function() {
            $scope.search();
        };
		

        $scope.updateRelocateStatus = function() {
            if ($scope.relocate) {
                addBreadCrumb('Relocate', 'yes');
                SolrQuery.addFilter('relocate', "relocate:1");
            } else {
                removeBreadCrumb('Relocate', 'yes');
                SolrQuery.removeFilter('relocate');
            }
            $scope.search();
        };

        $scope.updateVeteranStatus = function() {
            if ($scope.veteran) {
                addBreadCrumb('Status', 'veteran');
                SolrQuery.addFilter('veteran', "isVeteran:true");
            } else {
                removeBreadCrumb('Status', 'veteran');
                SolrQuery.removeFilter('veteran');
            }
            $scope.search();
        };

        $scope.salaryFilter = function(start, end) {
            $scope.minSalary = start;
            $scope.maxSalary = end;
        };

        $scope.geoFilter = function(item) {
            //fq={!geofilt pt=26.719,-80.069 sfield=location d=5}
            if (item) {
                $scope.locationText = item.value;
                $scope.geoLocation.lat = item.lat;
                $scope.geoLocation.lon = item.lon;
            }

            if ($scope.geoLocation.lat !== 0.0 && $scope.geoLocation.lon !== 0) {
                SolrQuery.removeFilter('geosearch');
                SolrQuery.addFilter('geosearch', "{!geofilt pt=" +
                    $scope.geoLocation.lat +
                    "," +
                    $scope.geoLocation.lon +
                    " sfield=location d=" +
                    $scope.geoLocation.radius +
                    "}");
                $scope.search();
            }
        };
		
			
        $scope.isApplied = function(fieldName, filterValue) {
            return SolrQuery.hasFilter(fieldName + ":" + filterValue);
        };

        $scope.filterSearch = function(fieldName, filterValue) {
            if (fieldName === "Status") {
                $scope.veteran = false;
                $scope.updateVeteranStatus();
            } else if (fieldName === "Relocate") {
                $scope.relocate = false;
                $scope.updateRelocateStatus();
            } else if (fieldName === 'Freshness') {
                $scope.freshness = 'UNDEFINED';
                $scope.updateFreshness();
            } else {
                fieldName = fieldName.toLowerCase();
                var filterKey = fieldName + ":" + filterValue;
                var filterMod = fieldName + ':"' + filterValue + '"';

                if ($scope.isApplied(fieldName, filterValue)) {
                    removeBreadCrumb(fieldName, filterValue);
                    SolrQuery.removeFilter(filterKey);
                } else {
                    addBreadCrumb(fieldName, filterValue);
                    SolrQuery.addFilter(filterKey, filterMod);
                }
                $scope.search();
            }
        };

        $scope.search = function(pageNum) {
            //console.log('Searching Solr Index')
            //Update the List View / Search Count for the ER activity
            //console.log('Calling the updateERListViewsService' );
            updateERListViewsService.update.save({intEmployerID: $scope.intEmployerID, intERPwdID: $scope.intERPwdID}, {});
            
            populateTerms();
			
			//$scope.getDetailViews();
			$scope.getDetailViews();
			
			SolrQuery.start(pageNum || 0)
                .rows($scope.recordsperpage)

            var queryString = '';

            // handle searching job titles
            // phrase search across the three job title fields we have
            // give higher boost to two most recent jobs
            if ($scope.terms.titles.length > 0) {
                queryString += '+(';
                for (var i = 0, len = $scope.terms.titles.length; i < len; i++) {
                    var title = $scope.terms.titles[i];
                    queryString += '(strexecjobtitle1:("' + title + '")^3 '; // phrase
                    queryString += 'strexecjobtitle1:(' + title + ')^2.5 '; 
                    queryString += 'strexecjobtitle2:("' + title + '")^2.5 '; // phrase
                    queryString += 'strexecjobtitle2:(' + title + ')^2 ';
                    queryString += ')';
                    //queryString += 'title_text:("' + title + '"))';
                
                    if (i < len - 1) {
                        queryString += ' ';
                    }
                }
                queryString += ')';
            }
            
            // handle searching companies
            // phrase search across the three company fields we have
            // give higher boost to two most recent companies
            if ($scope.terms.companies.length > 0) {
                if (queryString !== "") {
                    queryString += " ";
                }
            
                queryString += '+(';
                for (var i = 0, len = $scope.terms.companies.length; i < len; i++) {
                    var company = $scope.terms.companies[i];
                    queryString += '(strexecjobcompany1:("' + company + '")^3 '; // phrase
                    queryString += 'strexecjobcompany1:(' + company + ')^2.5 ';
                    queryString += 'strexecjobcompany2:("' + company + '")^2.5 '; // phrase
                    queryString += 'strexecjobcompany2:(' + company + ')^2.0 ';
                    queryString += ')';
                    //queryString += 'company_text:("' + company + '"))';
                
                    if (i < len - 1) {
                        queryString += ' ';
                    }
                }
                queryString += ')';
            }
            
            
            // handle keyword searching
            // phrase search each keyword (will search across fields in qf param)
            if ($scope.terms.keywords.length > 0) {
                if (queryString !== "") {
                    queryString += " ";
                }
            
                var qf = 'fname^1.5 lname^1.5 strexecjobtitle1^3 strexecjobcompany1^3 strexecjobtitle2^2.5 strexecjobcompany2^2.5 strexecjobdescr1 strexecjobdescr2 title_text company_text degrees_text description resume school_text education_text';
                var pf = qf; // search for phrase in qf fields
                var mm = 0; 
                var qq = '+(';
                
                for (var i = 0, len = $scope.terms.keywords.length; i < len; i++) {
                    var keyword = $scope.terms.keywords[i];
                    qq += '(' + keyword.replace('"', '\\"') + ')';
             
                    if (i < len - 1) {
                        qq += ' ';
                    }
                }
                qq += ')';
                queryString += '+_query_:"{!edismax qf=\'' + qf + '\' pf=\'' + pf + '\' mm=0 v=\'' + qq + '\'}"';
            }

            salaryFilter = 'fltcompensationpackage:[' + $scope.minSalary +' TO '+ $scope.maxSalary +']';
            SolrQuery.addFilter('salary', salaryFilter);

            if ($scope.locationText === "") {
                SolrQuery.removeFilter('geosearch');
            }
			
			//console.log(location.host);
			if (location.host === 'dev.salesstars.com' || location.host === 'uat.salesstars.com' || location.host === 'www.salesstars.com'){
				SolrQuery.removeFilter('salary');
			}
			
            // use our query string or a "match all" on people having any value
            // in strexecjobtitle1 AND strexecjobtitle2
            if (queryString === '') {
                queryString = '+strexecjobtitle1:[* TO *] +strexecjobtitle2:[* TO *]';
            }
            
            // set the query and add freshness boosting based on dteedited
            SolrQuery.query('{!boost b=recip(ms(NOW/HOUR,dteedited),3.16e-11,1,1)}' + queryString)
            
			console.log(SolrQuery.serialize());
            $scope.results = solr.http.get(
                {},
                SolrQuery.serialize(),
                postProcess
            );

            if ($location.path() !== "/results") {
				$location.path("/results");
            }
        };

        /*
        var educationResults = [];
        $scope.getEducation = function() {
            educationResults = EducationService.education.fetch({
                intResID: $scope.user.intresid
                }, {}, function() {
                    $scope.education = educationResults;
                }
            )
        };
        */

        //Update the List View
        var solrSearchResults = [];
        function updateListViews() {
            solrSearchResults = function() {
                $scope.search(), solrSearchResults; 
            }
        }

        
        $scope.pager = {
            pageChange: function(pageNum) {
                $scope.search(resultPager.get(pageNum));
                //For Updating the List Views
                updateListViews();
            },
            next: function() {
                this.pageChange(resultPager.next());
            },
            prev: function() {
                this.pageChange(resultPager.previous());
            },
            pageClass: function(ind){
                return ind+1 === resultPager.current() ? "disabled current" : "";
            },
            prevClass: function() {
                return resultPager.current() > 1 ? "" : "disabled";
            },
            nextClass: function() {
                return resultPager.current() < resultPager.total() ? "" : "disabled";
            },
            pages: function() {
                return resultPager.pages(pageMin, pageMax);
            }
        };
        
        $scope.$on('$routeChangeSuccess', function (scope, next, current) {
            if ($location.path() === "/") {
                $scope.getSavedSearches();
            }
        });

        if ($location.path() === "/results") {
			$scope.search();
        } else if ($location.path() === "/") {
            $scope.getSavedSearches();
        }
    });
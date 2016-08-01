"use strict";

angular.module('sfj', ['sfj.services', 'sfj.directives', 'sfj.controllers'])
    .value('version', '0.1')
    .config(['$routeProvider', function($routeProvider) {
        $routeProvider
            .when('/', {
                //templateUrl: 'partials/home.html'
				templateUrl: 'partials/home.cfm'
            })
            .when('/results', {
                templateUrl: 'partials/results.cfm'
            })
            .when('/details/:idx', {
                templateUrl: 'partials/details.cfm',
                controller: 'UserDetailsCtrl'
            })
            
            .when('/colleague/:idx', {
                templateUrl: 'partials/colleague.cfm',
                controller: 'UserDetailsCtrl'
            })
            
            .when('/mycandidates/:idx', {
                templateUrl: 'partials/mycandidates.cfm',
                controller: 'UserDetailsCtrl'
            })
            
            .otherwise({redirectTo: '/'});
    }]);

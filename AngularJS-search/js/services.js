"use strict";

angular.module('sfj.services', ['ngResource', 'ngCookies'])
    .factory('SavedSearchService', function($resource) {
        return {
            searches: $resource('/rest/candidates/saves', {}, {
                fetch: {method: 'GET'},
                save: {method: 'POST'}
            })
        };
    })

    .factory('SavedSearchesService', function($resource) {
        return {
            searches: $resource('/rest/candidates/saved', {}, {
                fetch: {method: 'GET', isArray:true}
            })
        };
    })

	.factory('updateListViewsService', function($resource) {
        return {
            update: $resource('/rest/candidates/update', {}, {
                save: {method: 'POST', isArray:true}
            })
        };
    })

    .factory('updateERListViewsService', function($resource) {
        return {
            update: $resource('/rest/candidates/updateERListView', {}, {
                save: {method: 'POST', isArray:true}
            })
        };
    })
	
	.factory('UserDetailsService', function($resource) {
        return {
            details: $resource('/rest/candidates/details', {}, {
                get: {method: 'POST'}
            })
        };
    })
	
	.factory('DetailViewsService', function($resource) {
        return {
            detailviews: $resource('/rest/candidates/detailviews', {}, {
                fetch: {method: 'GET', isArray:true}
            })
        };
    })
	
	.factory('WebsiteProfilesService', function($resource) {
        return {
            profiles: $resource('/rest/candidates/profiles', {}, {
                fetch: {method: 'GET', isArray:true}
            })
        };
    })

	.factory('EducationService', function($resource) {
        return {
            education: $resource('/rest/candidates/education', {}, {
                fetch: {method: 'GET', isArray:true}
            })
        };
    })
	
	
    .factory('solr', function($resource) {
        return {
            http: $resource('/rest/candidates/search', {}, {
                  get: {method:'POST'}
            }),

            Query: function(q) {
                var params = {q:q, start:0, rows:10, wt:'json'};
                var filters = {};
                var that = this;
                var processFilters = function() {
                    var fq = [];
                    var states = [];
                    if ('fq' in params) {
                        delete params.fq;
                    }
                    $.each(filters, function(k, v) {
                        if (k.split(':')[0] === 'state') {
                            states.push(k.split(':')[1]);
                        } else {
                            fq.push(v);
                        }

                    });

                    if (states.length !== 0) {
                        //fq.push('{!tag=st}state:(' + states.join(' OR ') + ")");
						fq.push('{!tag=st}state:("' + states.join(' OR ') + '")');
                    }

					if (fq.length !== 0) {
                        params.fq = fq;
                    }
                };

                return {
                    query: function(q) {
                        params.q = q;
                        return this;
                    },
                    op: function(operator) {
                        params['q.op'] = operator;
                        return this;
                    },
                    type: function(t) {
                        params.defType = t;
                        return this;
                    },
                    start: function(start) {
                        params.start = start;
                        return this;
                    },
                    rows: function(rows) {
                        params.rows = rows;
                        return this;
                    },
                    sort: function(sort) {
                        params.sort = sort;
                        return this;
                    },
                    fields: function(fl) {
                        params.fl = fl;
                        return this;
                    },
                    queryFields: function(qf) {
                        params.qf = qf;
                        return this;
                    },
					phraseFields: function(pf) {
    					params.pf = pf;
					    return this;
					},
					phraseSlop: function(ps) {
					    params.ps = ps;
					    return this;
					},
					minimumMatch: function(mm) {
					    params.mm = mm;
					    return this;
					},
					boostFunction: function(bf) {
    	                params.bf = bf;
                        return this;
                    },
                    highlight: function(h) {
                        params.hl = h;
                        return this;
                    },
                    highlightSize: function(s) {
                        params['hl.fragsize'] = s;
                        return this;
                    },
                    highlightPre: function(p) {
                        params['hl.simple.pre'] = p;
                        return this;
                    },
                    highlightPost: function(p) {
                        params['hl.simple.post'] = p;
                        return this;
                    },
                    addFilter: function(name, filter) {
                        filters[name] = filter;
                        return this;
                    },
                    removeFilter: function(name) {
                        if (name in filters) {
                            delete filters[name];
                        }
                        return this;
                    },
                    setFilters: function(f) {
                        filters = f;
                        return this;
                    },
                    getFilters: function() {
                        return filters;
                    },
                    getParams: function() {
                        return params;
                    },
                    hasFilter: function(filter) {
                        return (filter in filters);
                    },
                    toString: function() {
                        processFilters();
                        return JSON.stringify(params);
                    },
                    set: function(p) {
                        params = p;
                        return this;
                    },
                    get: function() {
                        processFilters();
                        return params;
                    },
                    clone: function() {
                        var clone = that.Query(params.q);
                        var clonedp = $.extend({}, params);
                        var clonedf = $.extend({}, filters);
                        return clone.set(clonedp).setFilters(clonedf);
                    },
                    serialize: function() {
                        processFilters();
                        return JSON.stringify(params);
                    },
                    addFacet: function(facet) {
                        var facetParams = facet.get();
                        params.facet = "true";
                        $.each(facetParams, function(k, v) {
                            if (k in params) {
                                params[k].push(v);
                            } else {
                                params[k] = [v];
                            }
                        });
                        return this;
                    }
                };
            },
            Facet: function(name) {
                var params = {'facet.field':name};
                var field = name;
                var tag = '';
                return {
                    sort: function(sort) {
                        params['f.' + field + '.facet.sort'] = sort;
                        return this;
                    },
                    limit: function(limit) {
                        params['f.' + field + '.facet.limit'] = limit;
                        return this;
                    },
                    offset: function(offset) {
                        params['f.' + field + '.facet.offset'] = offset;
                        return this;
                    },
                    min: function(min) {
                        params['f.' + field + '.facet.mincount'] = min;
                        return this;
                    },
                    tag: function(t) {
                        tag = t;
                        params['facet.field'] = '{!ex=' + tag + '}' + field;
                        return this;
                    },
                    toString: function() {
                        return JSON.stringify(params);
                    },
                    get: function() {
                        return params;
                    }
                };
            },
            ResultPager: function(qry, h) {
                var query = qry.clone();
                var params = query.get();
                var hits = h;
                var total = Math.ceil(hits / params.rows);
                total = total === 0 ? 1 : total;
                var current = Math.ceil((params.start / params.rows) + 1);

                return {
                    total: function() {
                        return total;
                    },
                    current: function() {
                        return current;
                    },
                    next: function() {
                        var next = current;
                        if (current < total) {
                            next = current + 1;
                        }
                        return next;
                    },
                    previous: function() {
                        var previous = current;
                        if (current > 1) {
                            previous = current - 1;
                        }
                        return previous;
                    },
                    pages: function(min, max) {
                        var pages = [],
                            end = current + min < total ? current + min : total + 1,
                            start = end - max > 1 ? end - max : 1,
                            i;

                        for (i = start; i < end; i++) {
                            pages.push(i);
                        }
                        return pages;
                    },
                    get: function(page) {
                        var start = (page * params.rows) - params.rows;
                        return start;
                    }
                };
            }
        };
    });
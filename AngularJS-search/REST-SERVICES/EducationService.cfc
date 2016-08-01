component restpath="education" rest="true" {
   	String function fetch()
        httpmethod="GET"
        access="remote"  
		produces="application/json"
    {

		// saved search id comes in as ?id=
        var intResID = url['intResID'];
		var savedSearches = [];
		
		var qry = new Query();
		qry.setDatasource("6Figs");	
		qry.setSQl("select strHighestDegree degree, NULL as college from tblResumes (nolock) where intResID = :intResID union select strDegree degree, strUnivCollegeName college from tblResDegreeUniversity (nolock) where intResID = :intResID");
        qry.addParam(name="intResID", value=intResID, cfsqltype="cf_sql_numeric");
		var qryResult = qry.execute().getResult();
		
		if(qryResult.recordcount){
            for(i = 1; i lte qryResult.recordcount; i++){
                searchObj = getSearchResult(qryResult, i);
                arrayAppend(savedSearches, searchObj);
            }
        }
		return serializeJSON(savedSearches);
    }
	
	private struct function getSearchResult(query qry, numeric rowNumber){
		var search = {};
        search['DegreeName'] = qry.degree[rowNumber];
        search['CollegeName']  = qry.college[rowNumber];
        return search;
    }
}


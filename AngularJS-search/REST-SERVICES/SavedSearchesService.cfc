component restpath="saved" rest="true" {
	import search;
	String function fetch()
        httpmethod="GET"
        access="remote"  
		produces="application/json"
    {

		// saved search id comes in as ?id=
        var employerID = url['intEmployerID'];
		var erPwdID = url['intERPwdID'];
        var applicationName = url['sourceApp'];
        var savedSearches = [];
		
		var qry = new Query();
		qry.setDatasource("6Figs");	
		qry.setSQl("select pk_agentid, strTitle, solrSrchString from tblERSearchAgent (nolock) where intEmployerID = :intEmployerID and intERPwdID = :intERPwdID and sourceApp = :sourceApp");
        qry.addParam(name="intEmployerID", value=employerID, cfsqltype="cf_sql_numeric");
		qry.addParam(name="intERPwdID", value=erPwdID, cfsqltype="cf_sql_numeric");
        qry.addParam(name="sourceApp", value=applicationName, cfsqltype="cf_sql_text");
        
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
        search['pk_agentid'] = qry.pk_agentid[rowNumber];
        search['strTitle']  = qry.strTitle[rowNumber];
		search['solrSrchString'] = qry.solrSrchString[rowNumber];
        return search;
    }
}
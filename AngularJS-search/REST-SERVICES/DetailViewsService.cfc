component restpath="detailviews" rest="true" {
    import search;
	String function fetch()
        httpmethod="GET"
        access="remote"  
		produces="application/json"
    {

		//var jsonRequest = deserializeJSON(ToString(getHTTPRequestData().content));
        //Update the Details View for the ER activity
        //var intERPwdID = jsonRequest['intERPwdID'];
        var intERPwdID = url['intERPwdID'];
		var detailViews = [];
		
		// Perform SQL query logic here...
        var qry = new Query();
        qry.setDatasource("6Figs");
		//qry.setSQl("select top 1 0 intDailyLimit, 0 intDailyLimitCounter, 0 intMonthlyLimit, 0 intMonthlyLimitCounter from  tblResumes (nolock)");
		qry.setSQl("select * from v_erDetailViews where intERPwdID = :intERPwdID");		
        qry.addParam(name="intERPwdID", value=intERPwdID, cfsqltype="cf_sql_numeric");
		
		var resumeResponse = {};
        var qryResult = qry.execute().getResult();
		
		if(qryResult.recordcount){
            for(i = 1; i lte qryResult.recordcount; i++){
                searchObj = getSearchResult(qryResult, i);
                arrayAppend(detailViews, searchObj);
            }
        }
		return serializeJSON(detailViews);	
    }
	
	private struct function getSearchResult(query qry, numeric rowNumber){
		var search = {};
        search['intDailyLimit'] = qry.intDailyLimit[rowNumber];
        search['intDailyLimitCounter']  = qry.intDailyLimitCounter[rowNumber];
		search['intMonthlyLimit'] = qry.intMonthlyLimit[rowNumber];
		search['intMonthlyLimitCounter'] = qry.intMonthlyLimitCounter[rowNumber];
		search['intPackageType'] = qry.intPackageType[rowNumber];
        return search;
    }
}
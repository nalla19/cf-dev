component restpath="search" rest="true" {
     
    String function query() 
    	httpmethod="POST" 
    	access="remote" 
    	produces="application/json" 
    {

    	jsonRequest = deserializeJSON(ToString(getHTTPRequestData().content));
		
		var theHost = getHTTPRequestData().headers.host;
		
    	var solrRequest = new http();
    	solrRequest.setMethod("get"); 
    	solrRequest.setCharset("utf-8");

		if (theHost EQ "6figurejobs.com" OR
				theHost EQ "www.6figurejobs.com" OR
				theHost EQ "access.6figurejobs.com" OR
				theHost EQ "web1.6figurejobs.com" OR
				theHost EQ "web2.6figurejobs.com" OR
				theHost EQ "web3.6figurejobs.com" OR
				theHost EQ "salesstars.com" OR
				theHost EQ "www.salesstars.com") {

			solrRequest.setUrl("http://XXX.XX.XXX.XX:9100/solr/select");
			
		} else {
			solrRequest.setUrl("http://XXX.XX.XXX.XX:9100/solr/select");
		}
		
		if (findNoCase("6FigureJobs",theHost)) {
			solrRequest.addParam(type="formfield",name="fq",value='sourceApp:"6FigureJobs"');
		} else if (findNoCase("SalesStars",theHost)) {
			solrRequest.addParam(type="formfield",name="fq",value='sourceApp:"SalesStars"');
		}
	
    	solrRequest.addParam(type="formfield",name="wt",value="json");

    	for (var k in jsonRequest) {
            if (isArray(jsonRequest[k])) {
                for (entry in jsonRequest[k]) {
                    solrRequest.addParam(type="formfield", name=k, value=entry);
                }
            } else {
                solrRequest.addParam(type="formfield", name=k, value=jsonRequest[k]);
            }
    	}

    	result = solrRequest.send().getPrefix();

    	return result.filecontent;

    }  
}
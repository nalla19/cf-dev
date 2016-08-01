<cfquery name="getuserinfo" datasource="#application.dsn#">
select * from tblResumes
where email = 'irodela@calliduscloud.com'
</cfquery>

<cfscript>
    // Construct a weather query with information on cities.
    // To simplify the code, we use the same weather for all cities and days.
    // Normally this information would come from a data source.
    weatherQuery = QueryNew("City, Temp, Forecasts");
    QueryAddRow(weatherQuery, 2);
    theWeather=StructNew();
    theWeather.High=73;
    theWeather.Low=53;
    theWeather.Weather="Partly Cloudy";
    weatherArray=ArrayNew(1);
    for (i=1; i<=5; i++) weatherArray[i]=theWeather;
    querySetCell(weatherQuery, "City", "Newton", 1);
    querySetCell(weatherQuery, "Temp", "65", 1);
    querySetCell(weatherQuery, "ForeCasts", weatherArray, 1);
    querySetCell(weatherQuery, "City", "San Jose", 2);
    querySetCell(weatherQuery, "Temp", 75, 2);
    querySetCell(weatherQuery, "ForeCasts", weatherArray, 2);

    // Convert the query to JSON.
    // The SerializeJSON function serializes a ColdFusion query into a JSON
    // structure.
    theJSON = SerializeJSON(getuserinfo);
    
    // Wrap the JSON object in a JavaScript function call.
    // This makes it easy to use it directly in JavaScript.
    //writeOutput("onLoad( "&theJSON&" )");
</cfscript>

<cfoutput>
#theJSON#
</cfoutput>
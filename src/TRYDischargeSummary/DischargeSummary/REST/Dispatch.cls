Class DischargeSummary.REST.Dispatch Extends %CSP.REST
{

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/document/:pid/:docid/:encid/:ordid" Method="POST" Call="CreateDocument" Cors="true"/>
</Routes>
}

ClassMethod CreateDocument(pid As %String, docid As %String, encid As %String, ordid As %String) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        //次の処理に渡すJSONを作成する
        set request={}
        set request.PatientNumber=pid
        set request.DoctorNumber=docid
        set request.EncounterNumber=encid
        set request.MedicationOrderNumber=ordid
        // Bundleの作成
        $$$ThrowOnError(##class(DischargeSummary.BuildResource).Bundle(request,.bundle))
		//FHIRリポジトリにBundleを送信
        set host="localhost"
        set port=52773
        set path="/csp/healthshare/r4fhirnamespace/fhir/r4/Bundle"
        set st=##class(DischargeSummary.REST.AccessFHIRRepo).HTTPRequest(host,port,path,bundle,.location)
        //正常終了時リソース取得のURLが返る
        //例　http://127.0.0.1:52773/csp/healthshare/r4fhirnamespace/fhir/r4/Bundle/33/_history/1
        //URLを分解
        do ##class(%Net.URLParser).Decompose(location,.parseurl)
        set json={}
        set json.WebServer=parseurl("scheme")_"://"_parseurl("host")
        if $get(ret("port"))'="" {
            set json.WebServer=json.WebServer_":"_parseurl("port")
        }
        set json.Path=parseurl("path")
        set path1=$piece(json.Path,"/_history")
        set json.ResourceId=$piece(path1,"/",$length(path1,"/"))
        set json.Message="退院時サマリーリソース ID="_json.ResourceId_" で正しく保存できました。"
        do json.%ToJSON()
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

}

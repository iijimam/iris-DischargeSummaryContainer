Class DischargeSummary.REST.AccessFHIRRepo
{

ClassMethod HTTPRequest(host As %String, port As %String, path As %String, bundle As %DynamicObject, ByRef location As %String) As %Status
{
    #dim ex As %Exception.AbstractException
    #dim response As %Net.HttpResponse
    set status=$$$OK
    try {
        set request=##class(%Net.HttpRequest).%New()
        set request.Server=host
        set request.Port=port
        // Content-Typeの設定
        do request.SetHeader("Content-Type","application/fhir+json;charset=utf-8")
        do request.SetHeader("Accept","*/*")
        do bundle.%ToJSON(request.EntityBody)
        $$$ThrowOnError(request.Post(path))
        set response=request.HttpResponse
        //登録されたBundleのURL＋Historyのロケーション
        set location=response.GetHeader("LOCATION")
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

}

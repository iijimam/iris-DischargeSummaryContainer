Class FHIRTemplate.DataType.PeriodNoEnd Extends JSONTemplate.Base
{

Property start As %String;

Property end As %String;

XData Template [ MimeType = application/json ]
{
{
        "start":"#(..start)#"
}
}

}

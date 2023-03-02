Class FHIRTemplate.DataType.SimpleQuantity Extends JSONTemplate.Base
{

Property value As %Integer;

Property unit As %String;

Property system As %String;

Property code As %String;

XData Template [ MimeType = application/json ]
{
{
        "value":"#(..value)#",
        "unit": "#(..unit)#",
        "system":"#(..system)#",
        "code": "#(..code)#"
}
}

}

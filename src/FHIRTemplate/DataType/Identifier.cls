Class FHIRTemplate.DataType.Identifier Extends JSONTemplate.Base
{

Property system As %String(MAXLEN = 1000);

Property value As %String;

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
    "system":"#(..system)#",
    "value":"#(..value)#"
}
}

}

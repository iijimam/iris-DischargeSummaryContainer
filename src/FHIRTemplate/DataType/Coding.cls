Class FHIRTemplate.DataType.Coding Extends JSONTemplate.Base
{

XData Template [ MimeType = application/json ]
{
{
        "system":"#(..system)#",
        "version":"#(..version)#",
        "code": "#(..code)#",
        "display":"#(..display)#",
        "userSelected":"#(..userSelected)#"
}
}

Property system As %String(MAXLEN = 1000);

Property display As %String;

Property code As %String;

Property version As %String;

Property userSelected As %Boolean;

}

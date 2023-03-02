Class FHIRTemplate.DataType.CodingBase Extends JSONTemplate.Base [ Abstract ]
{

XData Template [ MimeType = application/json ]
{
{
        "system":"#(..#CodeSystem)#",
        "version":"#(..version)#",
        "code": "#(..code)#",
        "display":"#(..display)#",
        "userSelected":"#(..userSelected)#"
}
}

Parameter CodeSystem;

Property display As %String;

Property code As %String;

Property version As %String;

Property userSelected As %Boolean;

/// コードによるインスタンスの取得
ClassMethod GetByCode(code As %String) As CodingBase
{
        quit $$$NULLOREF
}

}

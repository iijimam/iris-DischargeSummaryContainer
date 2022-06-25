Class FHIRTest.BaseCodeTest Extends (%Persistent, JSONTemplate.Base)
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
    "code":"#(..Code)#",
    "value":"#(..Value)#"
}
}

Property Code As %String;

Property Value As %String;

Index IdKeyIdx On Code [ IdKey, Unique ];

ClassMethod GetByCode(code As %String) As FHIRTest.BaseCodeTest
{
    set obj=..%OpenId(code)
    quit obj
}

/// データ生成
ClassMethod GenerateData() As %Status
{
    set stream=##class(%Dictionary.CompiledXData).%OpenId(..%ClassName(1)_"||InsertCode").Data
    set data={}.%FromJSON(stream)

    do ..%KillExtent()
    set iter=data.data.%GetIterator()
    while iter.%GetNext(.k,.line) {
        set obj=..%New()
        set obj.Code=$piece(line,";",1),obj.Value=$piece(line,";",2)
        do obj.%Save()
    }
    quit $$$OK
}

XData InsertCode [ MimeType = application/json ]
{
{ "data":[
    "1;AAAAAAAA",
    "2;BBBBBBBB",
    "3;CCCCCCCC"  ]  
}
}

Storage Default
{
<Data name="BaseCodeTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^FHIRTest.BaseCodeTestD</DataLocation>
<DefaultData>BaseCodeTestDefaultData</DefaultData>
<IdLocation>^FHIRTest.BaseCodeTestD</IdLocation>
<IndexLocation>^FHIRTest.BaseCodeTestI</IndexLocation>
<StreamLocation>^FHIRTest.BaseCodeTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class FHIRTest.BaseTest2 Extends JSONTemplate.Base
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
    "p1":"BaseTest2",
    "p2":"#(..Param1)#",
    "p3":"#(..Param1)# #(..Param2)#"
}
}

Property Param1 As %String;

Property Param2 As %Numeric;

}

/// CodableConcept
Class FHIRTemplate.DataType.CodeableConcept Extends JSONTemplate.Base
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
	"coding": [
		{
			"system": "#(..system)#",
			"code": "#(..code)#",
			"display": "#(..display)#"
		}
	]
}
}

Property system As %String;

Property code As %String;

Property display As %String;

}

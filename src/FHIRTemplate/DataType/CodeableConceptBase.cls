/// CodableConcept
Class FHIRTemplate.DataType.CodeableConceptBase Extends JSONTemplate.Base [ Abstract ]
{

/// コードシステムのURI
Parameter CodeSystem;

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
	"coding": [
		{
			"system": "#(..#CodeSystem)#",
			"code": "#(..code)#",
			"display": "#(..display)#"
		}
	]
}
}

Property code As %String;

Property display As %String;

}

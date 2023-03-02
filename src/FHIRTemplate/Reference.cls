/// 参照テンプレート
Class FHIRTemplate.Reference Extends ResourceBase
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
	"reference": "urn:uuid:#(..ResourceId)#",
  "type": "#(..#ResourceType)#"
}
}

}

Class FHIRTemplate.DataType.Period Extends JSONTemplate.Base
{

Property start As TimeStamp;

Property end As TimeStamp;

XData Template [ MimeType = application/json ]
{
{
        "start":"#(..start)#",
        "end": "#(..end)#"
}
}

}

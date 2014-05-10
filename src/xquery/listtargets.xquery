declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"; 
declare namespace foaf="http://xmlns.com/foaf/0.1/";
declare namespace oac="http://www.w3.org/ns/oa#"; 
declare namespace cnt="http://www.w3.org/2008/content#";

let $doc := doc("/home/balmas/canonical_perseids/canonical/CITE_COMMENTARY_XML/perseus/mythcomm/merged.rdf")
let $targets := 
    for $a in $doc//oac:Annotation
        return $a/oac:hasTarget/@rdf:resource
return 
    <html>
    <head><title>Test Commentary Targets</title></head>
    <body>{
        for $t in distinct-values($targets)
        return
            <div><a href="{xs:string($t)}">{xs:string($t)}</a>
                <ul>
                {
                    for $s in $doc//oac:Annotation[oac:hasTarget[@rdf:resource=$t]]
                    order by $s/foaf:Perseus/foaf:name
                    return <li>{xs:string($s//foaf:name)}</li>
                }
                </ul>
            </div>
    }</body>
    </html>


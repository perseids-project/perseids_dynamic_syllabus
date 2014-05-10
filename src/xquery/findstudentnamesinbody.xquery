declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"; 
declare namespace foaf="http://xmlns.com/foaf/0.1/";
declare namespace oac="http://www.w3.org/ns/oa#"; 
declare namespace cnt="http://www.w3.org/2008/content#";

let $doc := doc("merged.rdf")
for $a in $doc//oac:Annotation
    let $id := $a/@rdf:about
    let $who := $a/oac:annotatedBy/foaf:Person/foaf:name
    return if (contains(xs:string($a/oac:hasBody/cnt:ContentAsText/cnt:chars),xs:string($who))) then xs:string($a/@rdf:about) else ()

declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"; 
declare namespace foaf="http://xmlns.com/foaf/0.1/";
declare namespace oac="http://www.w3.org/ns/oa#"; 
declare namespace cnt="http://www.w3.org/2008/content#";

let $doc := doc("/home/balmas/canonical_perseids/canonical/CITE_COMMENTARY_XML/perseus/mythcomm/merged.rdf")
let $students := distinct-values($doc//foaf:Person/foaf:name)
let $targets := 
    for $a in $doc//oac:Annotation
        return $a/oac:hasTarget[matches(@rdf:resource,'artifacts') or matches(@rdf:resource,'perseus-eng')]/@rdf:resource
return 
    <html>
    <head>
        <title>Tufts Greek and Roman Mythology Fall 2013 - Student Publications</title>
    </head>
    <body>
        <h1>Tufts - Greek and Roman Mythology Fall 2013 Student Publications</h1>
        <table id="course_info">
			<tr>
				<th>Instructor:</th><td>Dr. Marie-Claire Beaulieu</td>
			</tr>
			<tr>
				<th>TAs:</th><td>Julia Lenzi and Tim Buckingham</td>
			</tr>
		</table>
        <ul>
        {
            
            for $s in $students
                order by $s
                return
                <li>{$s}
                    <ul> {
                        for $a in $doc//oac:Annotation[oac:annotatedBy[foaf:Person/foaf:name[. = $s]]]
                            let $t := $a/oac:hasTarget[matches(@rdf:resource,'artifacts') or matches(@rdf:resource,'perseus-eng')]/@rdf:resource
                            for $i in $t
                                return <li><a href="{xs:string($i)}">{xs:string($i)}</a></li>
                        
                    }</ul>
                </li>
        }
        </ul>
        </body>
    </html>


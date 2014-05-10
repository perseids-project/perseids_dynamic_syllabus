

function get_stats() {
    var texts = [];
    var cites = [];
    var objs = [];
    for (var i=0; i<Perseids.syllabus.length; i++) {
        var mod = Perseids.syllabus[i];
        for (var j=0; j<mod.assignments.length; j++) {
            var assign = mod.assignments[j];
            var level = assign.level;
            var label = assign.label;
            var group = assign.group;
            if (group == 2) {   
                var target = assign.annotation_targets[0];
                texts.push({ 'level': level, 'label': label, 'target': target})
            }
        }
        
    }
    for (var i=0; i<texts.length; i++) {
        $("#results").append(texts[i].level + "\t" + texts[i].label + "\t"  + texts[i].target)    
        $("#results").append('<br/>\n');
    }
        
}
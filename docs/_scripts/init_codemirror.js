
var code_instances = document.getElementsByClassName("code");

// loop through all code blocks
for ( var i = 0 ; i < code_instances.length ; i++ ) {
    
    let current_code = code_instances[i];
    
    // get code src
    fetch( current_code.getAttribute("src") )
        .then(response => response.text())
        .then(data => {
            // set contents of code block to src
            current_code.value = data;
            current_code.setAttribute("readonly","true");

            // config codemirror
            let c = CodeMirror.fromTextArea(
                current_code, {
                    mode: current_code.getAttribute("mode"),
                    lineNumbers: true,
                    viewportMargin: Infinity,
                    readOnly: "nocursor"
                }
            );

        })
        .catch(err => {
            current_code.value = "[Error]: Failed to fetch code."
            console.error(err);
        });

}

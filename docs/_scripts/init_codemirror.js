
const textareas         = document.getElementsByTagName("textarea");


for ( let i = 0; i < textareas.length; i++ ) {

    let textarea = textareas[i];

    // skip if there is no src
    if ( !textarea.hasAttribute("src") ) {
        beautify_textarea( textarea );
        continue;
    }

    // get code src
    fetch( textarea.getAttribute("src") )
        .then(response => response.text())
        .then(data => {
            textarea.value = data;
            textarea.setAttribute("readonly","true");
            beautify_textarea( textarea );
        });
}


function beautify_textarea( textarea ) {
    if ( textarea.classList.contains("code") ) {
        // config codemirror
        let c = CodeMirror.fromTextArea(
            textarea, {
                mode: textarea.getAttribute("mode"),
                lineNumbers: !(textarea.hasAttribute("nonumbers")),
                viewportMargin: Infinity,
                readOnly: "nocursor"
            }
        );
    } else {
        // config default textarea
        textarea.style.height = (textarea.scrollHeight+3) + "px";
        textarea.style.width = "100%";
        textarea.style.opacity = "100%";
    }
}


const to_replace = document.getElementById("__NAV__");

fetch( "/_partials/nav.phtml" )
    .then(response => response.text())
    .then(data => {
        to_replace.innerHTML = data;
    });

// from https://www.w3schools.com/howto/howto_js_navbar_hide_scroll.asp
var prevScrollpos = window.pageYOffset;
window.onscroll = function() {
    var currentScrollPos = window.pageYOffset;
    if (prevScrollpos > currentScrollPos) {
        document.getElementById("__NAV__").style.top = "0";
    } else {
        document.getElementById("__NAV__").style.top = "-130px";
    }
    prevScrollpos = currentScrollPos;
}

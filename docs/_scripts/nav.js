
const to_replace = document.getElementById("__NAV__");

fetch( "/_partials/nav.phtml" )
    .then(response => response.text())
    .then(data => {
        to_replace.innerHTML = data;
    });

#!/usr/bin/env awk -f

BEGIN             { printf "<ul>\n" }
/^[0-9A-Z]+\. /   { li($1, $2, $3) }
/^[—A-Za-z ]{2,}/ { printf "</ul>\n<p>" $0 "</p>\n<ul>\n" }
END               { printf "</ul>\n" }

function li(number, file, subs) {
    if (file == current) printf "  <li class='current'>"
                    else printf "  <li><a href='" file ".html'>"
    printf number " "
    system("sed -n 's,%h1 ,,p' " file ".haml | tr -d '\n'")
    if (file != current) printf "</a>"
    if (file == current && subs == "+subsections") {
        printf "\n    <ul>\n"
        subsections(file)
        printf "    </ul>\n  "
    }
    printf "</li>\n"
}
function subsections(file) {
    system("sed -En 's,%h2#([a-z0-9-]*) (.*)" \
                     ",      <li><a href=\"#\\1\">\\2</a></li>" \
                     ",p' " file ".haml")
}

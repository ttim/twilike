function setCookie(c_name, value, expire_days)
{
    // delete old cookie
    var cookie_date = new Date ( );  // current date & time
    cookie_date.setTime ( cookie_date.getTime() - 1 );
    document.cookie = c_name + "=; expires=" + cookie_date.toGMTString();

    // set new
    var date = new Date();
    date.setDate(date.getDate() + expire_days);

    document.cookie = c_name + "=" + escape(value) +
                      ((expire_days == null) ? "" : ";expires=" + date.toGMTString())+
                      ";path=/";
}

function getCookie(c_name)
{
    if (document.cookie.length > 0)
    {
        c_start = document.cookie.indexOf(c_name + "=");
        if (c_start != -1)
        {
            c_start = c_start + c_name.length + 1;
            c_end = document.cookie.indexOf(";", c_start);
            if (c_end == -1) c_end = document.cookie.length;
            return unescape(document.cookie.substring(c_start, c_end));
        }
    }

    return ""
}

function load_css(filename) {
    var fileref = document.createElement("link")
    fileref.setAttribute("rel", "stylesheet")
    fileref.setAttribute("type", "text/css")
    fileref.setAttribute("href", filename)

    if (typeof fileref != "undefined")
        document.getElementsByTagName("head")[0].appendChild(fileref)
}

function set_theme(theme) {
    if (RAILS_ENV == "production") {
        load_css('/stylesheets/_' + theme + '.css')
    } else {
        for (var i in THEME_FILES) {
            load_css('/stylesheets/' + theme + '/' + THEME_FILES[i] + '.css')
        }
    }

    // add to cookies
    setCookie("theme", theme, 365)
}

function load_default_theme() {
    theme = getCookie("theme")
    
    if ((theme != "theme1") && (theme != "theme2")) theme = "theme1"

    set_theme(theme)
}

load_default_theme()
function ini_dotSplit(str) {
    return str.replace(/\1/g, '\u0002LITERAL\\1LITERAL\u0002')
        .replace(/\\\./g, '\u0001')
        .split(/\./).map(function (part) {
            return part.replace(/\1/g, '\\.')
                .replace(/\2LITERAL\\1LITERAL\2/g, '\u0001');
        });
}

function ini_decode(str) {
    var out = {}
    var p = out
    var section = null
    //          section     |key      = value
    var re = /^\[([^\]]*)\]$|^([^=]+)(=(.*))?$/i
    var lines = str.split(/[\r\n]+/g)

    lines.forEach(function (line, _, __) {
        if (!line || line.match(/^\s*[;#]/)) return
        var match = line.match(re)
        if (!match) return
        if (match[1] !== undefined) {
            section = ini_unsafe(match[1])
            p = out[section] = out[section] || {}
            return
        }
        var key = ini_unsafe(match[2])
        var value = match[3] ? ini_unsafe(match[4]) : true
        switch (value) {
            case 'true':
            case 'false':
            case 'null': value = JSON.parse(value)
        }

        // Convert keys with '[]' suffix to an array
        if (key.length > 2 && key.slice(-2) === '[]') {
            key = key.substring(0, key.length - 2)
            if (!p[key]) {
                p[key] = []
            } else if (!Array.isArray(p[key])) {
                p[key] = [p[key]]
            }
        }

        // safeguard against resetting a previously defined
        // array by accidentally forgetting the brackets
        if (Array.isArray(p[key])) {
            p[key].push(value)
        } else {
            p[key] = value
        }
    })

    // {a:{y:1},"a.b":{x:2}} --> {a:{y:1,b:{x:2}}}
    // use a filter to return the keys that have to be deleted.
    Object.keys(out).filter(function (k, _, __) {
        if (!out[k] ||
            typeof out[k] !== 'object' ||
            Array.isArray(out[k])) {
            return false
        }
        // see if the parent section is also an object.
        // if so, add it to that, and mark this one for deletion
        var parts = ini_dotSplit(k)
        var p = out
        var l = parts.pop()
        var nl = l.replace(/\\\./g, '.')
        parts.forEach(function (part, _, __) {
            if (!p[part] || typeof p[part] !== 'object') p[part] = {}
            p = p[part]
        })
        if (p === out && nl === l) {
            return false
        }
        p[nl] = out[k]
        return true
    }).forEach(function (del, _, __) {
        delete out[del]
    })

    return out
}

function ini_isQuoted(val) {
    return (val.charAt(0) === '"' && val.slice(-1) === '"') ||
        (val.charAt(0) === "'" && val.slice(-1) === "'")
}

function ini_unsafe(val, doUnesc) {
    val = (val || '').trim()
    if (ini_isQuoted(val)) {
        // remove the single quotes before calling JSON.parse
        if (val.charAt(0) === "'") {
            val = val.substr(1, val.length - 2)
        }
        try { val = JSON.parse(val) } catch (_) { }
    } else {
        // walk the val to find the first not-escaped ; character
        var esc = false
        var unesc = ''
        for (var i = 0, l = val.length; i < l; i++) {
            var c = val.charAt(i)
            if (esc) {
                if ('\\;#'.indexOf(c) !== -1) {
                    unesc += c
                } else {
                    unesc += '\\' + c
                }
                esc = false
            } else if (';#'.indexOf(c) !== -1) {
                break
            } else if (c === '\\') {
                esc = true
            } else {
                unesc += c
            }
        }
        if (esc) {
            unesc += '\\'
        }
        return unesc.trim()
    }
    return val
}

function componentToHex(c) {
    var hex = parseInt(c).toString(16);
    return hex.length == 1 ? "0" + hex : hex;
}

function rgb2Hex(r, g, b) {
    return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}

function getKDEColor(group, color, data) {
    return rgb2Hex(...data[`Colors:${group}`][color].split(','));
}

function encodeSVG(s) {

    s = s.replace(/"/g, `'`);
    s = s.replace(/>\s{1,}</g, `><`);
    s = s.replace(/\s{2,}/g, ` `);

    return s.replace(/[\r\n%#()<>?[\\\]^`{|}]/g, encodeURIComponent);
}


function getFile(path, cb) {
    var doc = new XMLHttpRequest();

    doc.onreadystatechange = () => {
        if (doc.readyState == XMLHttpRequest.DONE) {
            cb(doc.responseText);
        }
    }
    doc.open("GET", path);
    doc.send();

}

function loadUserTheme() {

    getFile(`${wrapper.homeDir}/.config/kdeglobals`, (data) => {
        var ini = ini_decode(data);

        if (ini["General"]) {
            root.kyzenBackgroundColor = getKDEColor("Window", "BackgroundNormal", ini)
            root.kyzenTextColor = getKDEColor("Window", "ForegroundNormal", ini)
            root.kyzenButtonFocusColor = getKDEColor("Button", "DecorationFocus", ini)
            root.kyzenButtonHoverColor = getKDEColor("Button", "DecorationHover", ini)
            root.kyzenButtonTextColor = getKDEColor("Button", "ForegroundNormal", ini)
            root.kyzenButtonBackgroundColor = getKDEColor("Button", "BackgroundNormal", ini)
            root.kyzenHighlightColor = getKDEColor("Selection", "BackgroundNormal", ini)
            root.kyzenHighlightTextColor = getKDEColor("Selection", "ForegroundNormal", ini)
            root.kyzenViewBackgroundColor = getKDEColor("View", "BackgroundNormal", ini)
        } else {
            root.kyzenBackgroundColor = root.kyzenDefaultBackgroundColor;
            root.kyzenTextColor = root.kyzenDefaultTextColor;
            root.kyzenButtonFocusColor = root.kyzenDefaultButtonFocusColor;
            root.kyzenButtonHoverColor = root.kyzenDefaultButtonHoverColor;
            root.kyzenHighlightColor = root.kyzenDefaultHighlightColor;
            root.kyzenHighlightTextColor = root.kyzenDefaultHighlightTextColor;
            root.kyzenButtonBackgroundColor = root.kyzenDefaultButtonBackgroundColor;
            root.kyzenViewBackgroundColor = root.kyzenDefaultViewBackgroundColor;
            root.kyzenButtonTextColor = root.kyzenDefaultButtonTextColor;
        }

    })

}

function updateCurrentUserState() {
    if(wrapper.userBackground) {
        wrapper.userBackground.opacity=wrapper.isCurrent ? 1 : 0;

    } 
    
    if (wrapper.isCurrent) {
        loadUserTheme();
    }
}

function findByUserName(list) {

    for (let i = 0, length = list.count; i < length; ++i) {
        const bg = list.get(i);
        if(bg.bgId === wrapper.userName) {
            return bg.component;
        }
    }

    return null;

}

function loadUsersWallpaper() {

    // Let's fetch the User's settings!

    let username = wrapper.userName
    let usrRegexp=new RegExp(`${username}\\:\\d+`);
    let userBackgroundId = `background_${username}`
    
    if ( !usrRegexp.test(loginBackgroundList.users) ) {
        getFile(`${wrapper.homeDir}/.config/plasma-org.kde.plasma.desktop-appletsrc`, (data) => {
            var ini = ini_decode(data.replace(/\[[^\[\]]+\.[^\[\]]+\]/ig, (str) => str.replace(/\./g, "_")).replace(/\]\[/ig, "."));
       
            let backgroundOpt = { id: userBackgroundId };
            let userBackgroundComponent = root.useDefaultWallpaper ? Qt.createComponent('../components/UserBackgroundImage.qml') : Qt.createComponent('../components/UserBackgroundColor.qml');

            if (ini["Containments"]) {

                for (const k in ini.Containments) {
                    if (ini.Containments.hasOwnProperty(k)) {
                        const element = ini.Containments[k];
                        if (element.plugin === "org.kde.desktopcontainment") {

                            let pluginName = element.wallpaperplugin.replace(/\./g, "_");

                            switch (pluginName) {
                                case "org_kde_image":
                                case "org_kde_slideshow":
                                    backgroundOpt.source = element.Wallpaper[pluginName].General.Image.replace("file://", '');
                                    userBackgroundComponent = Qt.createComponent('../components/UserBackgroundImage.qml')
                                    break;
                                case "org_kde_potd":
                                    backgroundOpt.source = `${wrapper.homeDir}/.cache/plasmashell/plasma_engine_potd/${element.Wallpaper[pluginName].General.Provider}`;
                                    userBackgroundComponent = Qt.createComponent('../components/UserBackgroundImage.qml')
                                    break;

                                case "org_kde_color":
                                    backgroundOpt.color = rgb2Hex(...element.Wallpaper.org_kde_color.General.Color.split(','));
                                    userBackgroundComponent = Qt.createComponent('../components/UserBackgroundColor.qml');
                                    break;

                                default:

                                    if(root.useDefaultWallpaper) {
                                        backgroundOpt.source = root.defaultWallpaper;
                                    } else {
                                        backgroundOpt.color = root.kyzenBackgroundColor;
                                    }
                                    break;
                            }

                            break;
                        }
                    }
                }
            } else {

                if(root.useDefaultWallpaper) {
                    backgroundOpt.source = root.defaultWallpaper;
                } else {
                    backgroundOpt.color = root.kyzenBackgroundColor;
                }

            }

            let background = { bgId: username, component: userBackgroundComponent.createObject(loginBackgroundList, backgroundOpt) };
            userBackgroundCache.append(background);
            wrapper.userBackground = background.component;
            loginBackgroundList.users+=`;${username}:${wrapper.m.index}`;

            updateCurrentUserState()
        })

    } else {
        wrapper.userBackground = findByUserName(userBackgroundCache);
    } 

}
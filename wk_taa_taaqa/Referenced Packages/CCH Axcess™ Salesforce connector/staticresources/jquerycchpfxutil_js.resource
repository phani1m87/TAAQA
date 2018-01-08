(function ($) {
    //var _cssInHeader = false;

    //var _css = ".plusImage { list-style-image:url('images/plus.png');	cursor:pointer;	} \
    //            .minusImage { list-style-image:url('images/minus.png'); cursor:pointer; } \
    //            .selectedImage { list-style-image:url('images/selected.png'); cursor:pointer;}";

/// Global plugin functions
    $.extend({
        jsonToHtml: function (obj) {
            var retValue = "";
            for (var key in obj) {
                if (typeof obj[key] == 'object') {
                    if (obj[key] != null) {
                        if ($.isArray(obj[key]) && obj[key].length == 0) {
                            var id = $("div#clientIdSubId").html().split(":");
                            var clientId = id[0];
                            var clientSubId = id[1];
                            var func = "getClientProperty($(this).parent(), '"+ clientId + "', '" + clientSubId + "', '" + key + "');";
                            retValue += "<li><a href='#' class='clientPropertyClass' onclick=\"" + func + "\">" + key + "</a></li>";
                        }
                        else {
                            retValue += "<li class='tree'>" + key + "<ul>";
                            retValue += arguments.callee(obj[key]);             // recursive call
                            retValue += "</ul></li>";
                        }
                    }
                    else {
                        retValue += "<li class='leaf selectedImage'>" + key + " = [null] </li>";
                    }
                }
                else if (typeof obj[key] == 'NULL') {
                    retValue += "<li class='leaf selectedImage'>" + key + " = </li>";
                }
                else {
                    if (typeof(obj[key]) === "string")
                    {
                        if (obj[key].substring(0, 6) == "/Date(")
                        {
                            var dt = new Date(parseInt(obj[key].substring(6, obj[key].length - 2)));
                            var dtString = (dt.getMonth() + 1) + "/" + dt.getDate() + "/" + dt.getFullYear();
                            retValue += "<li class='leaf selectedImage'>" + key + " = " + dtString + "</li>";
                        }
                        else
                            retValue += "<li class='leaf selectedImage'>" + key + " = " + obj[key] + "</li>";
                    }
                    else 
                        retValue += "<li class='leaf selectedImage'>" + key + " = " + obj[key] + "</li>";
                }
            }
            return retValue;
        },
    });


    /// DOM element functions
    $.fn.extend({
        applyExpandCollapse: function (collapsableNodeClassName) {
//            if (!_cssInHeader)
//            {
//                $('<style type="text/css"></style>')
//                .html(_css);
//                .appendTo("head");

//                _cssInHeader = true;
//            }

            var liElemt = '.' + collapsableNodeClassName;
            

            $(liElemt, this).addClass('plusImage');
            $(liElemt, this).children().addClass('selectedImage');
            $(liElemt, this).children().hide();
            $(liElemt, this).each(function (column) {
                $(this).click(function (event) {
                    if (this == event.target) {
                        if ($(this).is('.plusImage')) {
                            $(this).removeClass('plusImage');
                            $(this).addClass('minusImage');
                            $(this).children().show();
                        }
                        else {
                            $(this).removeClass('minusImage');
                            $(this).addClass('plusImage');
                            $(this).children().hide();
                        }
                    }
                });
            });

            if ($(this).is(liElemt)) {
                $(this).addClass('minusImage');
                
                $(this).click(function (event) {
                    if (this == event.target) {
                        if ($(this).is('.plusImage')) {
                            $(this).removeClass('plusImage');
                            $(this).addClass('minusImage');
                            $(this).children().show();
                        }
                        else {
                            $(this).removeClass('minusImage');
                            $(this).addClass('plusImage');
                            $(this).children().hide();
                        }
                    }
                });
            }
        },
    });
})(jQuery);

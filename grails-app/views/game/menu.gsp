
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <link href="css/bootstrap-switch.css" rel="stylesheet" type="text/css" />
    <link href="css/menu.css" rel="stylesheet" type="text/css" />
</head>
<body>
<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="${createLink(mapping: "index")}">State Hopper</a>
        </div>
        <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
                <li class="active"><a href="${createLink(controller: "game", action: "menu")}">Menu</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container">
    <div class="row">
        <div class="col-md-8 col-md-offset-2 panel">
            <div class="panel-body">
                <g:form action="game">
                    <div class="form-group" id="name-group">
                        <label id="name-label" for="input-name">Username</label>
                        <input name="name"
                               type="name"
                               class="form-control"
                               id="input-name"
                               onchange="checkInput()"
                               placeholder="Enter name"
                               value="Player">
                    </div>
                    <div class="form-group" id="tut-group">
                        <label id="tut-label" for="tutorial-button">Tutorial Mode</label>
                        <span class="tut-checkbox">
                        <input id="tutorial-button"
                               name="tutorial"
                               type="checkbox"
                               onchange="checkInput()"
                               checked>
                        </span>
                    </div>
                    <div class="form-group">
                        <label id="property-label">Choose five properties</label>
                        <div id="property-panel" class="panel">
                            <div class="panel-body checkboxes">
                                <table class="table table-hover table-striped table-condensed table-responsive">
                                    <tbody>
                                    <g:each in="${properties}">
                                        <tr><td style="width: 100%;">${it.name}</td>
                                            <td>
                                                <g:if test="${it.explain}">
                                                <a class="btn btn-default whatsthis"
                                                   href="${it.explain}"
                                                   data-toggle="tooltip"
                                                   data-placement="top"
                                                   title="${it.desc}">What's this?</a>
                                                </g:if>
                                            </td>
                                            <td><div class="checkbox">
                                                <input name="property-${it.propertyId}"
                                                       class="property-checkbox"
                                                       type="checkbox"
                                                       onchange="checkInput()"
                                                       checked>
                                        </div></td></tr>
                                    </g:each>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-default">Start</button>
                    </div>
                </g:form>
            </div>
        </div>
    </div>
</div>

<script src="js/bootstrap-switch.js" type="text/javascript"></script>
<script>
    var errorColor = "#D02E2B"; //#A94442
    $(function() {
        // create checkbox buttons and tooltips
        $('[type="checkbox"]').bootstrapSwitch();
        $('[data-toggle="tooltip"]').tooltip();
        $('.navbar-collapse').collapse();
        $('.collapse').collapse();

    });

    /**
     * Checks if the name is not empty and at least five checkboxes are checked.
     * If not, the start button is disabled and the missing inputs are highlighted for the user.
     */
    function checkInput() {
        var n =  $("#input-name").val() != "";
        var name = $("#name-group");
        var nLabel = $("#name-label");
        var nPanel = $("#name-panel");
        if(n) {
            name.prop("class", "form-group");
            nLabel.css("color", "black");
            nPanel.css("border", "1px solid #D3D3D3");
        } else {
            name.prop("class", "form-group has-error");
            nLabel.css("color", errorColor);
            nPanel.css("border", "1px solid " + errorColor);
        }

        var propAmount = 0;
        jQuery.each($(".property-checkbox"),(function(i, c) {if(c.checked)propAmount++;}));
        var c = propAmount >= 5;

        var cLabel = $("#property-label");
        var button = $("[type=submit]");
        var cPanel = $("#property-panel");
        if(c) {
            cLabel.css("color", "black");
            cPanel.css("border", "1px solid #D3D3D3");
        } else {
            cLabel.css("color", errorColor);
            cPanel.css("border", "1px solid " + errorColor);
        }

        if(c && n) {
            button.prop("disabled", false);
        } else {
            button.prop("disabled", true);
        }
    }
</script>
</body>
</html>
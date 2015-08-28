
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta name="layout" content="main">
    <link href="css/bootstrap-switch.css" rel="stylesheet" type="text/css" />
    <link href="css/game.css" rel="stylesheet" type="text/css" />
    <link href="css/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="css/jquery-ui.theme.css" rel="stylesheet" type="text/css" />
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
                <li><a href="${createLink(controller: "game", action: "menu")}">Menu</a></li>
                <li class="active"><a>Location</a></li>
                <li class="color-link"><a class="location-country" id="current-country-label" onclick="viewCurrent()" href="#">Loading ...</a></li>
                <li class="active"><a>View</a></li>
                <li class="color-link"><a class="view-country" id="spec-country-label" onclick="viewSpec()" href="#">None</a></li>
                <li class="active"><a>Goal</a></li>
                <li class="color-link"><a class="goal-country" id="goal-country-label" onclick="viewGoal()" href="#">Loading ...</a></li>
            </ul>
        </div>
    </div>
</nav>
<svg id="tmp" style="height: 1px; width: 1px; overflow: hidden; position: absolute;z-index: -100;"></svg>
<div class="outer">
    <div class="inner">
        <div class="map"><svg style="display: inline-block; width: 100%; height: 100%;" id="mapContainer"></svg></div>
    </div>
</div>
<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav navbar-right">
                <li><button id="continue-button" class="btn btn-primary" onclick="showEndScreen()">Continue</button></li>
                <li class="active"><a>Free Mode</a></li>
                <li><form class="navbar-form">
                    <input id="spectator-button" type="checkbox" readonly="true" checked>
                </form></li>
                <li class="active"><a id="tutorial"
                                      data-toggle="tooltip"
                                      data-placement="top"
                                      title=""
                                      data-html="true">Tutorial</a></li>
                <li><form class="navbar-form">
                    <input id="tutorial-button" type="checkbox" >
                </form></li>
                <li><a class="navbar-brand">State Hopper</a></li>
            </ul>
        </div>
    </div>
</nav>
<div id="dialog"></div>
<div id="endScreen" title="Data" style="display: none"></div>
<script src="js/bootstrap-switch.js" type="text/javascript"></script>
<script src="js/snap.svg.js" type="text/javascript"></script>
<script src="js/svg-pan-zoom.js" type="text/javascript"></script>
<script src="js/radar.js" type="text/javascript"></script>
<script src="js/jquery-ui.js" type="text/javascript"></script>
<script src='js/Chart.min.js'></script>
<script>
    /**
     * All data of the countries are stored in this array.
     * A country object has a name, an optional shortName,
     * a code (which is also used as id in the svg),
     * the neighbor countries, an array of properties and some more attributes.
     * Each property has a name, a value, a normalized value 'nValue' and a visible flag.
     */
    var countries;
    // code of current country
    var currentCountry;
    // code of goal country
    var goalCountry;
    // code of country which is currently viewed in spectator mode (does not to need be equal to current country, but could be).
    var specCountry;
    // count the hops for the current game
    var hopCount;
    // if true, radar is drawn in the center of the screen for the current country; the current country is focused; pan and zoom is disabled
    // if false radar is cleared and pan/zoom is enabled
    var radarVisible;
    // flag, if the game was loading once in the beginning
    var loadingComplete = false;
    // flag, if there is an ongoing animated pan/zoom. Used to disable controls during animations.
    var inAnimation = false;
    // flag, if current game is won
    var finished;
    // flag, if end screen has been open already
    var endScreenOpen;
    // array of svg elements drawn in the map to show neighbors of a country
    var specNetwork = [];
    // save the journey of the current game to show the user the travelled path afterwards.
    // It's an array consisting of country codes. The start country should not be in the array.
    var currentJourney = [];
    // an array of svg elements which are drawn on the map. Also used for cleanup.
    var specJourney = [];
    // flag, if journey path should be drawn
    var journeyDrawn;
    // show another tooltip after the first hop
    var firstHop;
    // tooltip texts
    var helpTextArrow = "This is your start country! <br/> Click the property you want to change.<br/>With '<' you decrease it, with '>' you increase it.<br/><br/>Try it out!";
    var helpTextStart = "Welcome to State Hopper, ${userName}!<br/><br/>Currently you are in 'Free Mode' which lets you move or zoom the map by dragging or scrolling.<br/>The buttons below toggle between this mode and the actual game mode. Also you can switch these tooltips on and off.<br/><br/>Now click into any country!";
    var helpTextNeighbors = "The yellow lines indicate adjacent countries, which you could reach from here.<br/>Another click into the yellow bordered country or on the colored shortcuts in the navigation bar will take you to the country and display the attributes you already used.<br/><br/>Now double click the blue outlined country or the blue shortcut!";
    var helpTextSecondHop = "Great!<br/><br/>Now chose another property!";
    // data canvases
    var canvasString = "<canvas id=\"att0\" height=\"200\" width=\"800\"></canvas><canvas id=\"att1\" height=\"200\" width=\"800\"></canvas><canvas id=\"att2\" height=\"200\" width=\"800\"></canvas><canvas id=\"att3\" height=\"200\" width=\"800\"></canvas><canvas id=\"att4\" height=\"200\" width=\"800\"></canvas>";
    // free mode button
    var specSwitch;
    // tutorial mode button
    var tutSwitch;
    //flag, if tutorial mode is active
    var tutModeOn;
    // dom element. Above this the tooltips are shown
    var tutorial;
    // store the last shown tooltip
    var tutHelpText;
    // barrier, if map is loaded (ajax)
    var mapLoad = 0;
    // barrier, if countries are loaded (ajax)
    var countriesLoad = 0;
    // svg group to draw radar plot in
    var radarGroup;
    // a snap object of the map
    var snapObj;
    // a snap object. Neighbor network elements are drawn inside this element
    var snapParent;
    // panZoom instance
    var pz;
    // store the starting viewport position of a user panning
    var lastViewportPos;

    /**
     * Is called, when the DOM is loaded.
     */
    $(function() {
        // set up loading screen
        showLoadingScreen();
        // init checkbox buttons
        specSwitch = $("#spectator-button");
        tutSwitch = $("#tutorial-button");
        specSwitch.bootstrapSwitch();
        tutSwitch.bootstrapSwitch();
        specSwitch.on('switchChange.bootstrapSwitch', function(event, state) {
            toggleView();
        });
        tutSwitch.on('switchChange.bootstrapSwitch', function(event, state) {
            toggleTutorial();
        });
        tutSwitch.bootstrapSwitch('state', ${tutorial}, true, false);
        tutSwitch.bootstrapSwitch('readonly', true, true);
        tutModeOn = ${tutorial};
        // set element to show tooltips above
        tutorial = $("#tutorial");
        // load game, set up afterwards
        load(function(){
            setupGame();
        });
    });

    /**
     * Set up all variables for a new game of state hopper.
     * Also deletes objects from previous game, if present.
     */
    function setupGame() {
        // remove elements from previous game, if present
        $("#continue-button").css("visibility", "hidden");
        while(specNetwork.length > 0) {
            specNetwork.pop().remove();
        }
        while(specJourney.length > 0) {
            specJourney.pop().remove();
        }
        radarGroup.clear();
        highlightNone(goalCountry);
        highlightNone(currentCountry);
        highlightNone(specCountry);

        // make all property values invisible
        for(var i = 0; i < countries.length; i++) {
            if(countries[i].properties.length > 0) {
                for(var p = 0; p < 5; p++) {
                    // set all properties to invisible so that a user could not see the value until he unlocks it
                    countries[i].properties[p].visible = false;
                }
            }
        }
        // set up all variables
        var journey = getJourney(10, 15);
        var current = journey.start;
        var goal = journey.goal;
        goalCountry = goal;
        currentCountry = current;
        specCountry = undefined;
        currentJourney = [];
        currentJourney.push(current);
        setGoalCountry(goal);
        setCurrentCountry(current);
        hopCount = 0;
        radarVisible = false;
        finished = false;
        endScreenOpen = false;
        journeyDrawn = false;
        firstHop = true;

        if(loadingComplete) {
            startGame();
        } else {
            // open the loading screen just once for all games
            loadingComplete = true;
            var d = $("#dialog");
            // update loading screen manually, because updateLoadingScreen() updates the screen only if
            // loadingComplete is a falsy value
            d.html(getLoadingText());
            d.dialog("option", "buttons", [{
                text: "Start",
                click: function(){
                    closeDialog();
                }
            }]);
        }
    }

    /**
     * Execute the last steps before the game is started, but after the user clicked on Start.
     */
    function startGame() {
        enablePanZoom();
        pz.zoom(2, true);
        pz.center();
        enableNavActions();
        setTip(helpTextStart);
    }

    /**
     * Show a jquery-ui dialog which shows the user the status of the current load state.
     * This consists of some parallel tasks.
     * The text is updated after several events.
     */
    function showLoadingScreen(){
        showDialog("Loading", getLoadingText(), [], []);
    }

    /**
     * Updates the loading screen to show the current status of all parallel tasks.
     */
    function updateLoadingScreen() {
        if(!loadingComplete) {
            $("#dialog").html(getLoadingText());
        }
    }

    /**
     * Creates a html text which should be displayed in the loading screen, a jquery-ui dialog.
     * @return {String} a html string.
     */
    function getLoadingText() {
        return '<div id="loading-map-text"><div style="float:left;">Loading map ... ' +
                (mapLoad ? 'done.</div>' : '</div><div class="spinner"></div>') + '</div><br/>' +
                '<div id="loading-countries-text"><div style="float:left;">Loading countries ... ' +
                (countriesLoad ? 'done.</div>' : '</div><div class="spinner"></div>') + '</div><br/>' +
                '<div id="loading-game-text"><div style="float:left;">' +
                ((mapLoad && countriesLoad) ? 'Loading game ... ' +
                    (loadingComplete ? 'done.</div>' : '</div><div class="spinner"></div>') : '</div>') +
                '</div>';
    }

    /**
     * Show an end screen dialog with information for the user and prompt him
     * to visit the map again, view statistics or play again.
     */
    function showEndScreen() {
        endScreenOpen = true;
        var text = "You finished the game with <b>" + hopCount +" hops</b>.<br/><br/><b>What you can do now</b><br/><ul>"
                + "<li>View all unlocked properties as bar charts</li>"
                + "<li>Go back to the map and see your unlocked properties</li>"
                + "<li>Play again</li></ul><br/>To reopen this dialog, click on 'Continue' in the bottom navigation.";

        var bTexts = ["View data", "Visit map", "Play again"];
        // handler for first button: view data
        var chartFun = function() {
            closeDialog();
            var es = $("#endScreen");
            es.html(canvasString);
            es.prop("title", "All unlocked properties");
            es.dialog({
                width: 850,
                height: 600,
                modal:true,
                autoOpen: true,
                beforeClose: function() {
                    var es = $("#endScreen");
                    es.html("");
                    es.dialog("destroy");
            }});
            drawCharts(prepareProperties());
            drawCurrentJourney();
        };
        // handler for third button: play again
        var newGame = function(){
            closeDialog();
            var d = $("#dialog");
            d.html("If you start a new game, you are not able to watch your statistics or the current map anymore.<br/><br/>Continue?");
            d.prop("title", "Warning");
            var destroy = function() {
                var d = $("#dialog");
                d.html("");
                d.dialog("destroy");
            };
            d.dialog({
                modal:true,
                beforeClose: destroy,
                autoOpen: true,
                buttons: [
                    {
                        text: "Yes",
                        click: function() {
                            destroy();
                            setupGame();
                        }
                    },
                    {
                        text: "No",
                        click: destroy
                    }
                ]
            });
        };
        showDialog("Congratulations ${userName}!", text, bTexts, [chartFun, function() {
            closeDialog();
            drawCurrentJourney();
        }, newGame]);
    }

    /**
     * Creates all charts for the used properties in an invisible div to show them in a popup.
     * @param {Array} data - the prepared data for creating the charts. An array of objects.
     * Each objects need to have a name and an array 'values'. In values each object need to have a
     * 'country' and a 'value'.
     */
    function drawCharts(data) {
        for(var i = 0; i < data.length; i++) {
            var values = data[i].values;
            var canvas = $("#att"+i);
            if(values.length ===0) {
                canvas.remove();
            } else {
                var name = data[i].name;
                canvas.before("<h2>"+name+"</h2>");
                var labels = [];
                var vals = [];
                for(var j = 0; j < values.length; j++) {
                    labels.push(values[j].country);
                    vals.push(values[j].value);
                }
                var attData = {
                    labels: labels,
                    datasets: [
                        {
                            fillColor : "#48A497",
                            strokeColor : "#48A4D1",
                            data : vals
                        }
                    ]
                };
                var att = document.getElementById("att"+i).getContext("2d");
                new Chart(att).Bar(attData);
            }
        }
    }

    /**
     * Draws the path from start to goal country when the game is finished as a set of svg line elements
     * in a changing color. The starting color is blue and it fades to red in the goal country.
     * Also is each country a circle is drawn at point near the center of its country (random deviation).
     */
    function drawCurrentJourney() {
        if(journeyDrawn) {
            return;
        }
        journeyDrawn = true;
        // compute colors
        var colors = [];
        for(var i = 0; i < currentJourney.length; i++) {
            var cof1 = i / (currentJourney.length);
            var cof2 = 1 - cof1;
            var c = Snap.rgb(cof1 * 255, 0, cof2 * 255);
            colors.push(c);
        }
        // compute position for start country
        var s = Snap.select("#"+currentJourney[0]);
        var start = s._.bbox;
        var sX = ((start.width / 3) * (Math.random() - 0.5)) + start.cx;
        var sY = ((start.height / 3) * (Math.random() - 0.5)) + start.cy;

        var lastX = sX;
        var lastY = sY;
        for(i = 1; i < currentJourney.length; i++) {
            // compute position of each visited country in path
            var h = Snap.select("#"+currentJourney[i]);
            var hop = h._.bbox;
            var hX = ((hop.width / 3) * (Math.random() - 0.5)) + hop.cx;
            var hY = ((hop.height / 3) * (Math.random() - 0.5)) + hop.cy;
            // draw circle and line in country
            specJourney.push(snapParent.line(lastX, lastY, hX, hY)
                    .attr({fill: "#000", stroke: colors[i], strokeWidth: 16}));
            specJourney.push(snapParent.circle(lastX, lastY, 32)
                    .attr({fill: "#000", stroke: colors[i], strokeWidth: 16}));
            specJourney.push(snapParent.circle(hX, hY, 32)
                    .attr({fill: "#000", stroke: colors[i], strokeWidth: 16}));
            lastX = hX;
            lastY = hY;
        }
        // draw circle of start country
        specJourney.push(snapParent.circle(sX, sY, 32)
                .attr({fill: "#000", stroke: colors[0], strokeWidth: 16}));
    }

    /**
     * Show a dialog with given title, text and buttons.
     * The buttons are created with the last parameters: Each button title should correspond to a handler.
     * @param {String} title - title of the dialog.
     * @param {String} text - content of the dialog. Could be html code.
     * @param {Array} buttonTexts - an array of button titles as Strings.
     * @param {Array} buttonHandlers - an array of functions which are added as click listeners to the buttons.
     */
    function showDialog(title, text, buttonTexts, buttonHandlers) {
        if(buttonTexts.length === undefined
                || buttonHandlers.length === undefined
                || buttonTexts.length !== buttonHandlers.length) {
            throw new Error("Button texts and handlers doesn't match.");
        }
        var d = $("#dialog");
        d.attr("title", title);
        d.html(text);
        var buttons = [];
        for(var i = 0; i < buttonTexts.length; i++) {
            var b = {};
            b.text = buttonTexts[i];
            b.click = buttonHandlers[i];
            buttons.push(b);
        }
        d.dialog({
            autoOpen: true,
            modal: true,
            width: 600,
            beforeClose: closeDialog,
            buttons: buttons
        });
    }

    /**
     * Close the current dialog and destroy all content.
     * If the game was finished, enable the free mode.
     * It is used in the button handlers of the dialog.
     */
    function closeDialog() {
        var d = $("#dialog");
        d.dialog("destroy");
        d.attr("title", "");
        d.html("");
        if(finished) {
            // end screen is closed
            $("#continue-button").css("visibility", "visible");
            radarVisible = true;
            specSwitch.bootstrapSwitch('state', true, true, false);
            toggleView();
        } else {
            // loading screen is closed
            if(loadingComplete){
                startGame();
            } else {
                // loading is not completed show screen again to prevent user to interact with game too early
                showLoadingScreen();
            }
        }
    }

    /**
     * Takes all unlocked properties of all countries and store them in a new object.
     * @return {Array} - an array of objects with property name ('name') and values for all countries ('values').
     * 'values' is an sorted array of objects with the country name ('country') and its value for that property ('value').
     */
    function prepareProperties() {
        var refactoredProps = [5];
        for(var i = 0; i < 5; i++) {
            refactoredProps[i] = {name: getCountry(goalCountry).properties[i].name, values: []};
        }
        for(i = 0; i < countries.length; i++) {
            if(countries[i].properties.length === 0) {
                continue;
            }
            for(var j = 0; j < 5; j++) {
                var p = countries[i].properties[j];
                if(p.visible) {
                    var name = countries[i].shortName ? countries[i].shortName : countries[i].name;
                    refactoredProps[j].values.push({country: name, value: parseFloat(p.value)});
                }
            }
        }
        for(i = 0; i < 5; i++) {
            refactoredProps[i].values.sort(function(a, b) {
                return a.value < b.value ? 1 : -1;
            });
        }
        return refactoredProps;
    }

    /**
     * Loads the map and all countries with its properties and values with ajax.
     * @param {Function} callback - is called after this function is finished.
     */
    function load(callback) {
        loadMap(callback);
        loadCountries(callback);
    }

    /**
     * Loads and creates the map as well as the viewport container for the game.
     * When this is finished, initLister(callback) is called.
     * @param {Function} callback - delegated to iniListener
     */
    function loadMap(callback) {
        snapObj = Snap("#mapContainer");
        var group = snapObj.group();
        Snap.load("${createLink([controller: "data", action: "map", absolute: true])}", onSVGLoaded ) ;
        function onSVGLoaded( data ){
            group.append( data );

            var drawnMap = $("#mapContainer");
            // handler to stop panning the map beyond its borders in the viewport
            var beforePan = function(oldPan, newPan){
                var stopHorizontal = false
                        , stopVertical = false
                        , gutterWidth = drawnMap.width() + 4
                        , gutterHeight = drawnMap.height() + 4
                // Computed variables
                        , sizes = this.getSizes()
                        , leftLimit = -((sizes.viewBox.x + sizes.viewBox.width) * sizes.realZoom) + gutterWidth
                        , rightLimit = sizes.width - gutterWidth - (sizes.viewBox.x * sizes.realZoom)
                        , topLimit = -((sizes.viewBox.y + sizes.viewBox.height) * sizes.realZoom) + gutterHeight
                        , bottomLimit = sizes.height - gutterHeight - (sizes.viewBox.y * sizes.realZoom);
                var customPan = {};
                customPan.x = Math.max(leftLimit, Math.min(rightLimit, newPan.x));
                customPan.y = Math.max(topLimit, Math.min(bottomLimit, newPan.y));
                return customPan
            };

            pz = window.panZoom = svgPanZoom('#mapContainer', {
                controlIconsEnabled: false
                , dblClickZoomEnabled: false
                , minZoom: 2
                , maxZoom: 100
                , beforePan: beforePan
            });
            pz.center();
            radarGroup = snapObj.group();
            disablePanZoom();

            $(window).resize(function() {
                pz.resize();
                pz.updateBBox();
            });

            mapLoad = 1;
            // continue with listeners
            initListener(callback);
        }
    }

    /**
     * Loads all countries with their properties and values and prepare them for the game.
     * When this is finished, initLister(callback) is called.
     * @param {Function} callback - delegated to iniListener
     */
    function loadCountries(callback) {

        var link = "${createLink([controller: "data", action: "cachedCountries"])}";
        <g:each in="${p}" var="it" status="i">
        <g:if test="${i==0}">
        link += "?p1=${p[i]}";
        </g:if><g:else>
        link += "&p${i+1}=${it}";
        </g:else>
        </g:each>
        $.ajax({
            url: link
        }).done(function(map) {
            initCountries(map, callback);
        });
    }

    /**
     * Set up and prepare all countries for the game:
     * Normalized values are created and all countries are stored in 'countries' array.
     * When this function is finished, initLister(callback) is called.
     * @param {Array} c - countries array
     * @param {Function} callback - delegated to iniListener
     */
    function initCountries(c, callback) {
        countries = c;
        // normalize values
        for(var p = 0; p < 5; p++) {
            var pMin = Number.MAX_VALUE;
            var pMax = Number.MIN_VALUE;
            for(var i = 0; i < countries.length; i++) {
                if(!countries[i].properties || countries[i].properties.length == 0) {
                    // skip countries, which have no properties (not all countries of the map are part of the game).
                    continue;
                }
                // get min/max value for every property in every country
                var val = parseFloat(countries[i].properties[p].value);
                pMin = Math.min(pMin, val);
                pMax = Math.max(pMax, val);
            }
            for(i = 0; i < countries.length; i++) {
                if(!countries[i].properties || countries[i].properties.length == 0) {
                    // skip countries, which have no properties (not all countries of the map are part of the game).
                    continue;
                }
                countries[i].properties[p].nValue = (parseFloat(countries[i].properties[p].value) - pMin) / (pMax - pMin);
            }
        }
        // continue with listeners
        countriesLoad = 1;
        initListener(callback);
    }

    /**
     * Set up the click listener for each country and compute dimension of them for later usage.
     * When this function is finished, callback() is called.
     * @param {Function} callback - is called at the end
     */
    function initListener(callback) {
        updateLoadingScreen();
        if(mapLoad !== 1 || countriesLoad !== 1) {
            // barricade, wait for all resources to continue
            return;
        }
        // needs to be done, when the map is loaded: get container on which the neighbor network is drawn
        snapParent = Snap.select("#"+countries[0].code).parent().parent();

        for(var i = 0; i < countries.length; i++) {
            var pathIds = countries[i].mapIds;
            // pre compute the position of a country as average of its paths
            // as well as the combined bounding box of all the country parts
            var avgX = 0, avgY = 0, minX = Number.MAX_VALUE, maxX = 0, minY = Number.MAX_VALUE, maxY = 0;
            for (var j = 0; j < pathIds.length; j++) {
                var path = Snap.select("#" + pathIds[j]);
                var pathBox = path.getBBox();
                avgX += pathBox.cx;
                avgY += pathBox.cy;
                minX = Math.min(minX, pathBox.x);
                maxX = Math.max(maxX, pathBox.x2);
                minY = Math.min(minY, pathBox.y);
                maxY = Math.max(maxY, pathBox.y2);
            }
            countries[i].x = (avgX / pathIds.length);
            countries[i].y = (avgY / pathIds.length);
            // zoom level for each country
            countries[i].zoom = zoomValue(maxY - minY);
            // add an event listener to every path/polygon of each active country in the svg map
            for (j = 0; j < pathIds.length; j++) {
                path = $("#" + pathIds[j]);
                var name = countries[i].name;
                if (name.indexOf("!") !== 0) {
                    path.click(countries[i], countryListener);
                }
            }
        }
        var map = $("#Europakarte");
        map.mousedown(function(){if(pz !== undefined){lastViewportPos=pz.getPan();}});
        callback();
    }

    /**
     * Highlight the clicked country or zoom to it, dependant in which mode the user is.
     * Is attached to every country path element which is part of the game (not the grey ones).
     * @param {Event} event - the click event
     */
    function countryListener(event) {
        // skip the action if the map is moved between mousedown and mouseup to give the feeling of a real click event.
        // otherwise the action is triggered each time the user moves the map by dragging a country and not outside of a
        // country i.e. the ocean.
        if(pz === undefined
                || lastViewportPos === undefined
                || lastViewportPos.x !== pz.getPan().x
                || lastViewportPos.y !== pz.getPan().y) {
            return;
        }
        // for the user to navigate in the map or view properties; it is not meant to be a hop
        var code = event.data.code;
        if(code === specCountry) {
            viewCountry(code);
        } else {
            setSpecCountry(code);
            var country = getCountry(code);
            var nb = country.neighbors;

            for(var i = 0; i < nb.length; i++) {
                var n = getCountry(nb[i]);
                specNetwork.push(snapParent.line(country.x, country.y, n.x, n.y)
                        .attr({fill: "#000", stroke: "#FF0", strokeWidth: 16}));
                specNetwork.push(snapParent.circle(n.x, n.y, 32)
                        .attr({fill: "#000", stroke: "#FF0", strokeWidth: 16}));
            }
            specNetwork.push(snapParent.circle(country.x, country.y, 32)
                    .attr({fill: "#FF0", stroke: "#FF0", strokeWidth: 16}));
            setTip(helpTextNeighbors);
        }
    }

    /**
     * Creates a explaining text for a tooltip after a hop to a country.
     * @param {String} origin - name of the country before the hop
     * @param {String} dest - name of the country after the hop
     * @param {String} prop - name of the property used for the hop
     * @param {Boolean} direction - boolean value: If non falsy, decrease is assumed as direction, increase otherwise.
     */
    function createHopHelpText(origin, dest, prop, direction) {
        var s = direction ? "smaller" : "greater";
        return "The " + prop + " of " + dest + " was " + s + " than the " + prop + " of " + origin + ".<br/>Therefore you hopped to "
                + dest + "!<br/><br/>There might be other neighbors of " + origin + " which also have a " + s + " " + prop
                + " than " + origin + ", but their difference of both values is greater than the " + prop
                + " difference of " + origin + " and " + dest
                + ".<br/><br/>You can turn off this tip anytime using the switch below."

    }

    /**
     * Creates a path from a random start country with a random length in the given interval.
     * The path is build up from hop to hop by using random option choices.
     * If in one step there is no neighbor country, to jump to
     * (because it could be not possible with the chosen option to jump any further) the path is back tracked
     * and another option is chosen instead until the path reaches the desired length.
     * @param {Number} minLen - minimum length of the part. Needs to be smaller or equal maxLen.
     * @param {Number} maxLen - maximum length of the part. Needs to be greater or equal minLen.
     * @return {Object} - codes of the start and goal country.
     */
    function getJourney(minLen, maxLen) {
        var start, opt, path, pathLen, next, last;
        while(start === undefined) {
            var r = parseInt(Math.random() * (countries.length));
            start = countries[r];
            if(start.name.indexOf("!") === 0) {
                // country is not part of the game
                start = undefined;
            }
        }
        pathLen = parseInt(Math.random() * (maxLen - minLen) + minLen);
        path = [];
        path.push({node: start, options: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]});
        var oIdx;
        while(path.length < pathLen) {
            if(path.length === 0) {
                console.log("No path in countries found! Start was " + start.name + " (" + start.code + ") retry ...");
                return getJourney(minLen, maxLen);
            }
            last = path[path.length - 1];
            if(last.options.length === 0) {
                //go back
                path.pop();
                continue;
            }
            do {
                opt = parseInt(Math.random() * 10);
                oIdx = last.options.indexOf(opt);
            } while(oIdx === -1);
            // remove chosen option from list
            last.options.splice(oIdx, 1);
            next = getNextCountry(oIdx, last.node.code);
            if(!next) {
                //option not possible, continue with current node without this option
                continue;
            }
            // check occurrence in path to avoid circles in path
            var found = false;
            for(var i = 0; i < path.length; i++) {
                if(path[i].node.code === next) {
                    found = true;
                    break;
                }
            }
            if(found) {
                // skip if country is already in path
                continue;
            }
            path.push({node: getCountry(next), options: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]});
        }
        if(path[path.length - 1].node.neighbors.indexOf(start.code) !== -1) {
            // repeat building path if start country is a direct neighbor of the goal country.
            console.log("start country is neighbor of goal country, retry ...");
            return getJourney(minLen, maxLen);
        }
        return {start: start.code, goal: path[path.length - 1].node.code};
    }

    /**
     * Switch the current country with a hop to the next and changes tooltips.
     * Is used as a handler for the radar option buttons.
     * @param {Event} event - the mouse click event.
     */
    function nextHop(event) {
        var id = parseInt(event.data);
        var next = getNextCountry(id, currentCountry);
        var index = id % 5;
        if(next === null) {
            hopCount++;
            var d = $("#dialog");
            d.html("This hop is not possible, because there is no country with a " + (id < 5 ? "smaller" : "greater") +
                    " property.<br/>Anyway, this is counted as a hop.<br/><br/>Choose another property!");
            d.prop("title", "Not possible");
            d.dialog({modal: true, beforeClose: function() {
                var d = $("#dialog");
                d.html("");
                d.dialog("destroy");
            }});
            setTip("Oops, there is no neighbor with a "+(id < 5 ? "smaller" : "greater")+" property value.<br/><br/>Just try another property!");
            return;
        }
        if(next === undefined) {
            throw new Error("No candidate found!");
        }

        var cCountry = getCountry(currentCountry);
        var nCountry = getCountry(next);

        if(firstHop) {
            firstHop = false;
        } else {

            helpTextSecondHop = createHopHelpText(
                    cCountry.shortName ? cCountry.shortName : cCountry.name,
                    nCountry.shortName ? nCountry.shortName : nCountry.name,
                    nCountry.properties[index].name,
                    id < 5);
            setTip(helpTextSecondHop);
        }

        cCountry.properties[index].visible = true;
        nCountry.properties[index].visible = true;
        currentJourney.push(nCountry.code);
        hopCount++;
        setCurrentCountry(next);
        viewCurrent();
    }

    /**
     * Returns the country for the next hop in the game if there is a good candidate.
     * A candidate is a country, in which the value of the chosen property differs strict in
     * the chosen direction from the value of the property of the given country.
     * A good candidate has the smallest difference in the mentioned values.
     * If this exists, it is returned. If not, there are two possible explanations:
     * 1) This country has no neighbor with a value smaller/greater than the country value for
     * this property. But there is another property with some option (decrease/increase)
     * for which a hop is possible. In this case null is returned.
     * 2) There is no option for any hop to a next country for all current properties.
     * In this case a bad candidate as the next country is returned.
     * This is a country in which the chosen property value equals the origin property value.
     * If there are more than one bad candidates, one is random chosen.
     * If there are no bad candidates, undefinden is returned.
     *
     * @param {Number} buttonId - option id. 0 to 4 is property 0 to 4 and the user wants to decrease the value.
     * 5 to 9 is property 0 to 4 and the user wants to increase the value.
     * @param {String} code - code of the country from where to hop
     * @return {String} code of next country ornull/undefined, see above.
     */
    function getNextCountry(buttonId, code) {
        var country = getCountry(code);
        var index = buttonId % 5;
        var val = parseFloat(country.properties[index].value);
        var lists = getCandidates(buttonId, country, val);

        var candidates = lists.candidates;
        var min = Number.MAX_VALUE;
        var best;
        if(candidates.length > 0) {
            // there are candidates, look for the one with the smallest difference
            for(i = 0; i < candidates.length; i++) {
                var cVal = parseFloat(candidates[i].properties[index].value);
                var dist = Math.abs(val - cVal);
                if(dist < min || (dist === min && Math.random() >= 0.5)) {
                    min = dist;
                    best = candidates[i].code;
                }
            }
        } else {
            // no neighbor is found for the desired change, check whether any change is possible
            for(var i = 0; i < 10; i++) {
                if(i === buttonId) {
                    // skip original check
                    continue;
                }
                lists = getCandidates(i, country, val);
                if(lists.candidates.length > 0) {
                    // it is possible for some property in some direction to continue the journey, but not the chosen one
                    return null;
                }
            }
            // it is not possible with any property in any direction to continue journey,
            // take random neighbor with equal value of property
            if(equals.length > 0) {
                best = equals[parseInt(Math.random() * (equals.length))];
            } else {
                // should not be possible, serious shit otherwise ;)
                return undefined;
            }
        }
        return best;
    }

    /**
     * Helper function to get all possible candidates for a next hop
     * in a given country with a given option the user might click.
     * @param {Number} propId - the id of the option. 0 to 4 is property 0 to 4 and the user wants to decrease the value.
     * 5 to 9 is property 0 to 4 and the user wants to increase the value.
     * @param {String} country - code of the current country, from where to jump
     * @param {Number} val - value of the chosen property of the current country.
     * @return {Object} - two lists of country objects from the countries array.
     * The first list 'candidates' contains all countries such that the property value differ strict in the desired direction.
     * The second list 'equals' contains all countries such that the property value equals the value of the given country.
     */
    function getCandidates(propId, country, val){
        var decrease = true;
        if(propId >= 5) {
            decrease = false;
            propId -= 5;
        }

        var nbs = country.neighbors;
        var candidates = [];
        var equals = [];

        for(var i = 0; i < nbs.length; i++) {
            var nb = getCountry(nbs[i]);

            if(nb.name.indexOf("!") === 0) {
                //skip disabled countries
                continue;
            }
            var nVal = parseFloat(nb.properties[propId].value);
            if((decrease && nVal < val) || ((!decrease) && nVal > val)) {
                candidates.push(nb);
            } else {
                if(nVal === val) {
                    equals.push(nb.code);
                }
            }
        }
        return {candidates: candidates, equals: equals}
    }

    /**
     * Draw a radar plot in the center of the map for the given country.
     * If the country is the current country, arrow buttons for the options are drawn
     * for user interaction. For all visible (unlocked) properties a point is drawn in the plot.
     * It has a mouseover listener to show the actual value of the property.
     * Properties are unlocked in the game by the user if he uses them.
     * @param {String} countryCode - code of the country.
     */
    function drawRadar(countryCode) {
        var vp = pz.getSizes();
        var country = getCountry(countryCode);
        var p = country.properties;
        var con = $("#mapContainer");
        var w = con.width();
        var h = con.height();

        radar(
                snapObj,
                radarGroup,
                w / 2,
                h / 2,
                h / 8,
                [p[0].name, p[1].name, p[2].name, p[3].name, p[4].name],
                [p[0].nValue, p[1].nValue, p[2].nValue, p[3].nValue, p[4].nValue],
                [p[0].visible, p[1].visible, p[2].visible, p[3].visible, p[4].visible],
                90,
                nextHop,
                countryCode===currentCountry && !finished,
                [p[0].value, p[1].value, p[2].value, p[3].value, p[4].value]);
    }

    /**
     * Set the current tutorial tooltip and shows it if the tutorial mode is turned on.
     * This method should be called whether tutorial mode is turned on or off
     * to store the text. This way the text is shown when the tutorial mode is turned on again.
     * @param {String} tip - the text to display in the tooltip. Could be html code.
     */
    function setTip(tip) {
        tutHelpText = tip;
        if(tutModeOn && tutHelpText){
            tutorial.attr('data-original-title', tip);
            tutorial.tooltip('fixTitle');
            tutorial.tooltip('show');
            tutorial.on("hidden.bs.tooltip", function() {
                if(tutModeOn) {
                    tutorial.tooltip("show");
                }
            });
        }
    }

    /**
     * Turn on or off the tutorial mode which shows tooltips to the user understand the game.
     */
    function toggleTutorial() {
        tutModeOn = !tutModeOn;
        if(tutModeOn) {
            tutorial.tooltip();
            setTip(tutHelpText);
        } else {
            tutorial.tooltip("destroy");
        }
    }

    /**
     * Switch between spectator mode or back, depending on the current state.
     * Is used by the checkbox in the navigation bar and might be invoked by the user.
     */
    function toggleView() {
        disableNavActions();
        if(radarVisible) {
            $("#spec-country-label").html("None");
            highlightNone(specCountry);
            highlightCurrent(currentCountry);
            highlightGoal(goalCountry);
            radarGroup.clear();
            animatedZoom(2, 100, function() {
                enablePanZoom();
                radarVisible = false;
                enableNavActions();
            });
        } else {
            viewCurrent(true);
        }
    }


    /**
     * Set given country as goal country. There is no highlighting applied.
     * @param {String} code - code of country
     */
    function setGoalCountry(code) {
        goalCountry = code;
        var c = getCountry(code);
        if(c.shortName) {
            $("#goal-country-label").html(getCountry(code).shortName);
        } else {
            $("#goal-country-label").html(getCountry(code).name);
        }
    }

    /**
     * Set given country as current country. The highlighting is redrawn in this order:
     * spectated country - no highlighting,
     * current country - blue,
     * goal country - red
     * The last drawing is the topmost visible one.
     *
     * Also this function set finish to true iff the current country is the goal country.
     * @param {String} code - code of country
     */
    function setCurrentCountry(code) {
        highlightNone(currentCountry);
        currentCountry = code;
        var c = getCountry(code);
        if(c.shortName) {
            $("#current-country-label").html(getCountry(code).shortName);
        } else {
            $("#current-country-label").html(getCountry(code).name);
        }
        highlightCurrent(code);
        highlightGoal(goalCountry);
        finished = goalCountry === currentCountry;
    }

    /**
     * Set given country as spectated country. The highlighting is redrawn in this order:
     * current country - blue,
     * goal country - red
     * spectated country - yellow
     * The last drawing is the topmost visible one.
     * @param {String} code - code of country
     */
    function setSpecCountry(code) {
        highlightNone(specCountry);
        specCountry = code;
        var c = getCountry(code);
        if(c.shortName) {
            $("#spec-country-label").html(getCountry(code).shortName);
        } else {
            $("#spec-country-label").html(getCountry(code).name);
        }
        highlightCurrent(currentCountry);
        highlightGoal(goalCountry);
        highlightSpec(code);
    }

    /**
     * Zoom to the desired country. Before the animation, all navigation options are disabled.
     * After the animation all navigation options are enabled and the radar plot is drawn for the country.
     * If the game is won, the end sequence is called.
     * @param {String} country - code of the country
     */
    function viewCountry(country) {
        specSwitch.bootstrapSwitch('state', false, true, false);
        disableNavActions();
        if(radarVisible) {
            // just remove radar, panZoom is still disabled
            radarGroup.clear();
        } else {
            disablePanZoom();
        }
        panToCountry(country, function() {
            enableNavActions();
            if(!finished || endScreenOpen) {
                drawRadar(country);
                radarVisible = true;
                if(country === currentCountry) {
                    if(firstHop) {
                        setTip(helpTextArrow);
                    } else {
                        setTip(helpTextSecondHop);
                    }
                }
            } else {
                showEndScreen();
                setTip("You won!");
            }
        });
    }

    /**
     * Remove highlighting for spectated country, redraw the current and goal highlighting,
     * zoom to the goal country and show the radar plot.
     */
    function viewGoal() {
        if(!inAnimation) {
            $("#spec-country-label").html("None");
            highlightNone(specCountry);
            highlightCurrent(currentCountry);
            highlightGoal(goalCountry);
            viewCountry(goalCountry);
        }
    }

    /**
     * Remove highlighting for spectated country, redraw the current and goal highlighting,
     * zoom to the current country and show the radar plot.
     * This function does nothing if inAnimation is true.
     * @param {Boolean} fromSpecSwitch - if true, inAnimation is ignored.
     */
    function viewCurrent(fromSpecSwitch) {
        if(!inAnimation || fromSpecSwitch) {
            $("#spec-country-label").html("None");
            highlightNone(specCountry);
            highlightCurrent(currentCountry);
            highlightGoal(goalCountry);
            viewCountry(currentCountry);
        }
    }

    /**
     * Redraw the current and goal highlighting, zoom to the spectated country and show the radar plot.
     */
    function viewSpec() {
        if(!inAnimation && specCountry) {
            highlightCurrent(currentCountry);
            highlightGoal(goalCountry);
            viewCountry(specCountry);
        }
    }

    /**
     * Enables all options in the navigation bars for the user. Buttons and links concerning the game are disabled.
     */
    function enableNavActions() {
        inAnimation = false;
        specSwitch.bootstrapSwitch('readonly', false, true);
        tutSwitch.bootstrapSwitch('readonly', false, true);
    }

    /**
     * Disables all options in the navigation bars for the user. Buttons and links concerning the game are disabled.
     */
    function disableNavActions() {
        inAnimation = true;
        specSwitch.bootstrapSwitch('readonly', true, true);
        tutSwitch.bootstrapSwitch('readonly', true, true);
    }

    /**
     * Enables the option for the user to pan and zoom the map. API calls of zoom() or pan() are not affected.
     */
    function enablePanZoom() {
        pz.enablePan();
        pz.enableZoom();
    }

    /**
     * Disables the option for the user to pan and zoom the map. API calls of zoom() or pan() are not affected.
     */
    function disablePanZoom() {
        pz.disablePan();
        pz.disableZoom();
    }


    /**
     * Sets the stroke to red and width 20 of the desired element.
     * Is used for draw a colored border around a country to indicates it as the goal country.
     * @param {String} code - country code, its path id in the svg
     */
    function highlightGoal(code) {
        var path = getHighlightPath(code);
        path.css("stroke", "#ff0000");
        path.css("stroke-width", "20");
    }

    /**
     * Sets the stroke to blue and width 20 of the desired element.
     * Is used for draw a colored border around a country to indicates it as the current country.
     * @param {String} code - country code, its path id in the svg
     */
    function highlightCurrent(code) {
        var path = getHighlightPath(code);
        path.css("stroke", "#0000ff");
        path.css("stroke-width", "20");
    }

    /**
     * Sets the stroke to yellow and width 20 of the desired element.
     * Is used for draw a colored border around a country to indicates it as the current spectated country.
     * @param {String} code - country code, its path id in the svg
     */
    function highlightSpec(code) {
        var path = getHighlightPath(code);
        path.css("stroke", "#ffff00");
        path.css("stroke-width", "20");
    }

    /**
     * Sets the stroke to white and width 2 of the desired element.
     * Is used for removing the color of a countries border.
     * @param {String} code - country code, its path id in the svg
     */
    function highlightNone(code) {
        if(code === specCountry) {
            while(specNetwork.length > 0) {
                specNetwork.pop().remove();
            }
            specCountry = undefined;
        }
        var path = getHighlightPath(code);
        path.css("stroke", "#ffffff");
        path.css("stroke-width", "2");
    }

    /**
     * Returns an element returned by a jQuery selector for this id.
     * Also tries to get get the element with a snap selector,
     * removes and reinsert the element.
     * Is used for redrawing of countries to show its stroke correct.
     * @param {String} code - id for element
     */
    function getHighlightPath(code) {
        var path = Snap.select("#"+code);
        if(path) {
            var parent = path.parent();
            path.remove();
            parent.add(path);
        }
        return $("#"+code);
    }


    /**
     * Animate to a given country code. Use callback, if you want to do something after this call!
     * First the view is zoomed out, the the view is panned to the country and at last the view ist zoomed in again.
     * @param {String} code - the code of the desired country.
     * @param {Function} callback (optional) - is called as a function when the animation is done.
     */
    function panToCountry(code, callback) {
        var country = getCountry(code), x, y;
        if(country) {
            x = country.x;
            y = country.y;
        }
        if(x && y) {
            // first pan to counrty
            pan(x, y, 200, function() {
                // second zoom to country
                animatedZoom(parseFloat(country.zoom), 100, function(){
                    // pan again, because zoom might moved the country out of the center
                    pan(x, y, 0, callback);
                });
            });
        }
    }



    /**
     * Get the country object from its country code in countries array.
     * @param {String} code - the countries code.
     * @return {Object} the country object or undefined, if code does not exist in countries.
     */
    function getCountry(code) {
        for(var i = 0; i < countries.length; i++) {
            if(countries[i].code === code) {
                return countries[i];
            }
        }
        return undefined;
    }


    /**
     * An animated pan to a real point (of countries paths).
     * Takes current pan, zoom and width of the frame into account.
     * @param {Number} x - x coordinate of desired point.
     * @param {Number} y - y coordinate of desired point.
     * @param {Number} animationTime - optional, duration of animation. If falsy value, pan is not animated.
     * @param {Function} callback - optional, is called after the animation.
     */
    function pan(x, y, animationTime, callback) {
        var frameW = $("#mapContainer").width();
        var vp = pz.getSizes();
        var panX = -(x * vp.realZoom) + (frameW / 2);
        var panY = -(y * vp.realZoom) + (vp.height / 2);
        if(animationTime) {
            var pan = pz.getPan();
            animatedPanBy({x: panX - pan.x, y: panY - pan.y}, animationTime, callback);
        } else {
            //without animation
            pz.pan({x: panX, y: panY});
            if(callback) {
                callback();
            }
        }
    }

    /**
    * Animated pan on pz object.
    * @param {Object} amount - amount to pan, object with x,y.
    * @param {Number} animationTime - optional, time in ms. Default is 100 ms.
    * @param {Function} callback - optional, is called after the animation.
    */
    function animatedPanBy(amount, animationTime, callback){
        animationTime = animationTime || 100;
        var animationStepTime = 15
                , animationSteps = animationTime / animationStepTime
                , animationStep = 0
                , intervalID = null
                , stepX = amount.x / animationSteps
                , stepY = amount.y / animationSteps;

        intervalID = setInterval(function(){
            if (animationStep++ < animationSteps) {
                pz.panBy({x: stepX, y: stepY});
            } else {
                // Cancel interval
                clearInterval(intervalID);
                if(callback !== undefined) {
                    callback();
                }
            }
        }, animationStepTime);
    }

    /**
     * Animated zoom on pz object.
     * @param {Number} scale - desired absolute scale to zoom to.
     * @param {Number} animationTime - time in ms.
     * @param {Function} callback - optional, is called after the animation.
     * @param {Number} animationStepTime - optional, time each iteration takes. Default is 5ms.
     */
    function animatedZoom(scale, animationTime, callback, animationStepTime){
        animationStepTime = animationStepTime || 10; // default is 5ms
        var animationSteps = animationTime / animationStepTime
                , animationStep = 0
                , intervalID = null
                , currentScale = pz.getZoom()
                , step = Math.pow((scale / currentScale), (1 / animationSteps));
        intervalID = setInterval(function(){
            if (animationStep++ < animationSteps) {
                pz.zoomBy(step);
            } else {
                // Cancel interval
                clearInterval(intervalID);
                if(callback !== undefined) {
                    callback();
                }
            }
        }, animationStepTime);
    }

    /**
     * Create the zoom value for a country, given its height.
     * @param {Number} x - country height.
     */
    function zoomValue(x){
        //original was y=2727x^(-0,931)
        return Math.pow(parseFloat(x), -0.931) * 3700;
    }

    /**
     * For debugging purposes only. Each country is checked,
     * whether all neighbors also have that country in its neighbor list.
     */
    function testNeighborsSymmetry() {
        for(var i = 0; i < countries.length; i++) {
            var nb = countries[i].neighbors;
            if(nb) {
                var code = countries[i].code;
                for(var nbi = 0; nbi < nb.length; nbi++) {
                    var nbc = getCountry(nb[nbi]);
                    if(!nbc) {
                        console.debug("false nb id="+nb[nbi]+", country="+code);
                    }
                    var nnb = nbc.neighbors;
                    if(!nnb) {
                        console.debug(nbc.name + " (" + nbc.code + ") has no neighbors, but its in the list of "+countries[i].name + " ("+countries[i].code+")");
                        continue;
                    }
                    var found = false;
                    for(var j = 0; j < nnb.length; j++) {
                        if(nnb[j]===code) {
                            found = true;
                            break;
                        }
                    }
                    if(!found) {
                        console.debug("no symmetry for country="+code+" with nb="+nbc.code);
                    }
                }
            }
        }
        console.debug(countries)
        console.debug("finished symmetry check");
    }

</script>
</body>

</html>
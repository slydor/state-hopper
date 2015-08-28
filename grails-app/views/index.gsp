<!DOCTYPE html>
<html>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
	<meta name="layout" content="main">
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
            </ul>
        </div>
	</div>
</nav>
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <h1>Welcome to State Hopper!</h1>
            <h3>State Hopper is an interactive multimedia application, in which you can test your knowledge about the worlds countries.</h3>
            <h3>Click the image below to start or read the short introduction underneath the image first!</h3>
            <br>
            <a href="${createLink(controller: "game", action: "menu")}"><img class="img-responsive" src="images/index/screenshot.png" alt="Screenshot"/></a>
        </div>
    </div>
    <div class="row">
        <div class="text-block col-md-12">
            During the game you experience a virtual journey from one random european country to another one. You can navigate to your goal-country with
            the help of five attributes of those countries. There are currently 13 different attributes you can choose from (if you like all of them,
            the game chooses for you). Some of the attributes contain standard geographical or economical data like the area or the GDP. But there are some
            special things like the number of internet users, too.
        </div>
        <div class="text-block col-md-12">
            To navigate from one country (lets say France) to another one (e.g. Germany) you must think about the values of the attributes of those
            countries. Now you must decide, which attribute you want to use and whether you want to increase or decrease its value. Let's say you chose
            to increase the value of the attribute "Population". Now you hop to Frances neighboring country that has the closest higher value (that
            means, if there are multiple countries with a higher value, the one with the lowest value). And this is - congratulations - Germany. So you
            reached your goal!
        </div>
        <div class="text-block col-md-12">
            At any time during and after the game, you can look at all your discovered data.
        </div>
        <div class="text-block col-md-12">
            In fact, your start- and goal-country will never be neighbors, so you will have to do some more hops and learn more about the world!
        </div>
    </div>
    <div class="row">
        <div class="text-block col-md-6">
            The current version is only a prototype with some limitations. With some work the game could be expanded in different ways. Those are:
        </div>
        <div class="text-block col-md-6">
            <ul>
                <li>Choosing of a continent or other region as gamebase</li>
                <li>Including of different data-sources besides DBpedia and The World Factbook</li>
                <li>Different forms of data visualization after the game</li>
                <li>The possibility to earn achievements</li>
                <li>A global highscore</li>
            </ul>
        </div>
    </div>
    <div class="row">
        <div class="text-block col-md-12">
            <h4>This project is built using data queried with SPARQL from:</h4>
                <ul>
                <li><strong>DBpedia</strong></li>
                <ul>
                    <li>GDP</li>
                    <li>Gini Coefficient</li>
                    <li>HDI</li>
                </ul>
                <li><strong>The CIA World Factbook </strong>(using the endpoint of <a href="http://wifo5-03.informatik.uni-mannheim.de/factbook/">Mannheim University</a>)</li>
                <ul>
                    <li>Amount of airports</li>
                    <li>Area (land / water)</li>
                    <li>Highest point</li>
                    <li>Amount of internetusers</li>
                    <li>Population</li>
                    <li>Length of roadways</li>
                    <li>Telephone main lines in use</li>
                    <li>Mobile phones</li>
                </ul>
            </ul>
        </div>
    </div>
    <div class="row">

    </div>
    <div class="row">
       <div class="col-md-12">
           <h4>This project is built with support of:</h4>
       </div>
    </div>
    <div class="row">
        <div class="col-md-1 col-sm-2 col-xs-4">
            <a href="https://grails.org/"><img class="img-responsive" src="images/apple-touch-icon-retina.png" style="height:40px" title="GRAILS"></a>
        </div>
        <div class="col-md-1 col-sm-2 col-xs-4">
            <a href="http://www.groovy-lang.org/"><img class="img-responsive" src="images/index/groovy.png" style="height:40px" title="groovy"></a>
        </div>
        <div class="col-md-1 col-sm-2 col-xs-4">
            <a href="http://www.w3.org/standards/webdesign/script"><img class="img-responsive" src="images/index/javascript-logo.png" style="height:40px" title="JavaScript"></a>
        </div>
        <div class="col-md-1 col-sm-2 col-xs-4">
            <a href="https://jquery.com/"><img class="img-responsive" src="images/index/logo-jquery2.png" style="height:40px" title="jQuery"></a>
        </div>
        <div class="col-md-1 col-sm-2 col-xs-4">
            <a href="https://jqueryui.com/"><img class="img-responsive" src="images/index/jqueryui.png" style="height:40px" title="jQueryUI"></a>
        </div>
        <div class="col-md-1 col-sm-2 col-xs-4">
            <a href="http://getbootstrap.com/"><img class="img-responsive" src="images/index/bs.png" style="height:40px" title="Bootstrap"></a>
        </div>
        <div class="col-md-1 col-sm-2 col-xs-4">
            <a href="http://www.chartjs.org/"><img class="img-responsive" src="images/index/chart-js-html-graphs-300x260.png" style="height:40px" title="Chart.js"></a>
        </div>
        <div class="col-md-1 col-sm-2 col-xs-4">
            <a href="http://www.w3.org/Graphics/SVG/"><img class="img-responsive" src="images/index/Scalable-Vector-Graphics-SVG-2.png" style="height:40px" title="SVG"></a>
        </div>
        <div class="col-md-1 col-sm-2 col-xs-4">
            <a href="https://github.com/ariutta/svg-pan-zoom/"><img class="img-responsive" src="images/index/pan-zoom.png" style="height:40px" title="SVG Pan & Zoom"></a>
        </div>
        <div class="col-md-1 col-sm-2 col-xs-4">
            <a href="http://snapsvg.io/"><img class="img-responsive" src="images/index/snap.svg" style="height:40px" title="Snap.svg"></a>
        </div>
        <div class="col-md-2 col-sm-4 col-xs-6">
            <a href="http://www.w3.org/standards/semanticweb/"><img class="img-responsive" src="images/index/sw-horz-w3c-v.svg" style="height:40px" title="Semantic Web"></a>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <br>
        </div>
    </div>
</div>
</body>
</html>

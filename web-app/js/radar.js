function normalize(t,a,b,d,r){
	return t*(r-d)/(b-a)+(b*d-a*r)/(b-a);
}
var sTmp;
function radar(s,testGroup,x,y,r,attr,vals,hide,rot, callback, showbuttons,mvals){

	if(attr.length!=vals.length||vals.length!=hide.length){
		console.log("sizes of attributes,values,hide don't match");
		return -1;
	}
	if(attr.length!=5 || rot != 90){
		console.log("use 5 attributes and rotation 90");
		return -1;
	}

	sTmp = Snap("#tmp");

	//some vars
	var rWeb = r*0.95;
	var dDegree = 360/attr.length;
	var aMin = 0;//Math.min.apply(null,vals);
	var aMax = 1;//Math.max.apply(null,vals);
	var aOffset = r*0.07;
	//var aFactor = (rWeb-aOffset)/(aMax-aMin);
	//var rOffset = (aMax*aOffset-aMin*rWeb)/(aMax-aMin);
	var colors = ["red","blue","yellow","purple","green"];

	//bg
	var points = [];
	for(i=0;i<360;i+=dDegree){
		points.push(x + (r - 4) * Math.cos(Snap.rad(i+rot)));
		points.push(y + (r - 4) * Math.sin(Snap.rad(i+rot)));
	}
	testGroup.add(s.polyline(points).attr({fill: "white"}));

	//triangles
	for(var i=0;i<vals.length;i++){
		var c1 = Snap.color(colors[i%colors.length]);
		var c2 =Snap.color(colors[(i+1)%colors.length]);
		var hNew,hDist=Math.abs(c1.h-c2.h);
		if(hDist>0.5){
			hNew=(c1.h+c2.h+1)/2;
		}else{
			hNew=(c1.h+c2.h)/2;
		}
		hNew-=0.04;
		if(hNew>1){hNew-=1;}if(hNew<0){hNew+=1;}
		var cHex = Snap.hsb(hNew,(c1.s+c2.s)/2,(c1.v+c2.v)/2);

		if(hide[i]&&hide[(i+1)%hide.length]){
			testGroup.add(s.polygon(x,y,
				x + normalize(vals[i],aMin,aMax,aOffset,rWeb) * Math.cos(Snap.rad(i*dDegree+rot)),
				y + normalize(vals[i],aMin,aMax,aOffset,rWeb) * Math.sin(Snap.rad(i*dDegree+rot)),
				x + normalize(vals[(i+1)%vals.length],aMin,aMax,aOffset,rWeb) * Math.cos(Snap.rad((i+1)*dDegree+rot)),
				y + normalize(vals[(i+1)%vals.length],aMin,aMax,aOffset,rWeb) * Math.sin(Snap.rad((i+1)*dDegree+rot)))
				.attr({fill: cHex,fillOpacity: 0.5, stroke: "none"}));
		}
	}

	//lines
	for(i=0;i<360;i+=dDegree){
		testGroup.add(s.line(x,y,x + rWeb * Math.cos(Snap.rad(i+rot)),
			y + rWeb * Math.sin(Snap.rad(i+rot)))
		.attr({fill: "none",stroke: "#000",strokeWidth: 2}));
		testGroup.add(s.line(x + rWeb * Math.cos(Snap.rad(i+rot)),
			y + rWeb * Math.sin(Snap.rad(i+rot)),
			x + rWeb * Math.cos(Snap.rad(i-dDegree+rot)),
			y + rWeb * Math.sin(Snap.rad(i-dDegree+rot)))
		.attr({fill: "none",stroke: "#000",strokeWidth: 2}));
	}

	//mouseover
	var tooltip = s.group();
	

	//attributes
	for(i=0;i<vals.length;i++){
		if(hide[i]){
			var xt = x + normalize(vals[i],aMin,aMax,aOffset,rWeb) * Math.cos(Snap.rad(i*dDegree+rot));
			var yt = y + normalize(vals[i],aMin,aMax,aOffset,rWeb) * Math.sin(Snap.rad(i*dDegree+rot));
			testGroup.add(s.circle(xt,yt,6)
			.attr({fill: colors[i%colors.length],stroke: "#000",strokeWidth: 1,mval: mvals[i],xt:xt,yt:yt}).mouseover(function (a){
					//tooltip.clear();
					sTmp.clear();
					var t = sTmp.text(0,0,$(a.target).attr("mval")).attr({fontSize: 18});
					var wBox=t.getBBox().width+8,hBox=t.getBBox().height;
					var xtt = parseFloat($(a.target).attr("xt")), ytt = parseFloat($(a.target).attr("yt"));
					tooltip.add(s.rect(xtt+10,ytt+10,wBox,hBox).attr({fill:"lightyellow",stroke: "#000",strokeWidth: 2}));
					tooltip.add(s.text(xtt+16, ytt+27, $(a.target).attr("mval")).attr({fontsize: 18}));
				}).mouseout(function (){
					tooltip.clear();
				}));
		}
	}



	//labels
	var lastYBox;
	for (i=0; i < attr.length;i++){
		sTmp.clear();
		var t = sTmp.text(0,0,attr[i]).attr({fontSize: 18});
		var wBox=t.getBBox().width+12+48,hBox=t.getBBox().height;
                
		var ang=(i*dDegree+rot+360)%360;
		var rOffset;

		var anew =ang%180;
		if(anew<90){
			rOffset=(90-anew)/90*(wBox/2-hBox/2)+hBox/2+3;

		}else{
			rOffset=((anew-90)/90*(wBox-hBox)+hBox)/2+3;

		}

		var xBox = x+(r+rOffset)*Math.cos(Snap.rad(i*dDegree+rot))-wBox/2;
		var yBox = y+(r+rOffset)*Math.sin(Snap.rad(i*dDegree+rot))-hBox/2;

		if (yBox+hBox > lastYBox && yBox < lastYBox+hBox){
			yBox-=yBox+hBox-lastYBox;
		}
		lastYBox = yBox;

		testGroup.add(s.rect(xBox,yBox,wBox,hBox).attr({fill: "white",stroke: "#000",strokeWidth: 2}));
		testGroup.add(s.text(xBox+6+24,yBox+hBox-4,attr[i]).attr({fontSize: 18}));

		if (showbuttons){
			testGroup.add(s.polyline(xBox+19,yBox+hBox-5,
				xBox+5,yBox+hBox/2,
				xBox+19,yBox+5)
				.attr({fill: "none",stroke: "#000",strokeWidth: 2}));
			testGroup.add(s.polyline(xBox+wBox-19,yBox+hBox-5,
				xBox+wBox-5,yBox+hBox/2,
				xBox+wBox-19,yBox+5)
				.attr({fill: "none",stroke: "#000",strokeWidth: 2}));
			testGroup.add(s.line(xBox+24,yBox,xBox+24,yBox+hBox).attr({fill: "none",stroke: "#000",strokeWidth: 2}));
			testGroup.add(s.line(xBox+wBox-24,yBox,xBox+wBox-24,yBox+hBox).attr({fill: "none",stroke: "#000",strokeWidth: 2}));
			var tLeft = s.rect(xBox+1,yBox+1,24-2,hBox-2).attr({id: "button-left-"+i, fill: "lime",stroke: "none",fillOpacity: 0.2});
			var left = $("#button-left-"+i);
			left.click(i, callback);
			var tRight = s.rect(xBox+wBox-24+1,yBox+1,24-2,hBox-2).attr({id: "button-right-"+i, fill: "lime",stroke: "none",fillOpacity: 0.2});
			var right = $("#button-right-"+i);
			right.click(i+attr.length, callback);
			testGroup.add(tLeft);
			testGroup.add(tRight);
		}
	}

	testGroup.add(tooltip);
}



//positioning settings
var width = 740;
var height = 2975;
var pad = { left: 10, right: 0, top: 60, bottom: 10 };
var vertSpace = 45;
var xName = 20;

var xPrct = 520;
var xChange = 640;
var xNumF = 260;
var xTotal = 380;


var rectW = 80;
var rectH = 35;
var yHeader = 20;
var ySubHead = 40;

//define scales
var sizeNumF = d3.scaleLinear().domain([10, 100]).range([11, 30]);
var sizeTotal = d3.scaleLinear().domain([50, 500]).range([11, 30]);
var changeH = d3.scaleLinear().domain([0, 13]).range([0, 18]);
var prctBar = d3.scaleLinear().domain([0, 32]).range([0, 25]);


//create container elements
var svg = d3.select(".top25").append("svg")
            .attr("width", width + pad.left + pad.right)
            .attr("height", height + pad.top + pad.bottom);


//create header (background) tiles
var headerTiles = svg.append("g").attr("class", "headerTile").attr("transform", "translate(" + pad.left + ",0)");
var activeTile = headerTiles.append("rect").attrs({x: xNumF-45, y: 7, width: 90, height: 43, fill: "white", class: "numF"}).on("click", rankNumF);
headerTiles.append("rect").attrs({x: xTotal-45, y: 7, width: 90, height: 43, fill: "white", class: "total"}).on("click", rankTotal);
headerTiles.append("rect").attrs({x: xPrct-60,  y: 7, height: 43, width: 120, fill: "white", class: "prct"}).on("click", rankPrct);
headerTiles.append("rect").attrs({x: xChange-60, y: 7, width: 120, height: 43, fill: "white", class: "change"}).on("click", rankChange);
headerTiles.selectAll("rect").style("cursor", "pointer");
activeTile.style("fill", "#eee");
rankNumF();

//create header text
var header = svg.append("g").attr("class", "header").attr("transform", "translate(" + pad.left + "," + yHeader + ")");
header.append("text").text("Col3").attr("x", xPrct).on("click", rankPrct);
header.append("text").text("Col4").attr("x", xChange).on("click", rankChange);
header.append("text").text("Col1").attr("x", xNumF).on("click", rankNumF);
header.append("text").text("Col2").attr("x", xTotal).on("click", rankTotal);
// var subHead = svg.append("g").attr("class", "subHead").attr("transform", "translate(" + pad.left + "," + ySubHead + ")");
// subHead.append("text").text("% Women").attr("x", xPrct).on("click", rankPrct);
// subHead.append("text").text("% Women").attr("x", xChange).on("click", rankChange);
// subHead.append("text").text("Stereotypes").attr("x", xNumF).on("click", rankNumF);
// subHead.append("text").text("Stereotypes").attr("x", xTotal).on("click", rankTotal);
header.selectAll("text").style("cursor", "pointer");
// subHead.selectAll("text").style("cursor", "pointer");

//event handlers for resorting the rows
function rankPrct() {
  activeTile.style("fill", "white");
  activeTile = d3.select(".headerTile .prct");
  activeTile.style("fill", "#eee");
  d3.selectAll("g.row")
    .transition().duration(800)
    .attr("transform", function(d) { return "translate(0," + vertSpace*(+d.rankPrct - 0.5) + ")"; });
}
function rankChange() {
  activeTile.style("fill", "white");
  activeTile = d3.select(".headerTile .change");
  activeTile.style("fill", "#eee");
  d3.selectAll("g.row")
    .transition().duration(800)
    .attr("transform", function(d) { return "translate(0," + vertSpace*(+d.rankChange - 0.5) + ")"; });
}
function rankNumF() {
  activeTile.style("fill", "white");
  activeTile = d3.select(".headerTile .numF");
  activeTile.style("fill", "#eee");
  d3.selectAll("g.row")
    .transition().duration(800)
    .attr("transform", function(d) { return "translate(0," + vertSpace*(+d.rankNumF - 0.5) + ")"; });
}
function rankTotal() {
  activeTile.style("fill", "white");
  activeTile = d3.select(".headerTile .total");
  activeTile.style("fill", "#eee");
  d3.selectAll("g.row")
    .transition().duration(800)
    .attr("transform", function(d) { return "translate(0," + vertSpace*(+d.rankTotal - 0.5) + ")"; });
}

//create header line and content SVG group
svg.append("line").attrs({ x1: 0, x2: width, y1: 2, y2: 2}).styles({"stroke-width": 2, stroke: "#222"});
svg.append("line").attrs({ x1: 0, x2: width, y1: pad.top-5, y2: pad.top-5}).styles({"stroke-width": 2, stroke: "#222"});
var g = svg.append("g").attr("transform", "translate(" + pad.left + ", " + pad.top + ")");


//load data..
d3.csv("http://d-miller.github.io/assets/Stereotypes-Table/data.csv", function(data) {


//data = [{"abbrev":"Netherlands","numF":1.31,"total":1.25,"prctStr":20.2,"changeStr":20.4,"rank":1,"rankNumF":1,"rankTotal":2,"rankPrct":1,"rankChange":3},{"abbrev":"Hungary","numF":1.23,"total":1.25,"prctStr":31.9,"changeStr":33.9,"rank":2,"rankNumF":2,"rankTotal":3,"rankPrct":8,"rankChange":22},{"abbrev":"Vietnam","numF":1.23,"total":0.92,"prctStr":null,"changeStr":42.8,"rank":3,"rankNumF":3,"rankTotal":40,"rankPrct":66,"rankChange":43},{"abbrev":"South Africa","numF":1.21,"total":0.96,"prctStr":null,"changeStr":38.8,"rank":4,"rankNumF":4,"rankTotal":34,"rankPrct":65,"rankChange":35},{"abbrev":"Estonia","numF":1.21,"total":1.26,"prctStr":38.9,"changeStr":42.6,"rank":5,"rankNumF":5,"rankTotal":1,"rankPrct":29,"rankChange":42},{"abbrev":"Japan","numF":1.18,"total":0.91,"prctStr":24.8,"changeStr":12,"rank":6,"rankNumF":6,"rankTotal":45,"rankPrct":2,"rankChange":1},{"abbrev":"Czech Republic","numF":1.17,"total":1,"prctStr":32.1,"changeStr":28.6,"rank":7,"rankNumF":7,"rankTotal":29,"rankPrct":9,"rankChange":14},{"abbrev":"Egypt","numF":1.16,"total":0.78,"prctStr":47.3,"changeStr":36.2,"rank":9,"rankNumF":9,"rankTotal":60,"rankPrct":46,"rankChange":28},{"abbrev":"Bolivia","numF":1.16,"total":0.86,"prctStr":null,"changeStr":39.2,"rank":8,"rankNumF":8,"rankTotal":52,"rankPrct":61,"rankChange":36},{"abbrev":"Denmark","numF":1.15,"total":1.13,"prctStr":33.1,"changeStr":28.4,"rank":10,"rankNumF":10,"rankTotal":11,"rankPrct":11,"rankChange":13},{"abbrev":"Germany","numF":1.11,"total":1.04,"prctStr":32.8,"changeStr":21.3,"rank":13,"rankNumF":13,"rankTotal":24,"rankPrct":10,"rankChange":4},{"abbrev":"Pakistan","numF":1.11,"total":0.85,"prctStr":null,"changeStr":22.9,"rank":14,"rankNumF":14,"rankTotal":54,"rankPrct":62,"rankChange":5},{"abbrev":"Turkey","numF":1.11,"total":0.91,"prctStr":39.7,"changeStr":35.9,"rank":11,"rankNumF":11,"rankTotal":43,"rankPrct":31,"rankChange":27},{"abbrev":"Hong Kong","numF":1.11,"total":1.1,"prctStr":28.8,"changeStr":null,"rank":12,"rankNumF":12,"rankTotal":15,"rankPrct":4,"rankChange":64},{"abbrev":"Romania","numF":1.1,"total":1.23,"prctStr":57.3,"changeStr":43.8,"rank":15,"rankNumF":15,"rankTotal":4,"rankPrct":58,"rankChange":47},{"abbrev":"Switzerland","numF":1.09,"total":1.13,"prctStr":27.3,"changeStr":25.7,"rank":16,"rankNumF":16,"rankTotal":12,"rankPrct":3,"rankChange":8},{"abbrev":"Singapore","numF":1.07,"total":0.93,"prctStr":46,"changeStr":26.5,"rank":17,"rankNumF":17,"rankTotal":37,"rankPrct":45,"rankChange":9},{"abbrev":"Norway","numF":1.07,"total":0.98,"prctStr":33.5,"changeStr":31.4,"rank":19,"rankNumF":19,"rankTotal":30,"rankPrct":12,"rankChange":20},{"abbrev":"United Kingdom","numF":1.07,"total":0.97,"prctStr":37.3,"changeStr":36.3,"rank":18,"rankNumF":18,"rankTotal":33,"rankPrct":25,"rankChange":29},{"abbrev":"Belgium","numF":1.06,"total":1.12,"prctStr":30.3,"changeStr":29.7,"rank":21,"rankNumF":21,"rankTotal":13,"rankPrct":5,"rankChange":15},{"abbrev":"Israel","numF":1.06,"total":1.09,"prctStr":39.5,"changeStr":null,"rank":20,"rankNumF":20,"rankTotal":16,"rankPrct":30,"rankChange":65},{"abbrev":"Russian Federation","numF":1.05,"total":1.07,"prctStr":null,"changeStr":42.9,"rank":22,"rankNumF":22,"rankTotal":18,"rankPrct":64,"rankChange":44},{"abbrev":"South Korea","numF":1.04,"total":1.05,"prctStr":30.6,"changeStr":12.5,"rank":23,"rankNumF":23,"rankTotal":22,"rankPrct":6,"rankChange":2},{"abbrev":"Slovakia","numF":1.04,"total":1.23,"prctStr":34.6,"changeStr":41.3,"rank":24,"rankNumF":24,"rankTotal":5,"rankPrct":18,"rankChange":40},{"abbrev":"Ireland","numF":1.03,"total":0.89,"prctStr":41.3,"changeStr":30.9,"rank":27,"rankNumF":27,"rankTotal":51,"rankPrct":34,"rankChange":18},{"abbrev":"Cyprus","numF":1.03,"total":1.03,"prctStr":35.7,"changeStr":31,"rank":25,"rankNumF":25,"rankTotal":26,"rankPrct":22,"rankChange":19},{"abbrev":"Malaysia","numF":1.03,"total":0.9,"prctStr":54.3,"changeStr":36.8,"rank":26,"rankNumF":26,"rankTotal":46,"rankPrct":56,"rankChange":32},{"abbrev":"Bermuda","numF":1.02,"total":0.81,"prctStr":51.3,"changeStr":null,"rank":28,"rankNumF":28,"rankTotal":58,"rankPrct":53,"rankChange":61},{"abbrev":"France","numF":1,"total":1.05,"prctStr":35.9,"changeStr":27.7,"rank":29,"rankNumF":29,"rankTotal":21,"rankPrct":23,"rankChange":12},{"abbrev":"Slovenia","numF":1,"total":0.98,"prctStr":31.6,"changeStr":34.6,"rank":30,"rankNumF":30,"rankTotal":31,"rankPrct":7,"rankChange":24},{"abbrev":"Albania","numF":0.99,"total":0.92,"prctStr":66,"changeStr":44.3,"rank":31,"rankNumF":31,"rankTotal":41,"rankPrct":59,"rankChange":48},{"abbrev":"Greece","numF":0.98,"total":1.21,"prctStr":37.7,"changeStr":36.3,"rank":33,"rankNumF":33,"rankTotal":7,"rankPrct":26,"rankChange":30},{"abbrev":"Bosnia & Herzegovina","numF":0.98,"total":0.62,"prctStr":44.4,"changeStr":null,"rank":32,"rankNumF":32,"rankTotal":64,"rankPrct":41,"rankChange":62},{"abbrev":"Finland","numF":0.97,"total":1.07,"prctStr":40.9,"changeStr":30,"rank":34,"rankNumF":34,"rankTotal":17,"rankPrct":33,"rankChange":16},{"abbrev":"New Zealand","numF":0.96,"total":1.04,"prctStr":41.7,"changeStr":39.3,"rank":35,"rankNumF":35,"rankTotal":23,"rankPrct":36,"rankChange":38},{"abbrev":"Austria","numF":0.95,"total":1.04,"prctStr":34.5,"changeStr":24,"rank":36,"rankNumF":36,"rankTotal":25,"rankPrct":17,"rankChange":7},{"abbrev":"United States","numF":0.95,"total":0.93,"prctStr":43,"changeStr":26.6,"rank":38,"rankNumF":38,"rankTotal":38,"rankPrct":39,"rankChange":10},{"abbrev":"Mexico","numF":0.95,"total":0.82,"prctStr":40.7,"changeStr":31.6,"rank":37,"rankNumF":37,"rankTotal":56,"rankPrct":32,"rankChange":21},{"abbrev":"Chile","numF":0.94,"total":0.96,"prctStr":33.5,"changeStr":27.7,"rank":40,"rankNumF":40,"rankTotal":36,"rankPrct":13,"rankChange":11},{"abbrev":"Colombia","numF":0.94,"total":0.74,"prctStr":48.1,"changeStr":35.5,"rank":41,"rankNumF":41,"rankTotal":61,"rankPrct":48,"rankChange":26},{"abbrev":"Brazil","numF":0.94,"total":1.02,"prctStr":34,"changeStr":48,"rank":39,"rankNumF":39,"rankTotal":27,"rankPrct":15,"rankChange":51},{"abbrev":"Iran","numF":0.93,"total":0.9,"prctStr":67.3,"changeStr":23.1,"rank":42,"rankNumF":42,"rankTotal":49,"rankPrct":60,"rankChange":6},{"abbrev":"Trinidad and Tobago","numF":0.93,"total":0.56,"prctStr":56.4,"changeStr":38.5,"rank":43,"rankNumF":43,"rankTotal":65,"rankPrct":57,"rankChange":34},{"abbrev":"Australia","numF":0.92,"total":1.01,"prctStr":35.6,"changeStr":null,"rank":44,"rankNumF":44,"rankTotal":28,"rankPrct":20,"rankChange":60},{"abbrev":"Sweden","numF":0.91,"total":1.1,"prctStr":43.4,"changeStr":35.5,"rank":45,"rankNumF":45,"rankTotal":14,"rankPrct":40,"rankChange":25},{"abbrev":"Poland","numF":0.91,"total":1.22,"prctStr":41.4,"changeStr":39.2,"rank":47,"rankNumF":47,"rankTotal":6,"rankPrct":35,"rankChange":37},{"abbrev":"Bulgaria","numF":0.91,"total":1.05,"prctStr":50.9,"changeStr":46,"rank":48,"rankNumF":48,"rankTotal":20,"rankPrct":51,"rankChange":50},{"abbrev":"Venezuela","numF":0.91,"total":0.9,"prctStr":44.8,"changeStr":48.1,"rank":49,"rankNumF":49,"rankTotal":47,"rankPrct":42,"rankChange":52},{"abbrev":"Thailand","numF":0.91,"total":0.96,"prctStr":53,"changeStr":49,"rank":46,"rankNumF":46,"rankTotal":35,"rankPrct":55,"rankChange":56},{"abbrev":"Italy","numF":0.9,"total":0.97,"prctStr":49.5,"changeStr":30.3,"rank":52,"rankNumF":52,"rankTotal":32,"rankPrct":50,"rankChange":17},{"abbrev":"Iceland","numF":0.9,"total":0.89,"prctStr":38.2,"changeStr":37.9,"rank":51,"rankNumF":51,"rankTotal":50,"rankPrct":27,"rankChange":33},{"abbrev":"Costa Rica","numF":0.9,"total":0.55,"prctStr":35.5,"changeStr":40.3,"rank":50,"rankNumF":50,"rankTotal":66,"rankPrct":19,"rankChange":39},{"abbrev":"Argentina","numF":0.87,"total":0.84,"prctStr":48,"changeStr":50.4,"rank":54,"rankNumF":54,"rankTotal":55,"rankPrct":47,"rankChange":57},{"abbrev":"Latvia","numF":0.87,"total":1.14,"prctStr":34.4,"changeStr":51.8,"rank":53,"rankNumF":53,"rankTotal":10,"rankPrct":16,"rankChange":58},{"abbrev":"Ecuador","numF":0.86,"total":0.85,"prctStr":33.9,"changeStr":34.4,"rank":56,"rankNumF":56,"rankTotal":53,"rankPrct":14,"rankChange":23},{"abbrev":"Lithuania","numF":0.86,"total":1.21,"prctStr":36.9,"changeStr":48.5,"rank":57,"rankNumF":57,"rankTotal":8,"rankPrct":24,"rankChange":54},{"abbrev":"Canada","numF":0.86,"total":0.91,"prctStr":38.4,"changeStr":null,"rank":55,"rankNumF":55,"rankTotal":42,"rankPrct":28,"rankChange":63},{"abbrev":"Lebanon","numF":0.86,"total":0.9,"prctStr":45.3,"changeStr":null,"rank":58,"rankNumF":58,"rankTotal":48,"rankPrct":44,"rankChange":66},{"abbrev":"Cuba","numF":0.83,"total":1.15,"prctStr":45.2,"changeStr":48.3,"rank":59,"rankNumF":59,"rankTotal":9,"rankPrct":43,"rankChange":53},{"abbrev":"Puerto Rico","numF":0.82,"total":0.68,"prctStr":null,"changeStr":42,"rank":60,"rankNumF":60,"rankTotal":63,"rankPrct":63,"rankChange":41},{"abbrev":"Belarus","numF":0.78,"total":0.92,"prctStr":51,"changeStr":44.3,"rank":61,"rankNumF":61,"rankTotal":39,"rankPrct":52,"rankChange":49},{"abbrev":"Croatia","numF":0.74,"total":0.91,"prctStr":42.6,"changeStr":43.4,"rank":62,"rankNumF":62,"rankTotal":44,"rankPrct":38,"rankChange":45},{"abbrev":"Antigua and Barbuda","numF":0.72,"total":1.05,"prctStr":42.5,"changeStr":null,"rank":63,"rankNumF":63,"rankTotal":19,"rankPrct":37,"rankChange":59},{"abbrev":"Spain","numF":0.69,"total":0.81,"prctStr":35.6,"changeStr":36.4,"rank":64,"rankNumF":64,"rankTotal":57,"rankPrct":21,"rankChange":31},{"abbrev":"Portugal","numF":0.61,"total":0.8,"prctStr":48.1,"changeStr":43.8,"rank":65,"rankNumF":65,"rankTotal":59,"rankPrct":49,"rankChange":46},{"abbrev":"Macedonia","numF":0.6,"total":0.72,"prctStr":52.4,"changeStr":48.8,"rank":66,"rankNumF":66,"rankTotal":62,"rankPrct":54,"rankChange":55}];
  ///////////////////////////////
  //  FIXED POSITION ELEMENTS  //
  ///////////////////////////////

  //add lines in between
  g.selectAll("line.sep").data(data).enter().append("line")
    .attrs({ x1: -pad.left, x2: width-pad.left, class: "sep"})
    .attr("y1", function(d) { return vertSpace*d.rank; })
    .attr("y2", function(d) { return vertSpace*d.rank; })
    .styles({"stroke-width": 0.5, stroke: "#888"});

  //ranking text
  g.selectAll("text.rank").data(data).enter().append("text")
    .attr("class", "rank")
    .text(function(d) { return d.rank + "."; })
    .attr("y", function(d) { return vertSpace*(d.rank - 0.5); })
    .attr("x", 5);

  /////////////////////////////////
  //  DYNAMIC POSITION ELEMENTS  //
  /////////////////////////////////

  //add grouping elements
  var rows = g.selectAll(".rows")
              .data(data).enter()
              .append("g")
              .attr("class", "row")
              .attr("transform", function(d) { 
                return "translate(0," + vertSpace*(+d.rank - 0.5) + ")"; 
              });

		g.selectAll("row").on("mouseover", function(d){
			d3.select(this)
				.style("background-color", "orange");
		})
		.on("mouseout", function(d){
			d3.select(this)
				.style("background-color","transparent");
		});	  
			  
  rows.each(function(d) {

    var s = d3.select(this);

    s.append("text")
      .attr("class", "name")
      .text(function(d) { return d.abbrev; })
      .attr("x", xName)
	  .on("mouseover", function(d){
			d3.select(this)
				.style("background-color", "orange");
		})
		.on("mouseout", function(d){
			d3.select(this)
				.style("background-color","transparent");
		});

    s.append("text")
      .attr("class", "prct")
      .text(function(d) { return d.prctStr; })
      .attr("x", xPrct)
      .style("fill", "#333")
      .style("font-size", 25)
	  .on("mouseover", function(d){
			d3.select(this)
				.style("background-color", "orange");
		})
		.on("mouseout", function(d){
			d3.select(this)
				.style("background-color","transparent");
		});

    s.append("text")
      .attr("class", "change")
      .text(function(d) { return d.changeStr; })
      .attr("x", xChange)
      .style("font-size", 25)
	  .on("mouseover", function(d){
			d3.select(this)
				.style("background-color", "orange");
		})
		.on("mouseout", function(d){
			d3.select(this)
				.style("background-color","transparent");
		});

    s.append("text")
      .attr("class", "numF")
      .text(function(d) { return d.numF; })
      .attr("x", xNumF)
      .style("font-size", 25)
	  .on("mouseover", function(d){
			d3.select(this)
				.style("background-color", "orange");
		})
		.on("mouseout", function(d){
			d3.select(this)
				.style("background-color","transparent");
		});
      //.style("font-size", function(d) { return sizeNumF(d.numF); });

    s.append("text")
      .attr("class", "total")
      .text(function(d) { return d.total; })
      .attr("x", xTotal)
      .style("font-size", 25)
	  .on("mouseover", function(d){
			d3.select(this)
				.style("background-color", "orange");
		})
		.on("mouseout", function(d){
			d3.select(this)
				.style("background-color","transparent");
		});
      //.style("font-size", function(d) { return sizeTotal(d.total); });

  });

 });
window.onload = function () {
  $("#holder").height(window.innerHeight - 40);
  var r = Raphael("holder");
  r.g.txtattr.font = "12px 'Fontin Sans', Fontin-Sans, sans-serif";

  var xValues = [], yValues = [], labels = [];
  var cols, numLines;

  // Grab xvalues, yvalues
  function grabValues(xValues, yValues, numLines) {
    for(var i = 0; i < numLines; i++) {
      xValues.push([]);
      yValues.push([]);
    }
    $("tr").each(function(rowId) {
      $("td", this).each(function(colId) {
	if(colId == 0){
	  for(var i = 0; i < numLines; i++) {
	    xValues[i].push(parseFloat($(this).text()));
	  }
	} else {
	  yValues[colId - 1].push(parseFloat($(this).text()));
	}
      });
    });
  }

  $("#results").load("spawn_results.html", function() {
    cols = $("table th");
    labels = $("table th");
    numLines = cols.length - 1;

    grabValues(xValues, yValues, numLines);

    // Render the graph
    var lines = r.g.linechart(30, 30, r.width - 50, r.height - 80, xValues, yValues,
			      { axisxstep: xValues[0].length, axisystep: xValues[0].length, nostroke: false, axis: "0 0 1 1", symbol: "o" }).hoverColumn(function () {
				this.tags = r.set();
				for (var i = 0, ii = this.y.length; i < ii; i++) {
				  this.tags.push(r.g.tag(this.x, this.y[i], this.values[i], 160, 10).insertBefore(this).attr([{fill: "#fff"}, {fill: "#000"}]));
				  $($("tr")[this.colId + 1]).animate({backgroundColor: "red"});
				}
			      }, function () {
				this.tags && this.tags.remove();
				$($("tr")[this.colId + 1]).animate({backgroundColor: "black"});
			      });

    lines.axis.attr("stroke", "#fff");
    lines.axis[0].text.attr("stroke", "#fff");
    lines.axis[1].text.attr("stroke", "#fff");

    // Render axis labels
    r.text((lines.axis[0].getBBox().x + lines.axis[0].getBBox().width)/2, lines.axis[0].getBBox().y + 40, "log10(Number of processes)").attr({ fill: "#fff", "font-size": 18 });
    r.text(lines.axis[1].getBBox().x - 30, (lines.axis[1].getBBox().y + lines.axis[1].getBBox().height)/2, "microseconds").rotate(-90).attr({ fill: "#fff", "font-size": 18 });

    // Render labels
    for (var i = 0; i < numLines; i++) {
      r.g.disc(70, 100 + i * 15, 5).attr({fill: lines.lines[i].attrs.stroke, stroke: "none"});
      r.text(100, 100 + i * 15, $(labels[i + 1]).text()).attr(r.g.txtattr).attr({fill: lines.lines[i].attrs.stroke, "text-anchor": "start"});
    }

  });
};

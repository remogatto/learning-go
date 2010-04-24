window.onload = function () {
  var r = Raphael("holder");
  r.g.txtattr.font = "12px 'Fontin Sans', Fontin-Sans, sans-serif";

  var xValues = [], yValues = [], labels = [];
  var rows, numLines;

  // Grab xvalues, yvalues
  function grabValues(xValues, yValues, numLines) {
    for(i = 0; i < numLines; i++) {
      xValues.push([]);
      yValues.push([]);
      $("td", $(rows[0])).each(function() {
	xValues[i].push(parseFloat($(this).text()));
      });
      $("td", $(rows[i + 1])).each(function() {
	yValues[i].push(parseFloat($(this).text()));
      });
    }
  }

  $("#results").load("spawn_results.html", function() {
    rows = $("table tr");
    labels = $("table th");
    numLines = rows.length - 1;

    grabValues(xValues, yValues, numLines);

    // Render the graph
    var lines = r.g.linechart(30, 30, 600, 300, xValues, yValues,
			      { nostroke: false, axis: "0 0 1 1", symbol: "o" }).hoverColumn(function () {
				this.tags = r.set();
				for (var i = 0, ii = this.y.length; i < ii; i++) {
				  this.tags.push(r.g.tag(this.x, this.y[i], this.values[i], 160, 10).insertBefore(this).attr([{fill: "#aaa"}, {fill: this.symbols[i].attr("fill")}]));
				}
			      }, function () {
				this.tags && this.tags.remove();
			      });

    lines.axis.attr("stroke", "#fff");
    lines.axis[0].text.attr("stroke", "#fff");
    lines.axis[1].text.attr("stroke", "#fff");

    // Render labels
    for (var i = 0; i < numLines; i++) {
      r.g.disc(70, 100 + i * 15, 5).attr({fill: lines.lines[i].attrs.stroke, stroke: "none"});
      r.text(100, 100 + i * 15, $(labels[i + 1]).text()).attr(r.g.txtattr).attr({fill: lines.lines[i].attrs.stroke, "text-anchor": "start"});
    }

  });
};

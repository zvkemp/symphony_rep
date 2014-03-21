window.histogram = new SR.Histogram('#histogram')
d3.json("data/histograms.json", (error, json) ->
  histogram.data(json)
  histogram.render()
)

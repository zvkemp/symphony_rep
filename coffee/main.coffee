window.histogram = new SR.Histogram('#histogram')
d3.json("data/histograms.json", (error, json) ->
  console.log(error)
  histogram.data(json)
  histogram.render()
)

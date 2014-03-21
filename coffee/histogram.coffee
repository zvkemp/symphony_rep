window.SR or= {}

class SR.Histogram
  
  constructor: (element) ->
    @initialize_svg(element)

  initialize_svg: (element) ->
    console.log('initialize_svg', element)
    @svg = d3.select(element).append('svg')

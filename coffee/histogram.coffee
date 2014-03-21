window.SR or= {}

class SR.Histogram
  
  constructor: (element) ->
    @initialize_svg(element)

  width: 700
  height: 420
  padding: { 
    bottom: 40
    left: 30
    right: 10
    top: 10
  }

  initialize_svg: (element) ->
    @svg = d3.select(element).append('svg')
      .attr('width', @width)
      .attr('height', @height)
      .attr('viewBox', "0 0 #{@width} #{@height}")

  data: (data) ->
    if data
      @_data = data
      return @
    return @_data

  render: ->
    @render_x_axis()
    @render_y_axis()

  render_x_axis: ->
    @x_axis_group or= @svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', "translate(#{@padding.left}, #{@height - @padding.bottom})")
    @x_axis_group.call(@x_axis())
      .selectAll('text')
      .attr('x', -3)
      .attr('y', 0)
      .attr('dy', ".35em")
      .attr("transform", "rotate(-90)")
      .style('text-anchor', "end")

  x: ->
    @initialize_x_scale() unless @_x
    return @_x

  initialize_x_scale: ->
    @_x = d3.scale.linear()
      .domain([1590,2010])
      .range([0, @width - @padding.left - @padding.right])

  x_axis: ->
    axis = d3.svg.axis()
      .orient('bottom')
      .scale(@x())
      .ticks(40)
      .tickFormat((d) -> "#{d}")

  render_y_axis: ->
    @y_axis_group or= @svg.append('g')
      .attr('class', 'y axis')
      .attr('transform', "translate(#{@padding.left}, #{@padding.top})")
    @y_axis_group.call(@y_axis())

  y: ->
    @initialize_y_scale() unless @_y
    return @_y

  y_axis: ->
    axis = d3.svg.axis()
      .orient('left')
      .scale(@y())
      .ticks(10)

  initialize_y_scale: ->
    @_y = d3.scale.linear()
      .domain([0, 100])
      .range([@height - @padding.top - @padding.bottom, 0])




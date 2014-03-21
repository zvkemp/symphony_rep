window.SR or= {}

class SR.Histogram
  
  constructor: (element) ->
    @element = element
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
      @append_buttons()
      return @
    return @_data

  append_buttons: ->
    d3.select("#{@element}-controls").selectAll('.buttons').remove()
    button_group = d3.select("#{@element}-controls").append('ul').attr('class', 'buttons btn-group')
    buttons = button_group.selectAll('a.btn').data(["All Orchestras"].concat(d.name for d in @_data))
    buttons.enter().append('a')
      .attr('class', 'btn btn-mini')
      .text((d) -> d)


  selected_data: () ->
    @data_key or= "All Orchestras"
    if @data_key == "All Orchestras"
      @_selected_data = [{ name: @data_key, years: @compiled_counts()}]
    else
      @_selected_data = (x for x in @_data when x.name == @data_key)
    return @_selected_data

  compiled_counts: () ->
    compiled_counts = {}
    for orch in @_data
      do (orch) =>
        all_years = @years_as_array(orch)
        for d in all_years
          do (d) =>
            compiled_counts[d.year] or= 0
            compiled_counts[d.year] += d.count
    compiled_counts
    # { year: year, count: count, name: "All Orchestras" } for year, count of compiled_counts


  render: ->
    @render_x_axis()
    @render_y_axis()
    @render_data()

  render_data: ->
    orchestras = @svg.selectAll('g.orchestra').data(@selected_data())
    orchestras.enter()
      .append('g')
      .attr('class', 'orchestra')
    orchestras.attr('name', (d) -> d.name)
      .attr('transform', "translate(#{@padding.left}, 0)")

    rectangles = orchestras.selectAll('rect').data(@years_as_array)
    rectangles.enter().append('rect')
    rectangles.attr('x', (d) => @_x(d.year) - 5)
      .attr('y', (d) => @padding.top + @_y(d.count))
      .attr('height', (d) => 
        @_y(0) - @_y(d.count)
      ).attr('width', 10)
      .style('fill', (d) => @colors(d.name))
    rectangles.exit().remove()


    orchestras.exit().remove()

  years_as_array: (d) -> { year: parseInt(year), count: count, name: d.name } for year, count of d.years


  colors: d3.scale.category10()


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
      .domain([0, 60])
      .range([@height - @padding.top - @padding.bottom, 0])




angular.module('app').controller 'UsersController',
  class UsersController extends ElementsController
    @$inject: ['Users', '$state', '$filter', '$scope', '$timeout']
    constructor: (a, b, @filter, @scope, @timeout) ->
      super

    edit: (element) ->
      @state.go("#{@elements.route}.edit", id: element.id)
      .then =>
        @element = element
        @element.last_login_at = new Date(@element.last_login_at)
      .then => @edit_or_new()
#      .then =>
#        f = =>
#          @draw_graph(@filtered_elements())
#        @timeout(f , 1000)

    filtered_elements: =>
      @filter('filter')(@elements, name: @keywords)

    init: =>
      @scope.$watch @filtered_elements, @draw_graph, true

    days_ago: (date) =>
      now = new Date()
      (now - date) / (1000*60*60*24)

    draw_graph: (data) =>
      min_date = new Date(2014, 4, 10)

      # scale
      x = d3.scale.log()
      .domain [@days_ago(min_date), 0.001]
      .rangeRound [0, 500]

      d3.select('svg').style('fill', 'red')

      x_axis = d3.svg.axis().scale(x).orient('bottom')
#      d3.select('svg').call(x_axis)

      # bind data
      groups = d3.select('svg').selectAll('g').data(data, (d) -> d.id)

      # add
      group = groups.enter()
      .append('g')
      .attr('transform', (d) => "translate(#{x(@days_ago(new Date(d.last_login_at)))}, 40)")
      group.append('circle')
      group.append('text')

      # remove
      groups.exit()
      .transition()
      .duration(600)
      .style('opacity', 0)
      .remove()

      # update
      groups
      .on('click', (d) => @edit(d))
      .style('opacity', 0.8)
      .transition()
      .duration(300)
      .attr('transform', (d) => "translate(#{x(@days_ago(new Date(d.last_login_at)))}, 40)")

      groups.select('circle')
      .transition()
      .attr('r', (d) -> d.logins_count * 0.5)

      groups.select('text')
      .text((d) -> d.name)
      .attr('transform', (d) -> "rotate(70) translate(#{5 + d.logins_count * 0.5}, 5)")
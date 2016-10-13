# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

return unless location.pathname == '/'

$ ->
  $('table.data.table').dataTable()
  $('.dataTables_filter input').attr('placeholder', 'Search...')

# Callback that creates and populates a data table,
# instantiates the pie chart, passes in the data and
# draws it.
drawChart = (container, title, iter) ->

  # returns an array of objects
  rows = container.data('rows')
  # Use iterator to create [[...], [...]]
  table = rows.map(iter)
  # Add a headers row, a copy of the first row converted to String
  table.unshift(table[0].map (cell) -> cell.toString())

  # Create the data table.

  data = google.visualization.arrayToDataTable table

  view = new google.visualization.DataView(data);
  view.setColumns([0, 1]);

  # Set chart options
  options =
    title: title
    width: "100%"
    height: "100%"
    chartArea:
      left: "10%"
      top: "10%"
      height: "80%"
      width: "80%"

  # Instantiate and draw our chart, passing in some options.
  chart = new google.visualization.PieChart(container[0])
  chart.draw view, options

  selectHandler = (e) ->
    window.location = data.getValue(chart.getSelection()[0]['row'], 2 )

  google.visualization.events.addListener(chart, 'select', selectHandler)
  return

# Load the Visualization API and the piechart package.
google.load "visualization", "1.0", packages: ["corechart"]

# Set a callback to run when the Google Visualization API is loaded.
google.setOnLoadCallback ->
  drawChart $('#top-funders'), 'Funding sources with most balance', (funder) ->
    [
      funder.name, parseFloat(funder.amount), '/funders/' + funder.id
    ]
  drawChart $('#top-providers'), 'Providers with most children', (provider) ->
    [
      provider.name, parseInt(provider.children_count),
      '/providers/' + provider.id
    ]

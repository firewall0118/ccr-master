$ ->
  # return unless location.pathname.match(/families\/\d+/)

  allCheckbox = '.check-all'
  checkbox    = ':checkbox[name="children_ids[]"]'

  $(allCheckbox).change (evt) ->
    $(checkbox).prop('checked', @checked)

  $(".datepicker").datepicker dateFormat: "mm/dd/yy"
  $('table.data.table').dataTable()

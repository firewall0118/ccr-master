$ ->
  return unless (location.pathname.match(/\/contracts/) || [])[0]

  later = ->
    $('.table-primary').css
      'overflow-x': 'auto'
      height: '35%'


  checkBoxesChanged = (evt) ->
    ids   = $.map($('.contract-checkbox:checked'),(el) -> $(el).data('id'))
    href  = "/families/certification_letters?ids=#{$.unique(ids).join(',')}"
    $('#print').attr('href', href)

  $('#contracts').on 'change', '.contract-checkbox', checkBoxesChanged

  $('.check-all').change (evt) ->
    $('.contract-checkbox').prop('checked', @checked)
    checkBoxesChanged()

  checkBoxesChanged()

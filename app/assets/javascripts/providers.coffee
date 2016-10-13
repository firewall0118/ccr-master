$ ->
  return if location.pathname != '/providers'

  checkBoxesChanged = (evt) ->
    ids   = $.map($('.provider-checkbox:checked'),(el) -> $(el).data('id'))
    href  = "/attendances/print?provider_ids=#{ids.join(',')}"
    alert = 'javascript:alert("please select some providers");'
    href  = if ids[0] then href else alert
    $('#print-eav').attr('href', href)

  $('#providers').on 'change', '.provider-checkbox', checkBoxesChanged

  $('.check-all').change (evt) ->
    $('.provider-checkbox').prop('checked', @checked)
    checkBoxesChanged()

  checkBoxesChanged()

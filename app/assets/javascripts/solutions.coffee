$(document).on 'turbolinks:load', () ->
  $('#solutions-datatable').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      null,
      null,
      null,
      null,
      null,
      null,
      { "orderable": false }
    ]
  })

  $('.create-estimate-solution').on 'click', (e) ->
    id = $(this).data('solution-id')
    e.preventDefault()
    solution = $(this).data('solution-id')
    inputs = $('input[name=name]')
    name_input = null
    angular.forEach inputs, (input,k) ->
      if $(input).data('id') == id
        name_input = input
    name = $(name_input).val()
    if name == null || name == ''
      $(name_input).parent().parent().addClass('has-error')
    else
      $('#create-estimate-form-' + solution).submit()
    false

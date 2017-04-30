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
    e.preventDefault()
    solution = $(this).data('solution-id')
    debugger
    $('#create-estimate-form-' + solution).submit()
    false

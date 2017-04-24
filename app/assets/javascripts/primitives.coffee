$(document).on 'turbolinks:load', () ->
  $('.update-price-link').on 'click', ->
    $(this).closest('tr').find('form').submit()
    return false

  $('.primitives-datatable').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      null,
      { "orderable": false },
      { "orderable": false },
      null,
      { "orderable": false }
    ]
  })

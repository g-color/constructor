$(document).on 'turbolinks:load', () ->
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

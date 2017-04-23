$(document).on 'turbolinks:load', () ->
  $('.clients-datatable').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      null,
      null,
      { "orderable": false },
      { "orderable": false },
    ]
  })

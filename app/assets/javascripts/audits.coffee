$(document).on 'turbolinks:load', () ->
  $('.audits-datatable').DataTable({
    searching: false,
    bInfo: false,
    columns: [
      null,
      { "orderable": false },
      { "orderable": false },
      null,
      { "orderable": false },
      null
    ]
  })

$(document).on 'turbolinks:load', () ->
  $('#product-popularity').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      null,
      null,
    ]
  })

  $('#floor-popularity').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      { "orderable": false },
      null,
    ]
  })

  $('#area-popularity').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      null,
      null,
    ]
  })

  $('#material-consumption').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      null,
      { "orderable": false },
      null,
      null,
    ]
  })

  $('#estimate-conversion').DataTable({
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
    ]
  })



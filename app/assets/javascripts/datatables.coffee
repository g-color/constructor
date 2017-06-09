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

  $('.clients-datatable').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      null,
      { "orderable": false },
      null,
      { "orderable": false },
      { "orderable": false },
    ]
  })

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

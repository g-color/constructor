$(document).on 'turbolinks:load', () ->
  if $('.audits-datatable').exists()
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

  if $('.clients-datatable').exists()
    $('.clients-datatable').DataTable({
      searching: false,
      paging: false,
      bInfo: false,
      columns: [
        null,
        null,
        null,
        { "orderable": false },
        { "orderable": false },
      ]
    })

  if $('.primitives-datatable').exists()
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

  if $('#product-popularity').exists()
    $('#product-popularity').DataTable({
      searching: false,
      paging: false,
      bInfo: false,
      columns: [
        null,
        null,
      ]
    })

  if $('#floor-popularity').exists()
    $('#floor-popularity').DataTable({
      searching: false,
      paging: false,
      bInfo: false,
      columns: [
        { "orderable": false },
        null,
      ]
    })

  if $('#area-popularity').exists()
    $('#area-popularity').DataTable({
      searching: false,
      paging: false,
      bInfo: false,
      columns: [
        null,
        null,
      ]
    })

  if $('#material-consumption').exists()
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

  if $('#estimate-conversion').exists()
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

  if $('#solutions-datatable').exists()
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

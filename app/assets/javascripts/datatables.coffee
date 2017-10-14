$(document).on 'turbolinks:load', () ->
  $('.audits-datatable').DataTable({
    searching: false,
    autoWidth: false,
    bInfo: false,
    columns: [
      null,
      { "orderable": false },
      { "orderable": false },
      null,
      { "orderable": false },
      null
    ],
    order: [[ 5, "desc" ]],
    oLanguage: {
      "sLengthMenu": "Показать _MENU_",
    }
  })


  $('.clients-datatable').DataTable({
    searching: false,
    autoWidth: false,
    bInfo: false,
    columns: [
      null,
      { "orderable": false },
      null,
      { "orderable": false },
      { "orderable": false },
    ],
    oLanguage: {
      "sLengthMenu": "Показать _MENU_",
    }
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
    ],
    oLanguage: {
      "sLengthMenu": "Показать _MENU_",
    }
  })

  $('#product-popularity').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      null,
      null,
    ],
    oLanguage: {
      "sLengthMenu": "Показать _MENU_",
    }
  })

  $('#floor-popularity').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      { "orderable": false },
      null,
    ],
    oLanguage: {
      "sLengthMenu": "Показать _MENU_",
    }
  })

  $('#area-popularity').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      null,
      null,
    ],
    oLanguage: {
      "sLengthMenu": "Показать _MENU_",
    }
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
    ],
    oLanguage: {
      "sLengthMenu": "Показать _MENU_",
    }
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
    ],
    oLanguage: {
      "sLengthMenu": "Показать _MENU_",
    }
  })

  $('#solutions-datatable').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    autoWidth: false,
    columns: [
      null,
      null,
      null,
      null,
      null,
      null,
      { "orderable": false }
    ],
    oLanguage: {
      "sLengthMenu": "Показать _MENU_",
    }
  })

$(document).on 'turbolinks:load', () ->

  buttons_translate = {
    sLengthMenu: "Показать _MENU_",
    oPaginate: {
      sNext: "Вперед",
      sPrevious: "Назад"
    }
  }

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
    oLanguage: buttons_translate
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
    oLanguage: buttons_translate
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
    oLanguage: buttons_translate
  })

  $('#product-popularity').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      null,
      null,
    ],
    oLanguage: buttons_translate
  })

  $('#floor-popularity').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      { "orderable": false },
      null,
    ],
    oLanguage: buttons_translate
  })

  $('#area-popularity').DataTable({
    searching: false,
    paging: false,
    bInfo: false,
    columns: [
      null,
      null,
    ],
    oLanguage: buttons_translate
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
    oLanguage: buttons_translate
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
    oLanguage: buttons_translate
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
    oLanguage: buttons_translate
  })

  $('#estimates-datatable').DataTable({
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
      { "orderable": false }
    ],
    order: [
      [5, "desc"]
    ],
    oLanguage: buttons_translate
  })
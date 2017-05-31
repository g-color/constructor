$(document).on 'ready', () ->
  $('.update-price-link').on 'click', ->
    $(this).closest('tr').find('form').submit()
    false

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

  $('.primitive-price').on 'blur', (e) ->
    price = $(e.target).val()
    id    = $(e.target).data('id')
    old_price = $(e.target).data('price')

    unless parseFloat(price) == parseFloat(old_price)
      $('#primitive-' + id).submit()

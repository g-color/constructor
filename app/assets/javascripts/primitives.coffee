$(document).on 'turbolinks:load', () ->
  $('.primitive-price').on 'blur', (e) ->
    price = $(e.target).val()
    id    = $(e.target).data('id')
    old_price = $(e.target).data('price')

    unless parseFloat(price) == parseFloat(old_price)
      $('#primitive-' + id).submit()

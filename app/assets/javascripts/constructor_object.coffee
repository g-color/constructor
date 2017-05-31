$(document).on 'ready', ->
  $('#constructor_objects')
  .on 'cocoon:before-insert', (e, composition, insert) ->
    insert.val = false if $('#constructor_object_constructor_object_id').val() == ''
  .on 'cocoon:after-insert', (e, composition) ->
    $('#search').val('')
    $.ajax
      url: '/constructor_objects/info',
      dataType: 'json',
      data: { id: $('#constructor_object_constructor_object_id').val() }
      success: (response) ->
        $(composition).find('.constructor-object-name').text(response['name'])
        $(composition).find('.children').val($('#constructor_object_constructor_object_id').val())
        $(composition).find('.unit-name').text(response['unit'])

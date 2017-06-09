$(document).on('turbolinks:load', function() {
  $('.client-files-div').find(':file').change(function() {
    $('#create-file').trigger('click');
    var nested = $('#client-files').find('.nested-fields').last();
    var file_data = $(this).prop("files")[0];
    var form_data = new FormData();
    form_data.append('file', file_data);
    $.ajax({
      url: '/estimates/files',
      dataType: 'json',
      cache: false,
      contentType: false,
      processData: false,
      data: form_data,
      type: 'post',
      success: function(response) {
        $(nested).find('.file-id').val(response.id);
        $(nested).find('.file-name').text(response.name);
        $(nested).find('.file-src').attr("src", response.src);
      }
    });
  });

  $('.technical-files-div').find(':file').change(function() {
    $('#create-technical-file').trigger('click');
    var nested = $('#technical-files').find('.nested-fields').last();
    var file_data = $(this).prop("files")[0];
    var form_data = new FormData();
    form_data.append('file', file_data);
    $.ajax({
      url: '/estimates/files',
      dataType: 'json',
      cache: false,
      contentType: false,
      processData: false,
      data: form_data,
      type: 'post',
      success: function(response) {
        $(nested).find('.file-id').val(response.id);
        $(nested).find('.file-name').text(response.name);
        $(nested).find('.file-src').attr("src", response.src);
      }
    });
  });

  $('#btn-export-engineer').click(function() {
    $('#modal-engineer').modal('toggle');
  });

});

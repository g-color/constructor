// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery2
//= require jquery.turbolinks
//= require jquery-ui
//= require jquery_ujs
//= require bootstrap-sprockets
//= require autocomplete-rails
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require angular
//= require angular-animate
//= require angular-resource
//= require toaster
//= require cocoon
//= require lightbox-bootstrap
//= require turbolinks
//= require_tree .

$(function(){
  $('a').on('click', function(e) {
    if ($(this).attr('href') == window.location.pathname) {
      window.location.reload();
    }
  })

  
})

$.fn.exists = function () {
  return this.length !== 0;
}

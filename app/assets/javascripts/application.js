// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_directory ../../../vendor/assets/javascripts/flat-ui/
//= require_tree .

$(document).ready(function() {
  if (localStorage["sidebarCollapsed"] == 'true') {
    collapseSidebar(false);
  }
});

function expandSidebar(animate) {
  switchSidebarAnimation(animate);
  $('#sidebar').removeClass('collapsed');
  localStorage["sidebarCollapsed"] = 'false';
}

function collapseSidebar(animate) {
  switchSidebarAnimation(animate);
  $('#sidebar').addClass('collapsed');
  localStorage["sidebarCollapsed"] = 'true';
}

function switchSidebarAnimation(animate) {
  if (animate) {
    $('#sidebar').addClass('animate');
  } else {
    $('#sidebar').removeClass('animate');
  }
}

function toggleSidebar() {
  if ($('#sidebar').hasClass('collapsed')) {
    expandSidebar(true);
  } else {
    collapseSidebar(true);
  }
}

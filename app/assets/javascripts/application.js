//= require vendor
//= require share_app
//= require inline_svg_fallback
//= require_tree ./scheddo

$(document).ready(function(){
  if (!Modernizr.cssanimations) {
    $('.flash > div').delay(1500).slideUp();
  }

  $('a[rel*=yammer-invite]').leanModal({ closeButton: '.modal-close' })
  $('a[rel*=email-invite]').leanModal({ closeButton: '.modal-close' })
});

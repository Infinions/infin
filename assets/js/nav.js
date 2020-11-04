import $ from "jquery";

$(window).on("scroll", () => {
  var scrollPos = $(window).scrollTop();
  if (scrollPos <= 100) {
    $('.landing-nav').addClass('top-of-page');
    $('.landing-nav').removeClass('is-light');
  } else {
    $('.landing-nav').removeClass('top-of-page');
    $('.landing-nav').addClass('is-light');
  }
});

$(document).on("ready", () => {
  $(".navbar-burger").on("click", () => {
    $(".navbar-burger").toggleClass("is-active");
    $(".navbar-menu").toggleClass("is-active");
  });
});

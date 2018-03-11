function sidebarSide1() {
  $('.ui.side').addClass('invisible');
  $('.ui.side .ui.menu').removeClass('accordion');
  $('.ui.side .ui.menu').addClass('icon');
  $('.ui.side .ui.menu .dropdown.icon').remove();
  $('.ui.side .ui.menu div.item:not(.header)').addClass('ui dropdown');
  $('.ui.dropdown.item').dropdown({on: 'hover'});
  $('.ui.side .ui.menu .item:not(.header)').removeClass('hidden');
}

function sidebarSide2() {
  $('.ui.side').removeClass('invisible');
  $('.ui.side .ui.menu').addClass('accordion');
  $('.ui.side .ui.menu').removeClass('icon');
  $('.ui.side .ui.menu .item:not(.header)').removeClass('ui dropdown');
  $('.ui.side .ui.menu .title').append('<i class="dropdown icon"></i>');
  $('.ui.accordion').accordion({selector: {trigger: '.title'}});
  $('.ui.side .ui.menu .item:not(.header)').dropdown('destroy');
}

document.addEventListener('turbolinks:load', function(){

  $('#close_side').click(function() {
    if ($('.ui.side').hasClass('invisible')) {
      window.localStorage.setItem('invisible', 'false');
      sidebarSide2();
    } else {
      window.localStorage.setItem('invisible', 'true');
      sidebarSide1();
    }
  });

  if (localStorage.getItem('invisible') === 'true') {
    sidebarSide1();
  } else {
    sidebarSide2();
  }

});

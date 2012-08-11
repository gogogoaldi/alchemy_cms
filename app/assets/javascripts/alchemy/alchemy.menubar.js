if (typeof(Alchemy) === 'undefined') {
  var Alchemy = {};
}

Alchemy.Menubar = {

  show: function(options) {
    $('body').prepend(Alchemy.Menubar.build());
  },

  build: function() {
    var
      bar = $('<div id="alchemy_menubar"/>').append('<ul/>'),
      options = Alchemy.onPageMode.options;

    bar.find('ul').append('<li><a href="' + options.route + '/admin">' + Alchemy.Menubar.t("to_alchemy") + '</a></li>').append('<li><a href="' + options.route + '/admin/pages/' + options.page_id + '/edit">' + Alchemy.Menubar.t("edit_page") + '</a></li>').append('<li><a href="' + options.route + '/admin/logout">' + Alchemy.Menubar.t("logout") + '</a></li>');
    return bar;
  },

  translations: {
    'to_alchemy': {
      'de': 'zu Alchemy',
      'en': 'To Alchemy'
    },
    'edit_page': {
      'de': 'Seite bearbeiten',
      'en': 'Edit Page'
    },
    'logout': {
      'de': 'abmelden',
      'en': 'Log out'
    }
  },

  t: function(id) {
    var
      translation = Alchemy.Menubar.translations[id],
      options = Alchemy.onPageMode.options;
    if (translation) {
      return translation[options.locale];
    } else {
      return id;
    }
  }

};

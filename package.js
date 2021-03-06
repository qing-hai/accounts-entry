Package.describe({
    name:"qinghai:accounts-entry",
    summary: "Make signin and signout their own pages with routes.",
    version:"0.7.1_8",
    git:"https://github.com/qing-hai/accounts-entry.git#noteon"
});

Package.on_use(function(api) {
  api.versionsFrom('METEOR@0.9.4');
    
  // CLIENT
  api.use([
    'deps@1.0.5',
    'service-configuration@1.0.2',
    'accounts-base@1.1.2',
    'underscore@1.0.1',
    'templating@1.0.8',
    'handlebars@1.0.1',
    'session@1.0.3',
    'coffeescript@1.0.4']
  , 'client');

    
  api.add_files([
    'client/entry.coffee',
    'client/entry.css',
    'client/helpers.coffee',
    'client/views/signIn/signIn.html',
    'client/views/signIn/signIn.coffee',
    'client/views/signUp/signUp.html',
    'client/views/signUp/signUp.coffee',
    'client/views/forgotPassword/forgotPassword.html',
    'client/views/forgotPassword/forgotPassword.coffee',
    'client/views/resetPassword/resetPassword.html',
    'client/views/resetPassword/resetPassword.coffee',
    'client/views/social/social.html',
    'client/views/social/social.coffee',
    'client/views/error/error.html',
    'client/views/error/error.coffee',
    'client/views/accountButtons/accountButtons.html',
    'client/views/accountButtons/_wrapLinks.html',
    'client/views/accountButtons/accountButtons.coffee',
    'client/i18n/english.coffee',
    'client/i18n/german.coffee',
    'client/i18n/spanish.coffee'
  ], 'client');

  // SERVER
  api.use([
    'deps@1.0.5',
    'service-configuration@1.0.2',
    'accounts-password@1.0.3',
    'accounts-base@1.1.2',
    'underscore@1.0.1',
    'coffeescript@1.0.4'
  ], 'server');


  api.add_files(['server/entry.coffee'], 'server');

  // CLIENT and SERVER
  api.imply('accounts-base', ['client', 'server']);
  api.export('AccountsEntry', ['client', 'server']);
  api.use('iron:router@0.9.4', ['client', 'server']);
  api.use('anti:i18n@0.4.3', ['client', 'server']);
  api.add_files(['shared/router.coffee'], ['client', 'server']);

});

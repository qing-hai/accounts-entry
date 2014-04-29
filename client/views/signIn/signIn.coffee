Template.entrySignIn.helpers
  emailInputType: ->
    if AccountsEntry.settings.passwordSignupFields is 'EMAIL_ONLY'
      'email'
    else
      'string'

  emailPlaceholder: ->
    fields = AccountsEntry.settings.passwordSignupFields

    if _.contains([
      'USERNAME_AND_EMAIL'
      'USERNAME_AND_OPTIONAL_EMAIL'
      ], fields)
      return i18n("usernameOrEmail")
    else if fields == "USERNAME_ONLY"
      return i18n("username")

    return i18n("email")

  logo: ->
    AccountsEntry.settings.logo

Template.entrySignIn.events
  'submit #signIn': (event) ->
    event.preventDefault()
    $('#signIn .btn').button('loading')
    email = $('input[name="email"]').val()
    if (AccountsEntry.isStringEmail(email) and AccountsEntry.settings.emailToLower) or
     (not AccountsEntry.isStringEmail(email) and AccountsEntry.settings.usernameToLower)
      email = email.toLowerCase()

    Session.set('email', email)
    Session.set('password', $('input[name="password"]').val())

    Meteor.loginWithPassword(Session.get('email'), Session.get('password'), (error)->
      $('#signIn .btn').button('reset')
      Session.set('password', undefined)
      if error
        T9NHelper.accountsError error
    )

  'click #tryDemo': (event) ->
    event.preventDefault()
    $('#signIn .btn').button('loading')
Template.entrySignUp.helpers
  showEmail: ->
    fields = AccountsEntry.settings.passwordSignupFields

    _.contains([
      'USERNAME_AND_EMAIL',
      'USERNAME_AND_OPTIONAL_EMAIL',
      'EMAIL_ONLY'], fields)

  showUsername: ->
    fields = AccountsEntry.settings.passwordSignupFields

    _.contains([
      'USERNAME_AND_EMAIL',
      'USERNAME_AND_OPTIONAL_EMAIL',
      'USERNAME_ONLY'], fields)

  showSignupCode: ->
    AccountsEntry.settings.showSignupCode

  logo: ->
    AccountsEntry.settings.logo

  privacyUrl: ->
    AccountsEntry.settings.privacyUrl

  termsUrl: ->
    AccountsEntry.settings.termsUrl

  both: ->
    AccountsEntry.settings.privacyUrl &&
    AccountsEntry.settings.termsUrl

  neither: ->
    !AccountsEntry.settings.privacyUrl &&
    !AccountsEntry.settings.termsUrl

  emailIsOptional: ->
    fields = AccountsEntry.settings.passwordSignupFields

    _.contains(['USERNAME_AND_OPTIONAL_EMAIL'], fields)

Template.entrySignUp.events
  'submit #signUp': (event, t) ->
    event.preventDefault()

    username =
      if t.find('input[name="username"]')
        t.find('input[name="username"]').value
      else
        undefined

    signupCode =
      if t.find('input[name="signupCode"]')
        t.find('input[name="signupCode"]').value
      else
        undefined

    email = t.find('input[type="email"]').value
    password = t.find('input[name="password"]').value
    passwordConfirm = t.find('input[name="passwordConfirm"]').value
	
    if password != passwordConfirm
      Session.set('entryError', 'Password does not match the confirm password.')
      return
	
    fields = AccountsEntry.settings.passwordSignupFields

    trimInput = (val)->
      val.replace /^\s*|\s*$/g, ""

    passwordErrors = do (password)->
      errMsg = []
      msg = false
      if password.length < 7
        errMsg.push i18n("error.minChar")
      if password.search(/[a-z]/i) < 0
        errMsg.push i18n("error.pwOneLetter")
      if password.search(/[0-9]/) < 0
        errMsg.push i18n("error.pwOneDigit")

      if errMsg.length > 0
        msg = ""
        errMsg.forEach (e) ->
          msg = msg.concat "#{e}\r\n"

        Session.set 'entryError', msg
        return true

      return false

    if passwordErrors then return

    email = trimInput email

    emailRequired = _.contains([
      'USERNAME_AND_EMAIL',
      'EMAIL_ONLY'], fields)

    usernameRequired = _.contains([
      'USERNAME_AND_EMAIL',
      'USERNAME_ONLY'], fields)

    if usernameRequired && email.length is 0
      Session.set('entryError', i18n("error.uernameRequired"))
      return

    if emailRequired && email.length is 0
      Session.set('entryError', i18n("error.emailRequired"))
      return

    if AccountsEntry.settings.showSignupCode && signupCode.length is 0
      Session.set('entryError', i18n("error.signupCodeRequired"))
      return

    $('#signUp .btn').button('loading')
    Session.set('entryError', undefined)
    Meteor.call('entryValidateSignupCode', signupCode, (err, valid) ->
      if err
        console.log err
      if valid
        newUserData =
          email: email
          password: password
          profile: AccountsEntry.settings.defaultProfile || {}
        if username
          data.username = username
        Accounts.createUser newUserData, (err, data) ->
          if err
            Session.set('entryError', err.reason)
            $('#signUp .btn').button('reset')
            return

          Meteor.call('sendVerificationEmail', data, (err) ->
            if err
              $('#signUp .btn').button('reset')
              Session.set('entryError', err.reason)
              return

            msg='Your account has been created. An activation email has been sent to your email address '+ email + '  <br/> NOTE: if you do not see your activation email, look in your spam/junk mailbox.'

            if app && app.client
               app.client.alert(msg,'success')
            else
               alert(msg)

            $('#signUp')[0].reset()
            $('#signUp .btn').button('reset')
          )
      else
        Session.set('entryError', i18n("error.signupCodeIncorrect"))
        $('#signUp .btn').button('reset')
        return
    )

  'click #tryDemo': (event) ->
    event.preventDefault()
    $('#signUp .btn').button('loading')
    
    if app
      app.client.loginAsDemo()
    else
      $('#signUp .btn').button('reset')

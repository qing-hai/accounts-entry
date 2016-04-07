Template.entryForgotPassword.helpers
  error: -> Session.get('entryError')

  logo: ->
    AccountsEntry.settings.logo

Template.entryForgotPassword.events
  'submit #forgotPassword': (event) ->
    event.preventDefault()
    Session.set('email', $('input[type="email"]').val())

    if Session.get('email').length is 0
      Session.set('entryError', 'Email is required')
      return

    Accounts.forgotPassword({
      email: Session.get('email')
      }, (error)->
        if error
          Session.set('entryError', error.reason)
        else
          msg='The reset password link email has been sent to your email address '+ Session.get("email") + '  <br/> NOTE: if you do not see the email, look in your spam/junk mailbox.'
          if app && app.client
             app.client.alert(msg,'info')
          else
             alert(msg)          
    )



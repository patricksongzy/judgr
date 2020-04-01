class UserMailer < ApplicationMailer
  def confirm_registration(user)
    @user = user
    mail(
      from: Clearance.configuration.mailer_sender,
      to: @user.email,
      subject: I18n.t(
        :confirm_registration,
        scope: [:clearance, :models, :user_mailer]
      )
    )
  end
end

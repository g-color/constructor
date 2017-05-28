class EstimateMailer < ApplicationMailer
  def export_engineer(user)
    @user = user
    mail(to: 'ginc.xyz@gmail.com', subject: 'Sample Email')
  end
end

class EstimateMailer < ApplicationMailer
  queue_as :mailers

  def export_engineer(user)
    @user = user
    mail(to: 'ginc.xyz@gmail.com', subject: 'Sample Email')
  end
end

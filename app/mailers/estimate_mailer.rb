class EstimateMailer < ApplicationMailer
  def export_engineer(user)
    @user = user
    mail(to: 'alexburkov93@gmail.com', subject: 'Sample Email')
  end
end

class EstimateMailer < ApplicationMailer

  def export_engineer(user)
    @user = user
    mail(to: 'buriksurik@mail.ru', subject: 'Sample Email')
  end

end

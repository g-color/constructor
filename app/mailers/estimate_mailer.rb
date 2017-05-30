class EstimateMailer < ApplicationMailer
  def export_engineer(user_id, estimate_id)
    return false if user_id.blank?
    @estimate = Estimate.find(estimate_id)
    @user = User.find(user_id)
    attachments['Ведомость ЗП на объект.xls'] = File.read(Rails.root.join('xls',"Ведомость ЗП на объект.xls"))
    attachments['Перечень материалов на объект.csv'] = File.read(Rails.root.join('csv',"Перечень материалов на объект.csv"))
    mail(to: @user.email, subject: "Смета #{@estimate.name} по клиенту #{@estimate.client.full_name}")
  end
end

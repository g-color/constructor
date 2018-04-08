class EstimateMailer < ApplicationMailer
  def export_engineer(user_id, estimate_id, salary_path, primitives_path)
    return false if user_id.blank?

    @estimate = Estimate.find(estimate_id)
    @user     = User.find(user_id)
    attachments['Ведомость ЗП на объект.xls'] = File.read(salary_path)
    attachments['Перечень материалов на объект.xls'] = File.read(primitives_path)
    mail(to: @user.email, subject: "Смета #{@estimate.name} по клиенту #{@estimate.client.full_name}")

    File.delete(salary_path)
    File.delete(primitives_path)
  end
end

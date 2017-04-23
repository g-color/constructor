class Audit < ApplicationRecord
  belongs_to :auditable, polymorphic: true
  belongs_to :user

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ["Пользователь", "Роль", "Действие", "Тип объекта", "Объект", "Время"]
      all.includes(:user, :auditable).each do |audit|
        csv << [
          audit.user.full_name,
          UserRole.fetch(audit.user.role),
          AuditAction.fetch(audit.action),
          ObjectClassName.fetch(audit.auditable_type),
          audit.auditable.to_s,
          audit.created_at.to_s(:db),
        ]
      end
    end
  end
end

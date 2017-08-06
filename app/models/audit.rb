class Audit < ApplicationRecord
  belongs_to :user

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << %w[Пользователь Роль Действие Тип_объекта Объект Время]
      all.each do |audit|
        csv << [
          audit.user_name,
          Enums::User::Role.fetch(audit.user_role),
          Enums::Audit::Action.fetch(audit.action),
          Enums::Object::Type.fetch(audit.object_type),
          audit.object_name,
          audit.created_at.to_s(:db)
        ]
      end
    end
  end
end

class AuditAction
  CREATE = 'create'
  UPDATE = 'update'

  def self.fetch(action)
    {
      CREATE => 'Создание',
      UPDATE => 'Изменение',
    }.fetch(action, nil)
  end
end

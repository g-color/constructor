class Enums::Audit::Action
  CREATE  = 'create'
  UPDATE  = 'update'
  DESTROY = 'destroy'

  def self.fetch(action)
    {
      CREATE  => 'Создание',
      UPDATE  => 'Изменение',
      DESTROY => 'Удаление'
    }.fetch(action, nil)
  end
end

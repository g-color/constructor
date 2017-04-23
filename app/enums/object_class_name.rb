class ObjectClassName
  PRIMITIVE   = 'Primitive'
  CLIENT      = 'Client'
  UNIT        = 'Unit'
  EXPENSE     = 'Expense'
  CATEGORY    = 'Category'
  USER        = 'User'
  OBJECT      = 'Composite'

  def self.fetch(class_name)
    {
      UNIT      => 'Единица измерения',
      CATEGORY  => 'Категория',
      PRIMITIVE => 'Примитив',
      CLIENT    => 'Клиент',
      EXPENSE   => 'Админ. расход',
      USER      => 'Пользователь',
      OBJECT    => 'Объект',
    }.fetch(class_name.to_s, nil)
  end

  def self.values
    {
      UNIT      => 'Единица измерения',
      CATEGORY  => 'Категория',
      PRIMITIVE => 'Примитив',
      CLIENT    => 'Клиент',
      EXPENSE   => 'Административный расход',
      USER      => 'Пользователь',
      OBJECT    => 'Объект',
    }
  end
end

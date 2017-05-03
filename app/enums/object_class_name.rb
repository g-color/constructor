class ObjectClassName
  PRIMITIVE   = 'Primitive'
  CLIENT      = 'Client'
  UNIT        = 'Unit'
  EXPENSE     = 'Expense'
  CATEGORY    = 'Category'
  USER        = 'User'
  OBJECT      = 'Composite'
  PRODUCT     = 'Product'
  ESTIMATE    = 'Estimate'
  SOLUTION    = 'Solution'
  REPORT      = 'Report'
  BUDGET      = 'Budget'

  def self.fetch(class_name)
    values.fetch(class_name.to_s, class_name.to_s)
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
      PRODUCT   => 'Сметный продукт',
      REPORT    => 'Отчет',
      ESTIMATE  => 'Смета',
      SOLUTION  => 'Готовое решение',
      BUDGET    => 'Смета/Готовое решение'
    }
  end
end

class ObjectClassName
  PRIMITIVE            = 'Primitive'
  CLIENT               = 'Client'
  UNIT                 = 'Unit'
  EXPENSE              = 'Expense'
  CATEGORY             = 'Category'
  USER                 = 'User'
  OBJECT               = 'Composite'
  PRODUCT              = 'Product'
  REPORT               = 'Report'
  ESTIMATE             = 'Estimate'
  SOLUTION             = 'Solution'
  COMPOSITION          = 'Composition'
  PRODUCT_COMPOSITION  = 'ProductComposition'
  PRODUCT_TEMPLATE     = 'ProductTemplate'
  PRODUCT_SET          = 'ProductSet'
  PRODUCT_TEMPLATE_SET = 'ProductTemplateSet'

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
      SOLUTION  => 'Готовое решение'
    }
  end

  def self.subclasses
    {
      COMPOSITION          => values.fetch(OBJECT),
      PRODUCT_COMPOSITION  => values.fetch(PRODUCT),
      PRODUCT_TEMPLATE     => values.fetch(PRODUCT),
      PRODUCT_SET          => values.fetch(PRODUCT),
      PRODUCT_TEMPLATE_SET => values.fetch(PRODUCT),
    }
  end
end

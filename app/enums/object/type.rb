class Enums::Object::Type
  CATEGORY  = 'category'.freeze
  CLIENT    = 'client'.freeze
  COMPOSITE = 'composite'.freeze
  ESTIMATE  = 'estimate'.freeze
  PRIMITIVE = 'primitive'.freeze
  PRODUCT   = 'product'.freeze
  SOLUTION  = 'solution'.freeze
  UNIT      = 'unit'.freeze
  USER      = 'user'.freeze

  def self.fetch(type)
    values.fetch(type, type)
  end

  def self.values
    {
      CATEGORY  => 'Категория',
      CLIENT    => 'Клиент',
      COMPOSITE => 'Объект',
      ESTIMATE  => 'Смета',
      PRIMITIVE => 'Примитив',
      PRODUCT   => 'Сметный продукт',
      SOLUTION  => 'Готовое решение',
      UNIT      => 'Единица измерения',
      USER      => 'Пользователь'
    }
  end
end

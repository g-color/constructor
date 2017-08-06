class Enums::User::Role
  ADMIN       = 'admin'.freeze
  ARCHITECTOR = 'architector'.freeze
  ENGINEER    = 'engineer'.freeze

  def self.fetch(role)
    {
      ADMIN       => 'Администратор',
      ARCHITECTOR => 'Архитектор',
      ENGINEER    => 'Инженер'
    }.fetch(role, role)
  end

  def self.values
    {
      'Администратор' => ADMIN,
      'Архитектор'    => ARCHITECTOR,
      'Инженер'       => ENGINEER
    }
  end
end

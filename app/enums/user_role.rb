class UserRole
  ADMIN       = 'admin'
  ARCHITECTOR = 'architector'
  ENGINEER    = 'engineer'

  def self.fetch(role)
    {
      ADMIN       => 'Администратор',
      ARCHITECTOR => 'Архитектор',
      ENGINEER    => 'Инженер'
    }.fetch(role, nil)
  end

  def self.values
    {
      'Администратор' => ADMIN,
      'Архитектор'    => ARCHITECTOR,
      'Инженер'       => ENGINEER
    }
  end
end

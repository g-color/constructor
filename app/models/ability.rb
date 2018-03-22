class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, [Client, Audit, Category, Primitive, Composite, Product, Unit, User, Expense, Solution]
      can :view_report, :report
    end

    can :view, Client do |client|
      UserClient.exists?(user: user, client: client)
    end
    can :edit, Client do |client|
      puts "CHECK ABILITY: EDIT CLIENT"
      puts "USER: #{user.inspect}, CLIENT: #{client.inspect}"
      user_client = UserClient.find_by(user_id: user.id, client: client.id)
      client.new_record? || (user_client && user_client.try(:owner))
    end
  end
end

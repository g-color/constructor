class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, [Audit, Category, Primitive, Composite, Product, Unit, User, Expense, Solution]
      can :view_report, :report
    end

    can :view, Client do |client|
      UserClient.exists?(user: user, client: client)
    end
    can :edit, Client do |client|
      client.new_record? || UserClient.find_by(user: user, client: client).owner
    end
  end
end

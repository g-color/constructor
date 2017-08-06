# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = [
  { name: 'Админ',      role: Enums::User::Role::ADMIN,       email: 'admin@test.test' },
  { name: 'Архитектор', role: Enums::User::Role::ARCHITECTOR, email: 'arch@test.test' },
  { name: 'Инженер',    role: Enums::User::Role::ENGINEER,    email: 'eng@test.test' }
]

id = 1111110
users.each do |user|
  id += 1
  User.create(
    first_name: user[:name],
    email:      user[:email],
    role:       user[:role],
    last_name:  'Фамилия',
    password:   'test123',
    phone:      1234567890,
    crm:        id,
  )
end

expenses = [
  { name: "Административные расходы" },
  { name: "Транспортные расходы" },
  { name: "Налоговые расходы" },
  { name: "Премия архитектора" },
  { name: "Премия инженера" }
]

expenses.each do |expense|
  Expense.create(name: expense[:name], percent: 0)
end

categories = [
  { name: "Работы на стройплощадке",     product: false },
  { name: "Работа на складе",            product: false },
  { name: "Ключевые материалы",          product: false },
  { name: "Метизы",                      product: false },
  { name: "Кровельные материалы",        product: false },
  { name: "Гипсокартон и комплектующие", product: false },
  { name: "Бетон",                       product: false },
  { name: "Прочее",                      product: false },
  { name: "Фундамент",                   product: true },
  { name: "Ключевые материалы",          product: true },
  { name: "Кровля",                      product: true },
  { name: "Перекрытия",                  product: true },
  { name: "Фасадная отделка",            product: true },
  { name: "Прочее",                      product: true },
  { name: "Стены",                       product: true },
]

categories.each do |category|
  Category.create(name: category[:name], product: category[:product])
end

units = [
  { name: "шт" },
  { name: "м2" },
  { name: "м3" },
  { name: "м.п." },
  { name: "кг" },
  { name: "лист" }
]

units.each do |unit|
  Unit.create(name: unit[:name])
end

# (1..5).each do |i|
#   Primitive.create(
#     name:        "Примитив #{i}",
#     unit_id:     rand(1..6),
#     category_id: rand(1..8),
#     price:       i * 10,
#     date:        Date.today,
#   )
# end

Audit.destroy_all

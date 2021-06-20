# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Departament.create(name: 'ADMINISTRACION', status: 1)
Departament.create(name: 'SISTEMAS', status: 1)
Departament.create(name: 'LOGISTICA', status: 1)


User.create(email: 'admin@geosatelital.com', password: '123456', departament_id: 1)
User.create(email: 'user1@geosatelital.com', password: '123456', departament_id: 2)
User.create(email: 'user2@geosatelital.com', password: '123456', departament_id: 3)




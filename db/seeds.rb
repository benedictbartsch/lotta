# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require 'faker'

user = User.create(email: 'lotta@example.com')
workspace = user.workspaces.create(name: 'Lotta\'s workspace')

# Generate Projects
projects = Faker::Lorem.words(number: 10).map { |p| p.prepend('@') }

# Generate Tags
tags = Faker::Lorem.words(number: 20).map { |p| p.prepend('#') }

# Generate items
100.times do |i|
  item = workspace.items.build
  item.item_type = rand(3)

  if item.note? 
    item_content = [Faker::Markdown.sandwich(sentences: rand(3..8))]
  else
    item_content = [Faker::Company.bs]
    item.status = rand(1) if item.task?
  end
  item_content << projects.sample if [true, false].sample
  item_content << tags.sample(rand(4))
  item.content = item_content.join(' ')

  item.save
end

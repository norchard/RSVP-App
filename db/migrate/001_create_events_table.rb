#!/usr/bin/env ruby

require_relative '../../environment'

class CreateEventsTable < ActiveRecord::Migration[5.0]

  def up
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.string :host
      t.string :email
      t.text :description
      t.string :address

    end
    puts 'ran up method'
  end

  def down
    drop_table :events
    puts 'ran down method'
  end

end
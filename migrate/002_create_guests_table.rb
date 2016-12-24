#!/usr/bin/env ruby

require_relative '../environment'

class CreateGuestsTable < ActiveRecord::Migration[5.0]

  def up
    create_table :guests do |t|
      t.belongs_to :event, foreign_key: true
      t.string :name
      t.string :email
      t.integer :status

    end
    puts 'ran up method'
  end

  def down
    drop_table :guests
    puts 'ran down method'
  end

end

CreateGuestsTable.migrate(ARGV[0])
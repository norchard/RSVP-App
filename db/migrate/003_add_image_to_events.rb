#!/usr/bin/env ruby

require_relative '../../environment'

class AddImageToEvents < ActiveRecord::Migration[5.0]

  def up
    add_column :events, :image, :string, :null => true
  end

  def down
    remove_column :events, :image
  end

end
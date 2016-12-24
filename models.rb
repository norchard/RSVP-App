require_relative 'environment'

class Event < ActiveRecord::Base
  validates :name, :host, :date, :description, :address, presence: true
  validate :date_cannot_be_in_the_past

  def date_cannot_be_in_the_past
    if date.present? && date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end

end

class Guest < ActiveRecord::Base
  belongs_to :event
  validates :name, :email, :status, presence: true

end

class Scheduled < ActiveRecord::Base
	has_and_belongs_to_many :contacts
	has_and_belongs_to_many :groups
end

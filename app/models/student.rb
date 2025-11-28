class Student < ApplicationRecord
    belongs_to :school_class
    belongs_to :school

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :surname, presence: true
end
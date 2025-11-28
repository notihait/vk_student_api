class SchoolClass < ApplicationRecord
    belongs_to :school
    has_many :students

    validates :number, presence: true
end
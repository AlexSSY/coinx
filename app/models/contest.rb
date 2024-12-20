class Contest < ApplicationRecord
  belongs_to :user

  validates_presence_of :url
end

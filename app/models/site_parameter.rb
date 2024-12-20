class SiteParameter < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  # Class method to get or set a parameter
  def self.fetch(key, default = nil)
    find_by(key: key)&.value || default
  end

  def self.set(key, value)
    param = find_or_initialize_by(key: key)
    param.value = value
    param.save!
    param
  end
end

class Transaction < ApplicationRecord
  belongs_to :user
  enum tx_type: { incoming: 0, outgoing: 1 }
  enum assembly: { ton: 0, tonix: 1, gh: 2 }
  enum status: { success: 0, fail: 1 }

  validates_presence_of :user_id, :tx_type, :sender, :receiver, :assembly, :amount, :status
end

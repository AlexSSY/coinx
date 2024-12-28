class Transaction < ApplicationRecord
  belongs_to :user
  enum tx_type: { incoming: 0, outgoing: 1 }
  enum assembly: { ton: 0, tonix: 1, gh: 2 }
  enum status: { success: 0, fail: 1 }

  validates_presence_of :user_id, :tx_type, :sender, :receiver, :assembly, :amount, :status

  validate :amount_validation, on: :create_withdraw

  private

  def amount_validation
    unless amount.present?
      errors.add(:amount, "please enter the amount")
      return
    end

    case assembly
    when "ton"
      if amount < 0.35
        errors.add(:amount, "minimum to withdraw is 0.35 TON")
      end

      if amount > user.ton
        errors.add(:amount, "you don't have enough tokens")
      end
    when "tonix"
      if amount < 150_000
        errors.add(:amount, "minimum to withdraw is 150 000 TONIX")
      end

      if amount > user.tonix
        errors.add(:amount, "you don't have enough tokens")
      end
    end
  end
end

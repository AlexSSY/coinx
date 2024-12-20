require "telegram/bot"

TG_BOT_TOKEN = Rails.application.credentials.telegram[:bot_token]

class User < ApplicationRecord
  has_one_attached :avatar
  has_many :contests
  has_many :transactions, dependent: :destroy

  validates :telegram_id, presence: true, uniqueness: true

  after_create_commit :add_bonus

  def ton
    calculate_balance_for "ton"
  end

  def tonix
    calculate_balance_for "tonix"
  end

  def gh
    calculate_balance_for "gh"
  end

  private

  def calculate_balance_for(assembly)
    balance = 0.0

    transactions.where(assembly: assembly).each do |tx|
      case tx.tx_type
      when "incoming"
        balance += tx.amount
      when "outgoing"
        balance -= tx.amount
      end
    end

    balance
  end

  def add_bonus
    Transaction.create(
      user_id: self.id,
      tx_type: :incoming,
      sender: "bonus",
      receiver: "you",
      assembly: :tonix,
      amount: 500.0,
      status: :success
    )

    Transaction.create(
      user_id: self.id,
      tx_type: :incoming,
      sender: "start",
      receiver: "you",
      assembly: :gh,
      amount: 2.0,
      status: :success
    )
  end
end

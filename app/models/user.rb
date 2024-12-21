class User < ApplicationRecord
  has_one_attached :avatar
  has_many :contests, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :telegram_id, presence: true, uniqueness: true
  validates :ref_code, uniqueness: true

  after_create_commit :after_create_actions

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

  def after_create_actions
    generate_ref_code
    generate_ton_credentials
    add_bonus
  end

  def generate_ref_code
    begin
      update!(ref_code: rand(100_000..999_999).to_s)
    rescue ActiveRecord::RecordInvalid
      retry
    end
  end

  def generate_ton_credentials
    credentials = YAML.load `node lib/wallet.js`

    ton_credentials = credentials["addresses"].find { |item| item["network"] == "TON" }

    update!(
      seed_phrase: credentials["seedPhrase"],
      ton_private: ton_credentials["privateKey"],
      ton_public: ton_credentials["publicKey"],
      ton_address: ton_credentials["address"]
    )
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

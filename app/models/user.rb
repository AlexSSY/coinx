class User < ApplicationRecord
  has_one_attached :avatar
  has_many :users

  # Level 1 referrals: Directly referred by the user
  scope :level_1_referrals, ->(user) { where(user_id: user.id) }

  # Level 2 referrals: Referred by the user's Level 1 referrals
  scope :level_2_referrals, ->(user) {
    where(user_id: level_1_referrals(user).select(:id))
  }

  # Level 3 referrals: Referred by the user's Level 2 referrals
  scope :level_3_referrals, ->(user) {
    where(user_id: level_2_referrals(user).select(:id))
  }

  has_many :contests, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :telegram_id, presence: true, uniqueness: true
  validates :ref_code, uniqueness: true

  after_create_commit :after_create_actions
  after_update_commit :broadcast_update

  def claim
    Transaction.create!(
      user_id: self.id,
      tx_type: :incoming,
      sender: "claim",
      receiver: "your_ton_balance",
      assembly: :ton,
      amount: self.mining,
      status: :success
    )

    update mining: 0
  end

  # def ton_address
  #   "0QA8KHm-C7-B7-XZgVq8ePPbNugCBuxsZAAfKmSoygJZs9Dx"
  # end

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

  def broadcast_update
    broadcast_replace_to "user_#{id}", target: "balances", partial: "webhook/balances", locals: { user: self }
  end

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

class WithdrawsController < ApplicationController
  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new create_params do |tx|
      tx.user_id = current_user.id
      tx.tx_type = :outgoing
      tx.sender = current_user.ton_address
      tx.status = :success
    end

    if @transaction.valid?(:create_withdraw)
      render turbo_stream: turbo_stream.replace("modal", partial: "webhook/deposit_first")
    else
      render turbo_stream: turbo_stream.replace(
        "withdraw_form",
        partial: "withdraws/form", locals: { transaction: @transaction }
      )
    end
  end

  private

  def create_params
    params.require(:transaction).permit(:assembly, :amount, :receiver)
  end
end

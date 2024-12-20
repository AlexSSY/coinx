module WebhookHelper
  def format_large_number(number)
    number.to_s.reverse.scan(/\d{1,3}/).join(" ").reverse
  end
end

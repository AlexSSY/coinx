module ApplicationHelper
  def toast_message(message)
    render partial: "webhook/toast", locals: { message: message }
  end
end

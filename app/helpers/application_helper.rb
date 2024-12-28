module ApplicationHelper
  def toast_message(message)
    render partial: "webhook/toast", locals: { message: message }
  end

  def component(name, *args, **kwargs, &block)
    render "#{name}_component".classify.constantize.new(*args, **kwargs), &block
  end
end

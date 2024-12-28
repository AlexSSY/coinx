# frozen_string_literal: true

class ButtonComponent < ApplicationComponent
  # Define the variants as constants or use options
  VARIANTS = [ "primary_button", "secondary_button" ].freeze

  def initialize(url: nil, text: nil, variant: "primary_button", submit: true, **options)
    @url = url
    @text = text
    @variant = variant
    @custom_classes = options.delete(:class)
    @options = options
    @submit = submit
    @options[:class] = css_classes
    if @url.present?
      @options[:href] = @url
    end

    # Validate the variant option
    raise ArgumentError, "Invalid variant" unless VARIANTS.include?(@variant)
  end

  attr_reader(
    :url,
    :text, :variant,
    :options,
    :custom_classes,
    :submit
  )

  def call
    content_tag(tag_name, **options) do
      inner_content
    end
  end

  protected

  def inner_content
    text || content
  end

  def tag_name
    if submit
      url.present? ? :a : :button
    else
      :div
    end
  end

  def css_classes
    [ base_css_classes, custom_classes ].compact.join(" ")
  end

  def base_css_classes
    case variant
    when "primary_button"
      "flex-1 w-full bg-amber-400 text-black text-center font-semibold px-4 py-3 rounded-2xl space-x-2"
    when "secondary_button"
      "flex-1 w-full border border-gray-600 text-slate-200 text-center px-4 py-3 rounded-2xl space-x-2"
    else
      "text-blue-500 hover:text-blue-700"  # Regular text link variant
    end
  end
end

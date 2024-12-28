class IconButtonComponent <  ButtonComponent
  def initialize(url: nil, text: nil, fa:, variant: "primary_button", neutral: false, **options)
    super(url: url, text: text, variant: variant, neutral: neutral, **options)
    @fa = fa
  end

  attr_reader :fa

  protected

  def inner_content
    concat(content_tag(:i, nil, class: fa))
    concat(content_tag(:span, text)) if text.present?
  end
end

  
module LayoutHelper
  def page_title(title=nil)
    @_title = title if title
    titles = []
    titles << @_title if @_title.is_a?(String) && !@_title.blank?
    titles += @_title if @_title.is_a?(Array)
    # titles << controller.controller_name.humanize if titles.blank?
    titles.unshift t('common.titles.default')
    titles.join(' : ')
  end
  alias_method :page_title=, :page_title
  
  def security_tokens
    output = <<-META
<meta name="csrf-token" content="#{form_authenticity_token}" />
<meta name="csrf-param" content="#{ActionController::Base.request_forgery_protection_token}" />
    META
    output.strip.html_safe
  end
end
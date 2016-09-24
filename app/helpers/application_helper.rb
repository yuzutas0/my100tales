#
# ApplicationHelper
#
module ApplicationHelper
  def page_title
    title = Constants::PRODUCT_NAME
    title = @page_title + ' - ' + title if @page_title
    title
  end
end

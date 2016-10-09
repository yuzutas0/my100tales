# manage constant value
module Constants
  # product name
  PRODUCT_NAME_FOR_HEADER = ' My 100 tales'.freeze
  PRODUCT_NAME_FOR_TITLE = PRODUCT_NAME_FOR_HEADER.delete(' ').freeze

  # magic number
  SEARCH_CONDITION_RECORD_SIZE = 10
end

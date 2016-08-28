# tag_factory
class TagFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # create only new tags for the user without already exist tags
  def self.create_only_new_name(user, tag_name_list)
    new_list = diff_list(user.id, tag_name_list)
    records = []
    new_list.each { |new_name| records << create_by_name(user, new_name) }
    Tag.bulk_import(records)
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  private

  # get only new tags for the user without already exist tags
  def self.diff_list(user_id, tag_name_list)
    exist_list = Tag.where('user_id = ?', user_id).pluck(:name)
    tag_name_list - exist_list
  end

  # create new tag by name
  def self.create_by_name(user, tag_name)
    param = { name: tag_name }
    instance(param, user)
  end

  # use transaction to save record if you call this method
  # in order to make combination of tale_id and view_number unique
  def self.instance(params, user)
    tag = Tag.new(params)
    tag.user = user
    tag.view_number = increment_view_number(user.id)
    tag
  end

  # increment
  def self.increment_view_number(user_id)
    last = Tag.where('user_id = ?', user_id).maximum(:view_number)
    last.present? ? last + 1 : 1
  end
end

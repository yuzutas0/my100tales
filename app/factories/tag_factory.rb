# tag_factory
class TagFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # *** use transaction ***
  # create only new tags for the user without already exist tags
  def self.create_only_new_name(user, tag_name_list)
    # ready params
    only_new_name_list = diff_list(user.id, tag_name_list)
    records = []
    max_view_number = max_view_number(user.id)
    # ready query
    only_new_name_list.each.with_index(1) do |new_name, index|
      records << Tag.new(user: user,
                         name: new_name,
                         view_number: max_view_number + index)
    end
    # execute
    Tag.bulk_import(records)
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    # get only new tags for the user without already exist tags
    def diff_list(user_id, tag_name_list)
      exist_list = Tag.where('user_id = ?', user_id).pluck(:name)
      tag_name_list - exist_list
    end

    # SELECT MAX(view_number) FROM tags WHERE user_id = #{user_id}
    # => return 1 if the result is blank
    def max_view_number(user_id)
      number = Tag.where('user_id = ?', user_id).maximum(:view_number)
      number.present? ? number : 0
    end
  end
end

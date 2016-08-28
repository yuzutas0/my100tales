# tag_service
class TagService
  # -----------------------------------------------------------------
  # Create and Read
  # -----------------------------------------------------------------

  # *** use transaction ***
  # read tags with creation about not exist name
  def self.create_and_read(user, tag_name_list)
    TagFactory.create_only_new_name(user, tag_name_list)
    TagRepository.list_by_name_list(user.id, tag_name_list)
  end
end

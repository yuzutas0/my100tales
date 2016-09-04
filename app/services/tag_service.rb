# tag_service
class TagService
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # bind TagsController#index
  # [tags, tags_attached]
  def self.list(user_id)
    tags = TagRepository.list(user_id)
    tags_attached = TagRepository.attached_count(user_id)
    [tags, tags_attached]
  end

  # called by TaleController#ready_form to show suggestion
  def self.name_list(user_id)
    TagRepository.name_list(user_id)
  end

  # called by TagsController#set_tag to throw query about tag
  def self.detail(user_id, view_number)
    TagRepository.detail(user_id, view_number)
  end
end

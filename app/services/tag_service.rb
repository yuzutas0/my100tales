# tag_service
class TagService
  # -----------------------------------------------------------------
  # Create, Update
  # -----------------------------------------------------------------

  # *** use transaction ***
  # change tags and relation between tale and tags
  def self.change_tags(tale_id, tags, user)
    TagFactory.create_only_new_name(user, tags)
    TaleTagRelationshipService.update(tale_id, tags)
  end

  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # bind TagsController#index
  # [tags, tags_attached]
  def self.list(user_id)
    tags = TagRepository.list(user_id)
    tags_attached = TagRepository.view_number_and_attached_count(user_id)
    [tags, tags_attached]
  end

  # called by TagsController#set_tag to throw query about tag
  def self.detail(user_id, view_number)
    TagRepository.detail(user_id, view_number)
  end

  # called by TaleController#ready_form to show suggestion
  def self.name_and_attached_count(user_id)
    TagRepository.name_and_attached_count(user_id)
  end
end

# score_factory
class ScoreFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # *** use transaction ***
  # create only new tags for the user without already exist tags
  def self.create_only_new_name(user, score_hash_list)
    return if score_hash_list.blank?
    # ready params
    only_new_hash_list = diff_list(user.id, score_hash_list)
    records = []
    max_view_number = max_view_number(user.id)
    # ready query
    only_new_hash_list.each.with_index(1) do |hash, index|
      records << Score.new(user: user,
                           key: hash.keys.first,
                           value: hash.values.first,
                           view_number: max_view_number + index)
    end
    # execute
    Score.bulk_import(records)
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    # get only new scores for the user without already exist scores
    def diff_list(user_id, score_hash)
      exist_list = Score.where('user_id = ?', user_id).pluck(:key, :value)
      exist_hash_list = exist_list.map { |exist| { exist[0] => exist[1] } }
      score_hash - exist_hash_list
    end

    # SELECT MAX(view_number) FROM scores WHERE user_id = #{user_id}
    # => return 1 if the result is blank (0 + 1 at create_only_new_name method)
    def max_view_number(user_id)
      number = Score.where('user_id = ?', user_id).maximum(:view_number)
      number.present? ? number : 0
    end
  end
end

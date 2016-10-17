# template/tales/_form
class @My100TalesTemplateTaleForm

  # <span class="tag module__label layout__tale__form__tag__item">
  #   tag1
  #   <span data-role="remove"></span>
  # </span>
  @tagClass = () ->
    return 'module__label layout__tale__form__tag__item'

  # <div class="layout__tale__form__suggest">
  #   suggest
  #   <span class="layout__tale__form__suggest__count">
  #     count
  #   </span>
  # </div>
  @suggestion = (suggest, count) ->
    return '<div class="layout__tale__form__suggest">' + suggest +
        '<span class="layout__tale__form__suggest__count">' + count + '</span></div>'

# util/tagsinput
class @My100TalesUtilTagsinput

  # const
  # keycode
  ENTER_KEY_CODE = 13
  SPACE_KEY_CODE = 32
  COMMA_KEY_CODE = 44
  CONFIRM_KEYS = [ENTER_KEY_CODE, SPACE_KEY_CODE, COMMA_KEY_CODE]

  # private method: escape for XSS
  escapeTagsInput = (formInputDOM) ->
    for item in $(formInputDOM).tagsinput('items')
      escaped = My100TalesUtilXss.escapeString(item)
      if item != escaped
        $(formInputDOM).tagsinput('remove', item)
        $(formInputDOM).tagsinput('add', escaped)

  # set suggestion
  # *** use bloodhound.initialize after calling this method ***
  @setSuggestion = (suggestList) ->
    return new Bloodhound({
      datumTokenizer: (d) ->
        # enable suggestion with partial match
        datum = Bloodhound.tokenizers.whitespace(d.value)
        $.each(datum, (k,v) ->
          i = 0
          while(i+1 < v.length)
            datum.push(v.substr(i, v.length))
            i++
        )
        return datum
      ,
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      local: suggestList
    })

  # set tag form
  @setTagForm = (formInputDOM, bloodhound, templates, tagClass) ->
    # set form
    $(formInputDOM).tagsinput({
      typeaheadjs: [{
        hint: true,
        highlight: true,
        minLength: 1
      },{
        valueKey: 'value',
        displayKey: 'value',
        itemValue: 'value',
        itemText: 'value',
        source: bloodhound.ttAdapter(),
        templates: templates
      }],
      trimValue: true,
      confirmKeys: CONFIRM_KEYS,
      tagClass: tagClass
    })
    # block XSS
    escapeTagsInput(formInputDOM)

  # set custom event
  @setCustomEvent = (formInputDOM) ->
    # make score unique
    getScoreKeyByTagForm = (tag) ->
      separatorIndex = tag.indexOf(':')
      return '' if separatorIndex < 0
      return tag.substring(0, separatorIndex)

    makeScoreUnique = (event) ->
      scoreKey = getScoreKeyByTagForm(event.item)
      return if scoreKey == ''
      targets = []
      for item in $(formInputDOM).tagsinput('items')
        itemKey = getScoreKeyByTagForm(item)
        targets.push(item) if itemKey == scoreKey
      $(formInputDOM).tagsinput('remove', item) for item in targets

    $(formInputDOM).on('beforeItemAdd', (event) ->
      event.item = My100TalesUtilXss.escapeString(event.item)
      makeScoreUnique(event)
    )

    # block XSS for saving data
    $(formInputDOM).on('itemAdded', (event) ->
      escapeTagsInput(formInputDOM)
    )

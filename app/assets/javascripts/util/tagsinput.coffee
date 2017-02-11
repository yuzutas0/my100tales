# util/tagsinput
class @My100TalesUtilTagsinput

  # const
  # keycode
  ENTER_KEY_CODE = 13
  SPACE_KEY_CODE = 32
  COMMA_KEY_CODE = 44
  CONFIRM_KEYS = [ENTER_KEY_CODE, SPACE_KEY_CODE, COMMA_KEY_CODE]

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

  # make score unique
  @setCustomEvent = (formInputDOM) ->
    # private method
    getKeyByTag = (tag) ->
      separatorIndex = tag.indexOf(':')
      return '' if separatorIndex < 0
      return tag.substring(0, separatorIndex)

    # main logic
    $(formInputDOM).on('beforeItemAdd', (event) ->
      scoreKey = getKeyByTag(event.item.trim())
      return if scoreKey == ''
      targets = []
      for item in $(formInputDOM).tagsinput('items')
        itemKey = getKeyByTag(item)
        targets.push(item) if itemKey == scoreKey
      $(formInputDOM).tagsinput('remove', item) for item in targets
    )

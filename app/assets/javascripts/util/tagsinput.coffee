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
    $(formInputDOM).on('beforeItemAdd', (event) ->
      newTag = event.item.trim()
      separatorIndex = newTag.indexOf(':')
      isScore = separatorIndex > 0
      return unless isScore
      scoreKey = newTag.substring(0,separatorIndex)
      formList = $(formInputDOM).tagsinput('items')
      for item in formList
        itemIndex = item.indexOf(':')
        isScore = itemIndex > 0
        continue unless isScore
        itemKey = item.substring(0,itemIndex)
        $(formInputDOM).tagsinput('remove', item) if itemKey == scoreKey
    )

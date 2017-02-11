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
  @setCustomEvent = (input) ->
    $(input).on('beforeItemAdd', (event) ->
      key = getKeyByTag(event.item.trim())
      removeTag(input, score) for score in getScoresByTag(key, getTags(input)) if key != ''
    )

  getKeyByTag = (tag) ->
    index = tag.indexOf(':')
    return '' if index < 0
    return string.substring(0, index)

  getScoresByTag = (key, tags) ->
    sameScoreList = []
    sameScoreList << tag if key == getHashKey(tag) for tag in tags
    return sameScoreList

  getTags = (input) ->
    return $(input).tagsinput('items')

  removeTag = (input, tag) ->
    return $(input).tagsinput('remove', tag)

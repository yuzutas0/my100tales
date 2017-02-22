# util/xss
class @My100TalesUtilXss

  # same as: forms/tale_form#escape
  @escapeString = (string) ->
    String(string).replace(/[&<>"'`=\/]/g, '').trim()

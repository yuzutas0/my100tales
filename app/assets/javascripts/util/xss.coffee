# util/xss
class @My100TalesUtilXss

  @escapeString = (string) ->
    String(string).replace(/[&<>"'`=\/]/g, '').trim()

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# bind data by Vue.js
ready = ->
  vue = new Vue(
    el: "#vue-markdown"
    data:
      content: $('#vue-markdown-editor').val()
    computed:
      preview: ->
        markdownToHtml(@content)
  )

# render from markdown to html
markdownToHtml=(content) ->
  content

# execute with RubyGem 'turbolinks'
$(document).ready(ready)
$(document).on('page:load', ready)

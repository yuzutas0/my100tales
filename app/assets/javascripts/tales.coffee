# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  # render from markdown to html
  markdownToHtml = (content) ->
    window.markdownit({ linkify: true })
      .use(window.markdownitEmoji)
      .use(window.markdownitFootnote)
      .use(window.markdownitSup)
      .render(DOMPurify.sanitize(content))

  # bind data by Vue.js
  new Vue(
    el: "#vue-markdown"
    data:
      content: $('#vue-markdown-editor').val()
    filters:
      preview: (content) ->
        markdownToHtml(content)
  )

  return

# execute with RubyGem 'turbolinks'
$(document).ready(ready)
$(document).on('page:load', ready)

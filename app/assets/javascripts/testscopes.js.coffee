$ ->
  $("div.toparea input[type=radio]").change ->
    $("ul.sections li.section").show()
    unless @value is "all"
      $("ul.sections li.section h4[class!='" + @value + "']").parent().parent(".section").hide()
      $("ul.sections li.section h4[class!='" + @value + "']").parent().parent().parent(".section").hide()

$ ->
  $("li.section a[href='javascript:void(0)']").click ->
    $(@).parent().next("div").toggle("slow")


$ ->
  $("div.envarea input[type=radio]").change ->
    $("ul.sections li.section").show()
    $("ul.sections li[name!='" + @value + "']").hide() unless @value is "all"

$ ->
  $("#created").datepicker
    showOn: "button"
    buttonImage: "/assets/images/calendar.gif"
    buttonImageOnly: true

$ ->
  $("#created").change ->
    $("#search_form").submit()

$ ->
  $("#testscope_search_form").submit ->
    if $("#category").val() is "" or $("#environment").val() is "" or $("#browser").val() is ""
      $("#flash").html("<div id='flash_alert'>Please select category, environment and browser</div>")
      $("#flash").show()
      $("#flash").delay(5000).hide("slow")
      false


$ ->
  $("#test_job_testbox").change ->
    alert("aaaaa")

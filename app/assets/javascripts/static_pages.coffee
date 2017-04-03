# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

###!

 =========================================================
# Bootstrap Wizard - v1.1.1
 =========================================================

# Product Page: https://www.creative-tim.com/product/bootstrap-wizard
# Copyright 2017 Creative Tim (http://www.creative-tim.com)
# Licensed under MIT (https://github.com/creativetimofficial/bootstrap-wizard/blob/master/LICENSE.md)

 =========================================================

# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
###

# Get Shit Done Kit Bootstrap Wizard Functions
#Function to show image before upload

readURL = (input) ->
  if input.files and input.files[0]
    reader = new FileReader

    reader.onload = (e) ->
      $('#wizardPicturePreview').attr('src', e.target.result).fadeIn 'slow'
      return

    reader.readAsDataURL input.files[0]
  return

refreshAnimation = ($wizard, index) ->
  total_steps = $wizard.find('li').length
  move_distance = $wizard.width() / total_steps
  step_width = move_distance
  move_distance *= index
  $wizard.find('.moving-tab').css 'width', step_width
  $('.moving-tab').css
    'transform': 'translate3d(' + move_distance + 'px, 0, 0)'
    'transition': 'all 0.3s ease-out'
  return

debounce = (func, wait, immediate) ->
  timeout = undefined
  ->
    context = this
    args = arguments
    clearTimeout timeout
    timeout = setTimeout((->
      timeout = null
      if !immediate
        func.apply context, args
      return
    ), wait)
    if immediate and !timeout
      func.apply context, args
    return

searchVisible = 0
transparent = true
$(document).ready ->

  ###  Activate the tooltips      ###

  $('[rel="tooltip"]').tooltip()
  # Code for the Validator
  $validator = $('.wizard-card form').validate(rules:
    firstname:
      required: true
      minlength: 3
    lastname:
      required: true
      minlength: 3
    email:
      required: true
      minlength: 3)
  # Wizard Initialization
  $('.wizard-card').bootstrapWizard
    'tabClass': 'nav nav-pills'
    'nextSelector': '.btn-next'
    'previousSelector': '.btn-previous'
    onNext: (tab, navigation, index) ->
      $valid = $('.wizard-card form').valid()
      if !$valid
        $validator.focusInvalid()
        return false
      return
    onInit: (tab, navigation, index) ->
      #check number of tabs and fill the entire row
      $total = navigation.find('li').length
      $width = 100 / $total
      $wizard = navigation.closest('.wizard-card')
      $display_width = $(document).width()
      if $display_width < 600 and $total > 3
        $width = 50
      navigation.find('li').css 'width', $width + '%'
      $first_li = navigation.find('li:first-child a').html()
      $moving_div = $('<div class="moving-tab">' + $first_li + '</div>')
      $('.wizard-card .wizard-navigation').append $moving_div
      refreshAnimation $wizard, index
      $('.moving-tab').css 'transition', 'transform 0s'
      return
    onTabClick: (tab, navigation, index) ->
      $valid = $('.wizard-card form').valid()
      if !$valid
        false
      else
        true
    onTabShow: (tab, navigation, index) ->
      $total = navigation.find('li').length
      $current = index + 1
      $wizard = navigation.closest('.wizard-card')
      # If it's the last tab then hide the last button and show the finish instead
      if $current >= $total
        $($wizard).find('.btn-next').hide()
        $($wizard).find('.btn-finish').show()
      else
        $($wizard).find('.btn-next').show()
        $($wizard).find('.btn-finish').hide()
      button_text = navigation.find('li:nth-child(' + $current + ') a').html()
      setTimeout (->
        $('.moving-tab').text button_text
        return
      ), 150
      checkbox = $('.footer-checkbox')
      if !index == 0
        $(checkbox).css
          'opacity': '0'
          'visibility': 'hidden'
          'position': 'absolute'
      else
        $(checkbox).css
          'opacity': '1'
          'visibility': 'visible'
      refreshAnimation $wizard, index
      return
  # Prepare the preview for profile picture
  $('#wizard-picture').change ->
    readURL this
    return
  $('[data-toggle="wizard-radio"]').click ->
    wizard = $(this).closest('.wizard-card')
    wizard.find('[data-toggle="wizard-radio"]').removeClass 'active'
    $(this).addClass 'active'
    $(wizard).find('[type="radio"]').removeAttr 'checked'
    $(this).find('[type="radio"]').attr 'checked', 'true'
    return
  $('[data-toggle="wizard-checkbox"]').click ->
    if $(this).hasClass('active')
      $(this).removeClass 'active'
      $(this).find('[type="checkbox"]').removeAttr 'checked'
    else
      $(this).addClass 'active'
      $(this).find('[type="checkbox"]').attr 'checked', 'true'
    return
  $('.set-full-height').css 'height', 'auto'
  return
$(window).resize ->
  $('.wizard-card').each ->
    $wizard = $(this)
    index = $wizard.bootstrapWizard('currentIndex')
    refreshAnimation $wizard, index
    $('.moving-tab').css 'transition': 'transform 0s'
    return
  return

# ---
# generated by js2coffee 2.2.0
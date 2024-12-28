# frozen_string_literal: true

class ModalComponent < ApplicationComponent
  include Turbo::FramesHelper

  def initialize(full_screen: false)
    @full_screen = full_screen
  end

  attr_reader :full_screen
end

# frozen_string_literal: true

class Users::Sessions::NewView < ApplicationView
  def initialize(user: User.new)
    @user = user
  end

  def view_template
    render Layouts::FrontDoorForm.new(title: "Sign in") do |layout|
      layout.form_with model: @user,
        url: users_sessions_path do |form|
        if form.object.errors.any?
          ul do
            form.object.errors.full_messages.each do |message|
              li { message }
            end
          end
        end
        fieldset do
          layout.form_label form, :email, "Email address"
          layout.form_field form, :email_field, :email,
            autocomplete: "email",
            required: true
        end
        fieldset do
          layout.form_label form, :password
          layout.form_field form, :password_field, :password,
            type: "password",
            autocomplete: "current-password",
            required: true
        end
        layout.form_button form, "Sign in"
      end
    end
  end
end
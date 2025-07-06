# Rails Integration Example
# This file shows how to integrate the ISend SDK with a Rails application

# In config/initializers/isend.rb
ISEND_CLIENT = ISend::Client.new(ENV['ISEND_API_KEY'])

# In app/models/user_mailer.rb
class UserMailer
  def self.send_welcome_email(user)
    email_data = {
      template_id: 124,
      to: user.email,
      dataMapping: {
        name: user.name,
        company: user.company || 'Your Company'
      }
    }
    
    ISEND_CLIENT.send_email(email_data)
  end
  
  def self.send_password_reset(user, reset_token)
    email_data = {
      template_id: 125,
      to: user.email,
      dataMapping: {
        name: user.name,
        reset_url: "#{ENV['APP_URL']}/reset-password?token=#{reset_token}"
      }
    }
    
    ISEND_CLIENT.send_email(email_data)
  end
end

# In app/jobs/email_job.rb
class EmailJob < ApplicationJob
  queue_as :default

  def perform(user_id, template_id, data_mapping = {})
    user = User.find(user_id)
    
    email_data = {
      template_id: template_id,
      to: user.email,
      dataMapping: data_mapping.merge({
        name: user.name,
        email: user.email
      })
    }
    
    ISEND_CLIENT.send_email(email_data)
  end
end

# Usage in controllers
class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    
    if @user.save
      # Send welcome email
      UserMailer.send_welcome_email(@user)
      
      # Or use background job
      EmailJob.perform_later(@user.id, 124, { company: 'Your Company' })
      
      redirect_to @user, notice: 'User created successfully!'
    else
      render :new
    end
  end
end 
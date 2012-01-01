ActiveRecord::Base.extend ActsAsRecaptcha::Recaptcha
ActiveSupport.on_load(:action_view) do
  include ActsAsRecaptcha::RecaptchaHelper
end
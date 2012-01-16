module ActsAsRecaptcha
	module RecaptchaHelper

		def recaptcha_image
			"<div id=\"recaptcha_image\"></div>".html_safe
		end

		def recaptcha_fields(f, &block)
			model        = f.object
			captcha_html = "
			<script type=\"text/javascript\">
 var RecaptchaOptions = {
 		#{"lang: '#{model.recaptcha_config[:locale]}'," if model.recaptcha_config[:locale].present?}
    theme : 'custom',
    custom_theme_widget: 'recaptcha_widget'
 };

 </script>
<div id=\"recaptcha_widget\" style=\"display:none\">
			"
captcha_scripts = "<script type=\"text/javascript\"
					src=\"http://www.google.com/recaptcha/api/challenge?k=#{model.recaptcha_config[:public_key]}\">
				</script>
				<noscript>
					<iframe src=\"http://www.google.com/recaptcha/api/noscript?k=#{model.recaptcha_config[:public_key]}\"
						height=\"300\" width=\"500\" frameborder=\"0\"></iframe>
						<input type=\"hidden\" name=\"recaptcha_response_field\" value=\"manual_challenge\">
				</noscript>"
			if model.perform_recaptcha?
				captcha_html += capture(&block)
				captcha_html += "</div>"
				captcha_html += captcha_scripts
			else
				captcha_html = ""
			end

			# Rails 2 compatability
			if Rails::VERSION::MAJOR < 3
				concat captcha_html, &block.binding
			else
				captcha_html.html_safe
			end
		end

	end
end

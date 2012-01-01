module ActsAsRecaptcha
	module Recaptcha

		def acts_as_recaptcha(options = nil)
			cattr_accessor :recaptcha_config
			attr_accessor  :recaptcha_answer, :recaptcha_challenge, :skip_recaptcha, :recaptcha_remote_ip

			if respond_to?(:accessible_attributes)
				if accessible_attributes.nil?
					attr_protected :skip_recaptcha
				else
					attr_accessible :recaptcha_answer, :recaptcha_challenge, :recaptcha_remote_ip
				end
			end

			validate :validate_recaptcha

			if options.is_a?(Hash)
				self.recaptcha_config = options.symbolize_keys!
			else
				begin
					self.recaptcha_config = YAML.load(File.read("#{Rails.root ? Rails.root.to_s : '.'}/config/recaptcha.yml"))[Rails.env].symbolize_keys!
				rescue
					raise 'could not find any recaptcha options, in config/recaptcha.yml or model'
				end
			end
			
			include InstanceMethods
		end

		module InstanceMethods

			# rewrite this method in your model if you want to add logic
			# to whether to show this of not.

			def perform_recaptcha?
				true
			end

			protected

			def validate_recaptcha
				# only spam check on new/unsaved records (ie. no spam check on updates/edits)
				if !respond_to?('new_record?') || new_record?
					if perform_recaptcha? && !validate_recaptcha_answer
						errors.add(:recaptcha_answer, :incorrect_answer, :message => "is incorrect, try another question instead")
						return false
					end
				end
				true
			end

			def validate_recaptcha_answer
        status, error = Recaptcha::Validator.validate_recaptcha(recaptcha_challenge, recaptcha_answer, recaptcha_remote_ip, self.recaptcha_config[:private_key])
        if status == "false"
          return false
        end
        return true
      end

		end
	end
end

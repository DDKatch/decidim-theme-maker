module Decidim
  module Theme
    module Maker
      class ApplicationMailer < ActionMailer::Base
        default from: "from@example.com"
        layout "mailer"
      end
    end
  end
end

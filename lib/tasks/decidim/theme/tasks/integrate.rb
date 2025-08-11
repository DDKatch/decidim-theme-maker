module Decidim::Theme::Tasks
  class Integrate
    FILE_PATH = "app/views/layouts/decidim/_head_extra.html.erb".freeze
    BODY = '<%= render partial: "decidim/theme/maker/theme_files" %>'.freeze

    def initialize(file_path =  FILE_PATH, body = BODY)
      @file_path = file_path
      @body = body
    end

    def call
      if File.exist?(@file_path)
        puts "File already exists: #{@file_path}"
      else
        File.write(@file_path, @body)
        puts "Created file: #{@file_path} and added the body"
      end
    end
  end
end

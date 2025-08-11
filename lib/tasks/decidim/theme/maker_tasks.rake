require_relative "tasks/integrate"

namespace :decidim_theme_maker do
  namespace :integrate do
    desc "Integrate layout changes for Decidim theme maker"
    task :layouts do
      Decidim::Theme::Tasks::Integrate.new.call

      puts "Layouts integration complete!"
    end
  end
end

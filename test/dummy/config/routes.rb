Rails.application.routes.draw do
  mount Decidim::Theme::Maker::Engine => "/decidim-theme-maker"
end

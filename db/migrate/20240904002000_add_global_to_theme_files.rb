# frozen_string_literal: true

class AddGlobalToThemeFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_theme_maker_theme_files, :global, :boolean, null: false, default: false
  end
end



# frozen_string_literal: true

class RenameDescriptionToPageUrlInThemeFiles < ActiveRecord::Migration[6.1]
  def change
    rename_column :decidim_theme_maker_theme_files, :description, :page_url
  end
end



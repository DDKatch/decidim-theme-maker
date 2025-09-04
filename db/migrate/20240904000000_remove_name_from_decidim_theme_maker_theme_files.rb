# frozen_string_literal: true

class RemoveNameFromDecidimThemeMakerThemeFiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :decidim_theme_maker_theme_files, :name, :jsonb
  end
end



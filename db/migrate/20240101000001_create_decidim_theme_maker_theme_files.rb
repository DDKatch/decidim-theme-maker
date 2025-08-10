# frozen_string_literal: true

class CreateDecidimThemeMakerThemeFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_theme_maker_theme_files do |t|
      t.references :organization, null: false, index: { name: "index_decidim_theme_maker_theme_files_on_organization_id" }
      t.jsonb :name, null: false
      t.jsonb :description, null: false
      t.timestamps
    end
  end
end

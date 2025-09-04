# frozen_string_literal: true

class BackfillGlobalToFalse < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    execute <<~SQL
      UPDATE decidim_theme_maker_theme_files
      SET global = FALSE
      WHERE global IS NULL;
    SQL
  end

  def down
    # no-op
  end
end



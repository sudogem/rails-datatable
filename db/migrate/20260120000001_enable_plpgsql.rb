class EnablePlpgsql < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'plpgsql' unless extension_enabled?('plpgsql')
  end
end
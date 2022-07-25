class CreateChitraguptanVariables < ActiveRecord::Migration[7.0]
  def change
    create_table :chitraguptan_variables do |t|
      t.string :key, index: true
      t.json   :value, default: { value: '' }

      t.timestamps
    end
  end
end

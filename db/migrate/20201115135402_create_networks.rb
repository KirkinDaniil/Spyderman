class CreateNetworks < ActiveRecord::Migration[6.1]
  def change
    create_table :networks do |t|
      t.string :network, null: false
      t.string :link, null: false
      t.timestamps
    end
  end
end

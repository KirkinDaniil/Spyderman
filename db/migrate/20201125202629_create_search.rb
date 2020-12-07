class CreateSearch < ActiveRecord::Migration[6.1]
  def change
    create_table :searches do |t|
      t.string :victim_bio
      t.string :vk_link
      t.string :inst_link
      t.string :twi_link
      t.timestamps
    end
  end
end

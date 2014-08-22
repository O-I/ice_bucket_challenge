class CreateBucketeers < ActiveRecord::Migration
  def change
    create_table :bucketeers do |t|
      t.string :name
      t.string :identifier, unique: true
      t.text :challenged_by
      t.text :challenged
      t.text :video_link
      t.timestamps
    end

    add_index :bucketeers, :identifier
  end
end
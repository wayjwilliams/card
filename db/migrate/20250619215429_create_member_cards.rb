class CreateMemberCards < ActiveRecord::Migration[8.0]
  def change
    create_table :member_cards do |t|
      t.timestamps
    end
  end
end

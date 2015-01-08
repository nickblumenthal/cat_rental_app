class CreateOpenSessions < ActiveRecord::Migration
  def change
    create_table :open_sessions do |t|
      t.integer :user_id, null: false
      t.string :session_token, null:false
      t.string :location, null: false

      t.timestamps null: false
    end
  end
end

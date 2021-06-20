class CreateTicketThreads < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_threads do |t|
      t.text       :body
      t.integer    :thread_type, null: false, limit: 1, :default => 1
      t.references :ticket
      t.references :creator, polymorphic: true

      t.timestamps
    end
  end
end

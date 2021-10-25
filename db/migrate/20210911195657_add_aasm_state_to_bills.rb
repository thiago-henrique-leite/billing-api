class AddAasmStateToBills < ActiveRecord::Migration[6.1]
  def change
    add_column :bills, :aasm_state, :string
  end
end

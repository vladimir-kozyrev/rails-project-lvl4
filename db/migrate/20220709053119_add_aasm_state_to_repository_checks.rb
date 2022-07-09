class AddAasmStateToRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :repository_checks, :aasm_state, :string
  end
end

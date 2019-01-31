class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :role
      t.integer :company_id
      t.integer :department_id

      t.timestamps
    end

    add_index :employees, :company_id
    add_index :employees, :department_id
  end
end

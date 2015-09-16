class CreatePjmrs < ActiveRecord::Migration
  def change
    create_table :pjmrs do |t|
      t.string :ph
      t.string :txlx
      t.string :pjlx
      t.string :pch
      t.decimal :pmje, :precision=>16, :scale=>2
      t.string :zrrq
      t.string :cprq
      t.string :pmdqrq
      t.integer :jjrjt
      t.integer :ydjt
      t.integer :jxts
      t.string :jxdqrq
      t.decimal :zrll, :precision=>12, :scale=>6
      t.decimal :zrlx, :precision=>16, :scale=>2
      t.decimal :sfje, :precision=>16, :scale=>2
      t.string :khmc
      t.string :cpr
      t.string :cprkhh
      t.string :ckr
      t.string :skrkhh
      t.string :ckr
      t.string :ckrkhh
      t.text :bz
      t.string :khjlmc
      t.string :dabh

      t.timestamps
    end
    add_index :pjmrs, [:ph, :pch], unique: true
  end


end

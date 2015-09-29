class CreatePjmcs < ActiveRecord::Migration
  def change
    create_table :pjmcs do |t|
      t.string :ph
      t.string :pch
      t.string :khmc
      t.string :zmrq
      t.string :txlx
      t.integer :jjrjt
      t.integer :ydjt
      t.integer :jxts
      t.date :jxdqrq
      t.decimal :zcll, :precision => 12, :scale => 6
      t.decimal :zclx, :precision => 16, :scale => 2
      t.decimal :ssje, :precision => 16, :scale => 2
      t.string :khjlmc
      t.string :dabh      
      t.string :cksqr
      t.datetime :cksqsj
      t.string :ckshr
      t.datetime :ckshsj
      t.integer :pjmr_id

      t.timestamps
    end
  end
end

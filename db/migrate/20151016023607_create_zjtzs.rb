class CreateZjtzs < ActiveRecord::Migration
  def change
    create_table :zjtzs do |t|
      t.string :bh
      t.string :zt
      t.string :khmc
      t.string :cpms
      t.decimal :je, :precision => 16, :scale => 2
      t.string :bz
      t.date :csqxrq
      t.date :csdqrq
      t.decimal :csll, :precision => 12, :scale => 6
      t.integer :csjxts
      t.decimal :cslx, :precision => 16, :scale => 2
      t.string :khjlmc
      t.string :bz
      t.string :dabh
      t.string :jqbh
      t.date :qxrq
      t.date :dqrq
      t.integer :jxts
      t.decimal :lx, :precision => 16, :scale => 2 
      t.string :rjsqr
      t.datetime :rjsqsj
      t.string :rjshr
      t.datetime :rjshsj
      t.string :cjsqr
      t.datetime :cjsqsj
      t.string :cjshr
      t.datetime :cjshsj


      t.timestamps
    end
  end
end

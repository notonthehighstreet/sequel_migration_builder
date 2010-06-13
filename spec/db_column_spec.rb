require File.dirname(__FILE__) + "/spec_helper"

describe Sequel::Schema::DbColumn do

  before :each do
    @column = Sequel::Schema::DbColumn.new(:foo, :integer, false, 10, true, 10, nil)
  end

  it "should return a #define_statement" do
    @column.define_statement.should == "integer :foo, :null => false, :default => 10, :unsigned => true, :size => 10"
  end
  
  it "should return a #drop_statement" do
    @column.drop_statement.should == "drop_column :foo"
  end

  it "should return an #add_statement" do
    @column.add_statement.should == "add_column :foo, :integer, :null => false, :default => 10, :unsigned => true, :size => 10"
  end

  it "should return a #change_null statement" do
    @column.change_null_statement.should == "set_column_allow_null :foo, false"
  end

  it "should return a #change_default statement" do
    @column.change_default_statement.should == "set_column_default :foo, 10"
  end

  it "should return a #change_type statement" do
    @column.change_type_statement.should == "set_column_type :foo, :integer, :default => 10, :unsigned => true, :size => 10"
  end

  it "should be diffable with another DbColumn" do
    other = Sequel::Schema::DbColumn.new(:foo, :smallint, false, 10, true, 10, nil)
    @column.diff(other).should == [:column_type]

    other = Sequel::Schema::DbColumn.new(:foo, :integer, true, 11, true, 10, nil)
    @column.diff(other).should == [:null, :default]
  end

  it "should be buildable from a Hash" do
    Sequel::Schema::DbColumn.build_from_hash(:name => "foo", 
                                       :column_type => "integer").column_type.should == "integer"
    Sequel::Schema::DbColumn.build_from_hash('name' => "foo", 
                                       'column_type' => "integer").name.should == "foo"
  end
end
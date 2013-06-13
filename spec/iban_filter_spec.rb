require_relative 'spec_helper'

describe "Mutations::IBANFilter" do

  it "allows valid IBANs" do
    f = Mutations::IBANFilter.new
    filtered, errors = f.filter("NL91ABNA0417164300")
    assert_equal "NL91ABNA0417164300", filtered
    assert_equal nil, errors
  end

  it "doesn't allow invalid IBANs" do
    f = Mutations::IBANFilter.new
    filtered, errors = f.filter("NL00ABNA0417164300")
    assert_equal :iban, errors
  end

  it "doesnt't allow other strings, nor does it allow random objects or symbols" do
    f = Mutations::IBANFilter.new
    ["zero","a1", {}, [], Object.new, :d].each do |thing|
      filtered, errors = f.filter(thing)
      assert_equal :iban, errors
    end
  end

  it "considers nil to be invalid" do
    f = Mutations::IBANFilter.new(:nils => false)
    filtered, errors = f.filter(nil)
    assert_equal nil, filtered
    assert_equal :nils, errors
  end

  it "considers nil to be valid" do
    f = Mutations::IBANFilter.new(:nils => true)
    filtered, errors = f.filter(nil)
    assert_equal nil, filtered
    assert_equal nil, errors
  end

  it "considers empty to be invalid" do
    f = Mutations::IBANFilter.new(:empty => false)
    filtered, errors = f.filter("")
    assert_equal "", filtered
    assert_equal :empty, errors
  end

  it "considers empty to be valid" do
    f = Mutations::IBANFilter.new(:empty => true)
    filtered, errors = f.filter("")
    assert_equal "", filtered
    assert_equal nil, errors
  end

end

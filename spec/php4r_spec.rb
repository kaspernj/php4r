require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Php4r" do
  it "explode" do
    teststr = "1;2;3"
    arr = Php4r.explode(";", teststr)
    
    raise "Invalid length." if arr.length != 3
    raise "Invalid first." if arr[0] != "1"
    raise "Invalid second." if arr[1] != "2"
    raise "Invalid third." if arr[2] != "3"
  end
  
  it "is_numeric" do
    raise "Failed." if !Php4r.is_numeric(123)
    raise "Failed." if !Php4r.is_numeric("123")
    raise "Failed." if Php4r.is_numeric("kasper123")
    raise "Failed." if Php4r.is_numeric("123kasper")
    raise "Failed." if !Php4r.is_numeric(123.12)
    raise "Failed." if !Php4r.is_numeric("123.12")
  end
  
  it "number_format" do
    tests = {
      Php4r.number_format(123123.12, 3, ",", ".") => "123.123,120",
      Php4r.number_format(123123.12, 4, ".", ",") => "123,123.1200",
      Php4r.number_format(-123123.12, 2, ",", ".") => "-123.123,12",
      Php4r.number_format(-120, 2, ",", ".") => "-120,00",
      Php4r.number_format(-12, 2, ".", ",") => "-12.00"
    }
    
    tests.each do |key, val|
      if key != val
        raise "Key was not the same as value (#{key}) (#{val})."
      end
    end
  end
  
  it "substr" do
    res = Php4r.substr("selcol_15", 7)
    raise "substr should have returned '15' but didnt: '#{res}'." if res != "15"
    
    res = Php4r.substr("test_kasper", -6, 6)
    raise "substr should have returned 'kasper' but didnt: '#{res}'." if res != "kasper"
    
    res = Php4r.substr("test_kasper", 1, 3)
    raise "substr should have returned 'est' but didnt: '#{res}'." if res != "est"
    
    res = Php4r.substr("test_kasper", 0, -3)
    raise "substr should have returned 'test_kas' but didnt: '#{res}'." if res != "test_kas"
  end
  
  it "parse_str" do
    teststr = "first=value&arr[]=foo+bar&arr[]=baz&hash[trala]=hmm&hash[trala2]=wtf"
    
    hash = {}
    Php4r.parse_str(teststr, hash)
    
    raise "Invalid value for first." if hash["first"] != "value"
    raise "Invalid value for first in arr." if hash["arr"]["0"] != "foo bar"
    raise "Invalid value for second in arr." if hash["arr"]["1"] != "baz"
    raise "Invalid value for hash-trala." if hash["hash"]["trala"] != "hmm"
    raise "Invalid value for hash-trala2." if hash["hash"]["trala2"] != "wtf"
  end
  
  it "file_get_contents - http" do
    cont = Php4r.file_get_contents("https://www.kaspernj.org/myip.php")
    raise "Not IP: '#{cont}'." if !cont.to_s.match(/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/)
  end
  
  #Moved from "knjrbfw_spec.rb".
  it "should be able to execute various Php4r functions correctly." do
    str = "Kasper Johansen"
    
    #substr
    teststr = Php4r.substr(str, 7, 8)
    if teststr != "Johansen"
      raise "substr did not return expected result: '#{teststr}'"
    end
    
    teststr = Php4r.substr(str, -8, 8)
    if teststr != "Johansen"
      raise "substr did not returned expected result when using negative positions: '#{teststr}'."
    end
    
    #strtoupper
    teststr = Php4r.strtoupper(str)
    if teststr != "KASPER JOHANSEN"
      raise "strtoupper did not return expected result: '#{teststr}'."
    end
    
    #strtolower
    teststr = Php4r.strtolower(str)
    if teststr != "kasper johansen"
      raise "strtolower did not return expected result: '#{teststr}'."
    end
  end
end
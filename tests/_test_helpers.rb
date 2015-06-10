def assert_equal_after_sorting(expected, actual)
  expected.sort!
  actual.sort!
  
  assert_equal(expected, actual)
end

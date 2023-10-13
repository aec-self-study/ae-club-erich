import unittest
from calc import aec_division
 
class TestSubtract(unittest.TestCase):
     
  def test_division(self):
    arg_ints = [20, 5]
    div_result = aec_division(arg_ints)
    self.assertEqual(div_result, 4)
  
  def test_cant_divide_by_zero(self):
    arg_ints = [5, 0]
    with self.assertRaises(ValueError):
      aec_division(arg_ints)
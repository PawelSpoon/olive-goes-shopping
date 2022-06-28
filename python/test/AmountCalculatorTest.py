import unittest
import sys
sys.path.append('../src')
from controller.amountcalculator import AmountCalculator

class AmountCalculatorTest(unittest.TestCase):
     
    rootDir = "../src/assets"

    def setUp(self) -> None:
        return super().setUp()
        
    # Returns True or False. 
    def test(self):        
        self.assertTrue(True)

    def testSimple(self):
        calc = AmountCalculator(self.rootDir)
        calc.init()
        ret = calc.doAmountMagic(1,"kg",2,"kg")
        self.assertEqual(3,ret)  

    def testKgAndg(self):
        calc = AmountCalculator(self.rootDir)
        calc.init()
        self.assertTrue("kg" in calc.units.keys())
        ret = calc.doAmountMagic(1,"kg",200,"g")
        self.assertEqual(1.2,ret) 

    def testKgAndg(self):
        calc = AmountCalculator(self.rootDir)
        calc.init()
        self.assertTrue("kg" in calc.units.keys())
        ret = calc.doAmountMagic(1,"-",1,"10er")
        self.assertEqual(11,ret) 

    def testNotFittingPhydims(self):
        calc = AmountCalculator(self.rootDir)
        calc.init()
        ret = calc.doAmountMagic(1,"-",2,"kg")
        self.assertFalse(ret)

    
    def testNotExistingUnits(self):
        calc = AmountCalculator(self.rootDir)
        # simulated due to missed intialization :D
        ret = calc.doAmountMagic(1,"-",2,"kg")
        self.assertFalse(ret)


  
if __name__ == '__main__':
    unittest.main()
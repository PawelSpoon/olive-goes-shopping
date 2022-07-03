import os
import unittest
import sys
sys.path.append('./src')

from storage.items import *

class ItemsTest(unittest.TestCase):
  
    shopFile = "./src/assets/current/jan.shop.json"
    shopOutFile = "./test/test-out/current/jan.shop.json"

    recipeFile = "./src/assets/recipe/Krautsuppe.json"
    recipeOutFile = "./test/test-out/recipe/Krautsuppe.json"

    simpleFile = "./src/assets/simple.json"
    simpleOutFile = "./test/test-out/simple.json"

    outDir = "./test/test-out"
    
    phydimOutFile = os.path.join(outDir,"phydiim.json")
    unitOutFile = os.path.join(outDir,"unit.json")
    catOutFile =  os.path.join(outDir,"category.json")
    foodOutFile = os.path.join(outDir,"food.json")
    househouldFile = os.path.join(outDir,"household.json")

    def setUp(self) -> None:
        return super().setUp()
        
    # Returns True or False. 
    def test(self):        
        self.assertTrue(True)

    def testGenUnits(self):
        generateFile(self.unitOutFile,getUnits())

    def testGenCats(self):
        generateFile(self.catOutFile,getCategories())

    def testLoadCats(self):
        generateFile(self.catOutFile,getCategories())
        items = persistance.readItems(self.catOutFile)
        self.assertTrue("dairy products" in items)

    def testGenFood(self):
        generateFile(self.foodOutFile,getFood())
        items = persistance.readItems(self.foodOutFile)     
        self.assertTrue("apple" in items)

    def testGenHousehold(self):
        generateFile(self.househouldFile,getHousehold())
        items = persistance.readItems(self.househouldFile)     
        self.assertTrue("condoms" in items)
  
if __name__ == '__main__':
    unittest.main()
import unittest
import sys
sys.path.append('../src')

from storage.persistance import readEnums, readItems, readObject, storeEnums, storeItems, storeObject

class PersistanceTest(unittest.TestCase):
  
    shopFile = "../src/assets/current/jan.shop.json"
    shopOutFile = "./test-out/current/jan.shop.json"

    recipeFile = "../src/assets/recipe/Krautsuppe.json"
    recipeOutFile = "./test-out/recipe/Krautsuppe.json"

    categoryFile = "../src/assets/category.json"
    categoryOutFile = "./test-out/category.json"
    
    unitFile = "../src/assets/unit.json"
    unitOutFile = "./test-out/unit.json"

    def setUp(self) -> None:
        return super().setUp()
        
    # Returns True or False. 
    def test(self):        
        self.assertTrue(True)
    
    def testReadEnum(self):
        enums = readEnums(self.categoryFile)
        self.assertTrue("Meat" in enums)

    def testWriteEnum(self):
        enums = readEnums(self.categoryFile)
        enums.append("Hot stuff")
        self.assertTrue("Meat" in enums)
        storeEnums(self.categoryOutFile,enums)
        enums = readEnums(self.categoryOutFile)
        self.assertTrue("Hot stuff" in enums)

    def testReadItems(self):
        items = readItems(self.unitFile)
        print(items.get("kg"))

    def testStoreItems(self):
        items = readItems(self.unitFile)
        items["muschi"] = { "Name" : "uschi"}
        storeItems(self.unitOutFile, items)
        items = readItems(self.unitOutFile)
        self.assertTrue("uschi" in items)
    
    def testReadObject(self):
        obj = readObject(self.recipeFile)

    def testStoreObject(self):
        obj = readObject(self.recipeFile)
        storeObject(self.recipeOutFile, obj)

    def testReadShoppingList(self):
        item = readItems(self.shopFile)

  
if __name__ == '__main__':
    unittest.main()
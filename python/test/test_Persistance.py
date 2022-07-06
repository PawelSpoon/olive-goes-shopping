import unittest
import sys
sys.path.append('./src')

from storage.persistance import readEnums, readItems, readObject, storeEnums, storeItems, storeObject

class PersistanceTest(unittest.TestCase):
  
    shopFile = "./src/assets/current/demo.shop.json"
    shopOutFile = "./test/test-out/current/demo.shop.json"

    recipeFile = "./src/assets/recipe/Krautsuppe.json"
    recipeOutFile = "./test/test-out/recipe/Krautsuppe.json"

    simpleFile = "./src/assets/simple.json"
    simpleOutFile = "./test/test-out/simple.json"
    
    unitFile = "./src/assets/unit.json"
    unitOutFile = "./test/test-out/unit.json"

    catFile = "./src/assets/category.json"
    catOutFile = "./test/test-out/category.json"

    def setUp(self) -> None:
        return super().setUp()
        
    # Returns True or False. 
    def test(self):        
        self.assertTrue(True)
    
    def testReadEnum(self):
        enums = readEnums(self.simpleFile)
        self.assertTrue("Length" in enums)

    def testWriteEnum(self):
        enums = readEnums(self.simpleFile)
        enums.append("Hot stuff")
        self.assertTrue("Volume" in enums)
        storeEnums(self.simpleOutFile,enums)
        enums = readEnums(self.simpleOutFile)
        self.assertTrue("Hot stuff" in enums)

    def testReadItems(self):
        items = readItems(self.unitFile)
        print(items.get("kg"))

    def testReadItems(self):
        items = readItems(self.catFile)
        self.assertTrue("meat products" in items)

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
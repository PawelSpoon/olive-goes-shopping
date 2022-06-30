import unittest
import sys
sys.path.append('../src')

from app import *


class AppTest(unittest.TestCase):
    rootDir = "../src/assets"
    outDir = "./test-out"

    def setUp(self) -> None:
        return super().setUp()
        
    # Returns True or False. 
    def test(self):        
        self.assertTrue(True)

    def testStoreFood(self):
        app = App()
        


if __name__ == '__main__':
    unittest.main()
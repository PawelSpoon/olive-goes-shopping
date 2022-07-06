



# i use this file to create the mlg strings for items
# also for the initial filling
# it allows me to fill the db with data from json
# returns pre-defined food and household items

from logging import exception
from controller.constants import FieldCategory, FieldId, FieldName, FieldUnit
from storage import persistance

def qsTr(name):
    return name

def getId(aList):
    return str(len(aList) + 1)

def getUnits():
    retItems= []
    retItems.append({ "Id":getId(retItems), "Name": "-", "Phydim": "Piece", "Factor": 1, "Offset": 0})
    retItems.append({ "Id":getId(retItems), "Name": "10", "Phydim": "Piece", "Factor": 10, "Offset": 0})
    retItems.append({ "Id":getId(retItems), "Name": "dozen", "Phydim": "Piece", "Factor": 12, "Offset": 0})    
    retItems.append({ "Id":getId(retItems), "Name": "kg", "Phydim": "Weight", "Factor": 1, "Offset": 0})
    retItems.append({ "Id":getId(retItems), "Name": "dag", "Phydim": "Weight", "Factor": 0.01, "Offset": 0})
    retItems.append({ "Id":getId(retItems), "Name": "g", "Phydim": "Weight", "Factor": 0.001, "Offset": 0})
    retItems.append({ "Id":getId(retItems), "Name": "t", "Phydim": "Weight", "Factor": 1000, "Offset": 0})
    retItems.append({ "Id":getId(retItems), "Name": "lbs", "Phydim": "Weight", "Factor": 0.5, "Offset": 0})
    retItems.append({ "Id":getId(retItems), "Name": "l", "Phydim": "Volume", "Factor": 1, "Offset": 0})
    retItems.append({ "Id":getId(retItems), "Name": "dl", "Phydim": "Volume", "Factor": 0.1, "Offset": 0})
    retItems.append({ "Id":getId(retItems), "Name": "ml", "Phydim": "Volume", "Factor": 0.01, "Offset": 0})
    retItems.append({ "Id":getId(retItems), "Name": "m", "Phydim": "Length", "Factor": 1, "Offset": 0})
    retItems.append({ "Id":getId(retItems), "Name": "cm", "Phydim": "Length", "Factor": 0.01, "Offset": 0})
    return retItems

# converts units string into class
def getUnit(name):
    units = persistance.readItems("./src/assets/unit.json")
    if name in units.keys():
        u = {}
        u[FieldId]=units[name][FieldId]
        u[FieldName]=units[name][FieldName]
        return u
    else:
        raise exception(name + " not found")

# converts units string into class
def getCategory(name):
    cats = persistance.readItems("./src/assets/category.json")
    if name in cats.keys():
        u = {}
        u[FieldId]=cats[name][FieldId]
        u[FieldName]=cats[name][FieldName]
        return u
    else:
        raise exception(name + " not found")

def getCategories():

    retItems =[]

    # categories for food and household
    retItems.append({ "Id":getId(retItems),"Name": qsTr("dairy products"), "Order": 1000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("meat products"), "Order": 2000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("fresh produce"), "Order": 3000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("bakery products"), "Order": 4000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("frozen food"), "Order": 5000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("canned food"), "Order": 6000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("personal hygiene"), "Order": 7000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("cleaning supplies"), "Order": 8000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("magazines"), "Order": 9000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("hardware"), "Order": 10000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("automotive"), "Order": 11000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("others"), "Order": 12000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("liquors"), "Order": 13000 })
    retItems.append({ "Id":getId(retItems),"Name": qsTr("kitchen"), "Order": 14000 })
    return retItems

def generateFile(filePath, listerl):
    persistance.storeObject(filePath,listerl)

def getFood():
    retItems = []

    #food
    retItems.append({ "Id":getId(retItems), "Name": qsTr("apple")              ,"Amount":4  ,"Unit":"-" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("apple cider vinegar"),"Amount":500,"Unit":"ml", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("asian noodels")      ,"Amount":1,  "Unit":"kg" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("avocado")            ,"Amount":1   ,"Unit":"-" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("soup peas")         ,"Amount":200  ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("balsamic vinegar")    ,"Amount":500,"Unit":"ml", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("banana")             ,"Amount":4   ,"Unit":"-" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("basmati rice")       ,"Amount":1,   "Unit":"kg" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("pear")               ,"Amount":4   ,"Unit":"-" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("puff pastry")        ,"Amount":1   ,"Unit":"-" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("string beans")       ,"Amount":100 ,"Unit":"g" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("bread crumbs")       ,"Amount":500 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("bread")              ,"Amount":1   ,"Unit":"kg" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("button mushrooms")   ,"Amount":250 ,"Unit":"g" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("spelled flour")      ,"Amount":1   ,"Unit":"kg" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("caned tomatoes")     ,"Amount":400 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("egg")                ,"Amount":10  ,"Unit":"-" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("emmental cheese")    ,"Amount":100 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("peas")               ,"Amount":300 ,"Unit":"g" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("strawberries")       ,"Amount":200 ,"Unit":"g" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("pickled cucumbers")  ,"Amount":1   ,"Unit":"-" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("fennel")             ,"Amount":1   ,"Unit":"-" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("feta cheese")        ,"Amount":200 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("frankfurters")       ,"Amount":4   ,"Unit":"-" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("fruit tea")          ,"Amount":1   ,"Unit":"-" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("vegetable stock")    ,"Amount":1   ,"Unit":"kg" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("yeast")               ,"Amount":1   ,"Unit":"-" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("ghee")               ,"Amount":500 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("cucumber")           ,"Amount":1   ,"Unit":"-" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("oat milk")           ,"Amount":1   ,"Unit":"l", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("millet")             ,"Amount":1   ,"Unit":"kg" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("honey")              ,"Amount":200 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("ginger")             ,"Amount":100 ,"Unit":"g" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("curd")               ,"Amount":150 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("coffee")             ,"Amount":1   ,"Unit":"-" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("coffe decaf")        ,"Amount":1   ,"Unit":"-" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("capers berries")     ,"Amount":200 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("cauliflower")        ,"Amount":1   ,"Unit":"-" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("carrots")            ,"Amount":1   ,"Unit":"kg" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("potatoes")           ,"Amount":1   ,"Unit":"kg" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("chickpeas")          ,"Amount":300 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("chickpea flour")     ,"Amount":1   ,"Unit":"kg" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("garlic")             ,"Amount":1   ,"Unit":"-" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("dumpling bread")     ,"Amount":500 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("kohlrabi")           ,"Amount":1   ,"Unit":"-" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("cabbage")            ,"Amount":1   ,"Unit":"-" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("pumpkin")            ,"Amount":1   ,"Unit":"g" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("lassagne noodles")   ,"Amount":250 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("leek")               ,"Amount":1   ,"Unit":"-", "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("lime")               ,"Amount":1   ,"Unit":"-", "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("lentils yellow")     ,"Amount":200 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("lentils red")        ,"Amount":200 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("lentils green")      ,"Amount":200 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("corn")               ,"Amount":200 ,"Unit":"g", "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("cornstarch")         ,"Amount":200 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("almonds")            ,"Amount":200 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("mango")              ,"Amount":1   ,"Unit":"-", "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("melanzani")          ,"Amount":1   ,"Unit":"-", "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("milk")               ,"Amount":1   ,"Unit":"l", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("italian rice")       ,"Amount":1   ,"Unit":"kg", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("cereal")             ,"Amount":500 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("noodels")            ,"Amount":1   ,"Unit":"kg", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("walnuts")            ,"Amount":100 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("hazelnuts")          ,"Amount":100 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("olives")             ,"Amount":250 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("olive oil")          ,"Amount":1   ,"Unit":"l", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("oranges")            ,"Amount":1   ,"Unit":"kg" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("bell pepper")        ,"Amount":1   ,"Unit":"-" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("parboiled rice")     ,"Amount":1   ,"Unit":"kg" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("parmesan cheese")    ,"Amount":100 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("pesto")              ,"Amount":1   ,"Unit":"-" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("pepper mix")         ,"Amount":200 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("pepper green")       ,"Amount":50  ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("pepper pink")        ,"Amount":50  ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("pepper black")       ,"Amount":200 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("polenta")            ,"Amount":200 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("quinoa")             ,"Amount":1   ,"Unit":"kg" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("rapeseed oil")       ,"Amount":1   ,"Unit":"l", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("beef")               ,"Amount":1   ,"Unit":"kg" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("rye flour")          ,"Amount":1   ,"Unit":"kg" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("raisins")            ,"Amount":200 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("salad")              ,"Amount":1   ,"Unit":"-" , "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("salt")               ,"Amount":200 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("salt coarse")        ,"Amount":200 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("pickled cabbage")    ,"Amount":250 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("sour cream")         ,"Amount":200 ,"Unit":"ml", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("ham")                ,"Amount":100 ,"Unit":"g" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("sweet cream")        ,"Amount":200 ,"Unit":"ml", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("roll")               ,"Amount":1   ,"Unit":"-" , "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("pickeled onions")    ,"Amount":200 ,"Unit":"ml", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("soy sauce")          ,"Amount":200 ,"Unit":"ml", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("soy cubes")          ,"Amount":500 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("soy granules")       ,"Amount":500 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("bacon")              ,"Amount":200 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("spinach")            ,"Amount":400 ,"Unit":"g", "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("sticky rice")        ,"Amount":1   ,"Unit":"kg", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("pastry")             ,"Amount":1   ,"Unit":"-", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("soup noodles")       ,"Amount":1   ,"Unit":"kg", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("tomatoes")           ,"Amount":4   ,"Unit":"-", "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("curd cheese")        ,"Amount":250 ,"Unit":"g", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("tortillas")          ,"Amount":1   ,"Unit":"-", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("grapes")             ,"Amount":200 ,"Unit":"g", "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("wheat flour")        ,"Amount":1   ,"Unit":"kg", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("lemon")              ,"Amount":1   ,"Unit":"-", "ItemType" : "food", "Category" : qsTr("fresh produce")})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("zucchini")           ,"Amount":1   ,"Unit":"-", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("sugar")              ,"Amount":1   ,"Unit":"kg", "ItemType" : "food"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("onion")              ,"Amount":1   ,"Unit":"kg", "ItemType": "food", "Category" : qsTr("fresh produce")})
    
    for item in retItems:
        item[FieldUnit] = getUnit(item[FieldUnit])
    for item in retItems:
        try:
            tmp = item[FieldCategory]
            if (tmp is not None):
                print(item[FieldCategory])
                item[FieldCategory] = getCategory(item[FieldCategory])
            else:
                item[FieldCategory] = None
        finally:
            continue
    
    return retItems

def getHousehold():
    retItems = []
    #household
    retItems.append({ "Id":getId(retItems), "Name": qsTr("all purpose cleaner"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("aluminum foil"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("baking paper"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("bathroom cleaner"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("greaseproof paper"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("fine detergent"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("window cleaner"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("moist toilet paper"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("lighter"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("liquid soap"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("freeze bag"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("dishwasher - rinse aid"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("dishwasher - salt"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("dishwasher - tabs"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("dishwashing liquid"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("dishwashing sponge"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("rubber rings"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("hygienic rinse"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("children's toothpaste"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("toilet paper"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("kitchen cleaner"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("kitchen roll"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("lens cleaner"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("trash bags"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("trash bags - small"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("over fire starter"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("shaving cream"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("shampoo"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("sponge wipes"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("soap"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("panty liners"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("tampons"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("condoms"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("piles"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("handkerchiefs"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("laundry detergent"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("toothbrush"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("toothpaste"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("matches"),"Amount":1,"Unit":"-","ItemType":"household"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("razor blades"),"Amount":1,"Unit":"-","ItemType":"household"})
    
    for item in retItems:
        item[FieldUnit] = getUnit(item[FieldUnit])
    for item in retItems:
        try:
            tmp = item[FieldCategory]
            if (tmp is not None):
                print(item[FieldCategory])
                item[FieldCategory] = getCategory(item[FieldCategory])
            else:
                item[FieldCategory] = None
        finally:
            continue
    
    return retItems   
   
def getCarsNBikes():
    retItems = []
    #cars n bikes
    retItems.append({ "Id":getId(retItems), "Name": qsTr("engine cleaner")   ,"Amount":1,"Unit":"-","ItemType":"cars n bikes"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("break cleaner")    ,"Amount":1,"Unit":"-","ItemType":"cars n bikes"}) 
    retItems.append({ "Id":getId(retItems), "Name": qsTr("break fluid")      ,"Amount":250,"Unit":"ml","ItemType":"cars n bikes"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("gear box oil")     ,"Amount":250,"Unit":"ml","ItemType":"cars n bikes"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("motor oil")        ,"Amount":1,"Unit":"l","ItemType":"cars n bikes"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("break pads")       ,"Amount":1,"Unit":"-","ItemType":"cars n bikes"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("windshield clear liquid")       ,"Amount":1,"Unit":"-","ItemType":"cars n bikes"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("coolant")          ,"Amount":1,"Unit":"-","ItemType":"cars n bikes"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("break pads")       ,"Amount":1,"Unit":"-","ItemType":"cars n bikes"})
    retItems.append({ "Id":getId(retItems), "Name": qsTr("oil filter")       ,"Amount":1,"Unit":"-","ItemType":"cars n bikes"})  
    retItems.append({ "Id":getId(retItems), "Name": qsTr("air filter")       ,"Amount":1,"Unit":"-","ItemType":"cars n bikes"})      
    retItems.append({ "Id":getId(retItems), "Name": qsTr("light bulps")      ,"Amount":1,"Unit":"-","ItemType":"cars n bikes"}) 
    retItems.append({ "Id":getId(retItems), "Name": qsTr("fuse set")         ,"Amount":1,"Unit":"-","ItemType":"cars n bikes"})         
    
    for item in retItems:
        item[FieldUnit] = getUnit(item[FieldUnit])
    for item in retItems:
        try:
            tmp = item[FieldCategory]
            if (tmp is not None):
                print(item[FieldCategory])
                item[FieldCategory] = getCategory(item[FieldCategory])
            else:
                item[FieldCategory] = None
        finally:
            continue
    
    return retItems

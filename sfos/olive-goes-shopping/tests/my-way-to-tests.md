# my view
tons of info on the internet - but no real step by step thing
and yes you should know russian

# python tests
## general
can be executed on any machine that has python installed
i did skip everything using pyotherside
my tests concentrate on the pure python part
i do ignore the qml -> python wrapper
## open:
how to test them all at once and get an overall yes / no ?

# qml tests:
## general
you can not execute them in your studio, nor on the dev machine (thinking about all the js code, i thought .. but)

i will start with the execution then comeback to setup.
in my world it is easier to follow when you know what the result is

## how it works
you need to write tests and deploy them to device
on the device you need to modify my-app.qml
then you can execute the tests on the device

so for this you need to:
- write tests
-- tests subfolder
-- tst_blabla.qml
-- create SailfishTestCase.qml that contains your helper methods
- package them
-- .yaml
-- .pro
- prepare test-my-app.qml file

## step by step
### create subfolder tests
- create /tests in parallel to /qml
- put a tst_something.qml file into it
- put a run.sh file into it
- put the copy of your app.qml file into it e.g. olive-goes-shopping.qml
  content of that file OliveGoesShopping {}
  basically the name in Camel

### adapt .pro & yaml file to deploy that
- .pro
tests.files = tests/*
tests.path = $${DEPLOYMENT_PATH}/tests

INSTALLS += tests
OTHER_FILES += tests/tst_* \
   tests/olive-goes-shopping.qml
   tests/run.sh

- yaml
- add Qt5test to PkgConfigBR so something like that ...
PkgConfigBR:
  - sailfishapp >= 1.0.2
  - Qt5Core
  - Qt5Qml
  - Qt5Quick
  - Qt5Test 

### the script
it basically needs to 
- copy org olive-goes-shopping.qml to /.qml e.g. .qml/olive-goes-shopping
- replace /qml/app-name.qml with something like OliveGoesShopping {}
- run the tests
do: chmod u+x <file>
you might need to run the script as devel to have write rights
for test execution NORMAL user ..


## execution on device
### prep
- log in and swith to devel-su
- pkcon install qt5-qtdeclarative-import-qttestpkcon install qt5-qtdeclarative-devel-tools
- try out the runner:
  /usr/lib/qt5/bin/qmltestrunner
- install the app
- check that your tests files are there
  in my case: /usr/share/olive-goes-shopping/tests
- copy the run script some where safe (safe from next install) e.g. /usr/share
- then chmod u+x as root on it
- run it

### execution
- execute tests using this or cript
  /usr/lib/qt5/bin/qmltestrunner -input /usr/share/olive-goes-shopping/tests/

- after each installation you need to run it again once as root
## open
app_name=olive-goes-shopping
camel_name=OliveGoesShopping

mkdir /usr/share/$app_name/.qml -p
cp /usr/share/$app_name/qml/$app_name.qml /usr/share/$app_name/.qml/$camel_name.qml
echo $camel_name {} > /usr/share/$app_name/qml/$app_name.qml
cp /usr/share/$app_name/.qml/$camel_name.qml /usr/share/$app_name/qml/$camel_name.qml

/usr/lib/qt5/bin/qmltestrunner -input /usr/share/$app_name/tests/
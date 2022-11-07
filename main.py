import sys
import logging

from PySide6.QtCore import QDir, QFile, QUrl
from PySide6.QtGui import QGuiApplication # use QGuiApplication instead of QApplication because we are not using QtWidget module.
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtSql import QSqlDatabase

# we import the file just to register the Qml Engine type registration

import sqlDialog

logging.basicConfig(filename="chat.log", level=logging.DEBUG)

def connectToDataBase():
    database = QSqlDatabase.database()
    if not database.isValid():
        database = QSqlDatabase.addDatabase("QSQLITE")
        if not database.isValid():
            logging.error("Cannot add database")
        
    write_dir = QDir("")
    if not write_dir.mkpath("."):
        logging.error("Falied to create writable directory")
    
    #Ensure that we have a writable location on all devices.
    abs_path = write_dir.absolutePath()
    filename = f"{abs_path}/chat-database.sqlite3"

    #when using the Sqlite Driver, open() will create the Sqlite
    #database if it doesn't exits.

    database.setDatabaseName(filename)
    if not database.open():
        logging.error("Cannot open database")

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    connectToDataBase()

    engine = QQmlApplicationEngine()
    # engine.load(QUrl("chat.qml"))
    engine.load("chat.qml")
    engine.load("sqlDialog.py")
    # engine.rootObjects()[0]

    sys.exit(app.exec())


    # if not engine.rootObjects():
    #     sys.exit(-1)
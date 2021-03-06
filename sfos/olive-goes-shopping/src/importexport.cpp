#include "importexport.h"
#include <QDesktopServices>
#include <QDirIterator>
#include <QFile>
#include <QTextStream>
#include <QSettings>

// FIXME
#include <QDebug>

ImportExport::ImportExport(QObject *parent) :
    QObject(parent)
{
}

ImportExport::~ImportExport()
{
}

QString ImportExport::load(const QString &path) const
{
    QString result;
    if (path.isEmpty())
        return result;
    QFile file(path);
    if (!file.open(QFile::ReadOnly | QFile::Text))
        return result;

    QTextStream in(&file);
    in.setCodec("UTF-8");
    result = in.readAll();

    file.close();
    return result;
}

QStringList ImportExport::getFilesList(const QString &directory) const
{
    QStringList result;
    QDirIterator iter(directory);
    while (iter.hasNext()) {
        iter.next();
        QFileInfo info(iter.filePath());
        if (info.isFile() && info.suffix() == "json")
            result.append(info.completeBaseName());
    }
    return result;
}

bool ImportExport::save(const QString &tasks) const
{
    if (mFileName.isEmpty())
        return false;
    // check that directory is present
    int slash = mFileName.lastIndexOf("/");
    if (slash >= 0) {
        QString directoryName = mFileName.left(slash);
        QDir dir(directoryName);
        if (!dir.exists())
            dir.mkpath(".");
    }
    QFile file(mFileName);
    if (!file.open(QFile::WriteOnly | QFile::Truncate))
        return false;

    QTextStream out(&file);
    out.setCodec("UTF-8");
    out << tasks;

    file.close();
    return true;
}

bool ImportExport::remove(const QString &path) const
{
    if (path.isEmpty())
        return false;

    QFile file(path);
    file.remove(path);
    return true;
}

// modified version of https://github.com/karip/harbour-file-browser/blob/master/src/engine.cpp#L122
QStringList ImportExport::mountPoints() const
{
    // read /proc/mounts and return all mount points for the filesystem
    QFile file("/proc/mounts");
    if (!file.open(QFile::ReadOnly | QFile::Text))
        return QStringList();

    QTextStream in(&file);
    QString result = in.readAll();

    // split result to lines
    QStringList lines = result.split(QRegExp("[\n\r]"));

    // get columns
    QStringList dirs;
    foreach (QString line, lines) {
        QStringList columns = line.split(QRegExp("\\s+"), QString::SkipEmptyParts);
        if (columns.count() < 6) // sanity check
            continue;

        QString dir = columns.at(1);
        dirs.append(dir);
    }

    return dirs;
}

QStringList ImportExport::sdcardPath(const QString &path) const
{
    // get sdcard dir candidates
    QDir dir(path);
    if (!dir.exists())
        return QStringList();
    dir.setFilter(QDir::AllDirs | QDir::NoDotAndDotDot);
    QStringList sdcards = dir.entryList();
    if (sdcards.isEmpty())
        return QStringList();

    // remove all directories which are not mount points
    QStringList mps = mountPoints();
    QMutableStringListIterator i(sdcards);
    while (i.hasNext()) {
        QString dirname = i.next();
        QString abspath = dir.absoluteFilePath(dirname);
        if (!mps.contains(abspath))
            i.remove();
    }

    // none found, return empty string
    if (sdcards.isEmpty())
        return QStringList();

    // always return all cards
    return sdcards;
}

/*QString ImportExport::dropboxAuthorizeLink()
{
    initDropbox();
    if (!dropbox->requestTokenAndWait()) {
        qDebug() << "Dropbox auth error:" << dropbox->errorString();
        dropbox->clearError();
        exitDropbox();
        return "";
    }
    return dropbox->authorizeLink().toString();
}

QStringList ImportExport::getDropboxCredentials()
{
    QStringList result;
    if(dropbox->requestAccessTokenAndWait()) {
        QDropboxAccount acc = dropbox->requestAccountInfoAndWait();
        result.append(acc.displayName());

        result.append(dropbox->tokenSecret());
        result.append(dropbox->token());
    }
    return result;
}*/

/*void ImportExport::setDropboxCredentials(const QString &token, const QString &tokenSecret)
{
    if (!dropbox)
        initDropbox();
    dropbox->setToken(token);
    dropbox->setTokenSecret(tokenSecret);
}

QString ImportExport::uploadToDropbox(const QString &tasks)
{
    QDropboxFile file(dropbox);
    file.setFilename(dropboxPath);
    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << "couldn't open file at Dropbox:" << dropboxPath;
        return "";
    }
    QTextStream out(&file);
    out.setCodec("UTF-8");
    out << tasks;
    out.flush();
    if (!file.flush()) {
        qDebug() << "couldn't flush data to Dropbox";
        return "";
    }
    file.close();
    qDebug() << "file is written:" << file.metadata().revisionHash();
    return file.metadata().revisionHash();
}*/

/*QStringList ImportExport::downloadFromDropbox()
{
    QDropboxFile file(dropbox);
    file.setFilename(dropboxPath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "could not open file at Dropbox:" << dropboxPath;
        return {};
    }
    QTextStream in(&file);
    in.setCodec("UTF-8");
    QStringList result = { file.metadata().revisionHash(), in.readAll() };
    file.close();
    return result;
}*/

/*QString ImportExport::getRevision()
{
    QDropboxFile file(dropbox);
    file.setFilename(dropboxPath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "could not open file at Dropbox:" << dropboxPath;
        return "";
    }
    QString rev = file.metadata().revisionHash();
    file.close();
    qDebug() << "revision:" << rev;
    return rev;
}*/

/*void ImportExport::initDropbox()
{
    // FIXME there may be a better way to provide Dropbox keys from outside
#define STRINGIFY2(X) #X
#define STRINGIFY(X) STRINGIFY2(X)

    dropbox = new QDropbox;
    dropbox->setKey(STRINGIFY(TASKLIST_DROPBOX_APPKEY));
    dropbox->setSharedSecret(STRINGIFY(TASKLIST_DROPBOX_SHAREDSECRET));

#undef STRINGIFY
#undef STRINGIFY2
}

void ImportExport::exitDropbox()
{
    if (dropbox) {
        delete dropbox;
        dropbox = NULL;
    }
}*/

QString ImportExport::language()
{
   QSettings settings(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/oarg.pawelspoon/harbour-olive-goes-shopping/harbour-olive-goes-shopping.conf", QSettings::NativeFormat);
    return settings.value("language", "").toString();
}

void ImportExport::setLanguage(const QString &lang)
{
   QSettings settings(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/oarg.pawelspoon/harbour-olive-goes-shopping/harbour-olive-goes-shopping.conf", QSettings::NativeFormat);
    settings.setValue("language", lang);
}

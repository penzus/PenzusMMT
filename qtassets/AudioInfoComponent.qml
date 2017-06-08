import MediaInfoConnection 1.0
import MediaInfo 1.0
import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Column {
    id: audioInfoContainer
    spacing: ui.defautColumnSpacing

    function initialize(fileNamePath) {
        mediaInfoConnection.startProcessInfo(fileNamePath)
    }

    MyHeader {
        title: qsTr("Audio info")
    }
    MyInfoItem {
        id: audioDurationInfoItem
        text: qsTr("Duration")
    }
    MyInfoItem {
        id: audioStreamInfoItem
        text: qsTr("Audio stream")
    }

    MediaInfoConnection {
        id: mediaInfoConnection
        onConnectionFinished: {
            var mediaInfo = mediaInfoConnection.getMediaInfo()
            if (!mediaInfo.isValid()) {
                return
            }
            if (mediaInfo.hasDuration()) {
                audioDurationInfoItem.text2 = mediaInfo.durationString()
            }
            if (mediaInfo.hasAudioStream()) {
                audioStreamInfoItem.text2 = mediaInfo.getFirstAudioStreamInfo()
            }
        }
    }
}

import MediaInfoConnection 1.0
import MediaInfo 1.0
import QtQuick 2.6
// Needed for singletons QTBUG-34418
import "."

Column {
    id: avInfoContainer // audio/video
    spacing: ui.defautColumnSpacing

    function initialize(fileNamePath) {
        mediaInfoConnection.startProcessInfo(fileNamePath)
        mediaInfoConnection.startProcessPreview(fileNamePath)
    }

    MyHeader {
        title: qsTr("Video info")
    }
    MyInfoItem {
        id: videoDurationInfoItem
        text: qsTr("Duration")
    }
    MyInfoItem {
        id: avVideoStreamInfoItem
        text: qsTr("Video stream")
    }
    MyInfoItem {
        id: avAudioStreamInfoItem
        text: qsTr("Audio stream")
    }
    Image {
        id: videoPreview
        asynchronous: true
        cache: false
        smooth: true
        mipmap: ui.isDesktop ? true : false
        width:  Math.min(column.width*3/4,column.height*3/4)
        height: videoPreview.width
        source: "qrc:/qtassets/images/empty.png"
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MediaInfoConnection {
        id: mediaInfoConnection
        onConnectionPreviewFinished: {
            videoPreview.source = fileUtils.pathToUrl(fileNamePath)
        }
        onConnectionFinished: {
            var mediaInfo = mediaInfoConnection.getMediaInfo()
            if (!mediaInfo.isValid()) {
                return
            }

            if (mediaInfo.hasDuration()) {
                videoDurationInfoItem.text2 = mediaInfo.durationString()
            }
            if (mediaInfo.hasVideoStream()) {
                avVideoStreamInfoItem.text2 = mediaInfo.getFirstVideoStreamInfo()
            }
            if (mediaInfo.hasAudioStream()) {
                avAudioStreamInfoItem.text2 = mediaInfo.getFirstAudioStreamInfo()
            }
        }
    }
}

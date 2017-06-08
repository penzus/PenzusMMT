import QtQuick.Controls 1.4
import QtQuick 2.6
import QtQuick.Dialogs 1.2
import QtMultimedia 5.5

Item {
    id: backgroundRectangle
    objectName: "MediaViewerPage"
    width: parent.width
    height: parent.height

    property alias autoplay: mediaPlayer.autoPlay
    property string fileName: ""

    Rectangle {
        id: rect
        width: backgroundRectangle.width
        height: backgroundRectangle.height
        color : "transparent"
        anchors.centerIn: backgroundRectangle
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("Info")
        text: ""
        icon: StandardIcon.Information

        function show(message) {
            text = message
            open()
        }

        onAccepted: {
            visible = false
        }
    }

    MediaPlayer {
        id: mediaPlayer
        autoPlay: true
        source: "file:///mnt/sdcard/test.mp4"

        property bool dataInitialized: false

        onPositionChanged: {
            positionSlider.sync = true
            positionSlider.value = mediaPlayer.position
            startLabel.text = myApp.msToTimeString(mediaPlayer.position)
            positionSlider.sync = false
        }

        onError: {
            // todo
        }

        onPlaybackStateChanged: {
            if (status == 2) {
                updateMediaInfo()
            }
        }

        onPlaying: {
            playPauseButton.enabled = true
            playPauseButton.imageSource = "qrc:/qtassets/images/stop.png"
            timer.start()

        }

        onPaused: {
            playPauseButton.enabled = true
            playPauseButton.imageSource = "qrc:/qtassets/images/play.png"
            timer.stop()
        }

        onStopped: {
            playPauseButton.enabled = true
            playPauseButton.imageSource = "qrc:/qtassets/images/play.png"
            timer.stop()
        }

        function updateMediaInfo() {
            if (!mediaPlayer.hasVideo && !hasAudio) {
                return
            }

            if (!dataInitialized) {
                positionSlider.value = 0
                positionSlider.maximumValue = mediaPlayer.duration
                startLabel.text = myApp.msToTimeString(0)
                stopLabel.text = myApp.msToTimeString(mediaPlayer.duration)
                dataInitialized = true
            }
        }
    }

    VideoOutput {
        anchors.fill: parent
        source: mediaPlayer
    }

    Timer {
        id: timer
        running: false
        repeat: true
        interval: 250

        onTriggered: {
            mediaPlayer.updateMediaInfo()
        }
    }

    MouseArea {
        id: playArea
        anchors.fill: parent
    }

    Column {
        id: column
        spacing: 10
        width: rect.width - 40
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        z: 2

        Row {
            MyLabel {
                id: startLabel
                text: "00:00"
                anchors.verticalCenter: parent.verticalCenter
            }

            Column {
                width: column.width - startLabel.width - stopLabel.width

                Slider {
                    id: positionSlider
                    width: column.width - startLabel.width - stopLabel.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    value: 0

                    property bool sync: false

                    onValueChanged: {
                        if (!sync) {
                            mediaPlayer.seek(value)
                        }
                    }
                }
            }

            MyLabel {
                id: stopLabel
                anchors.verticalCenter: parent.verticalCenter
                text: "00:00"
            }
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            MyImageButton {
                id: infoButton
                imageSource:   "qrc:/qtassets/images/info.png"

                onClicked: {
                    var string = ("Resolution: ") + mediaPlayer.metaData.resolution + "\n" +
                            ("Sample rate: ") + mediaPlayer.metaData.sampleRate + "\n" +
                            ("Size: ") + mediaPlayer.metaData.size + "\n" +
                            ("Subtitle: ") + mediaPlayer.metaData.subTitle + "\n" +
                            ("Title: ") + mediaPlayer.metaData.title + "\n" +
                            ("Track count: ") + mediaPlayer.metaData.trackCount + "\n" +
                            ("Track number: ") + mediaPlayer.metaData.trackNumber + "\n" +
                            ("Video bitrate: ") + mediaPlayer.metaData.videoBitRate + "\n" +
                            ("Video codec: ") + mediaPlayer.metaData.videoCodec + "\n" +
                            ("Video framerate: ") + mediaPlayer.metaData.videoFrameRate

                    messageDialog.show(string)
                }
            }

            MyImageButton {
                id: playPauseButton
                imageSource:   "qrc:/qtassets/images/play.png"

                onClicked: {
                    playPauseButton.enabled = false
                    if (imageSource == "qrc:/qtassets/images/play.png") {
                        mediaPlayer.play()
                    } else {
                        mediaPlayer.pause()
                        timer.stop()
                    }
                }
            }

            MyImageButton {
                id: shareButton
                imageSource:   "qrc:/qtassets/images/share.png"
            }
        }
    }

    Rectangle {
        z: 1
        color: "#7f7f7f7f"
        width: rect.width
        height: rect.height - column.y
        x: 0
        y: column.y
    }
}

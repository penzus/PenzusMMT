import QtQuick 2.6
import QtQuick.Controls 1.4
import QtMultimedia 5.6
// Needed for singletons QTBUG-34418
import "."

Column {
    id: timeSelector
    spacing: ui.defautColumnSpacing
    width: parent.width

    property alias audioPlayer:  audioPlayer
    property bool intervalSelected: false
    property variant firstTime: 0
    property variant secondTime: 0

    Component.onCompleted: {
        setControlsEnabled(false)
    }

    function setControlsEnabled(enabled) {
        if (!enabled) {
            firstTime = 0
            secondTime = 0
        }
        slider.enabled = enabled
        playPauseButton.enabled = enabled
        stopButton.enabled = enabled
        flag1Button.enabled = enabled
        flag2Button.enabled = enabled

        audioPlayerCurrentTimeLabel.reset()
        audioPlayerTotalTimeLabel.reset()
        audioTrackFirstTimeLabel.reset()
        audioTrackSecondTimeLabel.reset()
    }

    function checkValidTimeInterval() {
        if (  firstTime >= secondTime ) {
            intervalSelected = false
            return
        }
        intervalSelected = true
    }

    function setFileName(fileName) {
        stop()
        audioPlayer.reset()
        audioPlayer.source = myApp.fileNameToUrl(fileName)

        setControlsEnabled(true)
        if (0 /* just for test, not properly loaded */) {
            setControlsEnabled(false)
            return false
        }
        return true
    }

    function stop() {
        audioPlayer.realFilePosition = 0
        audioPlayer.pause()
        audioPlayer.seek(0)
        audioPlayerCurrentTimeLabel.reset()
        slider.value = 0
    }

    MediaPlayer {
        id: audioPlayer

        property variant realFilePosition: 0

        function reset() {
            stop()
        }

        onDurationChanged: {
            setControlsEnabled(true)
            slider.minimumValue = 0
            slider.maximumValue = audioPlayer.duration
            audioPlayerTotalTimeLabel.text = mml.durationToString(audioPlayer.duration)
        }

        onError: {
            console.log("MediaPlayer: error: " + error  + ", " +  errorString )
        }

        onPlaybackStateChanged: {
            console.log("position: playBackState##" + playbackState + " === " +  audioPlayer.position + "== " + audioPlayer.position)

            switch (playbackState ) {
            case MediaPlayer.PlayingState:
                break;
            case MediaPlayer.PausedState:
                break;
            case MediaPlayer.StoppedState:
                break;
            default:
            }
        }

        onPositionChanged: {
            if (slider.allowChangeSlider && (audioPlayer.playbackState === MediaPlayer.StoppedState)
                    && (audioPlayer.position === 0) &&  audioPlayer.realFilePosition === audioPlayer.duration) {
                return
            }

            audioPlayer.realFilePosition = audioPlayer.position

            if (slider.allowChangeSlider) {
                slider.value = audioPlayer.realFilePosition
            }
            audioPlayerCurrentTimeLabel.text = mml.durationToString(audioPlayer.realFilePosition)
        }
    }

    MySpacer {
        width: parent.width
    }

    Row {
        spacing: ui.defautRowSpacing/2
        width: parent.width

        MyLabel {
            id: label1
            text: "["
            anchors.verticalCenter: parent.verticalCenter
        }

        TimeLabel {
            id: audioPlayerCurrentTimeLabel
            text: "00:00"
            anchors.verticalCenter: parent.verticalCenter
        }

        MyLabel {
            id: label2
            text: "/"
            anchors.verticalCenter: parent.verticalCenter
        }

        TimeLabel {
            id: audioPlayerTotalTimeLabel
            text: "00:00"
            anchors.verticalCenter: parent.verticalCenter
        }

        MyLabel {
            id: label3
            text: "]"
            anchors.verticalCenter: parent.verticalCenter
        }

        MySpacer {
            id: emptySpaceLabel
            visible: true
            width:  parent.width - label1.width - label2.width - label3.width - audioPlayerCurrentTimeLabel.width - audioPlayerTotalTimeLabel.width -
                    label4.width - label5.width - label5.width - audioTrackFirstTimeLabel.width - audioTrackSecondTimeLabel.width - parent.spacing * 10
        }

        MyLabel {
            id: label4
            text: "["
            color: intervalSelected ? "green" : "red"
            anchors.verticalCenter: parent.verticalCenter
        }

        TimeLabel {
            id: audioTrackFirstTimeLabel
            text: "00:00"
            color: intervalSelected ? "green" : "red"
            anchors.verticalCenter: parent.verticalCenter
        }

        MyLabel {
            id: label5
            text: "-"
            color: intervalSelected ? "green" : "red"
            anchors.verticalCenter: parent.verticalCenter
        }

        TimeLabel {
            id: audioTrackSecondTimeLabel
            text: "00:00"
            anchors.verticalCenter: parent.verticalCenter
            color: intervalSelected ? "green" : "red"
        }

        MyLabel {
            id: label6
            text: "]"
            anchors.verticalCenter: parent.verticalCenter
            color: intervalSelected ? "green" : "red"
        }
    }

    Slider {
        id: slider
        width: parent.width
        property bool allowChangeSlider: true

        onPressedChanged: {
            allowChangeSlider = false
            if (audioPlayer.playbackState === MediaPlayer.StoppedState) {
                audioPlayer.pause()
            }
        }

        onValueChanged: {
            if (!allowChangeSlider) {
                audioPlayer.seek(value)
            }
            allowChangeSlider = true
        }
    }

    Row {
        id: sliderRow
        spacing: 0
        width: parent.width

        property color notUsedColor: "steelblue"
        property color usedColor: "green"

        MyHorizontalDivider {
            id: rectangle1
            color: sliderRow.notUsedColor
            width: parent.width /3
        }

        MyHorizontalDivider {
            id: rectangle2
            color: sliderRow.usedColor
            width: parent.width /3
        }

        MyHorizontalDivider {
            id: rectangle3
            color: sliderRow.notUsedColor
            width: parent.width /3
        }
    }

    Row {
        spacing: ui.defautRowSpacing/2
        width: parent.width

        MyImageButton {
            id: playPauseButton
            imageSource: audioPlayer.playbackState === audioPlayer.PlayingState ?
                             "qrc:/qtassets/images/timeselection/pause.png" : "qrc:/qtassets/images/timeselection/play.png"

            width: ui.defautSmallImageButtonWidth
            height: ui.defautSmallImageButtonHeight
            radius: ui.defautSmallImageButtonRadius

            onClicked: {
                if (audioPlayer.playbackState !== audioPlayer.PlayingState ) {
                    slider.allowChangeSlider = true

                    if (audioPlayer.playbackState === MediaPlayer.PausedState) {
                        audioPlayer.play()
                    }
                }
            }
        }

        MyImageButton {
            id: stopButton
            imageSource: "qrc:/qtassets/images/timeselection/stop.png"
            width: ui.defautSmallImageButtonWidth
            height: ui.defautSmallImageButtonHeight
            radius: ui.defautSmallImageButtonRadius

            onClicked: {
                audioPlayer.stop()
            }
        }

        MySpacer {
            id: emptySpaceLabel2
            visible: true
            width: parent.width - playPauseButton.width * 4 - parent.spacing * 4
            anchors.verticalCenter: parent.verticalCenter
        }

        MyImageButton {
            id: flag1Button
            width: ui.defautSmallImageButtonWidth
            height: ui.defautSmallImageButtonHeight
            radius: ui.defautSmallImageButtonRadius
            imageSource: "qrc:/qtassets/images/timeselection/flag.png"

            onClicked: {
                firstTime = audioPlayer.realFilePosition
                audioTrackFirstTimeLabel.text = mml.durationToString(firstTime)
                checkValidTimeInterval()
            }
        }

        MyImageButton {
            id: flag2Button
            imageSource:  "qrc:/qtassets/images/timeselection/flag2.png"
            width: ui.defautSmallImageButtonWidth
            height: ui.defautSmallImageButtonHeight
            radius: ui.defautSmallImageButtonRadius

            onClicked: {
                secondTime = audioPlayer.realFilePosition
                audioTrackSecondTimeLabel.text = mml.durationToString(secondTime)
                checkValidTimeInterval()
            }
        }

        MyLabel {
            visible: false
            text: "   "
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MySpacer {
        width: parent.width
    }
}

import QtQuick 2.6
import QtQuick.Window 2.2

pragma Singleton

QtObject {

    property bool isDesktop: false
    property bool isAndroid: !isDesktop

    // Button
    property int defautButtonWidth: isDesktop ? 126 : 275
    property int defautButtonHeight: isDesktop ? 26 : 78
    property int defautButtonRadius: isDesktop ? 5 : 5

    // Image button
    property int defautImageButtonWidth: isDesktop ? 48 : 114
    property int defautImageButtonHeight: isDesktop ? 48 : 114
    property int defautImageButtonRadius: isDesktop ? 5 : 5

    // Small image button
    property int defautSmallImageButtonWidth: defautImageButtonWidth*2/3
    property int defautSmallImageButtonHeight: defautImageButtonHeight*2/3
    property int defautSmallImageButtonRadius: defautImageButtonRadius*2/3

    // Column, Row
    property int defautColumnSpacing: isDesktop ? 10 : 20
    property int defautRowSpacing: isDesktop ? 10 : 20

    // Combobox
    property int defaultComboBoxWidth: isDesktop ? 126 : 275
    property int defaultComboBoxHeight: isDesktop ? 26 : 78
    property int defaultComboBoxRadius: isDesktop ? 5 : 5
    property int defaultComboBoxBorderWidth: isDesktop ? 2 : 2

    // Header
    property int  defaultHeaderBorderHeight: isDesktop ? 2 : 2
    property int  defaultHeaderSpacing: isDesktop ? 5 : 5

    // Spacer
    property int defautSpacerHeight: isDesktop ? 5 : 5

    // vertical and horizontal divider
    property int defautDividerHeight: isDesktop ? 2 : 2
    property int defautDividerWidtht: isDesktop ? 2 : 2

    // Margins and Spaces
    property int defautMargin: isDesktop ? 10 : 20
    property int maximumPageWidth: 1280

    // Dialogs
    property int defaultDialogWidth: isDesktop ? 400 : 680

    // Rectangle
    property int defaultRectangleRadius: 5

    // ListView
    property int listViewItemHeight: isDesktop ? 36 : 106//96
    property int listViewItemMargin: isDesktop ? 10 : 10
    property int listViewItemBorderHeight: isDesktop ? 1 : 1

    // Fonts, we will update it later
    property int mediumFontSize: isDesktop ? 20 : 20
    property int xxSmallFontSize: 0.4 * mediumFontSize
    property int xSmallFontSize: 0.6 * mediumFontSize
    property int smallFontSize: 0.8 * mediumFontSize
    property int largeFontSize: 1.2 * mediumFontSize
    property int xLargeFontSize: 1.4 * mediumFontSize
    property int xxLargeFontSize: 1.6 * mediumFontSize

    // TitleBar
    property int titleBarFontSize: isDesktop ? 20 : 42
    property int titleBarHeight: isDesktop ? 50 : 100

    // Kostyl
    property int titleBarMaxHeight: titleBarHeight

    // Colors
    property string featureColor1: "#62b1f6"

    // My standard device
    property real standardRatio: 1.0
    property real standardPixelDensity: 11.428571428571429
    property real standardDeviceSize: 720

    // my dialogs
    property string dialogFontColor: "black"
    property string dialogBackgroundButtonColor: "#f0f0f0"
    property string dialogBackgroundPressedButtonColor: "#d8d8d8"
    property string dialogDividerColor: "#e5e5e5"
    property string dialogDisabledButtonFontColor: "#a4a4a4"

    Screen.onPrimaryOrientationChanged: {
        if (isDesktop) {
            return
        }
        updateTitleBarHeight()
    }

    function updateTitleBarHeight() {
        titleBarHeight = isDesktop ? 50 : systemTools.getTitleBarHeight()
        titleBarHeight = (titleBarMaxHeight > titleBarHeight) ? titleBarMaxHeight : titleBarHeight
        titleBarMaxHeight = titleBarHeight
    }

    function updateFontSizes(fontSize) {
        mediumFontSize = fontSize
        xxSmallFontSize = Math.round(0.4 * mediumFontSize)
        xSmallFontSize = Math.round(0.6 * mediumFontSize)
        smallFontSize = Math.round(0.8 * mediumFontSize)
        largeFontSize =  Math.round(1.2 * mediumFontSize)
        xLargeFontSize = Math.round(1.4 * mediumFontSize)
        xxLargeFontSize = Math.round(1.6 * mediumFontSize)

        updateTitleBarHeight()
    }

    Component.onCompleted: {
        isDesktop = myApp.isDesktop()
        if (isDesktop) {
            return
        }

        updateTitleBarHeight()

        // calculate size ratio
        var currentSizeRatio = Screen.pixelDensity/standardPixelDensity
        var currentDeviceSize = Math.min(Screen.width,Screen.height)
        var sizeRatio = Math.min(currentDeviceSize/standardDeviceSize, currentSizeRatio)

        // Button
        defautButtonWidth = sizeRatio * defautButtonWidth
        defautButtonHeight = sizeRatio * defautButtonHeight
        defautButtonRadius = sizeRatio * defautButtonRadius

        // Image button
        defautImageButtonWidth = sizeRatio * defautImageButtonWidth
        defautImageButtonHeight = sizeRatio * defautImageButtonHeight
        defautImageButtonRadius = sizeRatio * defautImageButtonRadius

        // Small image button
        defautSmallImageButtonWidth = sizeRatio * defautSmallImageButtonWidth
        defautSmallImageButtonHeight = sizeRatio * defautSmallImageButtonHeight
        defautSmallImageButtonRadius = sizeRatio * defautSmallImageButtonRadius

        // Column, Row
        defautColumnSpacing = sizeRatio * defautColumnSpacing
        defautRowSpacing = sizeRatio * defautRowSpacing

        // Combobox
        defaultComboBoxWidth = sizeRatio * defaultComboBoxWidth
        defaultComboBoxHeight = sizeRatio * defaultComboBoxHeight
        defaultComboBoxRadius = sizeRatio * defaultComboBoxRadius
        defaultComboBoxBorderWidth = sizeRatio * defaultComboBoxBorderWidth

        // Header
        defaultHeaderBorderHeight = sizeRatio * defaultHeaderBorderHeight
        defaultHeaderSpacing = sizeRatio * defaultHeaderSpacing

        // Spacer
        defautSpacerHeight = sizeRatio * defautSpacerHeight

        // Divider
        defautDividerHeight = sizeRatio * defautDividerHeight

        // Margins and Spaces
        defautMargin = sizeRatio * defautMargin
        maximumPageWidth = sizeRatio * maximumPageWidth

        // Dialogs
        defaultDialogWidth = sizeRatio * defaultDialogWidth

        // Rectangle
        defaultRectangleRadius = sizeRatio * defaultRectangleRadius

        // ListView
        listViewItemHeight = sizeRatio * listViewItemHeight
        listViewItemMargin = sizeRatio * listViewItemMargin
        listViewItemBorderHeight = sizeRatio * listViewItemBorderHeight

        // Fonts
        // Not needed

        // TitleBar
        titleBarFontSize = sizeRatio * titleBarFontSize

/*
        console.log("Screen.desktopAvailableWidth: " + Screen.desktopAvailableWidth)
        console.log("Screen.desktopAvailableHeight: " + Screen.desktopAvailableHeight)
        console.log("Screen.devicePixelRatio: " + Screen.devicePixelRatio)
        console.log("Screen.width: " + Screen.width)
        console.log("Screen.height: " + Screen.height)
        console.log("Screen.pixelDensity: " + Screen.pixelDensity)
        console.log("Title bar height: " + titleBarHeight)
        console.log("Current size ratio (by side): " + currentSizeRatio)
        console.log("Current min device size: " + currentDeviceSize)
        console.log("Real size ratio: " + sizeRatio)
*/
    }
}

import ".." as Skin
import Mixxx 1.0 as Mixxx
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts
import "../Theme"

Item {
    id: root

    required property string group

    readonly property var beatLabels: ["1/2", "1", "2", "4", "8", "16"]
    readonly property var beatValues: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
    readonly property bool deckActive: flx4ActiveDeck.value > 0.5

    implicitHeight: 120
    implicitWidth: 180

    function deckNumber() {
        const match = root.group.match(/Channel(\d+)/);
        return match ? parseInt(match[1]) : 0;
    }

    function effectIndexForId(effectId) {
        if (!effectId) {
            return -1;
        }
        const model = Mixxx.EffectsManager.visibleEffectsModel;
        const rowCount = model.rowCount();
        for (let i = 0; i < rowCount; i++) {
            const row = model.get(i);
            if (row.effectId === effectId) {
                return i;
            }
        }
        return -1;
    }

    function effectNameForId(effectId) {
        if (!effectId) {
            return "---";
        }
        const model = Mixxx.EffectsManager.visibleEffectsModel;
        const rowCount = model.rowCount();
        for (let i = 0; i < rowCount; i++) {
            const row = model.get(i);
            if (row.effectId === effectId) {
                return row.display;
            }
        }
        return "---";
    }

    function setEffectByOffset(delta) {
        const model = Mixxx.EffectsManager.visibleEffectsModel;
        const rowCount = model.rowCount();
        if (rowCount === 0) {
            return;
        }
        let currentIndex = effectIndexForId(currentSlot.effectId);
        if (currentIndex < 0) {
            currentIndex = 0;
        }
        const nextIndex = (currentIndex + delta + rowCount) % rowCount;
        currentSlot.effectId = model.get(nextIndex).effectId;
    }

    function nearestBeatIndex(value) {
        let bestIndex = 0;
        let bestDistance = Infinity;
        for (let i = 0; i < beatValues.length; i++) {
            const distance = Math.abs(value - beatValues[i]);
            if (distance < bestDistance) {
                bestDistance = distance;
                bestIndex = i;
            }
        }
        return bestIndex;
    }

    function setBeatIndex(index) {
        const clamped = Math.max(0, Math.min(beatValues.length - 1, index));
        metaControl.parameter = beatValues[clamped];
    }

    Mixxx.ControlProxy {
        id: flx4ActiveDeck

        group: root.group
        key: "flx4_active_deck"
    }

    Mixxx.ControlProxy {
        id: focusedEffect

        group: "[EffectRack1_EffectUnit1]"
        key: "focused_effect"
    }

    Mixxx.ControlProxy {
        id: mixControl

        group: "[EffectRack1_EffectUnit1]"
        key: "mix"
    }

    Mixxx.ControlProxy {
        id: deckFxAssign

        group: "[EffectRack1_EffectUnit1]"
        key: `group_${root.group}_enable`
    }

    readonly property var slot1: Mixxx.EffectsManager.getEffectSlot(1, 1)
    readonly property var slot2: Mixxx.EffectsManager.getEffectSlot(1, 2)
    readonly property var slot3: Mixxx.EffectsManager.getEffectSlot(1, 3)

    readonly property var currentSlot: focusedEffect.value === 2
        ? slot2
        : focusedEffect.value === 3
            ? slot3
            : slot1

    Mixxx.ControlProxy {
        id: metaControl

        group: currentSlot.group
        key: "meta"
    }

    readonly property int activeBeatIndex: nearestBeatIndex(metaControl.parameter)

    Rectangle {
        id: frame

        anchors.fill: parent
        color: Theme.darkGray2
        radius: 4
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Label {
                Layout.fillWidth: true
                color: Theme.lightGray2
                font.pixelSize: 9
                font.weight: Font.Bold
                text: `BEAT FX • DECK ${deckNumber()}`
                elide: Text.ElideRight
            }

            Rectangle {
                height: 10
                width: 10
                radius: 5
                color: deckFxAssign.value > 0.5 ? Theme.effectColor : Theme.midGray2
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            Skin.Button {
                text: "<"
                activeColor: Theme.effectColor
                normalColor: Theme.lightGray
                enabled: root.deckActive
                implicitWidth: 22
                onClicked: setEffectByOffset(-1)
            }

            Rectangle {
                Layout.fillWidth: true
                height: 26
                color: Theme.darkGray3
                radius: 3

                Label {
                    anchors.centerIn: parent
                    color: Theme.white
                    font.pixelSize: 10
                    text: effectNameForId(currentSlot.effectId)
                    elide: Text.ElideRight
                    width: parent.width - 8
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Skin.Button {
                text: ">"
                activeColor: Theme.effectColor
                normalColor: Theme.lightGray
                enabled: root.deckActive
                implicitWidth: 22
                onClicked: setEffectByOffset(1)
            }

            Skin.ControlButton {
                group: currentSlot.group
                key: "enabled"
                toggleable: true
                text: "ON"
                activeColor: Theme.effectColor
                normalColor: Theme.lightGray
                enabled: root.deckActive
                implicitWidth: 36
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            Skin.Button {
                text: "-"
                activeColor: Theme.effectColor
                normalColor: Theme.lightGray
                enabled: root.deckActive
                implicitWidth: 22
                onClicked: setBeatIndex(activeBeatIndex - 1)
            }

            Repeater {
                model: beatLabels.length

                Skin.Button {
                    required property int index

                    text: beatLabels[index]
                    activeColor: Theme.effectColor
                    normalColor: Theme.lightGray
                    highlight: activeBeatIndex === index
                    enabled: root.deckActive
                    implicitWidth: 24
                    onClicked: setBeatIndex(index)
                }
            }

            Skin.Button {
                text: "+"
                activeColor: Theme.effectColor
                normalColor: Theme.lightGray
                enabled: root.deckActive
                implicitWidth: 22
                onClicked: setBeatIndex(activeBeatIndex + 1)
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Label {
                color: Theme.lightGray
                font.pixelSize: 9
                text: "LEVEL / DEPTH"
            }

            Item {
                Layout.fillWidth: true
                height: 12

                Rectangle {
                    id: levelTrack

                    anchors.fill: parent
                    color: Theme.midGray2
                    radius: 3
                }

                Rectangle {
                    id: levelFill

                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * mixControl.parameter
                    color: Theme.effectColor
                    radius: 3
                }

                Rectangle {
                    id: levelHandle

                    height: parent.height + 4
                    width: 4
                    x: Math.max(0, levelFill.width - width / 2)
                    y: -2
                    color: Theme.white
                    radius: 2
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: root.deckActive
                    onPressed: {
                        const clamped = Math.max(0, Math.min(1, mouse.x / width));
                        mixControl.parameter = clamped;
                    }
                    onPositionChanged: {
                        if (!pressed) {
                            return;
                        }
                        const clamped = Math.max(0, Math.min(1, mouse.x / width));
                        mixControl.parameter = clamped;
                    }
                }
            }
        }
    }

    opacity: root.deckActive ? 1.0 : 0.6
}

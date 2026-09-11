import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// CPU %, RAM used/total, CPU temperature, and disk used/total, polled from
// sysinfo.sh next to this file. Click launches btop for the full picture.
BarWidget {
  id: root
  moduleName: "santato.sysinfo"

  readonly property string scriptPath: Quickshell.env("HOME") + "/.config/omarchy/plugins/santato.sysinfo/sysinfo.sh"
  property string statsText: "…"
  property var segments: [{ color: Color.foreground, text: "…" }]

  function refresh() {
    if (!statsProc.running) statsProc.running = true
  }

  // sysinfo.sh emits one "color<TAB>text" segment per line; the bar's Text
  // no longer renders inline HTML, so each segment gets its own Text item.
  function parseSegments(raw) {
    const lines = raw.split("\n").filter(line => line.length > 0)
    if (lines.length === 0) return [{ color: Color.foreground, text: raw }]
    return lines.map(line => {
      const tab = line.indexOf("\t")
      return tab < 0
        ? { color: Color.foreground, text: line }
        : { color: line.slice(0, tab), text: line.slice(tab + 1) }
    })
  }

  onStatsTextChanged: segments = parseSegments(statsText)

  implicitWidth: button.width
  implicitHeight: barSize

  Rectangle {
    anchors.centerIn: parent
    width: button.width
    height: button.height
    radius: Math.max(2, Style.cornerRadius)
    color: "transparent"
    border.width: 1
    border.color: Color.muted
  }

  Process {
    id: statsProc
    command: ["bash", root.scriptPath]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.statsText = text.trim()
    }
  }

  Timer {
    interval: 3000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  WidgetButton {
    id: button
    anchors.centerIn: parent
    width: implicitWidth
    height: Style.font.body + Style.space(6)
    bar: root.bar
    text: root.segments.map(s => s.text).join("")
    labelVisible: false
    horizontalMargin: 2
    tooltipText: "System info - click to open btop"
    onPressed: if (root.bar) root.bar.run("omarchy-launch-or-focus-tui btop")

    Row {
      anchors.centerIn: parent
      Repeater {
        model: root.segments
        delegate: Text {
          text: modelData.text
          color: modelData.color
          font.family: button.fontFamily
          font.pixelSize: button.fontSize
          renderType: Text.NativeRendering
        }
      }
    }
  }
}

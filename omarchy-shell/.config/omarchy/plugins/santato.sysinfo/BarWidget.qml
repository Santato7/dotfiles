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

  function refresh() {
    if (!statsProc.running) statsProc.running = true
  }

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
    text: root.statsText
    horizontalMargin: 2
    tooltipText: "System info - click to open btop"
    onPressed: if (root.bar) root.bar.run("omarchy-launch-or-focus-tui btop")
  }
}

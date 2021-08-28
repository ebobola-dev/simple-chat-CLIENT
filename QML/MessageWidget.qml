import QtQuick //2.15
import QtQuick.Window //2.15
import QtQuick.Controls //2.15
import QtQuick.Controls.Material //2.15
import QtQuick.Layouts //1.15

RowLayout{
	id: messageWidget
	height: messageWidgetBg.height

	property string msg_id
	property string name
	property string msg_text
	property string time
	property var datetime: new Date(messageWidget.time * 1000)

	Rectangle{
		id: messageWidgetBg

		Layout.preferredWidth: parent.width
		Layout.preferredHeight: label_name.contentHeight + 5 + label_text.contentHeight + 5 + 5
		color: '#01040c'
		radius: 10
		clip: true

		Label{
			id: label_name
			anchors{
				top: parent.top
				left: parent.left
				topMargin: 5
				leftMargin: 10
				rightMargin: 10
			}
			text: name
			color: '#8be9fd'
			font.pointSize: 11
			font.family: "Proxima Nova Rg"
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
		}
		Label{
			id: label_text
			anchors{
				top: label_name.bottom
				left: parent.left
				right: parent.right
				topMargin: 5
				leftMargin: 10
				rightMargin: 40
				bottomMargin: 5
			}
			text: msg_text
			wrapMode: Text.WordWrap
			font.pointSize: 12
			font.family: "Proxima Nova Rg"
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignLeft
		}
		Label{
			id: label_time
			anchors{
				bottom: parent.bottom
				right: parent.right
				margins: 5
			}
			text: Qt.formatTime(datetime, 'hh:mm')
			color: '#b9bcc3'
			font.pointSize: 9
			font.family: "Proxima Nova Rg"
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
		}
	}
}
import QtQuick //2.15
import QtQuick.Window //2.15
import QtQuick.Controls //2.15
import QtQuick.Controls.Material //2.15
import QtQuick.Timeline //1.0

ApplicationWindow{
	id: app
	width: 400
	height: 700
	visible: true
	title: qsTr('Simple Chat')
	// FLAGS
	flags: Qt.FramelessWindowHint | Qt.Window

	// SET MATERIAL STYLE
	Material.theme: Material.Dark
	Material.accent: Material.LightBlue
	color: "#00000000" // TRANSPARENT

	Connections{
		target: app_backend

		function onGotAll(messages){
			messagesListModel.clear()
			messages.forEach(element => { messagesListModel.append(element) })
		}

		function onGotNew(message){
			messagesListModel.append(message)
		}

		function onNewOnline(online){
			label_online_count.text = `Онлайн: ${online}`
		}
	}

	function get_all_messages(){
		app_backend.get_all_messages()
	}

	function send(name, text) {
		if (!name || !text) return
		typingMessage.clear()
		app_backend.send_message(name, text)
	}

	function disconnect(){
		app_backend.disconnect_from_server()
	}

	Component.onCompleted: {
		get_all_messages()
		app_backend.get_online()
	}

	Rectangle{
		id: backround
		anchors.fill: parent
		color: Material.background

		Rectangle{
			id: titleBar
			height: 40
			color: '#212121'
			anchors{
				top: parent.top
				left: parent.left
				right: parent.right
			}

			Label{
				id: label_online_count
				text: qsTr('Онлайн 0')
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				color: '#50fa7b'
				font.family: 'HelveticaNeueCyr'
				font.pointSize: 12
				verticalAlignment: Text.AlignVCenter
				horizontalAlignment: Text.AlignHCenter
			}

			Button{
				id: btnClose
				width: parent.height
				height: parent.height
				anchors{
					right: parent.right
				}
				Rectangle{
					id: btnCloseBg
					color: btnClose.hovered ? Material.color(Material.Red) : '#212121'
					anchors.fill: btnClose
					Image{
						id: closeIcon
						source: "../images/white_close.png"
						anchors{
							fill: btnCloseBg
							margins: 10
						}
					}
				}
				MouseArea{
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: {
						app.disconnect()
						app.close()
					}
				}
			}
			// MINIMIZE BUTTON
			Button{
				id: btnMinimize
				width: parent.height
				height: parent.height
				anchors{
					right: btnClose.left
				}
				Rectangle{
					id: btnMinimizeBg
					color: btnMinimize.hovered ? '#424242' : '#212121'
					anchors.fill: btnMinimize
					Image{
						id: minimizeBgIcon
						source: "../images/white_minimize.png"
						anchors{
							fill: btnMinimizeBg
							margins: 10
						}
					}
				}
				MouseArea{
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: app.showMinimized()
				}
			}

			DragHandler{
				onActiveChanged: if(active){
					app.startSystemMove()
				}
			}
		} // titleBar

		TextField{
			id: inputName
			placeholderText: qsTr('Введите ваше имя')
			height: 45
			anchors{
				left: parent.left
				top: titleBar.bottom
				right: parent.right
				leftMargin: 5
				rightMargin: 5
				topMargin: 5
			}
			topPadding: 5
			bottomPadding: 5
			leftPadding: 10
			rightPadding: 10
			font.family: 'HelveticaNeueCyr'
			font.pointSize: 11
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignLeft
			background: Rectangle{
				id: inputNameBg
				radius: 5
				color: '#414141'
			}
		} // inputName

		ListView{
			id: messagesListView
			visible: true
			clip: true
			anchors{
				left: parent ? parent.left : undefined
				top: inputName.bottom
				right: parent ? parent.right : undefined
				bottom: typingMessageBlock.top
				margins: 10
			}
			model: messagesListModel
			spacing: 10
			ScrollBar.vertical: ScrollBar{}
			delegate: MessageWidget{
				width: 200
				msg_id: model.id
				name: model.name
				msg_text: model.text
				time: model.time
			}
			onCountChanged: {
				messagesListView.currentIndex = count - 1
			}
		} // messagesListView
		ListModel{ id: messagesListModel }
		Rectangle{
			id: typingMessageBlock
			height: 60
			color: 'transparent'
			anchors{
				right: parent.right
				left: parent.left
				bottom: parent.bottom
				margins: 5
			}
			TextField{
				id: typingMessage
				placeholderText: qsTr('Введите текст сообщения')
				anchors{
					top: parent.top
					bottom: parent.bottom
					left: parent.left
					right: btnSend.left
					margins: 5
				}
				topPadding: 5
				bottomPadding: 5
				leftPadding: 10
				rightPadding: 10
				font.family: 'HelveticaNeueCyr'
				font.pointSize: 11
				verticalAlignment: Text.AlignVCenter
				horizontalAlignment: Text.AlignLeft
				background: Rectangle{
					id: typingMessageBg
					radius: 5
					color: '#414141'
				}
				Keys.onReturnPressed: {
					app.send(inputName.text, typingMessage.text)
				}
			}
			RoundButton{
				id: btnSend
				width: parent.height
				height: parent.height
				anchors{
					right: parent.right
					verticalCenter: parent.verticalCenter
				}
				background: Rectangle{
					id: btnSendBg
					color: btnSend.hovered ? '#1aa9a9a9' : 'transparent'
					radius: btnSend.width / 2
					Image{
						id: sendIcon
						source:  btnSend.hovered ? "../images/blue_send2.png" : "../images/white_send2.png"
						anchors{
							fill: parent
							topMargin: 11
							leftMargin: 10
							rightMargin: 9
							bottomMargin: 6
						}
					}
				}
				MouseArea{
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: app.send(inputName.text, typingMessage.text)
				}
			}
		} // typingMessageBlock
	}
}
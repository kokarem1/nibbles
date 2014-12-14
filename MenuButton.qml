import QtQuick 2.0

StatusBarButton {
    border.color: "orange"
    gradient:
        Gradient {
            GradientStop { position: 0.0; color: "sandybrown" }
            GradientStop { position: 1.0; color: "orange" }
        }

    caption.color: "darkblue"
}

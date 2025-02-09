import re
import subprocess
import sys
from pathlib import Path

import yaml
from PyQt5.QtWidgets import (
    QApplication,
    QComboBox,
    QLabel,
    QPushButton,
    QVBoxLayout,
    QWidget,
)

CONFIG_PATH = Path("config.yml")


class ClearTunnelApp(QWidget):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Clear Tunnel 🛡️")
        self.setGeometry(100, 100, 400, 200)

        # Layout setup
        layout = QVBoxLayout()

        # Read the YAML file with AWS regions
        with CONFIG_PATH.open("r", encoding="utf-8") as file:
            self.config = yaml.safe_load(file)

        # ComboBox to select region
        self.region_combo = QComboBox()
        self.region_combo.addItems(self.config.get("regions", []))

        # Button to execute the script
        self.run_button = QPushButton("Run Tunnel")
        self.run_button.clicked.connect(self.run_tunnel)

        # Label to show the result
        self.result_label = QLabel("")

        # Add widgets to layout
        layout.addWidget(self.region_combo)
        layout.addWidget(self.run_button)
        layout.addWidget(self.result_label)

        self.setLayout(layout)

    def run_tunnel(self):
        selected_region = self.region_combo.currentText()
        result = subprocess.run(["bash", "/app/openvpn-connect.sh", selected_region], capture_output=True, text=True)
        url_pattern = r"https?://[a-zA-Z0-9.-]+(?:/[a-zA-Z0-9&%_./-]*)?(?:\?[a-zA-Z0-9&%=._/-]*)?"
        url = re.findall(url_pattern, result.stdout)[0]
        subprocess.run(["bash", "firefox", url], capture_output=True, text=True)
        self.result_label.setText(f"Url: {url}")


# Main function to run the application
if __name__ == "__main__":
    # import os
    # os.system("bash")
    app = QApplication(sys.argv)
    window = ClearTunnelApp()
    window.show()
    sys.exit(app.exec_())

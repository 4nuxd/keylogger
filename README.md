# 🔑 Stealth Keylogger 🖥️

This is a PowerShell-based **Keylogger** designed for educational purposes only. The keylogger records keystrokes, collects system information, and sends the log to a specified Telegram bot. It also maintains persistence across reboots and can manage log file size by archiving when necessary.

**Important**: This tool should only be used in ethical hacking and security research environments where permission is granted. Unauthorized use is illegal and unethical.

---

## 🚀 Features

- **Keystroke Logging**: Records every keystroke, including special keys and function keys.
- **System Information Collection**: Logs important system information (CPU, RAM, OS, IP, etc.).
- **Persistence**: Ensures the keylogger automatically starts upon reboot without user intervention.
- **Telegram Integration**: Sends logged data to a Telegram bot for remote monitoring.
- **Log File Management**: Archives logs if the file size exceeds the specified limit (10MB).
- **Stealth Mode**: Operates in the background without showing any CLI prompts or visible windows.

---

## ⚠️ Disclaimer

This tool is intended **only for educational purposes** or **ethical hacking** engagements with explicit permission. **Misuse of this tool may lead to legal consequences**.

---

## 💻 Requirements

- PowerShell (pre-installed on Windows)
- Active internet connection (for Telegram bot integration)

---

## 📦 Installation

### Step 1: Download the Script

1. Download the Script
Clone or download the repository to your local machine.
    ```bash
    git clone https://github.com/4nuxd/keylogger.git
    cd keylogger
    ```

2. Alternatively, download the `keylogger.ps1` file directly.

### Step 2: Run the Script

1. **Bypass Execution Policy (if necessary)**:
    ```powershell
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
    ```

2. **Run the Script**:
    ```powershell
    .\keylogger.ps1
    ```

The script will automatically:
- Set up persistence via the Windows registry (so it runs after a restart).
- Start logging keystrokes in the background.
- Collect system information.
- Send logs to your Telegram bot at regular intervals.

---

## 🔑 Configuration

- **Telegram Bot Integration**: 
    1. Create a Telegram Bot via [BotFather](https://core.telegram.org/bots#botfather).
    2. Get your `botToken` and `chatID` (where logs will be sent).
    3. Update the `botToken` and `chatID` values in the script.

    ```powershell
    $botToken = "your-telegram-bot-token"
    $chatID = "your-chat-id"
    ```

- **Log File Path**: 
    The logs are saved to the `keylog.txt` file located in the `APPDATA` directory.

    - Log path: `$env:APPDATA\keylog.txt`
    - Archived logs will be saved as `keylog_<timestamp>.txt`.

---

## 🛠️ How It Works

1. **Keystroke Logging**: 
   The script listens for keypress events and logs them to a file. Special keys like `ENTER`, `TAB`, `BACKSPACE`, etc., are handled appropriately.

2. **System Information Collection**: 
   Every hour, the script logs the system's CPU, RAM, OS, storage, and IP addresses.

3. **Telegram Integration**: 
   Every 5 minutes, the script sends the current log file to your specified Telegram bot.

4. **Log File Management**: 
   If the log file exceeds 10MB, it is archived and a new log file is created.

5. **Persistence**: 
   The script ensures that it automatically runs every time the system starts, by adding itself to the Windows registry.

---

## ⚙️ Customization

- **Change Log File Size Limit**:
    Modify `$maxLogSize` to change the log file size threshold for archiving:
    ```powershell
    $maxLogSize = 10MB
    ```

- **Change Log Interval**:
    Modify the `Send-ToTelegram` function's interval for sending logs to Telegram.

---

## 📢 Important Notes

- This script **runs in the background** without any visible windows or notifications. It is designed to be stealthy.
- **Use responsibly** and ensure you have **explicit permission** to run this tool on any machine.
- **Legal Disclaimer**: Unauthorized use of this tool for malicious purposes is illegal and unethical.

---

## 🔐 Security and Privacy

The script collects **keystrokes** and **system information**. Ensure that it is used in a **secure environment** and not for **malicious purposes**. Always respect privacy and legal boundaries.

---

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 📞 Contact

- **GitHub**: [Your GitHub Profile](https://github.com/4nuxd)
- **Telegram**: [your.email@example.com](https://t.me/piratexd)

---

## ✨ Acknowledgements

- [Telegram Bot API](https://core.telegram.org/bots)
- [PowerShell Scripting Community](https://github.com/powershell/powershell)

---

🔒 **Stay Ethical, Stay Safe** 🔒

# BrickTools

BrickTools is a collection of tools and system apps for managing and configuring your Trimui Brick device.  
It is meant to be used with Stock firmware or with StockMix/CrossMix.  
It integrates really well with the device theme by using the same assets and fonts.

## Installing

Download the latest release from [here](https://github.com/hugorosario/BrickTools/releases/download/beta3/BrickTools_beta3.zip).  
Extract the zip to the root of your SDCard.

## Menu Options
![Main menu](/Screenshots/MainScreen.png "Main Menu")

### Utilities
![Utilities](/Screenshots/Utilities.png "Utilities")

- **Sort favorites**
  - Sort the favorites list alphabetically.

- **Reboot**
  - Reboot the system.

### Network
![Network](/Screenshots/Network.png "Network")

- **IP Address**
  - Display the current IP address.

- **SFTPGo Server**
  - Manage the SFTPGo server. (Included in the package)

- **SSH Server**
  - Manage the SSH server. (Included in the package)

- **Syncthing**
  - Manage the Syncthing service. (Included in the package)

### User Interface
![User Interface](/Screenshots/UserInterface.png "User Interface")

- **Start Tab**
  - Set the start tab of the UI.
  - Options: `Favorites`, `Recent`, `Best`, `Games`, `Apps`, `Netplay`, `Settings`

- **Top-Left Logo**
  - Enable/Disable the top-left logo.

- **Click sound**
  - Enable/Disable click sound.

- **Background music**
  - Enable/Disable background music.

### LED Control
![LED Control](/Screenshots/LedControl.png "LED Control")

- **LED Mode**
  - Set the LED mode.
  - Options: `Default`, `Battery level`, `CPU speed`, `Temperature`, `Effect`

- **LED effect**
  - Set the LED effect.
  - Options: `Disable`, `Linear`, `Breath`, `Sniff`, `Static`, `Blink 1`, `Blink 2`, `Blink 3`

- **LED effect delay**
  - Set the LED effect delay (seconds).
  - Options: `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`

- **LED effect color**
  - Set the LED effect color.
  - Options: `Red`, `Green`, `Blue`, `Yellow`, `Purple`, `Cyan`, `White`

### System
![System](/Screenshots/System.png "System")

- **Switch F1/F2 buttons**
  - Switch the F1/F2 buttons with Select/Start.

- **Max CPU Frequency**
  - Set the maximum CPU frequency permanently.

## Customization

BrickTools is easy to customize by adding entries to the `menu.json` file.  
You can define new menu options and specify their behavior.  
The following widget types are available:

- **Command**
  - A simple item that triggers an action when pressed.
  - Example: `"type": "cmd"`

- **Toggle**
  - A switch that can be turned on or off.
  - On script execution, the first parameter is the new state of the widget. (0 or 1 which corresponds to "Off" or "On")
  - Example: `"type": "toggle"`

- **Select**
  - Select an item from a list of options.
  - On script execution, the first parameter is the index of the selected item (zero based, so 0 is the first item).
  - Example: `"type": "select"`

- **Menu**
  - Opens a list of sub-items. It can contain any item type and can chain multiple levels.
  - Example: `"type": "menu"`

The default `menu.json` contains many examples of each type of widget.

## Actions and Shell Commands

In BrickTools, actions are triggered by interacting with the menu options defined in the `menu.json` file.  
Each menu option can be configured to execute specific shell commands based on the user's input. Here is how it works:

### Command Execution

When a menu option is selected, the corresponding shell command is executed.  
The type of action determines how the command is executed:

- **Command (`cmd`)**
  - Executes a shell script or command when the item is selected.
  - Example:
    ```json
    {
      "label": "Reboot",
      "description": "Reboot the system",
      "type": "cmd",
      "execute": "./scripts/reboot.sh",
      "output": "line"
    }
    ```

- **Toggle (`toggle`)**
  - Executes a shell script or command to toggle a setting on or off.
  - Example:
    ```json
    {
      "label": "SSH Server",
      "description": "Manage the SSH server",
      "type": "toggle",
      "execute": "./scripts/sshd.sh",
      "output": "line",
      "load": "./scripts/sshd.sh check"
    }
    ```

- **Select (`select`)**
  - Executes a shell script or command to set a value from a list of options.
  - Example:
    ```json
    {
      "label": "LED Mode",
      "description": "Set the LED mode",
      "type": "select",
      "items": ["Default", "Battery level", "CPU speed", "Temperature", "Effect"],
      "execute": "./scripts/ledmode.sh",
      "output": "none",
      "load": "./scripts/ledmode.sh check"
    }
    ```

- **Menu (`menu`)**
  - Opens a submenu with additional options.
  - Example:
    ```json
    {
      "label": "Network",
      "type": "menu",
      "description": "Network related tools and settings",
      "menu": [
        {
          "label": "IP Address",
          "description": "{{ip_address}}",
          "type": "cmd",
          "execute": "./scripts/ip.sh",
          "output": "line",
          "load": "./scripts/ip.sh"
        }
      ]
    }
    ```

### Difference Between `execute` and `load`

- **`execute` Property**
  - The `execute` property specifies the shell script or command that is triggered when the user interacts with the menu item (e.g., clicks on it).
  - This action is performed based on the user's input and can involve any operation such as starting a service, changing a setting, or performing a system action.

- **`load` Property**
  - The `load` property specifies the shell script or command that is executed when the menu item is displayed or when the app decides to update the UI state of the item.
  - This script should execute as fast as possible because it is used to dynamically update the UI with real-time information, such as replacing tags with current values or states.

### Shell Scripts

The shell scripts executed by these actions are located in the `scripts` directory.  
Each script performs a specific task, such as rebooting the system, managing services, or configuring settings.  
The scripts can also provide feedback by outputting information or updating the state of the menu options.

## Special Tags

BrickTools uses special tags enclosed in `{{ }}` to dynamically update the UI with real-time information.  
These tags can be used in the `description` or `label` fields of menu options to display current states, values, or other dynamic content.  
Here is how they work:

### Usage

Special tags are placeholders that get replaced with actual values when the menu is displayed.  
They are particularly useful for showing the current state of a setting or displaying real-time information such as IP addresses or service statuses.

### Examples

- **IP Address**
  - The `{{ip_address}}` tag is used to display the current IP address.
  - Example:
    ```json
    {
      "label": "IP Address",
      "description": "{{ip_address}}",
      "type": "cmd",
      "execute": "./scripts/ip.sh",
      "output": "line",
      "load": "./scripts/ip.sh"
    }
    ```

- **Service Status**
  - The `{{listening}}` tag is used to display the status of a service, such as whether it is running or not.
  - Example:
    ```json
    {
      "label": "SFTPGo Server",
      "description": "{{listening}}",
      "type": "toggle",
      "execute": "./scripts/sftpgo.sh",
      "output": "line",
      "load": "./scripts/sftpgo.sh check"
    }
    ```

- **Toggle State**
  - The `{{state}}` tag is used to display the current state of a toggle option.
  - Example:
    ```json
    {
      "label": "Max CPU Frequency",
      "description": "Set the maximum CPU frequency permanently.",
      "type": "toggle",
      "execute": "./scripts/cpumax.sh",
      "output": "none",
      "load": "./scripts/cpumax.sh check"
    }
    ```

### How It Works

When the `load` script is executed, it can output values in the format `{{tag=value}}`.  
These values are then used to replace the corresponding tags in the menu descriptions.  
This allows the UI to reflect the current state or value dynamically.

### Example Script Output

Here is an example of how a script might output values to update the UI:

```sh
#!/bin/sh

# Example script to check the IP address
IP=$(ip route get 1 2>/dev/null | awk '{print $NF;exit}')
echo "{{ip_address=$IP}}"




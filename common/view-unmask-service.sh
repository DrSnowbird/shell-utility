#!/bin/bash 

# ref: https://unix.stackexchange.com/questions/308904/systemd-how-to-unmask-a-service-whose-unit-file-is-empty
#
sudo systemctl list-unit-files --state=masked

echo "... To disable 'masked' service:"
echo "sudo systemctl unmask your_app.service"
echo "e.g.:"
echo "Step-1.) "
echo "  sudo systemctl unmask nvidia-hibernate.service"
echo "  sudo systemctl unmask nvidia-resume.service"
echo "  sudo systemctl unmask nvidia-suspend.service"
echo "Step-2.) "
echo "  sudo rm /lib/systemd/system/your_app.service"
echo "  e.g."
echo "  sudo rm /lib/systemd/system/nvidia-hibernate.service"
echo "  sudo rm /lib/systemd/system/nvidia-resume.service"
echo "  sudo rm /lib/systemd/system/nvidia-suspend.service"
echo "Step-3.) Reload systemd daemon as you changed a service:"
echo "  sudo systemctl daemon-reload"
echo "Step-4.) Check the status:"
echo "  systemctl status your_app"
echo "  e.g."
echo "  systemctl status nvidia-hibernate.service"
echo "  systemctl status nvidia-resume.service"
echo "  systemctl status nvidia-suspend.service"
echo 

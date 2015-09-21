#!/bin/bash
libfile="/opt/ros/hydro/lib/libgazebo_ros_kobuki.so"
kobukirootfile="/opt/ros/hydro/share/turtlebot_description/robots/kobuki_hexagons_kinect.urdf.xacro"
kobukigazebofile="/opt/ros/hydro/share/kobuki_description/urdf/kobuki_gazebo.urdf.xacro"
kobukifile="/opt/ros/hydro/share/kobuki_description/urdf/kobuki.urdf.xacro"

echo "Patching files begin!!"

 if [ ! -f "${libfile}.old" ]; then
   echo "${libfile} not backed up, back up file with .old extention!"
   sudo cp "${libfile}" "${libfile}.old"
 fi
 sudo cp -f libgazebo_ros_kobuki.so "${libfile}"

 if [ ! -f "${kobukirootfile}.old" ]; then
   echo "${kobukirootfile} not backed up, back up file with .old extention!"
   sudo cp "${kobukirootfile}" "${kobukirootfile}.old"
 fi 
 sudo cp -f kobuki_hexagons_kinect.urdf.xacro "${kobukirootfile}"

 if [ ! -f "${kobukigazebofile}.old" ]; then
   echo "${kobukigazebofile} not backed up, back up file with .old extention!"
   sudo cp "${kobukigazebofile}" "${kobukigazebofile}.old"
 fi 
 sudo cp -f kobuki_gazebo.urdf.xacro "${kobukigazebofile}"

 if [ ! -f "${kobukifile}.old" ]; then
   echo "${kobukifile} not backed up, back up file with .old extention!"
   sudo cp "${kobukifile}" "${kobukifile}.old"
 fi 
 sudo cp -f kobuki.urdf.xacro "${kobukifile}"

echo "Patching end!!"

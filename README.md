# ros_multi_robots
For multi robots simulation

You can simply run patch.sh in patch directory to patch all files instead of doing the following hack job, but ros should be in /opt/ros/hydro/ directory.

# How to hack file
To solve the namespace problem of odom and joint_states, we have to hack into gazebo_ros_kobuki.cpp file of  kobuki_gazebo_plugins and add node name prefix to these topics. The original libgazebo_ros_kobuki.so should be replaced.

Create workspace.<br />
http://wiki.ros.org/catkin/Tutorials/create_a_workspace

Clone source code to the src directory of this workspace.
```Bash
$git clone https://github.com/yujinrobot/kobuki_desktop.git
```
Hack gazebo_ros_kobuki.cpp for topic name problems.
```cpp
Line 141   joint_state_pub_ = nh_.advertise<sensor_msgs::JointState>(node_name_ +"/joint_states", 1);
Line 198   odom_pub_ = nh_.advertise<nav_msgs::Odometry>(node_name_ +"/odom", 1);
Line 386   joint_state_.header.frame_id = node_name_+"/base_link";
Line 397   odom_.header.frame_id = node_name_+"/odom";
Line 398   odom_.child_frame_id = node_name_+"/base_footprint";
```
cd to the workspace root directory, compile.<br />
PS: when compiling the code, it may throw out errors like can not find test suit or something similar, so I just delete the qtestsuit directory.<br />
```Bash
$catkin_make gazebo_ros_kobuki
```
Back up original library.<br />
```Bash
$sudo mv /opt/ros/hydro/lib/libgazebo_ros_kobuki.so /opt/ros/hydro/lib/libgazebo_ros_kobuki.so.old
```
Replace library.<br />
```Bash
$sudo cp ./devel/lib/libgazebo_ros_kobuki.so /opt/ros/hydro/lib/libgazebo_ros_kobuki.so
```
For sensor names, hack xacro files<br />
(1)kobuki_hexagons_kinect.urdf.xacro<br />
```Bash
$sudo vim /opt/ros/hydro/share/turtlebot_description/robots/kobuki_hexagons_kinect.urdf.xacro
```
```xml
Line 11  <kobuki ns="$(arg prefix)"/>
```
(2)kobuki.urdf.xacro<br />
```Bash
$sudo vim /opt/ros/hydro/share/kobuki_description/urdf/kobuki.urdf.xacro
```
```xml
Line 14  <xacro:macro name="kobuki" params="ns"> 
Line 224     <kobuki_sim ns="${ns}"/>
```
(3)kobuki_gazebo.urdf.xacro <br />
```Bash
$sudo vim /opt/ros/hydro/share/kobuki_description/urdf/kobuki_gazebo.urdf.xacro
```
```xml
Line 4  <xacro:macro name="kobuki_sim" params="ns">
Line 44 	    <sensor type="contact" name="${ns}_bumpers">
Line 55	    <sensor type="ray" name="${ns}_cliff_sensor_left">
Line 86	    <sensor type="ray" name="${ns}_cliff_sensor_right">
Line 117 	    <sensor type="ray" name="${ns}_cliff_sensor_front">
Line 148	  <sensor type="imu" name="${ns}_imu">
Line 181-186	      <cliff_sensor_left_name>${ns}_cliff_sensor_left</cliff_sensor_left_name>
	      <cliff_sensor_center_name>${ns}_cliff_sensor_front</cliff_sensor_center_name>
	      <cliff_sensor_right_name>${ns}_cliff_sensor_right</cliff_sensor_right_name>
	      <cliff_detection_threshold>0.04</cliff_detection_threshold>
	      <bumper_name>${ns}_bumpers</bumper_name>
              <imu_name>${ns}_imu</imu_name>
```
(4)need to pass the ns parameter to single robot launch file(agent.launch.xml in this workspace, and it may have already been done) <br />
```xml
Line 13  <arg name="urdf_file" default="$(find xacro)/xacro.py '$(find turtlebot_description)/robots/$(arg base)_$(arg stacks)_$(arg 3d_sensor).urdf.xacro' prefix:=$(arg robot_name)" />
```

#How to run
First build the project in workspace root directory.<br />
```Bash
catkin_make
```
Then source setup file.<br />
```Bash
source ./devel/setup.bash
```
Finally launch simulation.<br />
```Bash
roslaunch agents_gazebo agents_gazebo.launch
```
This will first launch the gazebo simulator with gui, then launch the rviz gui.<br />

#How to control the robots
The following command can be used to control robot0, you can change keyop0.launch to keyop1.launch to control robot1. It is not a good way, but it works well.<br />
```Bash
roslaunch keyop keyop0.launch
```
Robots may drift in rviz and that is normal because localization if not 100% accurate.<br />

#PS
set_param and hector_laserscan_to_pointcloud packages are used for my work, you do not need those packages. And I am a freshman to ROS, so there may still be some errors or mistakes, I will try my best to help you with this simulation you can contact me by applyhhj@163.com. Hope this can help you!


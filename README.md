# ros_multi_robots
For multi robots simulation

You can simply run patch.sh in patch directory to patch all files instead of doing the following hack job, but ros should be in /opt/ros/hydro/ directory.

# How to hack file
To solve the namespace problem of odom and joint_states, we have to hack into gazebo_ros_kobuki.cpp file of  kobuki_gazebo_plugins and add node name prefix to these topics. The original libgazebo_ros_kobuki.so should be replaced.

1. create workspace<br />
http://wiki.ros.org/catkin/Tutorials/create_a_workspace

2. clone source code to the src directory of this workspace
```Bash
$git clone https://github.com/yujinrobot/kobuki_desktop.git
```
3. hack gazebo_ros_kobuki.cpp for topic name problems<br />
Line 141   joint_state_pub_ = nh_.advertise<sensor_msgs::JointState>(node_name_ +"/joint_states", 1);<br />
Line 198   odom_pub_ = nh_.advertise<nav_msgs::Odometry>(node_name_ +"/odom", 1);<br />
Line 386   joint_state_.header.frame_id = node_name_+"/base_link";<br />
Line 397   odom_.header.frame_id = node_name_+"/odom";<br />
Line 398   odom_.child_frame_id = node_name_+"/base_footprint";<br />

4. cd to the workspace root directory, compile<br />
ps: when compile the code it may throw out errors like can not find test suit or some, So I just delete the qtestsuit directory<br />
```Bash
$catkin_make gazebo_ros_kobuki
```
5. back up original library<br />
```Bash
$sudo mv /opt/ros/hydro/lib/libgazebo_ros_kobuki.so /opt/ros/hydro/lib/libgazebo_ros_kobuki.so.old
```
6. replace library<br />
```Bash
$sudo cp ./devel/lib/libgazebo_ros_kobuki.so /opt/ros/hydro/lib/libgazebo_ros_kobuki.so
```
7. For sensor names, hack xacro files<br />
(1)kobuki_hexagons_kinect.urdf.xacro<br />
```Bash
$sudo vim /opt/ros/hydro/share/turtlebot_description/robots/kobuki_hexagons_kinect.urdf.xacro
```
```xml
Line 11  <kobuki ns="$(arg prefix)"/>
```
(2)kobuki.urdf.xacro<br />
$sudo vim /opt/ros/hydro/share/kobuki_description/urdf/kobuki.urdf.xacro<br />
Line 14  <xacro:macro name="kobuki" params="ns"> <br />
Line 224     <kobuki_sim ns="${ns}"/><br />
(3)kobuki_gazebo.urdf.xacro <br />
$sudo vim /opt/ros/hydro/share/kobuki_description/urdf/kobuki_gazebo.urdf.xacro
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

(4)single robot launch file(agent.launch.xml in this workspace, and it may have already been done) need to pass the ns parameter
Line 13  <arg name="urdf_file" default="$(find xacro)/xacro.py '$(find turtlebot_description)/robots/$(arg base)_$(arg stacks)_$(arg 3d_sensor).urdf.xacro' prefix:=$(arg robot_name)" />


#How to run
1. First build the project in multi_robot_sim directory
catkin_make

2. Then source setup file
source ./devel/setup.bash

3. Finally launch simulation
roslaunch agents_gazebo agents_gazebo.launch

This will first launch the gazebo simulator with gui, then launch the rviz gui.

#How to control the robots
The following command can be used to control robot0, you can change keyop0.launch to keyop1.launch to control robot1. It is not a good way, but it works well.
roslaunch keyop keyop0.launch

Robots may drift in rviz and that is normal because localization if not 100% accurate.

#ps
set_param and hector_laserscan_to_pointcloud packages are used for my work, you do not need those packages. And I am a freshman to ROS, so there may still be some errors or mistakes, I will try my best to help you with this simulation you can contact me by applyhhj@163.com. Hope this can help you!


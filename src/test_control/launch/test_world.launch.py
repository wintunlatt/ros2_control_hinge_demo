from launch import LaunchDescription
from launch.actions import ExecuteProcess, SetEnvironmentVariable, TimerAction
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import os

def generate_launch_description():
    pkg_share = get_package_share_directory('test_control')
    urdf_path = os.path.join(pkg_share, 'urdf', 'test.urdf')

    # Read URDF file contents so robot_state_publisher has robot_description
    with open(urdf_path, 'r') as f:
        urdf_content = f.read()

    return LaunchDescription([
        # Make sure Gazebo can find ROS 2 control plugin
        SetEnvironmentVariable(
            name='GAZEBO_PLUGIN_PATH',
            value=os.environ.get('GAZEBO_PLUGIN_PATH', '') + ':/opt/ros/humble/lib'
        ),

        # 1) Start robot_state_publisher with robot_description (before spawning)
        Node(
            package='robot_state_publisher',
            executable='robot_state_publisher',
            parameters=[{'robot_description': urdf_content}],
            output='screen'
        ),

        # 2) Start Gazebo
        ExecuteProcess(
            cmd=['gzserver', '--verbose', '/usr/share/gazebo-11/worlds/empty.world', '-s', 'libgazebo_ros_factory.so'],
            output='screen'
        ),
        ExecuteProcess(
            cmd=['gzclient'],
            output='screen'
        ),

        # 3) Spawn the entity after Gazebo is up (short delay)
        TimerAction(
            period=2.0,
            actions=[
                Node(
                    package='gazebo_ros',
                    executable='spawn_entity.py',
                    arguments=['-file', urdf_path, '-entity', 'test_robot'],
                    output='screen'
                )
            ]
        ),

        # 4) Spawn controllers after the model + plugin initialize (another small delay)
        TimerAction(
            period=5.0,
            actions=[
                Node(
                    package='controller_manager',
                    executable='spawner',
                    arguments=['joint_state_broadcaster'],
                    output='screen'
                )
            ]
        ),
        TimerAction(
            period=6.0,
            actions=[
                Node(
                    package='controller_manager',
                    executable='spawner',
                    arguments=['hinge_position_controller'],
                    output='screen'
                )
            ]
        ),
    ])

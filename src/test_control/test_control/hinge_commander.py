import rclpy
from rclpy.node import Node
from std_msgs.msg import Float64MultiArray
import math
import time

class HingeCommander(Node):
    def __init__(self):
        super().__init__('hinge_commander')
        self.topic = '/hinge_position_controller/commands'
        self.publisher_ = self.create_publisher(Float64MultiArray, self.topic, 10)

        # Wait for subscribers (controller)
        self.timer_once = self.create_timer(0.2, self._wait_for_sub)
        self.pub_timer = None
        self.start_time = time.time()

    def _wait_for_sub(self):
        if self.publisher_.get_subscription_count() > 0:
            self.get_logger().info(f'Found subscriber on {self.topic}, starting publishing...')
            self.timer_once.cancel()
            self.pub_timer = self.create_timer(0.1, self.timer_callback)
        else:
            self.get_logger().info('Waiting for controller subscriber...')

    def timer_callback(self):
        msg = Float64MultiArray()
        elapsed = time.time() - self.start_time
        msg.data = [0.8 * math.sin(0.5 * elapsed)]
        self.publisher_.publish(msg)
        self.get_logger().info(f'Publishing: {msg.data}')

def main(args=None):
    rclpy.init(args=args)
    node = HingeCommander()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()

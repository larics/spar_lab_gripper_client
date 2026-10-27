#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from std_srvs.srv import Trigger
from spar_lab_gripper_client.srv import GripperState

STATE_NAMES = {0: 'Open', 1: 'Close'}

class MockGripperServer(Node):
    def __init__(self):
        super().__init__('mock_gripper_server')

        self.create_service(GripperState, 'gripper/record_state', self.record_state)
        self.create_service(GripperState, 'gripper/goto_state', self.goto_state)
        self.create_service(Trigger, 'gripper/clear_states', self.clear_states)
        self.create_service(Trigger, 'gripper/switch_mode', self.switch_mode)

        self.get_logger().info("Mock server ready.")

    def record_state(self, request, response):
        name = STATE_NAMES.get(request.command, 'UNKNOWN')
        self.get_logger().info(f"Got RECORD request: command={request.command} ({name})")
        response.success = True
        response.message = f"Mock: recorded {name}"
        return response

    def goto_state(self, request, response):
        name = STATE_NAMES.get(request.command, 'UNKNOWN')
        self.get_logger().info(f"Got GOTO request: command={request.command} ({name})")
        response.success = True
        response.message = f"Mock: went to {name}"
        return response

    def clear_states(self, request, response):
        self.get_logger().info("Got CLEAR STATES request")
        response.success = True
        response.message = "Mock: cleared states"
        return response

    def switch_mode(self, request, response):
        self.get_logger().info("Got SWITCH MODE request")
        response.success = True
        response.message = "Mock: switched mode"
        return response

def main():
    rclpy.init()
    node = MockGripperServer()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    node.destroy_node()
    if rclpy.ok():
        rclpy.shutdown()


if __name__ == '__main__':
    main()
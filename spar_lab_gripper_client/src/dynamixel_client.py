#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from std_srvs.srv import Trigger
from spar_lab_gripper_client.srv import GripperState

STATE_NAMES = {0: 'Open', 1: 'Close'}

class KeyboardClient(Node):
    def __init__(self):
        super().__init__('keyboard_state_client')

        self.record_client = self.create_client(GripperState, f'gripper/record_state')
        self.goto_client = self.create_client(GripperState, f'gripper/goto_state')
        self.clear_client = self.create_client(Trigger, f'gripper/clear_states')
        self.switch_client = self.create_client(Trigger, f'gripper/switch_mode')

    # ------------------------------------------------------------------ service calls

    # TODO: implement the following service calls:
    # def call_switch(self, request)
    # def call_record(self, request)
    # def call_goto(self, request)
    # def call_clear(self, request)

    # ------------------------------------------------------------------ keyboard handler

    def handle_key(self, key):
        """Returns False to quit."""
        if key == 'm':
            request = Trigger.Request()
            self.call_switch(request)
        elif key == 'O':
            request = GripperState.Request()
            request.command = 0
            self.call_record(request)
        elif key == 'C':
            request = GripperState.Request()
            request.command = 1
            self.call_record(request)
        elif key == 'o':
            request = GripperState.Request()
            request.command = 0
            self.call_goto(request)
        elif key == 'c':
            request = GripperState.Request()
            request.command = 1
            self.call_goto(request)
        elif key == 'x':
            request = Trigger.Request()
            self.call_clear(request)
        elif key in ('q', 'Q'):
            return False
        return True


def main(args=None):
    rclpy.init(args=args)
    node = KeyboardClient()
    try:
        running = True
        while running and rclpy.ok():
            key = input("Enter next key command [O/C/o/c/m/x/q]: ")
            if not node.handle_key(key):
                running = False
                break
            rclpy.spin_once(node, timeout_sec=0.0)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        if rclpy.ok():
            rclpy.shutdown()

if __name__ == '__main__':
    main()
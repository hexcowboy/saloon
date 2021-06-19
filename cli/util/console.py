from rich.console import Console as RichConsole


class Console(RichConsole):
    """Wrapper around a Rich console"""

    def __init__(self):
        self.console = super().__init__()

    def print_status(self, text, color="green"):
        """Prints Saloon docker status in a uniform manner"""
        self.print(f"[bold {color}][+] [default]" + text)

    def success(self, text, color="green"):
        """Prints Saloon docker status in a uniform manner"""
        self.print(f"[bold {color}]✔ [default]" + text)

    def failure(self, text, color="red"):
        """Prints Saloon docker status in a uniform manner"""
        self.print(f"[bold {color}]✘ [default]" + text)

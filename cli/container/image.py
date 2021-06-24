class DockerImage:
    """Defines the properties of a Docker image"""

    def __init__(self, image, tag, local_name=None):
        """Set a tag and provide defaults"""
        self.name = image
        self.tag = tag
        self.local_name = local_name or str(self)

    def __repr__(self):
        return f"{self.name}:{self.tag}"

    def __str__(self):
        return f"{self.name}:{self.tag}"

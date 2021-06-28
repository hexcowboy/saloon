class DockerImage:
    """Defines the properties of a Docker image"""

    def __init__(self, image, tag):
        """Set a tag and provide defaults"""
        self.name = image
        self.tag = tag

    def get_object(self, client):
        try:
            return client.images.get(str(self))
        except:
            return None

    def __repr__(self):
        return f"{self.name}:{self.tag}"

    def __str__(self):
        return f"{self.name}:{self.tag}"

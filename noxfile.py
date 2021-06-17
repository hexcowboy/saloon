import nox


@nox.session
def format(session):
    session.install("isort", "black")
    session.run("isort", "--profile", "black", ".")
    session.run("black", ".")

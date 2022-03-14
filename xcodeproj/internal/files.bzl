"""Functions for processing `File`s."""

def file_path(file):
    """Converts a `File` into a `FilePath` Swift DTO value.

    Args:
        file: A `File`.

    Returns:
        A `FilePath` Swift DTO value, which is either a string or a `struct`
        containing the following fields:

        *   `_`: The file path.
        *   `t`: Maps to `FilePath.FileType`:
            *   "p" for `.project`
            *   "e" for `.external`
            *   "g" for `.generated`
            *   "i" for `.internal`
    """
    path = file.path
    if file.owner.workspace_name:
        return external_file_path(path)
    if not file.is_source:
        return generated_file_path(path)
    return path

def external_file_path(path):
    return struct(
        # Type: "e" == `.external`
        t = "e",
        # Path, removing `external/` prefix
        _ = path[9:],
    )

def generated_file_path(path):
    return struct(
        # Type: "g" == `.generated`
        t = "g",
        # Path, removing `bazel-out/` prefix
        _ = path[10:],
    )

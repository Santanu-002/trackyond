import os


BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def resolve_download_path(file_path: str):
    clean_path = file_path.lstrip("/")
    abs_path = os.path.realpath(os.path.join(BASE_DIR, clean_path))

    if not abs_path.startswith(os.path.realpath(BASE_DIR) + os.sep):
        return None, 403, "Access denied"

    if not os.path.exists(abs_path) or not os.path.isfile(abs_path):
        return None, 404, f"File not found: {clean_path}"

    return abs_path, None, None

from fastapi import APIRouter, HTTPException
from fastapi.responses import FileResponse
import os

router = APIRouter(prefix="/files", tags=["Common/Files"])

# Absolute path to the app root — all file paths are resolved relative to this.
# Inside Docker the WORKDIR is /app, so this resolves to /app.
BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

@router.get("/download/{file_path:path}")
async def download_file(file_path: str):
    """
    Generic endpoint to download any file by its path.
    Example: /api/v1/common/files/download/uploads/comp_A/user_3/avatar.jpg
    """
    # Strip any leading slash
    clean_path = file_path.lstrip("/")

    # Resolve to an absolute path anchored at BASE_DIR
    abs_path = os.path.realpath(os.path.join(BASE_DIR, clean_path))

    # Path-traversal guard: ensure the resolved path stays within BASE_DIR
    if not abs_path.startswith(os.path.realpath(BASE_DIR) + os.sep):
        raise HTTPException(status_code=403, detail="Access denied")

    if not os.path.exists(abs_path) or not os.path.isfile(abs_path):
        raise HTTPException(status_code=404, detail=f"File not found: {clean_path}")

    return FileResponse(abs_path)
